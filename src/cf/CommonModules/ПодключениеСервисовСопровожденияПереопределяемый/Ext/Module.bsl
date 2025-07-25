﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет список модулей библиотек и конфигурации, которые предоставляют
// основные сведения о сервисах: идентификатор, наименование, описание и картинка.
// Модуль должен обязательно содержать процедуру ПриДобавленииОписанийСервисовСопровождения.
// Пример см. СПАРКРиски.ПриДобавленииОписанийСервисовСопровождения.
//
// Параметры:
//  МодулиСервисов - Массив из Строка - имена серверных общих модулей библиотек и конфигурации.
//
// Пример:
//  МодулиСервисов.Добавить("СПАРКРиски");
//  МодулиСервисов.Добавить("РаботаСКонтрагентами");
//
//@skip-warning
Процедура ПриОпределенииСервисовСопровождения(МодулиСервисов) Экспорт
	
	// МашинноеОбучение.РаботаСРечью
	МодулиСервисов.Добавить("РаботаСРечьюБМОСервер");
	// Конец МашинноеОбучение.РаботаСРечью
	
	// Распознавание
	МодулиСервисов.Добавить("Распознавание");
	// Конец РаспознаваниеДокументов
	
КонецПроцедуры

#КонецОбласти
