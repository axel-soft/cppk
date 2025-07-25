﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияДокументооборот.УстановитьДополнительноеСвойствоПредыдущиеЗначенияРеквизитов(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить(
		"ПараметрыОбновленияДанныхКэширующихОбъектов",
		Справочники.ПолныеРоли.ЗначенияПараметровОбновленияДанныхКэширующихОбъектов(ЭтотОбъект));
	
	Если ДополнительныеСвойства.ЭтоНовый Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыВладельца = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, "ПометкаУдаления,
		|ИспользуетсяБезОбъектовАдресации, ИспользуетсяСОбъектамиАдресации,
		|ТипыОсновногоОбъектаАдресации, ТипыДополнительногоОбъектаАдресации");
	
	ОбъектыАдресацииОбязательны = Не РеквизитыВладельца.ИспользуетсяБезОбъектовАдресации;
	
	ОбъектыАдресацииУказаны =
		ОсновнойОбъектАдресации <> Неопределено
		Или ДополнительныйОбъектАдресации <> Неопределено;
		
	Если РеквизитыВладельца.ИспользуетсяСОбъектамиАдресации
			И ЗначениеЗаполнено(РеквизитыВладельца.ТипыОсновногоОбъектаАдресации) Тогда
		
		ТипыОсновногоОбъектаАдресации = РеквизитыВладельца.ТипыОсновногоОбъектаАдресации.ТипЗначения.Типы();
		Если РеквизитыВладельца.ИспользуетсяБезОбъектовАдресации Тогда
			ТипыОсновногоОбъектаАдресации.Добавить(Тип("Неопределено"));
		КонецЕсли;
	Иначе
		ТипыОсновногоОбъектаАдресации = Новый Массив;
		ТипыОсновногоОбъектаАдресации.Добавить(Тип("Неопределено"));
	КонецЕсли;
	
	Если РеквизитыВладельца.ИспользуетсяСОбъектамиАдресации
			И ЗначениеЗаполнено(РеквизитыВладельца.ТипыДополнительногоОбъектаАдресации) Тогда
		
		ТипыДополнительногоОбъектаАдресации = РеквизитыВладельца.ТипыДополнительногоОбъектаАдресации.ТипЗначения.Типы();
		Если РеквизитыВладельца.ИспользуетсяБезОбъектовАдресации Тогда
			ТипыДополнительногоОбъектаАдресации.Добавить(Тип("Неопределено"));
		КонецЕсли;
	Иначе
		ТипыДополнительногоОбъектаАдресации = Новый Массив;
		ТипыДополнительногоОбъектаАдресации.Добавить(Тип("Неопределено"));
	КонецЕсли;
	
	ПометкаУдаления =
		РеквизитыВладельца.ПометкаУдаления
			Или (ОбъектыАдресацииОбязательны И Не ОбъектыАдресацииУказаны)
			Или (ТипыОсновногоОбъектаАдресации.Найти(ТипЗнч(ОсновнойОбъектАдресации)) = Неопределено)
			Или (ТипыДополнительногоОбъектаАдресации.Найти(ТипЗнч(ДополнительныйОбъектАдресации)) = Неопределено);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.ПолныеРоли.ОбновитьДанныеКэширующихОбъектов(
		ЭтотОбъект, ДополнительныеСвойства.ПараметрыОбновленияДанныхКэширующихОбъектов);
	
	Справочники.ФактическиеИсполнители.УстановитьСнятьПометкуУдаленияФактическогоИсполнителя(ЭтотОбъект);
	
	Если ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ПометкаУдаления <> ПометкаУдаления Тогда
		РегистрыСведений.СоставСубъектовПравДоступа.ОбновитьПометкиУдаленияПоПолнойРоли(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
