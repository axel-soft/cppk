﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Очередь.Параметры.УстановитьЗначениеПараметра("СмещениеВремени", ТекущаяДатаСеанса() - ТекущаяУниверсальнаяДата());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обработать(Команда)
	
	Элементы.Очередь.Обновить();
	
КонецПроцедуры

#КонецОбласти
