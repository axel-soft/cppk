﻿// @strict-types


#Область ПрограммныйИнтерфейс

// Конструктор параметров для выгрузки настроек обработки в файл
// 
// Возвращаемое значение:
//  Структура -  Новые параметры выгрузки настроек обработки:
// * НастройкиОбработки - СправочникСсылка.НастройкиОбработкиВидовОбъектов - 
// * ВидыОбъектов - Массив Из ОпределяемыйТип.ВидОбъектаСОбработкой
Функция НовыеПараметрыВыгрузкиНастроекОбработки() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("НастройкиОбработки",
		ПредопределенноеЗначение("Справочник.НастройкиОбработкиВидовОбъектов.ПустаяСсылка"));
	Параметры.Вставить("ВидыОбъектов", Новый Массив());
	
	Возврат Параметры;
	
КонецФункции

// Начинает процедуру выгрузки настроек обработки в файл
// 
// Параметры:
//  Параметры - см. НовыеПараметрыВыгрузкиНастроекОбработки
Процедура ВыгрузитьНастройкиОбработкиВФайл(Параметры) Экспорт
	
	КонтекстВыгрузки = КопированиеНастроекОбработкиКлиентСервер.НовыйКонтекстВыгрузкиНастроек();
	КонтекстВыгрузки.ВыбранныеНастройкиОбработки = Параметры.НастройкиОбработки;
	КонтекстВыгрузки.ВыбранныеВидыОбъектов = Параметры.ВидыОбъектов;
	
	Если ЗначениеЗаполнено(КонтекстВыгрузки.ВыбранныеНастройкиОбработки) Тогда
		
		КопированиеНастроекОбработкиВызовСервера.ЗаполнитьДоступныеДляВыгрузкиДанныеПоНастройкеОбработки(КонтекстВыгрузки);
		Если НеобходимоПоказатьДиалогВыбораНастроекДляВыгрузки(КонтекстВыгрузки) Тогда
			
			ВидыОбъектов = Новый Массив(); // Массив Из ОпределяемыйТип.ВидОбъектаСОбработкой
			Для Каждого Элемент Из КонтекстВыгрузки.ДоступныеНастройкиОбработки Цикл
				ВидыОбъектов.Добавить(Элемент.Ключ);
			КонецЦикла;
			
			КонтекстВыгрузки.ВыбранныеВидыОбъектов = ВидыОбъектов;
			
			ПоказатьВыборНастроекДляВыгрузки(КонтекстВыгрузки);
			Возврат;
			
		Иначе
			
			ЗаполнитьНастройкиДляВыгрузкиПоДоступнымДляВыгрузкиДанным(КонтекстВыгрузки);
			ЗаполнитьДвоичныеДанныеВыгрузкиНастроек(КонтекстВыгрузки);
			Возврат;
			
		КонецЕсли;
		
	ИначеЕсли КонтекстВыгрузки.ВыбранныеВидыОбъектов.Количество() > 0 Тогда
		
		ПоказатьВыборНастроекДляВыгрузки(КонтекстВыгрузки);
		Возврат;
		
	Иначе
		
		ПоказатьВыборНастроекДляВыгрузки(КонтекстВыгрузки);
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

// Конструктор параметров загрузки настроек обработки из файла
// 
// Возвращаемое значение:
//  Структура:
// * ВидОбъекта - ОпределяемыйТип.ВидОбъектаСОбработкой - 
// * ДатаНачалаДействия - Дата - 
// * ОбработчикЗавершения - Неопределено, ОписаниеОповещения -
//
Функция НовыеПараметрыЗагрузкиНастройкиОбработкиИзФайла() Экспорт
	
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("ВидОбъекта", ПредопределенноеЗначение("Справочник.ВидыДокументов.ПустаяСсылка"));
	ПараметрыЗагрузки.Вставить("ДатаНачалаДействия", Дата(1, 1, 1));
	ПараметрыЗагрузки.Вставить("ОбработчикЗавершения", Неопределено);
	
	Возврат ПараметрыЗагрузки;
	
КонецФункции

// Выполняет загрузку настроек обработки из файла
// 
// Параметры:
//  Параметры - см. НовыеПараметрыЗагрузкиНастройкиОбработкиИзФайла
Процедура ЗагрузитьНастройкиОбработкиИзФайла(Параметры) Экспорт
	
	Фильтр = НСтр("ru = 'Файлы xml (*.xml)|*.xml'");
	
	ПараметрыВыбора = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыВыбора.Диалог.Заголовок = НСтр("ru = 'Выберите файл выгрузки настроек'");
	ПараметрыВыбора.Диалог.Фильтр = Фильтр;
	
	ОбработчикВыбора = Новый ОписаниеОповещения(
		"ОбработатьВыборФайлаЗагрузкиНастроекОбработки", ЭтотОбъект, Параметры);
	
	ФайловаяСистемаКлиент.ЗагрузитьФайл(ОбработчикВыбора, ПараметрыВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обрабатывает выбор файла загрузки настроек обработки
// 
// Параметры:
//   ПомещенныйФайл - Неопределено - пользователь отказался от выбора.
//                  - Структура    - пользователь выбрал файл:
//                      * Хранение  - Строка - расположение данных во временном хранилище.
//                      * Имя       - Строка - в тонком клиенте и в веб-клиенте с установленным
//                                   расширением работы с файлами - локальный путь, по которому
//                                   был получен файл. В веб-клиенте без расширения работы с
//                                   файлами - имя файла с расширением.
//   Параметры - см. НовыеПараметрыЗагрузкиНастройкиОбработкиИзФайла
Процедура ОбработатьВыборФайлаЗагрузкиНастроекОбработки(ПомещенныйФайл, Параметры) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЗагрузки = КопированиеНастроекОбработкиКлиентСервер.НовыйКонтекстЗагрузкиНастроек();
	КонтекстЗагрузки.ВидОбъектаЗагрузки = Параметры.ВидОбъекта;
	КонтекстЗагрузки.ДатаНачалаДействия = Параметры.ДатаНачалаДействия;
	КонтекстЗагрузки.АдресДанныхФайлаНастроек = ПомещенныйФайл.Хранение;
	
	ЗагрузитьНастройкиИзВыгрузки(КонтекстЗагрузки);
	
	Если Параметры.ОбработчикЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОбработчикЗавершения);
	КонецЕсли;
	
КонецПроцедуры

// Загружает настройки обработки из выгрузки
// 
// Параметры:
//  КонтекстЗагрузки - см. КопированиеНастроекОбработкиКлиентСервер.НовыйКонтекстЗагрузкиНастроек
Процедура ЗагрузитьНастройкиИзВыгрузки(КонтекстЗагрузки)
	
	КопированиеНастроекОбработкиВызовСервера.ВыполнитьЗагрузкуНастроекОбработки(КонтекстЗагрузки);
	
	Если КонтекстЗагрузки.Отказ Тогда
		Для Каждого Ошибка Из КонтекстЗагрузки.Ошибки Цикл
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(Ошибка.ТекстОшибки);
			
		КонецЦикла;
	Иначе
		
		ТекстОповещения = СтрШаблон(НСтр("ru = 'Настройки обработки успешно загружены для вида объекта %1'"),
			КонтекстЗагрузки.ВидОбъектаЗагрузки);
		
		ПоказатьОповещениеПользователя(ТекстОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает, нужно ли показывать выбор, какие настройки необходимо выгрузить или все однозначно
// 
// Параметры:
//  КонтекстВыгрузки - см. КопированиеНастроекОбработкиКлиентСервер.НовыйКонтекстВыгрузкиНастроек
// 
// Возвращаемое значение:
//  Булево
Функция НеобходимоПоказатьДиалогВыбораНастроекДляВыгрузки(КонтекстВыгрузки)
	
	Если КонтекстВыгрузки.ДоступныеНастройкиОбработки.Количество() <> 1 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Для Каждого Элемент Из КонтекстВыгрузки.ДоступныеНастройкиОбработки Цикл
		
		ДоступныеНастройки = Элемент.Значение; // см. КопированиеНастроекОбработкиКлиентСервер.НовыеДанныеДоступныхНастроекОбработкиДляВыгрузки
		
		Если ДоступныеНастройки.НастройкиОбработки.Количество() <> 1
			Или ДоступныеНастройки.ПравилаОбработки.Количество() > 1 Тогда
			
			Возврат Истина;
		КонецЕсли;
		
		Возврат Ложь;
		
	КонецЦикла;
	
КонецФункции

// Показывает форму выборка настроек обработки для выгрузки
// 
// Параметры:
//  КонтекстВыгрузки - см. КопированиеНастроекОбработкиКлиентСервер.НовыйКонтекстВыгрузкиНастроек
Процедура ПоказатьВыборНастроекДляВыгрузки(КонтекстВыгрузки)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидыОбъектов", КонтекстВыгрузки.ВыбранныеВидыОбъектов);
	ПараметрыФормы.Вставить("ВыбранныеНастройкиОбработки", КонтекстВыгрузки.ВыбранныеНастройкиОбработки);
	
	ОбработчикВыбора =
		Новый ОписаниеОповещения("ОбработатьВыборНастроекОбработкиДляВыгрузки", ЭтотОбъект, КонтекстВыгрузки);
	
	ОткрытьФорму(
		"Обработка.КопированиеНастроекОбработки.Форма.ВыборКопируемыхНастроекОбработки",
		ПараметрыФормы, , , , ,
		ОбработчикВыбора);
	
КонецПроцедуры

// Обработчик выбора настроек обработки для выгрузки
// 
// Параметры:
//  НастройкиОбработкиДляВыгрузки - Соответствие Из КлючИЗначение:
//    * Ключ - ОпределяемыйТип.ВидОбъектаСОбработкой
//    * Значение - см. КопированиеНастроекОбработкиКлиентСервер.НовыеДанныеНастроекОбработкиДляВыгрузки
//  КонтекстВыгрузки - см. КопированиеНастроекОбработкиКлиентСервер.НовыйКонтекстВыгрузкиНастроек
Процедура ОбработатьВыборНастроекОбработкиДляВыгрузки(НастройкиОбработкиДляВыгрузки, КонтекстВыгрузки) Экспорт
	
	Если НастройкиОбработкиДляВыгрузки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстВыгрузки.НастройкиОбработки = НастройкиОбработкиДляВыгрузки;
	
	ЗаполнитьДвоичныеДанныеВыгрузкиНастроек(КонтекстВыгрузки);
	
КонецПроцедуры

// Заполняет настройки обработки для выгрузки по досутпным для выгрузки данным.
//  Если настройки обработки однозначно не определяются (см. НеобходимоПоказатьДиалогВыбораНастроекДляВыгрузки дает Ложь,
//  то вызывается исключение)
// 
// Параметры:
//  КонтекстВыгрузки - см. КопированиеНастроекОбработкиКлиентСервер.НовыйКонтекстВыгрузкиНастроек
Процедура ЗаполнитьНастройкиДляВыгрузкиПоДоступнымДляВыгрузкиДанным(КонтекстВыгрузки)
	
	Если КонтекстВыгрузки.ДоступныеНастройкиОбработки.Количество() <> 1 Тогда
		ВызватьИсключение НСтр("ru = 'Недопустимый вызов метода, указаны доступные настройки по нескольким видам объектов'");
	КонецЕсли;
	
	Для Каждого Элемент Из КонтекстВыгрузки.ДоступныеНастройкиОбработки Цикл
		
		ВидОбъекта = Элемент.Ключ;
		ДоступныеНастройки = Элемент.Значение; // см. КопированиеНастроекОбработкиКлиентСервер.НовыеДанныеДоступныхНастроекОбработкиДляВыгрузки
		
		Если ДоступныеНастройки.НастройкиОбработки.Количество() = 0 Тогда
			ВызватьИсключение НСтр("ru = 'Недопустимый вызов метода, не указаны доступные настройки обработки'");
		ИначеЕсли ДоступныеНастройки.НастройкиОбработки.Количество() > 1 Тогда
			ВызватьИсключение НСтр("ru = 'Недопустимый вызов метода, выбрано более одной настройки обработки'");
		КонецЕсли;
		
		Если ДоступныеНастройки.ПравилаОбработки.Количество() > 1 Тогда
			ВызватьИсключение НСтр("ru = 'Недопустимый вызов метода, выбрано более одного правила обработки'");
		КонецЕсли;
		
		НастройкиВида = КопированиеНастроекОбработкиКлиентСервер.НовыеДанныеНастроекОбработкиДляВыгрузки();
		НастройкиВида.НастройкаОбработки = ДоступныеНастройки.НастройкиОбработки[0];
		НастройкиВида.ПравилаОбработки = ДоступныеНастройки.ПравилаОбработки;
		КонтекстВыгрузки.НастройкиОбработки[ВидОбъекта] = НастройкиВида;
		
	КонецЦикла;
	
КонецПроцедуры

// Заполняет двоичные данные выгрузки настроек обработки для дальнейшего ее сохранения в файл или копирования в буфер
// 
// Параметры:
//  КонтекстВыгрузки - см. КопированиеНастроекОбработкиКлиентСервер.НовыйКонтекстВыгрузкиНастроек
Процедура ЗаполнитьДвоичныеДанныеВыгрузкиНастроек(КонтекстВыгрузки)
	
	КопированиеНастроекОбработкиВызовСервера.ЗаполнитьАдресДанныхВыгрузкиНастроек(КонтекстВыгрузки);
	СохранитьДанныеВыгрузкиНастроекОбработки(КонтекстВыгрузки);
	
КонецПроцедуры

// Сохраняет данные выгрузки настроек обработки в файл
// 
// Параметры:
//  КонтекстВыгрузки - см. КопированиеНастроекОбработкиКлиентСервер.НовыйКонтекстВыгрузкиНастроек
Процедура СохранитьДанныеВыгрузкиНастроекОбработки(КонтекстВыгрузки)
	
	Фильтр = НСтр("ru = 'Файлы xml (*.xml)|*.xml'");
	
	ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохранения.Диалог.Фильтр = Фильтр;
	ПараметрыСохранения.Диалог.Заголовок = НСтр("ru = 'Выберите файл для выгрузки настроек'");
	
	СсылкаНаДанные = КонтекстВыгрузки.АдресДвоичныхДанныхВыгрузки;
	ИмяФайла = ИмяФайлаВыгрузкиНастроекОбработки(КонтекстВыгрузки);
	
	ФайловаяСистемаКлиент.СохранитьФайл(, СсылкаНаДанные, ИмяФайла, ПараметрыСохранения);
	
КонецПроцедуры

// Имя файла выгрузки настроек обработки.
// 
// Параметры:
//  КонтекстВыгрузки - см. КопированиеНастроекОбработкиКлиентСервер.НовыйКонтекстВыгрузкиНастроек
// 
// Возвращаемое значение:
//  Строка
Функция ИмяФайлаВыгрузкиНастроекОбработки(КонтекстВыгрузки)
	
	Если ЗначениеЗаполнено(КонтекстВыгрузки.ВыбранныеНастройкиОбработки) Тогда
		Возврат Строка(КонтекстВыгрузки.ВыбранныеНастройкиОбработки);
	КонецЕсли;
	
	Если КонтекстВыгрузки.ВыбранныеВидыОбъектов.Количество() = 1 Тогда
		Возврат Строка(КонтекстВыгрузки.ВыбранныеВидыОбъектов[0]);
	КонецЕсли;
	
	Возврат НСтр("ru = 'Настройки обработки.xml'");
	
КонецФункции

#КонецОбласти
