﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Проект = Параметры.Проект;
	ЗначениеВРеквизитФормы(Проект.ПроектнаяКоманда.Выгрузить(), "ПроектнаяКоманда");
	
	АдресВременногоХранилища = Параметры.АдресВременногоХранилища;
	Исполнители = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	Для Каждого Исполнитель Из Исполнители Цикл
		НоваяСтрока = Выбранные.Добавить();
		НоваяСтрока.Исполнитель = Сотрудники.ОсновнойСотрудникПользователя(Исполнитель);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Включить(Команда)
	
	ВключитьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура Исключить(Команда)
	
	Если Элементы.Выбранные.ВыделенныеСтроки.Количество() > 0 Тогда
		Для каждого Строка Из Элементы.Выбранные.ВыделенныеСтроки Цикл
			СтрокаПоИдентификатору = Выбранные.НайтиПоИдентификатору(Строка);
			Выбранные.Удалить(СтрокаПоИдентификатору);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьНаКлиенте()
	
	Для каждого ВыбранноеЗначение Из Элементы.ПроектнаяКоманда.ВыделенныеСтроки Цикл
		ВыбраннаяСтрока = ПроектнаяКоманда.НайтиПоИдентификатору(ВыбранноеЗначение);
		
		ПараметрыОтбора = Новый Структура("Исполнитель");
		ПараметрыОтбора.Исполнитель = СотрудникиВызовСервера.ЛюбойПользовательСотрудника(ВыбраннаяСтрока.Исполнитель);
			
		Если Выбранные.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда
			НоваяСтрока = Выбранные.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыбраннаяСтрока);
			Элементы.Выбранные.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
				
	КонецЦикла;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПроектнаяКомандаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВключитьНаКлиенте()
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьИсполнителейВоВременноеХранилище()
	
	Исполнители = Выбранные.Выгрузить().ВыгрузитьКолонку("Исполнитель");
	ПоместитьВоВременноеХранилище(Исполнители, АдресВременногоХранилища);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Выбранные.Количество() = 0 Тогда
		ВключитьНаКлиенте();
	КонецЕсли;
	
	ПоместитьИсполнителейВоВременноеХранилище();
	ОповеститьОВыборе(АдресВременногоХранилища);
	
КонецПроцедуры
