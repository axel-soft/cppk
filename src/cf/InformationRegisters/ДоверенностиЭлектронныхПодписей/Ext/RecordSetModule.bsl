﻿// @strict-types


#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСЭП.ПриЗаписиДоверенностейЭлектронныхПодписей(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
