﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	ТипШаблона = "";
	Параметры.Свойство("ТипШаблона", ТипШаблона);
	
	ЗначениеСписка = ТипШаблона;
	
	Если ЗначениеСписка = "Исполнение" Или 
		ЗначениеСписка = "Ознакомление" Или
		ЗначениеСписка = "Рассмотрение" Или
		ЗначениеСписка = "Регистрация" Или
		ЗначениеСписка = "Согласование" Или
		ЗначениеСписка = "Подписание" Или
		ЗначениеСписка = "Утверждение" Или
		ЗначениеСписка = "Приглашение" Или
		ЗначениеСписка = "Комплексный" Тогда
		
		Элементы.Панели.ТекущаяСтраница = Элементы["Панель" + ЗначениеСписка];
		Элементы.Списки.ТекущаяСтраница = Элементы["Список" + ЗначениеСписка];
		Элементы["ВыбратьПанель" + ЗначениеСписка].Видимость = Истина;
		Элементы["ВыбратьПанель" + ЗначениеСписка].КнопкаПоУмолчанию = Истина;
		
	Иначе // составной процесс	
		
	КонецЕсли;	
	
	Если ЗначениеСписка = "Исполнение" Тогда
		Заголовок = НСтр("ru = 'Выбор шаблона процесса ""Исполнение""'");
	ИначеЕсли ЗначениеСписка = "Ознакомление" Тогда
		Заголовок = НСтр("ru = 'Выбор шаблона процесса ""Ознакомление""'");
	ИначеЕсли ЗначениеСписка = "Рассмотрение" Тогда
		Заголовок = НСтр("ru = 'Выбор шаблона процесса ""Рассмотрение""'");
	ИначеЕсли ЗначениеСписка = "Регистрация" Тогда
		Заголовок = НСтр("ru = 'Выбор шаблона процесса ""Регистрация""'");
	ИначеЕсли ЗначениеСписка = "Согласование" Тогда
		Заголовок = НСтр("ru = 'Выбор шаблона процесса ""Согласование""'");
	ИначеЕсли ЗначениеСписка = "Подписание" Тогда
		Заголовок = НСтр("ru = 'Выбор шаблона процесса ""Подписание""'");
	ИначеЕсли ЗначениеСписка = "Утверждение" Тогда
		Заголовок = НСтр("ru = 'Выбор шаблона процесса ""Утверждение""'");
	ИначеЕсли ЗначениеСписка = "Приглашение" Тогда
		Заголовок = НСтр("ru = 'Выбор шаблона процесса ""Приглашение""'");
	ИначеЕсли ЗначениеСписка = "Комплексный" Тогда
		Заголовок = НСтр("ru = 'Выбор шаблона комплексного процесса'");
	Иначе	
		Заголовок = НСтр("ru = 'Выбор шаблона составного процесса'");
	КонецЕсли;
	
	Если Параметры.Свойство("ДоступныеЭлементы") И Параметры.ДоступныеЭлементы.Количество() > 0 Тогда
		
		Если ЗначениеСписка = "Исполнение" Тогда
			ЭлементОтбора = СписокИсполнение.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ИначеЕсли ЗначениеСписка = "Ознакомление" Тогда
			ЭлементОтбора = СписокОзнакомление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ИначеЕсли ЗначениеСписка = "Рассмотрение" Тогда
			ЭлементОтбора = СписокРассмотрение.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ИначеЕсли ЗначениеСписка = "Регистрация" Тогда
			ЭлементОтбора = СписокРегистрация.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ИначеЕсли ЗначениеСписка = "Согласование" Тогда
			ЭлементОтбора = СписокСогласование.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ИначеЕсли ЗначениеСписка = "Подписание" Тогда
			ЭлементОтбора = СписокПодписание.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ИначеЕсли ЗначениеСписка = "Утверждение" Тогда
			ЭлементОтбора = СписокУтверждение.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ИначеЕсли ЗначениеСписка = "Приглашение" Тогда
			ЭлементОтбора = СписокПриглашение.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ИначеЕсли ЗначениеСписка = "Комплексный" Тогда
			ЭлементОтбора = СписокКомплексный.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Иначе	
		КонецЕсли;
		
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.ПравоеЗначение = Параметры.ДоступныеЭлементы;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
	КонецЕсли;	
	
	ИзменятьСоставСтрок = Ложь;
	Если Параметры.Свойство("ИзменятьСоставСтрок")
		И Параметры.ИзменятьСоставСтрок = Истина Тогда
		
		ИзменятьСоставСтрок = Истина;
	КонецЕсли;
	
	Если ЗначениеСписка = "Исполнение" Тогда
		Элементы.Список3.ИзменятьСоставСтрок  = ИзменятьСоставСтрок;
	ИначеЕсли ЗначениеСписка = "Ознакомление" Тогда
		Элементы.Список1.ИзменятьСоставСтрок  = ИзменятьСоставСтрок;
	ИначеЕсли ЗначениеСписка = "Рассмотрение" Тогда
		Элементы.Список5.ИзменятьСоставСтрок  = ИзменятьСоставСтрок;
	ИначеЕсли ЗначениеСписка = "Регистрация" Тогда
		Элементы.Список6.ИзменятьСоставСтрок  = ИзменятьСоставСтрок;
	ИначеЕсли ЗначениеСписка = "Согласование" Тогда
		Элементы.Список2.ИзменятьСоставСтрок  = ИзменятьСоставСтрок;
	ИначеЕсли ЗначениеСписка = "Подписание" Тогда
		Элементы.Список11.ИзменятьСоставСтрок  = ИзменятьСоставСтрок;
	ИначеЕсли ЗначениеСписка = "Утверждение" Тогда
		Элементы.Список7.ИзменятьСоставСтрок  = ИзменятьСоставСтрок;
	ИначеЕсли ЗначениеСписка = "Приглашение" Тогда
		Элементы.Список9.ИзменятьСоставСтрок  = ИзменятьСоставСтрок;
	ИначеЕсли ЗначениеСписка = "Комплексный" Тогда
		Элементы.Список10.ИзменятьСоставСтрок  = ИзменятьСоставСтрок;
	Иначе	
	КонецЕсли;
	
	ПоказатьУдаленные();
	
	// Условное оформление списков шаблонов.
	ШаблоныБизнесПроцессов.УстановитьУсловноеОформлениеСпискаШаблонов(СписокИсполнение.УсловноеОформление);
	ШаблоныБизнесПроцессов.УстановитьУсловноеОформлениеСпискаШаблонов(СписокКомплексный.УсловноеОформление);
	ШаблоныБизнесПроцессов.УстановитьУсловноеОформлениеСпискаШаблонов(СписокОзнакомление.УсловноеОформление);
	ШаблоныБизнесПроцессов.УстановитьУсловноеОформлениеСпискаШаблонов(СписокПриглашение.УсловноеОформление);
	ШаблоныБизнесПроцессов.УстановитьУсловноеОформлениеСпискаШаблонов(СписокРассмотрение.УсловноеОформление);
	ШаблоныБизнесПроцессов.УстановитьУсловноеОформлениеСпискаШаблонов(СписокРегистрация.УсловноеОформление);
	ШаблоныБизнесПроцессов.УстановитьУсловноеОформлениеСпискаШаблонов(СписокСогласование.УсловноеОформление);
	ШаблоныБизнесПроцессов.УстановитьУсловноеОформлениеСпискаШаблонов(СписокПодписание.УсловноеОформление);
	ШаблоныБизнесПроцессов.УстановитьУсловноеОформлениеСпискаШаблонов(СписокУтверждение.УсловноеОформление);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПоказатьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Список1ПриАктивизацииСтроки(Элемент)
	
	ШаблонСсылка = Неопределено;
	Если Элементы.Список1.ТекущиеДанные <> Неопределено
		И Не Элементы.Список1.ТекущиеДанные.ЭтоГруппа Тогда
		
		ШаблонСсылка = Элементы.Список1.ТекущаяСтрока;
	КонецЕсли;
	
	ОбновитьСводкуПриАктивизацииСтроки(ШаблонСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Список2ПриАктивизацииСтроки(Элемент)
	
	ШаблонСсылка = Неопределено;
	Если Элементы.Список2.ТекущиеДанные <> Неопределено
		И Не Элементы.Список2.ТекущиеДанные.ЭтоГруппа Тогда
		
		ШаблонСсылка = Элементы.Список2.ТекущаяСтрока;
	КонецЕсли;
	
	ОбновитьСводкуПриАктивизацииСтроки(ШаблонСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Список3ПриАктивизацииСтроки(Элемент)
	
	ШаблонСсылка = Неопределено;
	Если Элементы.Список3.ТекущиеДанные <> Неопределено
		И Не Элементы.Список3.ТекущиеДанные.ЭтоГруппа Тогда
		
		ШаблонСсылка = Элементы.Список3.ТекущаяСтрока;
	КонецЕсли;
	
	ОбновитьСводкуПриАктивизацииСтроки(ШаблонСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Список5ПриАктивизацииСтроки(Элемент)
	
	ШаблонСсылка = Неопределено;
	Если Элементы.Список5.ТекущиеДанные <> Неопределено
		И Не Элементы.Список5.ТекущиеДанные.ЭтоГруппа Тогда
		
		ШаблонСсылка = Элементы.Список5.ТекущаяСтрока;
	КонецЕсли;
	ОбновитьСводкуПриАктивизацииСтроки(ШаблонСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Список6ПриАктивизацииСтроки(Элемент)
	
	ШаблонСсылка = Неопределено;
	Если Элементы.Список6.ТекущиеДанные <> Неопределено
		И Не Элементы.Список6.ТекущиеДанные.ЭтоГруппа Тогда
		
		ШаблонСсылка = Элементы.Список6.ТекущаяСтрока;
	КонецЕсли;
	ОбновитьСводкуПриАктивизацииСтроки(ШаблонСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Список7ПриАктивизацииСтроки(Элемент)
	
	ШаблонСсылка = Неопределено;
	Если Элементы.Список7.ТекущиеДанные <> Неопределено
		И Не Элементы.Список7.ТекущиеДанные.ЭтоГруппа Тогда
		
		ШаблонСсылка = Элементы.Список7.ТекущаяСтрока;
	КонецЕсли;
	ОбновитьСводкуПриАктивизацииСтроки(ШаблонСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Список9ПриАктивизацииСтроки(Элемент)
	
	ШаблонСсылка = Неопределено;
	Если Элементы.Список9.ТекущиеДанные <> Неопределено
		И Не Элементы.Список9.ТекущиеДанные.ЭтоГруппа Тогда
		
		ШаблонСсылка = Элементы.Список9.ТекущаяСтрока;
	КонецЕсли;
	ОбновитьСводкуПриАктивизацииСтроки(ШаблонСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Список10ПриАктивизацииСтроки(Элемент)
	
	ШаблонСсылка = Неопределено;
	Если Элементы.Список10.ТекущиеДанные <> Неопределено
		И Не Элементы.Список10.ТекущиеДанные.ЭтоГруппа Тогда
		
		ШаблонСсылка = Элементы.Список10.ТекущаяСтрока;
	КонецЕсли;
	ОбновитьСводкуПриАктивизацииСтроки(ШаблонСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Список11ПриАктивизацииСтроки(Элемент)
	
	ШаблонСсылка = Неопределено;
	Если Элементы.Список11.ТекущиеДанные <> Неопределено
		И Не Элементы.Список11.ТекущиеДанные.ЭтоГруппа Тогда
		
		ШаблонСсылка = Элементы.Список11.ТекущаяСтрока;
	КонецЕсли;
	
	ОбновитьСводкуПриАктивизацииСтроки(ШаблонСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СводкаПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ОбзорПроцессовКлиент.ПредставлениеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Список1Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Элементы.Список1.ТекущаяСтрока);
		
КонецПроцедуры

&НаКлиенте
Процедура Список2Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Элементы.Список2.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура Список3Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Элементы.Список3.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура Список5Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Элементы.Список5.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура Список6Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Элементы.Список6.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура Список7Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Элементы.Список7.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура Список9Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Элементы.Список9.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура Список10Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Элементы.Список10.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура Список11Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Элементы.Список11.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	
	ПоказатьУдаленные();
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать1(Команда)
	ОповеститьОВыборе(Элементы.Список1.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура Выбрать2(Команда)
	ОповеститьОВыборе(Элементы.Список2.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура Выбрать3(Команда)
	ОповеститьОВыборе(Элементы.Список3.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура Выбрать5(Команда)
	ОповеститьОВыборе(Элементы.Список5.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура Выбрать6(Команда)
	ОповеститьОВыборе(Элементы.Список6.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура Выбрать7(Команда)
	ОповеститьОВыборе(Элементы.Список7.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура Выбрать9(Команда)
	ОповеститьОВыборе(Элементы.Список9.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура Выбрать10(Команда)
	ОповеститьОВыборе(Элементы.Список10.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура Выбрать11(Команда)
	ОповеститьОВыборе(Элементы.Список11.ТекущаяСтрока);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьСводкуПриАктивизацииСтроки(ШаблонСсылка)
	
	ТекущийШаблон = ШаблонСсылка;
	
	Если ЗначениеЗаполнено(ШаблонСсылка) Тогда
		ДляСпискаШаблоновПроцессов = Истина;
		Сводка = ОбзорПроцессовВызовСервера.ПолучитьОбзорШаблонаПроцесса(ШаблонСсылка, ДляСпискаШаблоновПроцессов);
	Иначе	
		Сводка = "<html></html>";
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьУдаленные()
	
	Если ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокИсполнение, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокОзнакомление, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокРассмотрение, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокРегистрация, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокСогласование, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокПодписание, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокУтверждение, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокКомплексный, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокПриглашение, "ПометкаУдаления");
	Иначе	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокИсполнение, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокОзнакомление, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокРассмотрение, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокРегистрация, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокСогласование, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПодписание, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокУтверждение, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКомплексный, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПриглашение, "ПометкаУдаления", Ложь);
	КонецЕсли;	
	
	Элементы.Список1ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	Элементы.Список2ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	Элементы.Список3ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	Элементы.Список5ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	Элементы.Список6ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	Элементы.Список7ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	Элементы.Список9ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	Элементы.Список10ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
КонецПроцедуры

#КонецОбласти

