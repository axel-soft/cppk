﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДокументыПоВопросу.Параметры.УстановитьЗначениеПараметра("ЗначениеОтбора",
		Справочники.ВопросыДеятельности.ПустаяСсылка());
		
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		НастроитьЭлементыФормыДляМобильногоУстройства();
	КонецЕсли;
	
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
	
	Если Элементы.Список.ТекущаяСтрока <> ДокументыПоВопросу.Параметры.Элементы.Найти("ЗначениеОтбора").Значение Тогда
		ДокументыПоВопросу.Параметры.УстановитьЗначениеПараметра("ЗначениеОтбора", Элементы.Список.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаЗапросаОбновления()
	Элементы.Список.Обновить();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДокументыПоВопросуСортироватьПоДатаРегистрацииМК(Команда)
	
	ПереключитьСортировку(ДокументыПоВопросуСортироватьПо, ДокументыПоВопросуНаправлениеСортировки, "РегистрационныйНомерИДата");
	СортироватьСписокПоКолонке("РегистрационныйНомерИДата", ЭтотОбъект);
	
КонецПроцедуры


&НаКлиенте
Процедура ДокументыПоВопросуСортироватьПоДатаСортировкиМК(Команда)
	
	ПереключитьСортировку(ДокументыПоВопросуСортироватьПо, ДокументыПоВопросуНаправлениеСортировки, "ДатаСортировки");
	СортироватьСписокПоКолонке("ДатаСортировки", ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПоВопросуСортироватьПоЗаголовкуМК(Команда)
	
	ПереключитьСортировку(ДокументыПоВопросуСортироватьПо, ДокументыПоВопросуНаправлениеСортировки, "Заголовок");
	СортироватьСписокПоКолонке("Заголовок", ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПереключитьСортировку(ТекущееЗначениеСортироватьПо, НаправлениеСортировки, ИмяКолонки)
	
	Если ТекущееЗначениеСортироватьПо = ИмяКолонки Тогда
		Если НаправлениеСортировки = "Возр" Тогда
			НаправлениеСортировки = "Убыв";
		Иначе
			НаправлениеСортировки = "Возр";
		КонецЕсли;
	Иначе
		ТекущееЗначениеСортироватьПо = ИмяКолонки;
		НаправлениеСортировки = "Возр";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СортироватьСписокПоКолонке(ИмяКолонки, Форма)
	
	Форма.ДокументыПоВопросу.Порядок.Элементы.Очистить();
	Для Каждого ПользовательскаяНастройка Из Форма.ДокументыПоВопросу.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		
		Если ТипЗнч(ПользовательскаяНастройка) <> Тип("ПорядокКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		ПользовательскаяНастройка.Элементы.Очистить();
		
		ЭлементПорядка = ПользовательскаяНастройка.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ЭлементПорядка.Использование = Истина;
		ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных(ИмяКолонки);
		ЭлементПорядка.ТипУпорядочивания = ?(Форма.ДокументыПоВопросуНаправлениеСортировки = "Возр",
			НаправлениеСортировкиКомпоновкиДанных.Возр,
			НаправлениеСортировкиКомпоновкиДанных.Убыв);
		
	КонецЦикла;
	
	УстановитьПометкуРежимуСортировки(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПометкуРежимуСортировки(Форма)
	
	Форма.Элементы.ДокументыПоВопросуСортироватьПоЗаголовкуМК.Пометка = Ложь;
	Форма.Элементы.ДокументыПоВопросуСортироватьПоЗаголовкуМК.Заголовок = НСтр("ru = 'Заголовок'");
	
	Форма.Элементы.ДокументыПоВопросуСортироватьПоДатаРегистрацииМК.Пометка = Ложь;
	Форма.Элементы.ДокументыПоВопросуСортироватьПоДатаРегистрацииМК.Заголовок = НСтр("ru = 'Рег. номер'");
	
	Форма.Элементы.ДокументыПоВопросуСортироватьПоДатаСортировкиМК.Пометка = Ложь;
	Форма.Элементы.ДокументыПоВопросуСортироватьПоДатаСортировкиМК.Заголовок = НСтр("ru = 'Дата регистрации'");
	
	Если Форма.ДокументыПоВопросуСортироватьПо = "Заголовок" Тогда
		Форма.Элементы.ДокументыПоВопросуСортироватьПоЗаголовкуМК.Пометка = Истина;
		Форма.Элементы.ДокументыПоВопросуСортироватьПоЗаголовкуМК.Заголовок = 
			СтрШаблон("%1 (%2)",
				НСтр("ru = 'Заголовок'"),
				Форма.ДокументыПоВопросуНаправлениеСортировки);
	ИначеЕсли Форма.ДокументыПоВопросуСортироватьПо = "РегистрационныйНомерИДата" Тогда
		Форма.Элементы.ДокументыПоВопросуСортироватьПоДатаРегистрацииМК.Пометка = Истина;
		Форма.Элементы.ДокументыПоВопросуСортироватьПоДатаРегистрацииМК.Заголовок = 
			СтрШаблон("%1 (%2)",
				НСтр("ru = 'Рег. номер'"),
				Форма.ДокументыПоВопросуНаправлениеСортировки);
	ИначеЕсли Форма.ДокументыПоВопросуСортироватьПо = "ДатаСортировки" Тогда
		Форма.Элементы.ДокументыПоВопросуСортироватьПоДатаСортировкиМК.Пометка = Истина;
		Форма.Элементы.ДокументыПоВопросуСортироватьПоДатаСортировкиМК.Заголовок = 
			СтрШаблон("%1 (%2)",
				НСтр("ru = 'Дата регистрации'"),
				Форма.ДокументыПоВопросуНаправлениеСортировки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_МобильныйКлиент

&НаСервере
Процедура НастроитьЭлементыФормыДляМобильногоУстройства()
	
	// Настроим Дату.
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию(
		"ИспользоватьДатуИВремяВСрокахЗадач");
		
	// Формат даты.
	ФорматДатыДляКолонок = ?(ИспользоватьДатуИВремяВСрокахЗадач, 
		"ДФ='dd.MM.yy
		|H:ss'",
		"ДФ=dd.MM.yy");
		
	Элементы.ДатаСортировки.Формат = ФорматДатыДляКолонок;
	Элементы.ДатаСортировки.Ширина = 5;
	Элементы.ДатаСортировки.Видимость = Ложь;
	
	// Установим первоначальную сортировка.
	Если ПустаяСтрока(ДокументыПоВопросуСортироватьПо) Тогда
		ДокументыПоВопросуСортироватьПо = "Заголовок";
		ДокументыПоВопросуНаправлениеСортировки = "Убыв";
	КонецЕсли;
		
	ПереключитьСортировку(ДокументыПоВопросуСортироватьПо, ДокументыПоВопросуНаправлениеСортировки, ДокументыПоВопросуСортироватьПо);
	СортироватьСписокПоКолонке(ДокументыПоВопросуСортироватьПо, ЭтотОбъект);
	
	Элементы.ДокументыПоВопросу.Шапка = Ложь;
	Элементы.КомандыСортировкиДокументыПоВопросу.Видимость = Истина;

КонецПроцедуры

#КонецОбласти

