﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Для Каждого ЭлементНастроек Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ЭлементНастроек) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ЭлементНастроек.ПравоеЗначение = Сотрудники.ОсновнойСотрудник();
			ЭлементНастроек.Использование = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	Для Каждого ЭлементНастроек Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ЭлементНастроек) =  Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ЭлементНастроек.ПравоеЗначение = Сотрудники.ОсновнойСотрудник();
			ЭлементНастроек.Использование = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПараметрСрокИстекает = Новый ПараметрКомпоновкиДанных("СрокИстекает");
	Для Каждого ЭлементНастройки Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
			И ЭлементНастройки.Параметр = ПараметрСрокИстекает
			И ЭлементНастройки.Использование = Ложь Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Не включен параметр ""Срок истекает""'"),,
				"Отчет.КомпоновщикНастроек.ПользовательскиеНастройки",, Отказ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти