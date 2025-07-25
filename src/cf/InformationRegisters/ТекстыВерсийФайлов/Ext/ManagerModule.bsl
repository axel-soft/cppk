﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет запись в регистр.
//
// Параметры:
//  Версия - СправочникСсылка.ВерсииФайлов
//  СтатусИзвлеченияТекста - Перечисление.СтатусыИзвлеченияТекста
//  ИзвлеченныйТекст - ХранилищеЗначения
//  Расширение - Строка
//  ТекстХранилище - ХранилищеЗначения
//  СтатусРаспознаванияТекста - Перечисление.СтатусыРаспознаванияТекста
//
Процедура ДобавитьЗаписьИзвлечения(Версия, СтатусИзвлеченияТекста, ИзвлеченныйТекст, Расширение,
	ТекстХранилище = Неопределено, СтатусРаспознаванияТекста = Неопределено, 
	ОбновлениеДанных = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Версия.Установить(Версия);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда // не было записи
		Запись = НаборЗаписей.Добавить();
		Запись.СтатусРаспознаванияТекста 
			= Перечисления.СтатусыРаспознаванияТекста.НеНужноРаспознавать;
	КонецЕсли;	
	
	Для Каждого Запись Из НаборЗаписей Цикл
		
		Запись.Версия = Версия;
		Запись.Расширение = Расширение;
		
		Запись.СтатусИзвлеченияТекста = СтатусИзвлеченияТекста;
		Запись.ИзвлеченныйТекст = ИзвлеченныйТекст;
		Запись.ДатаИзвлечения = ТекущаяДатаСеанса();
		
		// ТекстХранилище сформируем.
		Если ТекстХранилище = Неопределено Тогда
			Запись.ТекстХранилище = СформироватьРеквизитТекстХранилище(
				Запись.ИзвлеченныйТекст, Запись.РаспознанныйТекст);
			ТекстХранилище = Запись.ТекстХранилище;	
		Иначе
			Запись.ТекстХранилище = ТекстХранилище;		
		КонецЕсли;	
		
	КонецЦикла;
	
	Если ОбновлениеДанных Тогда
		ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(НаборЗаписей);
	Иначе	
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Добавляет запись в регистр.
//
// Параметры:
//  Версия - СправочникСсылка.ВерсииФайлов
//  СтатусРаспознаванияТекста - Перечисление.СтатусыРаспознаванияТекста
//
Процедура ДобавитьСтатусРаспознавания(Версия, СтатусРаспознаванияТекста) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Версия = Версия;
	МенеджерЗаписи.Прочитать();
	
	МенеджерЗаписи.Версия = Версия;
	
	МенеджерЗаписи.СтатусРаспознаванияТекста = СтатусРаспознаванияТекста;
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Возвращает статус распознавания текста версии файла.
//
// Параметры:
//  Версия - СправочникСсылка.ВерсииФайлов
//
// Возвращаемое значение
//  СтатусРаспознаванияТекста - Перечисление.СтатусыРаспознаванияТекста
//
Функция ПрочитатьСтатусРаспознавания(Версия) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.Версия.Установить(Версия);
	
	Набор.Прочитать();
	Если Набор.Выбран() И Набор.Количество() <> 0 Тогда
		Возврат Набор[0].СтатусРаспознаванияТекста;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Добавляет запись в регистр.
//
// Параметры:
//  Версия - СправочникСсылка.ВерсииФайлов
//  СтатусИзвлеченияТекста - Перечисление.СтатусыИзвлеченияТекста
//
Процедура ДобавитьСтатусИзвлечения(Версия, СтатусИзвлеченияТекста) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Версия = Версия;
	МенеджерЗаписи.Прочитать();
	
	МенеджерЗаписи.Версия = Версия;
	
	МенеджерЗаписи.СтатусИзвлеченияТекста = СтатусИзвлеченияТекста;
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Обновляет запись
//
// Параметры:
//  Версия - СправочникСсылка.ВерсииФайлов
//  Расширение - Строка
//
Процедура ДобавитьРасширение(Версия, Расширение, ОбновлениеДанных = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);  
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Версия.Установить(Версия);
	НаборЗаписей.Прочитать();

	Для Каждого Запись Из НаборЗаписей Цикл

		Запись.Версия = Версия;
		Запись.Расширение = Расширение;
	
	КонецЦикла;
	
	Если ОбновлениеДанных Тогда
		ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(НаборЗаписей);
	Иначе	
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Обновляет состояние записи
//
// Параметры:
//  Версия - СправочникСсылка.ВерсииФайлов
//
Процедура ДобавитьСтатусИзвлеченияПоТексту(Версия, ОбновлениеДанных = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Версия.Установить(Версия);
	НаборЗаписей.Прочитать();

	Для Каждого Запись Из НаборЗаписей Цикл
	
		Запись.Версия = Версия;
		
		СтатусИзвлеченияТекста = Запись.СтатусИзвлеченияТекста;
		
		Попытка
			ТекстВнутри = Запись.ТекстХранилище.Получить();
			Если ЗначениеЗаполнено(ТекстВнутри) Тогда  
				СтатусИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.Извлечен;
			Иначе	
				СтатусИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.ИзвлечьНеУдалось;
			КонецЕсли;	
		Исключение   
			// не пишем ошибку.
			СтатусИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.ИзвлечьНеУдалось;
		КонецПопытки;	
		
		Запись.СтатусИзвлеченияТекста = СтатусИзвлеченияТекста;
	
	КонецЦикла;
	
	Если ОбновлениеДанных Тогда
		ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(НаборЗаписей);
	Иначе	
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Добавляет запись в регистр.
//
// Параметры:
//  Версия - СправочникСсылка.ВерсииФайлов
//  СтатусРаспознаванияТекста - Перечисление.СтатусыРаспознаванияТекста
//  РаспознанныйТекст - ХранилищеЗначения
//  ТекстХранилище - возвращаемое значение 
//
Процедура ДобавитьРезультатРаспознавания(Версия, СтатусРаспознаванияТекста, РаспознанныйТекст, ТекстХранилище) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Версия = Версия;
	МенеджерЗаписи.Прочитать();
	
	МенеджерЗаписи.Версия = Версия;
	
	МенеджерЗаписи.СтатусРаспознаванияТекста = СтатусРаспознаванияТекста;
	МенеджерЗаписи.РаспознанныйТекст = РаспознанныйТекст;
	
	МенеджерЗаписи.ТекстХранилище = СформироватьРеквизитТекстХранилище(
		МенеджерЗаписи.ИзвлеченныйТекст, МенеджерЗаписи.РаспознанныйТекст);
		
	ТекстХранилище = МенеджерЗаписи.ТекстХранилище;	
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Получает текст
//
// Параметры:
//  Версия - СправочникСсылка.ВерсииФайлов
//
// Возвращаемое значение
// ХранилищеЗначения
//
Функция ПолучитьТекстХранилище(Версия) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.Версия.Установить(Версия);
	
	Набор.Прочитать();
	Если Набор.Выбран() И Набор.Количество() <> 0 Тогда
		Возврат Набор[0].ТекстХранилище;
	КонецЕсли;
	
	Возврат Новый ХранилищеЗначения("");
	
КонецФункции

// Получает текст
//
// Параметры:
//  Файл - СправочникСсылка.Файлы
//
// Возвращаемое значение
// Строка
//
Процедура ПолучитьИзвлеченныйТекстИСтатус(Версия, ИзвлеченныйТекст, СтатусИзвлеченияТекста) Экспорт
	
	ИзвлеченныйТекст = "";
	СтатусИзвлеченияТекста = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.Версия.Установить(Версия);
	
	Набор.Прочитать();
	Если Набор.Выбран() И Набор.Количество() <> 0 Тогда
		ИзвлеченныйТекст = Набор[0].ИзвлеченныйТекст.Получить();
		СтатусИзвлеченияТекста = Набор[0].СтатусИзвлеченияТекста;
	КонецЕсли;
	
КонецПроцедуры

// Удаляет запись из регистра.
//
// Параметры:
//  Версия - СправочникСсылка.ВерсииФайлов
//
Процедура УдалитьЗапись(Версия) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Версия = Версия;
	МенеджерЗаписи.Удалить();
	
КонецПроцедуры

// Формирует текст версии файла в формате HTML.
// 
// Параметры:
//  ВерсияФайла - СправочникСсылка.ВерсииФайлов.
// 
// Возвращаемое значение:
//  Строка - текст версии файла в формате HTML.
// 
Функция ТекстВерсииФайлаHTML(ВерсияФайла) Экспорт
	
	ТекстВерсииФайлаHTML = "";
	
	ТекстВерсииФайла = ПолучитьТекстХранилище(ВерсияФайла).Получить();
	
	Если Не ЗначениеЗаполнено(ТекстВерсииФайла) Тогда
		Возврат ТекстВерсииФайлаHTML;
	КонецЕсли;
	
	ТекстВерсииФайла = ОбработкаСтрокиXML.УдалитьНедопустимыеСимволыXML(ТекстВерсииФайла);
	
	ТекстВерсииФайлаHTML = РаботаС_HTML.ПолучитьHTMLИзТекста_ДляПросмотраТекста(ТекстВерсииФайла);
	РаботаС_HTML.ДобавитьТегиКСсылкам(ТекстВерсииФайлаHTML);
	
	Возврат ТекстВерсииФайлаHTML;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет синтетический реквизит ТекстХранилище на основе ИзвлеченныйТекст и РаспознанныйТекст.
// 
// Параметры:
//  ИзвлеченныйТекстАргумент - ХранилищеЗначения
//  РаспознанныйТекстАргумент - ХранилищеЗначения
// 
// Возвращаемое значение:
//  ХранилищеЗначения
// 
Функция СформироватьРеквизитТекстХранилище(ИзвлеченныйТекстАргумент, РаспознанныйТекстАргумент)
	
	ИзвлеченныйТекст = ИзвлеченныйТекстАргумент.Получить();
	РаспознанныйТекст = РаспознанныйТекстАргумент.Получить();
	
	ТекстХранилище = Строка(ИзвлеченныйТекст);
	
	Если НЕ ПустаяСтрока(Строка(РаспознанныйТекст)) Тогда
		
		Если НЕ ПустаяСтрока(ТекстХранилище) Тогда
			ТекстХранилище = ТекстХранилище + " " + Символы.ВК + Символы.ПС;
		КонецЕсли;	
		
		ТекстХранилище = ТекстХранилище + Строка(РаспознанныйТекст);
		
	КонецЕсли;	
	
	ТекстХранилище = Новый ХранилищеЗначения(ТекстХранилище);
	Возврат ТекстХранилище;
	
КонецФункции

#КонецОбласти

#КонецЕсли