﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает признак использования легкой почты.
//
Функция ПолучитьИспользованиеЛегкойПочты(Знач Пользователь = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Запись = РегистрыСведений.ИспользованиеПочты.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Прочитать();
	
	Если Не Запись.Выбран() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Запись.НастройкаИспользоватьЛегкуюПочту;
	
КонецФункции

// Возвращает признак использования встроенной почты.
//
Функция ПолучитьИспользованиеВстроеннойПочты(Знач Пользователь = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Запись = РегистрыСведений.ИспользованиеПочты.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Прочитать();
	
	Если Не Запись.Выбран() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Запись.НастройкаИспользоватьВстроеннуюПочту;
	
КонецФункции

// Устанавливает признаки использования легкой и встроенной почты.
//
Процедура УстановитьИспользованиеПочты(ИспользоватьЛегкуюПочту, ИспользоватьВстроеннуюПочту, Знач Пользователь = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	КонстантаИспользоватьВстроеннуюПочту = Константы.ИспользоватьВстроеннуюПочту.Получить();
	
	Запись = РегистрыСведений.ИспользованиеПочты.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Прочитать();
	
	Запись.Пользователь = Пользователь;
	Запись.НастройкаИспользоватьЛегкуюПочту = ИспользоватьЛегкуюПочту;
	Запись.НастройкаИспользоватьВстроеннуюПочту = ИспользоватьВстроеннуюПочту;
	Запись.ИспользоватьЛегкуюПочту = ИспользоватьЛегкуюПочту;
	Запись.ИспользоватьВстроеннуюПочту = ИспользоватьВстроеннуюПочту И КонстантаИспользоватьВстроеннуюПочту;
	Запись.Записать(Истина);
	
КонецПроцедуры

// Обновляет записи регистра сведений. Пересчитывает признак использования встроенной почты
// с учетом значения константы ИспользоватьВстроеннуюПочту.
//
Процедура ОбновитьИспользованиеПочты() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КонстантаИспользоватьВстроеннуюПочту = Константы.ИспользоватьВстроеннуюПочту.Получить();
	Набор = РегистрыСведений.ИспользованиеПочты.СоздатьНаборЗаписей();
	Набор.Прочитать();
	Для каждого Запись Из Набор Цикл
		Запись.ИспользоватьВстроеннуюПочту = Запись.НастройкаИспользоватьВстроеннуюПочту И КонстантаИспользоватьВстроеннуюПочту;
		Запись.ИспользоватьЛегкуюПочту = Запись.НастройкаИспользоватьЛегкуюПочту;
	КонецЦикла;
	Набор.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли