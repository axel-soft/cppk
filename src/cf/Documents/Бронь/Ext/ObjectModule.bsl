﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Включает на данную дату как исключение из правила повторения.
//
Процедура ДобавитьИсключениеПовторения(ДатаИсключения, ЗаписьИсключения = Неопределено) Экспорт
	
	Если ТипЗаписи <> Перечисления.ТипЗаписиКалендаря.ПовторяющеесяСобытие Тогда
		ВызватьИсключение НСтр("ru = 'Некорректный тип повторяющейся брони.'");
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ДатаИсключения", ДатаИсключения);
	НайденныеСтроки = ИсключенияПовторения.НайтиСтроки(ПараметрыОтбора);
	
	Если НайденныеСтроки.Количество() <> 0 Тогда
		ВызватьИсключение НСтр("ru = 'На данную дату уже указано исключение повторения.'");
	КонецЕсли;
	
	НоваяСтрокаИсключенияПовторения = ИсключенияПовторения.Добавить();
	НоваяСтрокаИсключенияПовторения.ЗаписьИсключения = ЗаписьИсключения;
	НоваяСтрокаИсключенияПовторения.ДатаИсключения = ДатаИсключения;
	
КонецПроцедуры

// Возвращает представление повторения объекта.
//
// Возвращаемое значение:
//  Строка - Представление повторения.
//
Функция ПолучитьПредставлениеПовторения() Экспорт
	
	ТекстовоеПредставлениеПовторения = "";
	
	НастройкиПовторения = ПолучитьНастройкиПовторения();
	ТекстовоеПредставлениеПовторения =
		РаботаСРабочимКалендаремКлиентСервер.ПолучитьТекстовоеПредставлениеПовторения(НастройкиПовторения);
	
	Возврат ТекстовоеПредставлениеПовторения;
	
КонецФункции

// Возвращает настройки повторения объекта.
//
Функция ПолучитьНастройкиПовторения() Экспорт
	
	ПовторениеПоДнямНедели = Новый Соответствие;
	Для ИндексПовторениеПоДням = 1 По 7 Цикл
		
		Если ЧастотаПовторения = Перечисления.ЧастотаПовторения.Еженедельно Тогда
			
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("ДеньНедели", ИндексПовторениеПоДням);
			ПараметрыОтбора.Вставить("НомерВхождения", 0);
			НайденныеСтроки = ПовторениеПоДням.НайтиСтроки(ПараметрыОтбора); 
			
			ПовторениеПоДнямНедели.Вставить(ИндексПовторениеПоДням, НайденныеСтроки.Количество() <> 0);
			
		Иначе
			ПовторениеПоДнямНедели.Вставить(ИндексПовторениеПоДням, Ложь);
		КонецЕсли;
		
	КонецЦикла;
	
	ПовторениеПоДнямНеделиВМесяце = Неопределено;
	
	Если ЧастотаПовторения = Перечисления.ЧастотаПовторения.Ежемесячно
		И Не ЗначениеЗаполнено(ПовторениеПоДнямМесяца) И ПовторениеПоДням.Количество() = 1 Тогда
		
		ПовторениеПоДнямНеделиВМесяце = Новый Структура("НомерВхождения, ДеньНедели");
		ЗаполнитьЗначенияСвойств(ПовторениеПоДнямНеделиВМесяце, ПовторениеПоДням[0]);
		
	КонецЕсли;
	
	НастройкиПовторения = РаботаСРабочимКалендаремКлиентСервер.ПолучитьСтруктуруНастройкиПовторения(
		ЧастотаПовторения, ИнтервалПовторения, ПравилоОкончанияПовторения,
		КоличествоПовторов, ДатаОкончанияПовторения, ПовторениеПоДнямНедели,
		ПовторениеПоДнямМесяца, ПовторениеПоДнямНеделиВМесяце, ПовторениеПоМесяцам);
	
	Возврат НастройкиПовторения;
	
КонецФункции

