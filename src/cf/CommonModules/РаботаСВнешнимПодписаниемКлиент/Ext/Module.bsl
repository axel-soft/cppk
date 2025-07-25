﻿// @strict-types


#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму записи регистра, где хранится идентификатор, если записи нет, открывает форму новой записи.
// 
// Параметры:
//  Объект - СправочникСсылка.Организации, СправочникСсылка.ФизическиеЛица -
//
Процедура СопоставлениеОбъекта(Объект) Экспорт
	
	ОткрытьФорму("РегистрСведений.ИдентификаторыОбъектовВСервисахВнешнегоПодписания.ФормаЗаписи",
		ПараметрыФормыЗаписиИдентификаторыОбъектов(Объект));
	
КонецПроцедуры

// Проверить подключенине к сервису кабинет сотрудника.
// 
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения
//  АдресПриложения      - Строка - Адрес приложения
//  ИдентификаторКлиента - Строка - Идентификатор клиента
//  СекретКлиента        - Строка - Секрет клиента
//
Процедура НачатьПроверкуПодключенияКСервисуКабинетСотрудника(Форма, АдресПриложения, ИдентификаторКлиента, СекретКлиента) Экспорт
	
	ПодключениеУстановлено = РаботаСВнешнимПодписаниемВызовСервера.ПроверитьПодключениеКСервисуКабинетСотрудника(
		АдресПриложения,
		ИдентификаторКлиента,
		СекретКлиента);
	
	Если ПодключениеУстановлено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Подключение установлено успешно'"));
		Возврат;
	КонецЕсли;
	
	ПоказатьПредупреждение(, НСтр("ru = 'Подключение не установлено, проверьте корректность указанных данных.'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры формы записи идентификаторы объектов.
// 
// Параметры:
//  Объект - СправочникСсылка.Организации, СправочникСсылка.ФизическиеЛица -
// 
// Возвращаемое значение:
//  Структура
//
Функция ПараметрыФормыЗаписиИдентификаторыОбъектов(Объект)
	
	ЗначенияКлюча = Новый Структура;
	ЗначенияКлюча.Вставить("Сервис", ПредопределенноеЗначение("Справочник.СервисыВнешнегоПодписания.КабинетСотрудника"));
	ЗначенияКлюча.Вставить("Объект", Объект);
	
	КлючЗаписи = КлючЗаписиРегистраИдентификаторов(ЗначенияКлюча);
	
	ПараметрыФормы = Новый Структура;
	
	Если КлючЗаписи = Неопределено Тогда
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияКлюча);
		Возврат ПараметрыФормы;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Ключ", КлючЗаписи);
	Возврат ПараметрыФормы;
	
КонецФункции

Функция КлючЗаписиРегистраИдентификаторов(ЗначенияКлюча)
	
	Возврат РаботаСВнешнимПодписаниемВызовСервера.ПолучитьКлючЗаписиРегистраИдентификаторов(ЗначенияКлюча);
	
КонецФункции

#КонецОбласти
