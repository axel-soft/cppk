﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДокументооборотПраваДоступа.ПриЗаписиРазрезаДоступа(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЧтенииПредставленийНаСервере() Экспорт
	МультиязычностьСервер.ПриЧтенииПредставленийНаСервере(ЭтотОбъект);
КонецПроцедуры

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли