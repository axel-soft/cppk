﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ИмяМакетаТиповой") Тогда
		ТекстИнструкции = РаботаСИнструкциями.ТекстТиповойИнструкции(Параметры.ИмяМакетаТиповой);
		ТекстИнструкции = РаботаСИнструкциями.УстановитьСтильОформленияИнструкции(ТекстИнструкции);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
