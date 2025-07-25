﻿////////////////////////////////////////////////////////////////////////////////
// МОДУЛЬ ПО РАБОТЕ С ИНСТРУКЦИЯМИ
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет наличие инструкций для указанных предметов с учетом дополнительных
// характеристикам по каждому.
//
// Параметры:
//  Предметы - Массив структур описания предметов инструкции с дополнительными
//             характеристиками отбора:
//    ПредметИнструкции  - СправочникСсылка.ПредметыИнструкций
//    Организация        - СправочникСсылка.Организации
//    ВидДокумента       - СправочникСсылка.ВидыДокументов
//    ГрифДоступа        - СправочникСсылка.ГрифыДоступа
//    ВопросДеятельности - СправочникСсылка.ВопросыДеятельности
//    СостояниеДокумента - ПеречислениеСсылка.СостоянияДокументов
//    ШаблонДокумента    - СправочникСсылка.ШаблоныДокументов
//    ШаблонПроцесса     - СправочникСсылка.ШаблоныУтверждения
//                         СправочникСсылка.ШаблоныОзнакомления
//                         СправочникСсылка.ШаблоныСоставныхБизнесПроцессов
//                         СправочникСсылка.ШаблоныРассмотрения
//                         СправочникСсылка.ШаблоныСогласования
//                         СправочникСсылка.ШаблоныПодписания
//                         СправочникСсылка.ШаблоныИсполнения
//                         СправочникСсылка.ШаблоныРегистрации
//                         СправочникСсылка.ШаблоныПриглашения
//                         СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов
//  Инструкции - Массив полученных ссылок на справочник Инструкции.
//
// Возвращаемое значение:
//  Булево
//
Функция ЕстьИнструкции(Предметы, Инструкции) Экспорт
	
	Если Предметы.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Инструкции.Ссылка,
		|	Инструкции.Наименование,
		|	Инструкции.ПредметИнструкции
		|ИЗ
		|	Справочник.Инструкции КАК Инструкции
		|ГДЕ
		|	Инструкции.ПометкаУдаления = Ложь
		|	И Инструкции.Активна = Истина
		|	И ((";
		
	ИндексПредмета = 0;
	
	Для Каждого Предмет Из Предметы Цикл
		
		Если ИндексПредмета > 0 Тогда
			Запрос.Текст = Запрос.Текст + " ) ИЛИ ( ";
		КонецЕсли;
		ИндексПредмета = ИндексПредмета + 1;
		
		Запрос.Текст = Запрос.Текст + "
			|	Инструкции.ПредметИнструкции = &Предмет" + ИндексПредмета;
		Запрос.УстановитьПараметр("Предмет" + ИндексПредмета, Предмет.ПредметИнструкции);
		
		// отбор по организации
		Если Предмет.Свойство("Организация")
			И ТипЗнч(Предмет.Организация) = Тип("СправочникСсылка.Организации") Тогда
			
			Если НЕ Предмет.Организация.Пустая() Тогда
				Запрос.Текст = Запрос.Текст + "
					|	И (
					|		Инструкции.УсловияОтображения.Организация = &Организация" + ИндексПредмета + "
					|		ИЛИ Инструкции.УсловияОтображения.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
					|	)";
				Запрос.УстановитьПараметр("Организация" + ИндексПредмета, Предмет.Организация);
			Иначе
				Запрос.Текст = Запрос.Текст + "
					|	И Инструкции.УсловияОтображения.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)";
			КонецЕсли;
				
		КонецЕсли;
		
		// отбор по виду документа
		Если Предмет.Свойство("ВидДокумента")
			И ТипЗнч(Предмет.ВидДокумента) = Тип("СправочникСсылка.ВидыДокументов") Тогда
			Если НЕ Предмет.ВидДокумента.Пустая() Тогда
				Запрос.Текст = Запрос.Текст + "
					|	И (
					|		Инструкции.УсловияОтображения.ВидДокумента = &ВидДокумента" + ИндексПредмета + "
					|		ИЛИ Инструкции.УсловияОтображения.ВидДокумента = Неопределено
					|		ИЛИ Инструкции.УсловияОтображения.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументов.ПустаяСсылка)
					|	)";
				Запрос.УстановитьПараметр("ВидДокумента" + ИндексПредмета, Предмет.ВидДокумента);
			Иначе
				Запрос.Текст = Запрос.Текст + "
					|	И (
					|		Инструкции.УсловияОтображения.ВидДокумента = Неопределено
					|		ИЛИ Инструкции.УсловияОтображения.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументов.ПустаяСсылка)
					|	)";
			КонецЕсли;
		КонецЕсли;
		
		// отбор по грифу доступа
		Если Предмет.Свойство("ГрифДоступа") И ТипЗнч(Предмет.ГрифДоступа) = Тип("СправочникСсылка.ГрифыДоступа") Тогда
			Если НЕ Предмет.ГрифДоступа.Пустая() Тогда
				Запрос.Текст = Запрос.Текст + "
					|	И (
					|		Инструкции.УсловияОтображения.ГрифДоступа = &ГрифДоступа" + ИндексПредмета + "
					|		ИЛИ Инструкции.УсловияОтображения.ГрифДоступа = ЗНАЧЕНИЕ(Справочник.ГрифыДоступа.ПустаяСсылка)
					|	)";
				Запрос.УстановитьПараметр("ГрифДоступа" + ИндексПредмета, Предмет.ГрифДоступа);
			Иначе
				Запрос.Текст = Запрос.Текст + "
					|	И Инструкции.УсловияОтображения.ГрифДоступа = ЗНАЧЕНИЕ(Справочник.ГрифыДоступа.ПустаяСсылка)";
			КонецЕсли;
		КонецЕсли;
		
		// отбор по вопросу деятельности
		Если Предмет.Свойство("ВопросДеятельности")
			И ТипЗнч(Предмет.ВопросДеятельности) = Тип("СправочникСсылка.ВопросыДеятельности") Тогда
			Если НЕ Предмет.ВопросДеятельности.Пустая() Тогда
				Запрос.Текст = Запрос.Текст + "
					|	И (
					|		Инструкции.УсловияОтображения.ВопросДеятельности = &ВопросДеятельности" + ИндексПредмета + "
					|		ИЛИ Инструкции.УсловияОтображения.ВопросДеятельности = ЗНАЧЕНИЕ(Справочник.ВопросыДеятельности.ПустаяСсылка)
					|	)";
				Запрос.УстановитьПараметр("ВопросДеятельности" + ИндексПредмета, Предмет.ВопросДеятельности);
			Иначе
				Запрос.Текст = Запрос.Текст + "
					|	И Инструкции.УсловияОтображения.ВопросДеятельности = ЗНАЧЕНИЕ(Справочник.ВопросыДеятельности.ПустаяСсылка)";
			КонецЕсли;
		КонецЕсли;
		
		// отбор по шаблону документа
		Если Предмет.Свойство("ШаблонДокумента")
			И ТипЗнч(Предмет.ШаблонДокумента) = Тип("СправочникСсылка.ШаблоныДокументов") Тогда
			Если НЕ Предмет.ШаблонДокумента.Пустая() Тогда
				Запрос.Текст = Запрос.Текст + "
					|	И (
					|		Инструкции.УсловияОтображения.ШаблонДокумента = &ШаблонДокумента" + ИндексПредмета + "
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонДокумента = Неопределено
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонДокумента = ЗНАЧЕНИЕ(Справочник.ШаблоныДокументов.ПустаяСсылка)
					|	)";
				Запрос.УстановитьПараметр("ШаблонДокумента" + ИндексПредмета, Предмет.ШаблонДокумента);
			Иначе
				Запрос.Текст = Запрос.Текст + "
					|	И (
					|		Инструкции.УсловияОтображения.ШаблонДокумента = Неопределено
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонДокумента = ЗНАЧЕНИЕ(Справочник.ШаблоныДокументов.ПустаяСсылка)
					|	)";
			КонецЕсли;
		КонецЕсли;
		
		// отбор по шаблону процесса
		Если Предмет.Свойство("ШаблонПроцесса")
			И (
				ТипЗнч(Предмет.ШаблонПроцесса) = Тип("СправочникСсылка.ШаблоныУтверждения")
				ИЛИ ТипЗнч(Предмет.ШаблонПроцесса) = Тип("СправочникСсылка.ШаблоныОзнакомления")
				ИЛИ ТипЗнч(Предмет.ШаблонПроцесса) = Тип("СправочникСсылка.ШаблоныРассмотрения")
				ИЛИ ТипЗнч(Предмет.ШаблонПроцесса) = Тип("СправочникСсылка.ШаблоныСогласования")
				ИЛИ ТипЗнч(Предмет.ШаблонПроцесса) = Тип("СправочникСсылка.ШаблоныПодписания")
				ИЛИ ТипЗнч(Предмет.ШаблонПроцесса) = Тип("СправочникСсылка.ШаблоныИсполнения")
				ИЛИ ТипЗнч(Предмет.ШаблонПроцесса) = Тип("СправочникСсылка.ШаблоныПодписания")
				ИЛИ ТипЗнч(Предмет.ШаблонПроцесса) = Тип("СправочникСсылка.ШаблоныРегистрации")
				ИЛИ ТипЗнч(Предмет.ШаблонПроцесса) = Тип("СправочникСсылка.ШаблоныПриглашения")
				ИЛИ ТипЗнч(Предмет.ШаблонПроцесса) = Тип("СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов")
			) Тогда
			Если НЕ Предмет.ШаблонПроцесса.Пустая() Тогда
				Запрос.Текст = Запрос.Текст + "
					|	И (
					|		Инструкции.УсловияОтображения.ШаблонПроцесса = &ШаблонПроцесса" + ИндексПредмета + "
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = Неопределено
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныУтверждения.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныОзнакомления.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныРассмотрения.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныСогласования.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныПодписания.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныИсполнения.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныРегистрации.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныПриглашения.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныКомплексныхБизнесПроцессов.ПустаяСсылка)
					|	)";
				Запрос.УстановитьПараметр("ШаблонПроцесса" + ИндексПредмета, Предмет.ШаблонПроцесса);
			Иначе
				Запрос.Текст = Запрос.Текст + "
					|	И (
					|		Инструкции.УсловияОтображения.ШаблонПроцесса = Неопределено
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныУтверждения.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныОзнакомления.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныРассмотрения.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныСогласования.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныПодписания.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныИсполнения.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныРегистрации.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныПриглашения.ПустаяСсылка)
					|		ИЛИ Инструкции.УсловияОтображения.ШаблонПроцесса = ЗНАЧЕНИЕ(Справочник.ШаблоныКомплексныхБизнесПроцессов.ПустаяСсылка)
					|	)";
			КонецЕсли;
		КонецЕсли;
		
		// отбор по состоянию документа
		Если Предмет.Свойство("СостояниеДокумента")
			И ТипЗнч(Предмет.СостояниеДокумента) = Тип("ПеречислениеСсылка.СостоянияДокументов") Тогда
			
			Если Предмет.СостояниеДокумента <> Неопределено Тогда
				Запрос.Текст = Запрос.Текст + "
					|	И (
					|		Инструкции.УсловияОтображения.СостояниеДокумента = &СостояниеДокумента" + ИндексПредмета + "
					|		ИЛИ Инструкции.УсловияОтображения.СостояниеДокумента = ЗНАЧЕНИЕ(Перечисление.СостоянияДокументов.ПустаяСсылка)
					|	)";
				Запрос.УстановитьПараметр("СостояниеДокумента" + ИндексПредмета, Предмет.СостояниеДокумента);
			Иначе
				Запрос.Текст = Запрос.Текст + "
					|	И Инструкции.УсловияОтображения.СостояниеДокумента = ЗНАЧЕНИЕ(Перечисление.СостоянияДокументов.ПустаяСсылка)";
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос.Текст = Запрос.Текст + "))
		|УПОРЯДОЧИТЬ ПО
		|	Инструкции.УсловияОтображения.ВидДокумента УБЫВ,
		|	Инструкции.УсловияОтображения.ШаблонДокумента УБЫВ,
		|	Инструкции.УсловияОтображения.ШаблонПроцесса УБЫВ,
		|	Инструкции.УсловияОтображения.СостояниеДокумента УБЫВ,
		|	Инструкции.УсловияОтображения.Организация УБЫВ,
		|	Инструкции.УсловияОтображения.ВопросДеятельности УБЫВ,
		|	Инструкции.УсловияОтображения.ГрифДоступа УБЫВ";
	ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
	
	ДеревоИнструкций = Новый ДеревоЗначений;
	ДеревоИнструкций.Колонки.Добавить("Ссылка");
	Для Каждого Предмет Из Предметы Цикл
		СтрокаПредмета = ДеревоИнструкций.Строки.Добавить();
		СтрокаПредмета.Ссылка = Предмет.ПредметИнструкции;
	КонецЦикла;
	
	Пока ВыборкаЗапроса.Следующий() Цикл
		НайденнаяСтрока = ДеревоИнструкций.Строки.Найти(ВыборкаЗапроса.ПредметИнструкции, "Ссылка");
		Если НайденнаяСтрока <> Неопределено Тогда
			СтрокаИнструкции = НайденнаяСтрока.Строки.Добавить();
			СтрокаИнструкции.Ссылка = ВыборкаЗапроса.Ссылка;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ИнструкцииПоПредмету Из ДеревоИнструкций.Строки Цикл
		Для Каждого Инструкция Из ИнструкцииПоПредмету.Строки Цикл
			Инструкции.Добавить(Инструкция.Ссылка);
		КонецЦикла;
	КонецЦикла;
	
	Возврат Инструкции.Количество() > 0;
	
КонецФункции

// Возвращает структуру описания предмета с учетом функциональных опций.
//
// Параметры:
//  Предмет - СправочникСсылка.ПредметыИнструкций - Если задан, то записывается
//            в значение ключа ПредметИнструкции структуры.
//
Функция ОписаниеПредметаИнструкции(Предмет = Неопределено) Экспорт
	
	Структура = Новый Структура;
	
	Если ТипЗнч(Предмет) = Тип("СправочникСсылка.ПредметыИнструкций") Тогда
		Структура.Вставить("ПредметИнструкции", Предмет);
	Иначе
		Структура.Вставить("ПредметИнструкции");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
		Структура.Вставить("Организация");
	КонецЕсли;
	
	Структура.Вставить("ВидДокумента");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГрифыДоступа") Тогда
		Структура.Вставить("ГрифДоступа");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВопросыДеятельности") Тогда
		Структура.Вставить("ВопросДеятельности");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСостоянияДокументов") Тогда
		Структура.Вставить("СостояниеДокумента");
	КонецЕсли;
	
	Структура.Вставить("ШаблонДокумента");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыИЗадачи") Тогда
		Структура.Вставить("ШаблонПроцесса");
	КонецЕсли;
	
	Возврат Структура;
	
КонецФункции

// Возвращает текст инструкции.
//
// Параметры:
//  СсылкаНаИнструкцию        - СправочникСсылка.Инструкции
//  УстановитьСтильОформления - Булево - Если истина, то в HTML-код инструкции встраивается
//                              общий стиль оформления инструкций.
//
// Возвращаемое значение:
//  Строка - HTML-код инструкции для вставки в поле HTML документа.
//
Функция ТекстИнструкции(СсылкаНаИнструкцию, УстановитьСтильОформления = Истина) Экспорт
	
	HTMLКодИнструкции = СсылкаНаИнструкцию.ТекстИнструкции.Получить(); 
	
	Если HTMLКодИнструкции <> Неопределено Тогда
		Если УстановитьСтильОформления Тогда
			Возврат РаботаСИнструкциями.УстановитьСтильОформленияИнструкции(HTMLКодИнструкции);
		Иначе
			Возврат HTMLКодИнструкции;
		КонецЕсли;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Возвращает текст инструкций с навигацией.
// 
// Параметры:
//  Инструкции - Массив ссылок на справочник Инструкции.
//  УстановитьСтильОформления - Булево - Если истина, то в HTML-код списка инструкций
//                              встраивается общий стиль оформления инструкций.
//
// Возвращаемое значение:
//  Строка - HTML-код списка инструкций для вставки в поле HTML документа.
//
Функция ТекстыИнструкций(Инструкции, УстановитьСтильОформления = Истина) Экспорт
	
	Результат = "";
	
	МассивТекстовИнструкций = Новый Массив;
	МассивСсылокНаИнструкции = Новый Массив;
	
	Для Каждого Инструкция Из Инструкции Цикл
		
		HTMLКодИнструкции = ТекстИнструкции(Инструкция, Ложь);
		HTMLКодИнструкции = ТелоИнструкцииИзHTML(HTMLКодИнструкции);
		
		ТекстИнструкции = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<p class=""elem""><a name=""%1""></a></p>%2",
			Инструкция.УникальныйИдентификатор(), HTMLКодИнструкции);
		МассивТекстовИнструкций.Добавить(ТекстИнструкции);
		
		СсылкаНаИнструкцию = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<a href=""#%1"">%2</a>",
			Инструкция.УникальныйИдентификатор(),
			Инструкция.Наименование);
		МассивСсылокНаИнструкции.Добавить(СсылкаНаИнструкцию);
	КонецЦикла;
	
	Если МассивТекстовИнструкций.Количество() > 0 Тогда
		Если МассивТекстовИнструкций.Количество() = 1 Тогда
			Результат = МассивТекстовИнструкций[0];
			Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"<html><head></head><body>%1</body></html>", Результат);
		ИначеЕсли МассивТекстовИнструкций.Количество() > 1 Тогда
			Ссылки = СтрСоединить(МассивСсылокНаИнструкции, "");
			Ссылки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"<p class=""nav"">%1</p>", Ссылки);
			СтрокаВНачало = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"<a href=""#nav"" class=""up"">%1</a>",
				НСтр("ru = 'В начало'"));
			Результат = СтрСоединить(МассивТекстовИнструкций, СтрокаВНачало) + СтрокаВНачало;
			Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"<html><head></head><body><a name=""nav""></a>%1%2</body></html>",
				Ссылки,
				Результат);
		КонецЕсли;
		
		Если УстановитьСтильОформления Тогда
			РаботаСИнструкциями.УстановитьСтильОформленияИнструкции(Результат);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Результат) И ПараметрыСеанса.ЭтоМобильныйКлиент Тогда
		МК_КлиентСервер.АдаптироватьHtmlПодЭкранМобильногоПриНеобходимости(Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает общее количество типовых инструкций.
//
Функция КоличествоТиповыхИнструкций() Экспорт
	
	Возврат ПереченьИнструкций().Количество();
	
КонецФункции

// Возвращает количество типовых инструкций, которые еще не были загружены в ИБ.
//
Функция КоличествоТиповыхИнструкцийДляЗагрузки() Экспорт
	
	Результат = 0;
	
	Выборка = ПереченьИнструкций();
	Пока Выборка.Следующий() Цикл
		
		GUIDИнструкции = Выборка.GUIDИнструкции;
		ИмяМакета      = Выборка.МакетИнструкции;
		
		GUID = Новый УникальныйИдентификатор(GUIDИнструкции);
		
		СсылкаНаИнструкцию = Справочники.Инструкции.ПолучитьСсылку(GUID);
		РеквизитыИнструкции = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаНаИнструкцию, 
			"Ссылка,ПометкаУдаления,ИмяМакетаТиповой,ТекстИнструкции");
		Если ЗначениеЗаполнено(РеквизитыИнструкции.Ссылка) Тогда
			Если РеквизитыИнструкции.ПометкаУдаления Тогда
				Результат = Результат + 1;
			ИначеЕсли ЗначениеЗаполнено(РеквизитыИнструкции.ИмяМакетаТиповой) Тогда
				
				ТекстИнструкции = РеквизитыИнструкции.ТекстИнструкции.Получить();
				ТекстТиповойИнструкции = ТекстТиповойИнструкции(ИмяМакета);
				
				Если Не ЗначениеЗаполнено(ТекстТиповойИнструкции) Тогда
					Продолжить;
				КонецЕсли;
				
				Если ТекстИнструкции = ""
					Или Не ХешиТекстовИнструкцийСовпадают(ТекстИнструкции, ТекстТиповойИнструкции) Тогда
					Результат = Результат + 1;
				КонецЕсли;
				
			КонецЕсли;
		Иначе
			Результат = Результат + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает массив наименований типовых инструкций, которые еще не были загружены в ИБ.
//
// Возвращаемое значение:
//  Массив
//
Функция ТиповыеИнструкцииДляЗагрузки() Экспорт
	
	Результат = Новый Массив;
	
	Выборка = ПереченьИнструкций();
	Пока Выборка.Следующий() Цикл
		
		GUIDИнструкции = Выборка.GUIDИнструкции;
		ИмяМакета      = Выборка.МакетИнструкции;
		
		GUID = Новый УникальныйИдентификатор(GUIDИнструкции);
		
		СсылкаНаСуществующийОбъект = Справочники.Инструкции.ПолучитьСсылку(GUID);
		РеквизитыИнструкции = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаНаСуществующийОбъект, 
			"Ссылка,ПометкаУдаления,Наименование,ИмяМакетаТиповой,ТекстИнструкции");
		Если ЗначениеЗаполнено(РеквизитыИнструкции.Ссылка) Тогда
			Если РеквизитыИнструкции.ПометкаУдаления Тогда
				Результат.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Новая: %1'"), РеквизитыИнструкции.Наименование));
			ИначеЕсли ЗначениеЗаполнено(РеквизитыИнструкции.ИмяМакетаТиповой) Тогда
				
				ТекстИнструкции = РеквизитыИнструкции.ТекстИнструкции.Получить();
				ТекстТиповойИнструкции = ТекстТиповойИнструкции(ИмяМакета);
				
				Если Не ХешиТекстовИнструкцийСовпадают(ТекстИнструкции, ТекстТиповойИнструкции) Тогда
					Результат.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Обновление: %1'"), РеквизитыИнструкции.Наименование));
				КонецЕсли;
				
			КонецЕсли;
		Иначе
			HTMLКодИнструкции = ТекстТиповойИнструкции(ИмяМакета);
			НаименованиеИнструкции = НаименованиеИнструкцииИзHTML(HTMLКодИнструкции);
			Результат.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Новая: %1'"), НаименованиеИнструкции));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Создает новую инструкцию из переданных данных. Если инструкция уже существует и помечена
// на удаление, тогда она перезаписывается и снимается пометка удаления.
//
// Параметры:
//  Данные - Структура, описывающая создаваемую инструкцию:
//    GUID              - Уникальный идентификатор инструкции.
//    Наименование      - Наименование инструкции.
//    Активность        - Активность инструкции по умолчанию.
//    ПредметСсылка     - Ссылка на соответствующий инструкции предмет.
//    HTMLКодИнструкции - HTML-код инструкции.
//
// Возвращаемое значение:
//  Булево - Истина, в случае успешного создания, иначе Ложь.
//
Процедура СоздатьИнструкцию(Данные) Экспорт
	
	GUID = Новый УникальныйИдентификатор(Данные.GUID);
	
	СсылкаНаСуществующийОбъект = Справочники.Инструкции.ПолучитьСсылку(GUID);
	РеквизитыИнструкции = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаНаСуществующийОбъект, 
		"Ссылка,ПометкаУдаления,ИмяМакетаТиповой");
	Если ЗначениеЗаполнено(РеквизитыИнструкции.Ссылка) Тогда
		Если РеквизитыИнструкции.ПометкаУдаления Тогда
			НоваяИнструкция = СсылкаНаСуществующийОбъект.ПолучитьОбъект();
			НоваяИнструкция.УстановитьПометкуУдаления(Ложь);
		ИначеЕсли ЗначениеЗаполнено(РеквизитыИнструкции.ИмяМакетаТиповой) Тогда
			НоваяИнструкция = СсылкаНаСуществующийОбъект.ПолучитьОбъект();
		Иначе
			Возврат;
		КонецЕсли;
	Иначе
		НоваяИнструкция = Справочники.Инструкции.СоздатьЭлемент();
		НоваяСсылка = Справочники.Инструкции.ПолучитьСсылку(GUID);
		НоваяИнструкция.УстановитьСсылкуНового(НоваяСсылка);
	КонецЕсли;
	
	НоваяИнструкция.Наименование = Данные.Наименование;
	НоваяИнструкция.Активна = Данные.Активность = "Да";
	НоваяИнструкция.ПредметИнструкции = Данные.ПредметСсылка;
	НоваяИнструкция.ТекстИнструкции = Новый ХранилищеЗначения(Данные.HTMLКодИнструкции);
	НоваяИнструкция.Комментарий = НСтр("ru = 'Типовая инструкция'");
	НоваяИнструкция.ИмяМакетаТиповой = Данные.ИмяМакетаТиповой;
	
	Если НоваяИнструкция.УсловияОтображения.Количество() = 0 Тогда
		НоваяСтрока = НоваяИнструкция.УсловияОтображения.Добавить();
		НоваяСтрока.ВидДокумента = Неопределено;
		НоваяСтрока.СостояниеДокумента = Неопределено;
		НоваяСтрока.ГрифДоступа = Неопределено;
		НоваяСтрока.ВопросДеятельности = Неопределено;
	КонецЕсли;
	
	НоваяИнструкция.Записать();
	
КонецПроцедуры

// Возвращает массив инструкций по предмету.
//
// Параметры:
//  СсылкаНаПредмет - СправочникСсылка.ПредметыИнструкций
//  ТолькоАктивные  - Булево
//
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса
//
Функция ИнструкцииПоПредмету(СсылкаНаПредмет, ТолькоАктивные = Истина) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Инструкции.Ссылка
		|ИЗ
		|	Справочник.ПредметыИнструкций КАК Предметы
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Инструкции КАК Инструкции
		|	ПО Предметы.Ссылка = Инструкции.ПредметИнструкции
		|ГДЕ
		|	(Инструкции.ПредметИнструкции = &Предмет
		|	ИЛИ Предметы.Родитель.Ссылка = &Предмет
		|	ИЛИ Предметы.Родитель.Родитель.Ссылка = &Предмет
		|	ИЛИ Предметы.Родитель.Родитель.Родитель.Ссылка = &Предмет)";
	Запрос.Параметры.Вставить("Предмет", СсылкаНаПредмет);
	
	Если ТолькоАктивные Тогда
		Запрос.Текст = Запрос.Текст + " И Инструкции.Активна = Истина";
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

// Возвращает ссылку на предмет инструкции по переданному имени предмета.
//
// Параметры:
//  ИмяПредмета - Строка - Имя искомого предмета инструкции.
//
// Возвращаемое значение:
//   СправочникСсылка.ПредметыИнструкций или Неопределено.
//
Функция СсылкаНаПредметИнструкции(Знач ИмяПредмета) Экспорт
	
	Попытка
		Возврат ПредопределенноеЗначение("Справочник.ПредметыИнструкций." + ИмяПредмета);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

// Возвращает выборку типовых инструкций. Макет располагается в обработке ЗагрузкаТиповыхИнструкций.
//
Функция ПереченьИнструкций() Экспорт
	
	МакетДанных = МакетОбработки("СлужебныйПереченьИнструкций");
	ОбластьЗаголовков = МакетДанных.Область("C1:C4");
	
	Построитель = Новый ПостроительЗапроса;
	Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(ОбластьЗаголовков);
	Построитель.Выполнить();
	
	Возврат Построитель.Результат.Выбрать();
	
КонецФункции

// Возвращает HTML-код типовой инструкции, полученный из макета. Макеты располагаются в обработке
// ЗагрузкаТиповыхИнструкций.
//
// Параметры:
//  ИмяМакета - Строка - Имя макета с типовой инструкцией.
//
Функция ТекстТиповойИнструкции(Знач ИмяМакета) Экспорт
	
	МакетИнструкции = МакетОбработки(ИмяМакета);
	
	Если МакетИнструкции <> Неопределено Тогда
		Возврат МакетИнструкции.ПолучитьТекст();
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает HTML-код инструкции со встроенной таблицей стилей.
//
// Параметры:
//  HTMLКодИнструкции - Исходный HTML-код инструкции без таблицы стилей.
//
// Возвращаемое значение:
//  Строка
//
Функция УстановитьСтильОформленияИнструкции(HTMLКодИнструкции) Экспорт
	
	ЧтениеHTML = Новый ЧтениеHTML;
	ЧтениеHTML.УстановитьСтроку(HTMLКодИнструкции);
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеHTML);
	
	ЭлементSTYLE = ДокументDOM.СоздатьЭлемент("style");
	ЭлементSTYLE.ТекстовоеСодержимое = СтильОформленияИнструкций();
	
	Если ДокументDOM.ПолучитьЭлементыПоИмени("head").Количество() > 0 Тогда
		ЭлементHEAD = ДокументDOM.ПолучитьЭлементыПоИмени("head").Элемент(0);
		ЭлементHEAD.ДобавитьДочерний(ЭлементSTYLE);
	КонецЕсли;
	
	ЗаписьDOM = Новый ЗаписьDOM; 
	ЗаписьHTML = Новый ЗаписьHTML; 
	ЗаписьHTML.УстановитьСтроку(); 
	ЗаписьDOM.Записать(ДокументDOM, ЗаписьHTML); 
	HTMLКодИнструкции = ЗаписьHTML.Закрыть();
	
	Возврат HTMLКодИнструкции;	
	
КонецФункции

// Получает инструкции для указанной формы.
// На форме должны присутствовать:
// - реквизит Инструкция;
// - реквизит ПоказыватьИнструкции;
// - группа ГруппаИнструкции, содержащая поле формы Инструкция;
// - команда ПоказыватьИнструкции;
// - кнопка ПоказыватьИнструкции, расположенная в меню "Все действия" командной панели либо в правом
//   нижнем углу формы.
//
Процедура ПолучитьИнструкции(ЭтаФорма,
	ШиринаФормыПриОтсутствииИнструкций = Неопределено,
	ШиринаФормыПриНаличииИнструкций = Неопределено,
	Знач ИмяФормы = "",
	Знач ПредметыЗадачи = Неопределено) Экспорт
	
	ЭтаФорма.Элементы.ПоказыватьИнструкции.Пометка = ЭтаФорма.ПоказыватьИнструкции;
	ЭтаФорма.Элементы.ГруппаИнструкции.Видимость = Ложь;
	
	Если ШиринаФормыПриОтсутствииИнструкций <> Неопределено Тогда
		ЭтаФорма.Ширина = ШиринаФормыПриОтсутствииИнструкций;
	КонецЕсли;
	
	Если Не ЭтаФорма.ПоказыватьИнструкции
		ИЛИ Не ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Предметы = Новый Массив;
	Инструкции = Новый Массив;
	
	РаботаСИнструкциямиПереопределяемый.ПредметыИнструкцийСоответствующиеФорме(
		Предметы,
		ЭтаФорма,
		ИмяФормы,
		ПредметыЗадачи);
	
	Если ЕстьИнструкции(Предметы, Инструкции) Тогда
		
		ЭтаФорма.Инструкция = ТекстыИнструкций(Инструкции);
		
		ЭтаФорма.Элементы.ГруппаИнструкции.Видимость = Истина;
		ЭтаФорма.Элементы.Инструкция.ПропускатьПриВводе = Истина;
		ЭтаФорма.Элементы.Инструкция.ЦветРамки = ЦветаСтиля.ФонОбластиИнструкций;
		ЭтаФорма.Элементы.ГруппаИнструкции.ЦветФона = ЦветаСтиля.ФонОбластиИнструкций;
		
		Если ШиринаФормыПриНаличииИнструкций <> Неопределено Тогда
			ЭтаФорма.Ширина = ШиринаФормыПриНаличииИнструкций;
		КонецЕсли;
	Иначе
		ЭтаФорма.Элементы.ПоказыватьИнструкции.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Загружает типовые инструкции в справочник Инструкции.
//
Процедура ЗагрузитьТиповыеИнструкции() Экспорт
	
	ДатаЗагрузки = ТекущаяДата();
	
	Выборка = ПереченьИнструкций();
	Пока Выборка.Следующий() Цикл
		
		GUIDИнструкции	= Выборка.GUIDИнструкции;
		ИмяМакета		= Выборка.МакетИнструкции;
		ИмяПредмета		= Выборка.ПредметИнструкции;
		Активность		= Выборка.Активна;
		
		HTMLКодИнструкции = ТекстТиповойИнструкции(ИмяМакета);
		Если HTMLКодИнструкции <> Неопределено Тогда
			
			ПредметСсылка = СсылкаНаПредметИнструкции(ИмяПредмета);
			Если ПредметСсылка <> Неопределено Тогда
				
				НаименованиеНовойИнструкции = НаименованиеИнструкцииИзHTML(HTMLКодИнструкции);
				
				Данные = Новый Структура();
				Данные.Вставить("GUID", GUIDИнструкции);
				Данные.Вставить("Наименование", НаименованиеНовойИнструкции);
				Данные.Вставить("ПредметСсылка", ПредметСсылка);
				Данные.Вставить("HTMLКодИнструкции", HTMLКодИнструкции);
				Данные.Вставить("ДатаЗагрузки", ДатаЗагрузки);
				Данные.Вставить("Активность", Активность);
				Данные.Вставить("ИмяМакетаТиповой", ИмяМакета);
				
				СоздатьИнструкцию(Данные);
				
			КонецЕсли;
			
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

// Определяет, имеет ли текущий пользователь право только чтения к справочнику Инструкции.
//
Функция ПравоТолькоЧтения() Экспорт
	
	ОбъектМетаданных = Метаданные.Справочники.Инструкции;
	
	ПравоИзменения = ПравоДоступа("Добавление", ОбъектМетаданных) И ПравоДоступа("Изменение",
		ОбъектМетаданных);
	Возврат ПравоДоступа("Чтение", ОбъектМетаданных) И НЕ ПравоИзменения;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает макет обработки по имени. Поиск осуществляется среди макетов обработки 
// ЗагрузкаТиповыхИнструкций.
//
// Возвращаемое значение:
//  Макет либо Неопределено, если макет не найден.
//
Функция МакетОбработки(Знач ИмяМакета)
	
	Если Метаданные.Обработки.ЗагрузкаТиповыхИнструкций.Макеты.Найти(ИмяМакета) <> Неопределено Тогда
		Возврат Обработки.ЗагрузкаТиповыхИнструкций.ПолучитьМакет(ИмяМакета);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает текст таблицы стилей из макета для визуализации инструкций. Макет оформления
// располагается в справочнике Инструкции.
//
Функция СтильОформленияИнструкций()
	
	МакетОформления = Справочники.Инструкции.ПолучитьМакет("СлужебныйСтильОформления");
	Возврат МакетОформления.ПолучитьТекст();
	
КонецФункции

// Возвращает заголовок инструкции из тэга H1 html-кода.
//
Функция НаименованиеИнструкцииИзHTML(HTMLКодИнструкции) Экспорт
	
	ЧтениеHTML = Новый ЧтениеHTML;
	ЧтениеHTML.УстановитьСтроку(HTMLКодИнструкции);
	
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеHTML);
	
	// получение заголовка инструкции
	Если ДокументDOM.ПолучитьЭлементыПоИмени("h1").Количество() > 0 Тогда
		Возврат ДокументDOM.ПолучитьЭлементыПоИмени("h1").Элемент(0).ТекстовоеСодержимое;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Возвращает тело инструкции из тэга BODY html-кода.
//
Функция ТелоИнструкцииИзHTML(HTMLКодИнструкции) Экспорт
	
	ЧтениеHTML = Новый ЧтениеHTML;
	ЧтениеHTML.УстановитьСтроку(HTMLКодИнструкции);
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеHTML);
	
	ЭлементBODY = ДокументDOM.ПолучитьЭлементыПоИмени("body").Элемент(0);
	ЗаписьDOM = Новый ЗаписьDOM; 
	ЗаписьHTML = Новый ЗаписьHTML; 
	ЗаписьHTML.УстановитьСтроку(); 
	ЗаписьDOM.Записать(ЭлементBODY, ЗаписьHTML); 
	Результат = ЗаписьHTML.Закрыть();
	
	Результат = СтрЗаменить(Результат, Символы.ПС, "");
	Результат = СтрЗаменить(Результат, Символы.ВК, "");
	
	Возврат Результат;
	
КонецФункции

// Сравнивает хеши тел текстов двух инструкций.
//
// Параметры:
//  ТекстИнструкции1 - Строка - html-код инструкции.
//  ТекстИнструкции2 - Строка - html-код инструкции.
//
// Возвращаемое значение:
//  Булево.
//
Функция ХешиТекстовИнструкцийСовпадают(ТекстИнструкции1, ТекстИнструкции2)
	
	ТекстТелаИнструкции1 = ТелоИнструкцииИзHTML(ТекстИнструкции1);
	ХешДанных = Новый ХешированиеДанных(ХешФункция.SHA1);
	ХешДанных.Добавить(ТекстТелаИнструкции1);
	ХешИнструкции = Строка(ХешДанных.ХешСумма);
	
	ТекстТелаИнструкции2 = ТелоИнструкцииИзHTML(ТекстИнструкции2);
	ХешДанных = Новый ХешированиеДанных(ХешФункция.SHA1);
	ХешДанных.Добавить(ТекстТелаИнструкции2);
	ХешТиповойИнструкции = Строка(ХешДанных.ХешСумма);
	
	Возврат ХешИнструкции = ХешТиповойИнструкции;
	
КонецФункции

#КонецОбласти
