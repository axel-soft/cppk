﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ДействуетС = ТекущаяДатаСеанса();
	ЭлементГруппировки = Справочники.ТематикиДокументов.ПустаяСсылка();
	ДатаСоздания = ТекущаяДатаСеанса();
	Создал = Сотрудники.ОсновнойСотрудникПользователя();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("ЭлементГруппировки") 
			И ЗначениеЗаполнено(ДанныеЗаполнения.ЭлементГруппировки) Тогда
			ЭлементГруппировки = ДанныеЗаполнения.ЭлементГруппировки;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Родитель") 
			И ЗначениеЗаполнено(ДанныеЗаполнения.Родитель) Тогда
			Родитель = ДанныеЗаполнения.Родитель;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Родитель) Тогда
		РеквизитыРодителя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Родитель, 
			"ДействуетС, ДействуетПо, НеДействует");
		Если РеквизитыРодителя.ДействуетС > ДействуетС
			Или (ЗначениеЗаполнено(РеквизитыРодителя.ДействуетПо) И РеквизитыРодителя.ДействуетПо < ДействуетС) Тогда 
			ДействуетС = РеквизитыРодителя.ДействуетС;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РеквизитыРодителя.ДействуетПо) Тогда 
			ДействуетПо = РеквизитыРодителя.ДействуетПо;
		КонецЕсли;
		
		НеДействует = РеквизитыРодителя.НеДействует;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ДействуетС) И ЗначениеЗаполнено(ДействуетПо)
		И ДействуетС >= КонецДня(ДействуетПо) Тогда 
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Дата окончания действия меньше даты начала.'"),
			ЭтотОбъект,
			"ДействуетПо",, 
			Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Родитель) Тогда
		РеквизитыРодителя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Родитель, 
			"ДействуетС, ДействуетПо, НеДействует, ЭлементГруппировки");
		ПериодРодителя = ПредставлениеПериодаДействия(
			РеквизитыРодителя.ДействуетС, РеквизитыРодителя.ДействуетПо);
		
		Если ЗначениеЗаполнено(ДействуетС) 
			И (ДействуетС < РеквизитыРодителя.ДействуетС
			Или (ЗначениеЗаполнено(РеквизитыРодителя.ДействуетПо) И ДействуетС > КонецДня(РеквизитыРодителя.ДействуетПо))) Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Выберите дату в рамках периода действия вышестоящего правила %1'"),
				ПериодРодителя); 
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ДействуетС",, 
				Отказ);
		КонецЕсли;
		
		Если (ЗначениеЗаполнено(РеквизитыРодителя.ДействуетПо) 
				И (ДействуетПо > РеквизитыРодителя.ДействуетПо Или Не ЗначениеЗаполнено(ДействуетПо)))
			Или (ЗначениеЗаполнено(РеквизитыРодителя.ДействуетС) И ЗначениеЗаполнено(ДействуетПо) 
				И КонецДня(ДействуетПо) < РеквизитыРодителя.ДействуетС) Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Выберите дату в рамках периода действия вышестоящего правила %1'"),
				ПериодРодителя); 
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ДействуетПо",, 
				Отказ);
		КонецЕсли;
		
		Если Не НеДействует И РеквизитыРодителя.НеДействует Тогда 
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Вышестоящее правило помечено ""Недействующим"". Измените настройку в его карточке.'"),
				ЭтотОбъект,
				"НеДействует",, 
				Отказ);
		КонецЕсли;
		
		ТипГруппировки = ТипЗнч(ЭлементГруппировки);
		Если ТипЗнч(РеквизитыРодителя.ЭлементГруппировки) = ТипГруппировки Тогда 
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'В вышестоящем правиле указан Элемент совпадающего типа.
					 |Выберите Элемент другого типа.'"),
				ЭтотОбъект,
				"ЭлементГруппировки",, 
				Отказ);
		КонецЕсли;
		
		// Проверим наличие правил с другим типом группировки.
		// Если такие есть, то данный элемент нельзя записать, чтобы не было коллизии определения правил.
		ЭлементДругогоТипа = ЭлементГруппировкиДругогоТипа();
		Если ЗначениеЗаполнено(ЭлементДругогоТипа) Тогда
			ТипДругогоПравила = ТипЗнч(ЭлементДругогоТипа); 
			Если ТипДругогоПравила = Тип("СправочникСсылка.ВидыДокументов") Тогда
				ТекстСообщения = НСтр("ru = 'Для вышестоящего правила уже существует настройка по ""Видам документов"". 
									  |Выберите другой вид документа или укажите другой период действия правила.'");
				
			ИначеЕсли ТипДругогоПравила = Тип("СправочникСсылка.ВидыМероприятий") Тогда
				ТекстСообщения = НСтр("ru = 'Для вышестоящего правила уже существует настройка по ""Видам мероприятий"". 
									  |Выберите другой вид мероприятия или укажите другой период действия правила.'");
				
			ИначеЕсли ТипДругогоПравила = Тип("СправочникСсылка.Организации") Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Для вышестоящего правила уже существует настройка по ""%1"". 
					|Выберите %2 или укажите другой период действия правила.'"),
					РедакцииКонфигурацииКлиентСервер.Организации(),
					РедакцииКонфигурацииКлиентСервер.ДругуюОрганизацию());
					
			ИначеЕсли ТипДругогоПравила = Тип("СправочникСсылка.ТематикиДокументов") Тогда
				ТекстСообщения = НСтр("ru = 'Для вышестоящего правила уже существует настройка по ""Тематикам"". 
					|Выберите другую тематику или укажите другой период действия правила.'");
					
			ИначеЕсли ТипДругогоПравила = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
				ТекстСообщения = НСтр("ru = 'Для вышестоящего правила уже существует настройка по ""Подразделению"". 
					|Выберите другое подразделение или укажите другой период действия правила.'");
					
			ИначеЕсли ТипДругогоПравила = Тип("ПеречислениеСсылка.ВариантыВажностиОбъектов") Тогда
				ТекстСообщения = НСтр("ru = 'Для вышестоящего правила уже существует настройка по ""Вариант важности документа"". 
					|Выберите другой вариант важности документа или укажите другой период действия правила.'");
					
			ИначеЕсли ТипДругогоПравила = Тип("ПеречислениеСсылка.ВариантыФормДокументов") Тогда
				ТекстСообщения = НСтр("ru = 'Для вышестоящего правила уже существует настройка по ""Вариант формы документа"". 
					|Выберите другой вариант формы документа или укажите другой период действия правила.'");
					
			ИначеЕсли ТипДругогоПравила = Тип("СправочникСсылка.ГрифыДоступа") Тогда
				ТекстСообщения = НСтр("ru = 'Для вышестоящего правила уже существует настройка по ""Гриф доступа"". 
					|Выберите другой гриф доступа или укажите другой период действия правила.'");
			
			Иначе
				ТекстСообщения = НСтр("ru = 'Эти настройки уже используются другим правилом. 
					|Выберите другой тип правила или родителя.'");
			КонецЕсли;
			 
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ЭлементГруппировки",, 
				Отказ);
		КонецЕсли;
		
		// Проверим пересечение с другими правилами с совпадающими настройками.
		Если ЕстьПересеченияНастроек() Тогда
			Если ТипГруппировки = Тип("СправочникСсылка.ВидыДокументов") Тогда
				ТекстСообщения = НСтр("ru = 'Для указанного вида документа правило уже существует. 
					|Выберите другой вид документа или укажите другой период действия правила.'");
				
			ИначеЕсли ТипГруппировки = Тип("СправочникСсылка.ВидыМероприятий") Тогда
				ТекстСообщения = НСтр("ru = 'Для указанного вида мероприятия правило уже существует. 
					|Выберите другой вид мероприятия или укажите другой период действия правила.'");
				
			ИначеЕсли ТипГруппировки = Тип("СправочникСсылка.Организации") Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Для %1 правило уже существует. 
					|Выберите %2 или укажите другой период действия правила.'"),
					РедакцииКонфигурацииКлиентСервер.УказаннойОрганизации(),
					РедакцииКонфигурацииКлиентСервер.ДругуюОрганизацию());
					
			ИначеЕсли ТипГруппировки = Тип("СправочникСсылка.ТематикиДокументов") Тогда
				ТекстСообщения = НСтр("ru = 'Для указанной тематики документа правило уже существует. 
					|Выберите другую тематику или укажите другой период действия правила.'");
					
			ИначеЕсли ТипГруппировки = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
				ТекстСообщения = НСтр("ru = 'Для указанного подразделения правило уже существует. 
					|Выберите другое подразделение или укажите другой период действия правила.'");
					
			ИначеЕсли ТипГруппировки = Тип("ПеречислениеСсылка.ВариантыВажностиОбъектов") Тогда
				ТекстСообщения = НСтр("ru = 'Для указанного варианта важности документа правило уже существует. 
					|Выберите другой вариант важности документа или укажите другой период действия правила.'");
					
			ИначеЕсли ТипГруппировки = Тип("ПеречислениеСсылка.ВариантыФормДокументов") Тогда
				ТекстСообщения = НСтр("ru = 'Для указанного варианта формы документа правило уже существует. 
					|Выберите другой вариант формы документа или укажите другой период действия правила.'");
					
			ИначеЕсли ТипГруппировки = Тип("СправочникСсылка.ГрифыДоступа") Тогда
				ТекстСообщения = НСтр("ru = 'Для указанного грифа доступа правило уже существует. 
					|Выберите другой гриф доступа или укажите другой период действия правила.'");
				
			Иначе
				ТекстСообщения = НСтр("ru = 'Эти настройки уже используются другим правилом. 
					|Выберите другой период действия, элемент или родитель.'");
			КонецЕсли;
			 
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ЭлементГруппировки",, 
				Отказ);
		КонецЕсли;
	
	// Корневой элемент должен быть только по "Виду документа" или "Виду мероприятия"
	ИначеЕсли ТипЗнч(ЭлементГруппировки) <> Тип("СправочникСсылка.ВидыДокументов")
		И ТипЗнч(ЭлементГруппировки) <> Тип("СправочникСсылка.ВидыМероприятий") Тогда 
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Укажите ""Вид объекта"", к которому относится правило обработки.'"),
			ЭтотОбъект,
			"ЭлементГруппировки",, 
			Отказ);	
	
	// Проверка пересечения актуальности нескольких правил.
	ИначеЕсли Не НеДействует Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИСТИНА
		|ИЗ
		|	Справочник.ПравилаОбработки КАК ПравилаОбработки
		|ГДЕ
		|	ПравилаОбработки.ЭлементГруппировки = &ЭлементГруппировки
		|	И НЕ ПравилаОбработки.ПометкаУдаления
		|	И ПравилаОбработки.НеДействует = ЛОЖЬ
		|	И ПравилаОбработки.Ссылка <> &Ссылка
		|	И ПравилаОбработки.ДействуетС <= &ДействуетПо
		|	И ВЫБОР
		|		КОГДА ПравилаОбработки.ДействуетПо = ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДАТАВРЕМЯ(3999, 12, 31)
		|		ИНАЧЕ ПравилаОбработки.ДействуетПо
		|	КОНЕЦ >= &ДействуетС");
		Запрос.УстановитьПараметр("ЭлементГруппировки", ЭлементГруппировки);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("ДействуетС", ДействуетС);
		Запрос.УстановитьПараметр("ДействуетПо", ?(ДействуетПо = '00010101', '39991231', ДействуетПо));
		
		Если Не Запрос.Выполнить().Пустой() Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Для этого вида документа уже существует актуальное правило.
				|Выберите другой вид документа или период действия правила.'"),
				ЭтотОбъект,
				"ЭлементГруппировки",, 
				Отказ);
		КонецЕсли;
				
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ДополнительныеСвойства.Вставить("ЭтоНовый", Ложь);
		ПредыдущиеЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
			"ДействуетС, ДействуетПо, НеДействует, ПометкаУдаления");
	Иначе
		ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
		ПредыдущиеЗначенияРеквизитов = Новый Структура;
	КонецЕсли;
	
	Наименование = СокрЛП(ЭлементГруппировки);
	
	ДополнительныеСвойства.Вставить("ПредыдущиеЗначенияРеквизитов", ПредыдущиеЗначенияРеквизитов);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.ЭтоНовый
		И ДополнительныеСвойства.Свойство("ПредыдущиеЗначенияРеквизитов") 
		И НеДействует <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.НеДействует
		И НеДействует Тогда 
		ОбновитьДанныеЗависимыхГрупп(Ссылка, "НеДействует", "<>", НеДействует);
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.ЭтоНовый
		И ДополнительныеСвойства.Свойство("ПредыдущиеЗначенияРеквизитов") 
		И ПометкаУдаления <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ПометкаУдаления
		И ПометкаУдаления Тогда 
		ОбновитьДанныеЗависимыхГрупп(Ссылка, "ПометкаУдаления", "<>", ПометкаУдаления);
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.ЭтоНовый
		И ДополнительныеСвойства.Свойство("ПредыдущиеЗначенияРеквизитов") 
		И ДействуетС <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ДействуетС Тогда 
		ОбновитьДанныеЗависимыхГрупп(Ссылка, "ДействуетС", "<", ДействуетС);
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.ЭтоНовый
		И ДополнительныеСвойства.Свойство("ПредыдущиеЗначенияРеквизитов") 
		И ДействуетПо <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ДействуетПо Тогда 
		ОбновитьДанныеЗависимыхГрупп(Ссылка, "ДействуетПо", ">", ДействуетПо);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьДанныеЗависимыхГрупп(Ссылка, ИмяРеквизита, Операция, ЗначениеРеквизита)
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПравилаОбработки.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПравилаОбработки КАК ПравилаОбработки
		|ГДЕ
		|	ПравилаОбработки.Ссылка В ИЕРАРХИИ(&ТекущаяГруппа)
		|	И ПравилаОбработки.Ссылка <> &ТекущаяГруппа
		|	И (ПравилаОбработки." + ИмяРеквизита + Операция + "&ЗначениеРеквизита %1)";
		
	Если ИмяРеквизита = "ДействуетС" Или ИмяРеквизита = "ДействуетПо" Тогда
		Если ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
			Запрос.Текст = СтрШаблон(Запрос.Текст, "
				|ИЛИ ПравилаОбработки." + ИмяРеквизита + " = ДатаВремя(1, 1, 1)");
		Иначе
			Запрос.Текст = СтрШаблон(Запрос.Текст, "
				|ИЛИ ПравилаОбработки." + ИмяРеквизита + " <> ДатаВремя(1, 1, 1)");
		КонецЕсли;
	Иначе
		Запрос.Текст = СтрШаблон(Запрос.Текст, "");
	КонецЕсли;
	
	Запрос.Параметры.Вставить("ТекущаяГруппа", Ссылка);
	Запрос.Параметры.Вставить("ЗначениеРеквизита", ЗначениеРеквизита);
	ГруппыДляОбновления = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Группа Из ГруппыДляОбновления Цикл
		ГруппаОбъект = Группа.Ссылка.ПолучитьОбъект();
		ГруппаОбъект[ИмяРеквизита] = ЗначениеРеквизита;
		ГруппаОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Выполняет проверку на наличие других правилам от Родителя, с другим типом элемента группировки
//
Функция ЭлементГруппировкиДругогоТипа()

	УстановитьПривилегированныйРежим(Истина);
	НайденныйЭлементГруппировки = Неопределено;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПравилаОбработки.ЭлементГруппировки КАК ЭлементГруппировки
		|ИЗ
		|	Справочник.ПравилаОбработки КАК ПравилаОбработки
		|ГДЕ
		|	ПравилаОбработки.Родитель = &Родитель
		|	И ПравилаОбработки.Ссылка <> &Ссылка
		|	И ТИПЗНАЧЕНИЯ(ПравилаОбработки.ЭлементГруппировки) <> ТИПЗНАЧЕНИЯ(&ЭлементГруппировки)
		|	И Не ПравилаОбработки.ПометкаУдаления
		|	И (&ДействуетПО <> ДАТАВРЕМЯ(1, 1, 1)
		|	И ПравилаОбработки.ДействуетС <= &ДействуетПО
		|	ИЛИ &ДействуетПО = ДАТАВРЕМЯ(1, 1, 1))
		|	И (ПравилаОбработки.ДействуетПо <> ДАТАВРЕМЯ(1, 1, 1)
		|	И ПравилаОбработки.ДействуетПо >= &ДействуетС
		|	ИЛИ ПравилаОбработки.ДействуетПо = ДАТАВРЕМЯ(1, 1, 1))";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Запрос.Параметры.Вставить("Родитель", Родитель);
	Запрос.Параметры.Вставить("ЭлементГруппировки", ЭлементГруппировки);
	Запрос.Параметры.Вставить("ДействуетС", ДействуетС);
	Запрос.Параметры.Вставить("ДействуетПО", ДействуетПО);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НайденныйЭлементГруппировки = Выборка.ЭлементГруппировки;
	КонецЦикла;
		
	Возврат НайденныйЭлементГруппировки;
		
КонецФункции

// Выполняет проверку на наличие других правилам с совпадающими настройками
//
Функция ЕстьПересеченияНастроек()
	
	УстановитьПривилегированныйРежим(Истина);
	ЕстьПересечения = Ложь; 
	ВсеРодителиИЭлемент = Новый Массив();
	Если Не Ссылка.Пустая() Тогда
		ВсеРодителиИЭлемент.Добавить(Ссылка);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВсеРодителиИЭлемент,
			ОбщегоНазначенияДокументооборот.ВсеРодителиЭлемента(Ссылка), Истина);
		ВсеЭлементыГруппировки = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(
			ВсеРодителиИЭлемент, "ЭлементГруппировки");
	Иначе
		ВсеРодителиИЭлемент.Добавить(Родитель);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВсеРодителиИЭлемент,
			ОбщегоНазначенияДокументооборот.ВсеРодителиЭлемента(Родитель), Истина);
		
		ВсеЭлементыГруппировки = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(
			ВсеРодителиИЭлемент, "ЭлементГруппировки");
		ВсеЭлементыГруппировки.Вставить(Ссылка, ЭлементГруппировки);
	КонецЕсли;
	
	КоличествоРодителей = ВсеРодителиИЭлемент.Количество();
	Если КоличествоРодителей = 0 Тогда
		Возврат ЕстьПересечения;
	КонецЕсли;
	КорневоеПравило = ВсеРодителиИЭлемент[КоличествоРодителей - 1];
	
	КлючНастройки = Новый Структура;
	КлючНастройки.Вставить("ВидОбъекта", Неопределено);
	КлючНастройки.Вставить("ДатаОбработки", ДействуетС);
	КлючНастройки.Вставить("Тематика", Справочники.ТематикиДокументов.ПустаяСсылка());
	КлючНастройки.Вставить("Подразделение", Справочники.СтруктураПредприятия.ПустаяСсылка());
	КлючНастройки.Вставить("Организация", Справочники.Организации.ПустаяСсылка());
	КлючНастройки.Вставить("ГрифДоступа", Справочники.ГрифыДоступа.ПустаяСсылка());
	КлючНастройки.Вставить("Важность", Перечисления.ВариантыВажностиОбъектов.ПустаяСсылка());
	КлючНастройки.Вставить("ФормаДокумента", Перечисления.ВариантыФормДокументов.ПустаяСсылка());
	
	Для Каждого СтрЭлемент Из ВсеЭлементыГруппировки Цикл
		Если ТипЗнч(СтрЭлемент.Значение) = Тип("СправочникСсылка.ВидыДокументов")
			Или ТипЗнч(СтрЭлемент.Значение) = Тип("СправочникСсылка.ВидыМероприятий") Тогда
			КлючНастройки.Вставить("ВидОбъекта", СтрЭлемент.Значение);
		ИначеЕсли ТипЗнч(СтрЭлемент.Значение) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
			КлючНастройки.Вставить("Подразделение", СтрЭлемент.Значение);
		ИначеЕсли ТипЗнч(СтрЭлемент.Значение) = Тип("СправочникСсылка.Организации") Тогда
			КлючНастройки.Вставить("Организация", СтрЭлемент.Значение);
		ИначеЕсли ТипЗнч(СтрЭлемент.Значение) = Тип("СправочникСсылка.ТематикиДокументов") Тогда
			КлючНастройки.Вставить("Тематика", СтрЭлемент.Значение);
		ИначеЕсли ТипЗнч(СтрЭлемент.Значение) = Тип("СправочникСсылка.ГрифыДоступа") Тогда
			КлючНастройки.Вставить("ГрифДоступа", СтрЭлемент.Значение);
		ИначеЕсли ТипЗнч(СтрЭлемент.Значение) = Тип("ПеречислениеСсылка.ВариантыВажностиОбъектов") Тогда
			КлючНастройки.Вставить("Важность", СтрЭлемент.Значение);
		ИначеЕсли ТипЗнч(СтрЭлемент.Значение) = Тип("ПеречислениеСсылка.ВариантыФормДокументов") Тогда
			КлючНастройки.Вставить("ФормаДокумента", СтрЭлемент.Значение);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаПравил = РегистрыСведений.ПравилаОбработкиОбъектов.НоваяТаблицаПравил();
	УровеньВложенности = 1;
	РегистрыСведений.ПравилаОбработкиОбъектов.ЗаполнитьПодходящиеПравилаРекурсивно(
		КлючНастройки, УровеньВложенности, ТаблицаПравил, КорневоеПравило, Истина);
		
	Для Каждого Стр Из ТаблицаПравил Цикл
		Если ВсеРодителиИЭлемент.Найти(Стр.ПравилоОбработки) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЕстьПересечения = Истина;
		Прервать;
	КонецЦикла;
	
	Возврат ЕстьПересечения;
		
КонецФункции

Функция ПредставлениеПериодаДействия(ДействуетС, ДействуетПо)
	
	ИтоговоеПредставление = "";
	Если ЗначениеЗаполнено(ДействуетС) И ЗначениеЗаполнено(ДействуетПо) Тогда 
		ИтоговоеПредставление = СтрШаблон(НСтр("ru = '(с %1 по %2)'"),
			Формат(ДействуетС, "ДЛФ=D"), Формат(ДействуетПо, "ДЛФ=D"));
	ИначеЕсли ЗначениеЗаполнено(ДействуетС) Тогда 
		ИтоговоеПредставление = СтрШаблон(НСтр("ru = '(с %1)'"), Формат(ДействуетС, "ДЛФ=D"));
	ИначеЕсли ЗначениеЗаполнено(ДействуетПо) Тогда 
		ИтоговоеПредставление = СтрШаблон(НСтр("ru = '(действует по %1)'"), Формат(ДействуетПо, "ДЛФ=D"));
	КонецЕсли;
	
	Возврат ИтоговоеПредставление;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли