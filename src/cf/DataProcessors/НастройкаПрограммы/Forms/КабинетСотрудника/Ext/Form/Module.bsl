﻿
#Область ОбработчикиСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Сервис = Справочники.СервисыВнешнегоПодписания.КабинетСотрудника;
	АдресПриложения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сервис, "АдресПриложения");
	КлючиСервиса = РаботаСВнешнимПодписанием.КлючиСервисаИзБезопасногоХранилища(Сервис);
	Если КлючиСервиса <> Неопределено Тогда
		ИдентификаторКлиента = КлючиСервиса.ИдентификаторКлиента;
		СекретКлиента = КлючиСервиса.СекретКлиента;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	АдресПриложенияЗаписанный = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сервис, "АдресПриложения");
	КлючиСервиса = РаботаСВнешнимПодписанием.КлючиСервисаИзБезопасногоХранилища(Сервис);
	
	// Сохраняем изменившийся адрес приложения.
	Если АдресПриложенияЗаписанный <> АдресПриложения Тогда
		
		СервисОбъект = Сервис.ПолучитьОбъект();
		СервисОбъект.АдресПриложения = АдресПриложения;
		СервисОбъект.Записать();
		
	КонецЕсли;
	
	// Сохраняем изменившиеся ключи от сервиса.
	Если КлючиСервиса = Неопределено Или ИдентификаторКлиента <> КлючиСервиса.ИдентификаторКлиента
		Или СекретКлиента <> КлючиСервиса.СекретКлиента Тогда
		
		РаботаСВнешнимПодписанием.СохранитьКлючиСервисаВБезопасномХранилище(
			Сервис, ИдентификаторКлиента, СекретКлиента);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НужноПроверятьПодключенние Тогда
		
		ПодключениеУстановлено = РаботаСВнешнимПодписаниемВызовСервера.ПроверитьПодключениеКСервисуКабинетСотрудника(
			АдресПриложения,
			ИдентификаторКлиента,
			СекретКлиента);
		
		Если Не ПодключениеУстановлено Тогда
			
			Отказ = Истина;
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не удалось подключить к сервису по указанным параметрам. Сохранение настроек не выполнено.'"));
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьПовторноИспользуемыеЗначения();
	ОбновитьИнтерфейс();
	
	Если ПараметрыЗаписи.Свойство("Закрыть") Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьИнтеграциюПриИзменении(Элемент)
	
	ДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресПриложенияПриИзменении(Элемент)
	
	НужноПроверятьПодключенние = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторКлиентаПриИзменении(Элемент)
	
	НужноПроверятьПодключенние = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СекретКлиентаПриИзменении(Элемент)
	
	НужноПроверятьПодключенние = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	
	РаботаСВнешнимПодписаниемКлиент.НачатьПроверкуПодключенияКСервисуКабинетСотрудника(
		ЭтотОбъект,
		АдресПриложения,
		ИдентификаторКлиента,
		СекретКлиента);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
		
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Закрыть", Истина);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПодключение(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ПредопределенноеЗначение("Справочник.СервисыВнешнегоПодписания.КабинетСотрудника"));
	ОткрытьФорму("Справочник.СервисыВнешнегоПодписания.Форма.ФормаЭлемента", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры


&НаКлиенте
Процедура СопоставитьОбъекты(Команда)
	
	ОткрытьФорму("РегистрСведений.ИдентификаторыОбъектовВСервисахВнешнегоПодписания.ФормаСписка",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодробноОСервисе(Команда)
	
	ИнформационнаяСсылка = "https://welcome.1c-cabinet.ru/app/info?state=about";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ИнформационнаяСсылка);
	
КонецПроцедуры


&НаКлиенте
Процедура ОтчетСопоставленныеОбъекты(Команда)
	
	ФормаОтчета = ОткрытьФорму("Отчет.СопоставленныеОбъектыСервисовВнешнегоПодписания.Форма");
	ОтчетыКлиент.СформироватьОтчет(ФормаОтчета);
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДоступностьЭлементов()
	
	Элементы.НастроитьПодключение.Доступность			= НаборКонстант.ИспользоватьВнешнееПодписание;
	Элементы.Сопоставить.Доступность					= НаборКонстант.ИспользоватьВнешнееПодписание;
	Элементы.ГруппаНастройкиПодключения.Доступность		= НаборКонстант.ИспользоватьВнешнееПодписание;
	Элементы.ГруппаСоответствия.Доступность				= НаборКонстант.ИспользоватьВнешнееПодписание;
	
КонецПроцедуры

#КонецОбласти
