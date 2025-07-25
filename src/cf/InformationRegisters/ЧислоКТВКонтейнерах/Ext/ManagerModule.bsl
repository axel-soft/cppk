﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбновитьЧислоКТПоГруппе(ГруппаКТ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК ЧислоКТ
		|ИЗ
		|	Справочник.КонтрольныеТочки КАК КонтрольныеТочки
		|ГДЕ
		|	КонтрольныеТочки.ГруппаКТ = &ГруппаКТ
		|	И КонтрольныеТочки.ПометкаУдаления = Ложь";
	
	Запрос.УстановитьПараметр("ГруппаКТ", ГруппаКТ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		МенеджерЗаписи = РегистрыСведений.ЧислоКТВКонтейнерах.СоздатьМенеджерЗаписи();
		
		МенеджерЗаписи.КонтейнерКТ = ГруппаКТ;
		МенеджерЗаписи.ЧислоКТ = ВыборкаДетальныеЗаписи.ЧислоКТ;
		
		МенеджерЗаписи.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЧислоКТПоОбъекту(ОбъектКТ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК ЧислоКТ
		|ИЗ
		|	Справочник.КонтрольныеТочки КАК КонтрольныеТочки
		|ГДЕ
		|	КонтрольныеТочки.ОбъектКТ = &ОбъектКТ
		|	И КонтрольныеТочки.ПометкаУдаления = Ложь";
	
	Запрос.УстановитьПараметр("ОбъектКТ", ОбъектКТ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		МенеджерЗаписи = РегистрыСведений.ЧислоКТВКонтейнерах.СоздатьМенеджерЗаписи();
		
		МенеджерЗаписи.КонтейнерКТ = ОбъектКТ;
		МенеджерЗаписи.ЧислоКТ = ВыборкаДетальныеЗаписи.ЧислоКТ;
		
		МенеджерЗаписи.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЧислоКТПоШаблонуГруппы(ГруппаКТ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК ЧислоКТ
		|ИЗ
		|	Справочник.ШаблоныКонтрольныхТочек КАК КонтрольныеТочки
		|ГДЕ
		|	КонтрольныеТочки.ГруппаКТ = &ГруппаКТ
		|	И КонтрольныеТочки.ПометкаУдаления = Ложь";
	
	Запрос.УстановитьПараметр("ГруппаКТ", ГруппаКТ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		МенеджерЗаписи = РегистрыСведений.ЧислоКТВКонтейнерах.СоздатьМенеджерЗаписи();
		
		МенеджерЗаписи.КонтейнерКТ = ГруппаКТ;
		МенеджерЗаписи.ЧислоКТ = ВыборкаДетальныеЗаписи.ЧислоКТ;
		
		МенеджерЗаписи.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЧислоКТПоШаблону(ОбъектКТ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК ЧислоКТ
		|ИЗ
		|	Справочник.ШаблоныКонтрольныхТочек КАК КонтрольныеТочки
		|ГДЕ
		|	КонтрольныеТочки.ОбъектКТ = &ОбъектКТ
		|	И КонтрольныеТочки.ПометкаУдаления = Ложь";
	
	Запрос.УстановитьПараметр("ОбъектКТ", ОбъектКТ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		МенеджерЗаписи = РегистрыСведений.ЧислоКТВКонтейнерах.СоздатьМенеджерЗаписи();
		
		МенеджерЗаписи.КонтейнерКТ = ОбъектКТ;
		МенеджерЗаписи.ЧислоКТ = ВыборкаДетальныеЗаписи.ЧислоКТ;
		
		МенеджерЗаписи.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьЧислоКТПоКонтейнеру(Контейнер) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЧислоКТВКонтейнерах.ЧислоКТ
		|ИЗ
		|	РегистрСведений.ЧислоКТВКонтейнерах КАК ЧислоКТВКонтейнерах
		|ГДЕ
		|	ЧислоКТВКонтейнерах.КонтейнерКТ = &КонтейнерКТ";
	
	Запрос.УстановитьПараметр("КонтейнерКТ", Контейнер);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.ЧислоКТ;
	КонецЕсли;;
	
	Возврат 0;
	
КонецФункции

#КонецЕсли
