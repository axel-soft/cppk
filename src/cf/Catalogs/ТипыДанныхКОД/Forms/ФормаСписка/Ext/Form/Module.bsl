﻿
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодсистемаОтбораПриИзменении(Элемент)
	
	УстановитьОтборПоПодсистеме();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсистемаОтбораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ПодходящиеПодсистемы("");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсистемаОтбораАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = ПодходящиеПодсистемы(Текст);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Перезаполнить(Команда)
	
	ПерезаполнитьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПерезаполнитьНаСервере()
	
	Справочники.ТипыДанныхКОД.ОбновитьТипыДанныхКОД();
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПодсистеме()
	
	Если ЗначениеЗаполнено(ПодсистемаОтбора) Тогда
		Подсистема = Метаданные.НайтиПоПолномуИмени(
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПодсистемаОтбора, "ПолноеИмя"));
		Наименования = ПолныйСоставПодсистемы(Подсистема);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Наименование",
			Наименования,
			ВидСравненияКомпоновкиДанных.ВСписке,
			НСтр("ru = 'По подсистеме'"));
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Наименование");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолныйСоставПодсистемы(Подсистема)
	
	ПолныйСостав = Новый Массив;
	Для Каждого Элемент Из Подсистема.Состав Цикл
		ПолныйСостав.Добавить(Элемент.ПолноеИмя());
	КонецЦикла;
	Для Каждого ВложеннаяПодсистема Из Подсистема.Подсистемы Цикл
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПолныйСостав,
			ПолныйСоставПодсистемы(ВложеннаяПодсистема),
			Истина);
	КонецЦикла;
	Возврат ПолныйСостав;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПодходящиеПодсистемы(ЧастьНаименования)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Ссылка
		|ИЗ
		|	Справочник.ИдентификаторыОбъектовМетаданных
		|ГДЕ
		|	НЕ ПометкаУдаления
		|	И &ОтборНаименования
		|	И ПолноеИмя ПОДОБНО ""Подсистема%""
		|УПОРЯДОЧИТЬ ПО Ссылка ИЕРАРХИЯ
		|АВТОУПОРЯДОЧИВАНИЕ");
	Если ЗначениеЗаполнено(ЧастьНаименования) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "РАЗРЕШЕННЫЕ", "РАЗРЕШЕННЫЕ ПЕРВЫЕ 25");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборНаименования", "Наименование ПОДОБНО &ЧастьНаименования");
	Иначе
		Запрос.УстановитьПараметр("ОтборНаименования", Истина);
	КонецЕсли;
	Запрос.УстановитьПараметр("ЧастьНаименования", "%" + ЧастьНаименования + "%");
	
	СписокПодсистем = Новый СписокЗначений();
	СписокПодсистем.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	Возврат СписокПодсистем;
	
КонецФункции

#КонецОбласти