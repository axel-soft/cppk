﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет заполнение подисок по умолчанию.
//
Процедура ЗаполнитьПодпискиПоУмолчанию() Экспорт
	
	Пользователь = Справочники.Пользователи.ПустаяСсылка();
	Настройка = Перечисления.НастройкиУведомлений.Подписка;
	ВидыСобытий = Новый Массив;
	Выборка = Справочники.ВидыБизнесСобытий.Выбрать();
	Пока Выборка.Следующий() Цикл
		ВидыСобытий.Добавить(Выборка.Ссылка);
	КонецЦикла;
	Для Каждого ВидСобытия Из Перечисления.СобытияУведомлений Цикл
		ВидыСобытий.Добавить(ВидСобытия);
	КонецЦикла;
	Объект = Неопределено;
	
	Для Каждого ВидСобытия Из ВидыСобытий Цикл
		
		Для Каждого СпособУведомления Из Перечисления.СпособыУведомления Цикл
			
			ПодпискаПоУмолчанию = Перечисления.НастройкиУведомлений.СтандартноеЗначениеНастройки(
				Настройка,
				ВидСобытия,
				СпособУведомления);
			Если Не ПодпискаПоУмолчанию Тогда
				Продолжить;
			КонецЕсли;
			
			ТекущееЗначениеНастройки = ПолучитьНастройку(
				Пользователь,
				Настройка,
				ВидСобытия,
				СпособУведомления,
				Объект);
			Если ТекущееЗначениеНастройки <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			УстановитьНастройку(
				Пользователь,
				Настройка,
				ВидСобытия,
				СпособУведомления,
				Объект,
				Истина);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Формирует таблицу доступных дополнительных настроек.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Доступные дополнительные настройки.
//
Функция ДоступныеДополнительныеНастройки() Экспорт
	
	ДоступныеДополнительныеНастройки = Новый ТаблицаЗначений;
	ДоступныеДополнительныеНастройки.Колонки.Добавить("ВидСобытия",
		Новый ОписаниеТипов("СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений"));
	ДоступныеДополнительныеНастройки.Колонки.Добавить("Настройка",
		Новый ОписаниеТипов("ПеречислениеСсылка.НастройкиУведомлений"));
	ДоступныеДополнительныеНастройки.Колонки.Добавить("Представление",
		Новый ОписаниеТипов("Строка"));
	
	ДоступныеНастройки = РаботаСУведомлениями.ДоступныеУведомления();
	Для Каждого ДоступнаяНастройка Из ДоступныеНастройки Цикл
		Для Каждого ДополнительнаяНастройка Из ДоступнаяНастройка.ДополнительныеНастройки Цикл
			НоваяСтрока = ДоступныеДополнительныеНастройки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ДоступнаяНастройка, "ВидСобытия");
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ДополнительнаяНастройка);
		КонецЦикла;
	КонецЦикла;
	
	ДоступныеДополнительныеНастройки.Сортировать("Представление");
	
	Возврат ДоступныеДополнительныеНастройки;
	
КонецФункции

// Формирует таблицу доступных подписок на уведомления.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Доступные подписки.
//
Функция ДоступныеПодписки() Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.Подписка;
	
	Возврат ДоступныеНастройки(Настройка);
	
КонецФункции

// Формирует таблицу доступных сроков уведомлений.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Доступные сроки.
//
Функция ДоступныеСроки() Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.СрокУведомления;
	
	Возврат ДоступныеНастройки(Настройка);
	
КонецФункции

// Формирует таблицу доступных частот уведомлений.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Доступные частоты.
//
Функция ДоступныеЧастоты() Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.ЧастотаУведомления;
	
	Возврат ДоступныеНастройки(Настройка);
	
КонецФункции

// Формирует данные отказов от подписки.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
// 
// Возвращаемое значение:
//  Массив - Объекты с отказом от подписки.
//
Функция ОтказыОтПодписки(Пользователь, ВидСобытия, СпособУведомления) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиУведомлений.Объект КАК Объект
		|ИЗ
		|	РегистрСведений.НастройкиУведомлений КАК НастройкиУведомлений
		|ГДЕ
		|	НастройкиУведомлений.Пользователь = &Пользователь
		|	И НастройкиУведомлений.Настройка = ЗНАЧЕНИЕ(Перечисление.НастройкиУведомлений.Подписка)
		|	И НастройкиУведомлений.ВидСобытия = &ВидСобытия
		|	И НастройкиУведомлений.СпособУведомления = &СпособУведомления
		|	И НастройкиУведомлений.Значение = ЛОЖЬ";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("ВидСобытия", ВидСобытия);
	Запрос.УстановитьПараметр("СпособУведомления", СпособУведомления);
	
	ОтказыОтПодписки = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Объект");
	
	Возврат ОтказыОтПодписки;
	
КонецФункции

// Возвращает массив подписчиков по объекту.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Объект - ЛюбаяСсылка - Объект.
// 
// Возвращаемое значение:
//  Массив - Подписчики по объекту.
//
Функция ПодписчикиПоОбъекту(ВидСобытия, Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиУведомлений.Пользователь КАК Пользователь,
		|	НастройкиУведомлений.СпособУведомления КАК СпособУведомления
		|ИЗ
		|	РегистрСведений.НастройкиУведомлений КАК НастройкиУведомлений
		|ГДЕ
		|	НастройкиУведомлений.Объект = &Объект
		|	И НастройкиУведомлений.Настройка = ЗНАЧЕНИЕ(Перечисление.НастройкиУведомлений.Подписка)
		|	И НастройкиУведомлений.ВидСобытия = &ВидСобытия
		|	И НастройкиУведомлений.Значение = ИСТИНА";
	Запрос.УстановитьПараметр("ВидСобытия", ВидСобытия);
	Запрос.УстановитьПараметр("Объект", Объект);
	
	ПодписчикиПоОбъекту = Запрос.Выполнить().Выгрузить();
	
	Возврат ПодписчикиПоОбъекту;
	
КонецФункции

// Возвращает массив подписчиков по событию.
//
// Параметры:
//  ВозможныеПодписчики - Массив - Возможные подписчики.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Объект - ЛюбаяСсылка - Объект.
// 
// Возвращаемое значение:
//  Массив - Подписчики по событию.
//
Функция ПодписчикиПоСобытию(ВозможныеПодписчики, ВидСобытия, Объект) Экспорт
	
	Подписчики = Новый Массив;
	Для Каждого СпособУведомления Из Перечисления.СпособыУведомления Цикл
		Для Каждого Пользователь Из ВозможныеПодписчики Цикл
			Если ЗначениеЗаполнено(Объект) Тогда
				ПодпискаПоОбъекту = ПолучитьПодпискуПоОбъекту(Пользователь, ВидСобытия, СпособУведомления, Объект);
				Если ПодпискаПоОбъекту = Ложь Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			ПодпискаНаСобытие = ПолучитьПодписку(Пользователь, ВидСобытия, СпособУведомления);
			Если ПодпискаНаСобытие = Ложь Тогда
				Продолжить;
			КонецЕсли;
			Подписчик = Новый Структура("Пользователь, СпособУведомления");
			Подписчик.Пользователь = Пользователь;
			Подписчик.СпособУведомления = СпособУведомления;
			Подписчики.Добавить(Подписчик);
		КонецЦикла;
	КонецЦикла;
	
	Возврат Подписчики;
	
КонецФункции

// Возвращает дополнительную настройку.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  Настройка - ПеречислениеСсылка.НастройкиУведомлений - Настройка.
//
// Возвращаемое значение:
//  Булево, Число, Строка - Значение настройки.
//
Функция ПолучитьДополнительнуюНастройку(Пользователь, Настройка) Экспорт
	
	ВидСобытия = Перечисления.НастройкиУведомлений.ВидСобытия(Настройка);
	СпособУведомления = Перечисления.СпособыУведомления.ПустаяСсылка();
	
	Возврат ПолучитьНастройкуПользователя(Пользователь, Настройка, ВидСобытия, СпособУведомления);
	
КонецФункции

// Возвращает дополнительную настройку по умолчанию.
//
// Параметры:
//  Настройка - ПеречислениеСсылка.НастройкиУведомлений - Настройка.
//
// Возвращаемое значение:
//  Булево, Число, Строка - Значение настройки.
//
Функция ПолучитьДополнительнуюНастройкуПоУмолчанию(Настройка) Экспорт
	
	ВидСобытия = Перечисления.НастройкиУведомлений.ВидСобытия(Настройка);
	СпособУведомления = Перечисления.СпособыУведомления.ПустаяСсылка();
	
	Возврат ПолучитьНастройкуПоУмолчанию(Настройка, ВидСобытия, СпособУведомления);
	
КонецФункции

// Возвращает подписки пользователя по объектам.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//
// Возвращаемое значение:
//  ДеревоЗначений - Подписки по объектам.
//
Функция ПолучитьПодпискиПоОбъектам(Пользователь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиУведомлений.ВидСобытия КАК ВидСобытия,
		|	НастройкиУведомлений.СпособУведомления КАК СпособУведомления,
		|	НастройкиУведомлений.Объект КАК Объект,
		|	НастройкиУведомлений.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.НастройкиУведомлений КАК НастройкиУведомлений
		|ГДЕ
		|	НастройкиУведомлений.Пользователь = &Пользователь
		|	И НастройкиУведомлений.Настройка = ЗНАЧЕНИЕ(Перечисление.НастройкиУведомлений.Подписка)
		|	И НастройкиУведомлений.Объект <> НЕОПРЕДЕЛЕНО
		|
		|УПОРЯДОЧИТЬ ПО
		|	Объект,
		|	ВидСобытия,
		|	СпособУведомления
		|ИТОГИ ПО
		|	Объект,
		|	ВидСобытия";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	ДанныеПодписокПоОбъектам = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Возврат ДанныеПодписокПоОбъектам;
	
КонецФункции

// Возвращает подписку на уведомления.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//
// Возвращаемое значение:
//  Булево - Значение подписки.
//
Функция ПолучитьПодписку(Пользователь, ВидСобытия, СпособУведомления) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.Подписка;
	
	Возврат ПолучитьНастройкуПользователя(Пользователь, Настройка, ВидСобытия, СпособУведомления);
	
КонецФункции

// Возвращает подписку на уведомления по объекту.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//  Объект - ЛюбаяСсылка - Объект.
//
// Возвращаемое значение:
//  Булево - Значение подписки.
//
Функция ПолучитьПодпискуПоОбъекту(Пользователь, ВидСобытия, СпособУведомления, Объект) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.Подписка;
	
	Возврат ПолучитьНастройку(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект);
	
КонецФункции

// Возвращает подписку на уведомления по умолчанию.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//
// Возвращаемое значение:
//  Булево - Значение подписки.
//
Функция ПолучитьПодпискуПоУмолчанию(Знач ВидСобытия, Знач СпособУведомления = Неопределено) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.Подписка;
	
	Если ЗначениеЗаполнено(СпособУведомления) Тогда
		ЗначениеНастройки = ПолучитьНастройкуПоУмолчанию(Настройка, ВидСобытия, СпособУведомления);
	Иначе
		ЗначениеНастройки = Ложь;
		Для Каждого СпособУведомления Из Перечисления.СпособыУведомления Цикл
			ЗначениеНастройки = ЗначениеНастройки
				Или ПолучитьНастройкуПоУмолчанию(Настройка, ВидСобытия, СпособУведомления);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ЗначениеНастройки;
	
КонецФункции

// Возвращает подписку на уведомления по умолчанию с учетом дополнительных видов событий.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//
// Возвращаемое значение:
//  Булево - Значение подписки.
//
Функция ПолучитьПодпискуПоУмолчаниюДополненную(Знач ВидСобытия, Знач СпособУведомления = Неопределено) Экспорт
	
	ЗначениеНастройки = ПолучитьПодпискуПоУмолчанию(ВидСобытия, СпособУведомления);
	Для Каждого ВидСобытия Из РаботаСУведомлениями.ДополнительныеВидыСобытий(ВидСобытия) Цикл
		ЗначениеНастройки = ЗначениеНастройки Или ПолучитьПодпискуПоУмолчанию(ВидСобытия, СпособУведомления);
	КонецЦикла;
	
	Возврат ЗначениеНастройки;
	
КонецФункции

// Возвращает срок уведомлений.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//
// Возвращаемое значение:
//  Число - Значение срока.
//
Функция ПолучитьСрок(Пользователь, ВидСобытия) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.СрокУведомления;
	СпособУведомления = Перечисления.СпособыУведомления.ПустаяСсылка();
	
	Возврат ПолучитьНастройкуПользователя(Пользователь, Настройка, ВидСобытия, СпособУведомления);
	
КонецФункции

// Возвращает срок уведомлений по умолчанию.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//
// Возвращаемое значение:
//  Число - Значение срока.
//
Функция ПолучитьСрокПоУмолчанию(ВидСобытия) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.СрокУведомления;
	СпособУведомления = Перечисления.СпособыУведомления.ПустаяСсылка();
	
	Возврат ПолучитьНастройкуПоУмолчанию(Настройка, ВидСобытия, СпособУведомления);
	
КонецФункции

// Возвращает частоту уведомлений.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//
// Возвращаемое значение:
//  Число - Значение частоты.
//
Функция ПолучитьЧастоту(Пользователь, ВидСобытия) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.ЧастотаУведомления;
	СпособУведомления = Перечисления.СпособыУведомления.ПустаяСсылка();
	
	Возврат ПолучитьНастройкуПользователя(Пользователь, Настройка, ВидСобытия, СпособУведомления);
	
КонецФункции

// Возвращает частоту уведомлений по умолчанию.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//
// Возвращаемое значение:
//  Число - Значение частоты.
//
Функция ПолучитьЧастотуПоУмолчанию(ВидСобытия) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.ЧастотаУведомления;
	СпособУведомления = Перечисления.СпособыУведомления.ПустаяСсылка();
	
	Возврат ПолучитьНастройкуПоУмолчанию(Настройка, ВидСобытия, СпособУведомления);
	
КонецФункции

// Возвращает разрешение изменять настройки уведомлений пользователям.
//
// Возвращаемое значение:
//  Булево - Разрешено изменять настройки уведомлений.
//
Функция РазрешеноИзменятьНастройки() Экспорт
	
	РазрешеноИзменятьНастройки = РаботаСУведомлениямиПовтИсп.РазрешитьИзменятьНастройкиУведомлений();
	
	Возврат РазрешеноИзменятьНастройки;
	
КонецФункции

// Удаляет все настройки пользователей.
//
Процедура УдалитьВсеНастройкиПользователей() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	НастройкиУведомлений.Пользователь КАК Пользователь,
			|	НастройкиУведомлений.Настройка КАК Настройка,
			|	НастройкиУведомлений.ВидСобытия КАК ВидСобытия,
			|	НастройкиУведомлений.СпособУведомления КАК СпособУведомления,
			|	НастройкиУведомлений.Объект КАК Объект
			|ИЗ
			|	РегистрСведений.НастройкиУведомлений КАК НастройкиУведомлений
			|ГДЕ
			|	НастройкиУведомлений.Пользователь <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
			|	И НастройкиУведомлений.Объект = НЕОПРЕДЕЛЕНО";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			УдалитьНастройку(
				Выборка.Пользователь,
				Выборка.Настройка,
				Выборка.ВидСобытия,
				Выборка.СпособУведомления,
				Выборка.Объект);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Удаляет подписку на уведомления по объекту.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//  Объект - ЛюбаяСсылка - Объект.
//
Процедура УдалитьПодпискуПоОбъекту(Пользователь, ВидСобытия, СпособУведомления, Объект) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.Подписка;
	
	УдалитьНастройку(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект);
	
КонецПроцедуры

// Сохраняет дополнительную настройку.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  Настройка - ПеречислениеСсылка.НастройкиУведомлений - Настройка.
//  Значение - Булево, Строка, Число - Значение настройки.
//
Процедура УстановитьДополнительнуюНастройку(Пользователь, Настройка, Значение) Экспорт
	
	ВидСобытия = Перечисления.НастройкиУведомлений.ВидСобытия(Настройка);
	СпособУведомления = Перечисления.СпособыУведомления.ПустаяСсылка();
	Объект = Неопределено;
	
	УстановитьНастройкуПользователя(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект, Значение);
	
КонецПроцедуры

// Сохраняет дополнительную настройку по умолчанию.
//
// Параметры:
//  Настройка - ПеречислениеСсылка.НастройкиУведомлений - Настройка.
//  Значение - Булево, Строка, Число - Значение настройки.
//
Процедура УстановитьДополнительнуюНастройкуПоУмолчанию(Настройка, Значение) Экспорт
	
	ВидСобытия = Перечисления.НастройкиУведомлений.ВидСобытия(Настройка);
	СпособУведомления = Перечисления.СпособыУведомления.ПустаяСсылка();
	
	УстановитьНастройкуПоУмолчанию(Настройка, ВидСобытия, СпособУведомления, Значение);
	
КонецПроцедуры

// Сохраняет подписку на уведомления.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//  Значение - Булево - Значение подписки.
//
Процедура УстановитьПодписку(Пользователь, ВидСобытия, СпособУведомления, Значение) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.Подписка;
	Объект = Неопределено;
	
	НачатьТранзакцию();
	Попытка
		
		УстановитьНастройкуПользователя(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект, Значение);
		Для Каждого СвязаннаяПодписка Из Перечисления.НастройкиУведомлений.СвязанныеПодписки(ВидСобытия) Цикл
			УстановитьНастройкуПользователя(Пользователь, Настройка, СвязаннаяПодписка, СпособУведомления, Объект, Значение);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Сохраняет подписку на уведомления по объекту.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//  Объект - ЛюбаяСсылка - Объект.
//  Значение - Булево - Значение подписки.
//
Процедура УстановитьПодпискуПоОбъекту(Пользователь, ВидСобытия, СпособУведомления, Объект, Значение) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.Подписка;
	
	УстановитьНастройку(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект, Значение);
	
КонецПроцедуры

// Сохраняет подписку на уведомления по умолчанию.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//  Значение - Булево - Значение подписки.
//
Процедура УстановитьПодпискуПоУмолчанию(ВидСобытия, СпособУведомления, Значение) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.Подписка;
	
	НачатьТранзакцию();
	Попытка
		
		УстановитьНастройкуПоУмолчанию(Настройка, ВидСобытия, СпособУведомления, Значение);
		Для Каждого СвязаннаяПодписка Из Перечисления.НастройкиУведомлений.СвязанныеПодписки(ВидСобытия) Цикл
			УстановитьНастройкуПоУмолчанию(Настройка, СвязаннаяПодписка, СпособУведомления, Значение);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Сохраняет срок уведомлений.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Значение - Число - Значение срока.
//
Процедура УстановитьСрок(Пользователь, ВидСобытия, Значение) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.СрокУведомления;
	СпособУведомления = Перечисления.СпособыУведомления.ПустаяСсылка();
	Объект = Неопределено;
	
	УстановитьНастройкуПользователя(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект, Значение);
	
КонецПроцедуры

// Сохраняет срок уведомлений по умолчанию.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Значение - Число - Значение срока.
//
Процедура УстановитьСрокПоУмолчанию(ВидСобытия, Значение) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.СрокУведомления;
	СпособУведомления = Перечисления.СпособыУведомления.ПустаяСсылка();
	
	УстановитьНастройкуПоУмолчанию(Настройка, ВидСобытия, СпособУведомления, Значение);
	
КонецПроцедуры

// Сохраняет частоту уведомлений.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Значение - Число - Значение частоты.
//
Процедура УстановитьЧастоту(Пользователь, ВидСобытия, Значение) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.ЧастотаУведомления;
	СпособУведомления = Перечисления.СпособыУведомления.ПустаяСсылка();
	Объект = Неопределено;
	
	УстановитьНастройкуПользователя(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект, Значение);
	
КонецПроцедуры

// Сохраняет частоту уведомлений по умолчанию.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Значение - Число - Значение частоты.
//
Процедура УстановитьЧастотуПоУмолчанию(ВидСобытия, Значение) Экспорт
	
	Настройка = Перечисления.НастройкиУведомлений.ЧастотаУведомления;
	СпособУведомления = Перечисления.СпособыУведомления.ПустаяСсылка();
	
	УстановитьНастройкуПоУмолчанию(Настройка, ВидСобытия, СпособУведомления, Значение);
	
КонецПроцедуры

// Возвращает настройки подписки по умолчанию.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий
//             - ПеречислениеСсылка.СобытияУведомлений
// 
// Возвращаемое значение:
//  ТаблицаЗначений:
//   * СпособУведомления - ПеречислениеСсылка.СпособыУведомления
//   * Значение - Булево
//
Функция НастройкиПодпискиПоУмолчанию(ВидСобытия) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	НастройкиУведомлений.СпособУведомления КАК СпособУведомления,
		|	НастройкиУведомлений.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.НастройкиУведомлений КАК НастройкиУведомлений
		|ГДЕ
		|	НастройкиУведомлений.Объект = &Объект
		|	И НастройкиУведомлений.Пользователь = &Пользователь
		|	И НастройкиУведомлений.Настройка = &Настройка
		|	И НастройкиУведомлений.ВидСобытия = &ВидСобытия");
	
	Запрос.УстановитьПараметр("Объект", Неопределено);
	Запрос.УстановитьПараметр("Пользователь", Справочники.Пользователи.ПустаяСсылка());
	Запрос.УстановитьПараметр("Настройка", Перечисления.НастройкиУведомлений.Подписка);
	Запрос.УстановитьПараметр("ВидСобытия", ВидСобытия);
	
	НастройкиПодпискиПоУмолчанию = Запрос.Выполнить().Выгрузить();
	
	Возврат НастройкиПодпискиПоУмолчанию;
	
КонецФункции

// Возвращает персональные подписки.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий
//             - ПеречислениеСсылка.СобытияУведомлений
//  Пользователь - СправочникСсылка.Пользователи
// 
// Возвращаемое значение:
//  ТаблицаЗначений:
//   * СпособУведомления - ПеречислениеСсылка.СпособыУведомления
//   * Значение - Булево
//
Функция ПерсональныеНастройкиПодписки(ВидСобытия, Пользователь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	НастройкиУведомлений.СпособУведомления КАК СпособУведомления,
		|	НастройкиУведомлений.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.НастройкиУведомлений КАК НастройкиУведомлений
		|ГДЕ
		|	НастройкиУведомлений.Объект = &Объект
		|	И НастройкиУведомлений.Пользователь = &Пользователь
		|	И НастройкиУведомлений.Настройка = &Настройка
		|	И НастройкиУведомлений.ВидСобытия = &ВидСобытия");
	
	Запрос.УстановитьПараметр("Объект", Неопределено);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Настройка", Перечисления.НастройкиУведомлений.Подписка);
	Запрос.УстановитьПараметр("ВидСобытия", ВидСобытия);
	
	ПерсональныеНастройкиПодписки = Запрос.Выполнить().Выгрузить();
	
	Возврат ПерсональныеНастройкиПодписки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует таблицу доступных настроек уведомлений.
//
// Параметры:
//  Настройка - ПеречислениеСсылка.НастройкиУведомлений - Настройка.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Доступные настройки.
//
Функция ДоступныеНастройки(Настройка)
	
	Если Настройка = Перечисления.НастройкиУведомлений.Подписка Тогда
		ИмяКолонки = "ДоступнаПодписка";
	ИначеЕсли Настройка = Перечисления.НастройкиУведомлений.СрокУведомления Тогда
		ИмяКолонки = "ДоступенСрок";
	ИначеЕсли Настройка = Перечисления.НастройкиУведомлений.ЧастотаУведомления Тогда
		ИмяКолонки = "ДоступнаЧастота";
	Иначе
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Невозможно получить доступные настройки %1.'"), Настройка);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ДоступныеНастройки = РаботаСУведомлениями.ДоступныеУведомления();
	КоличествоЭлементов = ДоступныеНастройки.Количество();
	Для Индекс = 1 По КоличествоЭлементов Цикл
		Строка = ДоступныеНастройки[КоличествоЭлементов - Индекс];
		Если Не Строка[ИмяКолонки] Тогда
			ДоступныеНастройки.Удалить(Строка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДоступныеНастройки;
	
КонецФункции

// Для закончившихся ранее документов добавляет записи, что уведомления обработаны.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//
Процедура ОтметитьОтправкуУведомленийПоОкончившимсяРанееДокументам(Пользователь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДокументыПредприятия.Ссылка КАК Документ,
		|	ВЫБОР
		|		КОГДА СотрудникиПользователей.Пользователь ЕСТЬ NULL
		|			ТОГДА ДокументыПредприятия.Ответственный
		|		ИНАЧЕ СотрудникиПользователей.Пользователь
		|	КОНЕЦ КАК Ответственный
		|ПОМЕСТИТЬ ДокументыСИстекшимСрокомДействия
		|ИЗ
		|	Справочник.ДокументыПредприятия КАК ДокументыПредприятия
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СотрудникиПользователей КАК СотрудникиПользователей
		|		ПО ДокументыПредприятия.Ответственный = СотрудникиПользователей.Сотрудник
		|ГДЕ
		|	ДокументыПредприятия.Ответственный <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
		|		И ДокументыПредприятия.Ответственный <> ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка)
		|		И ДокументыПредприятия.Ответственный <> НЕОПРЕДЕЛЕНО
		|		И ДокументыПредприятия.Ответственный В(&Ответственные)
		|		И ДокументыПредприятия.ВидДокумента.УчитыватьСрокДействия = ИСТИНА
		|		И ДокументыПредприятия.ДатаОкончанияДействия <> ДАТАВРЕМЯ(1, 1, 1)
		|		И КОНЕЦПЕРИОДА(ДокументыПредприятия.ДатаОкончанияДействия, ДЕНЬ) < КОНЕЦПЕРИОДА(&ТекущаяДата, ДЕНЬ)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДокументыСИстекшимСрокомДействия.Документ КАК Документ,
		|	ДокументыСИстекшимСрокомДействия.Ответственный КАК Ответственный
		|ПОМЕСТИТЬ ДокументыПоОтветственным
		|ИЗ
		|	ДокументыСИстекшимСрокомДействия КАК ДокументыСИстекшимСрокомДействия
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДокументыСИстекшимСрокомДействия.Документ,
		|	ЗамещающиеИПомощники.Замещающий
		|ИЗ
		|	ДокументыСИстекшимСрокомДействия КАК ДокументыСИстекшимСрокомДействия
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗамещающиеИПомощники КАК ЗамещающиеИПомощники
		|		ПО ДокументыСИстекшимСрокомДействия.Ответственный = ЗамещающиеИПомощники.Сотрудник
		|ГДЕ
		|	НЕ ЗамещающиеИПомощники.Замещающий ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДокументыПоОтветственным.Документ КАК Документ,
		|	ДокументыПоОтветственным.Ответственный КАК Ответственный
		|ИЗ
		|	ДокументыПоОтветственным КАК ДокументыПоОтветственным
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбработанныеУведомления КАК ОбработанныеУведомления
		|		ПО (ОбработанныеУведомления.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.СобытияУведомлений.ЗакончилсяСрокДействияДокумента))
		|			И ДокументыПоОтветственным.Документ = ОбработанныеУведомления.ОбъектУведомления
		|			И ДокументыПоОтветственным.Ответственный = ОбработанныеУведомления.Пользователь
		|ГДЕ
		|	ОбработанныеУведомления.ВидСобытия ЕСТЬ NULL";
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	Если ЗначениеЗаполнено(Пользователь) Тогда
		Ответственные = Сотрудники.СотрудникиПользователя(Пользователь);
		Запрос.УстановитьПараметр("Ответственные", Ответственные);
	Иначе
		Запрос.Текст = СтрЗаменить(
			Запрос.Текст, "И ДокументыПредприятия.Ответственный В(&Ответственные)", "");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		РегистрыСведений.ОбработанныеУведомления.ДобавитьОбработанноеУведомление(
			Перечисления.СобытияУведомлений.ЗакончилсяСрокДействияДокумента,
			Выборка.Документ,
			Выборка.Ответственный);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает настройку уведомлений.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  Настройка - ПеречислениеСсылка.НастройкиУведомлений - Настройка.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//  Объект - ЛюбаяСсылка - Объект.
// 
// Возвращаемое значение:
//  Булево, Строка, Число - Значение настройки.
//
Функция ПолучитьНастройку(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиУведомлений.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.НастройкиУведомлений КАК НастройкиУведомлений
		|ГДЕ
		|	НастройкиУведомлений.Пользователь = &Пользователь
		|	И НастройкиУведомлений.Настройка = &Настройка
		|	И НастройкиУведомлений.ВидСобытия = &ВидСобытия
		|	И НастройкиУведомлений.СпособУведомления = &СпособУведомления
		|	И НастройкиУведомлений.Объект = &Объект";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Настройка", Настройка);
	Запрос.УстановитьПараметр("ВидСобытия", ВидСобытия);
	Запрос.УстановитьПараметр("СпособУведомления", СпособУведомления);
	Запрос.УстановитьПараметр("Объект", Объект);
	
	ЗначениеНастройки = Неопределено;
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗначениеНастройки = Выборка.Значение;
	КонецЕсли;
	
	Возврат ЗначениеНастройки;
	
КонецФункции

// Возвращает настройку уведомлений пользователя.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  Настройка - ПеречислениеСсылка.НастройкиУведомлений - Настройка.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
// 
// Возвращаемое значение:
//  Булево, Строка, Число - Значение настройки.
//
Функция ПолучитьНастройкуПользователя(Пользователь, Настройка, ВидСобытия, СпособУведомления)
	
	Объект = Неопределено;
	
	Если Не РазрешеноИзменятьНастройки() И ПолучитьПодпискуПоУмолчанию(ВидСобытия, СпособУведомления) Тогда
		ЗначениеНастройки = ПолучитьНастройкуПоУмолчанию(Настройка, ВидСобытия, СпособУведомления);
	Иначе
		ЗначениеНастройки = ПолучитьНастройку(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект);
		Если ЗначениеНастройки = Неопределено Тогда
			ЗначениеНастройки = ПолучитьНастройкуПоУмолчанию(Настройка, ВидСобытия, СпособУведомления);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗначениеНастройки;
	
КонецФункции

// Возвращает настройку уведомлений по умолчанию.
//
// Параметры:
//  Настройка - ПеречислениеСсылка.НастройкиУведомлений - Настройка.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
// 
// Возвращаемое значение:
//  Булево, Строка, Число - Значение настройки.
//
Функция ПолучитьНастройкуПоУмолчанию(Настройка, ВидСобытия, СпособУведомления)
	
	Пользователь = Справочники.Пользователи.ПустаяСсылка();
	Объект = Неопределено;
	
	ЗначениеНастройки = ПолучитьНастройку(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект);
	Если ЗначениеНастройки = Неопределено Тогда
		ЗначениеНастройки = Перечисления.НастройкиУведомлений.СтандартноеЗначениеНастройки(
			Настройка,
			ВидСобытия,
			СпособУведомления);
	КонецЕсли;
	
	Возврат ЗначениеНастройки;
	
КонецФункции

// Обработчик изменения значения настройки.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  Настройка - ПеречислениеСсылка.НастройкиУведомлений - Настройка.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//  Объект - ЛюбаяСсылка - Объект.
//  Значение - Булево, Строка, Число - Значение настройки.
//
Процедура ПриИзмененииНастройки(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект, Значение)
	
	Если Настройка = Перечисления.НастройкиУведомлений.Подписка
		И ВидСобытия = Перечисления.СобытияУведомлений.ЗакончилсяСрокДействияДокумента
		И Значение Тогда
		ОтметитьОтправкуУведомленийПоОкончившимсяРанееДокументам(Пользователь);
	КонецЕсли;
	
КонецПроцедуры

// Удаляет настройку уведомлений.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  Настройка - ПеречислениеСсылка.НастройкиУведомлений - Настройка.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//  Объект - ЛюбаяСсылка - Объект.
//
Процедура УдалитьНастройку(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Настройка = Настройка;
	Запись.ВидСобытия = ВидСобытия;
	Запись.СпособУведомления = СпособУведомления;
	Запись.Объект = Объект;
	Запись.Удалить();
	
КонецПроцедуры

// Сохраняет настройку уведомлений.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  Настройка - ПеречислениеСсылка.НастройкиУведомлений - Настройка.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//  Объект - ЛюбаяСсылка - Объект.
//  Значение - Булево, Строка, Число - Значение настройки.
//
Процедура УстановитьНастройку(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект, Значение)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		НачальноеЗначение = ПолучитьНастройку(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект);
		
		Запись = СоздатьМенеджерЗаписи();
		Запись.Пользователь = Пользователь;
		Запись.Настройка = Настройка;
		Запись.ВидСобытия = ВидСобытия;
		Запись.СпособУведомления = СпособУведомления;
		Запись.Объект = Объект;
		Запись.Значение = Значение;
		Запись.Записать();
		
		Если Значение <> НачальноеЗначение Тогда
			ПриИзмененииНастройки(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект, Значение);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Сохраняет настройку уведомлений пользователя.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  Настройка - ПеречислениеСсылка.НастройкиУведомлений - Настройка.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//  Объект - ЛюбаяСсылка - Объект.
//  Значение - Булево, Строка, Число - Значение настройки.
//
Процедура УстановитьНастройкуПользователя(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект, Значение)
	
	ЗначениеПоУмолчанию = ПолучитьНастройкуПоУмолчанию(Настройка, ВидСобытия, СпособУведомления);
	Если Значение <> ЗначениеПоУмолчанию Тогда
		УстановитьНастройку(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект, Значение);
	Иначе
		УдалитьНастройку(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект);
	КонецЕсли;
	
КонецПроцедуры

// Сохраняет настройку уведомлений по умолчанию.
//
// Параметры:
//  Настройка - ПеречислениеСсылка.НастройкиУведомлений - Настройка.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  СпособУведомления - ПеречислениеСсылка.СпособыУведомления - Способ уведомления.
//  Значение - Булево, Строка, Число - Значение настройки.
//
Процедура УстановитьНастройкуПоУмолчанию(Настройка, ВидСобытия, СпособУведомления, Значение)
	
	Пользователь = Справочники.Пользователи.ПустаяСсылка();
	Объект = Неопределено;
	
	УстановитьНастройку(Пользователь, Настройка, ВидСобытия, СпособУведомления, Объект, Значение);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли