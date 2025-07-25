﻿////////////////////////////////////////////////////////////////////////////////
// Бронирование помещений, модуль для переопределения особенностей конфигурации для холдинга (сервер).
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработка перед записью объекта справочника "Территории и помещения".
// 
// Параметры:
//  Источник - СправочникОбъект.ТерриторииИПомещения.
//  Отказ - Булево.
//
Процедура ТерриторииИПомещенияПередЗаписью(Источник, Отказ) Экспорт
	
	Если Не ЗначениеЗаполнено(Источник.УзелОбработки) Тогда
		Источник.УзелОбработки = КОДПовтИсп.ИдентификаторТекущегоУзла();
	КонецЕсли;
	
КонецПроцедуры

// Обработка заполнения объекта справочника "Территории и помещения".
// 
// Параметры:
//  Источник - СправочникОбъект.ТерриторииИПомещения.
//  ДанныеЗаполнения - Произвольный.
//  ТекстЗаполнения - Строка.
//  СтандартнаяОбработка - Булево.
//
Процедура ТерриторииИПомещенияОбработкаЗаполнения(Источник, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если Не ЗначениеЗаполнено(Источник.УзелОбработки) Тогда
		Источник.УзелОбработки = КОДПовтИсп.ИдентификаторТекущегоУзла();
	КонецЕсли;
	
КонецПроцедуры

// Обработка при создании на сервере формы элемента справочника "Территории и помещения".
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения.
//  Отказ - Булево.
//  СтандартнаяОбработка - Булево.
//  Родитель - ГруппаФормы.
//
Процедура ТерриторииИПомещенияПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка, Родитель) Экспорт
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Справочники.УзлыКОД) Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФормами.ДобавитьРеквизит(Форма, "УзелОбработки", Тип("Строка"));
	Форма.УзелОбработки = КОДПовтИсп.УзелПредставлениеПоИдентификатору(Строка(Форма.Объект.УзелОбработки));
	
	Элемент = РаботаСФормами.ДобавитьПолеНадписи(Форма.Элементы, "УзелОбработки", Родитель, "УзелОбработки");
	Элемент.Заголовок = Метаданные.ОбщиеРеквизиты.УзелОбработки.Синоним;
	Элемент.Гиперссылка = Истина;
	Элемент.УстановитьДействие("Нажатие", "Подключаемый_Нажатие");
	
КонецПроцедуры

// Обработка при чтении на сервере формы элемента справочника "Территории и помещения".
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения.
//  ТекущийОбъект - СправочникОбъект.ТерриторииИПомещения.
//
Процедура ТерриторииИПомещенияПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	Если Не РаботаСФормами.РеквизитСуществует(Форма, "УзелОбработки") Тогда
		// Форма ещё не инициализирована. Будет заполнено при создании.
		Возврат;
	КонецЕсли;
	
	Форма.УзелОбработки = КОДПовтИсп.УзелПредставлениеПоИдентификатору(Строка(Форма.Объект.УзелОбработки));
	
КонецПроцедуры

// Проверяет, что это помещение этого узла.
// 
// Параметры:
//  Помещение - СправочникСсылка.ТерриторииИПомещения.
// 
// Возвращаемое значение:
//  Булево - Это помещение этого узла.
//
Функция ЭтоПомещениеЭтогоУзла(Помещение) Экспорт
	
	УзелПомещения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Помещение, "УзелОбработки");
	ЭтотУзел = КОДПовтИсп.ИдентификаторТекущегоУзла();
	
	ЭтоПомещениеЭтогоУзла = (УзелПомещения = ЭтотУзел);
	
	Возврат ЭтоПомещениеЭтогоУзла;
	
КонецФункции

