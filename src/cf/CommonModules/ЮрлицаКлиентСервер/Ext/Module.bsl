﻿///// Юрлица ///////////////////////////////////////////////////////////////////
// Процедуры, связанные с юридическими лицами - и организациями и контрагентами
// вызовы из форм элементов справочников Контрагенты и Организации
//////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// "Похожа" ли строка на ИНН.
// 
// Параметры:
//  СтрокаИНН - Строка - Строка, которую надо проверить
// 
// Возвращаемое значение:
//  Булево - 
Функция ЭтоИНН(СтрокаИНН) Экспорт
	
	Возврат ЗначениеЗаполнено(СтрокаИНН)
		И ТипЗнч(СтрокаИНН) = Тип("Строка")
		И (СтрДлина(СтрокаИНН) = 10 ИЛИ СтрДлина(СтрокаИНН) = 12)
		И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаИНН);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Обновить заголовок декорации-ссылки истории наименований.
// 
// Параметры:
//  Форма		- ФормаКлиентскогоПриложения	 - форма элемента Контрагенты или Организации, переданная из модуля формы
Процедура ОбновитьЗаголовокДекорацииИсторииНаименований(Форма) Экспорт

	#Если Не ВнешнееСоединение Тогда
	
	Форма.Элементы.ДекорацияИсторияНаименований.Заголовок
		= ЗаголовокДекорацииИстория(Форма.ИсторияНаименований.Количество());
	
	#КонецЕсли

КонецПроцедуры

// Обновить заголовок декорации-ссылки истории КПП.
// 
// Параметры:
//  Форма		- ФормаКлиентскогоПриложения	 - форма элемента Контрагенты или Организации, переданная из модуля формы
Процедура ОбновитьЗаголовокДекорацииИсторииКПП(Форма) Экспорт
	
	#Если Не ВнешнееСоединение Тогда
	
	Форма.Элементы.ДекорацияИсторияКПП.Заголовок
		= ЗаголовокДекорацииИстория(Форма.ИсторияКПП.Количество());
	
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗаголовокДекорацииИстория(КоличествоЗаписей)
	
	Если КоличествоЗаписей = 0 Тогда
		Возврат НСтр("ru = 'История'");
	Иначе
		Возврат СтрШаблон(НСтр("ru = 'История (%1)'"), КоличествоЗаписей);
	КонецЕсли;
	
КонецФункции

#КонецОбласти
