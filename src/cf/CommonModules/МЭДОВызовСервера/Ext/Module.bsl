﻿// @strict-types

#Область ПрограммныйИнтерфейс

// Отправить исходящие документы. Либо все готовые к отправке, либо заданные.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - Организация.
//  ДанныеОтвета - см. МЭДОСтруктурыДанных.НовыйЛегкийОтвет.
//  МассивДокументов - Массив из ОпределяемыйТип.ПредметМЭДО - Массив документов
Процедура ОтправитьИсходящиеДокументы(Знач Организация, ДанныеОтвета, Знач МассивДокументов = Неопределено) Экспорт
	
	Настройки = РегистрыСведений.НастройкиОрганизацийМЭДО.НастройкиОрганизации(Организация, ДанныеОтвета);
	Если Не ДанныеОтвета.Успех Тогда
		Возврат;
	КонецЕсли;
	
	МЭДО.ОтправитьИсходящиеДокументы(Настройки, ДанныеОтвета, МассивДокументов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Читает сообщения по входящим документам.
//
// Параметры:
//   Организация - ОпределяемыйТип.Организация - Для этой организации, согласно ее настройкам каталога получения
Процедура ПолучитьВходящиеДокументы(Знач Организация) Экспорт
	
	ДанныеОтвета = МЭДОСтруктурыДанных.НовыйЛегкийОтвет();
	Настройки = РегистрыСведений.НастройкиОрганизацийМЭДО.НастройкиОрганизации(Организация, ДанныеОтвета);
	Если Не ДанныеОтвета.Успех Тогда
		Возврат;
	КонецЕсли;
	
	МЭДО.ПолучитьВходящиеСообщения(Настройки, "Транспортный контейнер, Документ");
	
КонецПроцедуры

// Читает сообщения по уведомлениям и квитанциям.
// Параметры:
//   Организация - ОпределяемыйТип.Организация - Для этой организации, согласно ее настройкам каталога получения
Процедура ПолучитьВходящиеУведомленияКвитанции(Знач Организация) Экспорт
	
	ДанныеОтвета = МЭДОСтруктурыДанных.НовыйЛегкийОтвет();
	Настройки = РегистрыСведений.НастройкиОрганизацийМЭДО.НастройкиОрганизации(Организация, ДанныеОтвета);
	Если Не ДанныеОтвета.Успех Тогда
		Возврат;
	КонецЕсли;
	
	МЭДО.ПолучитьВходящиеСообщения(Настройки, "Уведомление, Квитанция");
	
КонецПроцедуры

// Процедура - Записывает сообщения по исходящим квитанциям.
//
// Параметры:
//   Организация - ОпределяемыйТип.Организация - Организация.
//  ДанныеОтвета - см. МЭДОСтруктурыДанных.НовыйЛегкийОтвет
//  МассивКвитанций - Массив из ДокументСсылка.КвитанцияМЭДО - Отбор по выбранным квитанциям
//  				- Неопределено - Если Неопределено, то все, подлежащие отправке по этой организации 
Процедура ОтправитьИсходящиеКвитанции(Знач Организация, ДанныеОтвета, Знач МассивКвитанций = Неопределено) Экспорт
	
	ДанныеОтвета = МЭДОСтруктурыДанных.НовыйЛегкийОтвет();
	Настройки = РегистрыСведений.НастройкиОрганизацийМЭДО.НастройкиОрганизации(Организация, ДанныеОтвета);
	Если Не ДанныеОтвета.Успех Тогда
		Возврат;
	КонецЕсли;
	
	МЭДО.ОтправитьИсходящиеКвитанции(Настройки, ДанныеОтвета, МассивКвитанций);
	
КонецПроцедуры

// Записывает сообщения по уведомлениям. Либо все готовые к отправке, либо заданные.
//
// Параметры:
//  Организация - ОпределяемыйТип.Организация - Организация.
//  ДанныеОтвета - см. МЭДОСтруктурыДанных.НовыйЛегкийОтвет.
//  МассивУведомлений	 - Массив из ДокументСсылка.УведомлениеМЭДО - массив уведомлений.
Процедура ОтправитьИсходящиеУведомления(Знач Организация, ДанныеОтвета, Знач МассивУведомлений) Экспорт
	
	Настройки = РегистрыСведений.НастройкиОрганизацийМЭДО.НастройкиОрганизации(Организация, ДанныеОтвета);
	Если Не ДанныеОтвета.Успех Тогда
		Возврат;
	КонецЕсли;
	
	МЭДО.ОтправитьИсходящиеУведомления(Настройки, ДанныеОтвета, МассивУведомлений);
	
КонецПроцедуры

#Область ПереопределяемыеТипы

// Пустая ссылка на сотрудника нашей организации - зависит от конфигурации.
// 
// Возвращаемое значение:
//  ОпределяемыйТип.КонтактноеЛицоМЭДО
Функция СотрудникПустаяСсылка() Экспорт
	
	Возврат МЭДОПереопределяемый.СотрудникПустаяСсылка();
	
КонецФункции

// Пустая ссылка на контактное лицо - зависит от конфигурации.
// 
// Возвращаемое значение:
//  ОпределяемыйТип.КонтактноеЛицоМЭДО
Функция КонтактноеЛицоПустаяСсылка() Экспорт
	
	Возврат МЭДОПереопределяемый.КонтактноеЛицоПустаяСсылка();
	
КонецФункции

// Тип "Контрагенты" - зависит от конфигурации.
// 
// Возвращаемое значение:
//  Тип
Функция ТипКонтрагенты() Экспорт
	
	Возврат МЭДОПереопределяемый.ТипКонтрагенты();
	
КонецФункции

#КонецОбласти

#КонецОбласти
