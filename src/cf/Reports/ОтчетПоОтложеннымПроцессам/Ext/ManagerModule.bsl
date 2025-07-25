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
	
	Если КлючВариантаОтчета = "ПоВидамПроцессов" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоЗадачамИПроцессам);
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ПроцессыСписок);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
