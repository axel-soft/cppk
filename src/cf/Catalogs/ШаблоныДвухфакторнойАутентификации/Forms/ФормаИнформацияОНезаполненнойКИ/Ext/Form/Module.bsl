﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Участники.ЗагрузитьЗначения(Параметры.Участники.Выгрузить().ВыгрузитьКолонку("Участник"));
	ВидыКИ.ЗагрузитьЗначения(Параметры.ВидыКИ);
	
	ЗаполнитьТаблицу();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_Сотрудники" Тогда
		ЗаполнитьТаблицу();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицу()
	
	УчастникиСНезаполненнойКИ = Справочники.ШаблоныДвухфакторнойАутентификации.СотрудникиИКонтейнерыСНезаполненнойКИ(
		Участники.ВыгрузитьЗначения(), ВидыКИ.ВыгрузитьЗначения());
	НезаполненнаяКИ.Загрузить(УчастникиСНезаполненнойКИ);
	
КонецПроцедуры

#КонецОбласти