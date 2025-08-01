﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СвойстваПодписи = ЭлектроннаяПодписьКлиентСервер.РезультатПроверкиПодписиВФорме();
	ЗаполнитьЗначенияСвойств(СвойстваПодписи, Параметры.СвойстваПодписи);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СвойстваПодписи);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СвойстваПодписи.РезультатПроверки);
	
	Если Параметры.СвойстваПодписи.Свойство("Объект") Тогда
		ПодписанныйОбъект = Параметры.СвойстваПодписи.Объект;
	КонецЕсли;
	
	Элементы.ГруппаМЧД.Видимость = Ложь;
	
	// Локализация
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.МашиночитаемыеДоверенности") Тогда
		МодульМашиночитаемыеДоверенностиФНССлужебный = ОбщегоНазначения.ОбщийМодуль(
			"МашиночитаемыеДоверенностиФНССлужебный");
		Если Параметры.СвойстваПодписи.Свойство("МашиночитаемаяДоверенность") И ЗначениеЗаполнено(
			Параметры.СвойстваПодписи.МашиночитаемаяДоверенность) Тогда
			Элементы.ГруппаМЧД.Видимость = Истина;
			Элементы.МашиночитаемаяДоверенностьДекорация.Заголовок = Параметры.СвойстваПодписи.МашиночитаемаяДоверенность;
			МодульМашиночитаемыеДоверенностиФНССлужебный.ЗаполнитьПротоколПроверки(ЭтотОбъект, Элементы.ГруппаПротоколПроверки,
				Параметры.СвойстваПодписи.РезультатПроверкиПодписиПоМЧД);
		КонецЕсли;
	КонецЕсли;
	
	// Конец Локализация
	
	Элементы.ОбоснованиеРучнойПроверкиДополнительныхАтрибутов.Видимость = ЗначениеЗаполнено(ОбоснованиеРучнойПроверкиДополнительныхАтрибутов)
		И СтрДлина(ОбоснованиеРучнойПроверкиДополнительныхАтрибутов) > 100;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ОписаниеОшибки");
		Элементы.Инструкция.Видимость     = 
			ЭлектроннаяПодписьСлужебный.ВидимостьСсылкиНаИнструкциюПоТипичнымПроблемамПриРаботеСПрограммами();
	ИначеЕсли ЗначениеЗаполнено(ОбоснованиеРучнойПроверкиДополнительныхАтрибутов) Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "РучнаяПроверка");
		Элементы.Инструкция.Видимость     = Ложь;
	Иначе
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "");
		Элементы.Инструкция.Видимость     = Ложь;
	КонецЕсли;
	
	Если Не ЭтоАдресВременногоХранилища(АдресПодписи) Тогда
		Возврат;
	КонецЕсли;
	
	АлгоритмПодписиНеСоответствуетГОСТ = "";
	АлгоритмПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.АлгоритмСформированнойПодписи(
		АдресПодписи, Истина, Ложь, АлгоритмПодписиНеСоответствуетГОСТ);
		
	Если ЗначениеЗаполнено(АлгоритмПодписиНеСоответствуетГОСТ) Тогда
		АлгоритмПодписи = АлгоритмПодписиНеСоответствуетГОСТ;
		Элементы.АлгоритмПодписи.Видимость = Ложь;
		Элементы.АлгоритмПодписиПредупреждение.Видимость = Истина;
	Иначе
		Элементы.АлгоритмПодписи.Видимость = Истина;
		Элементы.АлгоритмПодписиПредупреждение.Видимость = Ложь;
	КонецЕсли;
	
	АлгоритмХеширования = ЭлектроннаяПодписьСлужебныйКлиентСервер.АлгоритмХеширования(
		АдресПодписи, Истина);
	
	Если ЗначениеЗаполнено(Статус) Тогда
		Элементы.ДекорацияСтатус.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Статус на %1: %2'"), ДатаПроверкиПодписи, Статус);
	Иначе
		Элементы.ДекорацияСтатус.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Статус на %1: %2'"), ДатаПроверкиПодписи, РезультатПроверкиКраткий);
	КонецЕсли;
	
	Элементы.ОписаниеОшибки.Видимость = Не ПустаяСтрока(ОписаниеОшибки);
	Элементы.Комментарий.Видимость = Не ПустаяСтрока(Комментарий);
	
	Элементы.ГруппаОшибкаМатематическойПроверки.Видимость   = Не ПустаяСтрока(ОшибкаМатематическойПроверкиПодписи);
	Элементы.ГруппаОшибкаПроверкиДополнительныхАтрибутов.Видимость = Не ПустаяСтрока(ОшибкаПроверкиДополнительныхАтрибутов);
	
	ОбновитьДанныеФормы();
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнструкцияНажатие(Элемент)
	
	ЭлектроннаяПодписьКлиент.ОткрытьИнструкциюПоТипичнымПроблемамПриРаботеСПрограммами();
	
КонецПроцедуры

// Локализация

&НаКлиенте
Процедура Подключаемый_КомандаОтметитьВручную(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.МашиночитаемыеДоверенности") Тогда
		МодульМашиночитаемыеДоверенностиФНССлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"МашиночитаемыеДоверенностиФНССлужебныйКлиент");
		МодульМашиночитаемыеДоверенностиФНССлужебныйКлиент.ДобавитьОтметкуДоверенностьВерна(ЭтотОбъект, Элемент.Имя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.МашиночитаемыеДоверенности") Тогда
		МодульМашиночитаемыеДоверенностиФНССлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"МашиночитаемыеДоверенностиФНССлужебныйКлиент");
		МодульМашиночитаемыеДоверенностиФНССлужебныйКлиент.ПриОбработкеНавигационнойСсылкиОшибкиПроверкиПодписи(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// Конец Локализация

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьВФайл(Команда)
	
	ЭлектроннаяПодписьКлиент.СохранитьПодпись(АдресПодписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификат(Команда)
	
	Если ЗначениеЗаполнено(АдресСертификата) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(АдресСертификата);
		
	ИначеЕсли ЗначениеЗаполнено(Отпечаток) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(Отпечаток);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификатДляПроверкиПодписи(Команда)
	
	Если Не СвойстваПрочитаны Или ЗначениеЗаполнено(ОшибкаЧтенияПодписи) Тогда
		ЭлектроннаяПодписьКлиент.ПрочитатьСвойстваПодписи(
			Новый ОписаниеОповещения("ПослеЧтенияСвойствПодписи", ЭтотОбъект), АдресПодписи);
		Возврат;
	Иначе
		ОткрытьПрочитанныйСертификат();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродлитьДействиеПодписи(Команда)
	
	ОбработчикПродолжения = Новый ОписаниеОповещения("ПослеУсовершенствованияПодписи", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипПодписи", ТипПодписи);
	ПараметрыФормы.Вставить("ПредставлениеДанных", 
		СтрШаблон("%1, %2, %3", КомуВыданСертификат, ДатаПодписи, ТипПодписи));
		
	Если ЗначениеЗаполнено(ПодписанныйОбъект) Тогда
		Структура = Новый Структура;
		Структура.Вставить("Подпись", АдресПодписи);
		Структура.Вставить("ПодписанныйОбъект", ПодписанныйОбъект);
		Структура.Вставить("ПорядковыйНомер", ПорядковыйНомер); 
		ПараметрыФормы.Вставить("Подпись", Структура);
	Иначе
		ПараметрыФормы.Вставить("Подпись", АдресПодписи);
	КонецЕсли;
	
	ЭлектроннаяПодписьКлиент.ОткрытьФормуПродленияДействияПодписей(ЭтотОбъект, ПараметрыФормы, ОбработчикПродолжения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОписаниеОшибкиМатематическойПроверки(Команда)
	
	ОткрытьОписаниеОшибки(ОшибкаМатематическойПроверкиПодписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОписаниеОшибкиДополнительныхАтрибутов(Команда)
	
	ОткрытьОписаниеОшибки(ОшибкаПроверкиДополнительныхАтрибутов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьОписаниеОшибки(ТекстОшибки)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗаголовокПредупреждения", НСтр("ru = 'Ошибка проверки подписи'"));
	ПараметрыФормы.Вставить("ТекстОшибкиКлиент", ТекстОшибки);
	
	ДополнительныеПараметры = Новый Структура;
	
	Если ЗначениеЗаполнено(АдресСертификата) Тогда
		ДополнительныеПараметры.Вставить("ДанныеСертификата",
			АдресСертификата);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресПодписи) Тогда
		ДополнительныеПараметры.Вставить("ДанныеПодписи",
			АдресПодписи);
	КонецЕсли;
		
	ПараметрыФормы.Вставить("ДополнительныеДанные", ДополнительныеПараметры);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОткрытьФормуРасширенногоПредставленияОшибки(ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФормы()
	
	Если ЭлектроннаяПодпись.ДоступнаУсовершенствованнаяПодпись() И ЭлектроннаяПодпись.ДобавлениеИзменениеЭлектронныхПодписей() Тогда
		Если (ЗначениеЗаполнено(СрокДействияПоследнейМеткиВремени) И СрокДействияПоследнейМеткиВремени <= ТекущаяДатаСеанса())
			Или ТипПодписи = Перечисления.ТипыПодписиКриптографии.ОбычнаяCMS Или Не ПодписьВерна Тогда
			Элементы.ФормаПродлитьДействиеПодписи.Видимость = Ложь;
		Иначе
			Элементы.ФормаПродлитьДействиеПодписи.Видимость = Истина;
		КонецЕсли;
	Иначе
		Элементы.ФормаПродлитьДействиеПодписи.Видимость = Ложь;
	КонецЕсли;
		
	Если ТипПодписи = Перечисления.ТипыПодписиКриптографии.БазоваяCAdESBES
		Или ТипПодписи = Перечисления.ТипыПодписиКриптографии.ОбычнаяCMS Тогда
		Если ЗначениеЗаполнено(СрокДействияПоследнейМеткиВремени) Тогда
			Элементы.СрокДействияПоследнейМеткиВремени.Заголовок = НСтр("ru='Срок действия сертификата подписи истек'"); 
		Иначе
			Элементы.СрокДействияПоследнейМеткиВремени.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.СрокДействияПоследнейМеткиВремени.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУсовершенствованияПодписи(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Успех Тогда
		
		Для Каждого КлючИЗначение Из Результат.СвойстваПодписей[0].СвойстваПодписи Цикл
			Если КлючИЗначение.Ключ = "Подпись" Тогда
				АдресПодписи = ПоместитьВоВременноеХранилище(КлючИЗначение.Значение);
				Продолжить;
			КонецЕсли;
			Если КлючИЗначение.Значение = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если Элементы.Найти(КлючИЗначение.Ключ) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ЭтотОбъект[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
		КонецЦикла;
		
		ОбновитьДанныеФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ПослеЧтенияСвойствПодписи(Результат, ДополнительныеПараметры) Экспорт
	
	СвойстваПрочитаны = Истина;
	
	Если Результат.Успех = Истина Тогда
		ОшибкаЧтенияПодписи = "";
		ЕстьСертификатПодписи = Ложь;
		Для Каждого ДанныеСертификата Из Результат.Сертификаты Цикл
			
			НоваяСтрока = СертификатыДляПроверкиПодписи.Добавить();
			
			СертификатКриптографии = Новый СертификатКриптографии;
			Ждать СертификатКриптографии.ИнициализироватьАсинх(ДанныеСертификата);
			СвойстваСертификата = Ждать ЭлектроннаяПодписьСлужебныйКлиент.СвойстваСертификата(СертификатКриптографии);
			НоваяСтрока.КомуВыдан = СвойстваСертификата.Представление;
			НоваяСтрока.ДанныеСертификата = ПоместитьВоВременноеХранилище(ДанныеСертификата, УникальныйИдентификатор);
			Если ДанныеСертификата = Результат.Сертификат Тогда
				НоваяСтрока.ЭтоСертификатПодписи = Истина;
				ЕстьСертификатПодписи = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
		Если Не ЕстьСертификатПодписи И ЗначениеЗаполнено(Результат.Сертификат) Тогда
			
			НоваяСтрока = СертификатыДляПроверкиПодписи.Добавить();
			
			СертификатКриптографии = Новый СертификатКриптографии;
			Ждать СертификатКриптографии.ИнициализироватьАсинх(Результат.Сертификат);
			СвойстваСертификата = Ждать ЭлектроннаяПодписьСлужебныйКлиент.СвойстваСертификата(СертификатКриптографии);
			НоваяСтрока.КомуВыдан = СвойстваСертификата.Представление;
			НоваяСтрока.ДанныеСертификата = ПоместитьВоВременноеХранилище(Результат.Сертификат, УникальныйИдентификатор);
			НоваяСтрока.ЭтоСертификатПодписи = Истина;
			
		КонецЕсли;
	ИначеЕсли Результат.Успех = Неопределено Тогда
		ОшибкаЧтенияПодписи = НСтр("ru='Не удалось получить сертификаты из подписи, проверьте настройки приложений электронной подписи.'");
	Иначе
		ОшибкаЧтенияПодписи = Результат.ТекстОшибки;
	КонецЕсли;
		
	СертификатыДляПроверкиПодписи.Сортировать("ЭтоСертификатПодписи Убыв");
	ОткрытьПрочитанныйСертификат();
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ОткрытьПрочитанныйСертификат()
	
	Если ЗначениеЗаполнено(ОшибкаЧтенияПодписи) Тогда
		ПоказатьПредупреждение(, ОшибкаЧтенияПодписи);
		Возврат;
	КонецЕсли;
	
	Количество = СертификатыДляПроверкиПодписи.Количество();
	
	Если Количество > 1 Тогда
		
		СписокЗначений = Новый СписокЗначений();
		Для Каждого Сертификат Из СертификатыДляПроверкиПодписи Цикл
			
			Если Сертификат.ЭтоСертификатПодписи Тогда
				Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Сертификат подписанта: %1'"), Сертификат.КомуВыдан);
			Иначе
				Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Сертификат для проверки подписи: %1'"), Сертификат.КомуВыдан);
			КонецЕсли;
			
			СписокЗначений.Добавить(Сертификат.ДанныеСертификата, Представление);
				
		КонецЦикла;
		
		Выбрано = Ждать СписокЗначений.ВыбратьЭлементАсинх(НСтр("ru='Выберите сертификат'"));

		Если Выбрано <> Неопределено Тогда
			ЭлектроннаяПодписьКлиент.ОткрытьСертификат(Выбрано.Значение);
		КонецЕсли;
		
	ИначеЕсли Количество = 1 Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(СертификатыДляПроверкиПодписи[0].ДанныеСертификата);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
