﻿
//++AxelSoft Шарапова 30.10.2024 САНФ-029987
&НаСервере
Процедура ЦППК_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Параметры.СрокИсполнения) Тогда
	//++AxelSoft Шарапова 05.05.2024 САНФ-033849
		Если ДатаОтсчета = Дата(1,1,1) Тогда
			ДатаОтсчета = ТекущаяДатаСеанса();
		Иначе
			ДатаОтсчета = Параметры.ДатаОтсчета;		
		КонецЕсли;
	//--AxelSoft Шарапова 05.05.2024 САНФ-033849
		Параметры.СрокИсполнения = ЦППК_ОбщийМодульВызовСервера.ОбновитьСрокПоДаннымГраницыВремениСрокаИсполнения(ДатаОтсчета);
	КонецЕсли;
	
КонецПроцедуры
//--AxelSoft Шарапова 30.10.2024 САНФ-029987
