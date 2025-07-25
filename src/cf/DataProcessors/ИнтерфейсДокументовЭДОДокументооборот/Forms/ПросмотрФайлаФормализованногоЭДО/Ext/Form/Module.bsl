﻿// @strict-types

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.ФайлДО) Тогда
		ВызватьИсключение НСтр("ru = 'Некорректный вызов формы: не заполнен файл для показа данных.'");
	КонецЕсли;
	
	ФайлДО = Параметры.ФайлДО;
	Заголовок = Строка(ФайлДО);
	
	ЗаполнитьТипДокумента();
	
	ЗагрузитьНастройкиФормы();
	УстановитьОформлениеНастроекФормы();
	
	ПоказатьПредставлениеФайла();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтображатьОбластьКопияВерна(Команда)
	
	ОтключитьВыводКопияВерна = Не ОтключитьВыводКопияВерна;
	Элементы.ОтображатьОбластьКопияВерна.Пометка = Не ОтключитьВыводКопияВерна;
	
	СохранитьНастройкиИПоказатьПредставление();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьДополнительнуюИнформацию(Команда)
	
	ОтключитьВыводДопДанных = Не ОтключитьВыводДопДанных;
	Элементы.ОтображатьДополнительнуюИнформацию.Пометка = Не ОтключитьВыводДопДанных;
	
	СохранитьНастройкиИПоказатьПредставление();
		
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьБанковскиеРеквизиты(Команда)
	
	ВыводитьБанковскиеРеквизиты = Не ВыводитьБанковскиеРеквизиты;
	Элементы.ОтображатьБанковскиеРеквизиты.Пометка = ВыводитьБанковскиеРеквизиты;
	
	СохранитьНастройкиИПоказатьПредставление();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаСНастройками

&НаСервере
Процедура ЗагрузитьНастройкиФормы()
	
	НастройкиВизуализации = ОбменЭДОДокументооборот.НастройкиВизуализацииФайлаФормализованногоЭДО();
	ОтключитьВыводДопДанных = НастройкиВизуализации.ОтключитьВыводДопДанных;
	ОтключитьВыводКопияВерна = НастройкиВизуализации.ОтключитьВыводКопияВерна;
	ВыводитьБанковскиеРеквизиты = НастройкиВизуализации.ВыводитьБанковскиеРеквизиты;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОформлениеНастроекФормы()
	
	Элементы.ОтображатьДополнительнуюИнформацию.Пометка = НЕ ОтключитьВыводДопДанных;
	Элементы.ОтображатьОбластьКопияВерна.Пометка = НЕ ОтключитьВыводКопияВерна;
	
	Если ТипДокументаЭДО = Перечисления.ТипыДокументовЭДО.СчетНаОплату Тогда
		Элементы.ОтображатьБанковскиеРеквизиты.Видимость = Истина;
	Иначе
		Элементы.ОтображатьБанковскиеРеквизиты.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ОтображатьБанковскиеРеквизиты.Пометка = ВыводитьБанковскиеРеквизиты;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиИПоказатьПредставление()
	
	НастройкиВизуализации  = ОбменЭДОДокументооборот.НастройкиВизуализацииФайлаФормализованногоЭДО();
	НастройкиВизуализации.ОтключитьВыводКопияВерна = ОтключитьВыводКопияВерна;
	НастройкиВизуализации.ОтключитьВыводДопДанных = ОтключитьВыводДопДанных;
	НастройкиВизуализации.ВыводитьБанковскиеРеквизиты = ВыводитьБанковскиеРеквизиты;
	
	ОбменЭДОДокументооборот.СохранитьНастройкиВизуализацииФайлаФормализованногоЭДО(НастройкиВизуализации);
	
	ПоказатьПредставлениеФайла();
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьТипДокумента()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеФайлаИДвоичныеДанные = РаботаСФайламиВызовСервера.ДанныеФайлаИДвоичныеДанные(ФайлДО);
	//@skip-check property-return-type
	Расширение = ДанныеФайлаИДвоичныеДанные.ДанныеФайла.Расширение; // Строка
	Если ВРег(Расширение) <> "XML" Тогда
		ТипДокументаЭДО = Перечисления.ТипыДокументовЭДО.ПустаяСсылка();
		ПоказатьОшибкуФормированияПредставления(НСтр("ru = 'Файл не является формализованных xml-файлом'"));
		Возврат;
	КонецЕсли;
	
	Попытка
		ДанныеЭДФайла = ОбменСКонтрагентами.ДанныеЭлектронногоДокументаПоФайлу(
			ДанныеФайлаИДвоичныеДанные.ДвоичныеДанные);
	Исключение
		ТипДокументаЭДО = Перечисления.ТипыДокументовЭДО.ПустаяСсылка();
		ПоказатьОшибкуФормированияПредставления(НСтр("ru = 'Не удалось получить прочитать данные файла ЭДО. Наиболее вероятно он не является формализованным файлом ЭДО.'"));
		Возврат;
	КонецПопытки;
	
	ТипДокументаЭДО = ДанныеЭДФайла.НовыйЭД.ВидЭД;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьПредставлениеФайла()
	
	Если Не ЗначениеЗаполнено(ТипДокументаЭДО) Тогда
		ЗаполнитьТипДокумента();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТипДокументаЭДО) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВизуализацииДокумента = ИнтерфейсДокументовЭДО.НовыеПараметрыВизуализацииДокумента();
	
	ПараметрыВизуализацииДокумента.ВыводитьБанковскиеРеквизиты = ВыводитьБанковскиеРеквизиты;
	ПараметрыВизуализацииДокумента.ВыводитьДопДанные = Не ОтключитьВыводДопДанных;
	ПараметрыВизуализацииДокумента.ВыводитьКопияВерна = Не ОтключитьВыводКопияВерна;
	
	ДанныеФайлаИДвоичныеДанные = РаботаСФайламиВызовСервера.ДанныеФайлаИДвоичныеДанные(ФайлДО);
	ВидДокументаЭДО = ЭлектронныеДокументыЭДО.ВидДокументаПоТипу(ТипДокументаЭДО);
	
	Визуализация = ОбменСКонтрагентами.ПредставлениеЭлектронногоДокументаПоФайлу(
		ВидДокументаЭДО,
		ДанныеФайлаИДвоичныеДанные.ДвоичныеДанные, ,
		ПараметрыВизуализацииДокумента);
	
	Если ТипЗнч(Визуализация) <> Тип("ТабличныйДокумент") Тогда
		ПоказатьОшибкуФормированияПредставления(НСтр("ru = 'Не удалось сформировать визуализацию документа.'"));
		Возврат;
	КонецЕсли;
	
	ПоказатьТабличныйДокумент(Визуализация);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьОшибкуФормированияПредставления(ТекстОшибки)
	
	Элементы.СтраницыПредставлениеФайла.ТекущаяСтраница = Элементы.СтраницаОшибка;
	Элементы.НадписьОшибкаПредставленияФайла.Заголовок = ТекстОшибки;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьТабличныйДокумент(ТабличныйДокумент)
	
	Элементы.СтраницыПредставлениеФайла.ТекущаяСтраница = Элементы.СтраницаТабличныйДокумент;
	ТабличныйДокументФормализованногоЭДО = ТабличныйДокумент;
	
КонецПроцедуры

#КонецОбласти
