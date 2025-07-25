﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	КлючеваяОперация = "КонтрольныеТочкиОткрытиеФормыМоиКонтрольныеТочки";
	ИдентификаторЗамера = ОценкаПроизводительностиКлиент.ЗамерВремени(КлючеваяОперация);
	
	ОткрытьФорму(
		"Справочник.КонтрольныеТочки.Форма.МоиКТ", 
		, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(ИдентификаторЗамера);
	
КонецПроцедуры
