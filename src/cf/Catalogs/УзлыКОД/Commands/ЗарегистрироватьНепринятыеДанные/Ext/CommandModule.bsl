﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Узел", ПараметрКоманды);
	ПараметрыОповещения.Вставить("Источник", ПараметрыВыполненияКоманды.Источник);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Узел", ПараметрКоманды);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаКомандыПослеВыбора",
		ЭтотОбъект,
		ПараметрыОповещения);
		
	ОткрытьФорму("Справочник.УзлыКОД.Форма.ВыборНепринятогоСообщения",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,,
		ПараметрыВыполненияКоманды.Окно,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКомандыПослеВыбора(Результат, ПараметрыОповещения) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыполнения = НачатьРегистрациюВФоне(
		ПараметрыОповещения.Узел,
		Результат,
		ПараметрыОповещения.Источник.УникальныйИдентификатор);
		
	Если ПараметрыВыполнения.Статус = "Ошибка" Тогда
		ПоказатьПредупреждение(, ПараметрыВыполнения.ПодробноеПредставлениеОшибки);
	ИначеЕсли ПараметрыВыполнения.Статус = "Выполняется" Тогда
		ПараметрыВыполнения.Вставить("ВыводитьОкноОжидания", Истина);
		ПараметрыВыполнения.Вставить("ПолучатьРезультат", Истина); 
		Форма = ОткрытьФорму("ОбщаяФорма.ДлительнаяОперация",
			ПараметрыВыполнения, 
			ПараметрыОповещения.Источник);
		Форма.Заголовок = НСтр("ru = 'Регистрация непринятых данных'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НачатьРегистрациюВФоне(Узел, ИмяСообщения, Знач УникальныйИдентификатор)
	
	НаименованиеЗадания = НСтр("ru = 'Регистрация непринятых данных'");
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("Узел", Узел);
	ПараметрыПроцедуры.Вставить("ИмяСообщения", ИмяСообщения);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	
	Результат = ДлительныеОперации.ВыполнитьВФоне(
		"КОДСервер.ВыполнитьФоновуюРегистрациюНепринятыхДанных",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Возврат Результат;

КонецФункции