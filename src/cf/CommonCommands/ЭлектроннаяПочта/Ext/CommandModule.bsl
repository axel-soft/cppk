﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИмяФормы = "ЖурналДокументов.ЭлектроннаяПочта.ФормаСписка";
#Если МобильныйКлиент Тогда
	ИмяФормы = "ЖурналДокументов.ЭлектроннаяПочта.Форма.МК_ФормаСписка";
#КонецЕсли
	ПараметрыФормы = Новый Структура;
	ОткрытьФорму(
		ИмяФормы,
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		Ложь,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
