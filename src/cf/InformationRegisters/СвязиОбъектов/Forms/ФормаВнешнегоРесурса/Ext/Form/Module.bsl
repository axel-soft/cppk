﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВнешнийРесурс = Параметры.ВнешнийРесурс;
	Комментарий = Параметры.Комментарий;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВнешнийРесурсОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ЗначениеЗаполнено(ВнешнийРесурс) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Введите адрес внешней ссылки.'"));
	Иначе
		ПерейтиПоНавигационнойСсылке(ВнешнийРесурс);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнийРесурсПриИзменении(Элемент)
	
	Если СтрНачинаетсяС(ВнешнийРесурс, "e1cib") Тогда
		ТекстПредупреждения = 
			НСтр("ru = 'Для объектов в других информационных базах следует использовать внешние ссылки.'");
	Иначе
		ТекстПредупреждения = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если Не ЗначениеЗаполнено(ВнешнийРесурс) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Введите адрес внешней ссылки.'"));
		Возврат;
	КонецЕсли;
	
	Если СтрДлина(ВнешнийРесурс) > 250 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Длина внешней ссылки не может превышать 250 символов.
		|Используйте сервисы сокращения ссылок.'"));
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ВнешнийРесурс", ВнешнийРесурс);
	Результат.Вставить("Комментарий", Комментарий);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти