﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПротоколДоставкиПочты.Дата КАК Дата,
		|	ПротоколДоставкиПочты.Текст КАК Текст 
		|ИЗ
		|	РегистрСведений.ПротоколДоставкиПочты КАК ПротоколДоставкиПочты
		|ГДЕ
		|	ПротоколДоставкиПочты.Письмо = &Письмо
		|	И ПротоколДоставкиПочты.ЭтоОшибка = ИСТИНА";
		
	Запрос.УстановитьПараметр("Письмо", Параметры.Письмо);
	ТаблицаВыборки = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Строка Из ТаблицаВыборки Цикл
		
		НоваяСтрока = СписокПротокола.Добавить();
		
		НоваяСтрока.ОписаниеОшибки = Строка.Текст;
		НоваяСтрока.Дата = Строка.Дата;		
		
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПротоколаПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры
