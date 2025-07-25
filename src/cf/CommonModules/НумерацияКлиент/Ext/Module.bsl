﻿#Область ПрограммныйИнтерфейс

// Процедура - Выбрать пропущенные номера
// 
// Параметры:
//  Документ - ДанныеФормыСтруктура - Объект из формы документа
//  Оповещение - ОписаниеОповещения - Оповещение, которое будет выполнено после выбора пропущенного номера
//  Отказ - Булево - Признак что нужно показать вопрос перед продолжением, используется при вызове
//  СтруктураИзмерений - Структура -См. НумерацияКлиентСервер.ПолучитьПараметрыНумерации
//  ЭтоНагрузочноеТестирование - Булево - Это нагрузочное тестирование, нужно выолпнить процедуры, но пропущенные номера
//  									  не выбирать.
Процедура ВыбратьПропущенныеНомера(
	Знач Документ,
	Оповещение,
	Отказ,
	Знач СтруктураИзмерений = Неопределено) Экспорт

	Нумератор = Нумерация.ПолучитьНумераторДокумента(Документ);
	Если СтруктураИзмерений = Неопределено Тогда
		СтруктураИзмерений = НумерацияКлиентСервер.ПолучитьПараметрыНумерации(Документ, Истина);
	КонецЕсли;
	
	Если НагрузочноеТестированиеКлиент.ЭтоНагрузочноеТестирование() Тогда
		Возврат; // Выход здесь, без ошибок и непредвиденного открытия дополнительных форм. Но проверки сделаны.
	КонецЕсли;
	
	Если Не Нумерация.ЕстьПропущенныеНомера(Документ, Нумератор, СтруктураИзмерений) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("Документ", Документ);
	Если ЗначениеЗаполнено(СтруктураИзмерений) Тогда
		Параметры.Вставить("СтруктураПараметровНумерации", СтруктураИзмерений);
	КонецЕсли;
	
	Отказ = Истина;
	
	ОткрытьФорму("РегистрСведений.ПропускиРегистрационныхНомеров.Форма.ВыборПропущенныхНомеров",
		Параметры, , , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

#КонецОбласти