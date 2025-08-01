﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("Ключ") Тогда
		Возврат;
	КонецЕсли;

	Если ВидФормы = "ФормаОбъекта" И Не Параметры.Свойство("ОткрытьКарточкуНастройки") Тогда

		ВидОбъекта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Ключ, "ВидОбъекта");
		Если ТипЗнч(ВидОбъекта) = Тип("СправочникСсылка.ВидыДокументов") Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "Справочник.ВидыДокументов.Форма.ФормаЭлемента";
			Параметры.Вставить("АктивироватьОбработку", Истина);
			Параметры.Ключ = ВидОбъекта;
		ИначеЕсли ТипЗнч(ВидОбъекта) = Тип("СправочникСсылка.ВидыМероприятий") Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "Справочник.ВидыМероприятий.Форма.ФормаЭлемента";
			Параметры.Вставить("АктивироватьОбработку", Истина);
			Параметры.Ключ = ВидОбъекта;
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

// Возвращает виды объектов по виду действия.
// 
// Параметры:
//  ВидыДействий - Массив из СправочникСсылка.ВидыДействий - Массив видов действий
// 
// Возвращаемое значение:
//  Массив из ОпределяемыйТип.ВидОбъектаСОбработкой.
//
Функция ВидыОбъектовПоВидуДействия(ВидыДействий) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиОбработкиВидовОбъектов.ВидОбъекта КАК ВидОбъекта
		|ИЗ
		|	Справочник.НастройкиОбработкиВидовОбъектов КАК НастройкиОбработкиВидовОбъектов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НастройкиОбработкиВидовОбъектов.ВидыДействий КАК ВидыДействийНастройки
		|		ПО НастройкиОбработкиВидовОбъектов.Ссылка = ВидыДействийНастройки.Ссылка
		|ГДЕ
		|	НастройкиОбработкиВидовОбъектов.ДействуетС < &ТекущаяДата
		|	И (НастройкиОбработкиВидовОбъектов.ДействуетПо > &ТекущаяДата
		|	ИЛИ НастройкиОбработкиВидовОбъектов.ДействуетПо = ДАТАВРЕМЯ(1, 1, 1))
		|	И ВидыДействийНастройки.ВидДействия В (&ВидыДействий)
		|	И НастройкиОбработкиВидовОбъектов.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("ВидыДействий", ВидыДействий);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидОбъекта");
	
КонецФункции

// Возвращает признак наличия заданных настроек обработки для указанного вида объекта.
//
// Параметры:
//  ВидОбъекта - ОпределяемыйТип.ВидОбъектаСОбработкой - Ссылка на вид объекта, для которого получаем настройки.
//  ДатаОбработки - Дата - если задана, то получает настройки на указанную дату.
//
// Возвращаемое значение:
//  Булево - Истина, если настройки обработки заданы.
//
Функция НастройкиОбработкиЗаданы(ВидОбъекта, ДатаОбработки = Неопределено) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА
		|ИЗ
		|	Справочник.НастройкиОбработкиВидовОбъектов КАК НастройкиОбработкиВидовОбъектов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НастройкиОбработкиВидовОбъектов.ВидыДействий КАК ВидыДействийНастройки
		|		ПО НастройкиОбработкиВидовОбъектов.Ссылка = ВидыДействийНастройки.Ссылка
		|ГДЕ
		|	НастройкиОбработкиВидовОбъектов.ВидОбъекта = &ВидОбъекта
		|	И НастройкиОбработкиВидовОбъектов.ПометкаУдаления = ЛОЖЬ
		|	И &УсловиеОтбора";

	Если ЗначениеЗаполнено(ДатаОбработки) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбора", 
			"НастройкиОбработкиВидовОбъектов.ДействуетС <= &ДатаОбработки
			|	И (НастройкиОбработкиВидовОбъектов.ДействуетПо = ДАТАВРЕМЯ(1, 1, 1)
			|			ИЛИ НастройкиОбработкиВидовОбъектов.ДействуетПо >= &ДатаОбработки)");
		Запрос.Параметры.Вставить("ДатаОбработки", НачалоДня(ДатаОбработки)); // даты без времени
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбора", "ИСТИНА");
	КонецЕсли;

	Запрос.Параметры.Вставить("ВидОбъекта", ВидОбъекта);
	
	Возврат Не Запрос.Выполнить().Пустой();

КонецФункции

// Возвращает ссылку на настройку обработки для вида объекта.
//
// Параметры:
//  ВидОбъекта - ОпределяемыйТип.ВидОбъектаСОбработкой - Ссылка на вид объекта, для которого получаем настройки.
//  ДатаОбработки - Дата - дата, на которую получается настройка.
//
// Возвращаемое значение:
//  СправочникСсылка.НастройкиОбработкиВидовОбъектов
//
Функция НастройкаОбработкиДляВидаОбъекта(ВидОбъекта, ДатаОбработки) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НастройкиОбработкиВидовОбъектов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.НастройкиОбработкиВидовОбъектов КАК НастройкиОбработкиВидовОбъектов
		|ГДЕ
		|	НастройкиОбработкиВидовОбъектов.ВидОбъекта = &ВидОбъекта
		|	И НастройкиОбработкиВидовОбъектов.ПометкаУдаления = ЛОЖЬ
		|	И &УсловиеОтбора";

	Если ЗначениеЗаполнено(ДатаОбработки) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбора", 
			"НастройкиОбработкиВидовОбъектов.ДействуетС <= &ДатаОбработки
			|	И (НастройкиОбработкиВидовОбъектов.ДействуетПо = ДАТАВРЕМЯ(1, 1, 1)
			|			ИЛИ НастройкиОбработкиВидовОбъектов.ДействуетПо >= &ДатаОбработки)");
		Запрос.Параметры.Вставить("ДатаОбработки", ДатаОбработки);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбора", "ИСТИНА");
	КонецЕсли;

	Запрос.Параметры.Вставить("ВидОбъекта", ВидОбъекта);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

// Возвращает подходящую настройку обработки для объекта.
// 
// Параметры:
//  Объект - СправочникСсылка.ДокументыПредприятия, СправочникСсылка.Мероприятия
// 
// Возвращаемое значение:
//  СправочникСсылка.НастройкиОбработкиВидовОбъектов
//
Функция НастройкаОбработкиДляОбъекта(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбработкаОбъекта = Справочники.ОбработкиОбъектов.ОбработкаОбъекта(Объект);
	Если ЗначениеЗаполнено(ОбработкаОбъекта) Тогда
		НастройкаОбработки = НастройкаОбработкиОбъекта(ОбработкаОбъекта);
		Если ЗначениеЗаполнено(НастройкаОбработки) Тогда
			Возврат НастройкаОбработки;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыОбъектаОбработки = ДействияКлиентСервер.ПараметрыОбъектаОбработки(
		Объект, Объект.ПолучитьОбъект());
	
	Возврат НастройкаОбработкиДляВидаОбъекта(
		ПараметрыОбъектаОбработки.ВидОбъекта,
		НачалоДня(ТекущаяДатаСеанса()));
	
КонецФункции

// Возвращает настройку, по которой была создана обработка объекта.
// 
// Параметры:
//  ОбработкаОбъекта - СправочникСсылка.ОбработкиОбъектов
// 
// Возвращаемое значение:
//  СправочникСсылка.НастройкиОбработкиВидовОбъектов
//
Функция НастройкаОбработкиОбъекта(ОбработкаОбъекта) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ДействияОбработкиОбъектов.НастройкаОбработки КАК НастройкаОбработки,
		|	НЕ НастройкиОбработкиВидовОбъектов.Наименование ЕСТЬ NULL КАК НастройкаСуществует
		|ИЗ
		|	РегистрСведений.ДействияОбработкиОбъектов КАК ДействияОбработкиОбъектов
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НастройкиОбработкиВидовОбъектов КАК НастройкиОбработкиВидовОбъектов
		|		ПО ДействияОбработкиОбъектов.НастройкаОбработки = НастройкиОбработкиВидовОбъектов.Ссылка
		|ГДЕ
		|	ДействияОбработкиОбъектов.Обработка = &Обработка
		|	И ДействияОбработкиОбъектов.НастройкаОбработки <> ЗНАЧЕНИЕ(Справочник.НастройкиОбработкиВидовОбъектов.ПустаяСсылка)
		|	И НЕ ДействияОбработкиОбъектов.Действие.ПометкаУдаления
		|	";
	Запрос.УстановитьПараметр("Обработка", ОбработкаОбъекта);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПоискПоТекущейДате = Ложь;
	Если Выборка.Следующий() Тогда
		ПоискПоТекущейДате = Не Выборка.НастройкаСуществует;
		Если Выборка.НастройкаСуществует Тогда // Проверяем, что настройка - не битая ссылка
			Возврат Выборка.НастройкаОбработки;
		КонецЕсли;
	КонецЕсли;
	
	ВидВладельцаОбработки = ОбработкиОбъектов.ВидВладельцаОбработки(ОбработкаОбъекта);
	ТекущаяНастройка = НастройкаОбработкиДляВидаОбъекта(ВидВладельцаОбработки,
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбработкаОбъекта, "ДатаСоздания"));
	Если Не ЗначениеЗаполнено(ТекущаяНастройка)	И ПоискПоТекущейДате Тогда
		ТекущаяНастройка = НастройкаОбработкиДляВидаОбъекта(ВидВладельцаОбработки, ТекущаяДатаСеанса());
	КонецЕсли;	
	
	Возврат ТекущаяНастройка;
	
