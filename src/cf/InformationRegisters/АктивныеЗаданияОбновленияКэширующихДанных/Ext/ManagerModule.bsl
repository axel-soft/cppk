﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает всю информацию об активных заданиях обновления.
// 
// Параметры:
//  Долгое - Булево
// 
// Возвращаемое значение:
//  Массив из УникальныйИдентификатор
// 
Функция АктивныеЗаданияОбновления(Долгое) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	АктивныеЗаданияОбновленияКэширующихДанных.УникальныйИдентификаторЗадания
		|ИЗ
		|	РегистрСведений.АктивныеЗаданияОбновленияКэширующихДанных КАК АктивныеЗаданияОбновленияКэширующихДанных
		|ГДЕ
		|	АктивныеЗаданияОбновленияКэширующихДанных.Долгое = &Долгое");
	
	Запрос.УстановитьПараметр("Долгое", Долгое);
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаРезультата = РезультатЗапроса.Выгрузить();
	
	АктивныеЗаданияОбновления = ТаблицаРезультата.ВыгрузитьКолонку("УникальныйИдентификаторЗадания");
	
	Возврат АктивныеЗаданияОбновления;
	
КонецФункции

// Добавляет информацию об активном задании обновления кэширующих данных.
// 
// Параметры:
//  УникальныйИдентификаторЗадания - УникальныйИдентификатор
//  Долгое - Булево
// 
Процедура Добавить(УникальныйИдентификаторЗадания, Долгое) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.УникальныйИдентификаторЗадания.Установить(УникальныйИдентификаторЗадания);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.УникальныйИдентификаторЗадания = УникальныйИдентификаторЗадания;
	НоваяЗапись.Долгое = Долгое;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Удаляет информацию об активном задании обновления кэширующих данных.
// 
// Параметры:
//  УникальныйИдентификаторЗадания - УникальныйИдентификатор.
// 
Процедура Удалить(УникальныйИдентификаторЗадания) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.УникальныйИдентификаторЗадания.Установить(УникальныйИдентификаторЗадания);
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли