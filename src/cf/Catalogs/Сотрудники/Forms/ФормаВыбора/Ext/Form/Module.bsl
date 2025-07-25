﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастроитьВидимостьКолонкиПодразделениеПриСозданииФормы();
	НастроитьОтображениеНедействительных();
	
	ПоказыватьНедействительныхСотрудников = Ложь;
	ПереключитьОтображениеНедействительныхСотрудников(Список, ПоказыватьНедействительныхСотрудников);
	
	Отбор = Параметры.Отбор;
	Если Отбор.Свойство("Подразделение") Тогда
		
		Список.Параметры.УстановитьЗначениеПараметра("Подразделение", Отбор.Подразделение);
		
	КонецЕсли;
	
	Если Отбор.Свойство("Исключение") Тогда
		
		Список.Параметры.УстановитьЗначениеПараметра("Исключение", Отбор.Исключение);
		
	КонецЕсли;
	
	Если Параметры.РежимВыбора = Истина Тогда
		
		СкрытьКомандуПоИмени("ФормаОбщаяКомандаОбсуждения");
		СкрытьКомандуПоИмени("ФормаСправочникСотрудникиИнтеграцияСКабинетСотрудника");
		СкрытьКомандуПоИмени("ФормаСправочникСотрудникиОтправитьСотрудникам");
		СкрытьКомандуПоИмени("ФормаСоздатьНаОсновании");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки["ПоказыватьНедействительныхСотрудников"] <> Неопределено Тогда
		ПереключитьОтображениеНедействительныхСотрудников(Список, ПоказыватьНедействительныхСотрудников);
	КонецЕсли;
	Элементы.ПоказыватьНедействительныхСотрудников.Пометка = ПоказыватьНедействительныхСотрудников;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	КэшДанныхСтрок = Новый Соответствие();
	СотрудникиВСтроках = Новый Массив;
	ФизЛицаВСтроках = Новый Массив;
	
	Для Каждого ДанныеСтроки Из Строки Цикл
		КэшДанныхСтрок[ДанныеСтроки.Значение.Данные.Ссылка] = ДанныеСтроки.Значение.Данные; 
		Если Не ЗначениеЗаполнено(ДанныеСтроки.Значение.Данные.ВладелецСтрокой) Тогда
			СотрудникиВСтроках.Добавить(ДанныеСтроки.Значение.Данные.Ссылка);
			ФизЛицаВСтроках.Добавить(ДанныеСтроки.Значение.Данные.Владелец);
		КонецЕсли;
	КонецЦикла;
	
	// Заполнение ВладелецСтрокой
	
	НаименованияФизЛиц = 
		ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектовВПривилегированномРежиме(
			ФизЛицаВСтроках, "Наименование");
	Для Каждого Сотрудник Из СотрудникиВСтроках Цикл
		ДанныеСтроки = КэшДанныхСтрок[Сотрудник];
		ДанныеСтроки.ВладелецСтрокой = НаименованияФизЛиц[ДанныеСтроки.Владелец];
	КонецЦикла;
	
	// Заполнение периода действия.
	
	Для Каждого ДанныеСтроки Из Строки Цикл
		
		ДатаНачалаДействия = Формат(ДанныеСтроки.Значение.Данные.ДатаНачалаДействия, "ДФ=dd.MM.yyyy");
		ДатаОкончанияДействия = Формат(ДанныеСтроки.Значение.Данные.ДатаОкончанияДействия, "ДФ=dd.MM.yyyy");
		
		Если ЗначениеЗаполнено(ДанныеСтроки.Значение.Данные.ДатаНачалаДействия)
			И ЗначениеЗаполнено(ДанныеСтроки.Значение.Данные.ДатаОкончанияДействия) Тогда
			
			ДанныеСтроки.Значение.Данные.ПериодДействия = СтрШаблон("%1 - %2",
				ДатаНачалаДействия, ДатаОкончанияДействия);
			
		ИначеЕсли ЗначениеЗаполнено(ДанныеСтроки.Значение.Данные.ДатаНачалаДействия) Тогда
			ДанныеСтроки.Значение.Данные.ПериодДействия = СтрШаблон("с %1", ДатаНачалаДействия);
		ИначеЕсли ЗначениеЗаполнено(ДанныеСтроки.Значение.Данные.ДатаОкончанияДействия) Тогда
			ДанныеСтроки.Значение.Данные.ПериодДействия = СтрШаблон("по %1", ДатаОкончанияДействия);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьНедействительныхСотрудников(Команда)
	
	ПоказыватьНедействительныхСотрудников = Не ПоказыватьНедействительныхСотрудников;
	Элементы.ПоказыватьНедействительныхСотрудников.Пометка = ПоказыватьНедействительныхСотрудников;
	ПереключитьОтображениеНедействительныхСотрудников(Список, ПоказыватьНедействительныхСотрудников);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьВидимостьКолонкиПодразделениеПриСозданииФормы()
	
	ВидимостьКолонки = Истина;
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Подразделение") Тогда
		ВидимостьКолонки = Ложь;
	КонецЕсли;
	
	Элементы.Подразделение.Видимость = ВидимостьКолонки;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеНедействительных()
	
	// Цвет недействительных.
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ЦветТекста");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет.Значение;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Список.Действует");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("Список");
	ЭлементОформляемогоПоля.Использование = Истина;
	
	// Шрифт удаленных.
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементШрифтаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Шрифт");
	ЭлементШрифтаОформления.Значение = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста,,,,,, Истина);
	ЭлементШрифтаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Список.ПометкаУдаления");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("Список");
	ЭлементОформляемогоПоля.Использование = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПереключитьОтображениеНедействительныхСотрудников(СписокСотрудников, ПоказатьНедействительных)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокСотрудников, "Действует", Истина, , , Не ПоказатьНедействительных,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Авто,
		Строка(Новый УникальныйИдентификатор));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокСотрудников, "ПометкаУдаления", Ложь, , , Не ПоказатьНедействительных,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Авто,
		Строка(Новый УникальныйИдентификатор));
	
КонецПроцедуры

// Устанавливает Видимость = Ложь для кнопки. Если кнопка не найдена, то ничего не делает
//
// Параметры:
//  Имя - Строка
//
&НаСервере
Процедура СкрытьКомандуПоИмени(Имя)
	
	Кнопка = Элементы.Найти(Имя);
	Если Кнопка <> Неопределено Тогда
		Кнопка.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти