﻿// @strict-types

#Область СлужебныеПроцедурыИФункции

// Для переданного объекта возвращает тип ключа отметок времени.
// 
// Параметры:
//	Объект - СправочникСсылка.ИдентификаторыОбъектовМетаданных -
//		   - СправочникСсылка.ИдентификаторыОбъектовРасширений - Объект-источник отметок времени, тип ключа которого
//																 необходимо определить.
//
// Возвращаемое значение:
//	см. ОтметкиВремени.ВидКлючаОбъекта.
//
Функция ВидКлючаОбъекта(Объект) Экспорт
	
	Возврат ОтметкиВремени.ВидКлючаОбъекта(Объект);
	
КонецФункции

// Возвращает имя поля ключа объекта.
//
// Параметры:
//	ИдентификаторОбъекта - СправочникСсылка.ИдентификаторыОбъектовМетаданных - 
//						 - СправочникСсылка.ИдентификаторыОбъектовРасширений - Объект-источник отметок времени, ключевое
//																			   поле которого необходимо определить.
//
// Возвращаемое значение:
//	см. ОтметкиВремени.ПолеКлючаОбъекта.
//
Функция ПолеКлючаОбъекта(ИдентификаторОбъекта) Экспорт
	
	Возврат ОтметкиВремени.ПолеКлючаОбъекта(ИдентификаторОбъекта);
	
КонецФункции

// Возвращает тип поля ключа объекта.
//
// Параметры:
//	ИдентификаторОбъекта - СправочникСсылка.ИдентификаторыОбъектовМетаданных - 
//						 - СправочникСсылка.ИдентификаторыОбъектовРасширений - Объект-источник отметок времени, тип ключевого
//																			   поля которого необходимо определить.
//
// Возвращаемое значение:
//	ОписаниеТипов - Тип ключа объекта.
//
Функция ТипКлючаОбъекта(ИдентификаторОбъекта) Экспорт
	
	Возврат ОтметкиВремени.ТипКлючаОбъекта(ИдентификаторОбъекта);
	
КонецФункции

// Возвращает менеджер объекта метаданных по его идентификатору.
//
// Параметры:
//	Идентификатор - СправочникСсылка.ИдентификаторыОбъектовМетаданных -
//				  - СправочникСсылка.ИдентификаторыОбъектовРасширений - Идентификатор объекта метаданных.
//
// Возвращаемое значение:
//	СправочникМенеджер
//	ДокументМенеджер
//	БизнесПроцессМенеджер
//	ЗадачаМенеджер
//	ПланВидовХарактеристикМенеджер
//
Функция МенеджерОбъектаПоИдентификатору(Идентификатор) Экспорт
	
	Возврат ОтметкиВремени.МенеджерОбъектаПоИдентификатору(Идентификатор);
	
КонецФункции

// Проверяет, является ли ключ ключом ссылочного типа.
//
// Параметры:
//	ВидКлюча - ПеречислениеСсылка.ВидыКлючейОтметокВремени - Вид ключа отметки времени.
//
// Возвращаемое значение:
//	Булево - Истина, если это ключ ссылочного типа.
//
Функция ЭтоВидКлючаСсылочногоТипа(ВидКлюча) Экспорт
	
	Возврат ОтметкиВремени.ЭтоВидКлючаСсылочногоТипа(ВидКлюча);
	
КонецФункции

#КонецОбласти
