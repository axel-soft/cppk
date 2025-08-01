﻿#Область ПрограммныйИнтерфейс

// Проверяет орфографию переданного текста
// 
// Параметры:
//  ОбработчикРезультата - ОписаниеОповещения - Обработчик результата
//  ПроверяемыйТекст - Строка - Текст письма
//
Процедура ПроверитьОрфографиюТекст(ОбработчикРезультата, Знач ПроверяемыйТекст) Экспорт
	
	#Если МобильныйКлиент Тогда
		Возврат;
	#КонецЕсли

	#Если ВебКлиент Тогда
		Возврат;
	#КонецЕсли
		
	ПерсональныеНастройки = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами();
	СпособПроверкиОрфографии = ПерсональныеНастройки.СпособПроверкиОрфографии;
		
	ТекстДляПроверки = ПроверяемыйТекст;
	СловЗаменено = 0;
	СловПропущено = 0;
	
	ОбъектServiceManager = Неопределено;
	OOEmptyProps = Неопределено;
	OOlocale = Неопределено;
	OOSpellChecker = Неопределено;       
	
	Word = Неопределено;
	
	Попытка
		
#Если Не МобильныйКлиент И Не ВебКлиент Тогда
	
		Если СпособПроверкиОрфографии = ПредопределенноеЗначение("Перечисление.СпособыПроверкиОрфографии.MicrosoftOfficeWord") Тогда
	
			Word = Новый COMОбъект("Word.Application");
			Если Word.Documents.Count = 0 Тогда
				Word.Documents.Add();
			КонецЕсли;
			
		ИначеЕсли СпособПроверкиОрфографии = ПредопределенноеЗначение("Перечисление.СпособыПроверкиОрфографии.OpenOfficeOrgWriter") Тогда
				
			ОбъектServiceManager = Новый COMОбъект("com.sun.star.ServiceManager");
			
			OOEmptyProps = Новый COMSafeArray("VT_VARIANT", 0);
			
			OOlocale = ОбъектServiceManager.Bridge_GetStruct("com.sun.star.lang.Locale");
			OOlocale.Language="ru";
			OOlocale.Country="RU";
			
			OOSpellChecker = ОбъектServiceManager.createInstance("com.sun.star.linguistic2.SpellChecker");
		
		КонецЕсли;	
#КонецЕсли
				
	Исключение
		
		Word = Неопределено;
		ОбъектServiceManager = Неопределено;
		
		СтруктураВозврата = Новый Структура("ПроверяемыйТекст, ТекстИзменен", ПроверяемыйТекст, Ложь);
		ВыполнитьОбработкуОповещения(ОбработчикРезультата, СтруктураВозврата);
		
		Возврат;
		
	КонецПопытки;
		
	Текст = ТекстДляПроверки;
	
	Исключения = Новый Соответствие;
	СловаЗамены = Новый Соответствие;
	
	ВсеПрочиеСловаНеПроверяем = Ложь;
	НовыйТекстовыйДокумент = Новый ТекстовыйДокумент();
	
	НомерСтрокиНачальный = 1;
	ПозицияВСтроке = -1;
	СловоЗамены = "";
	СловоОригинальное = "";
	НомерСлова = -1;
	НомерСтрокиТекущий = -1;
	ПроверяемыйТекстРезультирующий = "";
	
	ПараметрыПроверкиОрфографииТекст = Новый Структура;
	ПараметрыПроверкиОрфографииТекст.Вставить("Текст", Текст);
	ПараметрыПроверкиОрфографииТекст.Вставить("НомерСтрокиНачальный", НомерСтрокиНачальный);
	ПараметрыПроверкиОрфографииТекст.Вставить("ПозицияВСтроке", ПозицияВСтроке); 
	ПараметрыПроверкиОрфографииТекст.Вставить("СловоОригинальное", СловоОригинальное);
	ПараметрыПроверкиОрфографииТекст.Вставить("СловоЗамены", СловоЗамены);
	ПараметрыПроверкиОрфографииТекст.Вставить("НомерСлова", НомерСлова);
	ПараметрыПроверкиОрфографииТекст.Вставить("ТекстДляПроверки", ТекстДляПроверки);
	
	ПараметрыПроверкиОрфографииТекст.Вставить("Word", Word);
	
	ПараметрыПроверкиОрфографииТекст.Вставить("ОбъектServiceManager", ОбъектServiceManager);
	ПараметрыПроверкиОрфографииТекст.Вставить("OOEmptyProps", OOEmptyProps);
	ПараметрыПроверкиОрфографииТекст.Вставить("OOlocale", OOlocale);
	ПараметрыПроверкиОрфографииТекст.Вставить("OOSpellChecker", OOSpellChecker);

	ПараметрыПроверкиОрфографииТекст.Вставить("СпособПроверкиОрфографии", СпособПроверкиОрфографии);
	
	ПараметрыПроверкиОрфографииТекст.Вставить("Исключения", Исключения); 
	ПараметрыПроверкиОрфографииТекст.Вставить("СловаЗамены", СловаЗамены); 
	ПараметрыПроверкиОрфографииТекст.Вставить("НомерСтрокиТекущий", НомерСтрокиТекущий);
	ПараметрыПроверкиОрфографииТекст.Вставить("СловЗаменено", СловЗаменено);
	ПараметрыПроверкиОрфографииТекст.Вставить("СловПропущено", СловПропущено);
	ПараметрыПроверкиОрфографииТекст.Вставить("Слово", "");
	
	ПараметрыПроверкиОрфографииТекст.Вставить("НоваяСтрока", "");
	ПараметрыПроверкиОрфографииТекст.Вставить("ВсеПрочиеСловаНеПроверяем", ВсеПрочиеСловаНеПроверяем);
	ПараметрыПроверкиОрфографииТекст.Вставить("НовыйТекстовыйДокумент", НовыйТекстовыйДокумент);
	ПараметрыПроверкиОрфографииТекст.Вставить("ДобавочныйСимвол", "");
	
	ПараметрыПроверкиОрфографииТекст.Вставить("ОбработчикРезультата", ОбработчикРезультата);
	ПараметрыПроверкиОрфографииТекст.Вставить("ПроверяемыйТекстРезультирующий", ПроверяемыйТекстРезультирующий);
	
	OOСловаИсключение = ЗагрузитьИсключенияOpenOffice(ПараметрыПроверкиОрфографииТекст);
	ПараметрыПроверкиОрфографииТекст.Вставить("OOСловаИсключение", OOСловаИсключение);
	
	ПроверитьОрфографиюВБлокеТекста();

КонецПроцедуры

// Добавляет слово в файл исключений Word
Процедура ДобавитьСловоВИсключенияWord(ПараметрыПроверкиОрфографии, Слово) Экспорт

#Если Не ВебКлиент И Не МобильныйКлиент Тогда
	Попытка
	
		Если ПараметрыПроверкиОрфографии.СпособПроверкиОрфографии 
			= ПредопределенноеЗначение("Перечисление.СпособыПроверкиОрфографии.MicrosoftOfficeWord") Тогда
	
			ПользовательскийСловарь = ПараметрыПроверкиОрфографии.Word.Application.CustomDictionaries.ActiveCustomDictionary;
		    ПолныйПутьФайла = ПользовательскийСловарь.Path + "\" + ПользовательскийСловарь.Name;
			
			Файл = Новый Файл(ПолныйПутьФайла);
			Если Не Файл.Существует() Тогда
				Возврат;
			КонецЕсли;	
			
			Кодировка = ОпределитьКодировкуТекстовогоФайла(ПолныйПутьФайла);
		
			// Дописывать = Истина
			ЗаписьТекста = Новый ЗаписьТекста(ПолныйПутьФайла, Кодировка, , Истина);
			ЗаписьТекста.ЗаписатьСтроку(Слово);
			ЗаписьТекста.Закрыть();
			
		ИначеЕсли ПараметрыПроверкиОрфографии.СпособПроверкиОрфографии 
			= ПредопределенноеЗначение("Перечисление.СпособыПроверкиОрфографии.OpenOfficeOrgWriter") Тогда
			
			Оболочка = Новый COMОбъект("WScript.Shell");
			КаталогДанныхПользователя = Оболочка.ExpandEnvironmentStrings("%APPDATA%");
			
			ПолныйПутьФайла = КаталогДанныхПользователя + "\OpenOffice\4\user\wordbook\standard.dic";
			
			Файл = Новый Файл(ПолныйПутьФайла);
			Если Не Файл.Существует() Тогда
				Возврат;
			КонецЕсли;	
			
			Кодировка = ОпределитьКодировкуТекстовогоФайла(ПолныйПутьФайла, "UTF-8");
		
			// Дописывать = Истина
			ЗаписьТекста = Новый ЗаписьТекста(ПолныйПутьФайла, Кодировка, , Истина);
			ЗаписьТекста.ЗаписатьСтроку(Слово);
			ЗаписьТекста.Закрыть();
			
		КонецЕсли;
		
	Исключение
		ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрацииКлиент(ОписаниеОшибки);
	КонецПопытки;
#КонецЕсли
	
КонецПроцедуры	

// Читает все исклчюения
// Параметры
//   ПараметрыПроверкиОрфографии - Структура
//
// Возвращаемое значение
//  Соответствие   - ключ - Строка, значение - число 1 (не используется)
Функция ЗагрузитьИсключенияOpenOffice(ПараметрыПроверкиОрфографии) Экспорт
	
	СловаИсключения = Новый Соответствие;
	
	Если Не ОбщегоНазначенияКлиент.ЭтоWindowsКлиент() Тогда    
		Возврат СловаИсключения;
	КонецЕсли;	

#Если Не ВебКлиент И Не МобильныйКлиент Тогда
	Попытка
	
		Если ПараметрыПроверкиОрфографии.СпособПроверкиОрфографии 
			= ПредопределенноеЗначение("Перечисление.СпособыПроверкиОрфографии.OpenOfficeOrgWriter") Тогда
			
			Оболочка = Новый COMОбъект("WScript.Shell");
			КаталогДанныхПользователя = Оболочка.ExpandEnvironmentStrings("%APPDATA%");
			
			ПолныйПутьФайла = КаталогДанныхПользователя + "\OpenOffice\4\user\wordbook\standard.dic";
			
			Файл = Новый Файл(ПолныйПутьФайла);
			Если Не Файл.Существует() Тогда
				Возврат СловаИсключения;
			КонецЕсли;	
			
			Кодировка = ОпределитьКодировкуТекстовогоФайла(ПолныйПутьФайла, "UTF-8");
		
			// Дописывать = Истина
			ЧтениеТекста = Новый ЧтениеТекста(ПолныйПутьФайла, Кодировка);
			Содержание = ЧтениеТекста.Прочитать();
			ЧтениеТекста.Закрыть();
			
			МассивСтрок = СтрРазделить(Содержание, Символы.ВК + Символы.ПС, Ложь);
			
			НашлиРазделитель = Ложь;
			Для Каждого Стр Из МассивСтрок Цикл
				
				Если Не НашлиРазделитель Тогда
					Если Стр <> "" И Лев(Стр, 1) = "-" Тогда
						НашлиРазделитель = Истина;
					КонецЕсли;
						
				Иначе
					
					СловаИсключения.Вставить(Стр, 1);
							
				КонецЕсли;	
				
			КонецЦикла;	 
			
		КонецЕсли;
		
	Исключение
		ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрацииКлиент(ОписаниеОшибки);
	КонецПопытки;
#КонецЕсли

	Возврат СловаИсключения;
	
КонецФункции	

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПроверитьОрфографиюВБлокеТекста() 
	
	СимволыРазделители = ПолучитьСимволыРазделители();
	
	Если Не ПараметрыПроверкиОрфографииТекст.Свойство("ТекстовыйДокумент") Тогда 
		ПараметрыПроверкиОрфографииТекст.Вставить("ТекстовыйДокумент", Новый ТекстовыйДокумент());	
		ПараметрыПроверкиОрфографииТекст.ТекстовыйДокумент.УстановитьТекст(ПараметрыПроверкиОрфографииТекст.Текст);
	КонецЕсли;		
	
	Если Не ПараметрыПроверкиОрфографииТекст.Свойство("КоличествоСтрокТекста") Тогда 
		ПараметрыПроверкиОрфографииТекст.Вставить(
			"КоличествоСтрокТекста", 
			ПараметрыПроверкиОрфографииТекст.ТекстовыйДокумент.КоличествоСтрок());
	КонецЕсли;	
	
	Если Не ПараметрыПроверкиОрфографииТекст.Свойство("НомерСтроки") Тогда 
		ПараметрыПроверкиОрфографииТекст.Вставить("НомерСтроки", ПараметрыПроверкиОрфографииТекст.НомерСтрокиНачальный);
	КонецЕсли;	
	
	Если Не ПараметрыПроверкиОрфографииТекст.Свойство("НомерПервогоСимвола") Тогда 
		ПараметрыПроверкиОрфографииТекст.Вставить("НомерПервогоСимвола", 1);
	КонецЕсли;	
	
	Если Не ПараметрыПроверкиОрфографииТекст.Свойство("НомерАнализируемогоСимвола") Тогда 
		ПараметрыПроверкиОрфографииТекст.Вставить("НомерАнализируемогоСимвола", 1);
	КонецЕсли;	
	
	ПараметрыПроверкиОрфографииТекст.НоваяСтрока = ПараметрыПроверкиОрфографииТекст.НоваяСтрока 
		+ ПараметрыПроверкиОрфографииТекст.Слово;
		
	Если СтрДлина(ПараметрыПроверкиОрфографииТекст.ДобавочныйСимвол) <> 0 Тогда
		ПараметрыПроверкиОрфографииТекст.НоваяСтрока = ПараметрыПроверкиОрфографииТекст.НоваяСтрока 
			+ ПараметрыПроверкиОрфографииТекст.ДобавочныйСимвол;
		ПараметрыПроверкиОрфографииТекст.ДобавочныйСимвол = "";
	КонецЕсли;
		
	ПараметрыПроверкиОрфографииТекст.Слово = "";	
	
	// Перебор строк
	Для СчСтроки = ПараметрыПроверкиОрфографииТекст.НомерСтроки 
		По ПараметрыПроверкиОрфографииТекст.КоличествоСтрокТекста Цикл
		
		ПараметрыПроверкиОрфографииТекст.НомерСтроки = СчСтроки;
		СтрокаСостояние = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Всего в тексте %1 строк. Проверяется %2 строка.'"),
			Строка(ПараметрыПроверкиОрфографииТекст.КоличествоСтрокТекста), 
			Строка(ПараметрыПроверкиОрфографииТекст.НомерСтроки));
		Состояние(СтрокаСостояние);
		
		// Получение строки, которую далее будем проверять
		СтрокаИзТекста = ПараметрыПроверкиОрфографииТекст.ТекстовыйДокумент.ПолучитьСтроку(ПараметрыПроверкиОрфографииТекст.НомерСтроки);
		
		Если ПараметрыПроверкиОрфографииТекст.ВсеПрочиеСловаНеПроверяем Тогда
			ПараметрыПроверкиОрфографииТекст.НовыйТекстовыйДокумент.ДобавитьСтроку(СтрокаИзТекста);
			Продолжить;
		КонецЕсли;	
		
		Если ПараметрыПроверкиОрфографииТекст.ПозицияВСтроке <> -1 
			И (ПараметрыПроверкиОрфографииТекст.НомерСтроки = ПараметрыПроверкиОрфографииТекст.НомерСтрокиНачальный) Тогда
			ПараметрыПроверкиОрфографииТекст.НомерПервогоСимвола = ПараметрыПроверкиОрфографииТекст.ПозицияВСтроке;
		Иначе	
			ПараметрыПроверкиОрфографииТекст.НомерПервогоСимвола = Найти(СтрокаИзТекста, """");
			Если ПараметрыПроверкиОрфографииТекст.НомерПервогоСимвола <> 0 Тогда
				ПараметрыПроверкиОрфографииТекст.НомерПервогоСимвола = ПараметрыПроверкиОрфографииТекст.НомерПервогоСимвола + 1;
			Иначе
				ПараметрыПроверкиОрфографииТекст.НомерПервогоСимвола = 1;
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыПроверкиОрфографииТекст.НомерСтрокиТекущий = ПараметрыПроверкиОрфографииТекст.НомерСтроки;
		
		ДлинаСтроки = СтрДлина(СтрокаИзТекста);
		ПараметрыПроверкиОрфографииТекст.НоваяСтрока = ПараметрыПроверкиОрфографииТекст.НоваяСтрока
			+ Лев(СтрокаИзТекста, ПараметрыПроверкиОрфографииТекст.НомерПервогоСимвола - 1);
		ПараметрыПроверкиОрфографииТекст.Слово       = "";
		СловоСобрано = Ложь;
		
		// Посимвольный обход строки для выделения и проверки слов
		Для СчСимволов = ПараметрыПроверкиОрфографииТекст.НомерАнализируемогоСимвола 
			По ДлинаСтроки Цикл
			
			ПараметрыПроверкиОрфографииТекст.НомерАнализируемогоСимвола = СчСимволов;
			
			Символ = Сред(СтрокаИзТекста, ПараметрыПроверкиОрфографииТекст.НомерАнализируемогоСимвола, 1);
			
			Если Найти(СимволыРазделители, Символ) <> 0 Тогда
				
				Если СтрДлина(ПараметрыПроверкиОрфографииТекст.Слово) = 0 Тогда
					ПараметрыПроверкиОрфографииТекст.НоваяСтрока = ПараметрыПроверкиОрфографииТекст.НоваяСтрока + Символ;
				Иначе
					ПараметрыПроверкиОрфографииТекст.ДобавочныйСимвол = Символ;
					СловоСобрано = Истина;
				КонецЕсли;
				
			Иначе
				
				ПараметрыПроверкиОрфографииТекст.Слово = ПараметрыПроверкиОрфографииТекст.Слово + Символ;
				Если ДлинаСтроки = ПараметрыПроверкиОрфографииТекст.НомерАнализируемогоСимвола Тогда 
					СловоСобрано = Истина;
				КонецЕсли;
				
			КонецЕсли;
			
			Если Не ПараметрыПроверкиОрфографииТекст.Свойство("Слово") Тогда 
				ПараметрыПроверкиОрфографииТекст.Вставить("Слово", "");
			КонецЕсли;	
			
			Если СловоСобрано Тогда
				
				Результат = ОрфографияОбработатьСлово(ПараметрыПроверкиОрфографииТекст.Слово, СтрокаИзТекста);
				СловоСобрано = Ложь;
				ПараметрыПроверкиОрфографииТекст.НомерАнализируемогоСимвола = 
					ПараметрыПроверкиОрфографииТекст.НомерАнализируемогоСимвола + 1;
				
				Если Не Результат Тогда
					// Процедура проверки прервана модальным окном и будет продолжена при его закрытии
					Возврат;
				КонецЕсли;	
				
				ПараметрыПроверкиОрфографииТекст.НоваяСтрока = ПараметрыПроверкиОрфографииТекст.НоваяСтрока 
					+ ПараметрыПроверкиОрфографииТекст.Слово;
					
				Если СтрДлина(ПараметрыПроверкиОрфографииТекст.ДобавочныйСимвол) <> 0 Тогда
					ПараметрыПроверкиОрфографииТекст.НоваяСтрока = ПараметрыПроверкиОрфографииТекст.НоваяСтрока 
						+ ПараметрыПроверкиОрфографииТекст.ДобавочныйСимвол;
					ПараметрыПроверкиОрфографииТекст.ДобавочныйСимвол = "";
				КонецЕсли;
					
				ПараметрыПроверкиОрфографииТекст.Слово = "";
				
			КонецЕсли;
			
		КонецЦикла;
		
		ПараметрыПроверкиОрфографииТекст.НоваяСтрока = ПараметрыПроверкиОрфографииТекст.НоваяСтрока 
			+ ПараметрыПроверкиОрфографииТекст.Слово;
		
		ПараметрыПроверкиОрфографииТекст.НомерАнализируемогоСимвола = 1;
		ПараметрыПроверкиОрфографииТекст.НовыйТекстовыйДокумент.ДобавитьСтроку(ПараметрыПроверкиОрфографииТекст.НоваяСтрока);
		ПараметрыПроверкиОрфографииТекст.НоваяСтрока = "";
		
	КонецЦикла;
	
	ЗавершитьПроверкуОрфографии();
	
КонецПроцедуры

Функция ОрфографияОбработатьСлово(Слово, СтрокаИзТекста)
				
	СловоНужноПроверитьWord = Истина;
	
	НаличиеСлова = ПараметрыПроверкиОрфографииТекст.Исключения.Получить(Слово);
	Если НаличиеСлова <> Неопределено Тогда
		СловоНужноПроверитьWord = Ложь;
		ПараметрыПроверкиОрфографииТекст.СловПропущено = ПараметрыПроверкиОрфографииТекст.СловПропущено + 1;
	КонецЕсли;	

	НаличиеСлова = ПараметрыПроверкиОрфографииТекст.OOСловаИсключение.Получить(Слово);
	Если НаличиеСлова <> Неопределено Тогда
		СловоНужноПроверитьWord = Ложь;
		ПараметрыПроверкиОрфографииТекст.СловПропущено = ПараметрыПроверкиОрфографииТекст.СловПропущено + 1;
	КонецЕсли;	
	
	ЗамененноеСлово = ПараметрыПроверкиОрфографииТекст.СловаЗамены.Получить(Слово);
	Если ЗамененноеСлово <> Неопределено Тогда
		Слово = ЗамененноеСлово;
		ПараметрыПроверкиОрфографииТекст.СловЗаменено = ПараметрыПроверкиОрфографииТекст.СловЗаменено + 1;
	КонецЕсли;	
	
	Если СловоНужноПроверитьWord Тогда
		
		Если ПараметрыПроверкиОрфографииТекст.СпособПроверкиОрфографии 
			= ПредопределенноеЗначение("Перечисление.СпособыПроверкиОрфографии.MicrosoftOfficeWord") Тогда
		
			Если Не ПараметрыПроверкиОрфографииТекст.Word.CheckSpelling(Слово) Тогда
				
				СписокВариантов = Новый СписокЗначений;
				
				ВариантыЗамены = ПараметрыПроверкиОрфографииТекст.Word.getSpellingSuggestions(Слово);
				
				Если ВариантыЗамены.Count <> 0 Тогда
					Для НомерВарианта = 1 По ВариантыЗамены.Count Цикл
						СписокВариантов.Добавить(ВариантыЗамены.Item(НомерВарианта).Name);
					КонецЦикла;
				КонецЕсли;
				
				ПараметрыФормы = Новый Структура("ИсходнаяСтрока,СловоЗамены,СписокВариантов,ПараметрыПроверкиОрфографииТекст");
				ПараметрыФормы.ИсходнаяСтрока = СокрЛП(СтрокаИзТекста);
				ПараметрыФормы.СловоЗамены = Слово;
				ПараметрыФормы.СписокВариантов = СписокВариантов.Скопировать();
				
				ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершениеПроверкиОрфографииВБлокеТекста", ЭтотОбъект);
				ОткрытьФорму(
					"Документ.ИсходящееПисьмо.Форма.ПроверкаОрфографии", 
					ПараметрыФормы,
					,,,,
					ОписаниеОповещения,
					РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
					
				Возврат Ложь;	
				
			КонецЕсли;
			
		ИначеЕсли ПараметрыПроверкиОрфографииТекст.СпособПроверкиОрфографии 
			= ПредопределенноеЗначение("Перечисление.СпособыПроверкиОрфографии.OpenOfficeOrgWriter") Тогда	
			
			Альтернативы = ПараметрыПроверкиОрфографииТекст.OOSpellChecker.spell(
				Слово, ПараметрыПроверкиОрфографииТекст.OOlocale, ПараметрыПроверкиОрфографииТекст.OOEmptyProps );
			
			Если Альтернативы <> Неопределено Тогда
				
				СписокВариантов = Новый СписокЗначений;	
				
				aAlternatives = Альтернативы.getAlternatives();
				Для Каждого Стр Из aAlternatives Цикл
					СписокВариантов.Добавить(Стр);
				КонецЦикла;	  

				ПараметрыФормы = Новый Структура("ИсходнаяСтрока,СловоЗамены,СписокВариантов,ПараметрыПроверкиОрфографииТекст");
				ПараметрыФормы.ИсходнаяСтрока = СокрЛП(СтрокаИзТекста);
				ПараметрыФормы.СловоЗамены = Слово;
				ПараметрыФормы.СписокВариантов = СписокВариантов.Скопировать();
				
				ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершениеПроверкиОрфографииВБлокеТекста", ЭтотОбъект);
				ОткрытьФорму(
					"Документ.ИсходящееПисьмо.Форма.ПроверкаОрфографии", 
					ПараметрыФормы,
					,,,,
					ОписаниеОповещения,
					РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
					
				Возврат Ложь;	
				 
			КонецЕсли;		  	
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Завершение обработки блока текста
Процедура ЗавершениеПроверкиОрфографииВБлокеТекста(КодВозврата, Параметр) Экспорт
	
	Если ТипЗнч(КодВозврата) <> Тип("Структура") Тогда
		ПараметрыПроверкиОрфографииТекст.ВсеПрочиеСловаНеПроверяем = Истина;
		Кнопка = "Завершить";
	Иначе
		Кнопка = КодВозврата.Кнопка;
	КонецЕсли;	
	
	Если Кнопка = "Завершить" Тогда
		ПараметрыПроверкиОрфографииТекст.ВсеПрочиеСловаНеПроверяем = Истина;
	КонецЕсли;
	
	Если Кнопка = "ПропуститьВсе" Тогда
		ПараметрыПроверкиОрфографииТекст.Исключения.Вставить(ПараметрыПроверкиОрфографииТекст.Слово, 1);
		ПараметрыПроверкиОрфографииТекст.СловПропущено = ПараметрыПроверкиОрфографииТекст.СловПропущено + 1;
	КонецЕсли;
	
	Если Кнопка = "Пропустить" Тогда
		ПараметрыПроверкиОрфографииТекст.СловПропущено = ПараметрыПроверкиОрфографииТекст.СловПропущено + 1;
	КонецЕсли;
	
	Если Кнопка = "Заменить" Тогда
		
		ПараметрыПроверкиОрфографииТекст.СловоОригинальное = ПараметрыПроверкиОрфографииТекст.Слово;
		ПараметрыПроверкиОрфографииТекст.СловоЗамены = КодВозврата.СловоЗамены;
		ПараметрыПроверкиОрфографииТекст.Слово = КодВозврата.СловоЗамены;
		ПараметрыПроверкиОрфографииТекст.СловЗаменено = ПараметрыПроверкиОрфографииТекст.СловЗаменено + 1;
		
	КонецЕсли;
	
	Если Кнопка = "ЗаменитьВсе" Тогда
		
		ПараметрыПроверкиОрфографииТекст.СловоЗамены = КодВозврата.СловоЗамены;
		ПараметрыПроверкиОрфографииТекст.СловаЗамены.Вставить(ПараметрыПроверкиОрфографииТекст.Слово, ПараметрыПроверкиОрфографииТекст.СловоЗамены);
		ПараметрыПроверкиОрфографииТекст.СловоОригинальное = ПараметрыПроверкиОрфографииТекст.Слово;
		ПараметрыПроверкиОрфографииТекст.Слово = КодВозврата.СловоЗамены;
		
		ПараметрыПроверкиОрфографииТекст.СловЗаменено = ПараметрыПроверкиОрфографииТекст.СловЗаменено + 1;
		
	КонецЕсли;
	
	Если Кнопка = "ДобавитьИсключение" Тогда
		
		ПараметрыПроверкиОрфографииТекст.Исключения.Вставить(ПараметрыПроверкиОрфографииТекст.Слово, 1);
		ДобавитьСловоВИСключенияWord(
			ПараметрыПроверкиОрфографииТекст, 
			ПараметрыПроверкиОрфографииТекст.Слово);
			
	КонецЕсли;
	
	ПроверитьОрфографиюВБлокеТекста(); 
	
КонецПроцедуры

Процедура ЗавершитьПроверкуОрфографии()
	
	Текст = ПараметрыПроверкиОрфографииТекст.НовыйТекстовыйДокумент.ПолучитьТекст();
	Если Прав(Текст, 1) = Символы.ПС Тогда
		Текст = Лев(Текст, СтрДлина(Текст)-1);
	КонецЕсли;
	
	ПроверяемыйТекст = ПараметрыПроверкиОрфографииТекст.ТекстДляПроверки;
	ТекстИзменен = Ложь;
	
	Если СокрЛП(ПараметрыПроверкиОрфографииТекст.ТекстДляПроверки) <> СокрЛП(Текст) Тогда
		
		// Для текстового письма целиком собираем новый текст (с исправленными словами) и ставим его письму.
		ПроверяемыйТекст = Текст;
		ТекстИзменен = Истина;
		
	КонецЕсли;
	
	Если ПараметрыПроверкиОрфографииТекст.СпособПроверкиОрфографии = ПредопределенноеЗначение("Перечисление.СпособыПроверкиОрфографии.MicrosoftOfficeWord") Тогда
		
		ПараметрыПроверкиОрфографииТекст.Word.Quit();
		ПараметрыПроверкиОрфографииТекст.Word = Неопределено;
		
	ИначеЕсли ПараметрыПроверкиОрфографииТекст.СпособПроверкиОрфографии = ПредопределенноеЗначение("Перечисление.СпособыПроверкиОрфографии.OpenOfficeOrgWriter") Тогда
		
		ПараметрыПроверкиОрфографииТекст.ОбъектServiceManager = Неопределено;
		ПараметрыПроверкиОрфографииТекст.OOSpellChecker = Неопределено;
			
	КонецЕсли;
	
	Состояние();
	
	ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Проверка орфографии завершена. 
		|Заменено слов: %1, пропущено слов: %2.'"),
		ПараметрыПроверкиОрфографииТекст.СловЗаменено, ПараметрыПроверкиОрфографииТекст.СловПропущено);
		
	ПоказатьПредупреждение(, ТекстПредупреждения);
	
	СтруктураВозврата = Новый Структура("ПроверяемыйТекст, ТекстИзменен", ПроверяемыйТекст, ТекстИзменен);
	ВыполнитьОбработкуОповещения(ПараметрыПроверкиОрфографииТекст.ОбработчикРезультата, СтруктураВозврата);
	
	ПараметрыПроверкиОрфографииТекст = Неопределено;
	
КонецПроцедуры

// Возвращает символы -разделители
Функция ПолучитьСимволыРазделители() 
	
	СимволыРазделители = " .,;:?!-+*/\%=<>[](){}""'|~@#$^&_";
	СимволыРазделители = СимволыРазделители + Символ(9) + Символ(10) + Символ(13) + Символ(160);
	Возврат СимволыРазделители;
	
КонецФункции	

// Вычисляет кодировку 
Функция ОпределитьКодировкуТекстовогоФайла(ПолноеИмяФайла, кодировкаПоУмолчанию = "windows-1251") 
	
	Кодировка = Неопределено;
	
#Если Не ВебКлиент И Не МобильныйКлиент Тогда	
	
	// Определяем кодировку
		
	ЧтениеТекста = Новый ЧтениеТекста(ПолноеИмяФайла, КодировкаТекста.Системная);
	
	// Проверяем наличие BOM (Byte order mark)
	Символ0 = ЧтениеТекста.Прочитать(1);
	Символ1 = ЧтениеТекста.Прочитать(1);
	Символ2 = ЧтениеТекста.Прочитать(1);
	
	КодСимвола0 = КодСимвола(Символ0);
	КодСимвола1 = КодСимвола(Символ1);
	КодСимвола2 = КодСимвола(Символ2);
	
	Если КодСимвола0 = 1087 И КодСимвола1 = 187 И КодСимвола2 = 1111 Тогда
		Кодировка = "UTF-8";
	ИначеЕсли КодСимвола0 = 1103 И КодСимвола1 = 1102 Тогда
		Кодировка = "UTF-16";
	Иначе	
		Кодировка = кодировкаПоУмолчанию;
	КонецЕсли;
		
#КонецЕсли

	Возврат Кодировка;
	
КонецФункции

// Делает запись в журнал регистрации
Процедура ЗаписьЖурналаРегистрацииКлиент(ТекстСообщения)
	
	ТекстСообщения = РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(ТекстСообщения);
	ОрфографияВызовСервера.ЗаписьВЖурналРегистрации(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти