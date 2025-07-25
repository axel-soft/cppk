﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Запоминает связь загруженного документа с внешним идентификатором,
// например идентификатором письма, в регистре сведений ВнешниеИсточникиДокументов
//
// Параметры:
// - Документ (ВходящийДокумент, ИсходящийДокумент, ДокументПредприятия, ВходящийДокумент)
// - Идентификатор (Строка)
//
Процедура ЗарегистрироватьВнешнийИсточникДокумента(Документ, Идентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Если ПустаяСтрока(Идентификатор) Тогда
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Документ) Тогда
		Возврат;
	КонецЕсли;
	Запись = РегистрыСведений.ВнешниеИсточникиДокументов.СоздатьМенеджерЗаписи();
	Запись.Идентификатор = Идентификатор;
	Запись.Документ = Документ;
	Запись.Прочитать();
	Запись.Идентификатор = Идентификатор;
	Запись.Документ = Документ;
	Запись.Записать(Истина);
	
КонецПроцедуры

// Возвращает найденные документы, связанные с идентификаторами.
// Результат (Массив)
// - Элемент (Структура)
//   - Идентификатор (Строка)
//   - Документы (СписокЗначений)
//     - Значение (СправочникСсылка.ВнутренниеДокумены)
//
// Параметры:
// - Идентификаторы (Массив)
//   - Элемент (Строка)
//
Функция ПолучитьДокументыПоВнешнимИсточникам(Идентификаторы) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВнешниеИсточникиДокументов.Идентификатор КАК Идентификатор,
		|	ВнешниеИсточникиДокументов.Документ КАК Документ,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(ВнешниеИсточникиДокументов.Документ) = ТИП(Справочник.ДокументыПредприятия)
		|			ТОГДА ВЫБОР
		|					КОГДА ВнешниеИсточникиДокументов.Документ.ВидДокумента.ЯвляетсяВходящейКорреспонденцией
		|						ТОГДА ""Входящий документ""
		|					КОГДА ВнешниеИсточникиДокументов.Документ.ВидДокумента.ЯвляетсяИсходящейКорреспонденцией
		|						ТОГДА ""Исходящий документ""
		|					ИНАЧЕ ""Документ""
		|				КОНЕЦ
		|		КОГДА ТИПЗНАЧЕНИЯ(ВнешниеИсточникиДокументов.Документ) = ТИП(Справочник.Файлы)
		|			ТОГДА ""Файл""
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК Тип,
		|	ВнешниеИсточникиДокументов.Документ.ВидДокумента КАК ВидДокумента
		|ИЗ
		|	РегистрСведений.ВнешниеИсточникиДокументов КАК ВнешниеИсточникиДокументов
		|ГДЕ
		|	ВнешниеИсточникиДокументов.Идентификатор В(&Идентификаторы)
		|ИТОГИ ПО
		|	Идентификатор");
	Запрос.УстановитьПараметр("Идентификаторы", Идентификаторы);
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		ДокументыПоИдентификатору = Новый СписокЗначений;
		ВыборкаПоДокументам = Выборка.Выбрать();
		Пока ВыборкаПоДокументам.Следующий() Цикл
			ПредставлениеДокумента = "";
			Если ЗначениеЗаполнено(ВыборкаПоДокументам.Тип) Тогда
				ДобавитьЗначениеКСтрокеЧерезРазделитель(ПредставлениеДокумента, "", ВыборкаПоДокументам.Тип + ": ");
			КонецЕсли;
			ДобавитьЗначениеКСтрокеЧерезРазделитель(ПредставлениеДокумента, " ", ВыборкаПоДокументам.Документ);
			Если ЗначениеЗаполнено(ВыборкаПоДокументам.ВидДокумента) Тогда
				ДобавитьЗначениеКСтрокеЧерезРазделитель(ПредставлениеДокумента, " ", "(" + ВыборкаПоДокументам.ВидДокумента + ")");
			КонецЕсли;
			ДокументыПоИдентификатору.Добавить(ВыборкаПоДокументам.Документ, ПредставлениеДокумента);
		КонецЦикла;
		Результат.Добавить(Новый Структура("Идентификатор, Документы", Выборка.Идентификатор, ДокументыПоИдентификатору));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает найденные документы связанные с идентификатором.
// Результат (СписокЗначений)
// - Значение (СправочникСсылка.ВнутренниеДокумены)
//
// Параметры:
// - Идентификатор (Строка)
//
Функция ПолучитьДокументыПоВнешнемуИсточнику(Идентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый СписокЗначений;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВнешниеИсточникиДокументов.Документ КАК Документ,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(ВнешниеИсточникиДокументов.Документ) = ТИП(Справочник.ДокументыПредприятия)
		|			ТОГДА ВЫБОР
		|					КОГДА ВнешниеИсточникиДокументов.Документ.ВидДокумента.ЯвляетсяВходящейКорреспонденцией
		|						ТОГДА ""Входящий документ""
		|					КОГДА ВнешниеИсточникиДокументов.Документ.ВидДокумента.ЯвляетсяИсходящейКорреспонденцией
		|						ТОГДА ""Исходящий документ""
		|					ИНАЧЕ ""Документ""
		|				КОНЕЦ
		|		КОГДА ТИПЗНАЧЕНИЯ(ВнешниеИсточникиДокументов.Документ) = ТИП(Справочник.Файлы)
		|			ТОГДА ""Файл""
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК Тип,
		|	ВнешниеИсточникиДокументов.Документ.ВидДокумента КАК ВидДокумента
		|ИЗ
		|	РегистрСведений.ВнешниеИсточникиДокументов КАК ВнешниеИсточникиДокументов
		|ГДЕ
		|	ВнешниеИсточникиДокументов.Идентификатор =&Идентификатор");
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ПредставлениеДокумента = "";
		Если ЗначениеЗаполнено(Выборка.Тип) Тогда
			ДобавитьЗначениеКСтрокеЧерезРазделитель(ПредставлениеДокумента, "", Выборка.Тип + ": ");
		КонецЕсли;
		ДобавитьЗначениеКСтрокеЧерезРазделитель(ПредставлениеДокумента, " ", Выборка.Документ);
		Если ЗначениеЗаполнено(Выборка.ВидДокумента) Тогда
			ДобавитьЗначениеКСтрокеЧерезРазделитель(ПредставлениеДокумента, " ", "(" + Выборка.ВидДокумента + ")");
		КонецЕсли;
		Результат.Добавить(Выборка.Документ, ПредставлениеДокумента);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли
