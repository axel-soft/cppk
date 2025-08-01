﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьРаспознавание = РаботаСФайламиВызовСервера.ПолучитьИспользоватьРаспознавание();
	ДоступноРаспознаваниеПоЗапросу = РаботаСФайламиВызовСервера.ДоступноРаспознаваниеПоЗапросу();
	
	Если ИспользоватьРаспознавание = Ложь Или ДоступноРаспознаваниеПоЗапросу = Ложь Тогда
		Элементы.ГруппаРаспознавание.Видимость = Ложь;
		Элементы.ГруппаСтраниц.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	Если Параметры.Свойство("СтратегияРаспознавания") Тогда
		СтратегияРаспознавания = Параметры.СтратегияРаспознавания;
	Иначе	
		СтратегияРаспознавания = Перечисления.СтратегииРаспознаванияТекста.ПоместитьТолькоВТекстовыйОбраз;
	КонецЕсли;
	
	ПрограммаРаспознавания = РаботаСФайламиВызовСервера.ПрограммаРаспознавания();
	
	Если ПрограммаРаспознавания = Перечисления.ПрограммыРаспознавания.СервисРаспознавания Тогда
		РаспознаватьФайлы = 
			(СтратегияРаспознавания = Перечисления.СтратегииРаспознаванияТекста.ПоместитьТолькоВТекстовыйОбраз);
		Элементы.СтратегияРаспознавания.Видимость = Ложь;
	Иначе
		Элементы.РаспознаватьФайлы.Видимость = Ложь;
	КонецЕсли;
	
	ЯзыкиРаспознавания = РаботаСФайламиВызовСервера.ЯзыкиРаспознаванияПрограммы(
		ПрограммаРаспознавания);
	Для Каждого Запись Из ЯзыкиРаспознавания Цикл
		Элементы.ЯзыкРаспознавания.СписокВыбора.Добавить(Запись.Language, Запись.Name);
	КонецЦикла;
	
	Если Параметры.Свойство("ЯзыкРаспознавания") Тогда
		ЯзыкРаспознавания = Параметры.ЯзыкРаспознавания;
	Иначе	
		ЯзыкРаспознавания = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Распознавание", "ЯзыкРаспознавания");
	КонецЕсли;
	
	Если Элементы.ЯзыкРаспознавания.СписокВыбора.НайтиПоЗначению(ЯзыкРаспознавания) = Неопределено
		Или ЯзыкРаспознавания = "" Тогда
		
		ЯзыкРаспознавания = РаботаСФайламиВызовСервера.ЯзыкРаспознаванияПрограммыПоУмолчанию(
			ПрограммаРаспознавания);
	КонецЕсли;
	
	Если Элементы.ЯзыкРаспознавания.СписокВыбора.Количество() = 1 Тогда
		Элементы.ЯзыкРаспознавания.Видимость = Ложь;
		Элементы.ДекорацияЯзыкРаспознавания.Заголовок = Элементы.ДекорацияЯзыкРаспознавания.Заголовок
			+ Элементы.ЯзыкРаспознавания.СписокВыбора.НайтиПоЗначению(ЯзыкРаспознавания).Представление;
	Иначе
		Элементы.ДекорацияЯзыкРаспознавания.Видимость = Ложь;
	КонецЕсли;
	
	Разрешение = Параметры.Разрешение;
	Цветность = Параметры.Цветность;
	Поворот = Параметры.Поворот;
	РазмерБумаги = Параметры.РазмерБумаги;
	ДвустороннееСканирование = Параметры.ДвустороннееСканирование;
	ИспользоватьImageMagickДляПреобразованияВPDF = Параметры.ИспользоватьImageMagickДляПреобразованияВPDF;
	ПоказыватьДиалогСканера = Параметры.ПоказыватьДиалогСканера;
	ФорматСканированногоИзображения = Параметры.ФорматСканированногоИзображения;
	КачествоJPG = Параметры.КачествоJPG;
	СжатиеTIFF = Параметры.СжатиеTIFF;
	ФорматХраненияОдностраничный = Параметры.ФорматХраненияОдностраничный;
	ФорматХраненияМногостраничный = Параметры.ФорматХраненияМногостраничный;
	
	Элементы.Поворот.Видимость = Параметры.ДоступностьПоворот;
	Элементы.РазмерБумаги.Видимость = Параметры.ДоступностьРазмерБумаги;
	Элементы.ДвустороннееСканирование.Видимость = Параметры.ДоступностьДвустороннееСканирование;
	
	ФорматJPG = Перечисления.ФорматыСканированногоИзображения.JPG;
	ФорматTIF = Перечисления.ФорматыСканированногоИзображения.TIF;
	
	ФорматМногостраничныйTIF = Перечисления.ФорматыХраненияМногостраничныхФайлов.TIF;
	ФорматОдностраничныйPDF = Перечисления.ФорматыХраненияОдностраничныхФайлов.PDF;
	ФорматОдностраничныйJPG = Перечисления.ФорматыХраненияОдностраничныхФайлов.JPG;
	ФорматОдностраничныйTIF = Перечисления.ФорматыХраненияОдностраничныхФайлов.TIF;
	ФорматОдностраничныйPNG = Перечисления.ФорматыХраненияОдностраничныхФайлов.PNG;
	
	Элементы.ГруппаФорматаХранения.Видимость = ИспользоватьImageMagickДляПреобразованияВPDF;
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = ФорматОдностраничныйPDF Тогда
			Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
		Иначе	
			Элементы.КачествоJPG.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйTIF);
		КонецЕсли;
	Иначе	
		Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
		Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
	КонецЕсли;
	
	ВидимостьДекораций = (ИспользоватьImageMagickДляПреобразованияВPDF И (ФорматХраненияОдностраничный = ФорматОдностраничныйPDF));
	Элементы.ДекорацияФорматХраненияОдностраничный.Видимость = ВидимостьДекораций;
	Элементы.ДекорацияФорматСканированногоИзображения.Видимость = ВидимостьДекораций;
	
	ВидимостьФорматаСканирования = (ИспользоватьImageMagickДляПреобразованияВPDF И (ФорматХраненияОдностраничный = ФорматОдностраничныйPDF)) ИЛИ (НЕ ИспользоватьImageMagickДляПреобразованияВPDF);
	Элементы.ГруппаФорматаСканирования.Видимость = ВидимостьФорматаСканирования;
	
	ФорматХраненияОдностраничныйПредыдущее = ФорматХраненияОдностраничный;
	
	Если НЕ ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Элементы.ФорматСканированногоИзображения.Заголовок = НСтр("ru = 'Формат'");
	Иначе
		Элементы.ФорматСканированногоИзображения.Заголовок = НСтр("ru = 'Тип'");
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФорматХраненияОдностраничныйПриИзменении(Элемент)
	
	ОтработатьИзмененияФорматХраненияОдностраничный();
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматСканированногоИзображенияПриИзменении(Элемент)
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = ФорматОдностраничныйPDF Тогда
			Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
		Иначе	
			Элементы.КачествоJPG.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйTIF);
		КонецЕсли;
	Иначе	
		Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
		Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспознаватьФайлыПриИзменении(Элемент)
	
	Если РаспознаватьФайлы Тогда
		СтратегияРаспознавания = ПредопределенноеЗначение(
			"Перечисление.СтратегииРаспознаванияТекста.ПоместитьТолькоВТекстовыйОбраз");
	Иначе
		СтратегияРаспознавания = ПредопределенноеЗначение(
			"Перечисление.СтратегииРаспознаванияТекста.НеРаспознавать");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)

	Если Не ЗначениеЗаполнено(Разрешение) Тогда
		Разрешение = ПредопределенноеЗначение("Перечисление.РазрешенияСканированногоИзображения.dpi200");
	КонецЕсли;	
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("ПоказыватьДиалогСканера",  ПоказыватьДиалогСканера);
	РезультатВыбора.Вставить("Разрешение",               Разрешение);
	РезультатВыбора.Вставить("Цветность",                Цветность);
	РезультатВыбора.Вставить("Поворот",                  Поворот);
	РезультатВыбора.Вставить("РазмерБумаги",             РазмерБумаги);
	РезультатВыбора.Вставить("ДвустороннееСканирование", ДвустороннееСканирование);
	
	РезультатВыбора.Вставить("ИспользоватьImageMagickДляПреобразованияВPDF",
		ИспользоватьImageMagickДляПреобразованияВPDF);
	
	РезультатВыбора.Вставить("ФорматСканированногоИзображения", ФорматСканированногоИзображения);
	РезультатВыбора.Вставить("КачествоJPG",                     КачествоJPG);
	РезультатВыбора.Вставить("СжатиеTIFF",                      СжатиеTIFF);
	РезультатВыбора.Вставить("ФорматХраненияОдностраничный",    ФорматХраненияОдностраничный);
	РезультатВыбора.Вставить("ФорматХраненияМногостраничный",   ФорматХраненияМногостраничный);
	РезультатВыбора.Вставить("СтратегияРаспознавания",   		СтратегияРаспознавания);
	РезультатВыбора.Вставить("ЯзыкРаспознавания",   			ЯзыкРаспознавания);
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПреобразоватьФорматХраненияВФорматСканирования(ФорматХранения)
	
	Если ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.BMP Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.BMP;
	ИначеЕсли ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.GIF Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.GIF;
	ИначеЕсли ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.JPG Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.JPG;
	ИначеЕсли ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.PNG Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.PNG; 
	ИначеЕсли ФорматХранения = Перечисления.ФорматыХраненияОдностраничныхФайлов.TIF Тогда
		Возврат Перечисления.ФорматыСканированногоИзображения.TIF;
	КонецЕсли;
	
	Возврат ФорматСканированногоИзображения; 
	
КонецФункции	

&НаСервере
Процедура ОтработатьИзмененияФорматХраненияОдностраничный()
	
	Элементы.ГруппаФорматаСканирования.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйPDF);
	
	Если ФорматХраненияОдностраничный = ФорматОдностраничныйPDF Тогда
		ФорматСканированногоИзображения = ПреобразоватьФорматХраненияВФорматСканирования(ФорматХраненияОдностраничныйПредыдущее);
	КонецЕсли;	
	
	ВидимостьДекораций = (ИспользоватьImageMagickДляПреобразованияВPDF И (ФорматХраненияОдностраничный = ФорматОдностраничныйPDF));
	Элементы.ДекорацияФорматХраненияОдностраничный.Видимость = ВидимостьДекораций;
	Элементы.ДекорацияФорматСканированногоИзображения.Видимость = ВидимостьДекораций;
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = ФорматОдностраничныйPDF Тогда
			Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
		Иначе	
			Элементы.КачествоJPG.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйJPG);
			Элементы.СжатиеTIFF.Видимость = (ФорматХраненияОдностраничный = ФорматОдностраничныйTIF);
		КонецЕсли;
	Иначе	
		Элементы.КачествоJPG.Видимость = (ФорматСканированногоИзображения = ФорматJPG);
		Элементы.СжатиеTIFF.Видимость = (ФорматСканированногоИзображения = ФорматTIF);
	КонецЕсли;
	
	ФорматХраненияОдностраничныйПредыдущее = ФорматХраненияОдностраничный;
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматХраненияОдностраничныйОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ФорматСканированногоИзображенияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура РазрешениеОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти