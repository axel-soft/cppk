﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОсновнойОбъект", ПараметрКоманды);
	ПараметрыФормы.Вставить("ТолькоВажные", Ложь);
	ПараметрыФормы.Вставить("ТолькоСвязиВОтветНа", Ложь);
	
	ОткрытьФорму(
		"ОбщаяФорма.СвязиОбъекта",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти