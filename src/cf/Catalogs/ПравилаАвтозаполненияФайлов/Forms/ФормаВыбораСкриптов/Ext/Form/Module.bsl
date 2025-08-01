﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокФормы) Тогда
		Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;
	
	ТекущееПравило = Параметры.ТекущееПравило;
	ПоляФайла = Параметры.ПоляФайла;
	КопируемыеСкрипты = Новый Структура;
	
	НастройкиФормы = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(ИмяФормы + "/ТекущиеДанные", "");
	Если НастройкиФормы = Неопределено Или НастройкиФормы.Получить("ПоказыватьУдаленные") = Неопределено Тогда
		Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	КонецЕсли;
	
	ЗаполнитьСкрипты();
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки["ПоказыватьУдаленные"] <> Неопределено Тогда
		ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
		Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	ЗаполнитьСкрипты();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("ДоступныеВидыДокументов", ВидыДокументовОтбор);
	ОткрытьФорму("Справочник.ВидыДокументов.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораВидовДокументов(Текст, ВидыДокументовОтбор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораВидовДокументов(Текст, ВидыДокументовОтбор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСкрипты

&НаКлиенте
Процедура СкриптыВыбратьПриИзменении(Элемент)
	
	ТекущаяСтрока = Скрипты.НайтиПоИдентификатору(Элементы.Скрипты.ТекущаяСтрока);
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущаяСтрока.Флаг = 2 Тогда
		ТекущаяСтрока.Флаг = 0;
	КонецЕсли;
	
	УстановитьФлагиРекурсивно(ТекущаяСтрока, ТекущаяСтрока.Флаг);
	
	Пока ТекущаяСтрока.ПолучитьРодителя() <> Неопределено Цикл
		ТекущаяСтрока.ПолучитьРодителя().Флаг =
			?(ФлагУстановленДляВсехСтрокТекущегоУровня(ТекущаяСтрока), ТекущаяСтрока.Флаг, 2);
		ТекущаяСтрока = ТекущаяСтрока.ПолучитьРодителя();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
	ЗаполнитьСкрипты();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлаги(Команда)
	
	УстановитьФлагиДляТекущейВетки(1);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлаги(Команда)
	
	УстановитьФлагиДляТекущейВетки(0);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВсе(Команда)
	
	Для Каждого Элемент Из Скрипты.ПолучитьЭлементы() Цикл
		Элементы.Скрипты.Развернуть(Элемент.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьВсе(Команда)
	
	Для Каждого Элемент Из Скрипты.ПолучитьЭлементы() Цикл
		Элементы.Скрипты.Свернуть(Элемент.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиСкрипты(Команда)
	
	Если Не КопируемыеСкрипты.Количество() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выберите хотя бы один скрипт.'"));
	Иначе
		Закрыть(КопируемыеСкрипты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСкрипты()
	
	Дерево = РеквизитФормыВЗначение("Скрипты");
	Дерево.Строки.Очистить();
	КопируемыеСкрипты.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПравилаАвтозаполненияФайлов.ВладелецФайла КАК ВладелецФайла,
		|	ПравилаАвтозаполненияФайлов.ПометкаУдаления КАК ПометкаУдаления,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ПравилаАвтозаполненияФайлов.ВладелецФайла) КАК ВладелецФайлаПредставление,
		|	ПравилаАвтозаполненияФайлов.ШаблонФайла КАК ШаблонФайла,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ПравилаАвтозаполненияФайлов.ШаблонФайла) КАК ШаблонФайлаПредставление,
		|	НастройкиАвтозаполнения.ТермДляЗамены КАК ПолеФайла,
		|	ВЫРАЗИТЬ(НастройкиАвтозаполнения.ТермДляЗамены КАК СТРОКА(250)) В (&ПоляФайла) КАК
		|		ЭтоПолеИсточника,
		|	НастройкиАвтозаполнения.ВыражениеОбработкиРезультатаЗамены КАК Скрипт
		|ИЗ
		|	Справочник.ПравилаАвтозаполненияФайлов.ДанныеДляАвтозаполнения КАК НастройкиАвтозаполнения
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПравилаАвтозаполненияФайлов КАК ПравилаАвтозаполненияФайлов
		|		ПО (НастройкиАвтозаполнения.Ссылка = ПравилаАвтозаполненияФайлов.Ссылка)
		|			И &ОтборВидДокумента
		|			И &ОтборУдаленные
		|ГДЕ
		|	ПравилаАвтозаполненияФайлов.Ссылка <> &ТекущееПравило
		|	И ВЫРАЗИТЬ(НастройкиАвтозаполнения.ВыражениеОбработкиРезультатаЗамены КАК
		|		СТРОКА(10)) <> """"
		|ИТОГИ
		|ПО
		|	ШаблонФайла";
	
	Запрос.УстановитьПараметр("ТекущееПравило", ТекущееПравило);
	Запрос.УстановитьПараметр("ПоляФайла", ПоляФайла);
	Если ЗначениеЗаполнено(ВидДокумента) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборВидДокумента",
			"ПравилаАвтозаполненияФайлов.ВладелецФайла = &ВидДокумента");
		Запрос.УстановитьПараметр("ВидДокумента", ВидДокумента);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборВидДокумента", "Истина");
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборУдаленные",
		?(ПоказыватьУдаленные, "Истина", "НЕ ПравилаАвтозаполненияФайлов.ПометкаУдаления"));
	
	ВыборкаШаблоныФайлов = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
	Пока ВыборкаШаблоныФайлов.Следующий() Цикл
		
		СтрокаВидаДокумента = Дерево.Строки.Добавить();
		СтрокаВидаДокумента.ШаблонФайла = ВыборкаШаблоныФайлов.ШаблонФайла;
		
		ВыборкаСкриптыПолей = ВыборкаШаблоныФайлов.Выбрать();
		
		Пока ВыборкаСкриптыПолей.Следующий() Цикл
			
			СтрокаВидаДокумента.ВидДокумента = ВыборкаСкриптыПолей.ВладелецФайла;
			СтрокаВидаДокумента.ПометкаУдаления = ВыборкаСкриптыПолей.ПометкаУдаления;
			Если ВидыДокументовОтбор.НайтиПоЗначению(СтрокаВидаДокумента.ВидДокумента) = Неопределено Тогда
				ВидыДокументовОтбор.Добавить(СтрокаВидаДокумента.ВидДокумента);
			КонецЕсли;
			СтрокаВидаДокумента.ШаблонФайлаПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 (Вид: %2)'"),
				ВыборкаСкриптыПолей.ШаблонФайлаПредставление,
				ВыборкаСкриптыПолей.ВладелецФайлаПредставление);
			
			СтрокаСкрипта = СтрокаВидаДокумента.Строки.Добавить();
			СтрокаСкрипта.ПолеФайла = ВыборкаСкриптыПолей.ПолеФайла;
			СтрокаСкрипта.Скрипт = ВыборкаСкриптыПолей.Скрипт;
			СтрокаСкрипта.ЭтоПолеИсточника = ВыборкаСкриптыПолей.ЭтоПолеИсточника;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Дерево.Строки.Сортировать("ШаблонФайлаПредставление");
	
	ЗначениеВРеквизитФормы(Дерево, "Скрипты");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформироватьДанныеВыбораВидовДокументов(Текст, ВидыДокументов)
	
	ДанныеВыбора = Новый СписокЗначений;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыДокументов.Ссылка
		|ИЗ
		|	Справочник.ВидыДокументов КАК ВидыДокументов
		|ГДЕ
		|	ВидыДокументов.Наименование ПОДОБНО &Текст
		|	И ВидыДокументов.Ссылка В (&ВидыДокументов)";
	
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	Запрос.УстановитьПараметр("ВидыДокументов", ВидыДокументов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 (%2)'"), Выборка.Ссылка, ТипЗнч(Выборка.Ссылка)));
	КонецЦикла;
		
	Возврат ДанныеВыбора;
	
КонецФункции

&НаКлиенте
Процедура УстановитьФлагиДляТекущейВетки(Значение)
	
	ТекущаяСтрока = Скрипты.НайтиПоИдентификатору(Элементы.Скрипты.ТекущаяСтрока);
	Пока ТекущаяСтрока.ПолучитьРодителя() <> Неопределено Цикл
		ТекущаяСтрока = ТекущаяСтрока.ПолучитьРодителя();
	КонецЦикла;
	
	ТекущаяСтрока.Флаг = Значение;
	УстановитьФлагиРекурсивно(ТекущаяСтрока, Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлагиРекурсивно(ТекущаяСтрока, Значение)
	
	ДополнитьКопируемыеСкрипты(ТекущаяСтрока);
	
	Для Каждого Строка Из ТекущаяСтрока.ПолучитьЭлементы() Цикл
		Строка.Флаг = Значение;
		УстановитьФлагиРекурсивно(Строка, Строка.Флаг);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ФлагУстановленДляВсехСтрокТекущегоУровня(Строка)
	
	Для Каждого Стр Из Строка.ПолучитьРодителя().ПолучитьЭлементы() Цикл
		Если Стр.Флаг <> Строка.Флаг Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьСбросФлагаДляРодителей(Строка)
	
	Пока Строка.ПолучитьРодителя() <> Неопределено Цикл
		Строка.ПолучитьРодителя().Флаг =
			?(ФлагУстановленДляВсехСтрокТекущегоУровня(Строка), Строка.Флаг, 2);
		Строка = Строка.ПолучитьРодителя();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьКопируемыеСкрипты(Строка)
	
	Если Не ЗначениеЗаполнено(Строка.ПолеФайла) Тогда
		Возврат;
	КонецЕсли;
	
	Если Строка.Флаг = 1 Тогда
		
		Позиция = Строка.ПолучитьИдентификатор();
		Если КопируемыеСкрипты.Свойство(Строка.ПолеФайла) И КопируемыеСкрипты[Строка.ПолеФайла].Позиция <> Позиция Тогда
			
			ИсключаемаяСтрока = Скрипты.НайтиПоИдентификатору(КопируемыеСкрипты[Строка.ПолеФайла].Позиция);
			ИсключаемаяСтрока.Флаг = 0;
			
			ОбработатьСбросФлагаДляРодителей(ИсключаемаяСтрока);
			
		ИначеЕсли Не КопируемыеСкрипты.Свойство(Строка.ПолеФайла) Тогда
			
			КопируемыеСкрипты.Вставить(Строка.ПолеФайла, Новый Структура("Скрипт, Позиция"));
			
		КонецЕсли;
		
		КопируемыеСкрипты[Строка.ПолеФайла].Скрипт = Строка.Скрипт;
		КопируемыеСкрипты[Строка.ПолеФайла].Позиция = Позиция;
		
	Иначе
		
		Если КопируемыеСкрипты.Свойство(Строка.ПолеФайла) Тогда
			КопируемыеСкрипты.Удалить(Строка.ПолеФайла);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Шрифт");
	ЭлементОформления.Значение = Новый Шрифт(,,, Истина);
	ЭлементОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Скрипты.ЭтоПолеИсточника");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("СкриптыПолеФайла");
	ЭлементОформляемогоПоля.Использование = Истина;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Текст");
	ЭлементОформления.Значение = "";
	ЭлементОформления.Использование = Истина;
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("СкриптыШаблонФайла");
	ЭлементОформляемогоПоля.Использование = Истина;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Шрифт");
	ЭлементОформления.Значение = Новый Шрифт(,,,,, Истина);
	ЭлементОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Скрипты.ПометкаУдаления");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("СкриптыШаблонФайлаПредставление");
	ЭлементОформляемогоПоля.Использование = Истина;
	
КонецПроцедуры

#КонецОбласти
