﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка
		Или ПараметрыСеанса.ЗагрузкаОбработанныхДанныхИзДругойСистемы Тогда
		Возврат;
	КонецЕсли;
	
	Политика = Константы.ПолитикаУчетаРабочегоВремени.Получить();
	Если Значение Тогда
		Если Политика <> Перечисления.ПолитикиУчетаРабочегоВремени.ИспользоватьЕженедельныеОтчеты
			И Политика <> Перечисления.ПолитикиУчетаРабочегоВремени.ИспользоватьЕжедневныеИЕженедельныеОтчеты Тогда
			ВызватьИсключение 
				НСтр("ru = 'Политика учета рабочего времени не предусматривает ведение еженедельных отчетов.'");
		КонецЕсли;
	Иначе
		Если Политика = Перечисления.ПолитикиУчетаРабочегоВремени.ИспользоватьЕженедельныеОтчеты
			Или Политика = Перечисления.ПолитикиУчетаРабочегоВремени.ИспользоватьЕжедневныеИЕженедельныеОтчеты Тогда
			ВызватьИсключение 
				НСтр("ru = 'Политика учета рабочего времени предусматривает ведение еженедельных отчетов.'");
		КонецЕсли;
	КонецЕсли;
	
	Если Значение Тогда
		Константы.ИспользоватьДокументыУчетаРабочегоВремени.Установить(Истина);
	ИначеЕсли Не Константы.ИспользоватьЕжедневныеОтчеты.Получить() Тогда
		Константы.ИспользоватьДокументыУчетаРабочегоВремени.Установить(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли