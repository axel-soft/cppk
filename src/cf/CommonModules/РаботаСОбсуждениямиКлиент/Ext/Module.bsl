﻿////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с форумом.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создает новую тему.
//
Процедура СоздатьНовуюТему() Экспорт
	
	ОткрытьФорму("Справочник.СообщенияОбсуждений.ФормаОбъекта");
	
КонецПроцедуры

// Формирует список раскрытых элементов дерева.
//
// Параметры:
//  ДеревоЭлемент - ТаблицаФормы - Элемент формы, отображающий дерево.
//  МассивСтрокОдногоУровня - Массив - Массив элементов одного уровня.
//  СписокПомеченныхЭлементов - СписокЗначений - Список, который содержит помеченные элементы дерева.
//
Процедура ПолучитьМассивРаскрытыхСообщений(ДеревоЭлемент,
	МассивСтрокОдногоУровня, СписокРаскрытыхСообщений) Экспорт
	
	Для Каждого СтрокаОдногоУровня Из МассивСтрокОдногоУровня Цикл
		ИдСообщения = СтрокаОдногоУровня.ПолучитьИдентификатор();
		Если ДеревоЭлемент.Развернут(ИдСообщения) <> Неопределено 
			И ДеревоЭлемент.Развернут(ИдСообщения) Тогда
			СписокРаскрытыхСообщений.Добавить(СтрокаОдногоУровня.Ссылка);
			ПолучитьМассивРаскрытыхСообщений(ДеревоЭлемент,
				СтрокаОдногоУровня.ПолучитьЭлементы(), СписокРаскрытыхСообщений);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Формирует список помеченных элементов дерева.
//
// Параметры:
//  ДеревоЭлемент - ТаблицаФормы - Элемент формы, отображающий дерево.
//  МассивСтрокОдногоУровня - Массив - Массив элементов одного уровня.
//  СписокПомеченныхЭлементов - СписокЗначений - Список, который содержит помеченные элементы дерева.
//  Пометка - Строка - Имя свойства элемента дерева, содержащее значение пометки.
//
Процедура ПолучитьМассивПомеченныхЭлементов(ДеревоЭлемент,
	МассивСтрокОдногоУровня, СписокПомеченныхЭлементов, Пометка) Экспорт
	
	Для Каждого СтрокаОдногоУровня Из МассивСтрокОдногоУровня Цикл
		ИдСообщения = СтрокаОдногоУровня.ПолучитьИдентификатор();
		ЭлементДерева = ДеревоЭлемент.ДанныеСтроки(ИдСообщения);
		Если ЭлементДерева[Пометка] Тогда
			СписокПомеченныхЭлементов.Добавить(СтрокаОдногоУровня.Ссылка);
		КонецЕсли;
		ПолучитьМассивПомеченныхЭлементов(ДеревоЭлемент,
			СтрокаОдногоУровня.ПолучитьЭлементы(), СписокПомеченныхЭлементов, Пометка);
	КонецЦикла;
	
КонецПроцедуры

// Раскрывает указанные элементы дерева сообщений
// Параметры:
//			ДеревоЭлемент - элемент формы, отображающий дерево сообщений.
//			ДеревоРеквизит - реквизит формы типа ДеревоЗначений, содержащий дерево сообщений.
//			СписокСообщенийДляРазвертывания - список сообщений, которые необходимо развернуть в дереве сообщений.
Процедура УстановитьРазвернутостьЭлементовДерева(ДеревоЭлемент, ДеревоРеквизит, СписокСообщенийДляРазвертывания) Экспорт
	
	Если СписокСообщенийДляРазвертывания <> Неопределено Тогда
		Для Каждого ЭлементСписка Из СписокСообщенийДляРазвертывания Цикл
			Индекс = -1;
			РаботаСОбсуждениямиКлиентСервер.НайтиСообщениеВДеревеПоСсылке(ДеревоРеквизит.ПолучитьЭлементы(), ЭлементСписка.Значение, Индекс);
			Если Индекс > -1 Тогда
				Если ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьЭлементы().Количество() > 0 Тогда
					ДеревоЭлемент.Развернуть(ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьИдентификатор(), Ложь);
				Иначе
					Если ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьРодителя() <> Неопределено Тогда
						ДеревоЭлемент.Развернуть(ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьРодителя().ПолучитьИдентификатор(), Ложь);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает в дереве сообщений текущую строку
// Параметры:
//			ДеревоЭлемент - элемент формы, отображающий дерево сообщений.
//			ДеревоРеквизит - реквизит формы типа ДеревоЗначений, содержащий дерево сообщений.
//			ТекущееСообщение - задача, которую необходимо выделить в дереве сообщений.
Процедура УстановитьТекущееСообщениеВДеревеПоСсылке(ДеревоЭлемент, ДеревоРеквизит, ТекущееСообщение) Экспорт
	
	Если ТекущееСообщение <> Неопределено И
		НЕ ТекущееСообщение.Пустая() Тогда
		Индекс = -1;
		РаботаСОбсуждениямиКлиентСервер.НайтиСообщениеВДеревеПоСсылке(ДеревоРеквизит.ПолучитьЭлементы(), ТекущееСообщение, Индекс);
		Если Индекс > -1 Тогда
			ДеревоЭлемент.ТекущаяСтрока = Индекс;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Функция выполняет изменение пометки прочтения элементов дерева на клиенте, без обновления всего дерева.
//
// Параметры:
//  ДеревоЭлемент - ТаблицаФормы - Таблица формы, содержащая дерево сообщений форума.
//  ДеревоРеквизит - ДанныеФормыДерево - Реквизит формы, содержащий дерево сообщений форума.
//  РежимОтображенияДеревом - Булево - Признак отображения сообщений формы в режиме дерева.
//  ПрочтенныеОбъекты - Массив, СправочникСсылка.СообщенияОбсуждений - Прочтенное сообщений или массив сообщений.
//                      Если был прочтен объект, отличный от сообщений обсуждений - функция вернет Ложь.
//
// Возвращаемое значение:
//  Булево - Признак того, было ли обновлено прочтение элементов.
//
Функция ОбновитьПрочтенностьЭлементовДерева(ДеревоЭлемент, ДеревоРеквизит, РежимОтображенияДеревом, ПрочтенныеОбъекты) Экспорт
	
	Если Не РежимОтображенияДеревом Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(ПрочтенныеОбъекты) = Тип("Массив") Тогда
		МассивПрочтенныеОбъекты = ПрочтенныеОбъекты;
	ИначеЕсли ТипЗнч(ПрочтенныеОбъекты) = Тип("СправочникСсылка.СообщенияОбсуждений") Тогда
		МассивПрочтенныеОбъекты = Новый Массив;
		МассивПрочтенныеОбъекты.Добавить(ПрочтенныеОбъекты);
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	ЗначениеПометкиПрочтения = Ложь;
	СтрокиОбъектов = Новый Массив;
	ПолучитьМассивСообщенийВДереве(ДеревоРеквизит.ПолучитьЭлементы(),
		МассивПрочтенныеОбъекты, СтрокиОбъектов, ЗначениеПометкиПрочтения);
	
	Если СтрокиОбъектов.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для каждого СтрокаОбъекта Из СтрокиОбъектов Цикл
		СтрокаОбъекта.Прочтен = ЗначениеПометкиПрочтения;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Копирует переданную тему.
//
// Параметры:
//  Тема - СправочникСсылка.ТемыОбсуждений - Тема, которую необходимо скопировать.
//
Процедура СкопироватьТему(Тема) Экспорт
	
	ПараметрыФормы = Новый Структура("Основание");
	ПараметрыФормы.Основание = Тема;
	
	ОткрытьФорму("Справочник.СообщенияОбсуждений.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

// Меняет раздел для массива тем форума на новый.
//
// Параметры:
//  МассивТем - Массив - Темы форума, у которых необходимо изменить раздел.
//  НовыйРаздел - СправочникСсылка.ПапкиФорума - Новый раздел форума.
//
Процедура ИзменитьРазделТем(МассивТем, НовыйРаздел) Экспорт
	
	// Не указан новый раздел
	Если Не ЗначениеЗаполнено(НовыйРаздел) Тогда
		Возврат;
	КонецЕсли;
	
	// Нет элементов в массиве
	Если МассивТем.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если РаботаСОбсуждениямиВызовСервера.ИзменитьРазделТем(МассивТем, НовыйРаздел) Тогда
		
		Если МассивТем.Количество() = 1 Тогда
			
			ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Тема ""%1"" перенесена в раздел ""%2""'"), МассивТем[0], НовыйРаздел);
			
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Тема перенесена.'"),
				ПолучитьНавигационнуюСсылку(МассивТем[0]),
				ПолноеОписание,
				БиблиотекаКартинок.Информация32);
			
		Иначе
			
			ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Темы (%1 шт.) перенесены в раздел ""%2""'"), МассивТем.Количество(), НовыйРаздел);
			
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Темы перенесены.'"),
				,
				ПолноеОписание,
				БиблиотекаКартинок.Информация32);
			
		КонецЕсли;
		
		Оповестить("Изменение_ТемыОбсуждений");
		
	КонецЕсли;
	
