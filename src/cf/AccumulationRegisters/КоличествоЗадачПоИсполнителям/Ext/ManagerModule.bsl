﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует пустую структуру данных итогов.
// 
// Возвращаемое значение:
//  Структура - Новые данные итогов:
//   * ВРаботе - Число.
//   * Всего - Число.
//   * ВСрок - Число.
//   * Выполненных - Число.
//   * Истекающих - Число.
//   * Новых - Число.
//   * ОжидающихВыполнения - Число.
//   * ОжидающихПроверки - Число.
//   * ПоступилиОбновления - Число.
//   * Просроченных - Число.
// 
Функция НовыеДанныеИтогов() Экспорт
	
	ДанныеИтогов = Новый Структура;
	ДанныеИтогов.Вставить("ВРаботе", 0);
	ДанныеИтогов.Вставить("Всего", 0);
	ДанныеИтогов.Вставить("ВСрок", 0);
	ДанныеИтогов.Вставить("Выполненных", 0);
	ДанныеИтогов.Вставить("Истекающих", 0);
	ДанныеИтогов.Вставить("Новых", 0);
	ДанныеИтогов.Вставить("ОжидающихВыполнения", 0);
	ДанныеИтогов.Вставить("ОжидающихПроверки", 0);
	ДанныеИтогов.Вставить("ПоступилиОбновления", 0);
	ДанныеИтогов.Вставить("Просроченных", 0);
	
	Возврат ДанныеИтогов;
	
КонецФункции

// Обновляет записи по задаче.
// 
// Параметры:
//  Задача - ДокументСсылка.Задача.
// 
Процедура ОбновитьПоЗадаче(Задача) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИнформационнаяБазаФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ТаблицаАктивныеДействия = Документы.ДействиеЗадачи.АктивныеДействияПоЗадаче(Задача);
	Для Каждого ДанныеДействия Из ТаблицаАктивныеДействия Цикл
		Если ИнформационнаяБазаФайловая Тогда
			//@skip-check query-in-loop
			ОбновитьПоДействиюЗадачи(ДанныеДействия.ДействиеЗадачи);
		Иначе
			РегистрыСведений.ОчередьОбновленияКэширующихДанных.Добавить(
				"РегистрНакопления.КоличествоЗадачПоИсполнителям",
				"Документ.ДействиеЗадачи",
				ДанныеДействия.ДействиеЗадачи);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Обновляет записи по действию задачи.
// 
// Параметры:
//  ДействиеЗадачи - ДокументСсылка.ДействиеЗадачи.
//  КэшДанных - Структура,
//              Неопределено.
// 
Процедура ОбновитьПоДействиюЗадачи(ДействиеЗадачи, КэшДанных = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Документ.ДействиеЗадачи");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ДействиеЗадачи);
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.КоличествоЗадачПоИсполнителям.НаборЗаписей");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Регистратор", ДействиеЗадачи);
		Блокировка.Заблокировать();
		
		РеестрыЗадачи = Справочники.РеестрыЗадач.РеестрыДействияЗадачи(ДействиеЗадачи, КэшДанных);
		
		ВостребованныеРеестры = Новый Соответствие;
		Для Каждого РеестрЗадачи Из РеестрыЗадачи Цикл
			ВостребованныеРеестры.Вставить(РеестрЗадачи, Истина);
		КонецЦикла;
		
		Если РеестрыЗадачи.Количество() > 0 Тогда
			ДанныеРеестра = ДанныеРеестра(ДействиеЗадачи, КэшДанных);
		Иначе
			ДанныеРеестра = НовыеДанныеРеестра();
		КонецЕсли;
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(ДействиеЗадачи);
		
		НаборЗаписей.Прочитать();
		
		СтарыеСтрокиРеестров = Новый Соответствие;
		Для Каждого СтараяЗапись Из НаборЗаписей Цикл
			СтарыеСтрокиРеестров[СтараяЗапись.РеестрЗадач] = СтараяЗапись;
		КонецЦикла;
		
		// Добавим новые и обновим существующие записи.
		Для Каждого РеестрЗадачи Из РеестрыЗадачи Цикл
			
			СтараяСтрокаРеестра = СтарыеСтрокиРеестров[РеестрЗадачи];
			ЭтоНовыйРеестр = СтараяСтрокаРеестра = Неопределено;
			Если ЭтоНовыйРеестр Тогда
				
				НоваяЗапись = НаборЗаписей.Добавить();
				НоваяЗапись.РеестрЗадач = РеестрЗадачи;
				ЗаполнитьЗначенияСвойств(НоваяЗапись, ДанныеРеестра);
				
			Иначе
				
				ЗаполнитьЗначенияСвойств(СтараяСтрокаРеестра, ДанныеРеестра);
				
			КонецЕсли;
			
		КонецЦикла;
		
		// Удалим невостребованные записи.
		КоличествоЭлементов = НаборЗаписей.Количество();
		Для Индекс = 1 По КоличествоЭлементов Цикл
			
			СтараяСтрокаРеестра = НаборЗаписей[КоличествоЭлементов - Индекс];
			
			ЭтоВостребованныйРеестр =
				ВостребованныеРеестры[СтараяСтрокаРеестра.РеестрЗадач] = Истина;
			ЭтоАктуальнаяДатаРеестра =
				СтараяСтрокаРеестра.Период = ДанныеРеестра.Период;
			
			Если ЭтоВостребованныйРеестр И ЭтоАктуальнаяДатаРеестра Тогда
				Продолжить;
			КонецЕсли;
			
			НаборЗаписей.Удалить(СтараяСтрокаРеестра);
			
		КонецЦикла;
		
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Рассчитывает итоги.
//
// Параметры:
//  ПараметрыОтбора - См. НовыеПараметрыОтбора.
// 
// Возвращаемое значение:
//  См. НовыеДанныеИтогов.
//
Функция ЗадачиРеестраИтоги(ПараметрыОтбора) Экспорт
	
	Если ПараметрыОтбора.РеестрЗадач = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не указан реестр задач.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗадачиРеестраИтоги = НовыеДанныеИтогов();
	
	Отбор = Отбор(ПараметрыОтбора);
	
	Измерения = "РеестрЗадач";
	
	Остатки = Остатки(, Отбор, Измерения);
	
	Если Остатки.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(ЗадачиРеестраИтоги, Остатки[0]);
	КонецЕсли;
	
	Возврат ЗадачиРеестраИтоги;
	
КонецФункции

// Рассчитывает итоги по измерениям.
//
// Параметры:
//  ПараметрыОтбора - См. НовыеПараметрыОтбора.
//  Измерения - Строка.
// 
// Возвращаемое значение:
//  ТаблицаЗначений.
//
Функция ЗадачиРеестраИтогиПоИзмерениям(ПараметрыОтбора, Измерения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Отбор = Отбор(ПараметрыОтбора);
	
	ЗадачиРеестраИтогиПоИзмерениям = Остатки(, Отбор, Измерения);
	
	Возврат ЗадачиРеестраИтогиПоИзмерениям;
	
КонецФункции

// Определяет кэшируемые в данном регистре реквизиты действий задач.
//
// Возвращаемое значение:
//  Строка - Кэшируемые в данном регистре реквизиты действий задач.
//
Функция КэшируемыеРеквизитыДействий() Экспорт
	
	Возврат "ВидДействия, Дата, ДатаНачала, ДатаВыполнения, ЕстьОсобыйСрок, Задача, Исполнитель,
		|ОсобыйАвтор, ОсобыйСрок, Проведен, СостояниеУчастникаЗадачи, Флаг, ПометкаУдаления";
	
КонецФункции

// Определяет кэшируемые в данном регистре реквизиты задач.
//
// Возвращаемое значение:
//  Строка - Кэшируемые в данном регистре реквизиты задач.
//
Функция КэшируемыеРеквизитыЗадач() Экспорт
	
	Возврат "Автор, Проект, ВидЗадачи, ДатаОтмены, ВидПриложения, Срок, ТипПриложения, ДатаНачалаПлан";
	
КонецФункции

// Формирует структуру параметров отбора данных регистра.
// 
// Возвращаемое значение:
//  Структура - Новые параметры отбора:
//   * РеестрЗадач - Неопределено, СправочникСсылка.РеестрыЗадач - Реестр задач.
//   * Автор - Неопределено, ОпределяемыйТип.УчастникЗадач - Автор.
//   * ВидДействия - Неопределено, СправочникСсылка.ВидыДействийЗадач - Вид действия.
//   * ВидЗадачи - Неопределено, СправочникСсылка.ВидыЗадач - Вид задачи.
//   * ВидПриложения - Неопределено, ОпределяемыйТип.ВидПриложенияЗадач - Вид приложения.
//   * Исполнитель - Неопределено, ОпределяемыйТип.УчастникЗадач - Исполнитель.
//   * Проект - Неопределено, СправочникСсылка.Проекты - Проект.
//   * ТипПриложения - Неопределено, ПеречислениеСсылка.ТипыПриложенийЗадач - Тип приложения.
//   * Флаг - Неопределено, ПеречислениеСсылка.ФлагиОбъектов - Флаг
// 
Функция НовыеПараметрыОтбора() Экспорт
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("РеестрЗадач", Неопределено);
	ПараметрыОтбора.Вставить("Автор", Неопределено);
	ПараметрыОтбора.Вставить("ВидДействия", Неопределено);
	ПараметрыОтбора.Вставить("ВидЗадачи", Неопределено);
	ПараметрыОтбора.Вставить("ВидПриложения", Неопределено);
	ПараметрыОтбора.Вставить("Исполнитель", Неопределено);
	ПараметрыОтбора.Вставить("Проект", Неопределено);
	ПараметрыОтбора.Вставить("ТипПриложения", Неопределено);
	ПараметрыОтбора.Вставить("Флаг", Неопределено);
	
	Возврат ПараметрыОтбора;
	
КонецФункции
 
// Помечает задачи истекающими.
//
Процедура ПометитьИстекающиеЗадачи() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КоличествоЗадачПоИсполнителям.Регистратор КАК ДействиеЗадачи
		|ИЗ
		|	РегистрНакопления.КоличествоЗадачПоИсполнителям КАК КоличествоЗадачПоИсполнителям
		|ГДЕ
		|	КоличествоЗадачПоИсполнителям.МожетБытьПросрочена
		|	И КоличествоЗадачПоИсполнителям.РеестрЗадач = ЗНАЧЕНИЕ(Справочник.РеестрыЗадач.ВсеЗадачи)
		|	И КоличествоЗадачПоИсполнителям.Срок МЕЖДУ &ТекущаяДатаСеанса И &ГраницаИстеченияСрока
		|	И КоличествоЗадачПоИсполнителям.Истекающих = 0
		|	И КоличествоЗадачПоИсполнителям.Срок <> ДАТАВРЕМЯ(1, 1, 1)");
	
	Запрос.УстановитьПараметр("ТекущаяДатаСеанса", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ГраницаИстеченияСрока", РаботаСЗадачами.ГраницаИстеченияСрока());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбновитьПоДействиюЗадачи(Выборка.ДействиеЗадачи);
	КонецЦикла;
	
КонецПроцедуры

// Помечает задачи просроченными.
//
Процедура ПометитьПросроченныеЗадачи() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КоличествоЗадачПоИсполнителям.Регистратор КАК ДействиеЗадачи
		|ИЗ
		|	РегистрНакопления.КоличествоЗадачПоИсполнителям КАК КоличествоЗадачПоИсполнителям
		|ГДЕ
		|	КоличествоЗадачПоИсполнителям.МожетБытьПросрочена
		|	И КоличествоЗадачПоИсполнителям.РеестрЗадач = ЗНАЧЕНИЕ(Справочник.РеестрыЗадач.ВсеЗадачи)
		|	И КоличествоЗадачПоИсполнителям.Срок <= &ТекущаяДатаСеанса
		|	И КоличествоЗадачПоИсполнителям.Срок <> ДАТАВРЕМЯ(1, 1, 1)");
	
	Запрос.УстановитьПараметр("ТекущаяДатаСеанса", ТекущаяДатаСеанса());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбновитьПоДействиюЗадачи(Выборка.ДействиеЗадачи);
	КонецЦикла;
	
КонецПроцедуры

// Данные реестра.
// 
// Параметры:
//  ДействиеЗадачи - ДокументСсылка.ДействиеЗадачи.
//  КэшДанных - Структура,
//              Неопределено.
// 
// Возвращаемое значение:
//  См. НовыеДанныеРеестра.
// 
Функция ДанныеРеестра(ДействиеЗадачи, КэшДанных = Неопределено) Экспорт
	
	Если КэшДанных <> Неопределено И КэшДанных.Свойство("ДанныеДействияЗадачи") Тогда
		РеквизитыДействия = КэшДанных.ДанныеДействияЗадачи;
	Иначе
		КэшируемыеРеквизитыДействий = КэшируемыеРеквизитыДействий();
		РеквизитыДействия = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ДействиеЗадачи,
			КэшируемыеРеквизитыДействий);
	КонецЕсли;
	
	Если КэшДанных <> Неопределено И КэшДанных.Свойство("ДанныеЗадачи") Тогда
		РеквизитыЗадачи = КэшДанных.ДанныеЗадачи;
	Иначе
		КэшируемыеРеквизитыЗадач = КэшируемыеРеквизитыЗадач();
		РеквизитыЗадачи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			РеквизитыДействия.Задача,
			КэшируемыеРеквизитыЗадач);
	КонецЕсли;
	
	ДанныеРеестра = НовыеДанныеРеестра();
	ДанныеРеестра.Регистратор = ДействиеЗадачи;
	
	ОбновитьДанныеРеестраПоДействиюЗадачи(ДанныеРеестра, РеквизитыДействия);
	ОбновитьДанныеРеестраПоЗадаче(ДанныеРеестра, РеквизитыДействия, РеквизитыЗадачи);
	
	ОжидаетВыполнения = ДанныеРеестра.ОжидающихВыполнения = 1;
	ОписаниеПоступившихОбновлений =
		РаботаСЗадачами.ОписаниеПоступившихОбновленийДействияЗадачи(ДействиеЗадачи);
	ДанныеРеестра.ПоступилиОбновления =
		?(ОжидаетВыполнения И ЗначениеЗаполнено(ОписаниеПоступившихОбновлений), 1, 0);
		
	Возврат ДанныеРеестра;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

#Область ОбновлениеКэширующихДанных

// Обрабатывает обновление кэширующих данных.
// 
// Параметры:
//  Выборка - ВыборкаИзРезультатаЗапроса - Выборка из очереди обновления кэширующих данных:
//   * ОтметкаВремени - ОпределяемыйТип.ОтметкаВремени.
//   * ЗависимыйОбъектМетаданных - СправочникСсылка.ИдентификаторыОбъектовМетаданных.
//   * ВлияющийОбъектМетаданных - СправочникСсылка.ИдентификаторыОбъектовМетаданных.
//   * КлючВлияющихДанных - ЛюбаяСсылка.
//   * Автор - СправочникСсылка.Пользователи.
//   * ЗагрузкаОбработанныхДанныхИзДругойСистемы - Булево.
//   * ИзмененияВлияющихДанных - ХранилищеЗначения.
//   * Попыток - Число.
//   * ДатаКОбработке - Дата.
// 
Процедура ОбновитьКэширующиеДанные(Выборка) Экспорт
	
	Если ТипЗнч(Выборка.КлючВлияющихДанных) = Тип("ДокументСсылка.ДействиеЗадачи") Тогда
		
		ОбновитьПоДействиюЗадачи(Выборка.КлючВлияющихДанных);
		
	ИначеЕсли ТипЗнч(Выборка.КлючВлияющихДанных) = Тип("ДокументСсылка.Задача") Тогда
		
		ОбновитьПоЗадаче(Выборка.КлючВлияющихДанных);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует пустую структуру данных реестра.
// 
// Возвращаемое значение:
//  Структура - Новые данные реестра:
//   * Период - Дата.
//   * Регистратор - ДокументСсылка.ДействиеЗадачи.
//   * ВидДвижения - ВидДвиженияНакопления.
//   * Автор - ОпределяемыйТип.УчастникЗадач, Неопределено - Автор.
//   * ВидДействия - СправочникСсылка.ВидыДействийЗадач.
//   * ВидЗадачи - СправочникСсылка.ВидыЗадач.
//   * ВидПриложения - ОпределяемыйТип.ВидПриложенияЗадач, Неопределено - Вид приложения.
//   * Исполнитель - ОпределяемыйТип.УчастникЗадач, Неопределено - Автор.
//   * Проект - СправочникСсылка.Проекты.
//   * ТипПриложения - ПеречислениеСсылка.ТипыПриложенийЗадач.
//   * Флаг - ПеречислениеСсылка.ФлагиОбъектов.
//   * ВРаботе - Число.
//   * Всего - Число.
//   * ВСрок - Число.
//   * Выполненных - Число.
//   * Истекающих - Число.
//   * Новых - Число.
//   * ОжидающихВыполнения - Число.
//   * ОжидающихПроверки - Число.
//   * ПоступилиОбновления - Число.
//   * Просроченных - Число.
//   * МожетБытьПросрочена - Булево.
//   * Срок - Дата.
// 
Функция НовыеДанныеРеестра()
	
	ДанныеРеестра = Новый Структура;
	ДанныеРеестра.Вставить("Период", Дата(1, 1, 1));
	ДанныеРеестра.Вставить("Регистратор", Документы.ДействиеЗадачи.ПустаяСсылка());
	ДанныеРеестра.Вставить("ВидДвижения", ВидДвиженияНакопления.Приход);
	ДанныеРеестра.Вставить("Автор", Неопределено);
	ДанныеРеестра.Вставить("ВидДействия", Справочники.ВидыДействийЗадач.ПустаяСсылка());
	ДанныеРеестра.Вставить("ВидЗадачи", Справочники.ВидыЗадач.ПустаяСсылка());
	ДанныеРеестра.Вставить("ВидПриложения", Неопределено);
	ДанныеРеестра.Вставить("Исполнитель", Неопределено);
	ДанныеРеестра.Вставить("Проект", Справочники.Проекты.ПустаяСсылка());
	ДанныеРеестра.Вставить("ТипПриложения", Перечисления.ТипыПриложенийЗадач.ПустаяСсылка());
	ДанныеРеестра.Вставить("Флаг", Перечисления.ФлагиОбъектов.ПустаяСсылка());
	ДанныеРеестра.Вставить("ВРаботе", 0);
	ДанныеРеестра.Вставить("Всего", 0);
	ДанныеРеестра.Вставить("ВСрок", 0);
	ДанныеРеестра.Вставить("Выполненных", 0);
	ДанныеРеестра.Вставить("Истекающих", 0);
	ДанныеРеестра.Вставить("Новых", 0);
	ДанныеРеестра.Вставить("ОжидающихВыполнения", 0);
	ДанныеРеестра.Вставить("ОжидающихПроверки", 0);
	ДанныеРеестра.Вставить("ПоступилиОбновления", 0);
	ДанныеРеестра.Вставить("Просроченных", 0);
	ДанныеРеестра.Вставить("МожетБытьПросрочена", Ложь);
	ДанныеРеестра.Вставить("Срок", Дата(1, 1, 1));
	
	Возврат ДанныеРеестра;
	
КонецФункции

// Обновляет данные задачи.
//
// Параметры:
//  ДанныеРеестра - См. НовыеДанныеРеестра.
//  РеквизитыДействия - Структура - Реквизиты задачи. См. КэшируемыеРеквизитыДействий.
//
Процедура ОбновитьДанныеРеестраПоДействиюЗадачи(ДанныеРеестра, РеквизитыДействия)
	
	ВидСостоянияУчастниковЗадач = РаботаСЗадачамиПовтИсп.ВидСостоянияУчастниковЗадач(
		РеквизитыДействия.СостояниеУчастникаЗадачи);
	
	ВРаботе = Перечисления.ВидыСостоянийУчастниковЗадач.ЭтоДействиеВРаботе(ВидСостоянияУчастниковЗадач);
	Выполнено = Перечисления.ВидыСостоянийУчастниковЗадач.ЭтоВыполненноеДействие(ВидСостоянияУчастниковЗадач);
	Новое = Перечисления.ВидыСостоянийУчастниковЗадач.ЭтоНовоеДействие(ВидСостоянияУчастниковЗадач);
	ОжидаетВыполнения = Перечисления.ВидыСостоянийУчастниковЗадач.ЭтоОжидаемоеДействие(ВидСостоянияУчастниковЗадач);
	ОжидаетПроверки = Перечисления.ВидыСостоянийУчастниковЗадач.ЭтоОжидающееПроверкиДействие(ВидСостоянияУчастниковЗадач);
	
	ГраницаИстеченияСрока = РаботаСЗадачами.ГраницаИстеченияСрока();
	
	ДанныеРеестра.ВидДвижения = ВидДвиженияНакопления.Приход;
	ДанныеРеестра.Период = РеквизитыДействия.Дата;
	
	ДанныеРеестра.Исполнитель = РеквизитыДействия.Исполнитель;
	ДанныеРеестра.ВидДействия = РеквизитыДействия.ВидДействия;
	ДанныеРеестра.Флаг = РеквизитыДействия.Флаг;
	
	ДанныеРеестра.Всего = 1;
	ДанныеРеестра.ВРаботе = ?(ВРаботе, 1, 0);
	ДанныеРеестра.Выполненных = ?(Выполнено, 1, 0);
	ДанныеРеестра.Новых = ?(Новое, 1, 0);
	ДанныеРеестра.ОжидающихВыполнения = ?(ОжидаетВыполнения, 1, 0);
	ДанныеРеестра.ОжидающихПроверки = ?(ОжидаетПроверки, 1, 0);
	
	Срок = ДанныеРеестра.Срок;
	Просрочено = Документы.ДействиеЗадачи.Просрочено(
		Срок,
		РеквизитыДействия.СостояниеУчастникаЗадачи,
		РеквизитыДействия.ДатаВыполнения);
	ДанныеРеестра.МожетБытьПросрочена = ОжидаетВыполнения И ЗначениеЗаполнено(Срок) И Не Просрочено;
	
	ДанныеРеестра.Просроченных = ?(Просрочено И ОжидаетВыполнения, 1, 0);
	
	ИстекаетСрок = ДанныеРеестра.МожетБытьПросрочена И Срок < ГраницаИстеченияСрока;
	
	ДанныеРеестра.Истекающих = ?(ИстекаетСрок, 1, 0);
	ДанныеРеестра.ВСрок = ?(ОжидаетВыполнения И Не Просрочено И Не ИстекаетСрок, 1, 0);
	
