﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обновляет наименование группировки задач.
// 
// Возвращаемое значение:
//  Булево - Наименование обновлено.
// 
Функция ОбновитьНаименование() Экспорт
	
	НаименованиеОбновлено = Ложь;
	
	Если Предопределенный Тогда
		Возврат НаименованиеОбновлено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Автор) И ТипЗнч(Автор) = Тип("СправочникСсылка.Сотрудники")  Тогда
		НовоеНаименование = РаботаСЗадачамиПовтИсп.ПредставлениеУчастника(Автор, Истина);
	ИначеЕсли ЗначениеЗаполнено(Автор) И ТипЗнч(Автор) = Тип("СправочникСсылка.ПолныеРоли")  Тогда
		НовоеНаименование = РаботаСЗадачамиПовтИсп.ПредставлениеУчастника(Автор, Истина);
	ИначеЕсли БезПроекта Тогда
		НовоеНаименование = НСтр("ru = 'Без проекта'");
	ИначеЕсли БезФлага Тогда
		НовоеНаименование = НСтр("ru = 'Без флага'");
	ИначеЕсли ЗначениеЗаполнено(ВидДействия) Тогда
		НовоеНаименование = Строка(ВидДействия);
	ИначеЕсли ЗначениеЗаполнено(ВидЗадачи) Тогда
		НовоеНаименование = Строка(ВидЗадачи);
	ИначеЕсли ЗначениеЗаполнено(ВидПриложения) Тогда
		НовоеНаименование = Строка(ВидПриложения);
	ИначеЕсли ЗначениеЗаполнено(Исполнитель) И ТипЗнч(Исполнитель) = Тип("СправочникСсылка.Сотрудники") Тогда
		НовоеНаименование = РаботаСЗадачамиПовтИсп.ПредставлениеУчастника(Исполнитель, Истина);
	ИначеЕсли ЗначениеЗаполнено(Исполнитель) И ТипЗнч(Исполнитель) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		НовоеНаименование = Строка(Исполнитель);
	ИначеЕсли ЗначениеЗаполнено(Исполнитель) И ТипЗнч(Исполнитель) = Тип("СправочникСсылка.ПолныеРоли") Тогда
		НовоеНаименование = Строка(Исполнитель);
	ИначеЕсли ЗначениеЗаполнено(Проект) И ТипЗнч(Проект) = Тип("СправочникСсылка.Проекты") Тогда
		НовоеНаименование = Строка(Проект);
	ИначеЕсли ЗначениеЗаполнено(ТипПриложения) Тогда
		НовоеНаименование = Строка(ТипПриложения);
	ИначеЕсли ЗначениеЗаполнено(Флаг) Тогда
		НовоеНаименование = Строка(Флаг);
	Иначе
		НовоеНаименование = НСтр("ru = '<Не указан>'");
	КонецЕсли;
	
	Если НовоеНаименование <> Наименование Тогда
		НаименованиеОбновлено = Истина;
		Наименование = НовоеНаименование;
	КонецЕсли;
	
	Возврат НаименованиеОбновлено;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриЧтенииПредставленийНаСервере() Экспорт
	МультиязычностьСервер.ПриЧтенииПредставленийНаСервере(ЭтотОбъект);
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьНаименование();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли