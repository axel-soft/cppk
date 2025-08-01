﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет дерево обработки участниками действия.
// 
// Параметры:
// 	ЭлементыДействия - ДанныеФормыЭлементДерева - коллекцию элементов дерева
// 	ЗначенияЗаполнения - Структура:
// 	 ВидДействия - СправочникСсылка.ВидыДействий - вид действия.
//	 Настройка - СправочникСсылка.НастройкиДействийИсполнения - ссылка на настройку действия. 
//	 НастройкаВключена - Булево - Истина, если включена.
//
Процедура ДополнитьДеревоПредставлениемНастройки(ЭлементыДействия, ЗначенияЗаполнения) Экспорт
	
	Настройка = ЗначенияЗаполнения.Настройка;
	ИспользоватьДатуИВремяВСрокахЗадач = 
		ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	
	НастройкаОбъект = Настройка.ПолучитьОбъект();
	Участники = НастройкаОбъект.Участники();
	Рассматривающие = НастройкаОбъект.Рассматривающие();
	УчастникиСАвтоопределениемФункции = НастройкаОбъект.УчастникиСАвтоопределениемФункции();
	
	// Действие.
	ЭлементДействия = ЭлементыДействия.Добавить();
	ЗаполнитьЗначенияСвойств(ЭлементДействия, ЗначенияЗаполнения);
	ЭлементДействия.ЭтоДействие = Истина;
	ЭлементДействия.Представление = Строка(НастройкаОбъект.ВидДействия);
	ПодчиненныеЭлементы = ЭлементДействия.ПолучитьЭлементы();
	
	// Рассматривающие.
	Если Рассматривающие.Количество() > 0 Тогда
			
		Для Каждого Рассматривающий Из Рассматривающие Цикл
			
			ПодчиненныйЭлемент = ПодчиненныеЭлементы.Добавить();
			ЗаполнитьЗначенияСвойств(ПодчиненныйЭлемент, Рассматривающий);
			ЗаполнитьЗначенияСвойств(ПодчиненныйЭлемент, ЗначенияЗаполнения);
			ПодчиненныйЭлемент.ЭтоУчастник = Истина;
			ПодчиненныйЭлемент.Участник = Рассматривающий.Участник;
			ПодчиненныйЭлемент.Представление = Рассматривающий.Участник;
			ПодчиненныйЭлемент.УсловиеПредставление = Рассматривающий.Условие;
			
			ПодчиненныйЭлемент.СрокПредставление = СрокиИсполненияПроцессовКлиентСервер.
				ПредставлениеСрокаИсполнения(
					Рассматривающий.Срок,
					Рассматривающий.СрокДни,
					Рассматривающий.СрокЧасы,
					Рассматривающий.СрокМинуты,
					ИспользоватьДатуИВремяВСрокахЗадач,
					Рассматривающий.ВариантУстановкиСрока);
			
		КонецЦикла;
		
		Если Рассматривающий.СрокОбщий Тогда
			ЭлементДействия.СрокПредставление = ПодчиненныйЭлемент.СрокПредставление;
		КонецЕсли;
					
	КонецЕсли;
	
	// Участники.
	Участник = Неопределено;
	
	Для Каждого Участник Из Участники Цикл
		
		ПодчиненныйЭлемент = ПодчиненныеЭлементы.Добавить();
		ЗаполнитьЗначенияСвойств(ПодчиненныйЭлемент, Участник);
		ЗаполнитьЗначенияСвойств(ПодчиненныйЭлемент, ЗначенияЗаполнения);
		ПодчиненныйЭлемент.ЭтоУчастник = Истина;
		ПодчиненныйЭлемент.Участник = Участник.Участник;
		ПодчиненныйЭлемент.Представление = Участник.Участник;
		ПодчиненныйЭлемент.УсловиеПредставление = Участник.Условие;
		ПодчиненныйЭлемент.Ответственный = Участник.Ответственный;
		
		ПодчиненныйЭлемент.СрокПредставление = СрокиИсполненияПроцессовКлиентСервер.
			ПредставлениеСрокаИсполнения(
				Участник.Срок,
				Участник.СрокДни,
				Участник.СрокЧасы,
				Участник.СрокМинуты,
				ИспользоватьДатуИВремяВСрокахЗадач,
				Участник.ВариантУстановкиСрока);
		
	КонецЦикла;
	
	Если Участник <> Неопределено И Участник.СрокОбщий Тогда
		ЭлементДействия.СрокПредставление = ПодчиненныйЭлемент.СрокПредставление;
	КонецЕсли;
	
	// Участники с автоопределяемой функцией.
	Участник = Неопределено;
	Для Каждого Участник Из УчастникиСАвтоопределениемФункции Цикл
		
		ПодчиненныйЭлемент = ПодчиненныеЭлементы.Добавить();
		ЗаполнитьЗначенияСвойств(ПодчиненныйЭлемент, Участник);
		ЗаполнитьЗначенияСвойств(ПодчиненныйЭлемент, ЗначенияЗаполнения);
		ПодчиненныйЭлемент.ЭтоУчастник = Истина;
		ПодчиненныйЭлемент.Участник = Участник.Участник;
		ПодчиненныйЭлемент.Представление = Участник.Участник;
		
		ПодчиненныйЭлемент.СрокПредставление = СрокиИсполненияПроцессовКлиентСервер.
			ПредставлениеСрокаИсполнения(
				Участник.Срок,
				Участник.СрокДни,
				Участник.СрокЧасы,
				Участник.СрокМинуты,
				ИспользоватьДатуИВремяВСрокахЗадач,
				Участник.ВариантУстановкиСрока);
		
		Если Участник <> Неопределено И Участник.СрокОбщий Тогда
			ЭлементДействия.СрокПредставление = ПодчиненныйЭлемент.СрокПредставление;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Ссылка");
	Поля.Добавить("ВидДействия");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Представление = НастройкиДействий.ПредставлениеНастройки(Данные.Ссылка, Данные.ВидДействия);
	
КонецПроцедуры

// Возвращает всех участников настройки действия
// 
// Параметры:
// 	НастройкаДействия - СправочникСсылка.НастройкиДействийИсполнения - ссылка на действие
// 	
// Возвращаемое значение:
// 	ТаблицаЗначений - таблица участников действия.
// 
Функция ВсеУчастники(НастройкаДействия) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Участники.Участник КАК Участник,
		|	Участники.ФункцияУчастника КАК Функция
		|ИЗ
		|	Справочник.НастройкиДействийИсполнения.Участники КАК Участники
		|ГДЕ
		|	Участники.Ссылка = &НастройкаДействия");
	
	Запрос.УстановитьПараметр("НастройкаДействия", НастройкаДействия);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Возвращает идентификатор объекта метаданных.
//
// Возвращаемое значение:
//  СправочникСсылка.ИдентификаторыОбъектовМетаданных - Возвращает идентификатор объекта метаданных.
//
Функция ИдентификаторОбъектаМетаданных() Экспорт
	
	ИдентификаторОбъектаМетаданных =
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Справочники.НастройкиДействийИсполнения);
	
	Возврат ИдентификаторОбъектаМетаданных;
	
КонецФункции

// Возвращает разрешения по действию в виде соответствия
// 
// Параметры:
// 	НастройкаДействия - СправочникСсылка.НастройкиДействийИсполнения - ссылка на действие
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

#КонецОбласти

#КонецЕсли
