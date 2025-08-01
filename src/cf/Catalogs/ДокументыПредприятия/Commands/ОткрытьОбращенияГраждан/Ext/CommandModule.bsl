﻿// @strict-types

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УИДЗамера = ОценкаПроизводительностиКлиент.ЗамерВремени(
		"ДокументыПредприятияОткрытиеФормыФормаСпискаСПапками_ОбращенияГраждан", , Ложь);
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", РаботаСОбращениямиКлиентСервер.КлючСписокОбращенийГраждан());
	
	ОткрытьФорму(
		"Справочник.ДокументыПредприятия.Форма.ФормаСпискаСПапками",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);
	
КонецПроцедуры

#КонецОбласти
