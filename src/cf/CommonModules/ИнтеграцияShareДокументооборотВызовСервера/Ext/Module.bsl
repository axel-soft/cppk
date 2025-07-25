﻿// Интеграция "1С:Share" Вызов сервера (Документооборот)

// @strict-types

#Область ПрограммныйИнтерфейс

// Получает необходимые данные для создания в базе документа предприятия.
// Найденные шаблоны помещаются в параметр ШаблоныДокумента
// 
// Параметры:
//  ОписаниеЭлектронногоДокумента См. ИнтеграцияShare.НовоеОписаниеДанныхЭлектронногоДокумента
//  ШаблоныДокумента - См. ИнтеграцияShareДокументооборотКлиентСервер.ШаблоныДляЗагрузкиДокумента
//  АдресХранилищаРезультата - Строка - Адрес временного хранилища, возвращаемый параметр
//  ИспользоватьПредпросмотрФайлов - Булево - возвращаемый параметр
//
Процедура ПолучитьДанныеДляЗарузкиДокумента(ОписаниеЭлектронногоДокумента, ШаблоныДокумента, АдресХранилищаРезультата,
		ИспользоватьПредпросмотрФайлов) Экспорт
	
	ИнтеграцияShareДокументооборот.ПолучитьДанныеДляЗарузкиДокумента(ОписаниеЭлектронногоДокумента, ШаблоныДокумента,
		АдресХранилищаРезультата, ИспользоватьПредпросмотрФайлов);
	
КонецПроцедуры

// Результат поиска документа по публичной ссылке.
//
// Параметры:
//  СсылкаДляСкачивания - Строка - ссылка для скачивания документа.
//  Отказ - Булево - признак наличия ошибки при выполнении операции.
//  ТекстОшибки - Строка - текст сообщения для отображения пользователю.
//
// Возвращаемое значение:
//  Неопределено
//  См. ИнтеграцияShare.РезультатПоискаДокументаПоПубличнойСсылке
//
Функция РезультатПоискаДокументаПоПубличнойСсылке(Знач СсылкаДляСкачивания, Отказ = Ложь, ТекстОшибки = "") Экспорт
	
	РезультатПоиска = ИнтеграцияShare.РезультатПоискаДокументаПоПубличнойСсылке(СсылкаДляСкачивания, Отказ, ТекстОшибки);
	Если Отказ Или ЗначениеЗаполнено(ТекстОшибки)  Или РезультатПоиска = Неопределено Тогда
		Возврат РезультатПоиска;
	КонецЕсли;
	
	ПараметрыОтраженияВУчете = РезультатПоиска.НастройкиЗагрузки.ПараметрыОтраженияВУчете;
	Если ТипЗнч(РезультатПоиска.НастройкиЗагрузки.ПараметрыОтраженияВУчете) = Тип("ТаблицаЗначений") Тогда
		РезультатПоиска.НастройкиЗагрузки.ПараметрыОтраженияВУчете = ОбщегоНазначения.ТаблицаЗначенийВМассив(
			ПараметрыОтраженияВУчете);
	КонецЕсли;
	
	Возврат РезультатПоиска;
	
КонецФункции	

// Создаёт документ ДО.
// 
// Параметры:
//  ОписаниеДанныхЭлектронногоДокумента - См. ИнтеграцияShare.НовоеОписаниеДанныхЭлектронногоДокумента
//  ШаблоныДокумента - см. ИнтеграцияShareДокументооборотКлиентСервер.ШаблоныДляЗагрузкиДокумента
//  АдресХранилищаРезультата - Строка - Адрес временного хранилища, возвращаемый параметр 
//
Процедура СоздатьДокументДО(ОписаниеДанныхЭлектронногоДокумента, Знач ШаблоныДокумента,
		Знач АдресХранилищаРезультата) Экспорт
	
	ИнтеграцияShareДокументооборот.СоздатьДокументДО(ОписаниеДанныхЭлектронногоДокумента, ШаблоныДокумента,
		АдресХранилищаРезультата);
	
КонецПроцедуры		

// Права на документ.
// 
// Параметры:
//  ДокументДО - ОпределяемыйТип.ДокументДОДляЭДО
// 
// Возвращаемое значение:
//  Структура - см.ИнтеграцияShareДокументооборот.ПраваНаДокумент 
//
Функция ПраваНаДокумент(Знач ДокументДО) Экспорт
	
	Возврат ИнтеграцияShareДокументооборот.ПраваНаДокумент(ДокументДО);
	
КонецФункции	

// Проверяет заполнение реквизитов документа.
// 
// Параметры:
//  ДокументДО - СправочникСсылка.ДокументыПредприятия
//  РеквизитыДокумента - Структура:
//   * Организация - СправочникСсылка.Организации
//   * Контрагент - СправочникСсылка.Контрагенты
//   * ДатаРегистрации - Дата
//   - Неопределено - значение по умолчанию Неопределено
//  НастройкиВидаДокумента - Структура:
//   * ВестиУчетСторон - Булево
//   * ЯвляетсяДоговором - Булево
//   * ЯвляетсяИсходящейКорреспонденцией - Булево
//   * ВестиУчетПоОрганизациям - Булево
//   - Неопределено - значение по умолчанию Неопределено
//  Отказ - Булево - Истина, если найдены ошибки в реквизитах, значение по умолчанию - Ложь
// 
Процедура ПроверитьЗаполнениеРеквизитовДокумента(Знач ДокументДО, РеквизитыДокумента = Неопределено,
		НастройкиВидаДокумента = Неопределено, Отказ = Ложь) Экспорт
	
	ИнтеграцияShareДокументооборот.ПроверитьЗаполнениеРеквизитовДокумента(ДокументДО, РеквизитыДокумента,
		НастройкиВидаДокумента, Отказ);
	
КонецПроцедуры	

#КонецОбласти