КонецПроцедуры

// Обновляет данные задачи.
//
// Параметры:
//  ДанныеРеестра - См. НовыеДанныеРеестра.
//  РеквизитыДействия - Структура - Реквизиты задачи. См. КэшируемыеРеквизитыДействий.
//  РеквизитыЗадачи - Структура - Реквизиты задачи. См. КэшируемыеРеквизитыЗадач.
//
Процедура ОбновитьДанныеРеестраПоЗадаче(ДанныеРеестра, РеквизитыДействия, РеквизитыЗадачи)
	
	Автор = Документы.ДействиеЗадачи.Автор(РеквизитыДействия.ОсобыйАвтор, РеквизитыЗадачи.Автор);
	Срок = Документы.ДействиеЗадачи.Срок(
		РеквизитыДействия.ЕстьОсобыйСрок,
		РеквизитыДействия.ОсобыйСрок,
		РеквизитыЗадачи.Срок);
	Просрочено = Документы.ДействиеЗадачи.Просрочено(
		Срок,
		РеквизитыДействия.СостояниеУчастникаЗадачи,
		РеквизитыДействия.ДатаВыполнения);
	
	ГраницаИстеченияСрока = РаботаСЗадачами.ГраницаИстеченияСрока();
	
	ОжидаетВыполнения =
		ДанныеРеестра.ОжидающихВыполнения = 1;
	
	ДанныеРеестра.Автор = Автор;
	ДанныеРеестра.Проект = РеквизитыЗадачи.Проект;
	ДанныеРеестра.ВидЗадачи = РеквизитыЗадачи.ВидЗадачи;
	ДанныеРеестра.ВидПриложения = РеквизитыЗадачи.ВидПриложения;
	ДанныеРеестра.ТипПриложения = РеквизитыЗадачи.ТипПриложения;
	
	ДанныеРеестра.МожетБытьПросрочена = ОжидаетВыполнения И ЗначениеЗаполнено(Срок) И Не Просрочено;
	ДанныеРеестра.Срок = Срок;
	
	ДанныеРеестра.Просроченных = ?(Просрочено И ОжидаетВыполнения, 1, 0);
	
	ИстекаетСрок = ДанныеРеестра.МожетБытьПросрочена И Срок < ГраницаИстеченияСрока;  
	ДанныеРеестра.Истекающих = ?(ИстекаетСрок, 1, 0);
	ДанныеРеестра.ВСрок = ?(ОжидаетВыполнения И Не Просрочено И Не ИстекаетСрок, 1, 0);
	
КонецПроцедуры

// Формирует отбор по параметрам отбора.
// 
// Параметры:
//  ПараметрыОтбора - См. НовыеПараметрыОтбора.
// 
// Возвращаемое значение:
//  Структура - Установленный отбор.
// 
Функция Отбор(ПараметрыОтбора)
	
	Отбор = Новый Структура;
	
	НовыеПараметрыОтбора = НовыеПараметрыОтбора();
	ЗаполнитьЗначенияСвойств(НовыеПараметрыОтбора, ПараметрыОтбора);
	
	Для Каждого КлючИЗначение Из НовыеПараметрыОтбора Цикл
		
		Если КлючИЗначение.Значение = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Отбор.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		
	КонецЦикла;
	
	Возврат Отбор;
	
КонецФункции

#КонецОбласти

#КонецЕсли