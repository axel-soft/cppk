﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытийФормы
	
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ТекстПроверкиНомераПоезда = ТТС_ЖурналыТУВызовСервера.ТекстОшибкиПроверкиНомераПоезда(НомерПоезда);
	
	Если ТекстПроверкиНомераПоезда <> "" Тогда
			
		ОбщегоНазначения.СообщитьПользователю(ТекстПроверкиНомераПоезда);
		Отказ = Истина;
			
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
