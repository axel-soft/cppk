﻿// @strict-types


#Область ПрограммныйИнтерфейс

// Новые данные для заполнения формализованного документа.
// 
// Возвращаемое значение:
//  Структура:
//    * ИдентификаторФайла - Неопределено - Идентификатор файла заполнять не требуется
//                         - УникальныйИдентификатор
//    * ПодписантДокумента - Неопределено - Подписанта заполнять не требуется
//                         - Структура: см. НовыеДанныеПодписантаДокумента
//    * ДоверенностиДокумента - Неопределено - Доверенности заполнять не требуется
//                            - Массив Из ОпределяемыйТип.МашиночитаемаяДоверенность
//    * УчастникиДокументооборота - Неопределено - Заполнять участников документооборота не требуется
//                                - Структура: см. НовыеДанныеУчастниковДокументооборота
//
Функция НовыеДанныеДляЗаполненияФормализованногоДокумента() Экспорт
	
	ДанныеДляЗаполнения = Новый Структура;
	ДанныеДляЗаполнения.Вставить("ИдентификаторФайла", Неопределено);
	ДанныеДляЗаполнения.Вставить("ПодписантДокумента", Неопределено);
	ДанныеДляЗаполнения.Вставить("ДоверенностиДокумента", Неопределено);
	ДанныеДляЗаполнения.Вставить("УчастникиДокументооборота", Неопределено);
	
	Возврат ДанныеДляЗаполнения;
	
КонецФункции

// Новые данные подписанта для заполнения в формализованном документе
// 
// Возвращаемое значение:
//  Структура:
//    * Организация - СправочникСсылка.Организации - Организация от которой подписываем
//    * Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - Сертификат, которым подписываем
//    * Доверенность - ОпределяемыйТип.МашиночитаемаяДоверенность - Доверенность, с помощью которой подписываем
//
Функция НовыеДанныеПодписантаДокумента() Экспорт
	
	ДанныеПодписанта = Новый Структура;
	ДанныеПодписанта.Вставить("Организация",
		ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
	ДанныеПодписанта.Вставить("Сертификат",
		ПредопределенноеЗначение("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка"));
	ДанныеПодписанта.Вставить("Доверенность",
		ПредопределенноеЗначение("Справочник.МЧД003.ПустаяСсылка"));
	
	Возврат ДанныеПодписанта;
	
КонецФункции

// Новые данные доверенностей для занесения в формализованный документ
// 
// Возвращаемое значение:
//  Массив Из ОпределяемыйТип.МашиночитаемаяДоверенность - Доверенности, которые необходимо записать
//
Функция НовыеДанныеДоверенностейДокумента() Экспорт
	
	Доверенности = Новый Массив();
	Возврат Доверенности;
	
КонецФункции

// Новые данные участников документооборота.
// 
// Возвращаемое значение:
//  Структура:
//    * ИдентификаторОтправителя - Строка - Идентификатор ЭДО отправителя документа
//    * ИдентификаторПолучателя - Строка - Идентификатор ЭДО получателя документа
//    * Оператор - Структура - Данные оператора ЭДО:
//      ** Наименование - Строка - Наименование оператора ЭДО
//      ** ИНН - Строка - ИНН оператора
//      ** Идентификатор - Строка - Идентификатор оператора ЭДО
//
Функция НовыеДанныеУчастниковДокументооборота() Экспорт
	
	ДанныеУчастников = Новый Структура;
	ДанныеУчастников.Вставить("ИдентификаторОтправителя", "");
	ДанныеУчастников.Вставить("ИдентификаторПолучателя", "");
	
	ДанныеОператора = Новый Структура;
	ДанныеОператора.Вставить("Наименование", "");
	ДанныеОператора.Вставить("ИНН", "");
	ДанныеОператора.Вставить("Идентификатор", "");
	
	ДанныеУчастников.Вставить("Оператор", ДанныеОператора);
	
	Возврат ДанныеУчастников;
	
КонецФункции

#КонецОбласти
