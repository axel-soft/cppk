﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборПоказыватьУдаленные(
		Список, ПоказыватьУдаленные, Элементы.ПоказыватьУдаленные);	
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборПоказыватьУдаленные(
		СтатусыОбмена, ПоказыватьУдаленные, Элементы.ПоказыватьУдаленные);
	
	ВидимостьКомандИнтеграцииСАрхивом();
	
	// Устанавливаем вид просмотра по умолчанию.
	Если ПолучитьФункциональнуюОпцию("ИнтеграцияС1САрхивом") = Ложь Тогда
		ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.Списком;
	ИначеЕсли Не ЗначениеЗаполнено(ВидПросмотра) Тогда
		ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоСтатусамОбменаСАрхивом;
	КонецЕсли;
		
	ПредыдущийВидПросмотра = ВидПросмотра;
	ПереключитьВидПросмотра();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборПоказыватьУдаленные(
		Список, ПоказыватьУдаленные, Элементы.ПоказыватьУдаленные);
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборПоказыватьУдаленные(
		СтатусыОбмена, ПоказыватьУдаленные, Элементы.ПоказыватьУдаленные);
		
	Если ПолучитьФункциональнуюОпцию("ИнтеграцияС1САрхивом") = Ложь Тогда
		ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.Списком;
	КонецЕсли;
	
	ПредыдущийВидПросмотра = ВидПросмотра;
	ПереключитьВидПросмотра();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененаПередачаДелВАрхив" Тогда
		Элементы.СтатусыОбмена.Обновить();
		Элементы.Список.Обновить();
		УстановитьПараметрыСписка();
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСтатусыОбмена

&НаКлиенте
Процедура СтатусыОбменаПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.СтатусыОбмена.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Если ТекущийСтатусОбмена = ТекущиеДанные.СтатусВыгрузкиВАрхив Тогда 
			Возврат;
		КонецЕсли;
			
		ТекущийСтатусОбмена = ТекущиеДанные.СтатусВыгрузкиВАрхив;
	КонецЕсли;
		
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
				
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборПоказыватьУдаленные(
		Список, ПоказыватьУдаленные, Элементы.ПоказыватьУдаленные);
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборПоказыватьУдаленные(
		СтатусыОбмена, ПоказыватьУдаленные, Элементы.ПоказыватьУдаленные);
		
КонецПроцедуры

&НаКлиенте
Процедура РежимПросмотраСписком(Команда)
	
	ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.Списком");
	ВидПросмотраПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПросмотраПоСтатусамОбмена(Команда)
	
	ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоСтатусамОбменаСАрхивом");
	ВидПросмотраПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОбменаСАрхивом(Команда)
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтатусыДляВыбора.Очистить();
	
	ДокументыДляОбработки = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока);
		ДокументыДляОбработки.Добавить(ДанныеСтроки.Ссылка);
	КонецЦикла;
	ВозможныеСтатусыДокументов = ПолучитьСписокСтатусовДляДокументов(ДокументыДляОбработки);
	Если ВозможныеСтатусыДокументов.Количество() Тогда
		СтатусыДляВыбора.ЗагрузитьЗначения(ВозможныеСтатусыДокументов);
		Оповещение = Новый ОписаниеОповещения("ПослеВыбораСтатусаОбмена", ЭтотОбъект);
		СтатусыДляВыбора.ПоказатьВыборЭлемента(Оповещение, НСтр("ru = 'Выберите статус документа'"));
	Иначе
		ТекстСообщения = НСтр("ru = 'Нельзя изменить текущий статус вручную. 
			|Нет подходящих статусов или документ принят в 1С:Архив. Обратитесь к администратору.'");
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновить(Команда)
	
	Элементы.СтатусыОбмена.Обновить();
	Элементы.Список.Обновить();
	СтатусыОбменаПриАктивизацииСтроки(Неопределено);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВидимостьКомандИнтеграцииСАрхивом()
	
	Если ПолучитьФункциональнуюОпцию("ИнтеграцияС1САрхивом") = Истина Тогда
		Элементы.ФормаГруппаПровести.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюГруппаПровести.Видимость = Ложь;
	Иначе
		Элементы.ПодменюРежимПросмотра.Видимость = Ложь;
		Элементы.ФормаКнопкаУстановитьСтатус.Видимость = Ложь;
		Элементы.СтатусВыгрузкиВАрхив.Видимость = Ложь;
		Элементы.СписокУстановитьСтатус.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПросмотраПриИзменении()
	
	Если ВидПросмотра = ПредыдущийВидПросмотра Тогда 
		Возврат;
	КонецЕсли;
	
	ПредыдущийВидПросмотра = ВидПросмотра;
	ПереключитьВидПросмотра();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
	
	УстановитьПараметрыСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыСписка()
	
	РаботаСоСпискамиДокументовКлиент.УстановитьПараметрыСписка(ЭтотОбъект);
			
КонецПроцедуры

&НаСервере
Процедура ПереключитьВидПросмотра()
	
	Если ПолучитьФункциональнуюОпцию("ИнтеграцияС1САрхивом") = Ложь Тогда
		ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.Списком;
	КонецЕсли;
	
	ПросмотрСписком = ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.Списком;
	
	Элементы.РежимПросмотраСписком.Пометка = ПросмотрСписком;
	Элементы.РежимПросмотраПоСтатусамОбмена.Пометка = Не ПросмотрСписком;
	
	Элементы.ГруппаДеревоСтатусовОбмена.Видимость = Не ПросмотрСписком;
	Элементы.СтатусВыгрузкиВАрхив.Видимость = ПросмотрСписком;
	
	Если ПросмотрСписком Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
			"СтатусОбменаСАрхивом", Неопределено, Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"СтатусОбменаСАрхивом");
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СтатусыОбмена,
			"ПредставлениеПустогоСтатуса", НСтр("ru = '<Не установлен>'"), Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокСтатусовДляДокументов(ВыбранныеДокументы)
		
	Возврат Документы.ПередачаДелВАрхив.ПолучитьСписокВыбораСтатусовВыгрузкиВАрхив(ВыбранныеДокументы);
		
КонецФункции

&НаКлиенте
Процедура ПослеВыбораСтатусаОбмена(ВыбранныйЭлемент, Параметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	РаботаСоСпискамиДокументовКлиент.УстановитьДокументамСтатусОбменаСАрхивом(Элементы.Список, ВыбранныйЭлемент.Значение);
	
	Элементы.СтатусыОбмена.Обновить();

КонецПроцедуры

#КонецОбласти