// Корректирует реквизиты повторения.
//
Процедура СкорректироватьДатыПовторения() Экспорт
	
	// Корректировка даты начала повторения и даты окончания повторения
	Если ТипЗаписи = Перечисления.ТипЗаписиКалендаря.Событие
		Или ТипЗаписи = Перечисления.ТипЗаписиКалендаря.ЭлементПовторяющегосяСобытия Тогда
		
		ОчиститьРеквизитыПовторения();
		
	ИначеЕсли ТипЗаписи = Перечисления.ТипЗаписиКалендаря.ПовторяющеесяСобытие Тогда
		
		ДатаНачалаПовторения = ДатаНачала;
		
		Если ПравилоОкончанияПовторения = Перечисления.ПравилаОкончанияПовторения.Никогда Тогда
			ДатаОкончанияПовторения = Дата(1,1,1);
		ИначеЕсли ПравилоОкончанияПовторения = Перечисления.ПравилаОкончанияПовторения.ПослеЧислаПовторов Тогда
			РассчитатьДатуОкончанияПовторения();
		ИначеЕсли ПравилоОкончанияПовторения = Перечисления.ПравилаОкончанияПовторения.ДоДаты Тогда
			Если Не ЗначениеЗаполнено(ДатаОкончанияПовторения) Тогда
				ПравилоОкончанияПовторения = Перечисления.ПравилаОкончанияПовторения.Никогда;
			ИначеЕсли ДатаОкончанияПовторения < ДатаНачалаПовторения Тогда
				ОтменитьПовторение();
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует структуру результат брони.
// 
// Возвращаемое значение:
//  Структура - Результат брони:
//   * Бронь - ДокументСсылка.Бронь - Бронь.
//   * ОжидаетПодтверждения - Булево - Бронь ожидает подтверждения.
//
Функция РезультатБрони() Экспорт
	
	РезультатБрони = Новый Структура("Бронь, ОжидаетПодтверждения");
	РезультатБрони.Бронь = Ссылка;
	РезультатБрони.ОжидаетПодтверждения = ОжидаетПодтверждения();
	
	Возврат РезультатБрони;
	
КонецФункции

// Определяет, ожидает ли бронь подтверждения.
// 
// Возвращаемое значение:
//  Булево - Бронь ожидает подтверждения.
//
Функция ОжидаетПодтверждения() Экспорт
	
	Возврат СостояниеБрони = Перечисления.СостоянияБроней.ОжидаетПодтверждения И Не ПометкаУдаления;
	
КонецФункции

// Отмечает бронь как подтвержденную.
//
Процедура ПодтвердитьБронь() Экспорт
	
	СостояниеБрони = Перечисления.СостоянияБроней.Подтверждена;
	ДатаОтмены = Дата(1, 1, 1);
	ПричинаОтмены = "";
	
КонецПроцедуры

// Отмечает бронь как отмененную.
//
// Параметры:
//  НоваяПричинаОтмены - Строка - Причина отмены брони.
//
Процедура ОтменитьБронь(НоваяПричинаОтмены) Экспорт
	
	СостояниеБрони = Перечисления.СостоянияБроней.Отменена;
	ДатаОтмены = ТекущаяДатаСеанса();
	ПричинаОтмены = НоваяПричинаОтмены;
	
КонецПроцедуры

// Проверяет, есть ли пересекающиеся брони, препятствующие подтверждению брони.
// 
// Возвращаемое значение:
//  Булево - Признак наличия пересечений с другими бронями.
//
Функция ЕстьПересекающиесяБрони() Экспорт
	
	БроньИсключение = Неопределено;
	ДополнительныеСвойства.Свойство("ПовторяющаясяБронь", БроньИсключение);
	Если Не ЗначениеЗаполнено(БроньИсключение) Тогда
		ДополнительныеСвойства.Свойство("БроньИсключение", БроньИсключение);
	КонецЕсли;
	
	ДатаИсключения = Неопределено;
	ДополнительныеСвойства.Свойство("ДатаИсключения", ДатаИсключения);
	
	ЕстьПересекающиесяБрони = БронированиеПомещений.ЕстьПересекающиесяБрони(ЭтотОбъект, БроньИсключение, ДатаИсключения);
	
	Возврат ЕстьПересекающиесяБрони;
	
КонецФункции

// Возвращает структуру правила повторения брони.
// 
// Возвращаемое значение:
//  Структура - Структура правила повторения:
//   * ДатаНачалаПовторения - Дата - Дата, с которой повторяется бронь.
//   * ДатаОкончанияПовторения - Дата - Дата, по которую повторяется бронь.
//   * ИнтервалПовторения - Число - Интервал с которым повторяется бронь.
//   * КоличествоПовторов - Число - Количество повторов брони.
//   * ПовторениеПоДнямМесяца - Число - Дни месяца, по которым повторяется бронь
//   * ПовторениеПоМесяцам - Число - Месяца, по которым повторяется бронь.
//   * ПравилоОкончанияПовторения - ПеречислениеСсылка.ПравилаОкончанияПовторения - Правило окончания повторения.
//   * ТипЗаписиКалендаря - ПеречислениеСсылка.ТипЗаписиКалендаря - Тип брони (обычная / повторяющаяся / исключение повторения).
//   * ЧастотаПовторения - ПеречислениеСсылка.ЧастотаПовторения - Частота повторения брони.
//   * ИсключенияПовторения - ТаблицаЗначений - Даты, по которым бронь не повторяется:
//      ** ДатаИсключения - Дата - Дата, по которой бронь не повторяется.
//      ** ЗаписьИсключения - СправочникСсылка.ЗаписиРабочегоКалендаря - Бронь, которая заменяет бронь на данную дату.
//   * ПовторениеПоДням - ТаблицаЗначений - Дни недели, по которым повторяется бронь:
//      ** ДеньНедели - Число - День недели, в который повторяется бронь.
//      ** НомерВхождения - Число - Номер дня недели, в который повторяется бронь.
//
Функция ПравилаПовторения() Экспорт
	
	СтруктураПравилаПовторения = РаботаСРабочимКалендаремСервер.ПолучитьСтруктуруПравилаПовторения();
	ЗаполнитьЗначенияСвойств(СтруктураПравилаПовторения, ЭтотОбъект);
	СтруктураПравилаПовторения.ИсключенияПовторения = ИсключенияПовторения.Выгрузить();
	СтруктураПравилаПовторения.ПовторениеПоДням = ПовторениеПоДням.Выгрузить();
	
	Возврат СтруктураПравилаПовторения;
	
КонецФункции

// Загружает правило повторения в бронь.
//
// Параметры:
//  СтруктураПравилаПовторения - Структура - Структура правила повторения.
//                                           См. РаботаСРабочимКалендаремСервер.ПолучитьСтруктуруПравилаПовторения.
//
Процедура ЗагрузитьПравилоПовторения(СтруктураПравилаПовторения) Экспорт
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураПравилаПовторения);
	ТипЗаписи = СтруктураПравилаПовторения.ТипЗаписиКалендаря;
	ИсключенияПовторения.Загрузить(СтруктураПравилаПовторения.ИсключенияПовторения);
	ПовторениеПоДням.Загрузить(СтруктураПравилаПовторения.ПовторениеПоДням);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ПовторяющаясяБронь") И ЗначениеЗаполнено(ДанныеЗаполнения.ПовторяющаясяБронь)
			И ДанныеЗаполнения.Свойство("ДатаИсключения") И ЗначениеЗаполнено(ДанныеЗаполнения.ДатаИсключения) Тогда
			
			ЗаполнитьЗначенияСвойств(
				ЭтотОбъект,
				ДанныеЗаполнения.ПовторяющаясяБронь,
				"ВесьДень, ДатаНачала, ДатаОкончания, Комментарий, Помещение, Предмет, КоличествоЧеловек, ТехническоеОбеспечение, ХозяйственноеОбеспечение");
			
			ТипЗаписи = Перечисления.ТипЗаписиКалендаря.ЭлементПовторяющегосяСобытия;
			
			ИсходнаяДатаНачала = ДатаНачала;
			ДатаНачала = НачалоДня(ДанныеЗаполнения.ДатаИсключения) + (ИсходнаяДатаНачала - НачалоДня(ИсходнаяДатаНачала));
			ДатаОкончания = НачалоДня(ДанныеЗаполнения.ДатаИсключения) + (ДатаОкончания - НачалоДня(ИсходнаяДатаНачала));
			
		Иначе
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Мероприятия") Тогда
		
		Предмет = ДанныеЗаполнения;
		
		РеквизитыМероприятия = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "ДатаНачала, ДатаОкончания, Помещение");
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыМероприятия);
		Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Бронь для мероприятия %1'"), ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Бронь") Тогда
		
		РеквизитыБрони = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ДанныеЗаполнения,
			"ВесьДень, ДатаНачала, ДатаОкончания, Комментарий, Помещение, Предмет, КоличествоЧеловек, ТехническоеОбеспечение, ХозяйственноеОбеспечение");
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыБрони);
		
		Если ДополнительныеСвойства.Свойство("ПовторяющаясяБронь")
			И ЗначениеЗаполнено(ДополнительныеСвойства.ПовторяющаясяБронь)
			И ДополнительныеСвойства.Свойство("ДатаИсключения")
			И ЗначениеЗаполнено(ДополнительныеСвойства.ДатаИсключения) Тогда
			ТипЗаписи = Перечисления.ТипЗаписиКалендаря.ЭлементПовторяющегосяСобытия;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьДанныеОбИзменении();
	
	Если Не ЗначениеЗаполнено(ДатаНачала) И Не ЗначениеЗаполнено(ДатаОкончания) Тогда
		
		ДатаНачала = РаботаСРабочимКалендаремКлиентСервер.КонецПолучаса(ТекущаяДатаСеанса());
		ДатаОкончания = ДатаНачала + 3600;
		
	КонецЕсли;
	
	РаботаСРабочимКалендаремКлиентСервер.СкорректироватьДатуНачалаИОкончания(ДатаНачала, ДатаОкончания, ВесьДень);
	
	Если Не ЗначениеЗаполнено(Сотрудник) Тогда
		Сотрудник = Сотрудники.ОсновнойСотрудникПользователя(Автор);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ВместимостьПомещения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Помещение, "Вместимость");
	Если ЗначениеЗаполнено(ВместимостьПомещения) Тогда
		Если ЗначениеЗаполнено(КоличествоЧеловек) И КоличествоЧеловек > ВместимостьПомещения Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Количество человек %1 превышает вместимость  помещения %2.'"),
				КоличествоЧеловек, ВместимостьПомещения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки, ЭтотОбъект, "Помещение", , Отказ);
		ИначеЕсли Не ЗначениеЗаполнено(КоличествоЧеловек) Тогда
			ТекстОшибки = НСтр("ru = 'Не указано количество человек.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки, ЭтотОбъект, "КоличествоЧеловек", , Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияДокументооборот.УстановитьДополнительноеСвойствоПредыдущиеЗначенияРеквизитов(ЭтотОбъект);
	
	ЗаполнитьДанныеОбИзменении();
	ЗаполнитьПовторение();
	
	ОбработатьИзменениеБрони();
	
	ПроверитьВводБрониОтветственным();
	ПроверитьКорректностьДат();
	ПроверитьПересечение();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ПовторяющаясяБронь") И ЗначениеЗаполнено(ДополнительныеСвойства.ПовторяющаясяБронь)
		И ДополнительныеСвойства.Свойство("ДатаИсключения") И ЗначениеЗаполнено(ДополнительныеСвойства.ДатаИсключения) Тогда
		
		ЗаблокироватьДанныеДляРедактирования(ДополнительныеСвойства.ПовторяющаясяБронь);
		
		ПовторяющаясяБроньОбъект = ДополнительныеСвойства.ПовторяющаясяБронь.ПолучитьОбъект();
		ПовторяющаясяБроньОбъект.ДобавитьИсключениеПовторения(ДополнительныеСвойства.ДатаИсключения, Ссылка);
		ПовторяющаясяБроньОбъект.Записать();
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.ЭтоНовый Тогда
		
		БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.СозданиеБрони);
		
	ИначеЕсли СостояниеБрони = Перечисления.СостоянияБроней.Отменена
		И СостояниеБрони <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.СостояниеБрони Тогда
		
		АвторБизнесСобытия = ?(ДополнительныеСвойства.Свойство("АвторБизнесСобытия"),
			ДополнительныеСвойства.АвторБизнесСобытия,
			Неопределено);
		ЭтоФоноваяОперация = ДополнительныеСвойства.Свойство("ЭтоФоноваяОперация")
			И ДополнительныеСвойства.ЭтоФоноваяОперация;
		БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(
			Ссылка,
			Справочники.ВидыБизнесСобытий.ОтменаБрони,
			Новый ХранилищеЗначения(ЭтоФоноваяОперация),
			АвторБизнесСобытия);
		
	Иначе
		
		БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ИзменениеБрони);
		
	КонецЕсли;
	
	Если ПометкаУдаления <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.Помещение Тогда
		ПротоколированиеРаботыСотрудников.ЗаписатьПометкуУдаления(Ссылка, ПометкаУдаления);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДатаОтмены = Дата(1, 1, 1);
	ПричинаОтмены = "";
	СостояниеБрони = Перечисления.СостоянияБроней.ПустаяСсылка();
	
	ОчиститьРеквизитыПовторения();
	
	ЗаполнитьДанныеОбИзменении();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьКорректностьДат()
	
	Если ПараметрыСеанса.ЗагрузкаОбработанныхДанныхИзДругойСистемы Тогда
		Возврат;
	КонецЕсли;
	
	Если ДатаНачала >= ДатаОкончания Тогда
		ТекстОшибки = НСтр("ru = 'Дата начала  не может быть меньше даты окончания.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьПересечение()
	
	Если ПометкаУдаления
		Или ПараметрыСеанса.ЗагрузкаОбработанныхДанныхИзДругойСистемы
		Или СостояниеБрони = Перечисления.СостоянияБроней.Отменена Тогда
		Возврат;
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ТерриторииИПомещения");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Ссылка", Помещение);
	Блокировка.Заблокировать();
	
	ДоступноБронирование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Помещение, "ДоступноБронирование");
	Если Не ДоступноБронирование Тогда
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Помещение %1 недоступно для бронирования.'"), Помещение);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если ЕстьПересекающиесяБрони() Тогда
		ТекстОшибки = НСтр("ru = 'Невозможно забронировать, так как на данное время уже введена бронь.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДанныеОбИзменении()
	
	// Данные об изменении заполняются только для новых объектов
	Если Не ЭтоНовый() Или ПараметрыСеанса.ЗагрузкаОбработанныхДанныхИзДругойСистемы Тогда
		Возврат;
	КонецЕсли;
	
	Автор = Сотрудники.ОсновнойСотрудник();
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПовторение()
	
	Если ПараметрыСеанса.ЗагрузкаОбработанныхДанныхИзДругойСистемы Тогда
		Возврат;
	КонецЕсли;
	
	// Установка настроек повторения
	Если ДополнительныеСвойства.Свойство("НастройкиПовторения") Тогда
		
		// Отказ в установке повторения для помеченной на удаление записи
		Если ПометкаУдаления = Истина Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Невозможно настроить повторение для брони, помеченной на удаление.'"));
			Возврат;
		КонецЕсли;
		
		// Отказ в установке повторения для записи, уже являющейся исключением повторения
		Если ТипЗаписи = Перечисления.ТипЗаписиКалендаря.ЭлементПовторяющегосяСобытия Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Невозможно настроить повторение для брони, являющейся исключением повторения.'"));
			Возврат;
		КонецЕсли;
		
		// При смене частоты повторения очищаются все настройки повторения, в том числе и исключения.
		Если ЧастотаПовторения <> ДополнительныеСвойства.НастройкиПовторения.ЧастотаПовторения Тогда
			ОчиститьРеквизитыПовторения();
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДополнительныеСвойства.НастройкиПовторения);
		
		// Проверка заполненности частоты повторения
		Если ЗначениеЗаполнено(ЧастотаПовторения) Тогда
			ТипЗаписи = Перечисления.ТипЗаписиКалендаря.ПовторяющеесяСобытие;
		Иначе
			ОтменитьПовторение();
		КонецЕсли;
		
		// Установка настроек и проверка заполненности, особенная для каждой частоты повторения.
		Если ЧастотаПовторения = Перечисления.ЧастотаПовторения.Еженедельно Тогда
			
			ПовторениеПоДням.Очистить();
			
			Для Каждого ДеньПовтора Из ДополнительныеСвойства.НастройкиПовторения.ПовторениеПоДнямНедели Цикл
				Если ДеньПовтора.Значение Тогда
					НоваяСтрока = ПовторениеПоДням.Добавить();
					НоваяСтрока.ДеньНедели = ДеньПовтора.Ключ;
					НоваяСтрока.НомерВхождения = 0;
				КонецЕсли;
			КонецЦикла;
			
			Если ПовторениеПоДням.Количество() = 0 Тогда
				ОтменитьПовторение();
			КонецЕсли;
			
		ИначеЕсли ЧастотаПовторения = Перечисления.ЧастотаПовторения.Ежемесячно Тогда
			
			ПовторениеПоДням.Очистить();
			
			Если ЗначениеЗаполнено(ДополнительныеСвойства.НастройкиПовторения.ПовторениеПоДнямНеделиВМесяце) Тогда
				НоваяСтрока = ПовторениеПоДням.Добавить();
				ЗаполнитьЗначенияСвойств(
					НоваяСтрока,
					ДополнительныеСвойства.НастройкиПовторения.ПовторениеПоДнямНеделиВМесяце);
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ПовторениеПоДнямМесяца) И ПовторениеПоДням.Количество() = 0 Тогда
				ОтменитьПовторение();
			КонецЕсли;
			
		ИначеЕсли ЧастотаПовторения = Перечисления.ЧастотаПовторения.Ежегодно Тогда
			
			Если Не ЗначениеЗаполнено(ПовторениеПоДнямМесяца) Или Не ЗначениеЗаполнено(ПовторениеПоМесяцам) Тогда
				ОтменитьПовторение();
			КонецЕсли;
			
		КонецЕсли;
		
		// Удаление исключений повторения, не подходящих под новое правило повторения
		СтруктураПравилаПовторения = ПравилаПовторения();
		ИсключенияПовторенияКоличество = ИсключенияПовторения.Количество();
		Для ИндексИсключения = 1 По ИсключенияПовторенияКоличество Цикл
			
			ИсключениеПовторения = ИсключенияПовторения[ИсключенияПовторенияКоличество - ИндексИсключения];
			Если Не РаботаСРабочимКалендаремСервер.ДатаУдовлетворяетПравилуПовторения(
				ИсключениеПовторения.ДатаИсключения, СтруктураПравилаПовторения, Ложь) Тогда
				
				ПометитьНаУдалениеИсключениеПовторения(ИсключениеПовторения);
				ИсключенияПовторения.Удалить(ИсключениеПовторения);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	СкорректироватьДатыПовторения();
	
	// Очистка настроек повторения при удалении повторяющегося события
	Если ТипЗаписи = Перечисления.ТипЗаписиКалендаря.ПовторяющеесяСобытие И ИзмениласьПометкаУдаления() Тогда
		
		ОтменитьПовторение();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьРеквизитыПовторения()
	
	ДатаНачалаПовторения = Дата(1,1,1);
	ДатаОкончанияПовторения = Дата(1,1,1);
	ИнтервалПовторения = 0;
	ПовторениеПоДнямМесяца = 0;
	ПовторениеПоМесяцам = 0;
	ПравилоОкончанияПовторения = Перечисления.ПравилаОкончанияПовторения.ПустаяСсылка();
	ЧастотаПовторения = Перечисления.ЧастотаПовторения.ПустаяСсылка();
	КоличествоПовторов = 0;
	ПовторениеПоДням.Очистить();
	
	ОчиститьИсключенияПовторения();
	
КонецПроцедуры

Процедура ОчиститьИсключенияПовторения()
	
	Для Каждого ИсключениеПовторения Из ИсключенияПовторения Цикл
		
		ПометитьНаУдалениеИсключениеПовторения(ИсключениеПовторения);
		
	КонецЦикла;
	
	ИсключенияПовторения.Очистить();
	
КонецПроцедуры

Процедура ОтменитьПовторение()
	
	ОчиститьРеквизитыПовторения();
	ТипЗаписи = Перечисления.ТипЗаписиКалендаря.Событие;
	
КонецПроцедуры

Процедура ПометитьНаУдалениеИсключениеПовторения(ИсключениеПовторения)
	
	Если ЗначениеЗаполнено(ИсключениеПовторения.ЗаписьИсключения) Тогда
		
		ЗаписьИсключенияОбъект = ИсключениеПовторения.ЗаписьИсключения.ПолучитьОбъект();
		
		Если ЗаписьИсключенияОбъект = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Если ЗаписьИсключенияОбъект.ТипЗаписи = Перечисления.ТипЗаписиКалендаря.ЭлементПовторяющегосяСобытия
			И Не ЗаписьИсключенияОбъект.ПометкаУдаления Тогда
			ЗаписьИсключенияОбъект.Заблокировать();
			ЗаписьИсключенияОбъект.ПометкаУдаления = Истина;
			ЗаписьИсключенияОбъект.Записать();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура РассчитатьДатуОкончанияПовторения()
	
	Если ЗначениеЗаполнено(ДатаОкончанияПовторения) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(КоличествоПовторов) Тогда
		ПравилоОкончанияПовторения = Перечисления.ПравилаОкончанияПовторения.Никогда;
		Возврат;
	КонецЕсли;
	
	СтруктураПравилаПовторения = ПравилаПовторения();
	
	НомерИтерации = 0;
	НомерПовтора = 0;
	ПроверяемаяДата = ДатаНачалаПовторения;
	
	Пока НомерИтерации < 10000 Цикл // Ограничение на слишком большую дату окончания повторения
		
		Если РаботаСРабочимКалендаремСервер.ДатаУдовлетворяетПравилуПовторения(
				ПроверяемаяДата, СтруктураПравилаПовторения) Тогда
			
			НомерИтерации = 0;
			НомерПовтора = НомерПовтора + 1;
			
			Если НомерПовтора = КоличествоПовторов Тогда
				ДатаОкончанияПовторения = ПроверяемаяДата;
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
		ПроверяемаяДата = ПроверяемаяДата + 86400; // 86400 - число секунд в сутках
		НомерИтерации = НомерИтерации + 1;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ИзмениласьПометкаУдаления()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Бронь.ПометкаУдаления
		|ИЗ
		|	Документ.Бронь КАК Бронь
		|ГДЕ
		|	Бронь.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат ПометкаУдаления И НЕ Выборка.ПометкаУдаления;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура ПроверитьВводБрониОтветственным()
	
	Если ПараметрыСеанса.ЗагрузкаОбработанныхДанныхИзДругойСистемы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не БронированиеПомещений.ДоступноБронированиеПомещения(Помещение) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для ввода брони. Обратитесь к ответственному за помещение.'");
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает изменение брони.
//
Процедура ОбработатьИзменениеБрони()
	
	// Для новых объектов контроль изменения не выполняется
	ИзменилосьПомещение =
		Помещение <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.Помещение;
	ИзмениласьДата =
		ДатаНачала <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ДатаНачала
		Или ДатаОкончания <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ДатаОкончания;
	ИзмениласьПометкаУдаления =
		ПометкаУдаления <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ПометкаУдаления;
	ИзменилосьПравилоПовторения =
		ДатаНачалаПовторения <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ДатаНачалаПовторения
		Или ДатаОкончанияПовторения <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ДатаОкончанияПовторения
		Или ИнтервалПовторения <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ИнтервалПовторения
		Или КоличествоПовторов <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.КоличествоПовторов
		Или ПовторениеПоДнямМесяца <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ПовторениеПоДнямМесяца
		Или ПовторениеПоМесяцам <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ПовторениеПоМесяцам
		Или ПравилоОкончанияПовторения <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ПравилоОкончанияПовторения
		Или ТипЗаписи <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ТипЗаписи
		Или ЧастотаПовторения <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ЧастотаПовторения
		Или Не ОбщегоНазначения.КоллекцииИдентичны(
			ПовторениеПоДням.Выгрузить(),
			ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ПовторениеПоДням);
	
	// Помеченные на удаления брони считаются удаленными.
	Если ИзмениласьПометкаУдаления И ПометкаУдаления И СостояниеБрони <> Перечисления.СостоянияБроней.Отменена Тогда
		ОтменитьБронь(НСтр("ru = 'Бронь помечена на удаление'"));
	КонецЕсли;
	
	// При пометке удаления очищается правило повторения - такую очистку не считаем изменением правила.
	Если ИзмениласьПометкаУдаления И ПометкаУдаления И ИзменилосьПравилоПовторения Тогда
		ИзменилосьПравилоПовторения = Ложь;
	КонецЕсли;
	
	// Изменение ключевых данных требуют нового подтверждения брони.
	Если ИзменилосьПомещение Или ИзмениласьДата Или ИзменилосьПравилоПовторения Тогда
		
		Если СостояниеБрони = Перечисления.СостоянияБроней.Отменена Тогда
			
			// Отмененные бронирования невозможно изменить.
			ВызватьИсключение СтрШаблон(
				НСтр("ru = 'Бронь ""%1"" в состоянии ""%2"" невозможно изменить.'"),
				Строка(Ссылка),
				Перечисления.СостоянияБроней.Отменена);
			
		ИначеЕсли ОбщегоНазначенияДокументооборот.ЭтоОбъектЭтогоУзла(Помещение) Тогда
			
			// Бронирование помещений этого узла сразу подтверждены.
			ПодтвердитьБронь();
			
		Иначе
			
			// Бронирование помещений другого узла необходимо подтверждать в другом узле.
			СостояниеБрони = Перечисления.СостоянияБроней.ОжидаетПодтверждения;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОтслеживаемыеРеквизиты = Документы.Бронь.ОтслеживаемыеРеквизиты();
	
	МассивОтслеживаемыеРеквизиты = СтрРазделить(ОтслеживаемыеРеквизиты, ",");
	
	КоличествоЭлементов = МассивОтслеживаемыеРеквизиты.Количество();
	Для Индекс = 1 По КоличествоЭлементов Цикл
		
		ОбратныйИндекс = КоличествоЭлементов - Индекс;
		ЭлементМассива = МассивОтслеживаемыеРеквизиты[ОбратныйИндекс];
		
		ИмяРеквизита = СокрЛП(ЭлементМассива);
		Если ИмяРеквизита <> Метаданные.Документы.Бронь.Реквизиты.СостояниеБрони.Имя Тогда
			Продолжить;
		КонецЕсли;
		
		МассивОтслеживаемыеРеквизиты.Удалить(ОбратныйИндекс);
		
	КонецЦикла;
	ИндексРеквизитаСостояниеБрони = МассивОтслеживаемыеРеквизиты.Найти(Метаданные.Документы.Бронь.Реквизиты.СостояниеБрони.Имя);
	Если ИндексРеквизитаСостояниеБрони <> Неопределено Тогда
		МассивОтслеживаемыеРеквизиты.Удалить(ИндексРеквизитаСостояниеБрони);
	КонецЕсли;
	
	ОтслеживаемыеРеквизиты = СтрСоединить(МассивОтслеживаемыеРеквизиты, ",");
	
	ИзменилисьОтслеживаемыеРеквизиты = ОбщегоНазначенияДокументооборот.ИзменилосьЗначениеРеквизитов(
		ЭтотОбъект,
		ОтслеживаемыеРеквизиты);
	Если ИзменилисьОтслеживаемыеРеквизиты Тогда
		ВерсияВсехДанных = ОбщегоНазначенияДокументооборот.УвеличитьВерсиюДанных(ВерсияВсехДанных);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли