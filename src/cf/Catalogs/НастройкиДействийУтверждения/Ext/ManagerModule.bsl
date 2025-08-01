﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет дерево обработки участниками действия.
// 
// Параметры:
// 	ЭлементыДействия - ДанныеФормыЭлементДерева - коллекцию элементов дерева
// 	ЗначенияЗаполнения - Структура:
// 	 ВидДействия - СправочникСсылка.ВидыДействий - вид действия.
//	 Настройка - СправочникСсылка.НастройкиДействийУтверждения - ссылка на настройку действия. 
//	 НастройкаВключена - Булево - Истина, если включена.
//
Процедура ДополнитьДеревоПредставлениемНастройки(ЭлементыДействия, ЗначенияЗаполнения) Экспорт
	
	Настройка = ЗначенияЗаполнения.Настройка;
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Настройка,
		"Автор, ВидДействия, ВидДействия.Наименование, Участники");
	
	ЭлементДействия = ЭлементыДействия.Добавить();
	ЗаполнитьЗначенияСвойств(ЭлементДействия, ЗначенияЗаполнения);
	ЭлементДействия.ЭтоДействие = Истина;
	ЭлементДействия.Представление = Реквизиты.ВидДействияНаименование;
	Участники = Реквизиты.Участники.Выгрузить();
	Участники.Сортировать("НомерСтроки");
	// Участник "Участник".
	Для Каждого Участник Из Участники Цикл
		Если Участник.ФункцияУчастника = ПредопределенноеЗначение(
			"Перечисление.ФункцииУчастниковУтверждения.ОбрабатывающийРезультат") Тогда
			Продолжить;
		КонецЕсли;
		
		ПодчиненныеЭлементы = ЭлементДействия.ПолучитьЭлементы();
		ПодчиненныйЭлемент = ПодчиненныеЭлементы.Добавить();
		ЗаполнитьЗначенияСвойств(ПодчиненныйЭлемент, ЗначенияЗаполнения);
		ПодчиненныйЭлемент.ЭтоУчастник = Истина;
		ПодчиненныйЭлемент.СрокИсполненияДни = Участник.СрокДни;
		ПодчиненныйЭлемент.СрокИсполненияМинуты = Участник.СрокМинуты;
		ПодчиненныйЭлемент.СрокИсполненияЧасы = Участник.СрокЧасы;
		ПодчиненныйЭлемент.ВариантУстановкиСрокаИсполнения = Участник.ВариантУстановкиСрока;
		ПодчиненныйЭлемент.Участник = Участник.Участник;
		ПодчиненныйЭлемент.Представление = ПодчиненныйЭлемент.Участник;
		ПодчиненныйЭлемент.УсловиеПредставление = Участник.Условие;
		ПодчиненныйЭлемент.СрокПредставление = 
			СрокиИсполненияПроцессовКлиентСервер.ПредставлениеСрокаИсполнения(
				Участник.Срок,
				Участник.СрокДни,
				Участник.СрокЧасы,
				Участник.СрокМинуты,
				ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач"),
				Участник.ВариантУстановкиСрока);
				
	КонецЦикла;
	
КонецПроцедуры

// Возвращает всех участников настройки действия
// 
// Параметры:
// 	НастройкаДействия - СправочникСсылка.НастройкиДействийУтверждения - ссылка на действие
// 	
// Возвращаемое значение:
// 	ТаблицаЗначений - таблица участников действия.
// 
Функция ВсеУчастники(НастройкаДействия) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	НастройкиДействийУтверждения.Участник КАК Участник,
		|	ЗНАЧЕНИЕ(Перечисление.ФункцииУчастниковУтверждения.Утверждающий) КАК Функция
		|ИЗ
		|	Справочник.НастройкиДействийУтверждения КАК НастройкиДействийУтверждения
		|ГДЕ
		|	НастройкиДействийУтверждения.Ссылка = &НастройкаДействия
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НастройкиДействийУтверждения.Автор,
		|	ЗНАЧЕНИЕ(Перечисление.ФункцииУчастниковУтверждения.ОбрабатывающийРезультат)
		|ИЗ
		|	Справочник.НастройкиДействийУтверждения КАК НастройкиДействийУтверждения
		|ГДЕ
		|	НастройкиДействийУтверждения.Ссылка = &НастройкаДействия");
	
	Запрос.УстановитьПараметр("НастройкаДействия", НастройкаДействия);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Возвращает разрешения по действию в виде соответствия
// 
// Параметры:
// 	НастройкаДействия - СправочникСсылка.НастройкиДействийУтверждения - ссылка на действие
// 	
// Возвращаемое значение:
// 	Соответствие - разрешения по действию.
// 
Функция РазрешенияИзмененияУчастников(НастройкаДействия) Экспорт
	
	РеквизитыНастройки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаДействия,
		 "ВозможностьИзменятьУчастников, Участники");
	
	// Для режима Авто смотрим на Участников. Если участники заданы, то запрещено менять
	Если РеквизитыНастройки.ВозможностьИзменятьУчастников = Перечисления.ВариантыДоступностиИзмененияДействий.Авто Тогда
		Выборка = РеквизитыНастройки.Участники.Выбрать();
		Если Выборка.Количество() > 0 Тогда
			ВозможностьИзменятьУчастников = Перечисления.ВариантыДоступностиИзмененияДействий.Запрещено;
		Иначе
			ВозможностьИзменятьУчастников = Перечисления.ВариантыДоступностиИзмененияДействий.Разрешено;
		КонецЕсли;
	Иначе
		ВозможностьИзменятьУчастников = РеквизитыНастройки.ВозможностьИзменятьУчастников;
	КонецЕсли;
	Разрешения = Новый Соответствие();
	Разрешения.Вставить(
		ДействияСервер.ПредопределенныйИдентификаторУчастника("Пустой"),
		ВозможностьИзменятьУчастников);
		
	Возврат Разрешения;
	
Конецфункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Ссылка");
	Поля.Добавить("ВидДействия");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Представление = НастройкиДействий.ПредставлениеНастройки(Данные.Ссылка, Данные.ВидДействия);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
