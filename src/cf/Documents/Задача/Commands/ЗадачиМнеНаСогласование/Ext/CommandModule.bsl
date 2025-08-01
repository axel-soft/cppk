﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	КлючевыеОперации = "ЗадачиОткрытиеФормыЗадачиМнеНаСогласование";
	ОценкаПроизводительностиКлиент.ЗамерВремени(КлючевыеОперации);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "ЗадачиМнеНаСогласование");
	
	ОткрытьФорму("Документ.Задача.Форма.Задачи",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыФормы.КлючНазначенияИспользования + Строка(ПараметрыВыполненияКоманды.Уникальность),
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти