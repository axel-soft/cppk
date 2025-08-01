﻿////////////////////////////////////////////////////////////////////////////////
// Работа с картинками (клиент)
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Устанавливает компоненту сканирования
Процедура УстановитьКомпоненту(ОбработчикРезультата) Экспорт

	Если КомпонентаПолученияКартинкиИзБуфера = Неопределено Тогда
		КодВозврата = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаПолученияКартинкиИзБуфера", "ImageFromClipboard", ТипВнешнейКомпоненты.Native);
		
		Если КодВозврата Тогда
			Состояние(НСтр("ru = 'Компонента сканирования уже установлена.'"));
		Иначе
			
			ПараметрыВыполнения = Новый Структура;
			ПараметрыВыполнения.Вставить("ОбработчикРезультата", ОбработчикРезультата);
			
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"НачатьУстановкуВнешнейКомпонентыПродолжение",
				ЭтотОбъект,
				ПараметрыВыполнения);
			НачатьУстановкуВнешнейКомпоненты(ОписаниеОповещения, "ОбщийМакет.КомпонентаПолученияКартинкиИзБуфера");		
			Возврат;
			
		КонецЕсли;
		КомпонентаПолученияКартинкиИзБуфера = Новый("AddIn.ImageFromClipboard.AddInNativeExtension");	
	Иначе
		Состояние(НСтр("ru = 'Компонента сканирования уже установлена.'"));
	КонецЕсли;
	
КонецПроцедуры

// Продолжение установки компоненты
Процедура НачатьУстановкуВнешнейКомпонентыПродолжение(ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияДляПодключения = Новый Структура;
	ПараметрыВыполненияДляПодключения.Вставить("ОбработчикРезультата", ПараметрыВыполнения.ОбработчикРезультата);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"НачатьПодключениеВнешнейКомпонентыПродолжение",
		ЭтотОбъект,
		ПараметрыВыполненияДляПодключения);
	
	НачатьПодключениеВнешнейКомпоненты(ОписаниеОповещения, 
		"ОбщийМакет.КомпонентаПолученияКартинкиИзБуфера", 
		"ImageFromClipboard", 
		ТипВнешнейКомпоненты.Native);
	
КонецПроцедуры

// Продолжение установки компоненты
Процедура НачатьПодключениеВнешнейКомпонентыПродолжение(Подключена, ПараметрыВыполнения) Экспорт
	
	Если Подключена Тогда
	
		КомпонентаПолученияКартинкиИзБуфера = Новый("AddIn.ImageFromClipboard.AddInNativeExtension");	
		ВыполнитьОбработкуОповещения(ПараметрыВыполнения.ОбработчикРезультата, Подключена);
		
	КонецЕсли;
	
КонецПроцедуры

// Проинициализировать компоненту сканирования
Функция ПроинициализироватьКомпоненту() Экспорт
	
	Если КомпонентаПолученияКартинкиИзБуфера = Неопределено Тогда
		КодВозврата = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаПолученияКартинкиИзБуфера", "ImageFromClipboard", ТипВнешнейКомпоненты.Native);
		
		Если Не КодВозврата Тогда
			Возврат Ложь;
		КонецЕсли;

		КомпонентаПолученияКартинкиИзБуфера = Новый("AddIn.ImageFromClipboard.AddInNativeExtension");	
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Вернет версию компоненты сканирования
Функция ВерсияКомпоненты() Экспорт

	Если Не ПроинициализироватьКомпоненту() Тогда
		Возврат НСтр("ru= 'Компонента не установлена'");
	КонецЕсли;
	
	Возврат КомпонентаПолученияКартинкиИзБуфера.Версия();
	
КонецФункции // ВерсияКомпонентыСканирования()

// Объединяет картинки скажем png в один pdf файл
// 
// Параметры:
//  МассивПутейКартинок - Массив из Строка
//  ФайлРезультата - Строка
//  ПутьКПрограммеКонвертации - Строка 
//  РасширениеРезультата - Строка                 
//  СпособПреобразованияВPDF - Число
Процедура ОбъединитьВМногостраничныйФайл(МассивПутейКартинок, ФайлРезультата, ПутьКПрограммеКонвертации, 
	РасширениеРезультата, СпособПреобразованияВPDF) Экспорт      

	Если НРег(РасширениеРезультата) = "pdf" Тогда     
		
		Если СпособПреобразованияВPDF = 1 Тогда // image magick
			ПреобразоватьPngВPdf(МассивПутейКартинок, ФайлРезультата, "", ПутьКПрограммеКонвертации);
			
		Иначе  // встроенное
			
			ИзображенияДляОбъединения = Новый Массив;
			Для Каждого ПутьИсходногоФайла Из МассивПутейКартинок Цикл
				Картинка = Новый Картинка(ПутьИсходногоФайла);
				ИзображенияДляОбъединения.Добавить(Картинка);
			КонецЦикла;
			
			ТабличныйДокумент = РаботаСФайламиСлужебныйВызовСервера.НовыйТабличныйДокументНаСервере(
				ИзображенияДляОбъединения.Количество());
			Поток = Новый ПотокВПамяти();
			ТабличныйДокумент.Записать(Поток, ТипФайлаТабличногоДокумента.PDF);
			
			ДокументPDF = Новый ДокументPDF();
			ДокументPDF.Прочитать(Поток);
			Для ИндексОбъекта = 0 По ИзображенияДляОбъединения.ВГраница() Цикл
				Описание = Новый ОписаниеОтображаемогоОбъектаPDF;
				Описание.Имя           = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Изображение № %1'"), ИндексОбъекта);
				Изображение = ИзображенияДляОбъединения[ИндексОбъекта];
				Ширина = Изображение.Ширина();
				Высота = Изображение.Высота();
				ОтношениеА4 = 210/297;
				
				Если ОтношениеА4*Высота > Ширина Тогда
					Описание.Высота        = 269; //297
					Описание.Ширина        = Описание.Высота * Ширина/Высота; //210
				Иначе
					Описание.Ширина        = 190; //210
					Описание.Высота        = Описание.Ширина * Высота/Ширина; //297 
				КонецЕсли;
				Описание.Лево          = 0;
				Описание.Верх          = 0;
				Описание.НомерСтраницы = ИндексОбъекта+1;
				Описание.Объект        = Изображение;
				ДокументPDF.ДобавитьОтображаемыйОбъект(Описание);
			КонецЦикла;
			ДокументPDF.Записать(Поток);
			ДанныеРезультата = Поток.ЗакрытьИПолучитьДвоичныеДанные();    
			
			ДанныеРезультата.Записать(ФайлРезультата);
			
		КонецЕсли;
		
	ИначеЕсли НРег(РасширениеРезультата) = "tif" Тогда	           
		
		ИзображенияДляОбъединения = Новый Массив;
		Для Каждого ПутьИсходногоФайла Из МассивПутейКартинок Цикл
			Картинка = Новый Картинка(ПутьИсходногоФайла);
			ИзображенияДляОбъединения.Добавить(Картинка);
		КонецЦикла;
		
		ИзображениеTif = РаботаСФайламиСлужебныйВызовСервера.ОбъединитьИзображенияВTifФайл(ИзображенияДляОбъединения);
		ДанныеРезультата = ИзображениеTif.ПолучитьДвоичныеДанные();
		ДанныеРезультата.Записать(ФайлРезультата);
		
	КонецЕсли;	
	
КонецПроцедуры	

// Преобразует массив png в pdf                  
// 
// Параметры:
//  МассивНовыхPng - Массив Из Строка     
//  ИмяФайлаPdfНовое - Строка
//  ИмяBatФайла - Строка
//  ПутьКПрограммеКонвертации - Строка
//
Процедура ПреобразоватьPngВPdf(МассивНовыхPng, ИмяФайлаPdfНовое, ИмяBatФайла = "", ПутьКПрограммеКонвертации = "") Экспорт
	
	ТекущийКаталог = "";
	
	Если ИмяBatФайла = "" Тогда           
		
#Если НЕ ВебКлиент Тогда 	
		
		ИмяBatФайла = ПолучитьИмяВременногоФайла("bat");  
		
		ФайлБат = Новый Файл(ИмяBatФайла);
		ТекущийКаталог = ФайлБат.Путь;
		ФайлБат = Неопределено;
		
#КонецЕсли	
		
	КонецЕсли;	
	
	ФайлыКУдалению = Новый Массив;
	
	ПараметрыConvert = Новый Массив;
	Для Каждого ПутьИсходногоФайла Из МассивНовыхPng Цикл
		ПараметрыConvert.Добавить(ПутьИсходногоФайла);
	КонецЦикла;
	
	Параметры = СтрШаблон(" %1 %2",
		СтрСоединить(ПараметрыConvert, " "),
		ИмяФайлаPdfНовое);
	
	РаботаСКартинкамиКлиентСервер.ЗапуститьImageMagick(Параметры, ФайлыКУдалению, ИмяBatФайла, ПутьКПрограммеКонвертации,
		ТекущийКаталог);

КонецПроцедуры

// Разделяет pdf файл на набор png файлов
// 
// Параметры:
//  ФайлНаВходе - Строка     
//  ВременнаяПапкаДляРазархивирования - Строка
//  ПутьКПрограммеКонвертации - Строка
//  DPI - число
//
// Возвращаемое значение
//   Массив из Строка
Функция РазделитьМногоСтраничныйФайл(ФайлНаВходе, ВременнаяПапкаДляРазархивирования, ПутьКПрограммеКонвертации,DPI = 0) Экспорт      
	
	МассивПутейPng = ПреобразоватьPdfВPng(
		ФайлНаВходе, ВременнаяПапкаДляРазархивирования, ПутьКПрограммеКонвертации, DPI);
		
	Возврат МассивПутейPng;	
	
КонецФункции

// Преобразует pdf в массив png
// 
// Параметры:
//  ИмяФайлаPdf  - Строка
//  ВременнаяПапкаДляРазархивирования  -Строка
//   ПутьКПрограммеКонвертации - Строка
//  DPI - число
// 
// Возвращаемое значение:
//  Массив из Строка - Преобразовать pdf в png
Функция ПреобразоватьPdfВPng(ИмяФайлаPdf, ВременнаяПапкаДляРазархивирования, 
	ПутьКПрограммеКонвертации = "", DPI = 0) Экспорт
	
	Если DPI = 0 Тогда
		DPI = 150; ///КачествоПреобразованияPDFДляПредпросмотра();
	КонецЕсли;	
	
	МассивПутейPng = Новый Массив;
	
	ПутьНовогоФайла = ВременнаяПапкаДляРазархивирования;
	Если Прав(ПутьНовогоФайла, 1) <> ПолучитьРазделительПути() Тогда
		ПутьНовогоФайла = ПутьНовогоФайла + ПолучитьРазделительПути();
	КонецЕсли;	
	ПутьНовогоФайла = ПутьНовогоФайла + "res.png";
	
	ФайлыКУдалению = Новый Массив;
	
	Параметры = СтрШаблон("-density DPI %1 -strip -quality 0 %2",
		ИмяФайлаPdf,
		ПутьНовогоФайла);
	Параметры = СтрЗаменить(Параметры, "DPI", Строка(DPI));	

	ИмяBatФайла = ВременнаяПапкаДляРазархивирования + ПолучитьРазделительПути() + "cnv.bat";

	РаботаСКартинкамиКлиентСервер.ЗапуститьImageMagick(Параметры, ФайлыКУдалению, ИмяBatФайла, ПутьКПрограммеКонвертации, 
		ВременнаяПапкаДляРазархивирования);
	
	МассивФайлов = НайтиФайлы(ВременнаяПапкаДляРазархивирования, "res*.png");
	
	МассивПутей = Новый Массив;
	МассивСтруктур = Новый Массив;
	
	// отсортируем по дате
	Для Каждого Файл Из МассивФайлов Цикл
		
		ПутьФайла = Файл.ПолноеИмя;
		
		СтруктураФайла = Новый Структура("ПутьФайла, ИмяБезРасширения");
		СтруктураФайла.ПутьФайла = ПутьФайла;
		СтруктураФайла.ИмяБезРасширения = Файл.ИмяБезРасширения;
		
		МассивСтруктур.Добавить(СтруктураФайла);
		
	КонецЦикла;	
	
	ОбщегоНазначенияДокументооборотВызовСервера.СортироватьМассивПоЧислам(МассивСтруктур, МассивПутей);
	
	Для Каждого ПутьФайла Из МассивПутей Цикл
		МассивПутейPng.Добавить(ПутьФайла);
	КонецЦикла;	
	
	Возврат МассивПутейPng;

КонецФункции

#КонецОбласти