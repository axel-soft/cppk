﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает значения реквизитов из регистра.
//
// Параметры:
//  Документ - СправочникСсылка.ДокументыПредприятия - ссылка на документ, для которого возвращаются реквизиты.
//  Реквизиты - Строка - имена реквизитов, перечисленные через запятую.
//
// Возвращаемое значение:
//  - Структура - значение реквизитов.
//  - Неопределено - если набор записей не создан по документу.
//
Функция ЗначенияРеквизитовДокумента(Документ, Реквизиты) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрШаблон(
		"ВЫБРАТЬ
		|	%1
		|ИЗ
		|	РегистрСведений.ДанныеДокументовПредприятия КАК КешИнформацииОбОбъектах
		|ГДЕ
		|	Документ = &Документ",
		Реквизиты);
	
	Запрос.УстановитьПараметр("Документ", Документ);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Результат = Новый Структура(Реквизиты);
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает значение реквизита из регистра.
//
// Параметры:
//  Документ - СправочникСсылка.ДокументыПредприятия - ссылка на документ, для которого возвращается реквизит.
//  Реквизит - Строка - имя реквизита.
//
// Возвращаемое значение:
//  Произвольный - значение реквизита.
//
Функция ЗначениеРеквизитаДокумента(Документ, Реквизит) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ДанныеДокументовПредприятия.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Документ = Документ;
	МенеджерЗаписи.Прочитать();
	
	Возврат МенеджерЗаписи[Реквизит];
	
КонецФункции

// Записывает значения реквизитов документа в регистр.
//
// Параметры:
//   Документ - СправочникОбъект - документ, чьи реквизиты записываются.
//
Процедура ЗаписатьРеквизитыДокумента(Документ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДатаСортировки = Делопроизводство.ДатаУчетаДокумента(Документ);
	
	КонтрагентыДляСписков = "";
	Если ТипЗнч(Документ.Ссылка) = Тип("СправочникСсылка.ДокументыПредприятия") Тогда
		КонтрагентыДляСписков = Делопроизводство.ПолучитьКонтрагентовДляСписков(
			Документ.Контрагенты.Выгрузить(), "Контрагент", ДатаСортировки);
	КонецЕсли;
	
	РегистрационныйНомерИДата = "";
	Если ЗначениеЗаполнено(Документ.РегистрационныйНомер)
		И ЗначениеЗаполнено(Документ.ДатаРегистрации) Тогда
		РегистрационныйНомерИДата =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 от %2'"),
			СокрЛП(Документ.РегистрационныйНомер),
			Формат(Документ.ДатаРегистрации, "ДЛФ=D"));
	КонецЕсли;
	
	ВидКорреспонденции = Перечисления.ВидыКорреспонденции.ПустаяСсылка();
	ВидДокумента = Документ.ВидДокумента;
	РеквВида = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидДокумента, 
		"ЯвляетсяВходящейКорреспонденцией, ЯвляетсяИсходящейКорреспонденцией, ЯвляетсяКомплектомДокументов");
	
	Если РеквВида.ЯвляетсяВходящейКорреспонденцией = Истина Тогда
		
		ВидКорреспонденции = Перечисления.ВидыКорреспонденции.Входящая;
		
	ИначеЕсли РеквВида.ЯвляетсяИсходящейКорреспонденцией Тогда
		
		ВидКорреспонденции = Перечисления.ВидыКорреспонденции.Исходящая;
		
	КонецЕсли;	
	
	// Запись в регистры ДанныеДокументов	
	НаборЗаписей = РегистрыСведений.ДанныеДокументовПредприятия.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ.Ссылка);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() > 0 Тогда
		ЗаписьРегистра = НаборЗаписей[0];
	Иначе
		ЗаписьРегистра = НаборЗаписей.Добавить();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЗаписьРегистра, Документ);
	ЗаписьРегистра.Документ = Документ.Ссылка;
	ЗаписьРегистра.ДатаСортировки = ДатаСортировки;
	ЗаписьРегистра.РегистрационныйНомерИДата = РегистрационныйНомерИДата;
	ЗаписьРегистра.КонтрагентыДляСписков = КонтрагентыДляСписков;
	
	ЗаписьРегистра.ВидКорреспонденции = ВидКорреспонденции;
	ЗаписьРегистра.ЯвляетсяКомплектомДокументов = РеквВида.ЯвляетсяКомплектомДокументов;      
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
		Если Документ.Стороны.Количество() Тогда
			ЗаписьРегистра["Сторона2"] = Документ.Стороны[0].Сторона;
		КонецЕсли;
	Иначе
		Для Н = 1 По 2 Цикл
			Если Документ.Стороны.Количество() >= Н Тогда
				ЗаписьРегистра["Сторона" + Н] = Документ.Стороны[Н - 1].Сторона;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Записывает отметку о получении оригинала документа в регистр.
//
// Параметры:
//  Документ - ссылка на документ, для которого записывается реквизит.
//  Значение - Булево - значение реквизита.
//
Процедура ЗаписатьОтметкуОПолученииОригиналаДокумента(Документ, Значение) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗначениеСтарое = Неопределено;
	Делопроизводство.ПрочитатьДанныеДокумента(Документ, "ОригиналПолучен", ЗначениеСтарое);
	Если ЗначениеСтарое = Значение Тогда
		Возврат;
	КонецЕсли;	
	
	Делопроизводство.ЗаписатьДанныеДокумента(Документ, "ОригиналПолучен", Значение);
	
	Если Значение = Истина Тогда 
		ОригиналПолучил = Сотрудники.ОсновнойСотрудник();
		ДатаПолученияОригинала = ТекущаяДатаСеанса();
	Иначе 
		ОригиналПолучил = Справочники.Сотрудники.ПустаяСсылка();
		ДатаПолученияОригинала = Неопределено;
	КонецЕсли;
	
	Делопроизводство.ЗаписатьДанныеДокумента(Документ, "ОригиналПолучил", ОригиналПолучил);
	Делопроизводство.ЗаписатьДанныеДокумента(Документ, "ДатаПолученияОригинала", ДатаПолученияОригинала);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли