﻿// @strict-types


#Область ПрограммныйИнтерфейс

// Конструктор контекста загрузки настроек
// 
// Возвращаемое значение:
//  Структура -  Новый контекст загрузки настроек:
//    * ДатаНачалаДействия - Дата - 
//    * АдресДанныхФайлаНастроек - Строка - Адрес загружаемого файла во временном хранилище
//    * ВидОбъектаЗагрузки - ОпределяемыйТип.ВидОбъектаСОбработкой
//    * ПрочитанныеДанные - см. НовыеДанныеВыгрузкиНастроекОбработки
//    * Отказ - Булево
//    * Ошибки - Массив Из см. НовыеДанныеОшибкиЗагрузкиНастроекОбработки
//    * СоответствиеВидовОбъектов - Соответствие Из КлючИЗначение:
//      ** Ключ - УникальныйИдентификатор
//      ** Значение - ОпределяемыйТип.ВидОбъектаСОбработкой
//    * ДанныеНастроекОбработкиКСозданию - Соответствие Из КлючИЗначение:
//      ** Ключ - ОпределяемыйТип.ВидОбъектаСОбработкой
//      ** Значение - см. НовыеДанныеДляСозданияНастроекОбработки
//
Функция НовыйКонтекстЗагрузкиНастроек() Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ДатаНачалаДействия", Дата(1, 1, 1));
	Контекст.Вставить("АдресДанныхФайлаНастроек", "");
	Контекст.Вставить("ВидОбъектаЗагрузки", ПредопределенноеЗначение("Справочник.ВидыДокументов.ПустаяСсылка"));
	Контекст.Вставить("ПрочитанныеДанные", НовыеДанныеВыгрузкиНастроекОбработки());
	Контекст.Вставить("Отказ", Ложь);
	Контекст.Вставить("Ошибки", Новый Массив());
	Контекст.Вставить("СоответствиеВидовОбъектов", Новый Соответствие());
	Контекст.Вставить("ДанныеНастроекОбработкиКСозданию", Новый Соответствие());
	
	Возврат Контекст;
	
КонецФункции

// Конструктор контекста выгрузки настроек обработки
// 
// Возвращаемое значение:
//  Структура:
//    * ВыбранныеВидыОбъектов - Массив Из ОпределяемыйТип.ВидОбъектаСОбработкой
//    * ВыбранныеНастройкиОбработки - СправочникСсылка.НастройкиОбработкиВидовОбъектов - 
//    * НастройкиОбработки - Соответствие Из КлючИЗначение:
//       ** Ключ - ОпределяемыйТип.ВидОбъектаСОбработкой
//       ** Значение - см. НовыеДанныеНастроекОбработкиДляВыгрузки
//    * ДоступныеНастройкиОбработки - Соответствие Из КлючИЗначение:
//       ** Ключ - ОпределяемыйТип.ВидОбъектаСОбработкой
//       ** Значение - см. НовыеДанныеДоступныхНастроекОбработкиДляВыгрузки
//    * АдресДвоичныхДанныхВыгрузки - Строка
//
Функция НовыйКонтекстВыгрузкиНастроек() Экспорт
	
	КонтекстВыгрузки = Новый Структура;
	КонтекстВыгрузки.Вставить("ВыбранныеВидыОбъектов", Новый Массив());
	КонтекстВыгрузки.Вставить("ВыбранныеНастройкиОбработки",
		ПредопределенноеЗначение("Справочник.НастройкиОбработкиВидовОбъектов.ПустаяСсылка"));
	КонтекстВыгрузки.Вставить("НастройкиОбработки", Новый Соответствие());
	КонтекстВыгрузки.Вставить("ДоступныеНастройкиОбработки", Новый Соответствие());
	КонтекстВыгрузки.Вставить("АдресДвоичныхДанныхВыгрузки", "");
	
	Возврат КонтекстВыгрузки;
	
КонецФункции

#Область КонструкторыДанныхВыгрузки

// Конструктор данных настроек обработки для выгрузки
// 
// Возвращаемое значение:
//  Структура:
// * НастройкаОбработки - СправочникСсылка.НастройкиОбработкиВидовОбъектов - 
// * ПравилаОбработки - Массив Из СправочникСсылка.ПравилаОбработки
Функция НовыеДанныеНастроекОбработкиДляВыгрузки() Экспорт
	
	ДанныеНастроек = Новый Структура;
	ДанныеНастроек.Вставить("НастройкаОбработки",
		ПредопределенноеЗначение("Справочник.НастройкиОбработкиВидовОбъектов.ПустаяСсылка"));
	ДанныеНастроек.Вставить("ПравилаОбработки", Новый Массив());
	
	Возврат ДанныеНастроек;
	
КонецФункции

// Конструктор доступных для выгрузки настроек обработки по виду объекта
// 
// Возвращаемое значение:
//  Структура:
// * НастройкиОбработки - Массив Из СправочникСсылка.НастройкиОбработкиВидовОбъектов
// * ПравилаОбработки - Массив Из СправочникСсылка.ПравилаОбработки
Функция НовыеДанныеДоступныхНастроекОбработкиДляВыгрузки() Экспорт
	
	ДоступныеНастройки = Новый Структура;
	ДоступныеНастройки.Вставить("НастройкиОбработки", Новый Массив());
	ДоступныеНастройки.Вставить("ПравилаОбработки", Новый Массив());
	
	Возврат ДоступныеНастройки;
	
КонецФункции

#КонецОбласти

#Область КонструкторыДанныхЗагрузки

// Конструктор данных, полученных из выгрузки настроек обработки
// 
// Возвращаемое значение:
//  Структура:
//    * ВерсияПрограммыВыгрузки - Строка - 
//    * ВыгруженныеНастройки - Массив Из см. НовыеДанныеНастроекОбработки
//    * ДанныеИспользуемыхСсылок - Соответствие Из КлючИЗначение:
//       ** Ключ - УникальныйИдентификатор
//       ** Значение - см. НовыеДанныеИспользуемойСсылки
Функция НовыеДанныеВыгрузкиНастроекОбработки() Экспорт
	
	ДанныеВыгрузки = Новый Структура;
	ДанныеВыгрузки.Вставить("ВерсияПрограммыВыгрузки", "");
	ДанныеВыгрузки.Вставить("ВыгруженныеНастройки", Новый Массив());
	ДанныеВыгрузки.Вставить("ДанныеИспользуемыхСсылок", Новый Соответствие());
	
	Возврат ДанныеВыгрузки;
	
КонецФункции

// Конструктор данных настроек обработки
// 
// Возвращаемое значение:
//  Структура:
// * ВидОбъекта - см. НовыеДанныеЗначения1С
// * НастройкиОбрабоки - см. НовыеДанныеЗначения1С
// * ПараметрыСхем - Массив Из см. НовыеДанныеЗначения1С
// * ПравилаОбработки - Массив Из см. НовыеДанныеПравилОбработки
Функция НовыеДанныеНастроекОбработки() Экспорт
	
	ПустоеЗначениеВидаОбъекта = НовыеДанныеЗначения1С();
	ПустоеЗначениеВидаОбъекта.Тип = Тип("СправочникСсылка.ВидыДокументов");
	ПустоеЗначениеВидаОбъекта.Значение = УникальныйИдентификаторПустой();
	
	ПустоеЗначениеНастроек = НовыеДанныеЗначения1С();
	ПустоеЗначениеНастроек.Тип = Тип("СправочникСсылка.НастройкиОбработкиВидовОбъектов");
	ПустоеЗначениеНастроек.Значение = УникальныйИдентификаторПустой();
	
	ДанныеНастроек = Новый Структура;
	ДанныеНастроек.Вставить("ВидОбъекта", ПустоеЗначениеВидаОбъекта);
	ДанныеНастроек.Вставить("НастройкиОбрабоки", ПустоеЗначениеНастроек);
	ДанныеНастроек.Вставить("ПараметрыСхем", Новый Массив());
	ДанныеНастроек.Вставить("ПравилаОбработки", Новый Массив());
	
	Возврат ДанныеНастроек;
	
КонецФункции

// Конструктор данных правил обработки объектов
// 
// Возвращаемое значение:
//  Структура:
// * ПравилоОбработки - см. НовыеДанныеЗначения1С
// * ВидДействия - см. НовыеДанныеЗначения1С
// * Настройка - см. НовыеДанныеЗначения1С
// * НастройкаВключена - см. НовыеДанныеЗначения1С
Функция НовыеДанныеПравилОбработки() Экспорт
	
	ДанныеПравил = Новый Структура;
	
	ПустоеЗначениеПравил = НовыеДанныеЗначения1С();
	ПустоеЗначениеПравил.Тип = Тип("СправочникСсылка.ПравилаОбработки");
	ПустоеЗначениеПравил.Значение = УникальныйИдентификаторПустой();
	ДанныеПравил.Вставить("ПравилоОбработки", ПустоеЗначениеПравил);
	
	ПустоеЗначениеВидаДействия = НовыеДанныеЗначения1С();
	ПустоеЗначениеВидаДействия.Тип = Тип("СправочникСсылка.ВидыДействий");
	ПустоеЗначениеВидаДействия.Значение = УникальныйИдентификаторПустой();
	ДанныеПравил.Вставить("ВидДействия", ПустоеЗначениеВидаДействия);
	
	ПустоеЗначениеНастройкиДействия = НовыеДанныеЗначения1С();
	ПустоеЗначениеНастройкиДействия.Тип = Тип("СправочникСсылка.НастройкиДействийОзнакомления");
	ПустоеЗначениеНастройкиДействия.Значение = УникальныйИдентификаторПустой();
	ДанныеПравил.Вставить("Настройка", ПустоеЗначениеНастройкиДействия);
	
	ПустоеЗначениеБулева = НовыеДанныеЗначения1С();
	ПустоеЗначениеБулева.Тип = Тип("Булево");
	ПустоеЗначениеБулева.Значение = Ложь;
	ДанныеПравил.Вставить("НастройкаВключена", ПустоеЗначениеБулева);
	
	Возврат ДанныеПравил;
	
КонецФункции

// Конструктор данных используемой ссылки
// 
// Возвращаемое значение:
//  Структура:
//    * ИмяОбъектаМетаданных - Строка - Имя объекта метаданных ссылки
//    * УникальныйИдентификатор - УникальныйИдентификатор - ГУИД ссылки
//    * Представление - Строка
//    * ЗначенияРеквизитов - Структура - Структура значий реквизитов
//    * ТабличныеЧасти - Соответствие Из КлючИЗначение:
//       ** Ключ - Строка - Имя табличной части
//       ** Значение - Массив Из Структура - Массив значий колонок табличной части
Функция НовыеДанныеИспользуемойСсылки() Экспорт
	
	ДанныеСсылки = Новый Структура;
	ДанныеСсылки.Вставить("ИмяОбъектаМетаданных", "");
	ДанныеСсылки.Вставить("УникальныйИдентификатор", УникальныйИдентификаторПустой());
	ДанныеСсылки.Вставить("Представление", "");
	ДанныеСсылки.Вставить("ЗначенияРеквизитов", Новый Структура());
	ДанныеСсылки.Вставить("ТабличныеЧасти", Новый Соответствие());
	
	Возврат ДанныеСсылки;
	
КонецФункции

// Конструктор данных значения 1С
// 
// Возвращаемое значение:
//  Структура:
// * Тип - Тип - 
// * Значение - Строка, Булево, Дата, Число, УникальныйИдентификатор, ПеречислениеСсылка, ХранилищеЗначения, Неопределено -
Функция НовыеДанныеЗначения1С() Экспорт
	
	ДанныеЗначения = Новый Структура;
	ДанныеЗначения.Вставить("Тип", Тип("Неопределено"));
	ДанныеЗначения.Вставить("Значение", Неопределено);
	
	Возврат ДанныеЗначения;
	
КонецФункции

// Конструктор данных для создания настроек обработки
// 
// Возвращаемое значение:
//  Структура:
//    * ВидОбъекта - ОпределяемыйТип.ВидОбъектаСОбработкой - 
//    * СопоставленныеСсылки - Соответствие Из КлючИЗначение:
//       ** Ключ - УникальныйИдентификатор
//       ** Значение - ЛюбаяСсылка
//    * НастройкиОбработки - см. НовыеДанныеЗначенияРеквизитаОбъектаДляСоздания
//    * ПараметрыСхем - Массив Из см. НовыеДанныеЗначенияРеквизитаОбъектаДляСоздания
//    * ПравилаОбработки - см. НовыйНаборПравилОбработкиДляСоздания
//    * ДанныеСсылокКСопоставлению - Соответствие Из КлючИЗначение:
//       ** Ключ - УникальныйИдентификатор
//       ** Значение - см. НовыеДанныеСсылкиКСопоставлению
// 
Функция НовыеДанныеДляСозданияНастроекОбработки() Экспорт
	
	ДанныеНастроек = Новый Структура;
	ДанныеНастроек.Вставить("ВидОбъекта", ПредопределенноеЗначение("Справочник.ВидыДокументов.ПустаяСсылка"));
	ДанныеНастроек.Вставить("СопоставленныеСсылки", Новый Соответствие());
	ДанныеНастроек.Вставить("НастройкиОбработки", НовыеДанныеЗначенияРеквизитаОбъектаДляСоздания());
	ДанныеНастроек.Вставить("ПараметрыСхем", Новый Массив());
	ДанныеНастроек.Вставить("ПравилаОбработки", НовыйНаборПравилОбработкиДляСоздания());
	ДанныеНастроек.Вставить("ДанныеСсылокКСопоставлению", Новый Соответствие());
	
	Возврат ДанныеНастроек;
	
КонецФункции

// Конструктор набора правил обработки
// 
// Возвращаемое значение:
//  Массив Из см. НовыеДанныеПравилОбработкиДляСоздания
Функция НовыйНаборПравилОбработкиДляСоздания() Экспорт
	
	Возврат Новый Массив();
	
КонецФункции

// Конструктор данных правил обрабокти для создания
// 
// Возвращаемое значение:
//  Структура:
// * ПравилоОбработки - см. НовыеДанныеЗначенияРеквизитаОбъектаДляСоздания
// * ВидДействия - см. НовыеДанныеЗначенияРеквизитаОбъектаДляСоздания
// * Настройка - см. НовыеДанныеЗначенияРеквизитаОбъектаДляСоздания
// * НастройкаВключена - Булево - 
Функция НовыеДанныеПравилОбработкиДляСоздания() Экспорт
	
	ДанныеПравил = Новый Структура;
	ДанныеПравил.Вставить("ПравилоОбработки", НовыеДанныеЗначенияРеквизитаОбъектаДляСоздания());
	ДанныеПравил.Вставить("ВидДействия", НовыеДанныеЗначенияРеквизитаОбъектаДляСоздания());
	ДанныеПравил.Вставить("Настройка", НовыеДанныеЗначенияРеквизитаОбъектаДляСоздания());
	ДанныеПравил.Вставить("НастройкаВключена", Ложь);
	
	Возврат ДанныеПравил;
	
КонецФункции

// Конструктор данных объекта для создания
// 
// Возвращаемое значение:
//  Структура:
//    * ИдентификаторПриЗагрузке - УникальныйИдентификатор
//    * ИмяОбъектаМетаданных - Строка - Полное имя объекта метаданных
//    * ЗначенияРеквизитов - Соответствие Из КлючИЗначение:
//      ** Ключ - Строка - Имя реквизита
//      ** Значение - см. НовыеДанныеЗначенияРеквизитаОбъектаДляСоздания
//    * ТабличныеЧасти - Соответствие Из КлючИЗначение:
//      ** Ключ - Строка - Имя табличной части
//      ** Значение - Массив Из см. НовыеДанныеЗначенийКолонокСтрокиТабличнойЧастиДляСоздания
Функция НовыеДанныеОбъектаДляСоздания() Экспорт
	
	ДанныеОбъекта = Новый Структура;
	ДанныеОбъекта.Вставить("ИдентификаторПриЗагрузке", УникальныйИдентификаторПустой());
	ДанныеОбъекта.Вставить("ИмяОбъектаМетаданных", "");
	ДанныеОбъекта.Вставить("ЗначенияРеквизитов", Новый Соответствие());
	ДанныеОбъекта.Вставить("ТабличныеЧасти", Новый Соответствие());
	
	Возврат ДанныеОбъекта;
	
КонецФункции

// Конструктор данных значений колонок
// 
// Возвращаемое значение:
//  Соответствие Из КлючИЗначение:
//    * Ключ - Строка - Имя колонки
//    * Значение - см. НовыеДанныеЗначенияРеквизитаОбъектаДляСоздания
Функция НовыеДанныеЗначенийКолонокСтрокиТабличнойЧастиДляСоздания() Экспорт
	
	Возврат Новый Соответствие();
	
КонецФункции

// Конструктор данных значения реквизита или кононки табличной части для создания объекта
// 
// Возвращаемое значение:
//  Структура:
//    * ВидЗначения - Строка - см. ВидыЗначенийРеквизитовОбъектовДляСоздания
//    * Значение - Неопределено, Строка, Дата, Число, УникальныйИдентификатор, ХранилищеЗначения, ЛюбаяСсылка -
//    * ОбъектКСозданию - см. НовыеДанныеОбъектаДляСоздания
//    * СсылкаКСопоставлению - см. НовыеДанныеСсылкиКСопоставлению
//
Функция НовыеДанныеЗначенияРеквизитаОбъектаДляСоздания() Экспорт
	
	ДанныеЗначения = Новый Структура;
	ДанныеЗначения.Вставить("ВидЗначения", ВидыЗначенийРеквизитовОбъектовДляСоздания().Значение);
	ДанныеЗначения.Вставить("Значение", Неопределено);
	ДанныеЗначения.Вставить("ОбъектКСозданию", НовыеДанныеОбъектаДляСоздания());
	ДанныеЗначения.Вставить("СсылкаКСопоставлению", НовыеДанныеСсылкиКСопоставлению());
	
	Возврат ДанныеЗначения;
	
КонецФункции

// Конструктор данных ссылки, подлежащей сопоставлению
// 
// Возвращаемое значение:
//  Структура:
// * УникальныйИдентификатор - УникальныйИдентификатор - 
// * ИмяОбъектаМетаданных - Строка - 
// * Представление - Строка
// * МестаИспользования - Массив Из Строка - 
// * СопоставленнаяСсылка - ЛюбаяСсылка, Неопределено -
// * ДанныеСсылки - см. НовыеДанныеИспользуемойСсылки
Функция НовыеДанныеСсылкиКСопоставлению() Экспорт
	
	ДанныеСсылки = Новый Структура;
	ДанныеСсылки.Вставить("УникальныйИдентификатор", УникальныйИдентификаторПустой());
	ДанныеСсылки.Вставить("Представление", "");
	ДанныеСсылки.Вставить("ИмяОбъектаМетаданных", "");
	ДанныеСсылки.Вставить("МестаИспользования", Новый Массив());
	ДанныеСсылки.Вставить("СопоставленнаяСсылка", Неопределено);
	ДанныеСсылки.Вставить("ДанныеСсылки", НовыеДанныеИспользуемойСсылки());
	
	Возврат ДанныеСсылки;
	
КонецФункции

// Перечисление видов значений реквизитов объектов для создания
// 
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//    * Значение - Строка - 
//    * ОбъектКСозданию - Строка - 
//    * СсылкаКСопоставлению - Строка - 
Функция ВидыЗначенийРеквизитовОбъектовДляСоздания() Экспорт
	
	ВидыЗначений = Новый Структура;
	ВидыЗначений.Вставить("Значение", "Значение");
	ВидыЗначений.Вставить("ОбъектКСозданию", "ОбъектКСозданию");
	ВидыЗначений.Вставить("СсылкаКСопоставлению", "СсылкаКСопоставлению");
	
	Возврат Новый ФиксированнаяСтруктура(ВидыЗначений);
	
КонецФункции

#КонецОбласти

#Область ДанныеОшибокЗагрузки

// Перечисление этапов загрузки настроек обработки
// 
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
// * ЧтениеДанных - Строка - 
// * ПроверкаПрочитанныхДанных - Строка - 
// * СопоставлениеСсылок - Строка - 
// * ЗаписьНастроек - Строка - 
Функция ЭтапыЗагрузкиНастроекОбработки() Экспорт
	
	Этапы = Новый Структура;
	Этапы.Вставить("ЧтениеДанных", "ЧтениеДанных");
	Этапы.Вставить("ПроверкаПрочитанныхДанных", "ПроверкаПрочитанныхДанных");
	Этапы.Вставить("СопоставлениеСсылок", "СопоставлениеСсылок");
	Этапы.Вставить("ЗаписьНастроек", "ЗаписьНастроек");
	
	Возврат Новый ФиксированнаяСтруктура(Этапы);
	
КонецФункции

// Конструктор ошибки загрузки настроек обработки
// 
// Возвращаемое значение:
//  Структура:
// * Этап - Строка - см. ЭтапыЗагрузкиНастроекОбработки
// * ТекстОшибки - Строка - 
Функция НовыеДанныеОшибкиЗагрузкиНастроекОбработки() Экспорт
	
	Ошибка = Новый Структура;
	Ошибка.Вставить("Этап", ЭтапыЗагрузкиНастроекОбработки().ЧтениеДанных);
	Ошибка.Вставить("ТекстОшибки", "");
	
	Возврат Ошибка;
	
КонецФункции

#КонецОбласти

#Область РаботаСКонтекстомЗагрузкиНастроек

// Устанавливает значение реквизита объекта к созданию
// 
// Параметры:
//  ОбъектКСозданию - см. НовыеДанныеОбъектаДляСоздания
//  ИмяРеквизита - Строка
//  ЗначениеРеквизита - Неопределено, Строка, Дата, Число, УникальныйИдентификатор, ХранилищеЗначения, ЛюбаяСсылка -
Процедура УстановитьЗначениеРеквизитаОбъектаКСозданию(ОбъектКСозданию, ИмяРеквизита, ЗначениеРеквизита) Экспорт
	
	ДанныеЗначения = НовыеДанныеЗначенияРеквизитаОбъектаДляСоздания();
	ДанныеЗначения.ВидЗначения = ВидыЗначенийРеквизитовОбъектовДляСоздания().Значение;
	ДанныеЗначения.Значение = ЗначениеРеквизита;
	
	ОбъектКСозданию.ЗначенияРеквизитов[ИмяРеквизита] = ДанныеЗначения;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