КонецПроцедуры

// Помечает раздел форума на удаление.
//
// Параметры:
//  ПапкаФорума		 - СправочникСсылка.ПапкиФорума	 - ПапкаФорума, которую помечаем на удаление.
//  ПометкаУдаления	 - Булево						 - Текущее значение пометки удаления раздела.
//
Процедура УстановитьПометкуУдаленияПапкиФорума(ПапкаФорума, ПометкаУдаления) Экспорт
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ПапкаФорума", ПапкаФорума);
	ПараметрыОповещения.Вставить("ПометкаУдаления", ПометкаУдаления);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"УстановитьПометкуУдаленияПапкиФорумаПродолжение", ЭтотОбъект, ПараметрыОповещения);

	Если НЕ ПометкаУдаления Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пометить ""%1"" на удаление?'"),
			ПапкаФорума);
	Иначе
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Снять с ""%1"" пометку удаления?'"),
			ПапкаФорума);
	КонецЕсли;
	
	ОбщегоНазначенияДокументооборотКлиент.ПоказатьВопросДаНет(
		ОписаниеОповещения, ТекстВопроса, , , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

// Голосует за выбранный вариант от имени текущего пользователя.
//
// Параметры:
//  Сообщение - СправочникСсылка.СообщенияОбсуждений - Сообщение, по которому открыто голосование.
//  ВариантОтвета - Число - Вариант ответа.
//
Процедура Проголосовать(Сообщение, ВариантОтвета) Экспорт
	
	Если Не ЗначениеЗаполнено(Сообщение) Тогда
		Текст = НСтр("ru = 'Не указано сообщение для голосования.'");
		ПоказатьПредупреждение(, Текст);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВариантОтвета) Тогда
		Текст = НСтр("ru = 'Не указан вариант голосования.'");
		ПоказатьПредупреждение(, Текст);
		Возврат;
	КонецЕсли;
	
	РаботаСОбсуждениямиВызовСервера.Проголосовать(Сообщение, ВариантОтвета);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Голосование выполнено успешно.'"),
		ПолучитьНавигационнуюСсылку(Сообщение),
		СтрШаблон(НСтр("ru = 'Вы проголосовали за вариант %1.'"), ВариантОтвета),
		БиблиотекаКартинок.Информация32);
	
	Оповестить("ВыполненоГолосование", Сообщение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. УстановитьПометкуУдаленияПапкиФорума.
//
Процедура УстановитьПометкуУдаленияПапкиФорумаПродолжение(Результат, Параметры) Экспорт

	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСОбсуждениямиВызовСервера.УстановитьПометкуУдаленияПапкиФорума(Параметры.ПапкаФорума, Не Параметры.ПометкаУдаления);
	Оповестить("Изменение_ПапкиФорума", Параметры.ПапкаФорума);
	
КонецПроцедуры

Процедура ПолучитьМассивСообщенийВДереве(МассивСтрокОдногоУровня,
	СписокОбъектов, СтрокиОбъектов, ЕстьНепрочтенные)
	
	Для Каждого СтрокаОдногоУровня Из МассивСтрокОдногоУровня Цикл
		Если СписокОбъектов.Найти(СтрокаОдногоУровня.Ссылка) <> Неопределено Тогда
			СтрокиОбъектов.Добавить(СтрокаОдногоУровня);
			ЕстьНепрочтенные = ЕстьНепрочтенные Или Не СтрокаОдногоУровня.Прочтен;
		КонецЕсли;
		ПолучитьМассивСообщенийВДереве(СтрокаОдногоУровня.ПолучитьЭлементы(),
			СписокОбъектов, СтрокиОбъектов, ЕстьНепрочтенные);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти