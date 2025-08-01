﻿// @strict-types


#Область ПрограммныйИнтерфейс

Функция ИмяЭлементаУзлаОбмена() Экспорт
	
	Возврат "УзелОбработки";
	
КонецФункции

Функция ИмяРеквизитаУзлаОбмена() Экспорт
	
	Возврат "УзелОбработки"
	
КонецФункции

Функция ИмяЭлементаНадписьОбменВДругомУзле() Экспорт
	
	Возврат "НадписьОбменВДругомУзле";
	
КонецФункции

// Параметры элементов ограничения редактирования настроек.
// 
// Возвращаемое значение:
//  Структура:
// * ИмяГруппы - Строка - 
// * ИмяКартинки - Строка - 
// * ИмяНадписи - Строка - 
// * Надпись - Строка - 
Функция ПараметрыЭлементовОграниченияРедактированияНастроек() Экспорт
	
	ПараметрыЭлементов = Новый Структура;
	ПараметрыЭлементов.Вставить("ИмяГруппы", "ГруппаРедактированиеНастроекВЦентральномУзле");
	ПараметрыЭлементов.Вставить("ИмяКартинки", "КартинкаРедактированиеНастроекВЦентральномУзле");
	ПараметрыЭлементов.Вставить("ИмяНадписи", "НадписьРедактированиеНастроекВЦентральномУзле");
	ПараметрыЭлементов.Вставить("Надпись",
		НСтр("ru = 'Некоторые настройки программы выполняются централизованно и могут быть изменены только в центральном узле'"));
	
	Возврат ПараметрыЭлементов;
	
КонецФункции

// Возвращает имя элемента надписи о редактировании констант только в ЦУ
// 
// Возвращаемое значение:
//  Строка
Функция ИмяЭлементаНадписьОграниченияРедактированияКонстант() Экспорт
	
	Возврат "НадписьРедактированиеКонстантВЦентральномУзле"
	
КонецФункции

Функция ПредставлениеОшибкиСинхронизацииЭДО() Экспорт
	
	Возврат НСтр("ru = 'Авторизация в сервисе ЭДО'");
	
КонецФункции

Функция ВидОшибкиСинхронизацияВДругомУзле() Экспорт
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "СинхронизацияВДругомУзле";
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Синхронизация в другом узле'");
	ВидОшибки.ОписаниеРешения =
		НСтр("ru = 'Выполните операцию синхронизации с сервисом ЭДО в другом узле.'");
	ВидОшибки.ОбработчикиНажатия.Вставить("список ошибок", "ОбработкаНеисправностейБЭДКлиент.ОткрытьФормуДетализацииОшибок");

	Возврат ВидОшибки;
	
КонецФункции

#КонецОбласти