// Определяет следующие свойств регламентных заданий:
//  - зависимость от функциональных опций.
//  - возможность выполнения в различных режимах работы программы.
//  - прочие параметры.
//
// Параметры:
//  Настройки - ТаблицаЗначений - таблица значений с колонками:
//    * РегламентноеЗадание - ОбъектМетаданных:РегламентноеЗадание - регламентное задание.
//    * ФункциональнаяОпция - ОбъектМетаданных:ФункциональнаяОпция - функциональная опция,
//        от которой зависит регламентное задание.
//    * ЗависимостьПоИ      - Булево - если регламентное задание зависит более, чем
//        от одной функциональной опции и его необходимо включать только тогда,
//        когда все функциональные опции включены, то следует указывать Истина
//        для каждой зависимости.
//        По умолчанию Ложь - если хотя бы одна функциональная опция включена,
//        то регламентное задание тоже включено.
//    * ВключатьПриВключенииФункциональнойОпции - Булево, Неопределено - если Ложь, то при
//        включении функциональной опции регламентное задание не будет включаться. Значение
//        Неопределено соответствует значению Истина.
//        По умолчанию - неопределено.
//    * ДоступноВПодчиненномУзлеРИБ - Булево, Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в РИБ.
//        По умолчанию - неопределено.
//    * ДоступноВПодчиненномУзлеКОД - Булево, Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в подчиненном узле КОД.
//        По умолчанию - неопределено.
//    * ДоступноВАвтономномРабочемМесте - Булево, Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в автономном рабочем месте.
//        По умолчанию - неопределено.
//    * ДоступноВМоделиСервиса      - Булево, Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в модели сервиса.
//        По умолчанию - неопределено.
//    * РаботаетСВнешнимиРесурсами  - Булево - Истина, если регламентное задание модифицирует данные
//        во внешних источниках (получение почты, синхронизация данных и т.п.). Не следует устанавливать
//        значение Истина, для регламентных заданий, не модифицирующих данные во внешних источниках.
//        Например, регламентное задание ЗагрузкаКурсовВалют. По умолчанию - Ложь.
//    * Параметризуется             - Булево - Истина, если регламентное задание параметризованное.
//        По умолчанию - Ложь.
//
// Например:
//	Настройка = Настройки.Добавить();
//	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеСтатусовДоставкиSMS;
//	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьПочтовыйКлиент;
//	Настройка.ДоступноВМоделиСервиса = Ложь;
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	// Подтверждение бронирования помещений необходимо только при обмене КОД.
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПодтверждениеБронированияПомещений;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьБронированиеПомещений;
	Настройка.ЗависимостьПоИ = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПодтверждениеБронированияПомещений;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьКОД;
	Настройка.ЗависимостьПоИ = Истина;
	
КонецПроцедуры

// Обрабатывает оперативное подтверждение бронирования на сервере.
// В случае необходимости оперативного подтверждения запускает длительную операцию подтверждения
// и заполняет реквизит параметра РезультатБронирования.ДлительнаяОперацияПодтверждения.
// В случае необходимости оперативной отмены запускает длительную операцию отмены.
// 
// Параметры:
//  РезультатБронирования - Структура - Общий результат броней:
//   * РезультатыБроней                - Массив Из Структура            - Результаты каждой брони:
//      ** Бронь                - ДокументСсылка.Бронь - Бронь.
//      ** ОжидаетПодтверждения - Булево               - Бронь ожидает подтверждения.
//   * ОтмененныеБрони                 - Массив из ДокументСсылка.Бронь - Брони, для которых была выполнена отмена.
//   * ДлительнаяОперацияПодтверждения - Структура                      - Длительная операция оперативного подтверждения брони.
//                                       Неопределено                   - Длительная операция не запущена.
//
Процедура ОперативноеПодтверждениеБронирования(РезультатБронирования) Экспорт
	
	Если Не БронированиеПомещенийХолдингПовтИсп.ИспользоватьОперативноеПодтверждениеБронированияПомещений() Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьОперативноеПодтверждениеБроней(РезультатБронирования);
	ОбработатьОперативнуюОтменуБроней(РезультатБронирования.ОтмененныеБрони);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик регламентного задания "Подтверждение бронирования помещений".
//
Процедура ПодтверждениеБронированияПомещений() Экспорт
	
	Отказ = Ложь;
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ПодтверждениеБронированияПомещений,
		Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПомещенияУзлаДляБронирования = ПомещенияЭтогоУзлаДляБронирования();
	Для Каждого Бронь Из Документы.Бронь.ОжидающиеПодтвержденияБрони(ПомещенияУзлаДляБронирования) Цикл
		Попытка
			ОбработатьПодтверждениеБрони(Бронь);
		Исключение
			ЗаписьЖурналаРегистрации(
				БронированиеПомещенийКлиентСервер.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,,,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Подтверждает бронь оперативно.
//
// Параметры:
//  ПараметрыПроцедуры - Структура - Параметры процедура:
//   * БрониОжидающиеПодтверждения - Массив из ДокументСсылка.Бронь - Брони, которые необходимо подтвердить оперативно.
//  АдресРезультата    - Строка    - Адрес временного хранилища, в которое нужно поместить результат.
//
Процедура ФоновоеОперативноеПодтверждениеБрони(ПараметрыПроцедуры, АдресРезультата) Экспорт
	
	РезультатыПодтвержденияБроней = Новый Массив;
	Для Каждого Бронь Из ПараметрыПроцедуры.БрониОжидающиеПодтверждения Цикл
		
		РезультатыПодтвержденияБрони = Новый Структура("Бронь, Подтверждена");
		РезультатыПодтвержденияБрони.Бронь = Бронь;
		РезультатыПодтвержденияБрони.Подтверждена = ПодтвердитьБроньОперативно(Бронь);
		РезультатыПодтвержденияБроней.Добавить(РезультатыПодтвержденияБрони);
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(РезультатыПодтвержденияБроней, АдресРезультата);
	
КонецПроцедуры

// Отменяет бронь оперативно.
//
// Параметры:
//  ПараметрыПроцедуры - Структура - Параметры процедура:
//   * ОтмененныеБрониДругихУзлов - Массив из ДокументСсылка.Бронь - Брони, которые необходимо отменить оперативно.
//  АдресРезультата    - Строка    - Адрес временного хранилища, в которое нужно поместить результат.
//
Процедура ФоноваяОперативнаяОтменаБрони(ПараметрыПроцедуры, АдресРезультата) Экспорт
	
	Для Каждого Бронь Из ПараметрыПроцедуры.ОтмененныеБрониДругихУзлов Цикл
		
		Попытка
			ОтменитьБроньОперативно(Бронь);
		Исключение
			ЗаписьЖурналаРегистрации(
				БронированиеПомещенийКлиентСервер.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,,,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

// Обрабатывает оперативное подтверждение броней на сервере.
// В случае необходимости оперативного подтверждения запускает длительную операцию подтверждения
// и заполняет реквизит параметра РезультатБронирования.ДлительнаяОперацияПодтверждения.
// 
// Параметры:
//  РезультатБронирования - Структура - Общий результат броней:
//   * РезультатыБроней                - Массив Из Структура            - Результаты каждой брони:
//      ** Бронь                - ДокументСсылка.Бронь - Бронь.
//      ** ОжидаетПодтверждения - Булево               - Бронь ожидает подтверждения.
//   * ОтмененныеБрони                 - Массив из ДокументСсылка.Бронь - Брони, для которых была выполнена отмена.
//   * ДлительнаяОперацияПодтверждения - Структура                      - Длительная операция оперативного подтверждения брони.
//                                       Неопределено                   - Длительная операция не запущена.
//
Процедура ОбработатьОперативноеПодтверждениеБроней(РезультатБронирования)
	
	БрониОжидающиеПодтверждения = Новый Массив;
	Для Каждого РезультатБрони Из РезультатБронирования.РезультатыБроней Цикл
		
		Если Не РезультатБрони.ОжидаетПодтверждения Тогда
			Продолжить;
		КонецЕсли;
		
		БрониОжидающиеПодтверждения.Добавить(РезультатБрони.Бронь);
		
	КонецЦикла;
	Если БрониОжидающиеПодтверждения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	БрониОжидающиеПодтверждения =
		ОбщегоНазначенияКлиентСервер.СвернутьМассив(БрониОжидающиеПодтверждения);
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.ОжидатьЗавершение = 0;
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = НСтр("ru = 'Оперативное подтверждение броней'");
	
	РезультатБронирования.ДлительнаяОперацияПодтверждения = ДлительныеОперации.ВыполнитьВФоне(
		"БронированиеПомещенийХолдинг.ФоновоеОперативноеПодтверждениеБрони",
		Новый Структура("БрониОжидающиеПодтверждения", БрониОжидающиеПодтверждения),
		ПараметрыВыполненияВФоне);
	
КонецПроцедуры

// Обрабатывает оперативную отмену броней на сервере.
// В случае необходимости оперативной отмены запускает длительную операцию отмены.
// 
// Параметры:
//  ОтмененныеБрони - Массив из ДокументСсылка.Бронь - Отмененные брони.
//
Процедура ОбработатьОперативнуюОтменуБроней(ОтмененныеБрони)
	
	ПризнакиЭтоПомещениеЭтогоУзла = Новый Соответствие;
	ОтмененныеБрониДругихУзлов = Новый Массив;
	
	ПомещенияБроней = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ОтмененныеБрони, "Помещение");
	Для Каждого ОтмененнаяБронь Из ОтмененныеБрони Цикл
		
		ПомещениеБрони = ПомещенияБроней[ОтмененнаяБронь];
		
		ЭтоПомещениеЭтогоУзла = ПризнакиЭтоПомещениеЭтогоУзла[ПомещениеБрони];
		Если ЭтоПомещениеЭтогоУзла = Неопределено Тогда
			ПризнакиЭтоПомещениеЭтогоУзла[ПомещениеБрони] = ЭтоПомещениеЭтогоУзла(ПомещениеБрони);
			ЭтоПомещениеЭтогоУзла = ПризнакиЭтоПомещениеЭтогоУзла[ПомещениеБрони];
		КонецЕсли;
		Если ЭтоПомещениеЭтогоУзла Тогда
			Продолжить;
		КонецЕсли;
		
		ОтмененныеБрониДругихУзлов.Добавить(ОтмененнаяБронь);
		
	КонецЦикла;
	
	Если ОтмененныеБрониДругихУзлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОтмененныеБрониДругихУзлов =
		ОбщегоНазначенияКлиентСервер.СвернутьМассив(ОтмененныеБрониДругихУзлов);
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.ОжидатьЗавершение = 0;
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = НСтр("ru = 'Оперативная отмена броней'");
	
	ДлительныеОперации.ВыполнитьВФоне(
		"БронированиеПомещенийХолдинг.ФоноваяОперативнаяОтменаБрони",
		Новый Структура("ОтмененныеБрониДругихУзлов", ОтмененныеБрониДругихУзлов),
		ПараметрыВыполненияВФоне);
	
КонецПроцедуры

// Отменяет бронь оперативно.
//
// Параметры:
//  Бронь - ДокументСсылка.Бронь - Бронь, которую необходимо отменить оперативно.
//
Процедура ОтменитьБроньОперативно(Бронь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПомещениеБрони = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Бронь, "Помещение");
	
	Если ЭтоПомещениеЭтогоУзла(ПомещениеБрони) Тогда
		ВызватьИсключение НСтр("ru = 'Для броней этого узла не требуется оперативная отмена.'");
	КонецЕсли;
	
	РезультатОтмены = ВыполнитьЗапросОтменитьБронированиеПомещения(Бронь);
	Если РезультатОтмены.Отменена Тогда
		
		// Оперативная отмена прошла успешно.
		
	ИначеЕсли РезультатОтмены.Ошибка Тогда
		
		ВызватьИсключение РезультатОтмены.ТекстОшибки;
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Неизвестный результат отмены бронирования помещения.'");
		
	КонецЕсли;
	
КонецПроцедуры

// Отменяет бронь оперативно.
//
// Параметры:
//  Бронь - ДокументСсылка.Бронь - Бронь, которую необходимо отменить оперативно.
// 
// Возвращаемое значение:
//  Структура - Результат отмены:
//   * Отменена - Булево.
//   * Ошибка - Булево.
//   * ТекстОшибки - Строка.
//
Функция ВыполнитьЗапросОтменитьБронированиеПомещения(Бронь)
	
	РезультатОтмены = Новый Структура;
	РезультатОтмены.Вставить("Отменена", Ложь);
	РезультатОтмены.Вставить("Ошибка", Ложь);
	РезультатОтмены.Вставить("ТекстОшибки", "");
	
	// Для переопределения в ДокументооборотХолдинга.
	РезультатОтмены.Ошибка = Истина;
	РезультатОтмены.ТекстОшибки = НСтр("ru = 'Невозможно выполнить запрос отмены бронирования помещения.'");
	
	Возврат РезультатОтмены;
	
КонецФункции


// Обработчик подтверждения брони - пытается выполнить подтверждение брони.
// Если подтвержденных пересекающихся броней нет - то устанавливает состояние "Подтверждена".
// Если есть пересекающиеся подтвержденные брони - то устанавливает состояние "Отменена".
// Если бронь не ожидает подтверждения, то вызывает исключение.
// Если помещение брони относится к другому узлу код, то вызывает исключение.
//
// Параметры:
//  Бронь - ДокументСсылка.Бронь - Бронь, которую необходимо подтвердить.
//
Процедура ОбработатьПодтверждениеБрони(Бронь)
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Документ.Бронь");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Бронь);
		Блокировка.Заблокировать();
		
		ЗаблокироватьДанныеДляРедактирования(Бронь);
		
		БроньОбъект = Бронь.ПолучитьОбъект();
		
		// Если бронь уже удалили - пропускаем обработку.
		Если БроньОбъект <> Неопределено Тогда
			
			// Если бронь уже обработали, либо пометили не удаление, либо изменили помещение - пропускаем обработку.
			
			ЭтоПомещениеЭтогоУзла = ЭтоПомещениеЭтогоУзла(БроньОбъект.Помещение);
			Если БроньОбъект.ОжидаетПодтверждения() И ЭтоПомещениеЭтогоУзла Тогда
				
				Если БроньОбъект.ЕстьПересекающиесяБрони() Тогда
					
					// Если есть пересекающиеся брони - то бронь отменяется.
					БроньОбъект.ОтменитьБронь(
						НСтр("ru = 'Не удалось оперативно подтвердить бронь, т.к. указанное время уже занято'"));
					
				Иначе
					
					// Если пересекающихся броней нет - то бронь подтверждается.
					БроньОбъект.ПодтвердитьБронь();
					
				КонецЕсли;
				
				БроньОбъект.Записать();
				
			КонецЕсли;
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Подтверждает бронь оперативно.
//
// Параметры:
//  Бронь - ДокументСсылка.Бронь - Бронь, которую необходимо подтвердить оперативно.
// 
// Возвращаемое значение:
//  Булево - Бронь подтверждена или отменена.
//
Функция ПодтвердитьБроньОперативно(Бронь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	БроньОбъект = Бронь.ПолучитьОбъект();
	БроньОбъект.ДополнительныеСвойства.Вставить("ЭтоФоноваяОперация", Истина);
	
	Если ЭтоПомещениеЭтогоУзла(БроньОбъект.Помещение) Тогда
		
		БроньОбъект.ПодтвердитьБронь();
		БроньОбъект.Записать();
		
		Подтверждена = Истина;
		
		Возврат Подтверждена;
		
	КонецЕсли;
	
	РезультатПодтверждения = ВыполнитьЗапросПодтвердитьБронированиеПомещения(БроньОбъект);
	Если РезультатПодтверждения.Подтверждена Тогда
		
		БроньОбъект.ПодтвердитьБронь();
		
		Подтверждена = Истина;
		
	ИначеЕсли РезультатПодтверждения.Отменена Тогда
		
		БроньОбъект.ОтменитьБронь(
			НСтр("ru = 'Не удалось оперативно подтвердить бронь, т.к. указанное время уже занято'"));
		
		Подтверждена = Ложь;
		
	ИначеЕсли РезультатПодтверждения.Ошибка Тогда
		
		ЗаписьЖурналаРегистрации(
			БронированиеПомещенийКлиентСервер.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,,
			РезультатПодтверждения.ТекстОшибки);
		
		БроньОбъект.ОтменитьБронь(
			НСтр("ru = 'Не удалось оперативно подтвердить бронь, т.к. возникла техническая ошибка'"));
		
		Подтверждена = Ложь;
		
		Возврат Подтверждена;
		
	Иначе
		
		ЗаписьЖурналаРегистрации(
			БронированиеПомещенийКлиентСервер.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,,
			НСтр("ru = 'Сервис подтверждения бронирования помещений не смог подтвердить или отменить бронь.'"));
		
		БроньОбъект.ОтменитьБронь(
			НСтр("ru = 'Не удалось оперативно подтвердить бронь, т.к. возникла техническая ошибка'"));
		
		Подтверждена = Ложь;
		
	КонецЕсли;
	
	БроньОбъект.Записать();
	
	Возврат Подтверждена;
	
КонецФункции

// Подтверждает бронь оперативно.
//
// Параметры:
//  БроньОбъект - ДокументОбъект.Бронь - Бронь, которую необходимо подтвердить оперативно.
// 
// Возвращаемое значение:
//  Структура - Результат подтверждения:
//   * Подтверждена - Булево.
//   * Отменена - Булево.
//   * Ошибка - Булево.
//   * ТекстОшибки - Строка.
//
Функция ВыполнитьЗапросПодтвердитьБронированиеПомещения(БроньОбъект)
	
	РезультатПодтверждения = Новый Структура;
	РезультатПодтверждения.Вставить("Подтверждена", Ложь);
	РезультатПодтверждения.Вставить("Отменена", Ложь);
	РезультатПодтверждения.Вставить("Ошибка", Ложь);
	РезультатПодтверждения.Вставить("ТекстОшибки", "");
	
	// Для переопределения в ДокументооборотХолдинга.
	РезультатПодтверждения.Ошибка = Истина;
	РезультатПодтверждения.ТекстОшибки = НСтр("ru = 'Невозможно выполнить запрос подтверждения бронирования помещения.'");
	
	Возврат РезультатПодтверждения;
	
КонецФункции

// Формирует список помещений этого узла, доступных для бронирования.
// 
// Возвращаемое значение:
//  Массив из СправочникСсылка.ТерриторииИПомещения - Помещения этого узла, доступные для бронирования.
//
Функция ПомещенияЭтогоУзлаДляБронирования()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТерриторииИПомещения.Ссылка КАК Помещение
		|ИЗ
		|	Справочник.ТерриторииИПомещения КАК ТерриторииИПомещения
		|ГДЕ
		|	ТерриторииИПомещения.УзелОбработки = &ЭтотУзел
		|	И ТерриторииИПомещения.ДоступноБронирование = ИСТИНА
		|	И ТерриторииИПомещения.ПометкаУдаления = ЛОЖЬ");
	
	ЭтотУзел = КОДПовтИсп.ИдентификаторТекущегоУзла();
	Запрос.УстановитьПараметр("ЭтотУзел", ЭтотУзел);
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаРезультата = РезультатЗапроса.Выгрузить();
	ПомещенияЭтогоУзлаДляБронирования = ТаблицаРезультата.ВыгрузитьКолонку("Помещение");
	
	Возврат ПомещенияЭтогоУзлаДляБронирования;
	
КонецФункции

#КонецОбласти