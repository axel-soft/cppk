﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет участников по умолчанию.
//
Процедура ЗаполнитьУчастниковПоУмолчанию() Экспорт
	
	УчастникиПоУмолчанию = НастройкиДействий.УчастникиПоУмолчанию(ВидДействия);
	
	Участники.Очистить();
	
	Для Каждого УчастникПоУмолчанию Из УчастникиПоУмолчанию Цикл
		
		СтрокаУчастника  = Участники.Добавить();
		СтрокаУчастника.Участник = УчастникПоУмолчанию;
		
	КонецЦикла;
	
	МоментРазыменованияУчастников =
		Перечисления.МоментыРазыменованияУчастниковДействий.ПередВыполнениемДействия;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	НастройкиДействий.ОбработкаЗаполнения(
		ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиДействий.ПередЗаписью(Ссылка, ДополнительныеСвойства, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиДействий.ПриЗаписи(Ссылка, ДополнительныеСвойства, ПометкаУдаления, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли