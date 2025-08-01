﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Проверяет, завершено ли отложенное обновление.
// 
// Возвращаемое значение:
//  Булево
// 
Функция ОтложенноеОбновлениеЗавершено() Экспорт
	
	БлокирующиеСтатусы = Новый Массив;
	БлокирующиеСтатусы.Добавить(Перечисления.СтатусыОбработчиковОбновления.НеВыполнялся);
	БлокирующиеСтатусы.Добавить(Перечисления.СтатусыОбработчиковОбновления.Выполняется);
	БлокирующиеСтатусы.Добавить(Перечисления.СтатусыОбработчиковОбновления.Приостановлен);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОбработчикиОбновления.ИмяОбработчика
		|ИЗ
		|	РегистрСведений.ОбработчикиОбновления КАК ОбработчикиОбновления
		|ГДЕ
		|	ОбработчикиОбновления.ИмяОбработчика = ""ОбновлениеИнформационнойБазыДокументооборот.ПерейтиНаВерсию_3_0_15_8""
		|	И ОбработчикиОбновления.Статус В (&БлокирующиеСтатусы)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОбработчикиОбновления.ИмяОбработчика
		|ИЗ
		|	РегистрСведений.ОбработчикиОбновления КАК ОбработчикиОбновления
		|ГДЕ
		|	ОбработчикиОбновления.ИмяОбработчика = ""ОбновлениеИнформационнойБазыДокументооборот.ПерейтиНаВерсию_3_0_15_9_РеестрЗадачПоАвторам""
		|	И ОбработчикиОбновления.Статус В (&БлокирующиеСтатусы)");
	
	Запрос.УстановитьПараметр("БлокирующиеСтатусы", БлокирующиеСтатусы);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ОтложенноеОбновлениеЗавершено = РезультатЗапроса.Пустой();
	
	Возврат ОтложенноеОбновлениеЗавершено;
	
КонецФункции

#КонецОбласти

#КонецЕсли