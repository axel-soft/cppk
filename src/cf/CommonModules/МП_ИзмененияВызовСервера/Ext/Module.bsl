﻿#Область ПрограммныйИнтерфейс
//Изменяет запись о трудозатрате для дальнейшего удаления в мобильном приложении
// Параметры:
//  Сотрудник - СправочникСсылка.Сотрудники - Сотрудник
//  День - Дата - День для отбора трудозатраты
//  НомерДобавления - Число - НомерДобавления для трудозатраты
//

Процедура ЗафиксироватьУдалениеЗаписиОТрудозатрате(Сотрудник, День, НомерДобавления) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьМобильныеПриложения") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НомерДобавления) Тогда
		Возврат;
	КонецЕсли;
	
	Пользователь = Сотрудники.ЛюбойПользовательСотрудника(Сотрудник);
	
	Если Справочники.ПользователиМобильногоПриложения.ЭтоПользовательМП(Пользователь) Тогда
		
		РегистрыСведений.МП_ИзмененныеТрудозатраты.УдалитьЗаписьОТрудозатрате(Пользователь,
			День,
			НомерДобавления);
	
	КонецЕсли;

КонецПроцедуры

#КонецОбласти