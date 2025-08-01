﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает количество объектов подлежащих обработке.
//
Функция ПереходНаНовуюВерсиюКоличествоОбъектов() Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЕСТЬNULL(КОЛИЧЕСТВО(Таблица.Ключ), 0) КАК Количество
		|ИЗ
		|	РегистрСведений.УдалитьОтметкиРассмотренияСсылочныхДанныхКОД КАК Таблица");
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Количество;
	
КонецФункции

// Выполняет переход на новую версию.
//
Функция ВыполнитьПереходНаНовуюВерсиюОтложенный(РазмерПорции = 1000) Экспорт
	
	РезультатОбработки = Новый Структура("ОбработаноОбъектов, ПроблемныхОбъектов", 0, 0);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	Таблица.Ключ КАК Ключ,
		|	Таблица.Отметка КАК Отметка,
		|	Таблица.ХешСуммаMD5 КАК ХешСуммаMD5,
		|	Таблица.Дата КАК Дата
		|ИЗ
		|	РегистрСведений.УдалитьОтметкиРассмотренияСсылочныхДанныхКОД КАК Таблица");
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1000" , СтрШаблон("ПЕРВЫЕ %1", Формат(РазмерПорции, "ЧГ=0")));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();
		
		Попытка
			ИдентификаторОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Выборка.Ключ));
			ОписаниеКлючаОтметкиВремени = КОДСервер.КлючДанныхВФорматКлючаОтметокВремени(Выборка.Ключ, ИдентификаторОбъекта);
			
			Запись = РегистрыСведений.ОтметкиРассмотренияСсылочныхДанныхКОД.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(Запись, Выборка);
			ЗаполнитьЗначенияСвойств(Запись, ОписаниеКлючаОтметкиВремени);
			Запись.Записать();
			
			СтараяЗапись = СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(СтараяЗапись, Выборка);
			СтараяЗапись.Удалить();
			
			РезультатОбработки.ОбработаноОбъектов = РезультатОбработки.ОбработаноОбъектов + 1;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			РезультатОбработки.ПроблемныхОбъектов = РезультатОбработки.ПроблемныхОбъектов + 1;
			
			ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не удалось перенести данные РС УдалитьОтметкиРассмотренияСсылочныхДанныхКОД
							|по причине:
							|%1'",
					ОбщегоНазначения.КодОсновногоЯзыка()),
				ТекстОшибки);
				
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.РегистрыСведений.УдалитьОтметкиРассмотренияСсылочныхДанныхКОД, ,
				ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Возврат РезультатОбработки;
	
КонецФункции

#КонецОбласти

#КонецЕсли