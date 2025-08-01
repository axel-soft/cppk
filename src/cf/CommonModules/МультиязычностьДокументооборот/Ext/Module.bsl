﻿#Область ПрограммныйИнтерфейс

// Заменяет в тексте реквизиты сведений об участниках (в т.ч. участников ознакомлений) на соответствующие языку
//
// Параметры:
//  Текст - Строка - Текст запроса
// 
// Возвращаемое значение:
//  Строка
//
Функция ТекстЗапросаСведенийОбУчастникахСУчетомЯзыка(Текст) Экспорт
	
	Если МультиязычностьСервер.ИспользуетсяПервыйДополнительныйЯзык()
		Или МультиязычностьСервер.ИспользуетсяВторойДополнительныйЯзык() Тогда
		
		СуффиксТекущегоЯзыка = МультиязычностьСервер.СуффиксТекущегоЯзыка();
		Текст = СтрЗаменить(Текст,
			"УчастникиОзнакомлений.ПредставлениеФактическогоИсполнителя", 
			"УчастникиОзнакомлений.ПредставлениеФактическогоИсполнителя" + СуффиксТекущегоЯзыка);
		Текст = СтрЗаменить(Текст,
			"УчастникиОзнакомлений.ПредставлениеСотрудникаДляПЭП", 
			"УчастникиОзнакомлений.ПредставлениеСотрудникаДляПЭП" + СуффиксТекущегоЯзыка);
		Текст = СтрЗаменить(Текст,
			"СведенияОбУчастникахДействий.ПредставлениеФактическогоИсполнителя", 
			"СведенияОбУчастникахДействий.ПредставлениеФактическогоИсполнителя" + СуффиксТекущегоЯзыка);
		Текст = СтрЗаменить(Текст,
			"СведенияОбУчастникахДействий.ПредставлениеСотрудникаДляПЭП", 
			"СведенияОбУчастникахДействий.ПредставлениеСотрудникаДляПЭП" + СуффиксТекущегоЯзыка);
		
	КонецЕсли;
	
	Возврат Текст;
	
КонецФункции

// Возвращает суффикс русского языка
// 
// Возвращаемое значение:
//  Строка
//
Функция СуффиксРусскогоЯзыка() Экспорт
	
	КодРусскогоЯзыка = "ru";
	
	ДопЯзык1 = МультиязычностьСервер.КодПервогоДополнительногоЯзыкаИнформационнойБазы();
	ДопЯзык2 = МультиязычностьСервер.КодВторогоДополнительногоЯзыкаИнформационнойБазы();
	
	Если ДопЯзык1 = КодРусскогоЯзыка Тогда
		
		Возврат "Язык1";
		
	ИначеЕсли ДопЯзык2 = КодРусскогоЯзыка Тогда
		
		Возврат "Язык2";
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти