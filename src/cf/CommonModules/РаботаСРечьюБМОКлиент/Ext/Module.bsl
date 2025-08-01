﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция ПоддерживаетсяРаспознавание() Экспорт
	
#Если Не МобильныйКлиент И Не ТолстыйКлиентУправляемоеПриложение Тогда
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Возврат ОбщегоНазначенияКлиентСервер.СравнитьВерсии(
		СистемнаяИнформация.ВерсияПриложения, "8.3.23.1200") >= 0;
#Иначе
	Возврат Ложь;
#КонецЕсли
	
КонецФункции

Функция ПоддерживаетсяПотоковоеРаспознавание() Экспорт
	
	Если Не ПоддерживаетсяРаспознавание() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат РаботаСРечьюБМОКлиентТолько8323.ПоддерживаетсяПотоковоеРаспознавание();
	
КонецФункции

Процедура НачатьПотоковоеРаспознавание(
		Ключ,
		ОбработчикРаспознавания,
		ПараметрыМодели,
		ИспользованиеВариантаРасположенияРаботыСРечью,
		ПараметрыПотоковогоРаспознавания
	) Экспорт
	
	Если Не ПоддерживаетсяРаспознавание() Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСРечьюБМОКлиентТолько8323.НачатьПотоковоеРаспознавание(
		Ключ,
		ОбработчикРаспознавания,
		ПараметрыМодели,
		ИспользованиеВариантаРасположенияРаботыСРечью,
		ПараметрыПотоковогоРаспознавания
	);
	
КонецПроцедуры

Процедура ОстановитьПотоковоеРаспознавание(Ключ) Экспорт
	
	Если Не ПоддерживаетсяРаспознавание() Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСРечьюБМОКлиентТолько8323.ОстановитьПотоковоеРаспознавание(Ключ);
	
КонецПроцедуры

#КонецОбласти