КонецФункции

// Удаляет порцию устаревших данных.
// 
// Возвращаемое значение - Булево - Истина, если были найдены устаревшие данные, в противном случае Ложь.
// 
Функция УдалитьПорциюУстаревшихДанных() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	НастройкиОбработкиВидовОбъектов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.НастройкиОбработкиВидовОбъектов КАК НастройкиОбработкиВидовОбъектов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДействияОбработкиОбъектов КАК ДействияОбработкиОбъектов
		|		ПО (ДействияОбработкиОбъектов.НастройкаОбработки = НастройкиОбработкиВидовОбъектов.Ссылка)
		|ГДЕ
		|	НастройкиОбработкиВидовОбъектов.ПометкаУдаления = ИСТИНА
		|	И ДействияОбработкиОбъектов.Обработка ЕСТЬ NULL";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОбработаноЗаписей = Выборка.Количество();
	ОбработаноУспешно = 0;
	ОбработаноСОшибками = 0;
	
	Пока Выборка.Следующий() Цикл
		
		СсылкаНаНастройкуСтрокой = ПолучитьНавигационнуюСсылку(Выборка.Ссылка);
		
		Попытка
			НастройкаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			НастройкаОбъект.Удалить();
			ОбработаноУспешно = ОбработаноУспешно + 1;
		Исключение
			ОбработаноСОшибками = ОбработаноСОшибками + 1;
			
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru='Ошибка при удалении неактуальной настройки обработки вида объекта'"),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.НастройкиОбработкиВидовОбъектов,
				СсылкаНаНастройкуСтрокой,
				ТекстОшибки);
			
			Продолжить;
		КонецПопытки;
			
	КонецЦикла;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru='Удаление устаревших данных'"), 
		УровеньЖурналаРегистрации.Информация,
		Метаданные.Справочники.НастройкиОбработкиВидовОбъектов, , 
		СтрШаблон(
			НСтр("ru = 'Процедура завершена.
				|Обработано записей: %1
				|Из них:
				|	Успешно - %2
				|	С ошибками - %3'"),
			ОбработаноЗаписей, ОбработаноУспешно, ОбработаноСОшибками));
	
	
	Возврат ОбработаноЗаписей > 0;
		
КонецФункции

// Настройка обработки действующая.
// 
// Параметры:
//  Настройка - СправочникСсылка.НастройкиОбработкиВидовОбъектов
// 
// Возвращаемое значение:
//  Булево - действует или нет
//  
Функция ЭтоДействующаяНастройка(Настройка) Экспорт
	
	ТекущаяДата = НачалоДня(ТекущаяДатаСеанса());
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Настройка, "ДействуетС, ДействуетПо");
	ДействуетС = Реквизиты.ДействуетС;
	ДействуетПо = Реквизиты.ДействуетПо;
	
	Результат = (Не ЗначениеЗаполнено(ДействуетС) Или ДействуетС <= ТекущаяДата)
				И (Не ЗначениеЗаполнено(ДействуетПо) Или ТекущаяДата <= ДействуетПо);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает отслеживаемые реквизиты для дополнительного свойства ПредыдущиеЗначенияРеквизитов.
// Используется в процедуре ОбщегоНазначенияДокументооборот.УстановитьДополнительноеСвойствоПредыдущиеЗначенияРеквизитов
//
// Возвращаемое значение:
//  Строка - Отслеживаемые реквизиты.
//
Функция ОтслеживаемыеРеквизиты() Экспорт
	
	ОтслеживаемыеРеквизиты =
		"ВидОбъекта,
		|ДействуетПо,
		|ДействуетС";
	
	Возврат ОтслеживаемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецЕсли