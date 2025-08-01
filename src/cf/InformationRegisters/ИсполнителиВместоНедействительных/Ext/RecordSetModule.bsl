﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить(
		"ПараметрыОбновленияДанныхКэширующихОбъектов",
		РегистрыСведений.ИсполнителиВместоНедействительных.ЗначенияПараметровОбновленияДанныхКэширующихОбъектов(ЭтотОбъект));
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.ИсполнителиВместоНедействительных.ОбновитьДанныеКэширующихОбъектов(
		ЭтотОбъект, ДополнительныеСвойства.ПараметрыОбновленияДанныхКэширующихОбъектов);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли