﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор")
			И Параметры.Отбор.Свойство("Узел")
			И ЗначениеЗаполнено(Параметры.Отбор.Узел) Тогда
		Элементы.Узел.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор")
			И Параметры.Отбор.Свойство("Ключ")
			И ЗначениеЗаполнено(Параметры.Отбор.Ключ) Тогда
		Элементы.Ключ.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборСсылкаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	Если СтрНачинаетсяС(СокрЛ(Текст), "e1cib/") Тогда
		Значение = ЗначениеПоНавигационнойСсылке(Текст);
	ИначеЕсли СтрДлина(СокрЛП(Текст)) = 36 Тогда
		Значение = ЗначениеПоИдентификатору(Текст, ТипЗнч(ОтборСсылка));
	КонецЕсли;
	Если ЗначениеЗаполнено(Значение) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(Значение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборСсылкаПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"Ключ",
		ОтборСсылка,,,
		ОтборСсылка <> Неопределено);
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗначениеПоНавигационнойСсылке(СтрокаСсылки, Обязательно = Ложь) Экспорт
	
	ИД = Прав(СокрЛП(СтрокаСсылки), 32);
	ИД = Сред(ИД, 25, 8)
		+ "-" + Сред(ИД, 21, 4)
		+ "-" + Сред(ИД, 17, 4)
		+ "-" + Сред(ИД, 1,  4)
		+ "-" + Сред(ИД, 5,  12);
		
	Имя = Сред(СтрокаСсылки, СтрНайти(СтрокаСсылки, "/", НаправлениеПоиска.СКонца) +1);
	Имя = Лев(Имя, СтрНайти(Имя, "?") -1);
	
	Попытка
		Возврат ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Имя).ПолучитьСсылку(Новый УникальныйИдентификатор(ИД));
	Исключение
		Если Обязательно Тогда
			ВызватьИсключение(НСтр("ru = 'Переданная ссылка не соответствует формату'"));
		КонецЕсли;
	КонецПопытки;

КонецФункции

&НаСервереБезКонтекста
Функция ЗначениеПоИдентификатору(СтрокаГУИД, ТипЗначения, Обязательно = Ложь) Экспорт
	
	Попытка
		Возврат XMLЗначение(ТипЗначения, СокрЛП(СтрокаГУИД));
	Исключение
		Если Обязательно Тогда
			ВызватьИсключение(НСтр("ru = 'Переданный идентификатор не соответствует формату'"));
		КонецЕсли;
	КонецПопытки;

КонецФункции

#КонецОбласти