﻿// @strict-types

#Область СлужебныеПроцедурыИФункции

// Проверяет, что при записи из формы процесс будет стартован.
// 
// Параметры:
//  ПараметрыЗаписи - Структура - Параметры записи
// 
// Возвращаемое значение:
//  Булево -  Это старт процесса
//
Функция ЭтоСтартПроцесса(ПараметрыЗаписи) Экспорт
	
	ПараметрыЗаписиПроцесса = НовыеПараметрыЗаписиПроцесса();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаписиПроцесса, ПараметрыЗаписи);
	Возврат ПараметрыЗаписиПроцесса.Старт Или ПараметрыЗаписиПроцесса.СтартПроцессаЧерезОчередьЗаданий
		Или ПараметрыЗаписиПроцесса.ЭтоСтартПроцесса;
		
КонецФункции

// Проверяет, что при записи из формы процесс будет прерван.
// 
// Параметры:
//  ПараметрыЗаписи - Структура - Параметры записи
// 
// Возвращаемое значение:
//  Булево -  Это прерывание процесса
//
Функция ЭтоПрерываниеПроцесса(ПараметрыЗаписи) Экспорт
	
	ПараметрыЗаписиПроцесса = НовыеПараметрыЗаписиПроцесса();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаписиПроцесса, ПараметрыЗаписи);
	Возврат ПараметрыЗаписиПроцесса.ПрерватьПроцессЧерезОчередьЗаданий;
	
КонецФункции

// Проверяет, что при записи из формы процесс будет остановлен.
// 
// Параметры:
//  ПараметрыЗаписи - Структура - Параметры записи
// 
// Возвращаемое значение:
//  Булево -  Это остановка процесса
//
Функция ЭтоОстановкаПроцесса(ПараметрыЗаписи) Экспорт
	
	ПараметрыЗаписиПроцесса = НовыеПараметрыЗаписиПроцесса();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаписиПроцесса, ПараметрыЗаписи);
	Возврат ПараметрыЗаписиПроцесса.ОстановитьПроцессЧерезОчередьЗаданий;
	
КонецФункции

// Проверяет, что при записи из формы процесс будет продолжен.
// 
// Параметры:
//  ПараметрыЗаписи - Структура - Параметры записи
// 
// Возвращаемое значение:
//  Булево -  Это продолжение процесса
//
Функция ЭтоПродолжениеПроцесса(ПараметрыЗаписи) Экспорт
	
	ПараметрыЗаписиПроцесса = НовыеПараметрыЗаписиПроцесса();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаписиПроцесса, ПараметрыЗаписи);
	Возврат ПараметрыЗаписиПроцесса.ПродолжитьПроцессЧерезОчередьЗаданий;
	
КонецФункции

// Проверяет, что при записи из формы процесс будет изменен через очередь заданий.
// 
// Параметры:
//  ПараметрыЗаписи - Структура - Параметры записи
// 
// Возвращаемое значение:
//  Булево -  Это продолжение процесса
//
Функция ЭтоИзменениеПроцессаЧерезОчередьЗаданий(ПараметрыЗаписи) Экспорт
	
	ПараметрыЗаписиПроцесса = НовыеПараметрыЗаписиПроцесса();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаписиПроцесса, ПараметрыЗаписи);
	Возврат ПараметрыЗаписиПроцесса.ИзменитьПроцессЧерезОчередьЗаданий 
		Или ПараметрыЗаписиПроцесса.ПрерватьПроцессЧерезОчередьЗаданий
		Или ПараметрыЗаписиПроцесса.ОстановитьПроцессЧерезОчередьЗаданий
		Или ПараметрыЗаписиПроцесса.ПродолжитьПроцессЧерезОчередьЗаданий;
		
КонецФункции

// Проверяет, что выполняется задача обрабатывающего результат.
// 
// Параметры:
//  ПараметрыЗаписи - Структура - Параметры записи
// 
// Возвращаемое значение:
//  Булево -  Это выполнение задачи обрабатывающего результат.
//
Функция ЭтоВыполнениеЗадачиОбрабатывающегоРезультат(ПараметрыЗаписи) Экспорт
	
	ПараметрыЗаписиПроцесса = НовыеПараметрыЗаписиПроцесса();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаписиПроцесса, ПараметрыЗаписи);
	Если ЗначениеЗаполнено(ПараметрыЗаписиПроцесса.ТочкаМаршрута) Тогда
		ТочкаМаршрута = ПараметрыЗаписиПроцесса.ТочкаМаршрута;
		Если ТочкаМаршрута = ПредопределенноеЗначение("БизнесПроцесс.Исполнение.ТочкаМаршрута.Проверить")
			Или ТочкаМаршрута = ПредопределенноеЗначение("БизнесПроцесс.Согласование.ТочкаМаршрута.Ознакомиться")
			Или ТочкаМаршрута = ПредопределенноеЗначение("БизнесПроцесс.Подписание.ТочкаМаршрута.ОбработатьРезультат")
			Или ТочкаМаршрута = ПредопределенноеЗначение("БизнесПроцесс.Утверждение.ТочкаМаршрута.Ознакомиться")
			Или ТочкаМаршрута = ПредопределенноеЗначение("БизнесПроцесс.Регистрация.ТочкаМаршрута.Ознакомиться")
			Тогда
				Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПараметрыЗаписиПроцесса.ЭтоВыполнениеЗадачиОбрабатывающегоРезультат;
	
КонецФункции

// Проверяет в КОД, что данные процесса задачи обрабатывающего результат(по исполнителям) подготовлены.
// 
// Параметры:
//  ПараметрыЗаписи - Структура -
// 
// Возвращаемое значение:
//  Булево - Истина, если данные процесса задачи обрабатывающего результат подготовлены для обработки в КОД
//
Функция ДанныеПроцессаЗадачиОбрабатывающегоРезультатПодготовлены(ПараметрыЗаписи) Экспорт
	ПараметрыЗаписиПроцесса = НовыеПараметрыЗаписиПроцесса();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаписиПроцесса, ПараметрыЗаписи);
	Возврат ПараметрыЗаписиПроцесса.ДанныеПроцессаЗадачиОбрабатывающегоРезультатПодготовлены;
КонецФункции

// Новые параметры записи процесса.
// 
// Возвращаемое значение:
//  Структура - Структура - Новый перечень возможных параметров записи процесса
//  * Старт - Булево - Интерактивный старт
//  * СтартПроцессаЧерезОчередьЗаданий - Булево - 
//  * ЭтоСтартПроцесса - Булево - Интерактивный старт или старт через очередь
//  * ПрерываниеПроцесса - Булево - Интерактивное прерывание
//  * ПрерватьПроцессЧерезОчередьЗаданий - Булево - 
//  * ОстановитьПроцессЧерезОчередьЗаданий - Булево - 
//  * ПродолжитьПроцессЧерезОчередьЗаданий - Булево - 
//  * ИзменитьПроцессЧерезОчередьЗаданий - Булево - простая запись процесса, остановка или прерывание
//  * ЭтоВыполнениеЗадачиОбрабатывающегоРезультат - Булево - 
//  * ТочкаМаршрута - ТочкаМаршрутаБизнесПроцессаСсылка, Неопределено - Точка маршрута бизнес процесса
//	
Функция НовыеПараметрыЗаписиПроцесса()
	
	Структура = Новый Структура;
	
	Структура.Вставить("Старт", Ложь);
	Структура.Вставить("СтартПроцессаЧерезОчередьЗаданий", Ложь);
	Структура.Вставить("ЭтоСтартПроцесса", Ложь);
	Структура.Вставить("ПрерываниеПроцесса", Ложь);
	Структура.Вставить("ПрерватьПроцессЧерезОчередьЗаданий", Ложь);
	Структура.Вставить("ОстановитьПроцессЧерезОчередьЗаданий", Ложь);
	Структура.Вставить("ПродолжитьПроцессЧерезОчередьЗаданий", Ложь);
	Структура.Вставить("ИзменитьПроцессЧерезОчередьЗаданий", Ложь);
	Структура.Вставить("ЭтоВыполнениеЗадачиОбрабатывающегоРезультат", Ложь);
	Структура.Вставить("ТочкаМаршрута", Неопределено);
	Структура.Вставить("ДанныеПроцессаЗадачиОбрабатывающегоРезультатПодготовлены", Ложь);
	
	Возврат Структура;
	
КонецФункции

#КонецОбласти
