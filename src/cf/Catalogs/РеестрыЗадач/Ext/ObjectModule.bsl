﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипРеестра = Перечисления.ТипыРеестров.ЗадачиПроекта
		И Не ЗначениеЗаполнено(КлючРеестра) Тогда
		
		Наименование = НСтр("ru = 'Задачи без проекта'");
		
	ИначеЕсли ЗначениеЗаполнено(КлючРеестра) Тогда
		
		Наименование = СтрШаблон("%1 %2", ТипРеестра, КлючРеестра);
		
	Иначе
		
		Наименование = Строка(ТипРеестра);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
