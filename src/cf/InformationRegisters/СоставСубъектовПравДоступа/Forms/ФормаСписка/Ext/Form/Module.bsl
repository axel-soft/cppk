﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершениеЗаполнить", ЭтотОбъект, Список);
	ОбщегоНазначенияДокументооборотКлиент.ПоказатьВопросДаНет(
		ОписаниеОповещения, 
		НСтр("ru = 'Перезаполнение состава субъектов прав доступа может занять продолжительное время.
			|Продолжить?'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗавершениеЗаполнить(Результат, Параметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ТекстПояснения =
		НСтр("ru = 'Выполняется перезаполнение состава субъектов.
			|Пожалуйста, подождите...'");
	Состояние(ТекстПояснения);
	ЗаполнитьНаСервере();
	ТекстПояснения =
		НСтр("ru = 'Состав субъектов заполнен.'");
	Состояние(ТекстПояснения);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьНаСервере()
	
	РегистрыСведений.СоставСубъектовПравДоступа.ОбновитьВсеДанные(Истина);
	
КонецПроцедуры

#КонецОбласти
