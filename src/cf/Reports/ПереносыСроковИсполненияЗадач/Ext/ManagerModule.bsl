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
			
	Если КлючВариантаОтчета = "СкоростьСогласованияПереносаСрока" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	ИначеЕсли КлючВариантаОтчета = "СписокЗаявокНаПереносСрока" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ПроцессыСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		
	ИначеЕсли КлючВариантаОтчета = "СтатистикаЗапросовНаПереносПоПодразделениям" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	ИначеЕсли КлючВариантаОтчета = "СтатистикаЗапросовНаПереносПоСотрудникам" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсполнителям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	ИначеЕсли КлючВариантаОтчета = "СтатистикаПринятыхРешений" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсполнителям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
