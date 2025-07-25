﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция СсылкаНовогоУзла(ФизЛицо, ТипСинхронизации) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СинхронизацияКалендарей.Ссылка КАК Ссылка
	|ИЗ
	|	ПланОбмена.СинхронизацияКалендарей КАК СинхронизацияКалендарей
	|ГДЕ
	|	(СинхронизацияКалендарей.ФизическоеЛицо = &ФизЛицо
	|	ИЛИ СинхронизацияКалендарей.Пользователь = &Пользователь)
	|	И СинхронизацияКалендарей.ТипСинхронизации = &ТипСинхронизации");
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	Запрос.УстановитьПараметр("Пользователь", ПользователиДокументооборот.ПользовательФизЛица(ФизЛицо));
	Запрос.УстановитьПараметр("ТипСинхронизации", ТипСинхронизации);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		НовыйУзел = СоздатьУзел();
		НовыйУзел.УстановитьНовыйКод();
		НовыйУзел.ФизическоеЛицо = ФизЛицо;
		НовыйУзел.ТипСинхронизации = ТипСинхронизации;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		НовыйУзел = Выборка.Ссылка.ПолучитьОбъект();
		НовыйУзел.УстановитьПометкуУдаления(Ложь);
		НовыйУзел.Календари.Очистить();
		НовыйУзел.Включен = Ложь;
	КонецЕсли;
	НовыйУзел.Наименование = Строка(ТипСинхронизации) + " " + Строка(ФизЛицо);
	НовыйУзел.Записать();
	Возврат НовыйУзел.Ссылка;

КонецФункции

Процедура ОчиститьУзел(Узел) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	УзелОбъект = Узел.ПолучитьОбъект();
	УзелОбъект.Включен = Ложь;
	УзелОбъект.ВремяУведомленийИмпорт = 0;
	УзелОбъект.ВремяУведомленийЭкспорт = 0;
	УзелОбъект.ДатаПоследнейСинхронизации = Дата(1,1,1);
	УзелОбъект.СинхронизацияЗавершенаСОшибками = Ложь;
	УзелОбъект.ИнформацияОбОшибке = "";
	УзелОбъект.Календари.Очистить();
	УзелОбъект.Записать();
	УзелОбъект.УстановитьПометкуУдаления(Истина);

КонецПроцедуры

Процедура ЗаписатьРезультатыСинхронизации(РезультатыСинхронизации) Экспорт

	Если Не ЗначениеЗаполнено(РезультатыСинхронизации) Тогда
		Возврат;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Истина);
	Для Каждого СоответствиеУзел Из РезультатыСинхронизации Цикл
		УзелОбъект = СоответствиеУзел.Ключ.ПолучитьОбъект();
		УзелОбъект.ДатаПоследнейСинхронизации = ТекущаяДатаСеанса();
		УзелОбъект.ИнформацияОбОшибке = СоответствиеУзел.Значение.ОписаниеОшибки;
		УзелОбъект.СинхронизацияЗавершенаСОшибками = ЗначениеЗаполнено(УзелОбъект.ИнформацияОбОшибке);
		ТокеныСинхронизации = СоответствиеУзел.Значение.ТокеныСинхронизации;
		Если Не УзелОбъект.СинхронизацияЗавершенаСОшибками
			Или ЗначениеЗаполнено(ТокеныСинхронизации) Тогда		
			Для Каждого СоответствиеКалендарь Из ТокеныСинхронизации Цикл
				НайденныеСтроки = УзелОбъект.Календари.НайтиСтроки(Новый Структура("Идентификатор", СоответствиеКалендарь.Ключ));
				Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
					НайденныеСтроки[0].ТокенСинхронизации = СоответствиеКалендарь.Значение;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		УзелОбъект.Записать();
	КонецЦикла;

КонецПроцедуры

// Выполняет заполнение реквизита ФизическоеЛицо для всех элементов плана обмена.
// Процедура предназначена для вызова механизмом отложенного обновления.
// 
// Параметры:
//  Параметры - Структура - стандартная структура параметров отложенных обработчиков обновления.
//
Процедура ЗаполнитьРеквизитФизическоеЛицоВНастройкахСинхронизацииКалендарей(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	
	Если Параметры.ПрогрессВыполнения.ВсегоОбъектов = 0 Тогда
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	КОЛИЧЕСТВО(*) КАК Количество
			|ИЗ
			|	ПланОбмена.СинхронизацияКалендарей КАК СинхронизацияКалендарей
			|ГДЕ
			|	СинхронизацияКалендарей.ФизическоеЛицо = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
			|	И СинхронизацияКалендарей.Пользователь <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)";
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		Параметры.ПрогрессВыполнения.ВсегоОбъектов = Выборка.Количество;
		
	КонецЕсли;
	
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 500
		|	СинхронизацияКалендарей.Ссылка КАК Ссылка
		|ИЗ
		|	ПланОбмена.СинхронизацияКалендарей КАК СинхронизацияКалендарей
		|ГДЕ
		|	СинхронизацияКалендарей.ФизическоеЛицо = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
		|	И СинхронизацияКалендарей.Пользователь <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОбработаноОбъектов = 0;
	ПроблемныхОбъектов = 0;
	
	Пока Выборка.Следующий() Цикл
		
		НастройкаСинхронизацииСтрокой = ПолучитьНавигационнуюСсылку(Выборка.Ссылка);
		
		НачатьТранзакцию();
		
		Попытка
			
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			
			НастройкаСинхронизации = Выборка.Ссылка.ПолучитьОбъект();
			НастройкаСинхронизации.ФизическоеЛицо = ПользователиДокументооборот.ФизЛицоПользователя(
				НастройкаСинхронизации.Пользователь);
				
			НастройкаСинхронизации.Записать();
			
			ОбработаноОбъектов = ОбработаноОбъектов + 1;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не удалось обработать настройку синхронизации календаря: %1 по причине:
					|%2'"),
				НастройкаСинхронизацииСтрокой,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,,,
				ТекстСообщения);
			
		КонецПопытки;
	
	КонецЦикла;
	
	Если ОбработаноОбъектов = 0 И ПроблемныхОбъектов > 0 Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Процедуре ЗаполнитьРеквизитФизическоеЛицоВНастройкахСинхронизацииКалендарей не удалось обработать некоторые настройки синхронизации календарей (пропущены): %1'"),
			ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов = 
		Параметры.ПрогрессВыполнения.ОбработаноОбъектов + ОбработаноОбъектов;
	
	Параметры.ОбработкаЗавершена = (ОбработаноОбъектов = 0 И ПроблемныхОбъектов = 0);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли