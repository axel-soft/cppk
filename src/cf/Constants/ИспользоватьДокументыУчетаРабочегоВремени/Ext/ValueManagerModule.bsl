﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка
		Или ПараметрыСеанса.ЗагрузкаОбработанныхДанныхИзДругойСистемы Тогда
		Возврат;
	КонецЕсли;
	
	Если Значение Тогда
		Если Не Константы.ИспользоватьЕжедневныеОтчеты.Получить()
			И Не Константы.ИспользоватьЕженедельныеОтчеты.Получить() Тогда
			ВызватьИсключение 
				НСтр("ru = 'Не установлено использование хотя бы одного вида документов учета рабочего времени.'");
		КонецЕсли;
	Иначе
		Если Константы.ИспользоватьЕжедневныеОтчеты.Получить()
			Или Константы.ИспользоватьЕженедельныеОтчеты.Получить() Тогда
			ВызватьИсключение 
				НСтр("ru = 'Установлено использование хотя бы одного вида документов учета рабочего времени.'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли