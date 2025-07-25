﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("Документ") Тогда
		ВызватьИсключение НСтр("ru = 'Отсутствует обязательный параметр открытия формы <Документ>.'");
	КонецЕсли;
	
	Документ = Параметры.Документ;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Документ", Документ,
		ВидСравненияКомпоновкиДанных.Равно, , Истина);
	
	ПоказыватьУдаленныеРезолюции = 
		Параметры.Свойство("ПоказыватьУдаленныеРезолюции")
		И Параметры.ПоказыватьУдаленныеРезолюции;
	
	Если Не ПоказыватьУдаленныеРезолюции Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти