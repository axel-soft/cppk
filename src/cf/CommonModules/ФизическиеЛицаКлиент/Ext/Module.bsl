﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Физические лица"
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция определяет пол физлица по его отчеству
// Параметр:
// 		ОтчествоРаботника - отчество работника
//
Функция ОпределитьПолПоОтчеству(ОтчествоРаботника) Экспорт
	
	Если Прав(ОтчествоРаботника, 2) = "ич" Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской");
	ИначеЕсли Прав(ОтчествоРаботника, 2) = "на" Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Женский");
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции // ОпределитьПолПоОтчеству()

// Выполняет подбор физ. лица по полному имени, после подбора запускает
// переданный обработчик подбора.
//
// Параметры:
//  ПолноеИмя - Строка
//  Форма - ФормаКлиентскогоПриложения - форма в которой выполняется подбор физ. лица.
//  ОбработчикПодбора - ОписаниеОповещения - обработчик, принимающий в качестве результата
//                      ссылку на физ. лицо, либо Неопределено.
//
Процедура ПодобратьФизическоеЛицоПоПолномуИмени(ПолноеИмя, Форма, ОбработчикПодбора) Экспорт
	
	Если ЗначениеЗаполнено(ПолноеИмя) Тогда
		ПохожиеФизЛица = ФизическиеЛицаВызовСервера.ФизическиеЛицаПоПолномуИмени(ПолноеИмя);
	Иначе
		ПохожиеФизЛица = Новый Массив;
	КонецЕсли;
	
	Если ПохожиеФизЛица.Количество() = 0 Тогда
		ВыполнитьОбработкуОповещения(
			ОбработчикПодбора,
			ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка"));
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму(
		"Справочник.ФизическиеЛица.Форма.ФизическиеЛицаСПохожимиДанными",
		Новый Структура("ПохожиеФизЛица", ПохожиеФизЛица),
		Форма,,,,
		ОбработчикПодбора,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Открывает форму набора записей по физическому лицу РС ФИОФизическихЛиц
//
// Параметры:
//  ФизическоеЛицо - СправочникСсылка.ФизическиеЛица
//  ОписаниеОповещения - ОписаниеОповещения
//
Процедура ОткрытьИсториюФИОФизЛица(ФизическоеЛицо, ОписаниеОповещения) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	
	ОткрытьФорму("РегистрСведений.ФИОФизическихЛиц.Форма.ФормаНабораЗаписей", ПараметрыФормы,,,,, ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Открывает форму изменения ФИО физического лица
//
// Параметры:
//  ФизическоеЛицо - СправочникСсылка.ФизическиеЛица
//  ОписаниеОповещения - ОписаниеОповещения
//  ВернутьРезультат - Булево - Если Истина, то возвращает данные нового ФИО, иначе - сразу записывает изменения
//
Процедура ОткрытьФормуИзмененияФИО(ФизическоеЛицо, ОписаниеОповещения, ВернутьРезультат) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВернутьРезультат", ВернутьРезультат);
	ПараметрыФормы.Вставить("Ключ", ФизическоеЛицо);
	
	ОткрытьФорму("РегистрСведений.ФИОФизическихЛиц.Форма.СменаФИО", ПараметрыФормы,,,,,ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Имя оповещения об изменении ФИО
// 
// Возвращаемое значение:
//  Строка
//
Функция ИмяОповещенияОбИзмененииФИО() Экспорт
	
	Возврат "ИзменениеФИО";
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Код процедур и функций
#КонецОбласти