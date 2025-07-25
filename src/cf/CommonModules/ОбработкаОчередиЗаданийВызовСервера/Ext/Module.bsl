﻿///////////////////////////////////////////////////////////////////////////////////////////////
// Модуль содержит код для работы обработки заданий
//

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбновитьHtmlПередОзнакомлением

// Вернет данные
// 
// Параметры:
// 	Действие - ОпределяемыйТип.Действия
// 	
// Возвращаемое значение:
// Структура
//  * Документ - СправочникССылка.ДокументыПредприятия
//  * НомерИтерации -Число
// 	
Функция ДанныеДляЗаданияОбновитьHtmlПередОзнакомлением(Знач Действие) Экспорт
	
	ПроверитьВозможностьОбработкиЗаданий();
	
	Возврат ОбработкаОчередиЗаданийСервер.ДанныеДляЗаданияОбновитьHtmlПередОзнакомлением(Действие);
	
КонецФункции

#КонецОбласти

#Область ЗавершениеОзнакомленияСогласования

// Вернет данные
// 
// Параметры:
// 	СлужебнаяЗадача - ЗадачаСсылка.ЗадачаИсполнителя
// 	
// Возвращаемое значение:
// Структура
//  * Документ - СправочникССылка.ДокументыПредприятия
//  * Действие - ОпределяемыйТип.Действия
// 	
Функция ДанныеДляЗавершениеОзнакомленияСогласования(Знач СлужебнаяЗадача) Экспорт
	
	ПроверитьВозможностьОбработкиЗаданий();
	
	Возврат
		ОбработкаОчередиЗаданийСервер.ДанныеДляЗавершениеОзнакомленияСогласования(СлужебнаяЗадача);
	
КонецФункции

#КонецОбласти

// Вернет ФО ИспользоватьЗадания
// 
// Возвращаемое значение:
// 	Булево - Описание
Функция ИспользоватьЗадания() Экспорт
	
	Возврат ОбработкаОчередиЗаданийСервер.ИспользоватьЗадания();
	
КонецФункции	

// Вернет ФО ИспользоватьЗадания + Константы.ВыполнятьЗаданияНаКлиенте
// 
// Возвращаемое значение:
// 	Булево - Описание
Функция ИспользоватьЗаданияДляКлиента() Экспорт
	
	Возврат ОбработкаОчередиЗаданийСервер.ИспользоватьЗаданияДляКлиента();
	
КонецФункции	

// Меняет ФО ИспользоватьЗадания если нужно
// 
Процедура ИзменитьНастройкуИспользоватьЗаданияЕслиНужно() Экспорт
	
	ОбработкаОчередиЗаданийСервер.ИзменитьНастройкуИспользоватьЗаданияЕслиНужно();
		
КонецПроцедуры	

// Возвращает актуальность задания.
// 
// Параметры:
//  Задание - СправочникСсылка.ОчередьЗаданийДокументооборота,
//            Структура с реквизитами задания (Ссылка, Тип, Родитель, ПредметЗадания)
// 
// Возвращаемое значение:
//  Структура
//   * Актуально - Булево
//   * Пояснение - Строка
//
Функция АктуальностьЗадания(Задание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбработкаОчередиЗаданийСервер.АктуальностьЗадания(Задание);
	
КонецФункции

// Выполняет служебную задачу
// 
// Параметры:
// 	СлужебнаяЗадача  -ЗадачаСсылка.ЗадачаИсполнителя
Процедура ВыполнитьЗадачу(Знач СлужебнаяЗадача) Экспорт
	
	ПроверитьВозможностьОбработкиЗаданий();
	ОбработкаОчередиЗаданийСервер.ВыполнитьЗадачу(СлужебнаяЗадача);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызовет исключение если нет прав
Процедура ПроверитьВозможностьОбработкиЗаданий()
	
	Если Не РольДоступна("ПолныеПрава") И Не РольДоступна("ВыполнениеЗаданийНаКлиенте") Тогда
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти