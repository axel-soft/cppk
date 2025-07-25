﻿////////////////////////////////////////////////////////////////////////////////
// Эскалация задач: модуль для работы с эскалацией и автоматическим выполнением задач.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует данные выбора направления эскалации.
//
// Параметры:
//  Параметры - Структура - Параметры поиска.
// 
// Возвращаемое значение:
//  СписокЗначений - Данные выбора.
//
Функция ДанныеВыбораНаправленияЭскалации(Знач Параметры) Экспорт
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Если Параметры.Отбор = Неопределено Тогда
		Параметры.Отбор = Новый Структура;
	КонецЕсли;
	Параметры.Отбор.Вставить("ПометкаУдаления", Ложь);
	
	// Автоподстановки
	Для Каждого ЭлементДанные Из ДанныеВыбораАвтоподстановки(Параметры) Цикл
		ДанныеВыбора.Добавить(ЭлементДанные.Значение, ЭлементДанные.Представление);
	КонецЦикла;
	
	// Сотрудники
	Для Каждого ЭлементДанные Из Справочники.Сотрудники.ПолучитьДанныеВыбора(Параметры) Цикл
		ДанныеВыбора.Добавить(ЭлементДанные.Значение, ЭлементДанные.Представление);
	КонецЦикла;
	
	// Роли
	Для Каждого ЭлементДанные Из Справочники.ПолныеРоли.ПолучитьДанныеВыбора(Параметры) Цикл
		ДанныеВыбора.Добавить(ЭлементДанные.Значение, ЭлементДанные.Представление);
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции

// Задает приоритет правила эскалации.
//
// Параметры:
//  ПравилоЭскалации - СправочникСсылка.ПравилаЭскалации - Правило эскалации.
//  Приоритет - Число - Текущие приоритет.
//
Процедура ЗадатьПриоритет(Знач ПравилоЭскалации, Знач Приоритет) Экспорт
	
	Справочники.ПравилаЭскалации.ЗадатьПриоритет(ПравилоЭскалации, Приоритет);
	
КонецПроцедуры

// Выполняет нормализацию приоритетов всех правил эскалации.
//
Процедура НормализоватьПриоритеты() Экспорт
	
	Справочники.ПравилаЭскалации.НормализоватьПриоритеты();
	
КонецПроцедуры

// Повышает приоритет правила эскалации.
//
// Параметры:
//  ПравилоЭскалации - СправочникСсылка.ПравилаЭскалации - Правило эскалации.
//  Шаблон - СправочникСсылка - Шаблон процесса, в контексте которого происходит изменение.
//
Процедура ПовыситьПриоритет(Знач ПравилоЭскалации, Знач Шаблон) Экспорт
	
	Справочники.ПравилаЭскалации.ПовыситьПриоритет(ПравилоЭскалации, Шаблон);
	
КонецПроцедуры

// Понижает приоритет правила эскалации.
//
// Параметры:
//  ПравилоЭскалации - СправочникСсылка.ПравилаЭскалации - Правило эскалации.
//  Шаблон - СправочникСсылка - Шаблон процесса, в контексте которого происходит изменение.
//
Процедура ПонизитьПриоритет(Знач ПравилоЭскалации, Знач Шаблон) Экспорт
	
	Справочники.ПравилаЭскалации.ПонизитьПриоритет(ПравилоЭскалации, Шаблон);
	
КонецПроцедуры

// По части наименования формирует список для выбора исполнителя правила эскалации.
//
// Параметры:
//  Текст - часть наименования, по которому выполняется поиск.
//
// Возвращает:
//  СписокЗначений - Список значений, содержащий ссылки на найденные по части наименования объекты
//
Функция СформироватьДанныеВыбораИсполнителя(Текст) Экспорт
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 20
	|	Сотрудники.Ссылка КАК Ссылка,
	|	Сотрудники.Подразделение КАК Подразделение
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|ГДЕ
	|	Сотрудники.Наименование ПОДОБНО &Текст
	|	И Сотрудники.Действует = ИСТИНА
	|	И Сотрудники.ПометкаУдаления = ЛОЖЬ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 20
	|	ПолныеРоли.Ссылка,
	|	NULL
	|ИЗ
	|	Справочник.ПолныеРоли КАК ПолныеРоли
	|ГДЕ
	|	ПолныеРоли.Владелец.Наименование ПОДОБНО &Текст
	|	И ПолныеРоли.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Подразделение) Тогда 
			ДанныеВыбора.Добавить(Выборка.Ссылка, Строка(Выборка.Ссылка) + " (" + Строка(Выборка.Подразделение) + ")");
		Иначе	
			ДанныеВыбора.Добавить(Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует данные выбора автоподстановок эскалации.
//
// Параметры:
//  Параметры - Структура - Параметры поиска.
// 
// Возвращаемое значение:
//  СписокЗначений - Данные выбора.
//
Функция ДанныеВыбораАвтоподстановки(Параметры)
	
	ФункцииАвтоподстановки = ЭскалацияЗадач.ДоступныеАвтоподстановки();
	СловаПоиска = ОбщегоНазначенияДокументооборот.СловаПоиска(Параметры.СтрокаПоиска);
	НайденныеДанные = ОбщегоНазначенияДокументооборот.НайтиПоСловамПоиска(ФункцииАвтоподстановки, СловаПоиска);
	ДанныеВыбора = ОбщегоНазначенияДокументооборот.ВыделитьСловаПоиска(НайденныеДанные, СловаПоиска);
	
	Возврат ДанныеВыбора;
	
КонецФункции

#КонецОбласти