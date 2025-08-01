﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Проверяет разрешения пользователя на создание документа по виду и тематике.
//
// Параметры:
//  ВидДокумента - СправочникСсылка.ВидыДокументов - вид документа.
//  Тематика - СправочникСсылка.ТематикиДокументов - тематика.
//  Пользователь - СправочникСсылка.Пользователи - пользователь.
//
// Возвращаемое значение:
//  Булево - признак наличия разрешения.
//
Функция ЕстьРазрешениеНаСоздание(ВидДокумента, Тематика, Знач Пользователь = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если Пользователи.ЭтоПолноправныйПользователь(Пользователь,, Ложь) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ДокументооборотИспользоватьОграничениеПравДоступа") Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК ЕстьРазрешение
		|ИЗ
		|	РегистрСведений.РазрешенияНаСозданиеДокументов КАК РазрешенияНаСозданиеДокументов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СотрудникиВКонтейнерах КАК СотрудникиВКонтейнерах
		|		ПО РазрешенияНаСозданиеДокументов.Участник = СотрудникиВКонтейнерах.Контейнер
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
		|		ПО (СотрудникиВКонтейнерах.Сотрудник = СоставСубъектовПравДоступа.Субъект)
		|ГДЕ
		|	РазрешенияНаСозданиеДокументов.ВидДокумента = &ВидДокумента
		|	И РазрешенияНаСозданиеДокументов.Тематика В (&Тематика, ЗНАЧЕНИЕ(Справочник.ТематикиДокументов.ПустаяСсылка))
		|	И СоставСубъектовПравДоступа.Сотрудник В(&ВсеСотрудникиПользователя)
		|	И СоставСубъектовПравДоступа.ИмяОбластиДелегирования В ("""", ""Документы"", ""ДокументыПросмотрИРедактирование"")
		|	И НЕ РазрешенияНаСозданиеДокументов.Участник.ПометкаУдаления
		|	И НЕ СоставСубъектовПравДоступа.СотрудникПометкаУдаления
		|	И НЕ СоставСубъектовПравДоступа.СубъектПометкаУдаления");
	Запрос.УстановитьПараметр("ВидДокумента", ВидДокумента);
	Запрос.УстановитьПараметр("Тематика", Тематика);
	
	Запрос.УстановитьПараметр(
		"ВсеСотрудникиПользователя",
		Сотрудники.СотрудникиПользователя(Пользователь));
	
	ЕстьРазрешение = Не Запрос.Выполнить().Пустой();
	
	Возврат ЕстьРазрешение;
	
КонецФункции

Процедура ДобавитьРазрешениеНаСоздание(ВидДокумента, Участник, Знач Тематика = Неопределено) Экспорт
	
	Если Тематика = Неопределено Тогда
		Тематика = Справочники.ТематикиДокументов.ПустаяСсылка();
	КонецЕсли;
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.ВидДокумента = ВидДокумента;
	Запись.Участник = Участник;
	Запись.Тематика = Тематика;
	Запись.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли