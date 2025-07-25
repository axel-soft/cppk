﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВладелецФайлов = Параметры.ВладелецФайлов;
	ДатаСканирования = Параметры.ДатаСканирования;
	
	Если Параметры.Свойство("Файлы") Тогда // открываем из формы успешно размещенных
		
		Файлы = Параметры.Файлы;
	
		Для Каждого Файл Из Файлы Цикл
			Строка = ТаблицаФайлов.Добавить();
			Строка.Файл = Файл.Значение;
			Строка.Представление = Строка(Файл.Значение);
			Строка.Расширение = Строка.Файл.ТекущаяВерсияРасширение;
			Строка.ИндексКартинки = ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(Строка.Файл.ТекущаяВерсияРасширение);
		КонецЦикла;	
		
	Иначе	// открываем из списка истории
		
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	РезультатыПотоковогоСканирования.Файл КАК Файл
			|ИЗ
			|	РегистрСведений.РезультатыПотоковогоСканирования КАК РезультатыПотоковогоСканирования
			|ГДЕ
			|	РезультатыПотоковогоСканирования.Объект = &Объект
			|	И РезультатыПотоковогоСканирования.Пользователь = &Пользователь
			|	И РезультатыПотоковогоСканирования.ДатаСеансаСканирования = &ДатаСеансаСканирования";

		Запрос.УстановитьПараметр("ДатаСеансаСканирования", ДатаСканирования);
		Запрос.УстановитьПараметр("Объект", ВладелецФайлов);
		Запрос.УстановитьПараметр("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());

		Результат = Запрос.Выполнить();

		Выборка = Результат.Выбрать();

		Пока Выборка.Следующий() Цикл
			Строка = ТаблицаФайлов.Добавить();
			Строка.Файл = Выборка.Файл;
			Строка.Представление = Строка(Выборка.Файл);
			Строка.Расширение = Строка.Файл.ТекущаяВерсияРасширение;
			Строка.ИндексКартинки = ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(Строка.Файл.ТекущаяВерсияРасширение);
		КонецЦикла;

	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ТаблицаФайлов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НомерТекущейСТроки = Элементы.ТаблицаФайлов.ТекущаяСтрока;
	СтрокаТаблицы = Элементы.ТаблицаФайлов.ДанныеСтроки(НомерТекущейСТроки);
	
	Расширение = СтрокаТаблицы.Расширение;
	Расширение = НРег(Расширение);
	Если Расширение = "pdf" Тогда
		АдресКартинки = "";
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Предпросмотр) Тогда

			СтрокаHtml = ПолучитьСтрокуПредпросмотраPDF(СтрокаТаблицы.Файл, УникальныйИдентификатор);
			СтрокаТаблицы.Предпросмотр = СтрокаHtml;
		
		Иначе

			СтрокаHtml = СтрокаТаблицы.Предпросмотр;
				
		КонецЕсли;	
		
		Элементы.ГруппаПревью.ТекущаяСтраница = Элементы.ГруппаHtml;
		
		Возврат;
	КонецЕсли;	
	
	Элементы.ГруппаПревью.ТекущаяСтраница = Элементы.ГруппаКартинка;
	
	Если ТекущийФайл <> СтрокаТаблицы.Файл Тогда
		
		Если ПустаяСтрока(СтрокаТаблицы.АдресКартинки) Тогда
			 КодВозврата = РаботаСФайламиВызовСервера.ДанныеФайлаИНавигационнаяСсылкаВерсииВоВременномХранилище(СтрокаТаблицы.Файл, Неопределено, УникальныйИдентификатор);
			 СтрокаТаблицы.АдресКартинки = КодВозврата.НавигационнаяСсылкаВерсии;
		КонецЕсли;	
		
		АдресКартинки = СтрокаТаблицы.АдресКартинки;
		
		ТекущийФайл = СтрокаТаблицы.Файл;
	КонецЕсли;	

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтрокуПредпросмотраPDF(Файл, УникальныйИдентификатор)
	
	ПредпросмотрУрезан = Ложь;
	
	Попытка
		НеПолучатьВизуализациюЭП = Истина;
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(
			Файл, 
			, 
			УникальныйИдентификатор,
			,
			,
			НеПолучатьВизуализациюЭП);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат СтрШаблон(
			НСтр("ru = '<html><body>Не удалось сформировать предпросмотр по причине: <br><br> %1</body></html>'"),
			ТекстОшибки);
		 // файл мог быть удален полностью.
	КонецПопытки;	
	
	ДвоичныеДанныеКартинок = ОбзорФайловВызовСервера.МассивДвоичныхДанныхКартинокИзPdf(
		ДанныеФайла, ПредпросмотрУрезан);

	ПредставлениеHTMLФайла = "<!DOCTYPE html>
				|<html>
				|<body>
				|<table width=100%>";
				
	НомерСтраницы = 0;			
				
	Для Каждого ДвДанные Из ДвоичныеДанныеКартинок Цикл
		
		ЗашифрованныеДанные = Base64Строка(ДвДанные);
		
		ПредставлениеHTMLФайла =  ПредставлениеHTMLФайла +
			"<tr><td width=100%>"
			+ "<img width=100% src=""data:image/" + "png" + ";base64," 
			+ ЗашифрованныеДанные + """>"
			+ "</td></tr>" 
			+ Символы.ПС;
		
		// номер страницы
		ПредставлениеHTMLФайла =  ПредставлениеHTMLФайла +
			"<tr><td>"
			+ Строка(НомерСтраницы + 1) 
			+ "</td></tr>" 
			+ Символы.ПС;
			
		НомерСтраницы = НомерСтраницы + 1;	
		
	КонецЦикла;				
				
	ПредставлениеHTMLФайла =  ПредставлениеHTMLФайла + 
				"</table>
				|</body>
				|</html>";
				
	Возврат ПредставлениеHTMLФайла;			
	
КонецФункции

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ТекущийФайл = Элементы.ТаблицаФайлов.ТекущиеДанные.Файл;
	ПараметрыОткрытияФормы = Новый Структура("Ключ", ТекущийФайл);
	ОткрытьФорму("Справочник.Файлы.ФормаОбъекта", ПараметрыОткрытияФормы);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	ОткрытьФайлВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлВыполнить()
	
	ТекущийФайл = Элементы.ТаблицаФайлов.ТекущиеДанные.Файл;
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(ТекущийФайл, , УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьФайлВыполнить();
КонецПроцедуры
