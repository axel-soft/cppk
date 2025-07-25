﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();

	Если Параметры.Свойство("Подготовил") И ЗначениеЗаполнено(Параметры.Подготовил) Тогда
		Подготовил = Параметры.Подготовил;
	Иначе 
		Подготовил = ТекущийПользователь;
	КонецЕсли;
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь(,, Ложь);
	// Если выбираем из списка, то отбор по правам не нужен 
	Если Параметры.Свойство("ВыборИзСписка") И Параметры.ВыборИзСписка = Истина Тогда 
		ЭтоПолноправныйПользователь = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ВидДокумента) Тогда
		ТекущийВидДокумента = Параметры.ВидДокумента;
	ИначеЕсли Параметры.Свойство("РодительГруппировки") 
		И ЗначениеЗаполнено(Параметры.РодительГруппировки)
		И ТипЗнч(Параметры.РодительГруппировки) = Тип("СправочникСсылка.ПравилаОбработки") Тогда 
		ТекущийВидДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Параметры.РодительГруппировки, "ЭлементГруппировки");
	ИначеЕсли Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("ВидДокумента") Тогда 
		ТекущийВидДокумента = Параметры.Отбор.ВидДокумента;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущийВидДокумента) Тогда 
		СписокРодителейВидаДокумента = Делопроизводство.СписокРодителейВидаДокумента(ТекущийВидДокумента);
		Для Каждого ВидДокументаЗначение Из СписокРодителейВидаДокумента Цикл 
			СписокДоступныхВидов.Добавить(ВидДокументаЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Если Параметры.Свойство("ТипДокумента") Тогда
		ТипДокумента = Параметры.ТипДокумента;
	КонецЕсли;
	
	Если Параметры.Свойство("ТекущаяСтрока") Тогда
		ТекущаяСтрока = Параметры.ТекущаяСтрока;
	КонецЕсли;
	
	ЭтоОтветственныйЗаНСИ = РольДоступна("ДобавлениеИзменениеНСИ") Или РольДоступна("ПолныеПрава");
	
	ПостроитьДеревоТематик();
	
	ОбъектМетаданных = Метаданные.Справочники.ТематикиДокументов;
	
	ПравоИзменения = ПравоДоступа("Добавление", ОбъектМетаданных) И ПравоДоступа("Изменение",
		ОбъектМетаданных);
		
	Если Не ПравоИзменения Тогда 
		Элементы.Тематики.ИзменятьСоставСтрок = Ложь;
		Элементы.Добавить.Видимость = Ложь;
		Элементы.Скопировать.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("Подразделение") И ЗначениеЗаполнено(Параметры.Подразделение) Тогда 
		Подразделение = Параметры.Подразделение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Тематика_Запись" Тогда
		ПостроитьДеревоТематик();
		
		// Установим курсор в нужную строку
		Если ЗначениеЗаполнено(Параметр) Тогда 
			НашлиСтроку = Ложь; 
			КоллекцияСтрок = Тематики.ПолучитьЭлементы();
			Для Каждого Строка Из КоллекцияСтрок Цикл
				Если НашлиСтроку Тогда
					Прервать;
				КонецЕсли;
				
				Если Параметр = Строка.ОбъектГруппировки Тогда
					Элементы.Тематики.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
					НашлиСтроку = Истина;
					Прервать;
				КонецЕсли;
				
				ПодчиненныеСтроки = Строка.ПолучитьЭлементы();
				Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл 
					Если Параметр = ПодчиненнаяСтрока.ОбъектГруппировки Тогда
						Элементы.Тематики.ТекущаяСтрока = ПодчиненнаяСтрока.ПолучитьИдентификатор();
						НашлиСтроку = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока)
		И ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		КореньДерева = Тематики.ПолучитьЭлементы();
		
		ТекущийИдентификатор = НайтиИдентификаторПоСсылке(КореньДерева, ВыбранноеЗначение);
		Элементы.Тематики.ТекущаяСтрока = ТекущийИдентификатор;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТематики

&НаКлиенте
Процедура ПапкиТематикВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Выбор(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ТематикиПриАктивизацииСтроки(Элемент)
	
	// Определение маршрута тематики.
	Маршрут = Неопределено;
	ВидДокументаМаршрутаОбработки = Неопределено;
	ТематикаМаршрутаОбработки = Неопределено;
	ПодразделениеМаршрутаОбработки = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ТематикиПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ТекущиеДанные = Элементы.Тематики.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда 
		Если ЗначениеЗаполнено(ТекущиеДанные.ОбъектГруппировки) Тогда
			ПоказатьЗначение(, ТекущиеДанные.ОбъектГруппировки);
		ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.Ссылка) И 
			Не ТекущиеДанные.ЭтоГруппа Тогда
			ПоказатьЗначение(, ТекущиеДанные.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТематикиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ТекущиеДанные = Элементы.Тематики.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;
	
	Если Копирование Тогда 
		ПараметрыФормы.Вставить("ЗначениеКопирования", ТекущиеДанные.ОбъектГруппировки);
	КонецЕсли;
	
	Открытьформу("Справочник.ТематикиДокументов.ФормаОбъекта", ПараметрыФормы,
		Элементы.Тематики, Элементы.Тематики,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ТематикиПоказыватьНеактуальные(Команда)
	
	ТематикиПоказыватьНеактуальные = Не ТематикиПоказыватьНеактуальные;
	Элементы.ТематикиКонтекстноеМенюТематикиПоказыватьНеактуальные.Пометка = ТематикиПоказыватьНеактуальные;	
	ПостроитьДеревоТематик();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРезультатыПоиска

&НаКлиенте
Процедура РезультатыПоискаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Выбор(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатыПоискаПриАктивизацииСтроки(Элемент)
	
	// Определение маршрута тематики.
	Маршрут = Неопределено;
	ВидДокументаМаршрутаОбработки = Неопределено;
	ТематикаМаршрутаОбработки = Неопределено;
	ПодразделениеМаршрутаОбработки = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбор(Команда)
	
	Если Элементы.РезультатыПоиска.Видимость Тогда
		ТекущиеДанные = Элементы.РезультатыПоиска.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.Тематики.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбрана тематика документа'"));
		Возврат;
	КонецЕсли;
	
	ТекущаяТематика = ТекущиеДанные.Ссылка;
	
	ОповеститьОВыборе(ТекущаяТематика);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПостроитьДеревоТематик()
	
	Дерево = РеквизитФормыВЗначение("Тематики");
	Дерево.Строки.Очистить();
	
	ПолучитьВсеПапкиТематик(Дерево);
	
	ЗначениеВДанныеФормы(Дерево, Тематики);
	
	УстановитьТекущуюСтрокуВДеревеНаПервыйЗначащийЭлемент();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьВсеПапкиТематик(Дерево)
	
	КоличествоТематик = 0;
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТематикиДокументов.Наименование,
		|	ТематикиДокументов.Ссылка,
		|	3 КАК Пиктограмма,
		|	ТематикиДокументов.Наименование КАК НаименованиеСортировки
		|ИЗ
		|	Справочник.ТематикиДокументов КАК ТематикиДокументов
		|ГДЕ
		|	ТематикиДокументов.ПометкаУдаления = ЛОЖЬ";
		
	Если Не ТематикиПоказыватьНеактуальные Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И (НЕ ТематикиДокументов.НеДействует
		|		ИЛИ ТематикиДокументов.НеДействуетДата > &ТекущаяДата)";
		
		Запрос.Параметры.Вставить("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	КонецЕсли;
	
	СтрокаВсе = Дерево;
	Если СписокДоступныхВидов.Количество() > 0 Тогда 
		Запрос.Текст = Запрос.Текст + "
				|	И ТематикиДокументов.ВидДокумента В(&СписокДоступныхВидов)";
		Запрос.Параметры.Вставить("СписокДоступныхВидов", СписокДоступныхВидов);
		
		РезультатыПоиска.ТекстЗапроса = РезультатыПоиска.ТекстЗапроса + "
			|	И ТематикиДокументов.ВидДокумента В (&СписокДоступныхВидов)";
		
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(РезультатыПоиска,
			"СписокДоступныхВидов",
			СписокДоступныхВидов.ВыгрузитьЗначения(),
			Истина);
	ИначеЕсли ЗначениеЗаполнено(ТекущийВидДокумента) Тогда 
		Запрос.Текст = Запрос.Текст + "
			|	И ТематикиДокументов.ВидДокумента = &ВидДокумента";
		Запрос.Параметры.Вставить("ВидДокумента", ТекущийВидДокумента);
		РезультатыПоиска.ТекстЗапроса = РезультатыПоиска.ТекстЗапроса + "
			|	И ТематикиДокументов.ВидДокумента = &ВидДокумента";
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(РезультатыПоиска,
			"ВидДокумента",
			ТекущийВидДокумента,
			Истина);
	ИначеЕсли СозданиеОбращенияГраждан Тогда
		
		Запрос.Текст = Запрос.Текст + "
			|	И (ТематикиДокументов.ВидДокумента.ЯвляетсяОбращениемОтГраждан))";
		Запрос.Параметры.Вставить("СозданиеОбращенияГраждан", СозданиеОбращенияГраждан);
		
		РезультатыПоиска.ТекстЗапроса = РезультатыПоиска.ТекстЗапроса + "
			|	И (ТематикиДокументов.ВидДокумента.ЯвляетсяОбращениемОтГраждан))";
	ИначеЕсли ТипДокумента <> Неопределено Тогда  
		РезультатыПоиска.ТекстЗапроса = РезультатыПоиска.ТекстЗапроса + "
			|	И ТИПЗНАЧЕНИЯ(ТематикиДокументов.ВидДокумента) = ТИПЗНАЧЕНИЯ(&ТипДокумента)";
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(РезультатыПоиска,
			"ТипДокумента",
			ТипДокумента,
			Истина);
		
	КонецЕсли;
	
	Если ЭтоОтветственныйЗаНСИ Тогда
		Запрос.Текст = Запрос.Текст + "
			|УПОРЯДОЧИТЬ ПО Наименование";
	Иначе 
		Запрос.Текст = Запрос.Текст + "
			|УПОРЯДОЧИТЬ ПО НаименованиеСортировки, Наименование";
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаГруппировки = СтрокаВсе.Строки.Добавить();
		СтрокаГруппировки.ОбъектГруппировки = Выборка.Ссылка;
		СтрокаГруппировки.ЭтоГруппа = Ложь;
		СтрокаГруппировки.Представление = Строка(Выборка.Ссылка);
		СтрокаГруппировки.Ссылка = Выборка.Ссылка;
		КоличествоТематик = КоличествоТематик + 1;
		
	КонецЦикла;
	
	ВДеревеЕстьАктивныеТематики(Дерево);
	
КонецПроцедуры

&НаСервере
Функция ВДеревеЕстьАктивныеТематики(Дерево)
	
	ЕстьШаблоны = Ложь;
	МассивУдаляемыхГрупп = Новый Массив;
	
	Для Каждого СтрокаДерева Из Дерево.Строки Цикл
		Если СтрокаДерева.ЭтоГруппа Тогда 
			Если Не ВДеревеЕстьАктивныеТематики(СтрокаДерева) Тогда 
				МассивУдаляемыхГрупп.Добавить(СтрокаДерева);
			Иначе 
				ЕстьШаблоны = Истина;
			КонецЕсли;
		Иначе 
			ЕстьШаблоны = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Группа Из МассивУдаляемыхГрупп Цикл 
		Для Каждого СтрокаДерева Из Дерево.Строки Цикл
			Если Группа = СтрокаДерева Тогда 
				Дерево.Строки.Удалить(СтрокаДерева);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ЕстьШаблоны;
	
КонецФункции

&НаСервере
Процедура УстановитьТекущуюСтрокуВДеревеНаПервыйЗначащийЭлемент()
	
	Если ЗначениеЗаполнено(ТекущаяСтрока) Тогда 
		КореньДерева = Тематики.ПолучитьЭлементы();
		
		ТекущийИдентификатор = НайтиИдентификаторПоСсылке(КореньДерева, ТекущаяСтрока);
		Элементы.Тематики.ТекущаяСтрока = ТекущийИдентификатор;
	Иначе 
		ЭлементыДерева = Тематики.ПолучитьЭлементы();
		Если ЭлементыДерева.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		ПерваяГруппа = ЭлементыДерева[0];
		Если ПерваяГруппа.ПолучитьЭлементы().Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		ПервыйЭлементПервойГруппы = ПерваяГруппа.ПолучитьЭлементы()[0];
		Индекс = ПервыйЭлементПервойГруппы.ПолучитьИдентификатор();
		Элементы.Тематики.ТекущаяСтрока = Индекс;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НайтиИдентификаторПоСсылке(ЭлементыДерева, ТекущаяСсылка)
	
	Для Каждого Строка Из ЭлементыДерева Цикл
		
		Если Строка.Ссылка = ТекущаяСсылка Тогда
			Возврат Строка.ПолучитьИдентификатор();
		КонецЕсли;
		
		ДочерниеЭлементыДерева = Строка.ПолучитьЭлементы();
		Идентификатор = НайтиИдентификаторПоСсылке(ДочерниеЭлементыДерева, ТекущаяСсылка);
		Если Идентификатор <> Неопределено Тогда
			Возврат Идентификатор;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти