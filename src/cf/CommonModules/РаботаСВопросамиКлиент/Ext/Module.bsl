﻿////////////////////////////////////////////////////////////////////////////////
// Работа с вопросами (клиент).
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму для просмотра вопросов по предмету рассмотрения.
//
// Параметры:
//  Задача - ЗадачаСсылка.ЗадачаИсполнителя, ДокументСсылка.Задача, ДокументСсылка.ДействиеЗадачи.
//
Процедура ПоказатьВопросы(Задача) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Задача", Задача);
	
	ОткрытьФорму(
		"БизнесПроцесс.РешениеВопросовВыполненияЗадач.Форма.ВопросыВыполненияЗадачи",
		ПараметрыФормы);
	
КонецПроцедуры

// Открывает форму для создания вопроса по предмету рассмотрения.
//
// Параметры:
//  Задача - ЗадачаСсылка.ЗадачаИсполнителя, ДокументСсылка.Задача, ДокументСсылка.ДействиеЗадачи.
//
Процедура СоздатьВопрос(Задача) Экспорт
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить(
		"Задача",
		Задача);
	ЗначенияЗаполнения.Вставить(
		"ВидВопроса",
		ПредопределенноеЗначение("Перечисление.ВидыВопросовВыполненияЗадач.Иное"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить(
		"ЗначенияЗаполнения",
		ЗначенияЗаполнения);
	
	ОткрытьФорму(
		"БизнесПроцесс.РешениеВопросовВыполненияЗадач.ФормаОбъекта",
		ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти