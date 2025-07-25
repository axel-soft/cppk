﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область НастройкиОтчетаПоУмолчанию

//Выполняет заполнение категорий и разделов в зависимости от варианта отчета
//Параметры:КлючВариантаОтчета - Строковое название варианта отчета
//			СписокКатегорий - в список добавляются необходимые категории
//			СписокРазделов - в список добавляются необходимые категории
Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.СовместнаяРабота));

	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.НСИ.Подсистемы.УправлениеБизнесПроцессами));
			
	Если КлючВариантаОтчета = "ТекущиеБизнесПроцессы" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ПроцессыСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		
	ИначеЕсли КлючВариантаОтчета = "ВсеБизнесПроцессы" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ПроцессыСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		
	ИначеЕсли КлючВариантаОтчета = "СтатистикаПоВидамПроцессы" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	ИначеЕсли КлючВариантаОтчета = "ТрудозатратыПроцессов" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ПроцессыСписок);
	
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПланФакт);
		
	ИначеЕсли КлючВариантаОтчета = "ИсполнениеПроцессов" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ПроцессыСписок);

		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
