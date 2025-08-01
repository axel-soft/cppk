﻿//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Режим = "ТолькоКонтрагенты" Тогда 	
		ЭтаФорма.Заголовок = НСтр("ru = 'Выбор контрагента'");
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
        Элементы.СписокКонтактныеЛица.Видимость = Ложь;
		ПоискТолькоКонтрагентов = Истина;
	ИначеЕсли Параметры.Режим = "КонтрагентыКонтактныеЛица" Тогда 	
		ЭтаФорма.Заголовок = НСтр("ru = 'Выбор контрагента и контактного лица'");
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	Иначе
		ЭтаФорма.Заголовок = НСтр("ru = 'Выбор получателя'");
	КонецЕсли;	
	
	Если Параметры.Свойство("ЮрФизЛицо") И ЗначениеЗаполнено(Параметры.ЮрФизЛицо) Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокКонтрагенты.Отбор,
			"ЮрФизЛицо", Параметры.ЮрФизЛицо);
	КонецЕсли;	
	
	Получатель = Параметры.Получатель;
	
	Если ЗначениеЗаполнено(Получатель) Тогда
		Если ТипЗнч(Параметры.Получатель) = Тип("СправочникСсылка.КонтактныеЛица") Тогда 
			Элементы.СписокКонтрагенты.ТекущаяСтрока = Параметры.Получатель.Владелец;
			Элементы.СписокКонтактныеЛица.ТекущаяСтрока = Параметры.Получатель;
		ИначеЕсли ТипЗнч(Параметры.Получатель) = Тип("СправочникСсылка.Контрагенты") Тогда 
			Элементы.СписокКонтрагенты.ТекущаяСтрока = Получатель;
      	ИначеЕсли ТипЗнч(Получатель) = Тип("СправочникСсылка.СпискиРассылкиПоКонтрагентам") Тогда
		    Элементы.Страницы.ТекущаяСтраница = Элементы.СпискиРассылки;
			Элементы.СписокСпискиРассылки.ТекущаяСтрока = Получатель;
		КонецЕсли;	
	КонецЕсли;	
	
	СписокКонтактныеЛица.Параметры.УстановитьЗначениеПараметра("Контрагент", 
		Элементы.СписокКонтрагенты.ТекущаяСтрока);
	СохранениеВводимыхЗначений.ЗагрузитьСписокВыбора(ЭтаФорма, "СтрокаПоиска");
	
	ПоказыватьУдаленные = Ложь;
	ПоказатьУдаленные();
	
	Если Параметры.Свойство("ПометкаУдаления") И Не Параметры.ПометкаУдаления Тогда 
		Элементы.ПоказыватьУдаленные.Видимость = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
    ПроверкаКонтрагентов.ПриСозданииНаСервереСписокКонтрагентов(СписокКонтрагенты);
    // Конец СтандартныеПодсистемы.РаботаСКонтрагентами 
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Не Параметры.Свойство("ПометкаУдаления") Тогда 
		ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
		ПоказатьУдаленные();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// Работа с поиском

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)

	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		
		СтрокаПоиска = СокрЛП(СтрокаПоиска);
	
		Если СтрДлина(СтрокаПоиска) < 3 И СтрокаПоиска <> "*" И СтрокаПоиска <> "**" Тогда			
			ЭтаФорма.ТекущийЭлемент = Элементы.СтрокаПоиска;
			ЭтаФорма.Активизировать();
			ПоказатьПредупреждение(, НСтр("ru = 'Необходимо ввести минимум 3 символа'"));
			Возврат;
		КонецЕсли;
	    	
		СохранениеВводимыхЗначенийКлиент.ОбновитьСписокВыбора(ЭтаФорма, "СтрокаПоиска", 10);

		ПустойРезультатПоиска = Ложь;
		НайтиКонтрагентовИКонтактныеЛица();
		ПустойРезультатПоиска = ДеревоКонтрагентов.ПолучитьЭлементы().Количество() = 0;
		
		Если ПустойРезультатПоиска Тогда
			ТекущийЭлемент = Элементы.СтрокаПоиска;
			УстановитьВидимостьРезультатаПоискаКонтрагентов(Ложь);
			ПоказатьПредупреждение(, НСтр("ru = 'По вашему запросу ничего не найдено'"));
		Иначе
			ТекущийЭлемент = Элементы.ДеревоКонтрагентов;
			УстановитьВидимостьРезультатаПоискаКонтрагентов(Истина);		
			РазвернутьДерево("ДеревоКонтрагентов");	
		КонецЕсли;
		
		ПоискВключен = Истина;
	Иначе
		Если ПоискВключен Тогда
			ОчиститьПоиск();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	СтрокаПоиска = Неопределено;
	ОчиститьПоиск();
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ КОНТРАГЕНТЫ

