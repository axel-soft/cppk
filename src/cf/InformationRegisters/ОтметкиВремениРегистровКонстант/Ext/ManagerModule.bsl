﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Удаляет порцию устаревших данных.
// 
// Возвращаемое значение - Булево - Истина, если были найдены устаревшие данные, в противном случае Ложь.
// 
Функция УдалитьПорциюУстаревшихДанных() Экспорт
	
	//если отметки времени еще используем - не чистим.  
	ИспользоватьОтметкиВремени = Константы.ИспользоватьОтметкиВремени.Получить();
	Если ИспользоватьОтметкиВремени Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 10000
		|	ОтметкиВремениРегистровКонстант.Граница КАК Граница,
		|	ОтметкиВремениРегистровКонстант.ИдентификаторКлюча КАК ИдентификаторКлюча,
		|	ОтметкиВремениРегистровКонстант.ТипКлюча КАК ТипКлюча,
		|	ОтметкиВремениРегистровКонстант.Объект КАК Объект
		|ИЗ
		|	РегистрСведений.ОтметкиВремениРегистровКонстант КАК ОтметкиВремениРегистровКонстант
		|
		|УПОРЯДОЧИТЬ ПО
		|	Граница");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл 
		
		НаборЗаписей = СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.Граница.Установить(Выборка.Граница);
		НаборЗаписей.Отбор.ИдентификаторКлюча.Установить(Выборка.ИдентификаторКлюча);
		НаборЗаписей.Отбор.ТипКлюча.Установить(Выборка.ТипКлюча);
		НаборЗаписей.Отбор.Объект.Установить(Выборка.Объект);
		
		НаборЗаписей.Записать(); // стираем
		
	КонецЦикла;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru='Удаление устаревших данных'"), 
		УровеньЖурналаРегистрации.Информация,
		Метаданные.РегистрыСведений.ОтметкиВремениРегистровКонстант,, 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура завершена успешно, обработано %1 записей'"), Выборка.Количество()));
	
	Возврат Выборка.Количество() > 0;
	
КонецФункции

#КонецЕсли