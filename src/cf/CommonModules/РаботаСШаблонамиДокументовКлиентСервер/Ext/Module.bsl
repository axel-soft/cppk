﻿#Область ПрограммныйИнтерфейс

// Возвращает представление шаблона
//
// Параметры:
//  Шаблон	 - СправочникСсылка.ШаблоныДокументов,СправочникСсылка.ВидыДокументов
//  Тематика - СправочникСсылка.ТематикиДокументов
// 
// Возвращаемое значение:
//  Строка
//
Функция ПредставлениеШаблона(Шаблон, Тематика=Неопределено) Экспорт
	
	Представление = "";
	Если ЗначениеЗаполнено(Тематика) Тогда
		Представление = СокрЛП(Шаблон) + " - " + СокрЛП(Тематика);
	Иначе
		Представление = СокрЛП(Шаблон);
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

// Возвращает представление настроек ручного отражения по входящим ЭДО
//
// Параметры:
//  ДанныеДляПредставления - см. ОтражениеВУчетеДО.НовыеДанныеДляПредставленияНастройкиРучногоОтраженияВУчете
// 
// Возвращаемое значение:
//  Строка
//
Функция ПредставлениеНастроекОтражения(ДанныеДляПредставления) Экспорт
	
	КоличествоШаблонов = ДанныеДляПредставления.КоличествоШаблонов;
	Если КоличествоШаблонов = 0 Тогда
		
		Возврат НСтр("ru='Выбрать шаблоны для ручного создания...'");
		
	ИначеЕсли КоличествоШаблонов = 1 Тогда
		 
		Возврат СтрШаблон(НСтр("ru='Шаблон: %1'"), ПредставлениеШаблона(
			ДанныеДляПредставления.ПервыйШаблон, ДанныеДляПредставления.ПерваяТематика));
		
	Иначе
		
		Возврат СтрШаблон(НСтр("ru='Шаблоны (%1)'"), КоличествоШаблонов);
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти
