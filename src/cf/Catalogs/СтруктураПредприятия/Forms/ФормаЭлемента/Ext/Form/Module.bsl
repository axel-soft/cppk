﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтарыйРуководитель = Объект.Руководитель;
	СтарыйРанг = Объект.Ранг;
	СтарыйУказанОсобыйРанг = Объект.УказанОсобыйРанг;
	
	Нумерация.ПоказатьИндексНумерации(ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.Руководитель = Справочники.Сотрудники.ПустаяСсылка();
	КонецЕсли;
	
	Если Не ДокументооборотПраваДоступаПовтИсп.ВключеноИспользованиеПравДоступа() Тогда
		Элементы.ФормаПолномочияИРазрешения.Заголовок = НСтр("ru = 'Полномочия'");
	КонецЕсли;
	
	Элементы.ФормаПолномочияИРазрешения.Видимость = ПравоДоступа("Изменение", 
		Метаданные.РегистрыСведений.ПолномочияСотрудников);
	
	ОбсужденияДокументооборот.ОбновитьВидимостьОбсужденийВАвтообновляемомЧате(ЭтотОбъект);
	
	// Обработчик механизма "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаСвойства");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ФормаСтандартныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	НастройкиФормы = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(СтрШаблон("%1/ТекущиеДанные", ИмяФормы), "");
		
	Если НастройкиФормы = Неопределено Тогда
		ПриЗагрузкеДанныхИзНастроекНаСервере(НастройкиФормы);
	КонецЕсли;
		
	
	НастроитьОтображениеГруппыПометкаУдаления();
	
	НастроитьОтображениеВышестоящегоРуководителя(ЭтотОбъект);
	
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	
КонецПроцедуры


&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	Если Настройки = Неопределено Тогда
		ЗадаватьВопросОНезаполненномРуководителе = Истина;
		ЗадаватьВопросОВышестоящемРуководителе = Истина;
	КонецЕсли;
	Элементы.ЗадаватьВопросОНеЗаполненномРуководителе.Пометка = ЗадаватьВопросОНезаполненномРуководителе;
	Элементы.ЗадаватьВопросОВышестоящемРуководителе.Пометка = ЗадаватьВопросОВышестоящемРуководителе;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьДоступностьРанга();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбсужденияПодключены" Тогда
		ОбновитьВидимостьКомандОбсужденийНаСервере();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_СтруктураПредприятия" Тогда
		НастроитьОтображениеВышестоящегоРуководителя(ЭтотОбъект);
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	НастроитьОтображениеГруппыПометкаУдаления();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик механизма "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект); 
	
	МультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("НетНастройкиНумерации", Нумерация.НетНастройкиНумерации(ТекущийОбъект.Ссылка));
	ИндексНумерации = СокрЛП(ИндексНумерации);
	Если ИндексНумерации <> ИндексНумерацииПриОткрытии Тогда 
		Если ЗначениеЗаполнено(ИндексНумерации) Тогда 
			РегистрыСведений.ИндексыНумерации.ЗаписатьИндексНумерации(Объект.Ссылка, ИндексНумерации);
		Иначе 
			РегистрыСведений.ИндексыНумерации.УдалитьИндексНумерации(Объект.Ссылка);
		КонецЕсли;
		
		ИндексНумерацииПриОткрытии = ИндексНумерации;
	КонецЕсли;
	
	ОбсужденияДокументооборот.ОбновитьВидимостьОбсужденийВАвтообновляемомЧате(ЭтотОбъект);
	
	СтарыйРанг = Объект.Ранг;
	СтарыйУказанОсобыйРанг = Объект.УказанОсобыйРанг;
	
	НастроитьОтображениеГруппыПометкаУдаления();
	
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПослеЗаписиКлиент(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.Руководитель) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗадаватьВопросОВышестоящемРуководителе И НЕ ПараметрыЗаписи.Свойство("ВопросОВышестоящемРуководителеЗадан")
		И Не ЗначениеЗаполнено(Объект.Руководитель) И ЗначениеЗаполнено(ТекущийРуководитель) Тогда
		ЗадатьВопросОВышестоящемРуководителе(ПараметрыЗаписи);
		Отказ = Истина;
	ИначеЕсли ЗадаватьВопросОНезаполненномРуководителе
		И НЕ ПараметрыЗаписи.Свойство("ВопросОНезаполненномРуководителеЗадан")
		И Не ЗначениеЗаполнено(Объект.Руководитель)
		И Не ЗначениеЗаполнено(ТекущийРуководитель) Тогда
		ЗадатьВопросОНезаполненномРуководителе(ПараметрыЗаписи);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
    МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура РуководительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ПодменятьПользователейСотрудниками", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор руководителя подразделения'"));
	
	ВыборанноеЗначение = Объект.Руководитель;
	Если Не ЗначениеЗаполнено(ВыборанноеЗначение) И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ВыборанноеЗначение = Объект.Ссылка;
	КонецЕсли;
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыборанноеЗначение);
	
	ОткрытьФорму("Справочник.АдреснаяКнига.ФормаСписка",
		ПараметрыФормы,
		Элементы.Руководитель,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	
КонецПроцедуры

&НаКлиенте
Процедура РуководительПриИзменении(Элемент)
	Объект.Руководитель = ТекущийРуководитель;
	НастроитьОтображениеВышестоящегоРуководителя(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РуководительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ТекущийРуководитель = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка");
		Объект.Руководитель = ТекущийРуководитель;
		НастроитьОтображениеВышестоящегоРуководителя(ЭтотОбъект);
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РуководительИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	Если Не ЦветТекстаПоляРуководительПоУмолчанию Тогда
		Элемент.ЦветТекста = ОбщегоНазначенияКлиент.ЦветСтиля("ЦветТекстаПоля");
		ЦветТекстаПоляРуководительПоУмолчанию = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РодительПриИзменении(Элемент)
	
	ОбработатьИзменениеРодителяНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УказанОсобыйРангПриИзменении(Элемент)
	
	УстановитьДоступностьРанга();
	
	Если Объект.УказанОсобыйРанг И СтарыйУказанОсобыйРанг Тогда
		
		Объект.Ранг = СтарыйРанг;
		
	ИначеЕсли Не Объект.УказанОсобыйРанг Тогда
		
		РангРодителя = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
			Объект.Родитель, "Ранг");
			
		Объект.Ранг = ?(ЗначениеЗаполнено(РангРодителя), РангРодителя+1, 1);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РуководительОбработкаВыбора(Элемент, ВыбранноеЗначение, ДополнительныеДанные, СтандартнаяОбработка)
	
	СотрудникиКлиент.СотрудникОбработкаВыбора(Объект, "Руководитель", ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолномочияИРазрешения(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Записать();
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Пользователь", Объект.Ссылка);
	
	ОткрытьФорму("Обработка.ПолномочияИРазрешения.Форма",
		ПараметрыФормы,
		ЭтотОбъект,
		Объект.Ссылка);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗадаватьВопросОВышестоящемРуководителе(Команда)
	ЗадаватьВопросОВышестоящемРуководителе = Не ЗадаватьВопросОВышестоящемРуководителе;
	Элементы.ЗадаватьВопросОВышестоящемРуководителе.Пометка = ЗадаватьВопросОВышестоящемРуководителе;	
КонецПроцедуры

&НаКлиенте
Процедура ЗадаватьВопросОНеЗаполненномРуководителе(Команда)
	ЗадаватьВопросОНезаполненномРуководителе = Не ЗадаватьВопросОНезаполненномРуководителе;
	Элементы.ЗадаватьВопросОНеЗаполненномРуководителе.Пометка = ЗадаватьВопросОНезаполненномРуководителе;
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработатьИзменениеРодителяНаСервере()
	
	Если Не Объект.УказанОсобыйРанг Тогда
		
		РангРодителя = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
			Объект.Родитель, "Ранг");
		Объект.Ранг = ?(ЗначениеЗаполнено(РангРодителя), РангРодителя+1, 1);
	
	КонецЕсли;
	
	НастроитьОтображениеВышестоящегоРуководителя(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиКлиент(ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.Руководитель) Тогда
		ОповеститьОбИзменении(Объект.Руководитель);
	КонецЕсли;
	Если ЗначениеЗаполнено(СтарыйРуководитель) Тогда
		ОповеститьОбИзменении(СтарыйРуководитель);
	КонецЕсли;
	СтарыйРуководитель = Объект.Руководитель;
	
	Параметр = Новый Структура;
	Параметр.Вставить("Ссылка", Объект.Ссылка);
	Параметр.Вставить("Руководитель", Объект.Руководитель);
	Оповестить("Запись_СтруктураПредприятия", Параметр);
	
	Если Не ПараметрыЗаписи.Свойство("ПоказаноПредупреждение") 
		И ПараметрыЗаписи.Свойство("НетНастройкиНумерации") И ПараметрыЗаписи.НетНастройкиНумерации = Истина Тогда
		ОписаниеПредупреждения = Новый ОписаниеОповещения(
			"ПослеЗаписиПродолжениеПослеПредупреждения",
			ЭтотОбъект,
			ПараметрыЗаписи);
		ПоказатьПредупреждение(ОписаниеПредупреждения,
			НСтр("ru = 'Документы с данным подразделением нельзя будет зарегистрировать, так как отсутствует подходящая настройка нумерации.'"));
		Возврат;	
	КонецЕсли;	
	
	Если ПараметрыЗаписи.Свойство("Закрыть") Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Изменение:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиПродолжениеПослеПредупреждения(ПараметрыЗаписи) Экспорт
	
	ПараметрыЗаписи.Вставить("ПоказаноПредупреждение", Истина);
	ПослеЗаписиКлиент(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть()
	
	ПараметрыЗаписи = Новый Структура();
	ПараметрыЗаписи.Вставить("Закрыть", Истина);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьИЗакрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьКомандОбсужденийНаСервере()
	
	ОбсужденияДокументооборот.ОбновитьВидимостьОбсужденийВАвтообновляемомЧате(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьРанга()
	Элементы.Ранг.ТолькоПросмотр = Не Объект.УказанОсобыйРанг;
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеГруппыПометкаУдаления()
	
	Элементы.ГруппаПометкаУдаления.Видимость = 
		ЗначениеЗаполнено(Объект.Ссылка) И Объект.ПометкаУдаления;

КонецПроцедуры

#Область ЗаполнениеРуководителя

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьОтображениеВышестоящегоРуководителя(Форма)
	
	Форма.Элементы.Руководитель.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	Если ЗначениеЗаполнено(Форма.Объект.Руководитель) Тогда
		Форма.ТекущийРуководитель = Форма.Объект.Руководитель;
		#Если Клиент Тогда
			Форма.Элементы.Руководитель.ЦветТекста = ОбщегоНазначенияКлиент.ЦветСтиля("ЦветТекстаПоля");
		#Иначе
			Форма.Элементы.Руководитель.ЦветТекста = ЦветаСтиля["ЦветТекстаПоля"];
		#КонецЕсли
		Форма.ЦветТекстаПоляРуководительПоУмолчанию = Истина;
	ИначеЕсли ЗначениеЗаполнено(Форма.Объект.Родитель) Тогда
		Форма.ТекущийРуководитель = СтруктураПредприятияВызовСервера.РуководительПодразделения(Форма.Объект.Родитель);
		Если ЗначениеЗаполнено(Форма.ТекущийРуководитель) Тогда
			#Если Клиент Тогда
				Форма.Элементы.Руководитель.ЦветТекста = ОбщегоНазначенияКлиент.ЦветСтиля("ИнформационнаяНадпись");
			#Иначе
				Форма.Элементы.Руководитель.ЦветТекста = ЦветаСтиля["ИнформационнаяНадпись"];
			#КонецЕсли
			Форма.ЦветТекстаПоляРуководительПоУмолчанию = Ложь;
			Форма.Элементы.Руководитель.Подсказка = НСтр("ru = 'Руководитель этого подразделения не указан.
				|Отображается руководитель вышестоящего подразделения.'");
		Иначе
			Форма.Элементы.Руководитель.Подсказка = НСтр("ru = 'Не указаны руководитель этого подразделения и
				|руководитель вышестоящего подразделения.'");
		КонецЕсли;
		Форма.Элементы.Руководитель.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопросОНезаполненномРуководителе(ПараметрыЗаписи = Неопределено)
		
		ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
		ПараметрыВопроса.Заголовок = НСтр("ru = 'Заполнение руководителя'");
		
		ТекстВопроса = НСтр("ru = 'Не указаны руководитель этого подразделения и руководитель вышестоящего
			|подразделения. Продолжить?'");
		
		СписокВариантовОтветов = Новый СписокЗначений;
		СписокВариантовОтветов.Добавить(КодВозвратаДиалога.Да);
		СписокВариантовОтветов.Добавить(КодВозвратаДиалога.Нет);

		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПослеОтветаНаВопросОНезаполненномРуководителе",
			ЭтотОбъект,
			ПараметрыЗаписи);
		
		СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(ОписаниеОповещения, ТекстВопроса,
			СписокВариантовОтветов, ПараметрыВопроса);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопросОВышестоящемРуководителе(ПараметрыЗаписи = Неопределено)
		
		ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
		ПараметрыВопроса.Заголовок = НСтр("ru = 'Заполнение руководителя'");
		
		ТекстВопроса = НСтр("ru = 'Руководитель этого подразделения не указан. Отображается руководитель вышестоящего
			|подразделения. Продолжить?'");
		
		СписокВариантовОтветов = Новый СписокЗначений;
		СписокВариантовОтветов.Добавить(КодВозвратаДиалога.Да);
		СписокВариантовОтветов.Добавить(КодВозвратаДиалога.Нет);

		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПослеОтветаНаВопросОВышестоящемРуководителе",
			ЭтотОбъект,
			ПараметрыЗаписи);
		
		СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(ОписаниеОповещения, ТекстВопроса,
			СписокВариантовОтветов, ПараметрыВопроса);
			
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросОНезаполненномРуководителе(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗадаватьВопросОНезаполненномРуководителе = Не Результат.БольшеНеЗадаватьЭтотВопрос;
	Элементы.ЗадаватьВопросОНеЗаполненномРуководителе.Пометка = ЗадаватьВопросОНезаполненномРуководителе;
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		ДополнительныеПараметры.Вставить("ВопросОНезаполненномРуководителеЗадан", Истина);
	КонецЕсли;
	
	Если Результат.Значение = КодВозвратаДиалога.Да Тогда
		Записать(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросОВышестоящемРуководителе(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗадаватьВопросОВышестоящемРуководителе = Не Результат.БольшеНеЗадаватьЭтотВопрос;
	Элементы.ЗадаватьВопросОВышестоящемРуководителе.Пометка = ЗадаватьВопросОВышестоящемРуководителе;
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		ДополнительныеПараметры.Вставить("ВопросОВышестоящемРуководителеЗадан", Истина);
	КонецЕсли;
	
	Если Результат.Значение = КодВозвратаДиалога.Да Тогда
		Записать(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ МЕХАНИЗМА СВОЙСТВ

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
      УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
      УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти