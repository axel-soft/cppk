﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает результат голосования для пользователя по предмету.
Процедура УстановитьВариантОтветаПользователя(Сообщение, ВариантОтвета, Знач Пользователь = Неопределено) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Пользователь = Неопределено Тогда
		Пользователь = СотрудникиВызовСервера.ОсновнойСотрудникПользователя(ПользователиКлиентСервер.ТекущийПользователь());
	КонецЕсли;
	
	Запись = РегистрыСведений.СведенияОГолосовании.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Сообщение = Сообщение;
	Запись.Прочитать();
	
	Запись.Пользователь = Пользователь;
	Запись.Сообщение = Сообщение;
	Запись.ВариантОтвета = ВариантОтвета;
	Запись.Записать(Истина);
	
КонецПроцедуры

// Очищает результаты голосования по предмету у всех пользователей.
Процедура УбратьСведенияОГолосовании(Сообщение) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.СведенияОГолосовании.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Сообщение.Установить(Сообщение);
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Процедура очищает результата голосования по предмету у пользователя.
Процедура ОтменитьГолосПользователя(Сообщение, Знач Пользователь = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Пользователь = Неопределено Тогда
		Пользователь = СотрудникиВызовСервера.ОсновнойСотрудникПользователя(ПользователиКлиентСервер.ТекущийПользователь());
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.СведенияОГолосовании.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Сообщение.Установить(Сообщение);
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Возвращает признак Прочтен для объекта у Пользователя (ТекущегоПользователя).
Функция ПолучитьВариантОтветаПользователя(Сообщение, Знач Пользователь = Неопределено) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Пользователь = Неопределено Тогда
		Пользователь = СотрудникиВызовСервера.ОсновнойСотрудникПользователя(ПользователиКлиентСервер.ТекущийПользователь());
	КонецЕсли;
	
	Запись = РегистрыСведений.СведенияОГолосовании.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Сообщение = Сообщение;
	Запись.Прочитать();
	
	Если Не Запись.Выбран() Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат Запись.ВариантОтвета;
	
КонецФункции

#КонецОбласти

#КонецЕсли