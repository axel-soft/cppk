﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЧислоЗаметок = РегистрыСведений.ТемыЗаметокДокументооборота.ПолучитьЧислоЗаметок(Ссылка);
	ЧислоЗаметокВсего = РегистрыСведений.ТемыЗаметокДокументооборота.ПолучитьЧислоЗаметок(Ссылка, Истина);
	
КонецПроцедуры

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли