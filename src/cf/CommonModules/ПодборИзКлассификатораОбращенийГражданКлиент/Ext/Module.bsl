﻿
#Область ПрограммыйИнтерфейс

// Обработчик события "ПриАктивацииСтроки" списка "Разделов", "Тем", "Тематик" или "Вопросов"
//
Процедура ОбработчикСобытияТаблицыФормыПриАктивизацииСтроки(Форма, Элемент) Экспорт
	
	Если Форма.ЭтоРедактированиеКодаВопроса Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьКодВопросаПоСоставляющим(Форма, ТекущиеДанные.Ссылка, ТекущиеДанные.Код);
	
КонецПроцедуры

// Анализирует переданный код вопроса и находит соответствующий коду элемент.
//
// Параметры:
//    Форма - ФормаКлиентскогоПриложения - Форма вызова.
//    Текст - Строка - введенный текстовый код.
//    СтандартнаяОбработка  - Булево - признак стандартной обработки.
//
Процедура ПроанализироватьКодВопросаПолучитьСоставляющие(Форма, Текст, СтандартнаяОбработка) Экспорт
	
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	Индекс		= 0;
	МассивПолей = СтрРазделить(Текст, ".");	
	Для Каждого Поле Из МассивПолей Цикл
		КодЭлемента = МассивПолей[Индекс];
		Если ЗначениеЗаполнено(КодЭлемента) И СтрДлина(КодЭлемента) = 4 Тогда
			ОписаниеЭлемента = Форма.КэшДанныхФормы.ЭлементыКлассификатора[Индекс];
			
			ЗначениеЭлементаКлассификатора = ПодборИзКлассификатораОбращенийГражданВызовСервера.ПолучитьЭлементКлассификатора(
				ОписаниеЭлемента.Тип,
				КодЭлемента);	
			
			Форма[ОписаниеЭлемента.ПолеФормы] = ЗначениеЭлементаКлассификатора;
			Форма.Элементы[ОписаниеЭлемента.ТаблицаФормы].ТекущаяСтрока = ЗначениеЭлементаКлассификатора;
		КонецЕсли;
		Индекс = Индекс + 1;
	КонецЦикла;
	
	Форма.КодВопроса = Текст;
	
КонецПроцедуры

// Проверяет корректность заполнения ключевых полей формы.
//
// Параметры:
//    Форма - ФормаКлиентскогоПриложения - Форма вызова.
//
// Возвращаемое значение:
//    Истина - Булево - Если все ключевые поля заполнены
//    Ложь - в противном случае.
//
Функция КлючевыеПоляЗаполнены(Форма) Экспорт
	
	Если Не ЗначениеЗаполнено(Форма.КодВопроса) 
			Или Не Форма.КэшДанныхФормы.СхемаКодаВопроса.Количество() = СтрРазделить(Форма.КодВопроса, ".", Ложь).Количество() Тогда
		Заполнены = Ложь;
		
		ТекстОшибки = Нстр("ru = 'Указан некорректный код вопроса.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "КодВопроса");
		
		Возврат Ложь;
	КонецЕсли;
	
	ТекстОшибки = "";
	Если Не ЭлементыКлассификатораОбращенийУказаны(Форма, ТекстОшибки) Тогда 
		Заполнены = Ложь;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "КодВопроса");
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьКодВопросаПоСоставляющим(Форма, ЭлементКлассификатора, КодЭлемента)
	
	СхемаКодаВопроса  = Форма.КэшДанныхФормы.СхемаКодаВопроса;
	ПоложениеВСхеме	  = СхемаКодаВопроса[ТипЗнч(ЭлементКлассификатора)];
	ОписаниеЭлемента  = Форма.КэшДанныхФормы.ЭлементыКлассификатора[ПоложениеВСхеме];
	
	НовыйКодВопроса	  = Новый Массив(СхемаКодаВопроса.Количество());
	ТекущийКодВопроса = СтрРазделить(Форма.КодВопроса, ".");
	
	Для i = 1 По ТекущийКодВопроса.Количество() Цикл
		НовыйКодВопроса[i - 1] = Лев(ТекущийКодВопроса[i - 1], 4);
	КонецЦикла;
	
	НовыйКодВопроса[ПоложениеВСхеме] = КодЭлемента;
	
	Форма[ОписаниеЭлемента.ПолеФормы] = ЭлементКлассификатора;	
	Форма.КодВопроса = СтрСоединить(НовыйКодВопроса, ".");
	
	Если ПолучитьКоличествоЗаполненныхЭлементов(НовыйКодВопроса) = НовыйКодВопроса.Количество() Тогда
		Форма.ПодключитьОбработчикОжидания("ОбновитьДанныеФормы", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьКоличествоЗаполненныхЭлементов(Данные)
	
	Заполнено	 = 0;
	ЭтоСтруктура = ТипЗнч(Данные) = Тип("Структура") Или ТипЗнч(Данные) = Тип("Соответствие");
	
	Для Каждого Элемент Из Данные Цикл
		Если Не ЭтоСтруктура Тогда
			Заполнено = Заполнено + ЗначениеЗаполнено(Элемент);
		Иначе 
			Заполнено = Заполнено + ЗначениеЗаполнено(Элемент.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Заполнено;
	
КонецФункции

Функция ЭлементыКлассификатораОбращенийУказаны(Форма, ТекстОшибки)
	
	Для Каждого ОписаниеЭлемента ИЗ Форма.КэшДанныхФормы.ЭлементыКлассификатора Цикл
		Если Не ЗначениеЗаполнено(Форма[ОписаниеЭлемента.Значение.ПолеФормы]) Тогда
			ТекстОшибки = Нстр("ru = 'Указан некорректный код вопроса.'");
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПодборИзКлассификатораОбращенийГражданВызовСервера.ВопросКорректен(
		Форма["Раздел"], Форма["Тематика"], Форма["Тема"], Форма["Вопрос"], ТекстОшибки) Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
