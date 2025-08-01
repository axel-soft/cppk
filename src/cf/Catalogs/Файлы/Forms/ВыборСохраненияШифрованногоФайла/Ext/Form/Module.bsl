﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СохранятьСРасшифровкой = 1;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		МодульЭлектроннаяПодписьКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодпись");
		РасширениеДляЗашифрованныхФайлов = МодульЭлектроннаяПодписьКлиентСервер.ПерсональныеНастройки(
			).РасширениеДляЗашифрованныхФайлов;
	Иначе
		РасширениеДляЗашифрованныхФайлов = "p7m";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьФайл(Команда)
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("СохранятьСРасшифровкой", СохранятьСРасшифровкой);
	СтруктураВозврата.Вставить("РасширениеДляЗашифрованныхФайлов", РасширениеДляЗашифрованныхФайлов);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти
