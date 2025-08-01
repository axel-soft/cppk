﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ДляВыгрузки;
Перем ДляЗагрузки;

Перем КонтейнерИнициализирован;
Перем ВременныйКаталог;
Перем Архив;
Перем КоличествоФайловПоВиду;
Перем ВремяНачалаВыгрузки;
Перем Состав;
Перем АрхивВТоме; // см. РаботаВМоделиСервиса.ПрочитатьАрхив
Перем АрхивВФайле; // см. ZipАрхивы.ПрочитатьАрхив
Перем ИспользуемыеФайлы;
Перем Предупреждения; // см. Предупреждения
Перем ВыгрузитьВТом;
Перем СоставнаяЗагрузка; // см. НовыйСоставнаяЗагрузка
Перем ВыгружатьДанныеРасширений;
Перем ВыгрузитьДифференциальнуюКопию;

Перем Параметры;

Перем ХешСуммаИсточника; // см. ХешСуммаИсточника
Перем ХешСуммаПараметров; // см. ХешСуммаПараметров

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// ВЫГРУЗКА

// Инициализирует выгрузку.
//
// Параметры:
//	ПараметрыВыгрузки - см. ВыгрузкаЗагрузкаДанных.ВыгрузитьДанныеТекущейОбластиВАрхив.ПараметрыВыгрузки
//
Процедура ИнициализироватьВыгрузку(Знач ПараметрыВыгрузки) Экспорт
	
	ПроверкаИнициализацииКонтейнера(Истина);
	Предупреждения = Новый Массив();
	ВремяНачалаВыгрузки = ТекущаяДатаСеанса();	

	ВременныйКаталог = ПолучитьИмяВременногоФайла("zip") + ПолучитьРазделительПути();
	СоздатьКаталог(ВременныйКаталог);
	
	ИмяФайлаВыгрузки = Неопределено;
	ПараметрыВыгрузки.Свойство("ИмяФайлаВыгрузки", ИмяФайлаВыгрузки);
	Если Не ЗначениеЗаполнено(ИмяФайлаВыгрузки) Тогда
		ИмяФайлаВыгрузки = ФайлыБТС.ИмяВременногоФайлаВОбщемКаталоге("zip");
	КонецЕсли;
	
	Архив = ZipАрхивы.Создать(ИмяФайлаВыгрузки);
	
	Параметры = ПараметрыВыгрузки;
	
	ДляВыгрузки = Истина;
	КонтейнерИнициализирован = Истина;
	Если Не ПараметрыВыгрузки.Свойство("ВыгрузитьВТом", ВыгрузитьВТом) Тогда
		ВыгрузитьВТом = Ложь;
	КонецЕсли;
	
	Если Не ПараметрыВыгрузки.Свойство("ВыгружатьДанныеРасширений", ВыгружатьДанныеРасширений) Тогда
		ВыгружатьДанныеРасширений = Ложь;
	КонецЕсли;
	
	Если Не ПараметрыВыгрузки.Свойство("ВыгрузитьДифференциальнуюКопию", ВыгрузитьДифференциальнуюКопию) Тогда
		ВыгрузитьДифференциальнуюКопию = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Параметры выгрузки
// 
// Возвращаемое значение: 
//  Структура - содержащая параметры выгрузки данных:
//		* ВыгружаемыеТипы - Массив из ОбъектМетаданных  - данные которых требуется выгрузить в архив
//      * ВыгружатьПользователей - Булево - выгружать информацию о пользователях информационной базы,
//      * ВыгружатьНастройкиПользователей - Булево - игнорируется если ВыгружатьПользователей = Ложь.
//    Также структура может содержать дополнительные ключи, которые могут быть обработаны внутри
//      произвольных обработчиков выгрузки данных.
Функция ПараметрыВыгрузки() Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Если ДляВыгрузки Тогда
		Возврат Новый ФиксированнаяСтруктура(Параметры);
	Иначе
		ВызватьИсключение НСтр("ru = 'Контейнер не инициализирован для выгрузки данных.'");
	КонецЕсли;
	
КонецФункции

Процедура УстановитьПараметрыВыгрузки(ПараметрыВыгрузки) Экспорт
	
	Параметры = ПараметрыВыгрузки;
	
КонецПроцедуры

// Создает файл в каталоге выгрузке.
//
// Параметры:
//	ВидФайла - Строка - вид файла выгрузки.
//	ТипДанных - Строка - тип данных.
//
// Возвращаемое значение:
//	Строка - имя файла.
//
Функция СоздатьФайл(Знач ВидФайла, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ДобавитьФайл(ВидФайла, "xml", ТипДанных);
	
КонецФункции

// Создает произвольный файл выгрузки.
//
// Параметры:
//	Расширение - Строка - расширение файла.
//	ТипДанных - Строка - тип данных.
//
// Возвращаемое значение:
//	Строка - имя файла.
//
Функция СоздатьПроизвольныйФайл(Знач Расширение, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ДобавитьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.CustomData(), Расширение, ТипДанных);
	
КонецФункции

Процедура УстановитьКоличествоОбъектов(Знач ПолныйПутьКФайлу, Знач ЧислоОбъектов = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	СтрокаСостава = НайтиСтрокуСостава(ПолныйПутьКФайлу, "ПолноеИмя");
	Если СтрокаСостава = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Файл не найден'");
	КонецЕсли;
	
	СтрокаСостава.ЧислоОбъектов = ЧислоОбъектов;
	
КонецПроцедуры

Процедура ИсключитьФайл(Знач ПолныйПутьКФайлу) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	СтрокаСостава = НайтиСтрокуСостава(ПолныйПутьКФайлу, "ПолноеИмя");
	Если СтрокаСостава = Неопределено Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Файл %1 не найден в составе контейнера.'"), ПолныйПутьКФайлу);
	КонецЕсли;
		
	КоличествоФайлов = КоличествоФайловПоВиду[СтрокаСостава.ВидФайла];
	КоличествоФайловПоВиду.Вставить(СтрокаСостава.ВидФайла, КоличествоФайлов - 1);
		
	Состав.Удалить(СтрокаСостава);
	ИспользуемыеФайлы.Удалить(ИспользуемыеФайлы.Найти(ПолныйПутьКФайлу));
	УдалитьФайлы(ПолныйПутьКФайлу);
	
КонецПроцедуры

Процедура ФайлЗаписан(Знач ПолныйПутьКФайлу) Экспорт
	
	Файл = Новый Файл(ПолныйПутьКФайлу);
	
	СтрокаСостава = НайтиСтрокуСостава(ПолныйПутьКФайлу, "ПолноеИмя");
	Если СтрокаСостава <> Неопределено Тогда
		СтрокаСостава.Размер = Файл.Размер();
	КонецЕсли;
	
	ОтносительноеИмя = Сред(ПолныйПутьКФайлу, СтрДлина(ВременныйКаталог));
	КаталогАрхива = ПолучитьИмяВременногоФайла("zip");
	Части = СтрРазделить(ОтносительноеИмя, ПолучитьРазделительПути());
	Части.Удалить(Части.ВГраница());
	СоздатьКаталог(КаталогАрхива + СтрСоединить(Части, ПолучитьРазделительПути()));
	ПереместитьФайл(ПолныйПутьКФайлу, КаталогАрхива + ОтносительноеИмя);
	ИспользуемыеФайлы.Удалить(ИспользуемыеФайлы.Найти(ПолныйПутьКФайлу));
	
	ZipАрхивы.ДобавитьФайл(Архив, КаталогАрхива);
	УдалитьФайлы(КаталогАрхива);
	
	Если ВыгрузитьВТом И ZipАрхивы.Размер(Архив) > 1024 * 1024 * 1024 Тогда
		ВремФайл = ПолучитьИмяВременногоФайла();
		ZipАрхивы.ОтделитьЧасть(Архив, ВремФайл);
		
		Если СоставнаяЗагрузка = Неопределено Тогда
			Результат = ПрограммныйИнтерфейсСервиса.НачатьСоставнуюЗагрузку(
				ВыгрузкаЗагрузкаДанныхКлиентСервер.ИмяФайлаВыгрузкиДанных(), 0, 
				"РезервнаяКопияОбласти", РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
			СоставнаяЗагрузка = НовыйСоставнаяЗагрузка(Результат.ИдентификаторФайла);
		Иначе
			Результат = ПрограммныйИнтерфейсСервиса.НоваяЧасть(СоставнаяЗагрузка.ИдентификаторФайла, 
				СоставнаяЗагрузка.Части.Количество() + 1);
		КонецЕсли;
		Если Результат.Тип = "s3" Тогда
			ОтправитьЧастьФайлаS3(Результат, ВремФайл);
		Иначе
			ОтправитьЧастьФайлаDT(Результат, ВремФайл, Ложь);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры



// Возвращает признак выгрузки дифференциальной копии
// 
// Возвращаемое значение:
// 	Булево - 
Функция ВыгрузитьДифференциальнуюКопию() Экспорт
	
	Возврат ВыгрузитьДифференциальнуюКопию;
	
КонецФункции

Функция ЭтоРезервноеКопирование() Экспорт
	
	Если Параметры.Свойство("ЭтоРезервноеКопирование") Тогда
		Возврат Параметры.ЭтоРезервноеКопирование;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Финализирует выгрузку. Записывает информацию о выгрузке в файл.
//
// Возвращаемое значение:
//   Строка - полное имя файла или идентификатор файла.
//
Функция ФинализироватьВыгрузку() Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	ИмяФайлаДайджеста = СоздатьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.Digest(), "CustomData");
	ЗаписатьДайджест(ИмяФайлаДайджеста);
	
	ЗаписатьИнформациюОРасширениях();
	
	ИмяФайлаСодержимого = СоздатьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents());
	ЗаписатьСодержимоеКонтейнераВФайл(ИмяФайлаСодержимого);
	
	Для Каждого НайденныйФайл Из НайтиФайлы(ВременныйКаталог, "*", Истина) Цикл
		Если НайденныйФайл.ЭтоФайл() Тогда
			ФайлЗаписан(НайденныйФайл.ПолноеИмя);
		КонецЕсли;
	КонецЦикла;
	
	УдалитьФайлы(ВременныйКаталог);
	
	ZipАрхивы.Завершить(Архив);
	
	Если ВыгрузитьВТом Тогда
		Если СоставнаяЗагрузка = Неопределено Тогда
			Файл = Новый Файл(Архив.ИмяФайла);
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ИмяФайла", Файл.Имя);
			ДополнительныеПараметры.Вставить("РазмерФайла", Файл.Размер());
			ДополнительныеПараметры.Вставить("ТипФайла", "РезервнаяКопияОбластиДанных");
			ДополнительныеПараметры.Вставить("ОбластьДанных", РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
			ДополнительныеПараметры.Вставить("КлючОбластиДанных", Константы.КлючОбластиДанных.Получить());
			ДополнительныеПараметры.Вставить("ПоддержкаS3", Истина);
			
			Возврат РаботаВМоделиСервиса.ПоместитьФайлВХранилищеМенеджераСервиса(Файл, , ДополнительныеПараметры);
				
		Иначе
			Результат = ПрограммныйИнтерфейсСервиса.НоваяЧасть(СоставнаяЗагрузка.ИдентификаторФайла, СоставнаяЗагрузка.Части.Количество() + 1);
			Если Результат.Тип = "s3" Тогда
				ОтправитьЧастьФайлаS3(Результат, Архив.ИмяФайла);
				ПрограммныйИнтерфейсСервиса.ЗавершитьСоставнуюЗагрузку(СоставнаяЗагрузка.ИдентификаторФайла, СоставнаяЗагрузка.Части);
			Иначе
				ОтправитьЧастьФайлаDT(Результат, Архив.ИмяФайла, Истина);
			КонецЕсли;
			Возврат СоставнаяЗагрузка.ИдентификаторФайла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Архив.ИмяФайла;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ЗАГРУЗКА

// Инициализирует загрузку.
//
// Параметры:
//	ДанныеФайла - Строка, УникальныйИдентификатор, Структура - имя файла, идентификатор файла или данные файла полученные с помощью РаботаВМоделиСервиса.ПрочитатьАрхив().
//	ПараметрыЗагрузки - см. ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеТекущейОбластиИзАрхива.ПараметрыЗагрузки
//
Процедура ИнициализироватьЗагрузку(Знач ДанныеФайла, Знач ПараметрыЗагрузки) Экспорт
	
	ПроверкаИнициализацииКонтейнера(Истина);
	Предупреждения = Новый Массив();
	ВременныйКаталог = ПолучитьИмяВременногоФайла("zip") + ПолучитьРазделительПути();
	СоздатьКаталог(ВременныйКаталог);
	
	Если ТипЗнч(ДанныеФайла) = Тип("Структура") Тогда
		АрхивВТоме = ДанныеФайла;
	ИначеЕсли ТипЗнч(ДанныеФайла) = Тип("УникальныйИдентификатор") Тогда
		АрхивВТоме = РаботаВМоделиСервиса.ПрочитатьАрхив(ДанныеФайла);
	Иначе
		АрхивВФайле = ZipАрхивы.ПрочитатьАрхив(ФайловыеПотоки.ОткрытьДляЧтения(ДанныеФайла));
	КонецЕсли;
	
	РаспаковатьФайлПоИмени(ПолучитьИмяФайла(ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents()));
	
	ИмяФайлаСодержимого = ВременныйКаталог + ПолучитьИмяФайла(ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents());
	
	ФайлСодержимого = Новый Файл(ИмяФайлаСодержимого);
	Если Не ФайлСодержимого.Существует() Тогда
		
		ВызватьИсключение НСтр("ru = 'Ошибка загрузки данных. Неверный формат файла. В архиве не обнаружен файл PackageContents.xml.
                                |Возможно, файл был получен из предыдущих версий программы или поврежден.'");
		
	КонецЕсли;
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.CRC32);
	ХешированиеДанных.ДобавитьФайл(ИмяФайлаСодержимого);
	ХешСуммаИсточника = ХешированиеДанных.ХешСумма;
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.CRC32);
	КонтролируемыеПараметрыЗагрузки = Новый Структура("ЗагружатьНастройкиПользователей, ЗагружатьПользователей, СвернутьРазделенныхПользователей");
	ЗаполнитьЗначенияСвойств(КонтролируемыеПараметрыЗагрузки, ПараметрыЗагрузки);
	ХешированиеДанных.Добавить(
		ОбщегоНазначения.ЗначениеВСтрокуXML(КонтролируемыеПараметрыЗагрузки));
	ХешСуммаПараметров = ХешированиеДанных.ХешСумма;
	
	ПотокЧтения = Новый ЧтениеXML();
	ПотокЧтения.ОткрытьФайл(ИмяФайлаСодержимого);
	ПотокЧтения.ПерейтиКСодержимому();
	
	Если ПотокЧтения.ТипУзла <> ТипУзлаXML.НачалоЭлемента
			Или ПотокЧтения.Имя <> "Data" Тогда
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Ошибка чтения XML. Неверный формат файла. Ожидается начало элемента %1.'"),
			"Data");
		
	КонецЕсли;
	
	Если НЕ ПотокЧтения.Прочитать() Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка чтения XML. Обнаружено завершение файла.'");
	КонецЕсли;
	
	Пока ПотокЧтения.ТипУзла = ТипУзлаXML.НачалоЭлемента Цикл
		
		ЭлементКонтейнера = ФабрикаXDTO.ПрочитатьXML(ПотокЧтения, ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "File"));
		Файл = Состав.Добавить();
		Файл.Имя = ЭлементКонтейнера.Name;
		Файл.Каталог = ЭлементКонтейнера.Directory;
		Файл.Размер = ЭлементКонтейнера.Size;
		Файл.ВидФайла = ЭлементКонтейнера.Type;
		Файл.ЧислоОбъектов = ЭлементКонтейнера.Count;
		Файл.ТипДанных = ЭлементКонтейнера.DataType;
		
	КонецЦикла;
	
	ПотокЧтения.Закрыть();
	
	Для Каждого Элемент Из Состав Цикл
		Элемент.ПолноеИмя = ВременныйКаталог + Элемент.Каталог + ПолучитьРазделительПути() + Элемент.Имя;
	КонецЦикла;
	
	Состав.Индексы.Добавить("ВидФайла, ТипДанных");
	Состав.Индексы.Добавить("ВидФайла");
	Состав.Индексы.Добавить("ПолноеИмя");
	Состав.Индексы.Добавить("Каталог");
	Состав.Индексы.Добавить("Имя");
	
	Параметры = ПараметрыЗагрузки;
	
	ДляЗагрузки = Истина;
	КонтейнерИнициализирован = Истина;
	
КонецПроцедуры

// Параметры загрузки
// 
// Возвращаемое значение: см. ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеТекущейОбластиИзАрхива.ПараметрыЗагрузки
Функция ПараметрыЗагрузки() Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Если ДляЗагрузки Тогда
		Возврат Новый ФиксированнаяСтруктура(Параметры);
	Иначе
		ВызватьИсключение НСтр("ru = 'Контейнер не инициализирован для загрузки данных.'");
	КонецЕсли;
	
КонецФункции

Процедура УстановитьПараметрыЗагрузки(ПараметрыЗагрузки) Экспорт
	
	Параметры = ПараметрыЗагрузки;
	
КонецПроцедуры

// Получает файл из каталога.
//
// Параметры:
//	ВидФайла - Строка - вид файла выгрузки.
//	ТипДанных - Строка - тип данных.
//
// Возвращаемое значение:
//	СтрокаТаблицыЗначений из см. НовыйСостав
//
Функция ПолучитьФайлИзКаталога(Знач ВидФайла, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Файлы = ПолучитьФайлыИзСостава(ВидФайла, ТипДанных);
	Если Файлы.Количество() = 0 Тогда
		Возврат Неопределено;
	ИначеЕсли Файлы.Количество() > 1 Тогда
		Шаблон = НСтр("ru = 'В выгрузке содержатся дубли файлов, вид файла: %1, тип данных: %2, количество: %3'");
		ВызватьИсключение СтрШаблон(Шаблон, ВидФайла, ТипДанных, Файлы.Количество());
	КонецЕсли;
	
	Возврат Файлы[0];
	
КонецФункции

// Получает произвольный файл из каталога.
//
// Параметры:
//	ТипДанных - Строка - тип данных.
//
// Возвращаемое значение:
//	СтрокаТаблицыЗначений - см. таблицу значений "Состав".
//
Функция ПолучитьПроизвольныйФайл(Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Файлы = ПолучитьФайлыИзСостава(ВыгрузкаЗагрузкаДанныхСлужебный.CustomData() , ТипДанных);
	Если Файлы.Количество() = 0 Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'В выгрузке отсутствует произвольный файл с типом данным %1.'"),
			ТипДанных);
	ИначеЕсли Файлы.Количество() > 1 Тогда
		Шаблон = НСтр("ru = 'В выгрузке содержатся дубли произвольных файлов, тип данных: %1, количество: %2'");
		ВызватьИсключение СтрШаблон(Шаблон, ТипДанных, Файлы.Количество());
	КонецЕсли;
	
	РаспаковатьФайл(Файлы[0]);
	
	Возврат Файлы[0].ПолноеИмя;
	
КонецФункции

// Получить файлы из каталога.
// 
// Параметры: 
//	ВидФайла - Строка - вид файла выгрузки.
//	ТипДанных - Строка - тип данных.
// 
// Возвращаемое значение:  см. ПолучитьОписанияФайловИзКаталога
Функция ПолучитьФайлыИзКаталога(Знач ВидФайла, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ПолучитьОписанияФайловИзКаталога(ВидФайла, ТипДанных);
	
КонецФункции

// Получить описания файлов из каталога
// 
// Параметры: 
//	ВидФайла - Строка - вид файла выгрузки.
//	ТипДанных - Строка - тип данных.
// 
// Возвращаемое значение: 
//  ТаблицаЗначений:
// * Имя - Строка
// * Каталог - Строка
// * ПолноеИмя - Строка
// * Размер - Число
// * ВидФайла - Строка
// * Хеш - Строка
// * ЧислоОбъектов - Число
// * ТипДанных - Строка
Функция ПолучитьОписанияФайловИзКаталога(Знач ВидФайла, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	ТаблицаСФайлами = Неопределено;
	
	Если ТипЗнч(ВидФайла) = Тип("Массив") Тогда 
		
		Для Каждого ОтдельныйВид Из ВидФайла Цикл
			ДописатьФайлыВТаблицуЗначений(ТаблицаСФайлами, ПолучитьФайлыИзСостава(ОтдельныйВид , ТипДанных));
		КонецЦикла;
		Возврат ТаблицаСФайлами;
		
	ИначеЕсли ТипЗнч(ВидФайла) = Тип("Строка") Тогда 
		
		Возврат ПолучитьФайлыИзСостава(ВидФайла, ТипДанных);
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Неизвестный вид файла'");
		
	КонецЕсли;
	
КонецФункции

// Получить произвольные файлы
// 
// Параметры: 
//  ТипДанных - Строка - тип данных.
// 
// Возвращаемое значение: 
//  Массив из Строка.
Функция ПолучитьПроизвольныеФайлы(Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ПолучитьОписанияПроизвольныхФайлов(ТипДанных).ВыгрузитьКолонку("ПолноеИмя");
	
КонецФункции

// Получить полное имя файла
// 
// Параметры: 
//  ОтносительноеИмяФайла - Строка
// 
// Возвращаемое значение: 
//  Строка - полное имя файла.
Функция ПолучитьПолноеИмяФайла(Знач ОтносительноеИмяФайла) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	СтрокаСостава = Состав.Найти(ОтносительноеИмяФайла, "Имя");
	
	Если СтрокаСостава = Неопределено Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'В контейнере не обнаружен файл с относительным именем %1.'"),
			ОтносительноеИмяФайла);
	Иначе
		РаспаковатьФайл(СтрокаСостава);
		Возврат СтрокаСостава.ПолноеИмя;
	КонецЕсли;
	
КонецФункции

// Получает относительное имя файла
// 
// Параметры: 
//  ПолноеИмяФайла - Строка
// 
// Возвращаемое значение: 
//  Строка - относительное имя файла.
Функция ПолучитьОтносительноеИмяФайла(Знач ПолноеИмяФайла) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	СтрокаСостава = НайтиСтрокуСостава(ПолноеИмяФайла, "ПолноеИмя");
	
	Если СтрокаСостава = Неопределено Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'В контейнере не обнаружен файл %1.'"),
			ПолноеИмяФайла);
	Иначе
		Возврат СтрокаСостава.Имя;
	КонецЕсли;
	
КонецФункции

Процедура ФинализироватьЗагрузку() Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	УдалитьФайлы(ВременныйКаталог);
	
КонецПроцедуры

Процедура РаспаковатьФайл(СтрокаФайл) Экспорт
	
	Для ОбратныйИндекс = 1 - ИспользуемыеФайлы.Количество() По 0 Цикл
		ПолноеИмяФайла = ИспользуемыеФайлы[-ОбратныйИндекс];
		Файл = Новый Файл(ПолноеИмяФайла);
		Если Не Файл.Существует() Тогда
			ИспользуемыеФайлы.Удалить(-ОбратныйИндекс);
		ИначеЕсли ФайлДоступенДляЗаписи(ПолноеИмяФайла) Тогда
			УдалитьФайлы(ПолноеИмяФайла);
			ИспользуемыеФайлы.Удалить(-ОбратныйИндекс);
		КонецЕсли;
	КонецЦикла;
	
	РаспаковатьФайлПоИмени(СтрокаФайл.Имя, СтрокаФайл.Каталог);
	ИспользуемыеФайлы.Добавить(СтрокаФайл.ПолноеИмя);
	
КонецПроцедуры

// Читает объект из файла.
// 
// Параметры: 
//  Файл - СтрокаТаблицыЗначений
// 
// Возвращаемое значение:
//  Произвольный
Функция ПрочитатьОбъектИзФайла(Файл) Экспорт
	
	РаспаковатьФайл(Файл);
	Результат = ВыгрузкаЗагрузкаДанных.ПрочитатьОбъектИзФайла(Файл.ПолноеИмя);
	УдалитьФайлы(Файл.ПолноеИмя);
	
	Возврат Результат;
	
КонецФункции

// Хеш сумма источника
// 
// Возвращаемое значение:
//  Число
Функция ХешСуммаИсточника() Экспорт
	Возврат ХешСуммаИсточника;
КонецФункции

// Хеш сумма параметров
// 
// Возвращаемое значение:
//  Число
Функция ХешСуммаПараметров() Экспорт
	Возврат ХешСуммаПараметров;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает таблицу состава контейнера выгрузки.
// 
// Возвращаемое значение:
// 	ТаблицаЗначений:
// * Имя - Строка
// * Каталог - Строка
// * ПолноеИмя - Строка
// * Размер - Число
// * ВидФайла - Строка
// * Хеш - Строка
// * ЧислоОбъектов - Число
// * ТипДанных - Строка
//
Функция НовыйСостав()
	
	НовыйСостав = Новый ТаблицаЗначений;
	НовыйСостав.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
	НовыйСостав.Колонки.Добавить("Каталог", Новый ОписаниеТипов("Строка"));
	НовыйСостав.Колонки.Добавить("ПолноеИмя", Новый ОписаниеТипов("Строка"));
	НовыйСостав.Колонки.Добавить("Размер", Новый ОписаниеТипов("Число"));
	НовыйСостав.Колонки.Добавить("ВидФайла", Новый ОписаниеТипов("Строка"));
	НовыйСостав.Колонки.Добавить("ЧислоОбъектов", Новый ОписаниеТипов("Число"));
	НовыйСостав.Колонки.Добавить("ТипДанных", Новый ОписаниеТипов("Строка"));
	
	Возврат НовыйСостав;
	
КонецФункции

// Параметры:
// 	ИдентификаторФайла - УникальныйИдентификатор
// 	
// Возвращаемое значение:
// 	Структура:
// 	* ИдентификаторФайла - УникальныйИдентификатор
// 	* Части - Массив
// 	* Отправлено - Число
// 	
Функция НовыйСоставнаяЗагрузка(ИдентификаторФайла) 
	
	НовыйСоставнаяЗагрузка = Новый Структура;
	НовыйСоставнаяЗагрузка.Вставить("ИдентификаторФайла", ИдентификаторФайла);
	НовыйСоставнаяЗагрузка.Вставить("Части", Новый Массив);
	НовыйСоставнаяЗагрузка.Вставить("Отправлено", 0);

	Возврат НовыйСоставнаяЗагрузка;
	
КонецФункции

Функция ПолучитьФайлыИзСостава(Знач ВидФайла = Неопределено, Знач ТипДанных = Неопределено)
	
	Фильтр = Новый Структура;
	Если ВидФайла <> Неопределено Тогда
		Фильтр.Вставить("ВидФайла", ВидФайла);
	КонецЕсли;
	Если ТипДанных <> Неопределено Тогда
		Фильтр.Вставить("ТипДанных", ТипДанных);
	КонецЕсли;
	
	Возврат Состав.Скопировать(Фильтр);
	
КонецФункции

Процедура ПроверкаИнициализацииКонтейнера(Знач ПриИнициализации = Ложь)
	
	Если ДляВыгрузки И ДляЗагрузки Тогда
		ВызватьИсключение НСтр("ru = 'Некорректная инициализация контейнера.'");
	КонецЕсли;
	
	Если ПриИнициализации Тогда
		
		Если КонтейнерИнициализирован <> Неопределено И КонтейнерИнициализирован Тогда
			ВызватьИсключение НСтр("ru = 'Контейнер выгрузки уже был инициализирован ранее.'");
		КонецЕсли;
		
	Иначе
		
		Если Не КонтейнерИнициализирован Тогда
			ВызватьИсключение НСтр("ru = 'Контейнер выгрузки не инициализирован.'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Работа с файлами в составе контейнера

// Параметры: 
//  ВидФайла - Строка - Вид файла
//  Расширение - Строка - Расширение
//  ТипДанных - Неопределено, Строка - Тип данных
// 
// Возвращаемое значение: 
//  Строка - полное имя файла.
//
Функция ДобавитьФайл(Знач ВидФайла, Знач Расширение = "xml", Знач ТипДанных = Неопределено)
	
	Для ОбратныйИндекс = 1 - ИспользуемыеФайлы.Количество() По 0 Цикл
		ПолноеИмяФайла = ИспользуемыеФайлы[-ОбратныйИндекс];
		Файл = Новый Файл(ПолноеИмяФайла);
		Если Файл.Существует() И ФайлДоступенДляЗаписи(ПолноеИмяФайла) Тогда
			ФайлЗаписан(ПолноеИмяФайла);
		КонецЕсли;
	КонецЦикла;
	
	ИмяФайла = ПолучитьИмяФайла(ВидФайла, Расширение, ТипДанных);
	
	Каталог = "";
	
	// для дайджеста нет отдельного вида файла
	Если ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Digest()
		ИЛИ ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Extensions() 
		ИЛИ ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.CustomExtensions() Тогда
		ВидФайла = "CustomData";
		
	КонецЕсли;
	
	Если Не ВыгрузкаЗагрузкаДанныхСлужебный.ПравилаФормированияСтруктурыКаталогов().Свойство(ВидФайла, Каталог) Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Вид файла %1 не поддерживается.'"), ВидФайла);
	КонецЕсли;
	
	Если ПустаяСтрока(Каталог) Тогда
		ПолноеИмя = ВременныйКаталог + ИмяФайла;
	Иначе
			
		КоличествоФайлов = 0;
		Если Не КоличествоФайловПоВиду.Свойство(ВидФайла, КоличествоФайлов) Тогда
			КоличествоФайлов = 0;
		КонецЕсли;
		КоличествоФайлов = КоличествоФайлов + 1;
		КоличествоФайловПоВиду.Вставить(ВидФайла, КоличествоФайлов);
		
		МаксимальноеКоличествоФайловВКаталоге = 1000;
		
		НомерКаталога = Цел((КоличествоФайлов - 1) / МаксимальноеКоличествоФайловВКаталоге) + 1;
		Каталог = Каталог + ?(НомерКаталога = 1, "", Формат(НомерКаталога, "ЧГ=0"));
		
		Если КоличествоФайлов % МаксимальноеКоличествоФайловВКаталоге = 1 Тогда
			СоздатьКаталог(ВременныйКаталог + Каталог);
		КонецЕсли;
		
		ПолноеИмя = ВременныйКаталог + Каталог + ПолучитьРазделительПути() + ИмяФайла;
		
	КонецЕсли;
	
	Файл = Состав.Добавить();
	Файл.Имя = ИмяФайла;
	Файл.Каталог = Каталог;
	Файл.ПолноеИмя = ПолноеИмя;
	Файл.ТипДанных = ТипДанных;
	Файл.ВидФайла = ВидФайла;
	
	ИспользуемыеФайлы.Добавить(ПолноеИмя);
	
	Возврат ПолноеИмя;
	
КонецФункции

Функция ФайлДоступенДляЗаписи(ИмяФайла)
	
	Попытка
		ЗаписьДанных = Новый ЗаписьДанных(ИмяФайла);
		ЗаписьДанных.Закрыть();
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

Функция ПолучитьИмяФайла(Знач ВидФайла, Знач Расширение = "xml", Знач ТипДанных = Неопределено)
	
	Если ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.DumpInfo() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.DumpInfo();
	ИначеЕсли ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Digest() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Digest();
	ИначеЕсли ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Extensions() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Extensions();	
	ИначеЕсли ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.CustomExtensions() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.CustomExtensions();	
	ИначеЕсли ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents();
	ИначеЕсли ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Users() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Users();
	Иначе
		ИмяФайла = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
	Для НомерСимвола = 1 По СтрДлина(Расширение) Цикл
		Символ = КодСимвола(Расширение, НомерСимвола);
		// Только цифры и латинские буквы, см. стандарт 542, п. 3.1
		Если Не (Символ >= 48 И Символ <= 57)
			И Не (Символ >= 65 И Символ <= 90)
			И Не (Символ >= 97 И Символ <= 122) Тогда
			Расширение = "bin";
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Расширение <> "" Тогда
		
		ИмяФайла = ИмяФайла + "." + Расширение;
		
	КонецЕсли;
	
	Возврат ИмяФайла;
	
КонецФункции

// Работа с описанием содержимого контейнера

Процедура ЗаписатьСодержимоеКонтейнераВФайл(ИмяФайла)
	
	ПотокЗаписи = Новый ЗаписьXML();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла);
	ПотокЗаписи.ЗаписатьОбъявлениеXML();
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Data");
	
	ТипFile = ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "File");
	Для Каждого Строка Из Состав Цикл
		
		ДанныеОФайле = ФабрикаXDTO.Создать(ТипFile);
		
		ДанныеОФайле.Name = Строка.Имя;
		ДанныеОФайле.Type = Строка.ВидФайла;
		Если ЗначениеЗаполнено(Строка.Каталог) Тогда
			ДанныеОФайле.Directory = Строка.Каталог;
		КонецЕсли;
		Если ЗначениеЗаполнено(Строка.Размер) Тогда
			ДанныеОФайле.Size = Строка.Размер;
		КонецЕсли;
		Если ЗначениеЗаполнено(Строка.ЧислоОбъектов) Тогда
			ДанныеОФайле.Count = Строка.ЧислоОбъектов;
		КонецЕсли;
		Если ЗначениеЗаполнено(Строка.ТипДанных) Тогда
			ДанныеОФайле.DataType = Строка.ТипДанных;
		КонецЕсли;
		
		ФабрикаXDTO.ЗаписатьXML(ПотокЗаписи, ДанныеОФайле);
		
	КонецЦикла;
	
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	ПотокЗаписи.Закрыть();
	
КонецПроцедуры

Процедура ЗаписатьДайджест(ИмяФайла)
	
	ИнформацияОКонфигурации = Новый СистемнаяИнформация();
	
	ЧислоОбъектов = Состав.Итог("ЧислоОбъектов");
	РазмерДанных  = Состав.Итог("Размер");
	
	ПродолжительностьВыгрузки = ТекущаяДатаСеанса() - ВремяНачалаВыгрузки;
	
	ПотокЗаписи = Новый ЗаписьXML();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла);
	ПотокЗаписи.ЗаписатьОбъявлениеXML();
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Digest");
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Platform");
	ПотокЗаписи.ЗаписатьТекст(ИнформацияОКонфигурации.ВерсияПриложения);
	ПотокЗаписи.ЗаписатьКонецЭлемента(); 
	
	Если РаботаВМоделиСервиса.РазделениеВключено() Тогда
		ПотокЗаписи.ЗаписатьНачалоЭлемента("Zone");
		ПотокЗаписи.ЗаписатьТекст(XMLСтрока(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса()));
		ПотокЗаписи.ЗаписатьКонецЭлемента();
	КонецЕсли; 
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("ObjectCount");
	ПотокЗаписи.ЗаписатьТекст(Формат(ЧислоОбъектов, "ЧГ=0"));
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("DataSize");
	ПотокЗаписи.ЗаписатьАтрибут("Measure", "Byte");
	ПотокЗаписи.ЗаписатьТекст(Формат(РазмерДанных, "ЧДЦ=1; ЧГ=0"));
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Duration");
	ПотокЗаписи.ЗаписатьАтрибут("Measure", "Second");
	ПотокЗаписи.ЗаписатьТекст(Формат(ПродолжительностьВыгрузки, "ЧГ=0"));
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	
	Если ПродолжительностьВыгрузки <>0 Тогда
		ПотокЗаписи.ЗаписатьНачалоЭлемента("SerializationSpeed");
		ПотокЗаписи.ЗаписатьАтрибут("Measure", "Byte/Second");
		ПотокЗаписи.ЗаписатьТекст(Формат(РазмерДанных / ПродолжительностьВыгрузки, "ЧДЦ=1; ЧГ=0"));
		ПотокЗаписи.ЗаписатьКонецЭлемента();
	КонецЕсли;
	
	Если ВыгрузкаОбластейДанныхДляТехническойПоддержки.РежимВыгрузкиДляТехническойПоддержки(ЭтотОбъект) Тогда
		ТипВыгрузки = "TechnicalSupport"
	Иначе                                  
		ТипВыгрузки = "Ordinary"	
	КонецЕсли;
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("DataDumpType");	
	ПотокЗаписи.ЗаписатьТекст(ТипВыгрузки); 
	ПотокЗаписи.ЗаписатьКонецЭлемента(); 
	
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	ПотокЗаписи.Закрыть();
	
КонецПроцедуры

Процедура ЗаписатьИнформациюОРасширениях()

	ИмяФайлаПоставляемыхРасширений = СоздатьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.Extensions(), "CustomData");
	ЗаписьПоставляемыхРасширений = Новый ЗаписьXML;
	ЗаписьПоставляемыхРасширений.ОткрытьФайл(ИмяФайлаПоставляемыхРасширений);
	ЗаписьПоставляемыхРасширений.ЗаписатьОбъявлениеXML();
	ЗаписьПоставляемыхРасширений.ЗаписатьНачалоЭлемента("Data");

	ИнформацияОПользовательскихРасширениях = Новый Массив;
	РазделениеВключено = РаботаВМоделиСервиса.РазделениеВключено();

	Если РазделениеВключено Тогда
		ПоставляемыеРасширения = РасширенияВМоделиСервиса.РасширенияТекущейОбластиДанных();
	КонецЕсли;
	
	ИменаУстановленныхИсправлений = ИменаУстановленныхИсправлений();
	
	Для Каждого РасширениеКонфигурации Из РасширенияКонфигурации.Получить() Цикл

		Если РазделениеВключено Тогда
		
			Если РасширениеКонфигурации.ОбластьДействия <> ОбластьДействияРасширенияКонфигурации.РазделениеДанных  Тогда
				Продолжить
			КонецЕсли;
			
			ЗаписьПоставляемогоРасширения = ПоставляемыеРасширения.Найти(РасширениеКонфигурации.УникальныйИдентификатор,
				"ИспользуемоеРасширение");
		
		Иначе
			ЗаписьПоставляемогоРасширения = Неопределено;
		КонецЕсли;
		
		ИзменяетСтруктуруДанных = РасширениеКонфигурации.ИзменяетСтруктуруДанных();
		
		Если ИзменяетСтруктуруДанных И НЕ РасширениеКонфигурации.Активно Тогда
			Продолжить;
		КонецЕсли;
		
		Если ДанныхПоставляемогоРасширенияДостаточноДляРезервногоКопирования(ЗаписьПоставляемогоРасширения) Тогда

			ИмяРасширения = ?(ЗначениеЗаполнено(ЗаписьПоставляемогоРасширения.Наименование),
				ЗаписьПоставляемогоРасширения.Наименование,
				РасширениеКонфигурации.Синоним);
			
			ЗаписьПоставляемыхРасширений.ЗаписатьНачалоЭлемента("Extension");
			ЗаписьПоставляемыхРасширений.ЗаписатьАтрибут("ModifiesDataStructure", Формат(ИзменяетСтруктуруДанных,
				"БЛ=false; БИ=true"));
			ЗаписьПоставляемыхРасширений.ЗаписатьАтрибут("Name", ИмяРасширения);
			ЗаписьПоставляемыхРасширений.ЗаписатьАтрибут("VersionUUID", Строка(
				ЗаписьПоставляемогоРасширения.ИдентификаторВерсии));
			ЗаписьПоставляемыхРасширений.ЗаписатьКонецЭлемента();

		Иначе
		
			Если ИменаУстановленныхИсправлений.Найти(РасширениеКонфигурации.Имя) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ИнформацияОПользовательскомРасширении = Новый Структура;
			ИнформацияОПользовательскомРасширении.Вставить("Active", РасширениеКонфигурации.Активно);
			ИнформацияОПользовательскомРасширении.Вставить("SafeMode", РасширениеКонфигурации.БезопасныйРежим);
			ИнформацияОПользовательскомРасширении.Вставить("UnsafeOperationWarnings",
				РасширениеКонфигурации.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях);
			ИнформацияОПользовательскомРасширении.Вставить("Name", РасширениеКонфигурации.Имя);
			ИнформацияОПользовательскомРасширении.Вставить("UseDefaultRolesForAllUsers", 
				РасширениеКонфигурации.ИспользоватьОсновныеРолиДляВсехПользователей);
			ИнформацияОПользовательскомРасширении.Вставить("UsedInDistributedInfoBase", 
				РасширениеКонфигурации.ИспользуетсяВРаспределеннойИнформационнойБазе);
			ИнформацияОПользовательскомРасширении.Вставить("Synonym", РасширениеКонфигурации.Синоним);
			ИнформацияОПользовательскомРасширении.Вставить("ModifiesDataStructure", ИзменяетСтруктуруДанных);
			
			Если ВыгружатьДанныеРасширений Тогда
				ИмяФайлаДанныхПользовательскогоРасширения = СоздатьПроизвольныйФайл("cfe", "ExtensionData");
				РасширениеКонфигурации.ПолучитьДанные().Записать(ИмяФайлаДанныхПользовательскогоРасширения);
				ФайлЗаписан(ИмяФайлаДанныхПользовательскогоРасширения);			
				ИнформацияОПользовательскомРасширении.Вставить("FileName", ПолучитьОтносительноеИмяФайла(
					ИмяФайлаДанныхПользовательскогоРасширения));
			КонецЕсли;
			
			ИнформацияОПользовательскомРасширении.Вставить("UUID", XMLСтрока(РасширениеКонфигурации.УникальныйИдентификатор));
				
			ИнформацияОПользовательскихРасширениях.Добавить(ИнформацияОПользовательскомРасширении);

		КонецЕсли;
	КонецЦикла;

	ЗаписьПоставляемыхРасширений.ЗаписатьКонецЭлемента();
	ЗаписьПоставляемыхРасширений.Закрыть();
	ФайлЗаписан(ИмяФайлаПоставляемыхРасширений);

	ИмяФайлаПользовательскихРасширений = ДобавитьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.CustomExtensions(), "json",
		"CustomData");
	ЗаписьПользовательскихРасширений = Новый ЗаписьJSON;
	ЗаписьПользовательскихРасширений.ОткрытьФайл(ИмяФайлаПользовательскихРасширений);
	ЗаписатьJSON(ЗаписьПользовательскихРасширений, ИнформацияОПользовательскихРасширениях);
	ЗаписьПользовательскихРасширений.Закрыть();
	ФайлЗаписан(ИмяФайлаПользовательскихРасширений);

КонецПроцедуры

Функция ДанныхПоставляемогоРасширенияДостаточноДляРезервногоКопирования(ЗаписьПоставляемогоРасширения)

	Результат = Ложь;
	ПустойИдентификатор = ОбщегоНазначенияКлиентСервер.ПустойУникальныйИдентификатор();
	Если ЗначениеЗаполнено(ЗаписьПоставляемогоРасширения)
		И ЗаписьПоставляемогоРасширения.ИдентификаторВерсии <> ПустойИдентификатор Тогда
	
		Результат = Истина;
	
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция ИменаУстановленныхИсправлений()

	Результат = Новый Массив;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеКонфигурации") Тогда 
		
		МодульОбновлениеКонфигурации = ОбщегоНазначения.ОбщийМодуль("ОбновлениеКонфигурации");		
		УстановленныеИсправления = МодульОбновлениеКонфигурации.УстановленныеИсправления();
		
		Для Каждого Исправление Из УстановленныеИсправления Цикл
			Результат.Добавить(Исправление.Наименование);	
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьОписанияПроизвольныхФайлов(Знач ТипДанных = Неопределено)
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ПолучитьФайлыИзСостава(ВыгрузкаЗагрузкаДанныхСлужебный.CustomData(), ТипДанных);
	
КонецФункции

Процедура ДописатьФайлыВТаблицуЗначений(ТаблицаСФайлами, Знач ФайлыИзСостава)
	
	Если ТаблицаСФайлами = Неопределено Тогда 
		ТаблицаСФайлами = ФайлыИзСостава;
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ФайлыИзСостава, ТаблицаСФайлами);
	
КонецПроцедуры

Процедура РаспаковатьФайлПоИмени(Знач Имя, Знач Путь = "")
	
	Если Не ПустаяСтрока(Путь) Тогда
		Путь = Путь + "/";
	КонецЕсли;
	ИмяФайлаВАрхиве = ?(ПустаяСтрока(Путь), Имя, Путь + Имя);
		
	Если АрхивВТоме <> Неопределено Тогда
		Если Не РаботаВМоделиСервиса.ИзвлечьФайл(АрхивВТоме, ИмяФайлаВАрхиве, ВременныйКаталог) Тогда
			ВызватьИсключение НСтр("ru = 'Файл не найден'");
		КонецЕсли;
	Иначе
		Если Не ZipАрхивы.ИзвлечьФайл(АрхивВФайле, ИмяФайлаВАрхиве, ВременныйКаталог) Тогда
			ВызватьИсключение НСтр("ru = 'Файл не найден'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтправитьЧастьФайлаS3(Результат, ИмяФайла)
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(Результат.Адрес);
	Если СтруктураURI.Схема = "https" Тогда
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение( , Новый СертификатыУдостоверяющихЦентровОС);
	КонецЕсли;
	Соединение = Новый HTTPСоединение(СтруктураURI.Хост, СтруктураURI.Порт, , , , 600, ЗащищенноеСоединение);
	Запрос = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере, Результат.Заголовки);
	Запрос.УстановитьИмяФайлаТела(ИмяФайла);
	Ответ = Соединение.ВызватьHTTPМетод("PUT", Запрос);
	Если Ответ.КодСостояния <> 200 Тогда
		ПрограммныйИнтерфейсСервиса.ОтменитьСоставнуюЗагрузку(СоставнаяЗагрузка.ИдентификаторФайла);
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Не удалось отправить часть файла, код ответа: %1%2%3'"), 
			Ответ.КодСостояния, Символы.ПС, Ответ.ПолучитьТелоКакСтроку());
	КонецЕсли;
	СоставнаяЗагрузка.Части.Добавить(Ответ.Заголовки.Получить("ETag"));
			
КонецПроцедуры

Процедура ОтправитьЧастьФайлаDT(Результат, ИмяФайла, ПоследняяЧасть)
	
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыДоступа = Новый Структура;
	ПараметрыДоступа.Вставить("URL", РаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса());
	ПараметрыДоступа.Вставить("UserName", РаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса());
	ПараметрыДоступа.Вставить("Password", РаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса());
	УстановитьПривилегированныйРежим(Ложь);
	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("Location", Результат.Адрес);
	ПараметрыОтправки.Вставить("SetCookie", Результат.Заголовки["SetCookie"]);
	
	Результат = ПередачаДанныхСервер.ОтправитьЧастьФайлаВЛогическоеХранилище(ПараметрыДоступа, ПараметрыОтправки, ИмяФайла, ПоследняяЧасть, СоставнаяЗагрузка.Отправлено);
	Если Результат = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не удалось отправить часть файла'");		
	КонецЕсли;
	
	Если Не ПоследняяЧасть Тогда
		СоставнаяЗагрузка.Отправлено = Результат;
	КонецЕсли;		
	
КонецПроцедуры

// Ищет строку с конца, т.к. это быстрее, когда строк > 100к
Функция НайтиСтрокуСостава(Значение, Колонка)
	
	Для ОбратныйИндекс = 1 - Состав.Количество() По Мин(4 - Состав.Количество(), 0) Цикл
		Если Состав[-ОбратныйИндекс][Колонка] = Значение Тогда
			Возврат Состав[-ОбратныйИндекс];
		КонецЕсли;
	КонецЦикла;
	
	Возврат Состав.Найти(Значение, Колонка);
	
КонецФункции

// Возвращаемое значение: 
//  Массив из Строка
Функция Предупреждения() Экспорт
	
	Возврат Предупреждения;
	
КонецФункции

Процедура ДобавитьПредупреждение(Предупреждение) Экспорт
	
	Предупреждения.Добавить(Предупреждение);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

// Инициализация состояния контейнера по умолчанию

ДополнительныеСвойства = Новый Структура();

КоличествоФайловПоВиду = Новый Структура();
ИспользуемыеФайлы = Новый Массив;

ДляВыгрузки = Ложь;
ДляЗагрузки = Ложь;

Состав = НовыйСостав();

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли