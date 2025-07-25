﻿
#Область ПрограммныйИнтерфейс

// Возвращает ключи регистра электронных подписей по идентификаторам подписей.
// 	Если подписи с идентификатором не найдено - ключ примет значение Неопределено
// 
// Параметры:
//  ИдентификаторыПодписей - Массив Из УникальныйИдентификатор
// 
// Возвращаемое значение:
//  Соответствие Из КлючИЗначение:
//    * Ключ - УникальныйИдентификатор
//    * Значение - см. РаботаСЭП.НовыйКлючРегистраЭлектронныхПодписей - Ключ регистра, если подпись была найдена
//               - Неопределено - Если подпись по идентификатору не была найдена
Функция КлючиРегистраПодписейПоИдентификаторамПодписей(ИдентификаторыПодписей) Экспорт
	
	Возврат РаботаСЭП.КлючиРегистраПодписейПоИдентификаторамПодписей(ИдентификаторыПодписей);
	
КонецФункции

Функция ПолучитьДвоичныеДанныеОбъекта(ОбъектСсылка, Версия = Неопределено,
	ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат РаботаСЭП.ПолучитьДвоичныеДанныеОбъекта(ОбъектСсылка, Версия, ДополнительныеПараметры);
	
КонецФункции

Процедура ЗанестиИнформациюОПодписях(ПодписанныеДанные, ИдентификаторФормы = Неопределено) Экспорт
	
	РаботаСЭП.ЗанестиИнформациюОПодписях(ПодписанныеДанные, ИдентификаторФормы);
	
КонецПроцедуры

// Обновляет информацию о статусе проверки подписей в РС ЭлектронныеПодписи
//
// Параметры:
//  ДанныеПодписей  - Массив из Структура - содержит:
//         * УникальныйИдентификатор  - УникальныйИдентификатор - УИД подписи
//         * Объект  - ОпределяемыйТип.ПодписанныйОбъект - Подписанный объект
//         * УстановившийПодпись  - СправочникСсылка.Пользователи - Пользователь, поставивший подпись
//         * ДатаПодписи  - Дата - Дата подписи
//         * ПодписьВерна  - Булево - Указывает, верна ли подпись
//         * ТекстОшибкиПроверкиПодписи  - Строка - Описание ошибки проверки подписи
//         * СертификатДействителен  - Булево - Указывает, действителен ли сертификат подписи
//         * ТекстОшибкиПроверкиСертификата  - Строка - Описание ошибки проверки сертификата
//
Процедура ОбновитьСтатусыПроверкиПодписей(ДанныеПодписей) Экспорт
	
	РаботаСЭП.ОбновитьСтатусыПроверкиПодписей(ДанныеПодписей);
	
КонецПроцедуры

Процедура ОбновитьСтатусПроверкиПодписи(ДанныеПодписи, ДатаПроверки = Неопределено,
	ОбщийСтатусПроверки = Неопределено) Экспорт
	
	РаботаСЭП.ОбновитьСтатусПроверкиПодписи(ДанныеПодписи, ДатаПроверки, ОбщийСтатусПроверки);
	
КонецПроцедуры

Функция ОбъектМожетБытьПодписанЭП(ОбъектСсылка) Экспорт
	
	Возврат РаботаСЭП.ОбъектМожетБытьПодписанЭП(ОбъектСсылка);
	
КонецФункции

// Возвращает данные подписанного объекта
// 
// Параметры:
//  Объект - Любая ссылка - Подписанный объект
// 
// Возвращаемое значение:
//  Структура - Данные подписанного объекта:
// * ПодписанныйОбъект - Ссылка - ссылка на подписанный объект
// * Представление - Строка - представление объекта
Функция ДанныеПодписанногоОбъекта(Знач Объект) Экспорт
	
	ДанныеОбъекта = Новый Структура;
	ДанныеОбъекта.Вставить("ПодписанныйОбъект", Неопределено);
	ДанныеОбъекта.Вставить("Представление", "");
	
	Если ТипЗнч(Объект) = Тип("СправочникСсылка.ДокументыПредприятия") Тогда
		
		ДанныеОбъекта.ПодписанныйОбъект = Объект;
		ДанныеОбъекта.Представление = СтрШаблон(
			НСтр("ru = '%1 (Документ)'"), Объект);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Файлы") Тогда
		
		ДанныеОбъекта.ПодписанныйОбъект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект, "ТекущаяВерсия");
		ДанныеОбъекта.Представление = СтрШаблон(
			НСтр("ru = '%1 (Файл)'"), Объект);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ВерсииФайлов") Тогда
		
		Файл = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект, "Владелец");
		
		ДанныеОбъекта.ПодписанныйОбъект = Объект;
		ДанныеОбъекта.Представление = СтрШаблон(
			НСтр("ru = '%1 (Файл)'"), Файл);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ВизыСогласования") Тогда
		
		ДанныеОбъекта.ПодписанныйОбъект = Объект;
		ДанныеОбъекта.Представление = СтрШаблон(
			НСтр("ru = '%1 (Виза согласования)'"), Объект);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Резолюции") Тогда
		
		ДанныеОбъекта.ПодписанныйОбъект = Объект;
		ДанныеОбъекта.Представление = СтрШаблон(
			НСтр("ru = '%1 (Резолюция)'"), Объект);
		
	КонецЕсли;
	
	Возврат ДанныеОбъекта;
	
КонецФункции

#Область ПроверкаПодписей

Функция ПроверитьЭлектронныеПодписиНаСервере(ДанныеПодписиейОбъектов, ДанныеОбъектов) Экспорт
	
	Возврат РаботаСЭП.ПроверитьПодписиНаСервере(ДанныеПодписиейОбъектов, ДанныеОбъектов);
	
КонецФункции

Функция ДанныеОбъектовДляПроверкиПодписей(ПараметрыПолучения) Экспорт
	
	Возврат РаботаСЭП.ДанныеОбъектовДляПроверкиПодписей(ПараметрыПолучения);
	
КонецФункции

Функция ЗавершитьПроверкуПодписейНаСервере(ДанныеПодписейОбъектов, РезультатыПроверкиПодписей) Экспорт
	
	ДатаПроверки = ТекущаяДатаСеанса();
	
	ДанныеПодписей = ДанныеПодписейДляОбновленияВРегистре(ДанныеПодписейОбъектов, РезультатыПроверкиПодписей);
	РаботаСЭП.ОбновитьСтатусыПроверкиПодписейВРегистре(ДанныеПодписей, ДатаПроверки);
	
	ДанныеДляПроверкиДоверенностей =
		ДанныеДляПроверкиДоверенностей(ДанныеПодписейОбъектов, РезультатыПроверкиПодписей, ДатаПроверки);
	РезультатыПроверкиДоверенностей =
		РаботаСЭП.ПроверитьДоверенностиЭлектронныхПодписей(ДанныеДляПроверкиДоверенностей);
		
	РаботаСЭП.ОбновитьСтатусыПроверкиДоверенностей(
		РезультатыПроверкиДоверенностей.РезультатыПроверкиДоверенностей, ДатаПроверки);
	
	ДанныеПроверок = ДанныеПроверокПодписей(
		ДанныеПодписейОбъектов,
		РезультатыПроверкиПодписей,
		РезультатыПроверкиДоверенностей.РезультатыПроверкиДоверенностей,
		ДатаПроверки);
	Возврат РаботаСЭП.РезультатПроверкиПодписей(ДанныеПроверок);
	
КонецФункции

// Получает сертификаты из подписи используя криптопровайдер на сервере
// 
// Параметры:
//  ПодписиБезСертификатов - Соответствие Из КлючИЗначение:
//    * Ключ - УникальныйИдентификатор - Идентификатор подписи
//    * Значение - Строка - Адрес временного хранилища двоичных данных попдиси
//  ИдентификаторФормы - УникальныйИдентификатор - Идентификатор формы для помещения во временное хранилище
//                                                 двоичных данных сертификата
// 
// Возвращаемое значение:
//  Структура - см РаботаСЭП.ПолучитьСертификатыИзПодписейНаСервере
Функция ПолучитьСертификатыИзПодписейНаСервере(ПодписиБезСертификатов, ИдентификаторФормы = Неопределено) Экспорт
	
	РезультатПолучения = РаботаСЭП.ПолучитьСертификатыИзПодписейНаСервере(ПодписиБезСертификатов, ИдентификаторФормы);
	
	ЗанестиДанныеПолученияСертификатовИзПодписи(РезультатПолучения.ДанныеСертификатовПоПодписям);
	
	Возврат РезультатПолучения;
	
КонецФункции

// Заносит в регистр сведений ЭП данные о сертификатах
// 
// Параметры:
//  ДанныеСертификатовПоПодписям - см. РаботаСЭП.ЗанестиДанныеСертификатовПодписей
//
Процедура ЗанестиДанныеПолученияСертификатовИзПодписи(ДанныеСертификатовПоПодписям) Экспорт
	
	РаботаСЭП.ЗанестиДанныеСертификатовПодписей(ДанныеСертификатовПоПодписям);
	
КонецПроцедуры

Процедура УстановитьСтатусПроверки(Знач Ссылка, Статус) Экспорт
	
	РаботаСЭП.УстановитьСтатусПроверки(Ссылка, Статус);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСМЧД

// Данные для установки доверенности подписи.
// 
// Параметры:
//  ИдентификаторПодписи - УникальныйИдентификатор - Идентификатор подписи
// 
// Возвращаемое значение:
//  Структура - Данные для установки доверенности подписи:
// * МожноУказатьДоверенность - Булево - Можно ли указать доверенность для подписи
// * ДоступныеДоверенностиДляСертификата - Массив из Структура:
//   ** Доверитель - Строка, СправочникСсылка.Организации - Доверитель доверенности
//   ** ИННДоверителя - Строка - ИНН доверителя
//   ** Доверенность - ОпределяемыйТип.МашиночитаемаяДоверенность - Ссылка на доверенность
// * ОписаниеПроблемы - Строка - Если нельзя указать доверенность, то выводит причину отказа.
Функция ДанныеДляУстановкиДоверенностиПодписи(ИдентификаторПодписи) Экспорт
	
	ДанныеДляУстановкиДоверенности = Новый Структура;
	ДанныеДляУстановкиДоверенности.Вставить("МожноУказатьДоверенность", Ложь);
	ДанныеДляУстановкиДоверенности.Вставить("ДоступныеДоверенностиДляСертификата", Новый Массив);
	ДанныеДляУстановкиДоверенности.Вставить("ОписаниеПроблемы", "");
	
	Если Не РаботаСЭП.ДоступноУказаниеДоверенностиПодписи(ИдентификаторПодписи) Тогда
		ДанныеДляУстановкиДоверенности.ОписаниеПроблемы =
			НСтр("ru = 'Нет прав на указание доверенности для этой ЭП. Указать доверенность может только администратор и пользователь, установивший подпись.'");
		Возврат ДанныеДляУстановкиДоверенности;
	КонецЕсли;
	
	Идентификаторы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИдентификаторПодписи);
	ПодписиПоИдентификаторам = РаботаСЭП.УстановленныеПодписиПоИдентификаторам(Идентификаторы);
	СвойстваПодписи = ПодписиПоИдентификаторам[ИдентификаторПодписи];
	
	Если ТипЗнч(СвойстваПодписи) <> Тип("Структура") Тогда
		ДанныеДляУстановкиДоверенности.ОписаниеПроблемы =
			НСтр("ru = 'Не найдена запись электронной подписи'");
		Возврат ДанныеДляУстановкиДоверенности;
	КонецЕсли;
	
	Сертификат = Неопределено;
	СвойстваПодписи.Свойство("Сертификат", Сертификат);
	
	Если ТипЗнч(Сертификат) <> Тип("ДвоичныеДанные") Тогда
		ДанныеДляУстановкиДоверенности.ОписаниеПроблемы =
			НСтр("ru = 'Не удалось получить сертификат из электронной подписи'");
		Возврат ДанныеДляУстановкиДоверенности;
	КонецЕсли;
	
	СертификатКриптографии = Новый СертификатКриптографии(Сертификат);
	
	Если Не РаботаСЭП.СертификатуНужнаДоверенность(СертификатКриптографии) Тогда
		ДанныеДляУстановкиДоверенности.ОписаниеПроблемы =
			НСтр("ru = 'Подпись установлена сертификатом, который не требует доверенности (от имени юридического лица или ИП)'");
		Возврат ДанныеДляУстановкиДоверенности;
	КонецЕсли;
	
	ДанныеДляУстановкиДоверенности.ДоступныеДоверенностиДляСертификата =
		ДоступныеДоверенностиДляСертификата(СертификатКриптографии);
	
	Если ДанныеДляУстановкиДоверенности.ДоступныеДоверенностиДляСертификата.Количество() = 0 Тогда
		ДанныеДляУстановкиДоверенности.ОписаниеПроблемы =
			НСтр("ru = 'В информационной базе нет подходящих доверенностей'");
		Возврат ДанныеДляУстановкиДоверенности;
	КонецЕсли;
	
	ДанныеДляУстановкиДоверенности.МожноУказатьДоверенность = Истина;
	Возврат ДанныеДляУстановкиДоверенности;
	
КонецФункции

Процедура УстановитьДоверенностьДляЭлектроннойПодписи(ИдентификаторПодписи, Доверенность) Экспорт
	
	Если Не ЗначениеЗаполнено(Доверенность) Тогда
		РаботаСЭП.УдалитьЗаписьОДоверенностиЭП(ИдентификаторПодписи);
		Возврат;
	КонецЕсли;
	
	Идентификаторы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИдентификаторПодписи);
	ПодписиПоИдентификаторам = РаботаСЭП.УстановленныеПодписиПоИдентификаторам(Идентификаторы);
	СвойстваПодписи = ПодписиПоИдентификаторам[ИдентификаторПодписи];
	
	РаботаСЭП.ЗанестиИнформациюОДоверенностиЭП(ИдентификаторПодписи, Доверенность, СвойстваПодписи);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСУсовершенствованнымиЭП

// Данные подписей для усовершенствования по идентификаторам.
// 
// Параметры:
//  ИдентификаторыПодписей - Массив Из УникальныйИдентификатор
// 
// Возвращаемое значение:
//  см. РаботаСЭП.ДанныеПодписейДляУсовершенствованияПоИдентификаторам
Функция ДанныеПодписейДляУсовершенствованияПоИдентификаторам(ИдентификаторыПодписей) Экспорт
	
	Возврат РаботаСЭП.ДанныеПодписейДляУсовершенствованияПоИдентификаторам(ИдентификаторыПодписей);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроверкаПодписей

Функция ДанныеПодписейДляОбновленияВРегистре(ДанныеПодписейОбъектов, РезультатыПроверкиПодписей)
	
	ДанныеПодписей = Новый Массив;
	
	Для Каждого ЭлементОбъекта Из ДанныеПодписейОбъектов Цикл
		
		ДанныеПодписейОбъекта = ЭлементОбъекта.Значение;
		
		Для Каждого ЭлементПодписи Из ДанныеПодписейОбъекта Цикл
			
			ИдентификаторПодписи = ЭлементПодписи.Ключ;
			ДанныеПодписи = ЭлементПодписи.Значение;
			
			РезультатПроверки = РезультатыПроверкиПодписей[ИдентификаторПодписи];
			Если РезультатПроверки = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ДанныеПодписиКОбновлению = РаботаСЭПКлиентСервер.НовыеДанныеПодписиДляПроверки();
			ЗаполнитьЗначенияСвойств(ДанныеПодписиКОбновлению, ДанныеПодписи);
			ЗаполнитьЗначенияСвойств(ДанныеПодписиКОбновлению, РезультатПроверки);
			
			ДанныеПодписей.Добавить(ДанныеПодписиКОбновлению);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ДанныеПодписей;
	
КонецФункции

Функция ДанныеДляПроверкиДоверенностей(ДанныеПодписейОбъектов, РезультатыПроверкиПодписей, ДатаПроверки)
	
	ДанныеДляПроверки = Новый Массив;
	
	Для Каждого ЭлементОбъекта Из ДанныеПодписейОбъектов Цикл
		
		ДанныеПодписейОбъекта = ЭлементОбъекта.Значение;
		
		Для Каждого ЭлементПодписи Из ДанныеПодписейОбъекта Цикл
			
			ИдентификаторПодписи = ЭлементПодписи.Ключ;
			ДанныеПодписи = ЭлементПодписи.Значение; // см. РаботаСЭПКлиентСервер.НовыеДанныеПодписиДляПроверки
			
			Доверенность = ДанныеПодписи.Доверенность;
			
			Если Не ЗначениеЗаполнено(Доверенность) Тогда
				Продолжить;
			КонецЕсли;
			
			РезультатПроверки = РезультатыПроверкиПодписей[ИдентификаторПодписи];
			Если РезультатПроверки = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ДанныеПоПодписи = РаботаСЭПКлиентСервер.НовыеДанныеДляПроверкиДоверенностиПодписи();
			ДанныеПоПодписи.Доверенность = Доверенность;
			
			ЗаполнитьЗначенияСвойств(ДанныеПоПодписи.ДанныеПодписи, ДанныеПодписи);
			
			ДанныеДляПроверки.Добавить(ДанныеПоПодписи);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ДанныеДляПроверки;
	
КонецФункции

Функция ДанныеПроверокПодписей(ДанныеПодписейОбъектов, РезультатыПроверкиПодписей,
		РезультатыПроверкиДоверенностей, ДатаПроверки)
	
	ДанныеПроверок = Новый Соответствие;
	
	Для Каждого ЭлементОбъекта Из ДанныеПодписейОбъектов Цикл
		
		ДанныеПодписейОбъекта = ЭлементОбъекта.Значение;
		
		Для Каждого ЭлементПодписи Из ДанныеПодписейОбъекта Цикл
			
			ИдентификаторПодписи = ЭлементПодписи.Ключ;
			ДанныеПодписи = ЭлементПодписи.Значение;
			
			РезультатПроверкиПодписи = РезультатыПроверкиПодписей[ИдентификаторПодписи];
			Если РезультатПроверкиПодписи = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			РезультатПроверкиДоверенности = РезультатыПроверкиДоверенностей[ИдентификаторПодписи];
			
			ДанныеПроверки = РаботаСЭП.НовыеДанныеПроверокПодписи();
			ДанныеПроверки.ДанныеДляПроверки = ДанныеПодписи;
			ДанныеПроверки.РезультатПроверкиПодписи = РезультатПроверкиПодписи;
			ДанныеПроверки.РезультатПроверкиДоверенности = РезультатПроверкиДоверенности;
			ДанныеПроверки.ДатаПроверки = ДатаПроверки;
			
			ДанныеПроверок.Вставить(ИдентификаторПодписи, ДанныеПроверки);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ДанныеПроверок;
	
КонецФункции

#КонецОбласти

#Область РаботаСМЧД

Функция ДоступныеДоверенностиДляСертификата(СертификатКриптографии)
	
	ДоступныеДоверенности = Новый Массив;
	
	СвойстваСубъекта = КриптографияБЭД.СвойстваСубъектаСертификата(СертификатКриптографии);
	
	ДанныеПредставителя = РаботаСМЧДДокументооборот.НовыеДанныеПредставителяМЧД();
	ДанныеПредставителя.ИНН = СвойстваСубъекта.ИНН;
	
	ДоверенностиПоПредставителям = РаботаСМЧДДокументооборот.МЧДПоДаннымПредставителей(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеПредставителя));
	
	ВсеМЧД = Новый Массив();
	Для Каждого Элемент Из ДоверенностиПоПредставителям Цикл
		ДоверенностиПоКлючу = Элемент.Значение;
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВсеМЧД, ДоверенностиПоКлючу);
	КонецЦикла;
	ВсеМЧД = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ВсеМЧД);
	
	ДанныеМЧД = РаботаСМЧДДокументооборот.ДанныеМЧД(ВсеМЧД);
	ДанныеДоверителей = РаботаСМЧДДокументооборот.ДанныеДоверителейМЧД(ВсеМЧД);
	
	СтатусМЧДДоступенДляУказания = Новый Соответствие();
	СтатусМЧДДоступенДляУказания[
		Перечисления.СтатусыМашиночитаемойДоверенностиВРеестреФНС.Зарегистрировано] = Истина;
	СтатусМЧДДоступенДляУказания[
		Перечисления.СтатусыМашиночитаемойДоверенностиВРеестреФНС.ДатаНачалаДействияНеНаступила] = Истина;
	СтатусМЧДДоступенДляУказания[
		Перечисления.СтатусыМашиночитаемойДоверенностиВРеестреФНС.ИстекСрокДействия] = Истина;
	СтатусМЧДДоступенДляУказания[
		Перечисления.СтатусыМашиночитаемойДоверенностиВРеестреФНС.ПустаяСсылка()] = Истина;
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	Для Каждого Доверенность Из ВсеМЧД Цикл
		
		ДанныеДоверенности = ДанныеМЧД[Доверенность]; // см. РаботаСМЧДДокументооборот.НовыеДанныеМЧД
		ДоверителиМЧД = ДанныеДоверителей[Доверенность]; // Массив Из см. РаботаСМЧДДокументооборот.НовыеДанныеДоверителяМЧД
		
		ДействуетПоСроку = (ТекущаяДата > ДанныеДоверенности.ДатаВыдачи)
			И (ДанныеДоверенности.ДатаОкончания > ТекущаяДата);
		
		Если ДанныеДоверенности.ПометкаУдаления
			Или Не ДействуетПоСроку
			Или ДанныеДоверенности.Отозвана
			Или СтатусМЧДДоступенДляУказания[ДанныеДоверенности.СтатусВРеестреФНС] <> Истина Тогда
			
			Продолжить;
		КонецЕсли;
		
		Если ДоверителиМЧД.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеДоверенности = НовыеДанныеДоверенностиДляУказания();
		
		ДанныеДоверенности.Доверенность = Доверенность;
		ДанныеДоверенности.ИННДоверителя = ДоверителиМЧД[0].ИНН;
		ДанныеДоверенности.Доверитель = ДоверителиМЧД[0].Представление;
		
		ДоступныеДоверенности.Добавить(ДанныеДоверенности);
		
	КонецЦикла;
	
	Возврат ДоступныеДоверенности;
	
КонецФункции

Функция НовыеДанныеДоверенностиДляУказания()
	
	ДанныеДоверенности = Новый Структура;
	ДанныеДоверенности.Вставить("Доверитель", "");
	ДанныеДоверенности.Вставить("ИННДоверителя", "");
	ДанныеДоверенности.Вставить("Доверенность", Справочники.МЧД003.ПустаяСсылка());
	
	Возврат ДанныеДоверенности;
	
КонецФункции

#КонецОбласти

#КонецОбласти
