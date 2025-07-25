﻿#Область ПрограммныйИнтерфейс

// Устанавливает компоненту сканирования
Процедура УстановитьКомпоненту(ОбработчикРезультата) Экспорт

	Если ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"] = Неопределено Тогда
		КодВозврата = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаTWAIN", "twain", ТипВнешнейКомпоненты.Native);
		
		Если КодВозврата Тогда
			Состояние(НСтр("ru = 'Компонента сканирования уже установлена.'"));
			РаботаСФайламиКлиент.ВернутьРезультат(ОбработчикРезультата, Истина);
			Возврат;
		Иначе
			
			ПараметрыВыполнения = Новый Структура;
			ПараметрыВыполнения.Вставить("ОбработчикРезультата", ОбработчикРезультата);
			Обработчик = Новый ОписаниеОповещения("УстановитьКомпонентуЗавершение", ЭтотОбъект, ПараметрыВыполнения);
			НачатьУстановкуВнешнейКомпоненты(Обработчик, "ОбщийМакет.КомпонентаTWAIN");
			
		КонецЕсли;

	Иначе
		Состояние(НСтр("ru = 'Компонента сканирования уже установлена.'"));
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура УстановитьКомпонентуЗавершение(ПараметрыВыполнения) Экспорт
	
	РаботаСФайламиВызовСервера.ОчиститьНастройкиФормНовогоФайла();
	Оповестить("КомпонентаСканированияУстановлена");
	
	КомпонентаПодключена = ПроинициализироватьКомпоненту();
	РаботаСФайламиКлиент.ВернутьРезультат(ПараметрыВыполнения.ОбработчикРезультата, КомпонентаПодключена);
	
КонецПроцедуры

// Проинициализировать компоненту сканирования
Функция ПроинициализироватьКомпоненту() Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.КомпонентаTwain";
	Если ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"] = Неопределено Тогда
		КодВозврата = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаTWAIN", "twain", ТипВнешнейКомпоненты.Native);
		
		Если Не КодВозврата Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый("AddIn.twain.ImageScan"));
		
		ПараметрыЛогированияСканера = РаботаСоСканеромКлиентПовтИсп.ПараметрыЛогированияСканера();
		Если ПараметрыЛогированияСканера.ИспользоватьКаталогЖурналаСканирования Тогда 
			
			УстановитьИмяЛогФайла(ПараметрыЛогированияСканера.КаталогЖурналаСканирования); 
			
		КонецЕсли;	
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Установит имя лог файла, на вход принимает каталог и СтиратьФайлЛога
//
// Параметры:
//  КаталогЖурналаСканирования - Строка     
//  СтиратьФайлЛога - Булево
//
Процедура УстановитьИмяЛогФайла(КаталогЖурналаСканирования, СтиратьФайлЛога = Ложь) Экспорт 
	
	Если Не ЗначениеЗаполнено(КаталогЖурналаСканирования) Тогда
		Возврат;
	КонецЕсли;	

	КаталогЖурналаСканирования = КаталогЖурналаСканирования; 
	Если Прав(КаталогЖурналаСканирования, 1) <> ПолучитьРазделительПути() Тогда
		КаталогЖурналаСканирования = КаталогЖурналаСканирования + ПолучитьРазделительПути();
	КонецЕсли;	
	ИмяЛогФайла = КаталогЖурналаСканирования + "ImageScan.log";
	
	// очищаем лог  - при смене настроек, закрытии формы сканирования
	Если СтиратьФайлЛога Тогда
		ФайлЛога = Новый Файл(ИмяЛогФайла);
		Если ФайлЛога.Существует() Тогда
			УдалитьФайлы(ИмяЛогФайла);
		КонецЕсли;
	КонецЕсли;

	ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].LogFilePath = ИмяЛогФайла;
			
КонецПроцедуры

// Вернет версию компоненты сканирования
Функция ВерсияКомпонентыСканирования() Экспорт

	Если Не ПроинициализироватьКомпоненту() Тогда
		Возврат НСтр("ru= 'Компонента сканирования не установлена'");
	КонецЕсли;
	
	Возврат ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].Версия();
КонецФункции // ВерсияКомпонентыСканирования()

// Вернет массив строк - устройства TWAIN
Функция ПолучитьУстройства() Экспорт
	
	Массив = Новый Массив;
	
	Если Не ПроинициализироватьКомпоненту() Тогда
		Возврат Массив;
	КонецЕсли;
	
	РаботаСФайламиСлужебныйКлиент.ЗаписатьЖурналСканирования("ПолучитьУстройства.Старт");
	
	Попытка
		СтрокаУстройств = ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].ПолучитьУстройства();
		
		РаботаСФайламиСлужебныйКлиент.ЗаписатьЖурналСканирования("ПолучитьУстройства.Результат", 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ПолучитьУстройства() = %1", 
			СтрокаУстройств));
		
		Для Индекс = 1 По СтрЧислоСтрок(СтрокаУстройств) Цикл
			Строка = СтрПолучитьСтроку(СтрокаУстройств, Индекс); 		
			Массив.Добавить(Строка);
		КонецЦикла;	
	
	Исключение   
		ПодключенныеУстройства = Новый Массив;
		ПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		РаботаСФайламиСлужебныйКлиент.ЗаписатьЖурналСканирования("ПолучитьУстройства", ПредставлениеОшибки, Истина);
		ВызватьИсключение;
	КонецПопытки;
	
	
	Возврат Массив;
КонецФункции // ПолучитьУстройства()

// Вызвать диалог сканирования и показать диалог просмотра картинки
Процедура СканироватьИПоказатьДиалогПросмотра(ВладелецФайла, УникальныйИдентификатор, 
	НеОткрыватьКарточкуПослеСозданияИзФайла = Неопределено) Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	
	ПараметрыОткрытия = Новый Структура("ВладелецФайла, НеОткрыватьКарточкуПослеСозданияИзФайла, ИдентификаторКлиента", 
		ВладелецФайла, НеОткрыватьКарточкуПослеСозданияИзФайла, ИдентификаторКлиента);
	ОткрытьФорму("Справочник.Файлы.Форма.РезультатСканирования", ПараметрыОткрытия);
	
КонецПроцедуры

// Вернет Истина, если доступна команда Сканировать - установлена компонента сканирования и есть хоть один сканер
Функция ДоступнаКомандаСканировать(ПоказыватьОшибку = Истина) Экспорт

	Если Не ПроинициализироватьКомпоненту() Тогда
		Возврат Ложь;
	КонецЕсли; 
	
	РаботаСФайламиСлужебныйКлиент.ЗаписатьЖурналСканирования("ЕстьУстройства.Старт");
	
	ЕстьУстройства = Ложь;
	
	Попытка
		ЕстьУстройства = ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].ЕстьУстройства();
		РаботаСФайламиСлужебныйКлиент.ЗаписатьЖурналСканирования("ЕстьУстройства.Результат", 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ЕстьУстройства() = %1", ЕстьУстройства));
	Исключение
		ПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		РаботаСФайламиСлужебныйКлиент.ЗаписатьЖурналСканирования("ЕстьУстройства", ПредставлениеОшибки, Истина);
		ЕстьУстройства = Ложь;
	КонецПопытки;
	
	Возврат ЕстьУстройства;
	
КонецФункции // ДоступнаКомандаСканировать()


// Получает настройку сканера по имени
//
// Параметры
//  ИмяУстройства  - Строка - Имя сканера
//
//  ИмяНастройки  - Строка - имя настройки, например "XRESOLUTION" или "PIXELTYPE" или "ROTATION" или "SUPPORTEDSIZES"	
//
//
// Возвращаемое значение:
//   Число   - значение настройки сканера
//
Функция ПолучитьНастройку(ИмяУстройства, ИмяНастройки) Экспорт
	
	Попытка
		РаботаСФайламиСлужебныйКлиент.ЗаписатьЖурналСканирования("ПолучитьНастройку.Старт", 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ПолучитьНастройку(%1, %2)", 
				ИмяУстройства, ИмяНастройки));        
				
		ЗначениеНастройки = ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].ПолучитьНастройку(ИмяУстройства, ИмяНастройки);
		
		РаботаСФайламиСлужебныйКлиент.ЗаписатьЖурналСканирования("ПолучитьНастройку.Результат", 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ПолучитьНастройку(%1, %2) = %3", 
				ИмяУстройства, ИмяНастройки, ЗначениеНастройки));
		
		Возврат ЗначениеНастройки;
	Исключение
		ПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		РаботаСФайламиСлужебныйКлиент.ЗаписатьЖурналСканирования("ПолучитьНастройку", ПредставлениеОшибки, Истина);
		Возврат -1;
	КонецПопытки;
	
КонецФункции // ПолучитьНастройку()

// Сохраняет в настройках цветность и разрешение
Процедура СохранитьВНастройкахПараметрыСканера(Разрешение, Цветность, Поворот, РазмерБумаги) Экспорт
	
	МассивСтруктур = Новый Массив;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиСканирования/Разрешение");
	Элемент.Вставить("Настройка", ИдентификаторКлиента);
	Элемент.Вставить("Значение", Разрешение);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиСканирования/Цветность");
	Элемент.Вставить("Настройка", ИдентификаторКлиента);
	Элемент.Вставить("Значение", Цветность);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиСканирования/Поворот");
	Элемент.Вставить("Настройка", ИдентификаторКлиента);
	Элемент.Вставить("Значение", Поворот);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиСканирования/РазмерБумаги");
	Элемент.Вставить("Настройка", ИдентификаторКлиента);
	Элемент.Вставить("Значение", РазмерБумаги);
	МассивСтруктур.Добавить(Элемент);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	
КонецПроцедуры	

#КонецОбласти