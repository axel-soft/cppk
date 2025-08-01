﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.СтатусВыгрузкиВАрхив =
		Перечисления.СтатусыОбменаСАрхивом.ОбнаруженыОшибкиПриЗагрузкеВАрхив Тогда
		Заголовок = НСтр("ru = 'Обнаружены ошибки при загрузке в Архив'");
	ИначеЕсли Параметры.СтатусВыгрузкиВАрхив =
		Перечисления.СтатусыОбменаСАрхивом.ОбнаруженыОшибкиПриПроверкеВАрхиве Тогда
		Заголовок = НСтр("ru = 'Обнаружены ошибки при проверке в Архиве'");
	Иначе
		Заголовок = НСтр("ru = 'Документ принят в Архив'");
	КонецЕсли;
	
	РезультатПроверки = Параметры.РезультатПроверки;
	
КонецПроцедуры

#КонецОбласти