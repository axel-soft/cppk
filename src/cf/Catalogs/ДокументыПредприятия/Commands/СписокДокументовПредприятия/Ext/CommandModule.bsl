﻿// @strict-types

#Область ОбработчикиСобытий
	
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УИДЗамера = ОценкаПроизводительностиКлиент.ЗамерВремени(
		"ДокументыПредприятияОткрытиеФормыФормаСпискаСПапками", , Ложь);
	
	ОткрытьФорму(
		"Справочник.ДокументыПредприятия.Форма.ФормаСпискаСПапками",
		,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);
	
КонецПроцедуры

#КонецОбласти