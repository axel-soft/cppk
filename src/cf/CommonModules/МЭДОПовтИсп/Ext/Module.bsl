﻿// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Автоматически отправлять квитанции МЭДО. Кэширование получения константы.
// 
// Возвращаемое значение:
//  Произвольный, Булево -  Автоматически отправлять квитанции МЭДО
Функция АвтоматическиОтправлятьКвитанцииМЭДО() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.АвтоматическиОтправлятьКвитанцииМЭДО.Получить();
	
КонецФункции

// Автоматически создавать/отправлять уведомления МЭДО. Кэширование получения константы.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ВариантыАвтосозданияУведомленийМЭДО -
Функция ВариантАвтосозданияУведомленийМЭДО() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.ВариантАвтосозданияУведомленийМЭДО.Получить();
	
КонецФункции

// Время хранения журнала событий. Кэширование получения константы.
// 
// Возвращаемое значение:
//  Число
Функция ВремяХраненияЖурналаСобытий() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.ВремяХраненияЖурналаСобытийМЭДО.Получить();
	
КонецФункции

// Функция - Получает настройки организации для МЭДО.
//
// Параметры:
//  Организация		- ОпределяемыйТип.Организация - Организация, для которой надо получить настройки.
//  СписокНастроек	- Строка,Неопределено - Список настроек через запятую, если не указан, то получить все настройки
// 
// Возвращаемое значение:
//  См. РегистрыСведений.НастройкиОрганизацийМЭДО.НовыйНастройки
Функция НастройкиОрганизации(Знач Организация, СписокНастроек = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Организация = МЭДОПереопределяемый.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ *
		|ИЗ
		|	РегистрСведений.НастройкиОрганизацийМЭДО КАК Настройки
		|ГДЕ
		|	Настройки.Организация = &Организация");
	Если ЗначениеЗаполнено(СписокНастроек) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "*", СписокНастроек);
	КонецЕсли;
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Возврат МЭДОСтруктурыДанных.РезультатЗапросаВСтруктуру(Запрос.Выполнить());
	
КонецФункции

// Нужно создавать автоматически создавать уведомления или нет. Кэширование значений константы
// 
// Возвращаемое значение:
//  Булево - Нужно или нет
Функция НужноСоздаватьУведомления() Экспорт
	
	Вариант = ВариантАвтосозданияУведомленийМЭДО();
	Возврат Вариант = Перечисления.ВариантыАвтосозданияУведомленийМЭДО.Создавать
		Или Вариант = Перечисления.ВариантыАвтосозданияУведомленийМЭДО.СоздаватьИОтправлять;
	
КонецФункции

// Размер порции обработки. Кэширование получения константы.
// 
// Возвращаемое значение:
//  Число - Размер порции обработки
Функция РазмерПорцииОбработки() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	РазмерПорции = Константы.РазмерПорцииОбработкиМЭДО.Получить();
	Если РазмерПорции = 0 Тогда
		РазмерПорции = 50; // по умолчанию.
	КонецЕсли;
	
	Возврат РазмерПорции;
	
КонецФункции

#КонецОбласти