&НаКлиенте
Процедура СписокКонтрагентыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Не Элементы.СписокКонтрагенты.ТекущиеДанные.ЭтоГруппа Тогда 
		ОповеститьОВыборе(Элементы.СписокКонтрагенты.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКонтрагентыПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжиданияКонтактныеЛица", 0.2, Истина);

КонецПроцедуры

&НаКлиенте
Процедура СписокКонтрагентыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОповеститьОВыборе(Элементы.СписокКонтрагенты.ТекущаяСтрока);
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДЕРЕВО КОНТРАГЕНТОВ

&НаКлиенте
Процедура ДеревоКонтрагентовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоКонтрагентов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	

	Если ТекущиеДанные.ЭтоКонтактноеЛицо Тогда
		Контрагент = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
			ТекущиеДанные.Ссылка, "Владелец");
		ОповеститьОВыборе(Новый Структура(
			"Контрагент, КонтактноеЛицо", 
			Контрагент, 
			ТекущиеДанные.Ссылка));
	Иначе					
		ОповеститьОВыборе(ТекущиеДанные.Ссылка);
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтрагентовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	Возврат;

КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтрагентовПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ТекущиеДанные = Элементы.ДеревоКонтрагентов.ТекущиеДанные;

	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.Ссылка);
		
		Если ТекущиеДанные.ЭтоКонтактноеЛицо Тогда					
			ОткрытьФорму("Справочник.КонтактныеЛица.Форма.ФормаЭлемента", ПараметрыФормы,,,,,,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);		
		Иначе			
			ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаЭлемента", ПараметрыФормы,,,,,,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;		
		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтрагентовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	Возврат;

КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ КОНТАКТНЫЕ ЛИЦА

&НаКлиенте
Процедура СписокКонтактныеЛицаВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Новый Структура(
		"Контрагент, КонтактноеЛицо", 
		Элементы.СписокКонтрагенты.ТекущаяСтрока, 
		Значение));
		
КонецПроцедуры

&НаКлиенте
Процедура СписокКонтактныеЛицаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование Тогда 
		Возврат;
	КонецЕсли;	
	
	Владелец = Элементы.СписокКонтрагенты.ТекущаяСтрока;
	
	Если Не ЗначениеЗаполнено(Владелец) Тогда 
		Возврат;
	КонецЕсли;	
	
	Отказ = Истина;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Владелец", Владелец);

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
	ОткрытьФорму("Справочник.КонтактныеЛица.ФормаОбъекта", ПараметрыФормы, Элемент);	
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СПИСКИ РАССЫЛКИ

&НаКлиенте
Процедура СписокСпискиРассылкиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Контрагенты Тогда
		
		Если ПоискВключен Тогда
			
			ТекущиеДанные = Элементы.ДеревоКонтрагентов.ТекущиеДанные;
			Если ТекущиеДанные = Неопределено Тогда 
				Возврат;
			КонецЕсли;
			
			Если ТекущиеДанные.ЭтоКонтактноеЛицо Тогда
				Контрагент = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
					ТекущиеДанные.Ссылка, "Владелец");
				ОповеститьОВыборе(Новый Структура(
					"Контрагент, КонтактноеЛицо", 
					Контрагент, 
					ТекущиеДанные.Ссылка));
			Иначе					
				ОповеститьОВыборе(ТекущиеДанные.Ссылка);
			КонецЕсли;
			
		ИначеЕсли Элементы.СписокКонтактныеЛица.ТекущаяСтрока <> Неопределено Тогда 
			
			ОповеститьОВыборе(Новый Структура(
				"Контрагент, КонтактноеЛицо", 
				Элементы.СписокКонтрагенты.ТекущаяСтрока, 
				Элементы.СписокКонтактныеЛица.ТекущаяСтрока));
						
		ИначеЕсли Элементы.СписокКонтрагенты.ТекущаяСтрока <> Неопределено Тогда 
			
			Если Не Элементы.СписокКонтрагенты.ТекущиеДанные.ЭтоГруппа Тогда 
				ОповеститьОВыборе(Элементы.СписокКонтрагенты.ТекущаяСтрока);
			КонецЕсли;
			
        КонецЕсли;
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СпискиРассылки Тогда 
		
		Если Элементы.СписокСпискиРассылки.ТекущаяСтрока = Неопределено Тогда 
			Возврат;
		КонецЕсли;	
		
		ОповеститьОВыборе(Элементы.СписокСпискиРассылки.ТекущаяСтрока);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИсторию(Команда)
	
	СохранениеВводимыхЗначенийКлиент.ОчиститьСписокВыбора(ЭтаФорма, "СтрокаПоиска");

КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	
	ПоказатьУдаленные();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбработкаОжиданияКонтактныеЛица()
	
	Если Элементы.СписокКонтрагенты.ТекущаяСтрока <> Неопределено Тогда 
		СписокКонтактныеЛица.Параметры.УстановитьЗначениеПараметра("Контрагент", Элементы.СписокКонтрагенты.ТекущаяСтрока);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево(ИмяРеквизитаДерева)
		
	Для каждого СтрокаДерева Из ЭтаФорма[ИмяРеквизитаДерева].ПолучитьЭлементы() Цикл
		Элементы[ИмяРеквизитаДерева].Развернуть(СтрокаДерева.ПолучитьИдентификатор(), Истина);
	КонецЦикла;                                                                               	
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с расширенным поиском контрагентов и контактных лиц

&НаСервере
Функция ПолучитьТекстЗапросаДляПоискаКонтрагентовИКонтактныхЛиц() 
	
	Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КонтрагентыКонтактнаяИнформация.Ссылка КАК ВладелецОбъекта,
		|	КонтрагентыКонтактнаяИнформация.Ссылка КАК ОбъектПоиска,
		|	КонтрагентыКонтактнаяИнформация.Представление КАК ЗначениеПоиска,
		|	КонтрагентыКонтактнаяИнформация.Ссылка.Наименование КАК НаименованиеВладельца,
		|	КонтрагентыКонтактнаяИнформация.Ссылка.Наименование КАК НаименованиеОбъекта
		|ИЗ
		|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
		|ГДЕ
		|	НЕ КонтрагентыКонтактнаяИнформация.Ссылка.ЭтоГруппа
		|	И НЕ КонтрагентыКонтактнаяИнформация.Ссылка.ПометкаУдаления
		|	И КонтрагентыКонтактнаяИнформация.Представление ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Контрагенты.Ссылка,
		|	Контрагенты.Ссылка,
		|	Контрагенты.Наименование + ""~"" + Контрагенты.ИНН + ""~"" + Контрагенты.КПП + ""~"" + Контрагенты.КодПоОКПО + ""~"" + Контрагенты.РегистрационныйНомер,
		|	Контрагенты.Наименование,
		|	Контрагенты.Наименование
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	НЕ Контрагенты.ЭтоГруппа
		|	И НЕ Контрагенты.ПометкаУдаления
		|	И Контрагенты.Наименование + ""~"" + Контрагенты.ИНН + ""~"" + Контрагенты.КПП + ""~"" + Контрагенты.КодПоОКПО + ""~"" + Контрагенты.РегистрационныйНомер ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Контрагенты.Ссылка,
		|	Контрагенты.Ссылка,
		|	ВЫРАЗИТЬ(Контрагенты.НаименованиеПолное КАК СТРОКА(1000)),
		|	Контрагенты.Наименование,
		|	Контрагенты.Наименование
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	НЕ Контрагенты.ЭтоГруппа
		|	И НЕ Контрагенты.ПометкаУдаления
		|	И Контрагенты.НаименованиеПолное ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Контрагенты.Ссылка,
		|	КонтактныеЛицаКонтактнаяИнформация.Ссылка,
		|	КонтактныеЛицаКонтактнаяИнформация.Представление,
		|	Контрагенты.Наименование,
		|	КонтактныеЛицаКонтактнаяИнформация.Ссылка.Наименование
		|ИЗ
		|	Справочник.КонтактныеЛица.КонтактнаяИнформация КАК КонтактныеЛицаКонтактнаяИнформация
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
		|		ПО КонтактныеЛицаКонтактнаяИнформация.Ссылка.Владелец = Контрагенты.Ссылка
		|ГДЕ
		|	НЕ Контрагенты.ЭтоГруппа
		|	И НЕ Контрагенты.ПометкаУдаления
		|	И КонтактныеЛицаКонтактнаяИнформация.Представление ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Контрагенты.Ссылка,
		|	КонтактныеЛица.Ссылка,
		|	КонтактныеЛица.Наименование,
		|	Контрагенты.Наименование,
		|	КонтактныеЛица.Наименование
		|ИЗ
		|	Справочник.КонтактныеЛица КАК КонтактныеЛица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
		|		ПО КонтактныеЛица.Владелец = Контрагенты.Ссылка
		|ГДЕ
		|	КонтактныеЛица.ПометкаУдаления = ЛОЖЬ
		|	И Контрагенты.ПометкаУдаления = ЛОЖЬ
		|	И КонтактныеЛица.Наименование ПОДОБНО &СтрокаПоиска
		|
		|УПОРЯДОЧИТЬ ПО
		|	НаименованиеВладельца,
		|	НаименованиеОбъекта
		|ИТОГИ ПО
		|	ВладелецОбъекта";

	Возврат Текст;

КонецФункции

&НаСервере
Функция ПолучитьТекстЗапросаДляПоискаКонтрагентов() 
	
	Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КонтрагентыКонтактнаяИнформация.Ссылка КАК ВладелецОбъекта,
		|	КонтрагентыКонтактнаяИнформация.Ссылка КАК ОбъектПоиска,
		|	КонтрагентыКонтактнаяИнформация.Представление КАК ЗначениеПоиска,
		|	КонтрагентыКонтактнаяИнформация.Ссылка.Наименование КАК НаименованиеВладельца,
		|	КонтрагентыКонтактнаяИнформация.Ссылка.Наименование КАК НаименованиеОбъекта
		|ИЗ
		|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
		|ГДЕ
		|	НЕ КонтрагентыКонтактнаяИнформация.Ссылка.ЭтоГруппа
		|	И НЕ КонтрагентыКонтактнаяИнформация.Ссылка.ПометкаУдаления
		|	И КонтрагентыКонтактнаяИнформация.Ссылка.ЮрФизЛицо = &ФизЛицо
		|	И КонтрагентыКонтактнаяИнформация.Представление ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Контрагенты.Ссылка,
		|	Контрагенты.Ссылка,
		|	ПОДСТРОКА(Контрагенты.НаименованиеПолное, 0, 1000),
		|	Контрагенты.Наименование,
		|	Контрагенты.Наименование
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	НЕ Контрагенты.ЭтоГруппа
		|	И НЕ Контрагенты.ПометкаУдаления
		|	И Контрагенты.ЮрФизЛицо = &ФизЛицо
		|	И Контрагенты.НаименованиеПолное ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Контрагенты.Ссылка,
		|	Контрагенты.Ссылка,
		|	Контрагенты.Наименование + ""~"" + Контрагенты.ИНН + ""~"" + Контрагенты.КПП + ""~"" + Контрагенты.КодПоОКПО + ""~"" + Контрагенты.РегистрационныйНомер,
		|	Контрагенты.Наименование,
		|	Контрагенты.Наименование
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	НЕ Контрагенты.ЭтоГруппа
		|	И НЕ Контрагенты.ПометкаУдаления
		|	И Контрагенты.ЮрФизЛицо = &ФизЛицо
		|	И Контрагенты.Наименование + ""~"" + Контрагенты.ИНН + ""~"" + Контрагенты.КПП + ""~"" + Контрагенты.КодПоОКПО + ""~"" + Контрагенты.РегистрационныйНомер ПОДОБНО &СтрокаПоиска
		|
		|УПОРЯДОЧИТЬ ПО
		|	НаименованиеВладельца,
		|	НаименованиеОбъекта
		|ИТОГИ ПО
		|	ВладелецОбъекта";
		
	Возврат Текст;

КонецФункции

&НаСервере
Процедура НайтиКонтрагентовИКонтактныеЛица()
	
	Запрос = Новый Запрос;
	
	Если ПоискТолькоКонтрагентов Тогда
		Запрос.Текст = ПолучитьТекстЗапросаДляПоискаКонтрагентов();
		Запрос.Параметры.Вставить("ФизЛицо", Перечисления.ЮрФизЛицо.ФизЛицо);
	Иначе
		Запрос.Текст = ПолучитьТекстЗапросаДляПоискаКонтрагентовИКонтактныхЛиц();
	КонецЕсли;
	
	Запрос.УстановитьПараметр("СтрокаПоиска", "%" + СтрокаПоиска + "%");
	
	Результат = Запрос.Выполнить();

	Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	КореньДерева = ДеревоКонтрагентов.ПолучитьЭлементы();
	КореньДерева.Очистить();
	Пока Выборка.Следующий() Цикл
		
		Если Не Элементы.ДеревоКонтрагентов.Видимость Тогда 
			Элементы.ДеревоКонтрагентов.Видимость = Истина;
		КонецЕсли;	
		
		НовыйКонтрагент = КореньДерева.Добавить();
		НовыйКонтрагент.Наименование = Выборка.НаименованиеВладельца;
		НовыйКонтрагент.Ссылка = Выборка.ВладелецОбъекта;
		НовыйКонтрагент.НомерКартинки = 3;
		
		ВыборкаПоКонтактнымЛицам = Выборка.Выбрать();
		Пока ВыборкаПоКонтактнымЛицам.Следующий() Цикл
			
			ТипОбъекта = ТипЗнч(ВыборкаПоКонтактнымЛицам.ОбъектПоиска);
			Если ТипОбъекта <> Тип("СправочникСсылка.КонтактныеЛица") Тогда
				Продолжить;
			КонецЕсли;
			
			НовоеКонтактноеЛицо = НовыйКонтрагент.ПолучитьЭлементы().Добавить();
			НовоеКонтактноеЛицо.Наименование = ВыборкаПоКонтактнымЛицам.НаименованиеОбъекта;
			НовоеКонтактноеЛицо.Ссылка = ВыборкаПоКонтактнымЛицам.ОбъектПоиска;
			НовоеКонтактноеЛицо.ЭтоКонтактноеЛицо = Истина;
			НовоеКонтактноеЛицо.НомерКартинки = 6;
		
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьРезультатаПоискаКонтрагентов(Видимость);
	
	Если Видимость Тогда	
		Элементы.СтраницыКонтрагентов.ТекущаяСтраница = Элементы.СтраницаДерево;
	Иначе
		Элементы.СтраницыКонтрагентов.ТекущаяСтраница = Элементы.СтраницаСписки;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПоиск()

	ПоискВключен = Ложь;
    УстановитьВидимостьРезультатаПоискаКонтрагентов(ПоискВключен);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьУдаленные()
	
	Если ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокКонтрагенты, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокКонтактныеЛица, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокСпискиРассылки, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокКонтактныеЛица, "НеДействует");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКонтрагенты, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКонтактныеЛица, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокСпискиРассылки, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СписокКонтактныеЛица, "НеДействует", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Истина);
	КонецЕсли;
	
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
КонецПроцедуры
