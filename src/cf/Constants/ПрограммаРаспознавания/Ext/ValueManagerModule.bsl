﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриЗаписи(Отказ)
	
	Если ЭтотОбъект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиВызовСервера.ОбновитьИспользованиеРаспознаванияПриПомощиCuneiForm();
	РаботаСФайламиВызовСервера.ОбновитьИспользуетсяРаспознаваниеПриПомощиСервиса();
	
КонецПроцедуры

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли