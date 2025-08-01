﻿// @strict-types


#Область ОбработчикиСобытий


// Обработка команды.
// 
// Параметры:
//  ПараметрКоманды - СправочникСсылка.Сотрудники - Параметр команды
//  ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды - Параметры выполнения команды
//
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ФизическоеЛицо = ФизическоеЛицоСотрудника(ПараметрКоманды);
	РаботаСВнешнимПодписаниемКлиент.СопоставлениеОбъекта(ФизическоеЛицо);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ФизическоеЛицоСотрудника(Сотрудник)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сотрудник, "Владелец");
	
КонецФункции

#КонецОбласти


