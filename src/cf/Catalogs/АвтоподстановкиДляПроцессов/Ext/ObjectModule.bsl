﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияДокументооборот.ЭтоЗагрузкаИзУзлаРИБ(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		ТекущаяДатаСеанса = ТекущаяДатаСеанса();
		Если ЭтоНовый() Или Не ЗначениеЗаполнено(ДатаСоздания) Тогда
			ДатаСоздания = ТекущаяДатаСеанса;
		КонецЕсли;
		ДатаИзменения = ТекущаяДатаСеанса;
	КонецЕсли;
	
	// Обновление адресной книги.
	ДополнительныеСвойства.Вставить(
		"ПараметрыОбновленияАдреснойКниги",
		Справочники.АвтоподстановкиДляПроцессов.ЗначенияПараметровОбновленияАдреснойКнигиПоОбъекту(ЭтотОбъект));
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Обновление адресной книги.
	Справочники.АвтоподстановкиДляПроцессов.ОбновитьАдреснуюКнигу(
		ЭтотОбъект, ДополнительныеСвойства.ПараметрыОбновленияАдреснойКниги);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ДатаСоздания = Дата("00000000");
	ДатаИзменения = Дата("00000000");
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли