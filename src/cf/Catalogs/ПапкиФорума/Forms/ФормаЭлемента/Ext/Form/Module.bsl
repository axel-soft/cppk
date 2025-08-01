﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьПолныйПуть();
	
	// Установка видимости команды "Права"
	Если Не УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей() Тогда
		Элементы.ФормаНастройкаПрав.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьПолныйПуть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Изменение_ПапкиФорума", Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ОбновитьПолныйПуть();
	
КонецПроцедуры

&НаКлиенте
Процедура РодительПриИзменении(Элемент)
	
	ОбновитьПолныйПуть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, ДополнительныеДанные, СтандартнаяОбработка)
	
	СотрудникиКлиент.СотрудникОбработкаВыбора(Объект, "Ответственный", ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаПрав(Команда)
	
	ИмяОсновногоРеквизита = "Объект";
	ИмяПодчиненнойФормы = "ОбщаяФорма.НастройкиПравПапок";
	
	ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
		|Выполнение команды ""Настройка прав"" возможно только после записи данных.
		|Данные будут записаны.'");
	
	ДокументооборотПраваДоступаКлиент.ЗаписатьОбъектЕслиНовыйИОткрытьПодчиненнуюФорму(
		ЭтаФорма, ИмяОсновногоРеквизита, ТекстВопроса, ИмяПодчиненнойФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подписаться(Команда)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("ОбъектПодписки", Объект.Ссылка);
		ОткрытьФорму("ОбщаяФорма.ПодпискаНаУведомленияПоОбъекту", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьПолныйПуть()
	
	ПолныйПуть = "";
	
	ПапкаРодитель = Объект.Родитель;
	Пока ЗначениеЗаполнено(ПапкаРодитель) Цикл
		
		ПолныйПуть = Строка(ПапкаРодитель) + "\" + ПолныйПуть;
		
		ПапкаРодитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПапкаРодитель, "Родитель");
		Если Не ЗначениеЗаполнено(ПапкаРодитель) Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	ПолныйПуть = ПолныйПуть + Объект.Наименование;
	
	Если Не ПустаяСтрока(ПолныйПуть) Тогда
		ПолныйПуть = """" + ПолныйПуть + """";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти