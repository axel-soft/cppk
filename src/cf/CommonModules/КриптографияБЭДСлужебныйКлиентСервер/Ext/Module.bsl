﻿
#Область СлужебныеПроцедурыИФункции

// Режимы проверки сертификата криптографии.
// 
// Возвращаемое значение:
//  Структура - Режимы проверки сертификата:
// * ТолькоКвалифицированные - Строка - 
// * ПроверятьКвалифицированные - Строка - 
// * НеПроверятьСертификат - Строка - 
Функция РежимыПроверкиСертификата() Экспорт
	Возврат ИнтеграцияБСПБЭДСлужебныйКлиентСервер.РежимыПроверкиСертификата();
КонецФункции

Функция ТегНачалоСертификата() Экспорт
	
	Возврат "-----BEGIN CERTIFICATE-----";
	
КонецФункции

Функция ТегКонецСертификата() Экспорт
	
	Возврат "-----END CERTIFICATE-----";
	
КонецФункции

Функция НайтиСертификатПодписавшейСтороныРекурсивно(СертификатыПодписи) Экспорт
	
	КоличествоСертификатовПодписи = СертификатыПодписи.Количество();
	Если КоличествоСертификатовПодписи = 1 Тогда
		Возврат СертификатыПодписи[0];
	ИначеЕсли КоличествоСертификатовПодписи = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Пока СертификатыПодписи.Количество() Цикл
		ТекущийСертификат = СертификатыПодписи[0];
		ДочернийСертификат = ДочернийСертификат(СертификатыПодписи, ТекущийСертификат);
		Если ДочернийСертификат = Неопределено Тогда
			Возврат ТекущийСертификат;
		Иначе 
			СертификатыПодписи.Удалить(0);
			Возврат НайтиСертификатПодписавшейСтороныРекурсивно(СертификатыПодписи);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции 

Функция ДочернийСертификат(МассивСертификатов, ТекущийСертификат) 
	
	Для каждого Сертификат Из МассивСертификатов Цикл
		Если Сертификат <> ТекущийСертификат И Сертификат.Издатель.CN = ТекущийСертификат.Субъект.CN Тогда
			Возврат Сертификат; 
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

// Получает сертификат в формате CER из сертификата в формате PEM.
// 
// Параметры:
// 	СтрокаPEM - Строка - сертификат в формате PEM.
// Возвращаемое значение:
// 	ДвоичныеДанные
Функция СертификатИзСтрокиPEM(СтрокаPEM) Экспорт
	
	ТегНачало = ТегНачалоСертификата();
	ТегКонец = ТегКонецСертификата();
	Если СтрНайти(СтрокаPEM, ТегНачало) > 0 Тогда
		СтрокаPEM = СтрЗаменить(СтрокаPEM, ТегНачало, "");
		СтрокаPEM = СтрЗаменить(СтрокаPEM, ТегКонец, "");
		СтрокаPEM = СокрЛП(СтрокаPEM);
	КонецЕсли;
	ТекстСертификата = СтрЗаменить(СтрокаPEM, " ", ""); // из-за пробелов получаются пустые двоичные данные
	
	Возврат Base64Значение(ТекстСертификата);
	
КонецФункции

#Область ОбработкаНеисправностей

// Возвращает вид ошибки, описывающий ситуацию, когда сертификатом нельзя подписать документ данного вида
// (в списке "Подписываемые виды документов" нет данного вида документа).
// Возвращаемое значение:
// 	См. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки
Функция ВидОшибкиДляСертификатаНетПодписываемогоВидаДокумента() Экспорт
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "ДляСертификатаНетПодписываемогоВидаДокумента";
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Отсутствует доступный сертификат для подписания документов'");
	ВидОшибки.ОписаниеПроблемы = НСтр("ru = 'Для сертификата в списке ""Подписываемые виды документов"" нет данного вида документа'");
	ВидОшибки.ОписаниеРешения = НСтр("ru = '<a href = ""Проверьте"">Проверьте</a> подписываемые виды документов в сертификате'");
	ВидОшибки.ОбработчикиНажатия.Вставить("Проверьте", "КриптографияБЭДКлиент.ОткрытьСписокОшибокПоСертификатам");
	
	Возврат ВидОшибки;
	
КонецФункции

#КонецОбласти

#Область Сертификаты

// Заполнить в свойствах сертификата ИНН по ИННЮЛ.
// 
// Параметры:
//  Свойства - Структура:
//   * ИНН - Строка
//   * ИННЮЛ - Строка
//
Процедура ЗаполнитьВСвойствахСертификатаИННПоИННЮЛ(Свойства) Экспорт
	
	ИНН = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Свойства, "ИННЮЛ", "");
	Если Не ЗначениеЗаполнено(ИНН) Тогда
		ИНН = Свойства.ИНН;
	КонецЕсли;
	
	// Удаляем незначащие символы, если это ИНН юридического лица
	Если СтрДлина(ИНН) = 12 И Лев(ИНН, 2) = "00" Тогда
		ИНН = Прав(ИНН, 10);
	КонецЕсли;
	
	Свойства.ИНН = ИНН;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти