﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Вернет Истина, у этого объекта метаданных есть функция ПолучитьАдресФото
Функция ЕстьФункцияПолученияФото() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Обновляет предопределенные автоподстановки.
//
Процедура ЗаполнитьПредопределенные() Экспорт
	
	ТаблицаЭлементов = Новый ТаблицаЗначений;
	ТаблицаЭлементов.Колонки.Добавить("ИмяПредопределенного");
	ТаблицаЭлементов.Колонки.Добавить("Выражение");
	ТаблицаЭлементов.Колонки.Добавить("ТипОбъекта");
	
	// Общие автоподстановки
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ТекущийПользователь";
	Стр.Выражение = "Результат = Пользователи.ТекущийПользователь()";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ПустаяСсылка();
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "НепосредственныйРуководительТекущегоПользователя";
	Стр.Выражение = "ПараметрыАлгоритма = Новый Структура(""Пользователь"", Пользователи.ТекущийПользователь());
		|Результат = Справочники.Алгоритмы.Вызвать(""НепосредственныйРуководительПользователя"", ПараметрыАлгоритма);";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ПустаяСсылка();
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ВсеРуководителиТекущегоПользователя";
	Стр.Выражение = "ПараметрыАлгоритма = Новый Структура(""Пользователь"", Пользователи.ТекущийПользователь());
		|Результат = Справочники.Алгоритмы.Вызвать(""ВсеРуководителиПользователя"", ПараметрыАлгоритма);";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ПустаяСсылка();
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ВсеПодчиненныеТекущегоПользователя";
	Стр.Выражение = "ПараметрыАлгоритма = Новый Структура(""Пользователь"", Пользователи.ТекущийПользователь());
		|Результат = Справочники.Алгоритмы.Вызвать(""ВсеПодчиненныеПользователя"", ПараметрыАлгоритма);";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ПустаяСсылка();
	
	// Документы предприятия
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "РуководительОрганизации";
	Стр.Выражение = "Результат = Справочники.Сотрудники.ПустаяСсылка();
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка) Тогда
		|	Организация = Объект.Организация;
		|	РуководительПользователь = Неопределено;
		|	Если ЗначениеЗаполнено(Организация) Тогда 
		|		ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.РуководительОрганизации;
		|		Отбор = Новый Структура(""Организация, ОтветственноеЛицо"", Организация, ОтветственноеЛицо);
		|		РуководительПользователь = РегистрыСведений.ОтветственныеЛицаОрганизаций.
		|			ПолучитьПоследнее(Объект.ДатаСоздания, Отбор).Сотрудник;
		|	КонецЕсли;
		|	Если Не ЗначениеЗаполнено(РуководительПользователь) Тогда
		|		// результат остается пустым.
		|	ИначеЕсли ТипЗнч(РуководительПользователь) = Тип(""СправочникСсылка.Пользователи"") Тогда
		|		Результат = Сотрудники.ОсновнойСотрудникПользователя(
		|			РуководительПользователь);
		|	Иначе
		|		Результат = РуководительПользователь;
		|	КонецЕсли;
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ОтветственныйЗаДокумент";
	Стр.Выражение = "Результат = Справочники.Сотрудники.ПустаяСсылка();
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка) Тогда
		|	Результат = Объект.Ответственный;
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ПодготовилДокумент";
	Стр.Выражение = "Результат = Справочники.Сотрудники.ПустаяСсылка();
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка) Тогда
		|	Результат = Объект.Подготовил;
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ЗарегистрировалДокумент";
	Стр.Выражение = "Результат = Справочники.Сотрудники.ПустаяСсылка();
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка) Тогда
		|	Результат = Объект.Зарегистрировал;
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "АдресатДокумента";
	Стр.Выражение = "Результат = Справочники.Сотрудники.ПустаяСсылка();
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка) Тогда
		|	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ВидДокумента, ""ЯвляетсяВходящейКорреспонденцией"") = Истина Тогда			 
		|		КорреспонденцияДокумента = РаботаСКорреспонденцией.КорреспонденцияДокумента(Объект.Ссылка);
		|		Если ЗначениеЗаполнено(КорреспонденцияДокумента) Тогда
		|			Корреспонденты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КорреспонденцияДокумента, ""Корреспонденты"");
		|			Выборка = Корреспонденты.Выбрать();
		|			Пока Выборка.Следующий() Цикл
		|				Результат = Выборка.Адресат;
		|			КонецЦикла;
		|		КонецЕсли;
		|
		|	Иначе
		|		Результат = Объект.Адресат;
		|	КонецЕсли;
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ПодразделениеПодготовившегоДокумент";
	Стр.Выражение = "Результат = Справочники.СтруктураПредприятия.ПустаяСсылка();
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка) Тогда
		|	Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Подготовил, ""Подразделение"");
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "РуководительПодразделенияДокумента";
	Стр.Выражение = "Результат = Справочники.Сотрудники.ПустаяСсылка();
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка) Тогда
		|	Результат = СтруктураПредприятия.РуководительПодразделения(Объект.Подразделение);
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "НепосредственныйРуководительПодготовившегоДокумент";
	Стр.Выражение = "Результат = Справочники.Сотрудники.ПустаяСсылка();
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка) Тогда
		|	ПараметрыАлгоритма = Новый Структура(""Сотрудник"", Объект.Подготовил);
		|	Результат = Справочники.Алгоритмы.Вызвать(""НепосредственныйРуководительСотрудника"", ПараметрыАлгоритма);
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ВсеРуководителиПодготовившегоДокумент";
	Стр.Выражение = "Результат = Новый Массив;
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка) Тогда
		|	ПараметрыАлгоритма = Новый Структура(""Сотрудник"", Объект.Подготовил);
		|	Результат = Справочники.Алгоритмы.Вызвать(""ВсеРуководителиСотрудника"", ПараметрыАлгоритма);
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ВсеПодчиненныеПодготовившегоДокумент";
	Стр.Выражение = "Результат = Новый Массив;
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка) Тогда
		|	ПараметрыАлгоритма = Новый Структура(""Сотрудник"", Объект.Подготовил);
		|	Результат = Справочники.Алгоритмы.Вызвать(""ВсеПодчиненныеСотрудника"", ПараметрыАлгоритма);
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ВсеКоллегиПодготовившегоДокумент";
	Стр.Выражение = "Результат = Новый Массив;
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка) Тогда
		|	ПараметрыАлгоритма = Новый Структура(""Сотрудник"", Объект.Подготовил);
		|	Результат = Справочники.Алгоритмы.Вызвать(""ВсеКоллегиСотрудника"", ПараметрыАлгоритма);
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "НепосредственныйРуководительИсполнителя";
	Стр.Выражение =
		"Результат = Справочники.Сотрудники.ПустаяСсылка();
		|Если ТипЗнч(Объект.ТекущийИсполнитель) = Тип(""СправочникСсылка.Пользователи"") Тогда
		|	ПараметрыАлгоритма = Новый Структура(""Пользователь"", Объект.ТекущийИсполнитель);
		|	Результат = Справочники.Алгоритмы.Вызвать(""НепосредственныйРуководительПользователя"", ПараметрыАлгоритма);
		|ИначеЕсли ТипЗнч(Объект.ТекущийИсполнитель) = Тип(""СправочникСсылка.Сотрудники"") Тогда
		|	ПараметрыАлгоритма = Новый Структура(""Сотрудник"", Объект.ТекущийИсполнитель);
		|	Результат = Справочники.Алгоритмы.Вызвать(""НепосредственныйРуководительСотрудника"", ПараметрыАлгоритма);
		|ИначеЕсли ТипЗнч(Объект.ТекущийИсполнитель) = Тип(""СправочникСсылка.ПолныеРоли"") Тогда
		|	Запрос = Новый Запрос(
		|		""ВЫБРАТЬ ПЕРВЫЕ 1
		|		|	ИсполнителиРолей.Исполнитель
		|		|ИЗ
		|		|	РегистрСведений.ИсполнителиРолей КАК ИсполнителиРолей
		|		|ГДЕ
		|		|	ИсполнителиРолей.РольИсполнителя = &РольИсполнителя"");
		|	Запрос.Параметры.Вставить(""РольИсполнителя"", Объект.ТекущийИсполнитель);
		|	Выборка = Запрос.Выполнить().Выбрать();
		|	Пока Выборка.Следующий() Цикл
		|		Если ТипЗнч(Выборка.Исполнитель) = Тип(""СправочникСсылка.Пользователи"") Тогда
		|			ПараметрыАлгоритма = Новый Структура(""Пользователь"", Выборка.Исполнитель);
		|			Результат = Справочники.Алгоритмы.Вызвать(""НепосредственныйРуководительПользователя"", ПараметрыАлгоритма);
		|		ИначеЕсли ТипЗнч(Выборка.Исполнитель) = Тип(""СправочникСсылка.Сотрудники"") Тогда
		|			ПараметрыАлгоритма = Новый Структура(""Сотрудник"", Выборка.Исполнитель);
		|			Результат = Справочники.Алгоритмы.Вызвать(""НепосредственныйРуководительСотрудника"", ПараметрыАлгоритма);
		|		КонецЕсли;
		|	КонецЦикла;
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ЗадачиПроцессов;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "НепосредственныйРуководительОтветственногоЗаДокумент";
	Стр.Выражение = "Результат = Справочники.Сотрудники.ПустаяСсылка();
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка)
		|	И ЗначениеЗаполнено(Объект.Ответственный) Тогда
		|	ПараметрыАлгоритма = Новый Структура(""Сотрудник"", Объект.Ответственный);
		|	Результат = Справочники.Алгоритмы.Вызвать(""НепосредственныйРуководительСотрудника"", ПараметрыАлгоритма);
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ВсеРуководителиОтветственногоЗаДокумент";
	Стр.Выражение = "Результат = Новый Массив;
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка)
		|	И ЗначениеЗаполнено(Объект.Ответственный) Тогда
		|	ПараметрыАлгоритма = Новый Структура(""Сотрудник"", Объект.Ответственный);
		|	Результат = Справочники.Алгоритмы.Вызвать(""ВсеРуководителиСотрудника"", ПараметрыАлгоритма);
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ВсеПодчиненныеОтветственногоЗаДокумент";
	Стр.Выражение = "Результат = Новый Массив;
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка)
		|	И ЗначениеЗаполнено(Объект.Ответственный) Тогда
		|	ПараметрыАлгоритма = Новый Структура(""Сотрудник"", Объект.Ответственный);
		|	Результат = Справочники.Алгоритмы.Вызвать(""ВсеПодчиненныеСотрудника"", ПараметрыАлгоритма);
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ВсеКоллегиОтветственногоЗаДокумент";
	Стр.Выражение = "Результат = Новый Массив;
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка)
		|	И ЗначениеЗаполнено(Объект.Ответственный) Тогда
		|	ПараметрыАлгоритма = Новый Структура(""Сотрудник"", Объект.Ответственный);
		|	Результат = Справочники.Алгоритмы.Вызвать(""ВсеКоллегиСотрудника"", ПараметрыАлгоритма);
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ВсеСогласовавшиеДокумент";
	Стр.Выражение = "Результат = Новый Массив;
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка) Тогда
		|	ПараметрыАлгоритма = Новый Структура(""Документ, ТолькоАктивные"", Объект.Ссылка, Истина);
		|	ВсеВизыДокумента = Справочники.Алгоритмы.Вызвать(""ВсеВизыДокумента"", ПараметрыАлгоритма);
		|	Для Каждого СтрВиза Из ВсеВизыДокумента Цикл
		|		Если СтрВиза.РезультатСогласования <> Перечисления.РезультатыСогласования.НеСогласовано Тогда
		|			Если ЗначениеЗаполнено(СтрВиза.РольИсполнителя) Тогда
		|				Результат.Добавить(СтрВиза.РольИсполнителя);
		|			Иначе
		|				Результат.Добавить(СтрВиза.Исполнитель);
		|			КонецЕсли;
		|		КонецЕсли;
		|	Конеццикла;
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	// Мероприятия.
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ПредседательМероприятия";
	Стр.Выражение = "Результат = Справочники.Сотрудники.ПустаяСсылка();
		|Если ТипЗнч(Объект) = Тип(""СправочникОбъект.Мероприятия"") Тогда
		|	Результат = Объект.Председатель;
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.Мероприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "СекретарьМероприятия";
	Стр.Выражение = "Результат = Справочники.Сотрудники.ПустаяСсылка();
		|Если ТипЗнч(Объект) = Тип(""СправочникОбъект.Мероприятия"") Тогда
		|	Результат = Объект.Секретарь;
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.Мероприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ОрганизаторМероприятия";
	Стр.Выражение = "Результат = Справочники.Сотрудники.ПустаяСсылка();
		|Если ТипЗнч(Объект) = Тип(""СправочникОбъект.Мероприятия"") Тогда
		|	Результат = Объект.Организатор;
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.Мероприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "КураторМероприятия";
	Стр.Выражение = "Результат = Справочники.Сотрудники.ПустаяСсылка();
		|Если ТипЗнч(Объект) = Тип(""СправочникОбъект.Мероприятия"") Тогда
		|	Результат = Объект.Куратор;
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.Мероприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ОтветственныеЗаПрограммуМероприятия";
	Стр.Выражение = "Результат = Новый Массив;
		|Если ТипЗнч(Объект) = Тип(""СправочникОбъект.Мероприятия"") Тогда
		|	Для Каждого СтрокаПрограммы Из Объект.Программа Цикл
		|		Если Не ЗначениеЗаполнено(СтрокаПрограммы.Исполнитель)
		|			Или Результат.Найти(СтрокаПрограммы.Исполнитель) <> Неопределено Тогда
		|			Продолжить;
		|		КонецЕсли;
		|		Результат.Добавить(СтрокаПрограммы.Исполнитель);
		|	КонецЦикла;
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.Мероприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "УчастникиМероприятия";
	Стр.Выражение = "Результат = Новый Массив;
		|Если ТипЗнч(Объект) = Тип(""СправочникОбъект.Мероприятия"") Тогда
		|	УчастникиМероприятия = УправлениеМероприятиями.ПолучитьУчастниковМероприятия(
		|		Объект.Ссылка,
		|		Истина);
		|	УчастникиМероприятияПрисутствовали = УчастникиМероприятия.Скопировать(
		|		УчастникиМероприятия.НайтиСтроки(Новый Структура(""Отсутствовал"", Ложь)));
		|	Результат = УчастникиМероприятияПрисутствовали.ВыгрузитьКолонку(""Исполнитель"");
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.Мероприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ИсполнителиПротоколаМероприятия";
	Стр.Выражение =
		"Результат = Новый Массив;
		|Если ТипЗнч(Объект) = Тип(""СправочникОбъект.Мероприятия"") Тогда
		|	
		|	ПротоколМероприятия = УправлениеМероприятиями.ПолучитьПротоколМероприятия(Объект.Ссылка);
		|	ЭтоПротоколСтарогоФормата =
		|		УправлениеМероприятиямиКлиентСервер.ЭтоПротоколСтарогоФормата(ПротоколМероприятия);
		|	Для Каждого ПунктПротокола Из ПротоколМероприятия Цикл
		|		
		|		НомерПунктаПротокола =
		|			УправлениеМероприятиямиКлиентСервер.ПолучитьНомерПунктаСтрокиПротокола(
		|				ПунктПротокола,
		|				ПротоколМероприятия,
		|				ЭтоПротоколСтарогоФормата);
		|		
		|		ДанныеПункта = Новый Структура(""Идентификатор, Автор, Контролер, Номер, Описание, Срок"");
		|		ДанныеПункта.Идентификатор = ПунктПротокола.Ссылка.УникальныйИдентификатор();
		|		ДанныеПункта.Автор = ПунктПротокола.Автор;
		|		ДанныеПункта.Контролер = ПунктПротокола.Контролер;
		|		ДанныеПункта.Номер = НомерПунктаПротокола;
		|		ДанныеПункта.Описание = ПунктПротокола.Решили;
		|		ДанныеПункта.Срок = ПунктПротокола.СрокИсполненияПроцесса;
		|		
		|		ЕстьИсполнители = Ложь;
		|		Для Каждого СтрокаИсполнителяПротокола Из ПунктПротокола.Исполнители Цикл
		|			
		|			Если Не ЗначениеЗаполнено(СтрокаИсполнителяПротокола.Исполнитель) Тогда 
		|				Продолжить;
		|			КонецЕсли;
		|			
		|			ЕстьИсполнители = Истина;
		|			
		|			СтрокаРезультата = Новый Структура(
		|				""Исполнитель, Срок, СрокМинуты, СрокЧасы, СрокДни, ВариантУстановкиСрока, НаименованиеЗадачи, Описание,
		|				|ДанныеПункта, Защищенный, ИдентификаторПункта, ФункцияУчастника"");
		|			СтрокаРезультата.Исполнитель = СтрокаИсполнителяПротокола.Исполнитель;
		|			СтрокаРезультата.Защищенный = Истина;
		|			СтрокаРезультата.СрокМинуты = 0;
		|			СтрокаРезультата.СрокЧасы = 0;
		|			СтрокаРезультата.СрокДни = 0;
		|			СтрокаРезультата.Срок = ДанныеПункта.Срок;
		|			СтрокаРезультата.ВариантУстановкиСрока =
		|				Перечисления.ВариантыУстановкиСрокаИсполнения.ТочныйСрок;
		|			СтрокаРезультата.Описание = ДанныеПункта.Описание;
		|			СтрокаРезультата.ФункцияУчастника = Перечисления.ФункцииУчастниковИсполнения.Исполнитель;
		|			
		|			СтрокаРезультата.ДанныеПункта = ДанныеПункта;
		|			СтрокаРезультата.ИдентификаторПункта = ДанныеПункта.Идентификатор;
		|			
		|			СтрокаРезультата.НаименованиеЗадачи = СтрШаблон(
		|				НСтр(""ru = 'Исполнить пункт № %1'""),
		|				ДанныеПункта.Номер);
		|			
		|			Результат.Добавить(СтрокаРезультата);
		|			
		|		КонецЦикла;
		|		
		|		Если ЕстьИсполнители И ЗначениеЗаполнено(ПунктПротокола.Проверяющий) Тогда 
		|			
		|			СтрокаРезультата = Новый Структура(
		|				""Исполнитель, Срок, СрокМинуты, СрокЧасы, СрокДни, ВариантУстановкиСрока, НаименованиеЗадачи, Описание,
		|				|ДанныеПункта, Защищенный, ИдентификаторПункта, ФункцияУчастника"");
		|			СтрокаРезультата.Исполнитель = ПунктПротокола.Проверяющий;
		|			СтрокаРезультата.Защищенный = Истина;
		|			СтрокаРезультата.СрокМинуты = 0;
		|			СтрокаРезультата.СрокЧасы = 0;
		|			СтрокаРезультата.СрокДни = 0;
		|			СтрокаРезультата.Срок = ДанныеПункта.Срок;
		|			СтрокаРезультата.ВариантУстановкиСрока =
		|				Перечисления.ВариантыУстановкиСрокаИсполнения.ТочныйСрок;
		|			СтрокаРезультата.Описание = ДанныеПункта.Описание;
		|			СтрокаРезультата.ФункцияУчастника = Перечисления.ФункцииУчастниковИсполнения.ОбрабатывающийРезультат;
		|			
		|			СтрокаРезультата.ДанныеПункта = ДанныеПункта;
		|			СтрокаРезультата.ИдентификаторПункта = ДанныеПункта.Идентификатор;
		|			
		|			Результат.Добавить(СтрокаРезультата);
		|			
		|		КонецЕсли;
		|		
		|	КонецЦикла;
		|	
		|КонецЕсли;";	
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.Мероприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ИсполнителиПротоколаМероприятияДляКоторыхТребуетсяИсполнение";
	Стр.Выражение =
		"Результат = Новый Массив;
		|Если ТипЗнч(Объект) = Тип(""СправочникОбъект.Мероприятия"") Тогда
		|	
		|	ПротоколМероприятия = УправлениеМероприятиями.ПолучитьПротоколМероприятия(Объект.Ссылка);
		|	ЭтоПротоколСтарогоФормата =
		|		УправлениеМероприятиямиКлиентСервер.ЭтоПротоколСтарогоФормата(ПротоколМероприятия);
		|	Для Каждого ПунктПротокола Из ПротоколМероприятия Цикл
		|		
		|		Если ПунктПротокола.СостояниеИсполнения <> Перечисления.СостоянияПротоколовМероприятий.ТребуетсяИсполнение Тогда
		|			Продолжить;
		|		КонецЕсли;
		|		
		|		НомерПунктаПротокола =
		|			УправлениеМероприятиямиКлиентСервер.ПолучитьНомерПунктаСтрокиПротокола(
		|				ПунктПротокола,
		|				ПротоколМероприятия,
		|				ЭтоПротоколСтарогоФормата);
		|		
		|		ДанныеПункта = Новый Структура(""Идентификатор, Автор, Контролер, Номер, Описание, Срок"");
		|		ДанныеПункта.Идентификатор = ПунктПротокола.Ссылка.УникальныйИдентификатор();
		|		ДанныеПункта.Автор = ПунктПротокола.Автор;
		|		ДанныеПункта.Контролер = ПунктПротокола.Контролер;
		|		ДанныеПункта.Номер = НомерПунктаПротокола;
		|		ДанныеПункта.Описание = ПунктПротокола.Решили;
		|		ДанныеПункта.Срок = ПунктПротокола.СрокИсполненияПроцесса;
		|		
		|		ЕстьИсполнители = Ложь;
		|		Для Каждого СтрокаИсполнителяПротокола Из ПунктПротокола.Исполнители Цикл
		|			
		|			Если Не ЗначениеЗаполнено(СтрокаИсполнителяПротокола.Исполнитель) Тогда 
		|				Продолжить;
		|			КонецЕсли;
		|			
		|			ЕстьИсполнители = Истина;
		|			
		|			СтрокаРезультата = Новый Структура(
		|				""Исполнитель, Срок, СрокМинуты, СрокЧасы, СрокДни, ВариантУстановкиСрока, НаименованиеЗадачи, Описание,
		|				|ДанныеПункта, Защищенный, ИдентификаторПункта, ФункцияУчастника"");
		|			СтрокаРезультата.Исполнитель = СтрокаИсполнителяПротокола.Исполнитель;
		|			СтрокаРезультата.Защищенный = Истина;
		|			СтрокаРезультата.СрокМинуты = 0;
		|			СтрокаРезультата.СрокЧасы = 0;
		|			СтрокаРезультата.СрокДни = 0;
		|			СтрокаРезультата.Срок = ДанныеПункта.Срок;
		|			СтрокаРезультата.ВариантУстановкиСрока =
		|				Перечисления.ВариантыУстановкиСрокаИсполнения.ТочныйСрок;
		|			СтрокаРезультата.Описание = ДанныеПункта.Описание;
		|			СтрокаРезультата.ФункцияУчастника = Перечисления.ФункцииУчастниковИсполнения.Исполнитель;
		|			
		|			СтрокаРезультата.ДанныеПункта = ДанныеПункта;
		|			СтрокаРезультата.ИдентификаторПункта = ДанныеПункта.Идентификатор;
		|			
		|			СтрокаРезультата.НаименованиеЗадачи = СтрШаблон(
		|				НСтр(""ru = 'Исполнить пункт № %1'""),
		|				ДанныеПункта.Номер);
		|			
		|			Результат.Добавить(СтрокаРезультата);
		|			
		|		КонецЦикла;
		|		
		|		Если ЕстьИсполнители И ЗначениеЗаполнено(ПунктПротокола.Проверяющий) Тогда 
		|			
		|			СтрокаРезультата = Новый Структура(
		|				""Исполнитель, Срок, СрокМинуты, СрокЧасы, СрокДни, ВариантУстановкиСрока, НаименованиеЗадачи, Описание,
		|				|ДанныеПункта, Защищенный, ИдентификаторПункта, ФункцияУчастника"");
		|			СтрокаРезультата.Исполнитель = ПунктПротокола.Проверяющий;
		|			СтрокаРезультата.Защищенный = Истина;
		|			СтрокаРезультата.СрокМинуты = 0;
		|			СтрокаРезультата.СрокЧасы = 0;
		|			СтрокаРезультата.СрокДни = 0;
		|			СтрокаРезультата.Срок = ДанныеПункта.Срок;
		|			СтрокаРезультата.ВариантУстановкиСрока =
		|				Перечисления.ВариантыУстановкиСрокаИсполнения.ТочныйСрок;
		|			СтрокаРезультата.Описание = ДанныеПункта.Описание;
		|			СтрокаРезультата.ФункцияУчастника = Перечисления.ФункцииУчастниковИсполнения.ОбрабатывающийРезультат;
		|			
		|			СтрокаРезультата.ДанныеПункта = ДанныеПункта;
		|			СтрокаРезультата.ИдентификаторПункта = ДанныеПункта.Идентификатор;
		|			
		|			Результат.Добавить(СтрокаРезультата);
		|			
		|		КонецЕсли;
		|		
		|	КонецЦикла;
		|	
		|КонецЕсли;";	
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.Мероприятия;

	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "ВсеНеСогласовавшиеДокумент";
	Стр.Выражение = "Результат = Новый Массив;
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка) Тогда
		|	ПараметрыАлгоритма = Новый Структура(""Документ, ТолькоАктивные"", Объект.Ссылка, Истина);
		|	ВсеВизыДокумента = Справочники.Алгоритмы.Вызвать(""ВсеВизыДокумента"", ПараметрыАлгоритма);	
		|	Для Каждого СтрВиза Из ВсеВизыДокумента Цикл
		|		Если СтрВиза.РезультатСогласования = Перечисления.РезультатыСогласования.НеСогласовано Тогда
		|			Если ЗначениеЗаполнено(СтрВиза.РольИсполнителя) Тогда
		|				Результат.Добавить(СтрВиза.РольИсполнителя);
		|			Иначе
		|				Результат.Добавить(СтрВиза.Исполнитель);
		|			КонецЕсли;
		|		КонецЕсли;
		|	Конеццикла;
		|КонецЕсли;";
	Стр.ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия;
	
	Стр = ТаблицаЭлементов.Добавить();
	Стр.ИмяПредопределенного = "РуководительПроекта";
	Стр.Выражение = "Результат = Справочники.Сотрудники.ПустаяСсылка();
		|Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект.Ссылка) 
		|	Или ДелопроизводствоКлиентСервер.ЭтоМероприятие(Объект.Ссылка) Тогда
		|	Проект = Объект.Проект;
		|	РуководительПроекта = Неопределено;
		|	Если ЗначениеЗаполнено(Проект) Тогда 
		|		РуководительПроекта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Проект, ""Руководитель"") ;
		|	КонецЕсли;
		|	Если Не ЗначениеЗаполнено(РуководительПроекта) Тогда
		|		// результат остается пустым.
		|	ИначеЕсли ТипЗнч(РуководительПроекта) = Тип(""СправочникСсылка.Пользователи"") Тогда
		|		Результат = Сотрудники.ОсновнойСотрудникПользователя(
		|			РуководительПроекта);
		|	Иначе
		|		Результат = РуководительПроекта;
		|	КонецЕсли;
		|КонецЕсли;";
	
	Для Каждого Стр Из ТаблицаЭлементов Цикл
		
		Попытка
			
			АПСсылка = Справочники.АвтоподстановкиДляОбъектов[Стр.ИмяПредопределенного];
			АПОбъект = АПСсылка.ПолучитьОбъект();
			
			Если АПОбъект.Выражение <> Стр.Выражение Тогда
				АПОбъект.Выражение = Стр.Выражение;
			КонецЕсли;
			
			Если АПОбъект.ТипОбъекта <> Стр.ТипОбъекта Тогда
				АПОбъект.ТипОбъекта = Стр.ТипОбъекта;
			КонецЕсли;
			
			Если АПОбъект.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(АПОбъект);
			КонецЕсли;
			
		Исключение
			
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Ошибка при обновлении предопределенной автоподстановки ""%1"": %2'"),
				Стр.ИмяПредопределенного,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				"АвтоподстановкиДляОбъектов",
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.АвтоподстановкиДляОбъектов,,
				ТекстОшибки);
				
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

// Определяет разделы адресной книги автоподстановки для объектов по типу объекта.
// 
// Параметры:
//  ТипОбъекта - ПеречислениеСсылка.ТипыОбъектов.
// 
// Возвращаемое значение:
//  Массив из СправочникСсылка.АдреснаяКнига - Разделы адресной книги автоподстановки.
//  
Функция РазделыАдреснойКниги(ТипОбъекта) Экспорт
	
	РазделыАдреснойКниги = Новый Массив;
	Если ТипОбъекта = Перечисления.ТипыОбъектов.ДокументыПредприятия Тогда
		
		РазделыАдреснойКниги.Добавить(Справочники.АдреснаяКнига.АвтоподстановкиДляДокументов);
		РазделыАдреснойКниги.Добавить(Справочники.АдреснаяКнига.ВсеАвтоподстановки);
		
	ИначеЕсли ТипОбъекта = Перечисления.ТипыОбъектов.Мероприятия Тогда
		
		РазделыАдреснойКниги.Добавить(Справочники.АдреснаяКнига.АвтоподстановкиДляМероприятий);
		РазделыАдреснойКниги.Добавить(Справочники.АдреснаяКнига.ВсеАвтоподстановки);
		
	ИначеЕсли ТипОбъекта = Перечисления.ТипыОбъектов.ЗадачиПроцессов Тогда
		
		РазделыАдреснойКниги.Добавить(Справочники.АдреснаяКнига.АвтоподстановкиДляЗадачПроцессов);
		РазделыАдреснойКниги.Добавить(Справочники.АдреснаяКнига.ВсеАвтоподстановки);
	
	ИначеЕсли ТипОбъекта = Перечисления.ТипыОбъектов.НаименованияОписанияЗадач Тогда
		
		РазделыАдреснойКниги.Добавить(Справочники.АдреснаяКнига.ВсеАвтоподстановки);
		
	ИначеЕсли ТипОбъекта = Перечисления.ТипыОбъектов.Задача Тогда
		
		РазделыАдреснойКниги.Добавить(Справочники.АдреснаяКнига.АвтоподстановкиДляЗадач);
		РазделыАдреснойКниги.Добавить(Справочники.АдреснаяКнига.ВсеАвтоподстановки);
		
	ИначеЕсли ТипОбъекта = Перечисления.ТипыОбъектов.ПустаяСсылка() Тогда
		
		РазделыАдреснойКниги.Добавить(Справочники.АдреснаяКнига.АвтоподстановкиДляДокументов);
		РазделыАдреснойКниги.Добавить(Справочники.АдреснаяКнига.АвтоподстановкиДляМероприятий);
		РазделыАдреснойКниги.Добавить(Справочники.АдреснаяКнига.АвтоподстановкиДляЗадачПроцессов);
		РазделыАдреснойКниги.Добавить(Справочники.АдреснаяКнига.АвтоподстановкиДляЗадач);
		РазделыАдреснойКниги.Добавить(Справочники.АдреснаяКнига.ВсеАвтоподстановки);
		
	Иначе
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Некорректный тип объекта %1 (%2).'"),
			ТипОбъекта,
			ТипЗнч(ТипОбъекта));
		
	КонецЕсли;
	
	Возврат РазделыАдреснойКниги;
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область ОбновлениеАдреснойКниги

// Конструктор параметров обновления адресной книги.
//
// Возвращаемое значение:
//	Структура:
//		* ОбновитьДанныеОбъекта - Булево - Признак обновления данных по объекту.
//		* ОбновитьДанныеОтображенияОбъекта - Булево - Признак обновления данных отображения.
//		* ОбновитьСловаПоискаПоОбъекту - Булево - Признак обновления слов поиска по объекту.
//		* ОбновитьДоступностьВПоискеПоОбъекту - Булево - Признак обновления доступности в результатах поиска.
//
Функция ПараметрыОбновленияАдреснойКниги() Экспорт
	
	ПараметрыОбновленияАдреснойКниги = Новый Структура;
	ПараметрыОбновленияАдреснойКниги.Вставить("ОбновитьДанныеОбъекта", Ложь);
	ПараметрыОбновленияАдреснойКниги.Вставить("ОбновитьДанныеОтображенияОбъекта", Ложь);
	ПараметрыОбновленияАдреснойКниги.Вставить("ОбновитьСловаПоискаПоОбъекту", Ложь);
	ПараметрыОбновленияАдреснойКниги.Вставить("ОбновитьДоступностьВПоискеПоОбъекту", Ложь);	
	
	Возврат ПараметрыОбновленияАдреснойКниги;
	
КонецФункции

// Устанавливает значения параметров обновления адресной книги по данным объекта.
//
// Параметры:
//	Объект - СправочникОбъект.АвтоподстановкиДляОбъектов - Объект, для которго необходимо определить параметры обновления.
//
// Возвращаемое значение:
//	Структура: см. ПараметрыОбновленияАдреснойКниги.
//
Функция ЗначенияПараметровОбновленияАдреснойКнигиПоОбъекту(Объект) Экспорт
	
	ПараметрыОбновленияАдреснойКниги = ПараметрыОбновленияАдреснойКниги();
		
	Если Не РаботаСАдреснойКнигой.ТребуетсяОбновлениеАдреснойКниги(Объект) Тогда
		Возврат ПараметрыОбновленияАдреснойКниги; 
	КонецЕсли;

	Если Объект.ЭтоНовый() Тогда
		ПараметрыОбновленияАдреснойКниги.ОбновитьДанныеОбъекта = Истина;
		Если Не Объект.ЭтоГруппа Тогда
			ПараметрыОбновленияАдреснойКниги.ОбновитьСловаПоискаПоОбъекту = Истина;
		КонецЕсли;
	Иначе
		ПредыдущиеЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Объект.Ссылка, "Наименование, ПометкаУдаления, Родитель");

		Если ПредыдущиеЗначенияРеквизитов.Родитель <> Объект.Родитель Тогда
			ПараметрыОбновленияАдреснойКниги.ОбновитьДанныеОбъекта = Истина;
		КонецЕсли;
		
		Если ПредыдущиеЗначенияРеквизитов.ПометкаУдаления <> Объект.ПометкаУдаления Тогда
			ПараметрыОбновленияАдреснойКниги.ОбновитьДанныеОбъекта = Истина;
			ПараметрыОбновленияАдреснойКниги.ОбновитьДанныеОтображенияОбъекта = Истина;
			ПараметрыОбновленияАдреснойКниги.ОбновитьДоступностьВПоискеПоОбъекту = Истина;
		КонецЕсли;
		
		Если ПредыдущиеЗначенияРеквизитов.Наименование <> Объект.Наименование Тогда
			ПараметрыОбновленияАдреснойКниги.ОбновитьДанныеОбъекта = Истина;
			ПараметрыОбновленияАдреснойКниги.ОбновитьДанныеОтображенияОбъекта = Истина;
			Если Не Объект.ЭтоГруппа Тогда
				ПараметрыОбновленияАдреснойКниги.ОбновитьСловаПоискаПоОбъекту = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПараметрыОбновленияАдреснойКниги;

КонецФункции

// Обновляет адресную книгу, согласно установленным параметрам.
//
// Параметры:
//	Объект - СправочникОбъект.АвтоподстановкиДляОбъектов - Объект, по данным которого необходимо обновить адресной книги.
//	ПараметрыОбновления - Структура Из КлючИЗначение - см. ПараметрыОбновленияАдреснойКниги.
//
Процедура ОбновитьАдреснуюКнигу(Объект, ПараметрыОбновления) Экспорт
	
	Если ПараметрыОбновления.ОбновитьДанныеОбъекта Тогда
		РазделыАдреснойКниги = РазделыАдреснойКниги(Объект.ТипОбъекта);
		Для Каждого РазделАдреснойКниги Из РазделыАдреснойКниги Цикл
			Справочники.АдреснаяКнига.ОбновитьДанныеОбъекта(
				Объект.Ссылка, Объект.Родитель, РазделАдреснойКниги);
		КонецЦикла;
	КонецЕсли;
	
	Если ПараметрыОбновления.ОбновитьДанныеОтображенияОбъекта Тогда
		Справочники.АдреснаяКнига.ОбновитьДанныеОтображенияПодчиненногоОбъекта(Объект.Ссылка);
	КонецЕсли;
	
	Если ПараметрыОбновления.ОбновитьСловаПоискаПоОбъекту Тогда
		РегистрыСведений.ОбъектыПоискаВАдреснойКниге.ОбновитьСловаПоискаПоАвтоподстановкеДляОбъектов(Объект);
	КонецЕсли;
	
	Если ПараметрыОбновления.ОбновитьДоступностьВПоискеПоОбъекту Тогда
		РегистрыСведений.ОбъектыПоискаВАдреснойКниге.ОбновитьДоступностьВПоиске(Объект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
