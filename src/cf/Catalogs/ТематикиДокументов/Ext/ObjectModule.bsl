﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	Если Не ЭтоНовый() Тогда
		
		ДополнительныеСвойства.Вставить("Предыдущие",
			ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ПометкаУдаления, НеДействует"));
		
	КонецЕсли;
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(ДатаСоздания) Тогда
		Создал = Сотрудники.ОсновнойСотрудник();
		ДатаСоздания = ТекущаяДатаСеанса();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Если ПометкаУдаления <> ДополнительныеСвойства.Предыдущие.ПометкаУдаления Тогда
			ПротоколированиеРаботыСотрудников.ЗаписатьПометкуУдаления(Ссылка, ПометкаУдаления);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ДатаСоздания = ТекущаяДатаСеанса();
	Создал = Сотрудники.ОсновнойСотрудник();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДатаСоздания = ТекущаяДатаСеанса();
	Создал = Сотрудники.ОсновнойСотрудник();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли