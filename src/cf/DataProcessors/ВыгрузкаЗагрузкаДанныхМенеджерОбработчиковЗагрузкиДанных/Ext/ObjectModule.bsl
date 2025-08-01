﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущиеОбработчики;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПередОчисткойДанных(Контейнер) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередОчисткойДанных", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПередОчисткойДанных(Контейнер);
	КонецЦикла;
	
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПриДобавленииСлужебныхСобытий
//
Процедура ПередЗагрузкойДанных(Контейнер) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередЗагрузкойДанных", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПередЗагрузкойДанных(Контейнер);
	КонецЦикла;
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПередЗагрузкойДанных(Контейнер);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПередЗагрузкойДанных(Контейнер);
	
КонецПроцедуры

// Выполняет ряд действий при загрузке пользователя информационной базы.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//
Процедура ПослеЗагрузкиДанных(Контейнер) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПослеЗагрузкиДанных", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПослеЗагрузкиДанных(Контейнер);
	КонецЦикла;
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПослеЗагрузкиДанных(Контейнер);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПослеЗагрузкиДанных(Контейнер);
	
КонецПроцедуры

Процедура ПередСопоставлениемСсылок(Контейнер, ОбъектМетаданных, ТаблицаИсходныхСсылок, СтандартнаяОбработка, НестандартныйОбработчик, Отказ) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередСопоставлениемСсылок", Истина);
	ОтборОбработчиков.Вставить("ОбъектМетаданных", ОбъектМетаданных);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		
		ОписаниеОбработчика.Обработчик.ПередСопоставлениемСсылок(Контейнер, ОбъектМетаданных, ТаблицаИсходныхСсылок, СтандартнаяОбработка, Отказ);
		
		Если Не СтандартнаяОбработка ИЛИ Отказ Тогда
			НестандартныйОбработчик = ОписаниеОбработчика.Обработчик;
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Выполняемые действия при замене ссылок.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер контейнера, используемый в процессе 
//	 выгрузки данных. Подробнее см. комментарий к программному интерфейсу обработки.
//	СоответствиеСсылок - Соответствие - см. описание ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаменыСсылок
//
Процедура ПриЗаменеСсылок(Контейнер, СоответствиеСсылок) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПриЗаменеСсылок", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПриЗаменеСсылок(Контейнер, СоответствиеСсылок);
	КонецЦикла;
	
КонецПроцедуры

// Выполняет обработчики перед загрузкой определенного типа данных.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	ОбъектМетаданных - ОбъектМетаданных - объект метаданных.
//	Отказ - Булево - признак выполнения данной операции.
//
Процедура ПередЗагрузкойТипа(Контейнер, ОбъектМетаданных, Отказ) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередЗагрузкойТипа", Истина);
	ОтборОбработчиков.Вставить("ОбъектМетаданных", ОбъектМетаданных);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПередЗагрузкойТипа(Контейнер, ОбъектМетаданных, Отказ);
	КонецЦикла;
	
КонецПроцедуры

// Вызывается перед выгрузкой объекта.
// см. "ПриРегистрацииОбработчиковВыгрузкиДанных".
//
Процедура ПередЗагрузкойОбъекта(Контейнер, Объект, Артефакты, Отказ) Экспорт
	
	Если ТипЗнч(Объект) = Тип("УдалениеОбъекта") Тогда
		Возврат;
	КонецЕсли;
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередЗагрузкойОбъекта", Истина);
	ОтборОбработчиков.Вставить("ОбъектМетаданных", Объект.Метаданные());
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПередЗагрузкойОбъекта(Контейнер, Объект, Артефакты, Отказ);
	КонецЦикла;
	
КонецПроцедуры

// Выполняет обработчики после загрузки объекта.
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//	Объект - Произвольный - объект загружаемых данных.
//	Артефакты - Массив из ОбъектXDTO - массив артефактов (объектов XDTO).
//
Процедура ПослеЗагрузкиОбъекта(Контейнер, Объект, Артефакты) Экспорт
	
	Если ТипЗнч(Объект) = Тип("УдалениеОбъекта") Тогда
		Возврат;
	КонецЕсли;
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПослеЗагрузкиОбъекта", Истина);
	ОтборОбработчиков.Вставить("ОбъектМетаданных", Объект.Метаданные());
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПослеЗагрузкиОбъекта(Контейнер, Объект, Артефакты);
	КонецЦикла;
	
КонецПроцедуры

// См. описание к процедуре ПриДобавленииСлужебныхСобытий() общего модуля ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.
//
Процедура ПослеЗагрузкиТипа(Контейнер, ОбъектМетаданных) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПослеЗагрузкиТипа", Истина);
	ОтборОбработчиков.Вставить("ОбъектМетаданных", ОбъектМетаданных);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПослеЗагрузкиТипа(Контейнер, ОбъектМетаданных);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗагрузкойХранилищаНастроек(Контейнер, ИмяХранилищаНастроек, ХранилищеНастроек, Отказ) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередЗагрузкойХранилищаНастроек", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПередЗагрузкойХранилищаНастроек(Контейнер, ИмяХранилищаНастроек, ХранилищеНастроек, Отказ);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗагрузкойНастроек(Контейнер, ИмяХранилищаНастроек, КлючНастроек, КлючОбъекта, Настройки, Пользователь, Представление, Артефакты, Отказ) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПередЗагрузкойНастроек", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПередЗагрузкойНастроек(
			Контейнер,
			ИмяХранилищаНастроек,
			КлючНастроек,
			КлючОбъекта,
			Настройки,
			Пользователь,
			Представление,
			Артефакты,
			Отказ);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеЗагрузкиНастроек(Контейнер, ИмяХранилищаНастроек, КлючНастроек, КлючОбъекта, Настройки, Пользователь, Представление, Артефакты) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПослеЗагрузкиНастроек", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПослеЗагрузкиНастроек(
			Контейнер,
			ИмяХранилищаНастроек,
			КлючНастроек,
			КлючОбъекта,
			Настройки,
			Пользователь,
			Представление,
			Артефакты);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеЗагрузкиХранилищаНастроек(Контейнер, ИмяХранилищаНастроек, ХранилищеНастроек) Экспорт
	
	// ЗарегистрированныеОбработчики
	ОтборОбработчиков = Новый Структура();
	ОтборОбработчиков.Вставить("ПослеЗагрузкиХранилищаНастроек", Истина);
	ОписанияОбработчиков = ТекущиеОбработчики.НайтиСтроки(ОтборОбработчиков);
	Для Каждого ОписаниеОбработчика Из ОписанияОбработчиков Цикл
		ОписаниеОбработчика.Обработчик.ПослеЗагрузкиХранилищаНастроек(Контейнер, ИмяХранилищаНастроек, ХранилищеНастроек);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ТекущиеОбработчики = Новый ТаблицаЗначений();

ТекущиеОбработчики.Колонки.Добавить("ОбъектМетаданных");
ТекущиеОбработчики.Колонки.Добавить("Обработчик");
ТекущиеОбработчики.Колонки.Добавить("Версия", Новый ОписаниеТипов("Строка"));

ТекущиеОбработчики.Колонки.Добавить("ПередОчисткойДанных", Новый ОписаниеТипов("Булево"));

ТекущиеОбработчики.Колонки.Добавить("ПередЗагрузкойДанных", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПослеЗагрузкиДанных", Новый ОписаниеТипов("Булево"));

ТекущиеОбработчики.Колонки.Добавить("ПередСопоставлениемСсылок", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПриЗаменеСсылок", Новый ОписаниеТипов("Булево"));

ТекущиеОбработчики.Колонки.Добавить("ПередЗагрузкойТипа", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПередЗагрузкойОбъекта", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПослеЗагрузкиОбъекта", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПослеЗагрузкиТипа", Новый ОписаниеТипов("Булево"));

ТекущиеОбработчики.Колонки.Добавить("ПередЗагрузкойХранилищаНастроек", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПередЗагрузкойНастроек", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПослеЗагрузкиНастроек", Новый ОписаниеТипов("Булево"));
ТекущиеОбработчики.Колонки.Добавить("ПослеЗагрузкиХранилищаНастроек", Новый ОписаниеТипов("Булево"));


// Интегрированные обработчики
ВыгрузкаЗагрузкаДанныхХранилищЗначений.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаДанныхГраницПоследовательностей.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаПредопределенныхДанных.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаНеразделенныхПредопределенныхДанных.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаСовместноРазделенныхДанных.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаДанныхУправлениеИтогами.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаИзбранногоРаботыПользователей.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);
ВыгрузкаЗагрузкаУзловПлановОбменов.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);

// Обработчики событий библиотек
ИнтеграцияПодсистемБТС.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);

// Переопределяемая процедура
ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковЗагрузкиДанных(ТекущиеОбработчики);

// Обеспечение обратной совместимости
Для Каждого Строка Из ТекущиеОбработчики Цикл
	Если ПустаяСтрока(Строка.Версия) Тогда
		Строка.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_0();
	КонецЕсли;
КонецЦикла;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли