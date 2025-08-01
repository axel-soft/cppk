﻿// РАБОТА С ДОКУМЕНТАМИ

#Область ПрограммныйИнтерфейс

// Возвращает максимальное значение реквизита Порядок в комплекте
//
Функция ПолучитьМаксПорядокВКомплекте(Комплект)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЕстьNULL(МАКСИМУМ(СвязиОбъектов.Порядок),0) КАК МаксПорядок
	|ИЗ
	|	РегистрСведений.СвязиОбъектов КАК СвязиОбъектов
	|ГДЕ
	|	СвязиОбъектов.Объект = &Комплект
	|	И СвязиОбъектов.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.Содержит)");
	Запрос.УстановитьПараметр("Комплект", Комплект);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить()[0].МаксПорядок;
	
КонецФункции

// Возвращает структуру с информацией о комплектующих
//
Функция ПолучитьИнформациюОКомплектующих(Комплект, ПолучитьРеквизиты = Истина) Экспорт
	
	Инфо = Новый Структура;
	Инфо.Вставить("Комплект", Комплект);
	Инфо.Вставить("Элементы", Новый Массив);
	Инфо.Вставить("Строки", Новый Массив);
	
	ПравоДоступаФайлыЧтение = ПравоДоступа("Чтение", Метаданные.Справочники.Файлы);
	ПравоДоступаДокументыПредприятияЧтение = ПравоДоступа("Чтение", Метаданные.Справочники.ДокументыПредприятия);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СвязиОбъектов.СвязанныйОбъект КАК Ссылка,
	|	СвязиОбъектов.Комментарий КАК Комментарий,
	|	СвязиОбъектов.Порядок КАК Порядок
	|ИЗ
	|	РегистрСведений.СвязиОбъектов КАК СвязиОбъектов
	|ГДЕ
	|	СвязиОбъектов.Объект = &Комплект
	|	И СвязиОбъектов.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.Содержит)");
	Запрос.УстановитьПараметр("Комплект", Комплект);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Если ПравоДоступаФайлыЧтение Тогда
		ФайлыСтроки = Новый Массив;
		ФайлыСсылки = Новый Массив;
		Для каждого РезультатЗапросаСтрока Из РезультатЗапроса Цикл
			Если ТипЗнч(РезультатЗапросаСтрока.Ссылка) = Тип("СправочникСсылка.Файлы") Тогда
				Если ПолучитьРеквизиты Тогда
					ФайлыСтроки.Добавить(РезультатЗапросаСтрока);
					ФайлыСсылки.Добавить(РезультатЗапросаСтрока.Ссылка);
				КонецЕсли;
				Инфо.Элементы.Добавить(РезультатЗапросаСтрока.Ссылка);
			КонецЕсли;
		КонецЦикла;
		Если ПолучитьРеквизиты Тогда
			СвойстваКомплектующих = ПолучитьСвойстваКомплектующихФайлы(ФайлыСсылки);
			Для каждого ФайлыСтрока Из ФайлыСтроки Цикл
				ЭлементИнфо = НоваяСтруктураИнформацииОКомплектующем();
				ЗаполнитьЗначенияСвойств(ЭлементИнфо, ФайлыСтрока);
				ЗаполнитьЗначенияСвойств(ЭлементИнфо, СвойстваКомплектующих.Получить(ФайлыСтрока.Ссылка));
				Инфо.Строки.Добавить(ЭлементИнфо)
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если ПравоДоступаДокументыПредприятияЧтение Тогда
		ДокументыПредприятияСтроки = Новый Массив;
		ДокументыПредприятияСсылки = Новый Массив;
		Для каждого РезультатЗапросаСтрока Из РезультатЗапроса Цикл
			Если ТипЗнч(РезультатЗапросаСтрока.Ссылка) = Тип("СправочникСсылка.ДокументыПредприятия") Тогда
				Если ПолучитьРеквизиты Тогда
					ДокументыПредприятияСтроки.Добавить(РезультатЗапросаСтрока);
					ДокументыПредприятияСсылки.Добавить(РезультатЗапросаСтрока.Ссылка);
				КонецЕсли;
				Инфо.Элементы.Добавить(РезультатЗапросаСтрока.Ссылка);
			КонецЕсли;
		КонецЦикла;
		Если ПолучитьРеквизиты Тогда
			СвойстваКомплектующих = ПолучитьСвойстваКомплектующихДокументыПредприятия(ДокументыПредприятияСсылки);
			Для каждого ДокументыПредприятияСтрока Из ДокументыПредприятияСтроки Цикл
				ЭлементИнфо = НоваяСтруктураИнформацииОКомплектующем();
				ЗаполнитьЗначенияСвойств(ЭлементИнфо, ДокументыПредприятияСтрока);
				ЗаполнитьЗначенияСвойств(ЭлементИнфо, СвойстваКомплектующих.Получить(ДокументыПредприятияСтрока.Ссылка));
				Инфо.Строки.Добавить(ЭлементИнфо)
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Инфо;
	
КонецФункции

Функция НоваяСтруктураИнформацииОКомплектующем()
	Возврат Новый Структура("Ссылка, Комментарий, Порядок, Наименование, Состояние, Задачи, ИндексКартинки, Редактирует, РедактируетТекущийПользователь");
КонецФункции

// Возвращает Соответствие
// Результат (Соответствие)
// - Ключ (Ссылка)
// - Значение (Структура)
//   - Ссылка
//   - Наименование
//   - Состояние
//   - Задачи
//   - ИндексКартинки
//   - Редактирует
//   - РедактируетТекущийПользователь
//
// Параметры
// - Элементы (Массив)
//
Функция ПолучитьСвойстваКомплектующих(Элементы)
	
	Результат = Новый Соответствие;
	
	Файлы = ОтобратьПоТипу(Элементы, Тип("СправочникСсылка.Файлы"));
	Если Файлы.Количество() > 0 Тогда
		РезультатФайлы = ПолучитьСвойстваКомплектующихФайлы(Файлы);
		Для каждого КлючЗначение Из РезультатФайлы Цикл
			Результат.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ДокументыПредприятия = ОтобратьПоТипу(Элементы, Тип("СправочникСсылка.ДокументыПредприятия"));
	Если ДокументыПредприятия.Количество() > 0 Тогда
		РезультатДокументыПредприятия = ПолучитьСвойстваКомплектующихДокументыПредприятия(ДокументыПредприятия);
		Для каждого КлючЗначение Из РезультатДокументыПредприятия Цикл
			Результат.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСвойстваКомплектующихФайлы(Элементы)
	
	Результат = Новый Соответствие;
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.Файлы) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Комплектующие.Ссылка КАК Ссылка,
	|	Комплектующие.Наименование КАК Наименование,
	|	НЕОПРЕДЕЛЕНО КАК Состояние,
	|	ВЫБОР
	|		КОГДА ИСТИНА В
	|			(ВЫБРАТЬ ПЕРВЫЕ 1
	|				ИСТИНА
	|			ИЗ
	|				Задача.ЗадачаИсполнителя.Предметы КАК ПредметыЗадач
	|			ГДЕ
	|				ПредметыЗадач.Предмет = Комплектующие.Ссылка
	|				И НЕ ПредметыЗадач.Ссылка.Выполнена)
	|			ТОГДА 1
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК Задачи,
	|	0 КАК ИндексКартинки,
	|	ВЫБОР
	|		КОГДА Комплектующие.Редактирует = Неопределено
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка)
	|		ИНАЧЕ Комплектующие.Редактирует
	|	КОНЕЦ КАК Редактирует,
	|	ВЫБОР
	|	КОГДА Комплектующие.Редактирует В (&ПользовательИЕгоСотрудники)
	|		ТОГДА ИСТИНА
	|	ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК РедактируетТекущийПользователь,
	|	Комплектующие.ТекущаяВерсияРасширение КАК ТекущаяВерсияРасширение
	|ИЗ
	|	Справочник.Файлы КАК Комплектующие
	|ГДЕ
	|	Комплектующие.Ссылка В (&Комплектующие)");
	Запрос.УстановитьПараметр("Комплектующие", Элементы);
	ПользовательИЕгоСотрудники 
		= СотрудникиВызовСервера.ПользовательИЕгоСотрудники(Пользователи.ТекущийПользователь());	
	Запрос.УстановитьПараметр("ПользовательИЕгоСотрудники", ПользовательИЕгоСотрудники);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Свойства = Новый Структура("Ссылка, Наименование, Состояние, Задачи, 
		|ИндексКартинки, Редактирует, РедактируетТекущийПользователь");
		ЗаполнитьЗначенияСвойств(Свойства, Выборка);
		Если ЭтоФайл(Выборка.Ссылка) Тогда
			Свойства.Вставить("ИндексКартинки", 
				ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(Выборка.ТекущаяВерсияРасширение));
		КонецЕсли;
		Результат.Вставить(Выборка.Ссылка, Свойства);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСвойстваКомплектующихДокументыПредприятия(Элементы)
	
	Результат = Новый Соответствие;
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.ДокументыПредприятия) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеДокументовПредприятия.Документ КАК Документ,
	|	ДанныеДокументовПредприятия.ПредставлениеСостояния КАК Состояние,
	|	ДанныеДокументовПредприятия.СостояниеОбработки КАК СостояниеОбработки
	|ПОМЕСТИТЬ ДанныеДокументов
	|ИЗ
	|	РегистрСведений.ДанныеДокументовПредприятия КАК ДанныеДокументовПредприятия
	|ГДЕ
	|	ДанныеДокументовПредприятия.Документ В (&Комплектующие)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Комплектующие.Ссылка КАК Ссылка,
	|	Комплектующие.Наименование КАК Наименование,
	|	ДанныеДокументов.Состояние КАК Состояние,
	|	ВЫБОР
	|		КОГДА Комплектующие.ВидДокумента.ЯвляетсяКомплектомДокументов = ИСТИНА
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЯвляетсяКомплектомДокументов,
	|	ВЫБОР
	|		КОГДА ДанныеДокументов.СостояниеОбработки = ЗНАЧЕНИЕ(Перечисление.СостоянияОбработкиОбъектов.Завершена)
	|			ТОГДА 0
	|		КОГДА ДанныеДокументов.СостояниеОбработки = ЗНАЧЕНИЕ(Перечисление.СостоянияОбработкиОбъектов.Выполняется)
	|			ТОГДА 1
	|		КОГДА ДанныеДокументов.СостояниеОбработки = ЗНАЧЕНИЕ(Перечисление.СостоянияОбработкиОбъектов.Остановлена)
	|			ТОГДА 2
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК Задачи,
	|	ВЫБОР
	|		КОГДА Комплектующие.ВидДокумента.ЯвляетсяКомплектомДокументов = ИСТИНА
	|			ТОГДА 2
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ИндексКартинки,
	|	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка) КАК Редактирует,
	|	ЛОЖЬ КАК РедактируетТекущийПользователь
	|ИЗ
	|	Справочник.ДокументыПредприятия КАК Комплектующие
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеДокументов КАК ДанныеДокументов
	|		ПО Комплектующие.Ссылка = ДанныеДокументов.Документ
	|ГДЕ
	|	Комплектующие.Ссылка В (&Комплектующие)");
	Запрос.УстановитьПараметр("Комплектующие", Элементы);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Свойства = Новый Структура("Ссылка, Наименование, Состояние, Задачи,
		| ИндексКартинки, Редактирует, РедактируетТекущийПользователь");
		ЗаполнитьЗначенияСвойств(Свойства, Выборка);
		Результат.Вставить(Выборка.Ссылка, Свойства);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОтобратьПоТипу(МассивЭлементов, Тип)
	Результат = Новый Массив;
	Для каждого Элемент Из МассивЭлементов Цикл
		Если ТипЗнч(Элемент) = Тип Тогда
			Результат.Добавить(Элемент);
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ФормаПолучитьИнформациюОКомплектующих(Форма)
	
	Инфо = Новый Структура;
	Инфо.Вставить("Комплект", Форма.Объект.Ссылка);
	Инфо.Вставить("Элементы", Новый Массив);
	Инфо.Вставить("Строки", Новый Массив);
	Для каждого СоставКомплектаСтрока Из Форма.СоставКомплекта.ПолучитьЭлементы() Цикл
		Если ЗначениеЗаполнено(СоставКомплектаСтрока.Ссылка) И Инфо.Элементы.Найти(СоставКомплектаСтрока.Ссылка) = Неопределено Тогда
			НоваяСтрока = Новый Структура("Ссылка, Комментарий, Порядок");
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СоставКомплектаСтрока);
			Инфо.Элементы.Добавить(СоставКомплектаСтрока.Ссылка);
			Инфо.Строки.Добавить(НоваяСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Инфо;
	
КонецФункции

Функция ВыбратьПодчиненныеФайлы(Документ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Файлы.Ссылка КАК Ссылка,
	|	Файлы.Наименование КАК Наименование,
	|	Файлы.ПодписанЭП КАК ПодписанЭП
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СлужебныеФайлыДокументов КАК СлужебныеФайлыДокументов
	|		ПО (СлужебныеФайлыДокументов.Файл = Файлы.Ссылка)
	|ГДЕ
	|	Файлы.ВладелецФайла = &ВладелецФайла
	|	И НЕ Файлы.ПометкаУдаления
	|	И СлужебныеФайлыДокументов.Файл ЕСТЬ NULL");
	Запрос.УстановитьПараметр("ВладелецФайла", Документ);
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

// Устанавливает видимость страницы "Состав комплекта" на форме
//
Процедура УстановитьВидимостьСоставаКомплекта(Форма) Экспорт
	ВидимостьСтраницы = (ЗначениеЗаполнено(Форма.Объект.ВидДокумента) И Форма.Объект.ВидДокумента.ЯвляетсяКомплектомДокументов);
	Форма.Элементы.ГруппаСоставКомплекта.Видимость = ВидимостьСтраницы;
КонецПроцедуры

// Модифицирует связи документа в соответствии со списком формы "Состав комплекта"
//
Процедура СохранитьСоставКомплекта(Форма) Экспорт
	ФормаКомплектИнфо = ФормаПолучитьИнформациюОКомплектующих(Форма);
	СохранитьСоставКомплектаВнутр(Форма.Объект.Ссылка, ФормаКомплектИнфо);
	СоставКомплектаОбновитьСписок(Форма, ФормаКомплектИнфо);
КонецПроцедуры

Процедура СохранитьСоставКомплектаВнутр(ОбъектСсылка, ФормаКомплектИнфо)
	
	ФормаЭлементыСоотв = Новый Соответствие;
	Для каждого ФормаСтрока Из ФормаКомплектИнфо.Строки Цикл
		ФормаЭлементыСоотв.Вставить(ФормаСтрока.Ссылка, ФормаСтрока);
	КонецЦикла;
	
	КомплектИнфо = ПолучитьИнформациюОКомплектующих(ОбъектСсылка);
	ЭлементыСоотв = Новый Соответствие;
	Для каждого Строка Из КомплектИнфо.Строки Цикл
		ЭлементыСоотв.Вставить(Строка.Ссылка, Строка);
	КонецЦикла;
	
	УдаляемыеЭлементы = Новый Массив;
	Для каждого Элемент Из КомплектИнфо.Элементы Цикл
		ЭлементИнфо = ЭлементыСоотв.Получить(Элемент);
		ФормаЭлементИнфо = ФормаЭлементыСоотв.Получить(Элемент);
		Если ФормаЭлементИнфо = Неопределено
			Или ФормаЭлементИнфо.Комментарий <> ЭлементИнфо.Комментарий
			Или ФормаЭлементИнфо.Порядок <> ЭлементИнфо.Порядок Тогда
			УдаляемыеЭлементы.Добавить(Элемент);
		КонецЕсли;
	КонецЦикла;
	
	ДобавляемыеЭлементы = Новый Массив;
	Для каждого ФормаЭлемент Из ФормаКомплектИнфо.Элементы Цикл
		ФормаЭлементИнфо = ФормаЭлементыСоотв.Получить(ФормаЭлемент);
		ЭлементИнфо = ЭлементыСоотв.Получить(ФормаЭлемент);
		Если ЭлементИнфо = Неопределено
			Или ЭлементИнфо.Комментарий <> ФормаЭлементИнфо.Комментарий
			Или ЭлементИнфо.Порядок <> ФормаЭлементИнфо.Порядок Тогда
			ДобавляемыеЭлементы.Добавить(ФормаЭлементИнфо);
		КонецЕсли;
	КонецЦикла;
	
	КомментарийБизнесСобытия = "";
	
	Для каждого УдаляемыйЭлемент Из УдаляемыеЭлементы Цикл
		СвязиОбъектов.УдалитьСвязь(ОбъектСсылка, УдаляемыйЭлемент, Справочники.ТипыСвязей.Содержит);
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
			КомментарийБизнесСобытия,
			Символы.ПС,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Удален: %1'"),
				УдаляемыйЭлемент));
	КонецЦикла;
	
	Для каждого ДобавляемыйЭлементИнфо Из ДобавляемыеЭлементы Цикл
		Если Не ЕстьЗацикливание(ОбъектСсылка, ДобавляемыйЭлементИнфо.Ссылка) Тогда
			СвязиОбъектов.СоздатьСвязь(
				ОбъектСсылка,
				ДобавляемыйЭлементИнфо.Ссылка,
				Справочники.ТипыСвязей.Содержит,,,
				ДобавляемыйЭлементИнфо.Комментарий,
				ДобавляемыйЭлементИнфо.Порядок);
			ДобавитьЗначениеКСтрокеЧерезРазделитель(
				КомментарийБизнесСобытия,
				Символы.ПС,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Добавлен: %1'"),
					ДобавляемыйЭлементИнфо.Ссылка));
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПустаяСтрока(КомментарийБизнесСобытия) Тогда
		КонтекстСобытия = Новый Структура("Комментарий", КомментарийБизнесСобытия);
		БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(
			ОбъектСсылка,
			Справочники.ВидыБизнесСобытий.ИзменениеСоставаКомплекта,
			КонтекстСобытия);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает список видов документов предприятия, являющихся комплектами
//
Функция ПолучитьСписокВидовКомплектов() Экспорт
	
	Результат = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыДокументов.Наименование КАК Наименование,
		|	ВидыДокументов.Ссылка
		|ИЗ
		|	Справочник.ВидыДокументов КАК ВидыДокументов
		|ГДЕ
		|	ВидыДокументов.ЯвляетсяКомплектомДокументов
		|	И НЕ ВидыДокументов.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Результат.Добавить(Выборка.Ссылка, Выборка.Наименование);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции


// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ

Функция ЕстьЗацикливание(Корень, ДобавляемыйЭлемент)
	
	Если Корень = ДобавляемыйЭлемент Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ЭтоКомплектДокументов(ДобавляемыйЭлемент) Тогда
		КомплектующиеИнфо = ПолучитьИнформациюОКомплектующих(ДобавляемыйЭлемент, Ложь);
		Для каждого Элемент Из КомплектующиеИнфо.Элементы Цикл
			Если ЕстьЗацикливание(Корень, Элемент) Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура СкопироватьЭлементы(Приемник, Источник)
	Для каждого ЭлементИсточника Из Источник Цикл
		НовыйЭлемент = Приемник.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, ЭлементИсточника.Значение);
		СкопироватьЭлементы(НовыйЭлемент, ЭлементИсточника.Элементы);
	КонецЦикла;
КонецПроцедуры

// Возвращает массив структур, представляющий дерево комплекта документов
// Результат (Массив)
// - Элемент (Структура - Узел дерева)
//   - Значение (Структура)
//     - Ссылка
//     - Наименование
//     - Состояние
//     - Задачи
//     - ИндексКартинки
//     - РедактируетТекущийПользователь
//     - Редактирует
//     - ПодписанЭП
//     - Комментарий
//     - Порядок
//   - Элементы (Массив)
//     - Элемент (Структура - Узел дерева)
Функция ПолучитьДеревоКомплектаДокументов(КомплектИнфо) Экспорт
	
	УстановитьПорядок(КомплектИнфо);
	ЭлементыИнфо = Новый Соответствие;
	Для каждого Строка Из КомплектИнфо.Строки Цикл
		ЭлементыИнфо.Вставить(Строка.Ссылка, Строка);
	КонецЦикла;
	
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("Ссылка");
	Дерево.Колонки.Добавить("Наименование");
	Дерево.Колонки.Добавить("Состояние");
	Дерево.Колонки.Добавить("Задачи");
	Дерево.Колонки.Добавить("ИндексКартинки");
	Дерево.Колонки.Добавить("РедактируетТекущийПользователь");
	Дерево.Колонки.Добавить("Редактирует");
	Дерево.Колонки.Добавить("ПодписанЭП");
	Дерево.Колонки.Добавить("Комментарий");
	Дерево.Колонки.Добавить("Порядок");
	Дерево.Колонки.Добавить("ЯвляетсяКомплектомДокументов");
	Дерево.Колонки.Добавить("ЭтоРольФайла");
	
	ВсеКомплектующие = Новый Массив;
	СвойстваКомплектующих = ПолучитьСвойстваКомплектующих(КомплектИнфо.Элементы);
	Для каждого Элемент Из КомплектИнфо.Элементы Цикл
		ВсеКомплектующие.Добавить(Элемент);
		Корень = Дерево.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(Корень, ЭлементыИнфо.Получить(Элемент));
		ДобавитьВеткуВДерево(Корень, Элемент, ВсеКомплектующие);
	КонецЦикла;
	СвойстваКомплектующих = ПолучитьСвойстваКомплектующих(ВсеКомплектующие);
	ЗаполнитьСвойстваКомплектующих(Дерево, СвойстваКомплектующих);
	
	Дерево.Строки.Сортировать("Порядок");
	
	Возврат МассивСтруктурИзДерева(Дерево);
	
КонецФункции

Процедура УстановитьПорядок(КомплектИнфо)
	
	ТребуетсяУстановкаПорядка = Ложь;
	ТекПорядок = 0;
	Для каждого Строка Из КомплектИнфо.Строки Цикл
		Если Строка.Порядок = -1 Тогда
			ТребуетсяУстановкаПорядка = Истина;
			Если ЗначениеЗаполнено(КомплектИнфо.Комплект) Тогда
				ТекПорядок = Макс(ТекПорядок, ПолучитьМаксПорядокВКомплекте(КомплектИнфо.Комплект) + 1);
				Прервать;
			КонецЕсли;
		КонецЕсли;
		Если Строка.Порядок >= ТекПорядок Тогда
			ТекПорядок = Строка.Порядок + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если ТребуетсяУстановкаПорядка Тогда
		Для каждого Строка Из КомплектИнфо.Строки Цикл
			Если Строка.Порядок = -1 Тогда
				Строка.Порядок = ТекПорядок;
				ТекПорядок = ТекПорядок + 1;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСвойстваКомплектующих(Корень, СвойстваКомплектующих)
	
	Для каждого Элемент Из Корень.Строки Цикл                                          
		Если ЗначениеЗаполнено(Элемент.Ссылка) Тогда
			ЗаполнитьЗначенияСвойств(Элемент, СвойстваКомплектующих.Получить(Элемент.Ссылка));
		КонецЕсли;	
		Если Элемент.Строки.Количество() > 0 Тогда
			ЗаполнитьСвойстваКомплектующих(Элемент, СвойстваКомплектующих);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьВеткуВДерево(Корень, Документ, ВсеКомплектующие)
	
	Если Корень.ЯвляетсяКомплектомДокументов = Истина Тогда
		КомплектИнфо = ПолучитьИнформациюОКомплектующих(Документ);
		ЭлементыСоотв = СоответствиеИзМассиваСтруктур(КомплектИнфо.Строки, "Ссылка");
		Для каждого Элемент Из КомплектИнфо.Элементы Цикл
			ВсеКомплектующие.Добавить(Элемент);
			НовыйКорень = Корень.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйКорень, ЭлементыСоотв.Получить(Элемент));
			Если Не ЭтоФайл(Элемент) Тогда
				ДобавитьВеткуВДерево(НовыйКорень, Элемент, ВсеКомплектующие);
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ЭтоДокумент(Документ) Тогда    
		
		ВидДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "ВидДокумента");
		РолиФайлов = Делопроизводство.РолиФайловДляВидаДокументов(ВидДокумента);
		ИспользоватьРолиФайлов = ПолучитьФункциональнуюОпцию("ИспользоватьРолиФайлов");

		ПодчиненныеФайлы = ВыбратьПодчиненныеФайлы(Документ);
		
		Если РолиФайлов.Количество() = 0 Или Не ИспользоватьРолиФайлов Тогда
			Для каждого ПодчиненныйФайл Из ПодчиненныеФайлы Цикл
				ВсеКомплектующие.Добавить(ПодчиненныйФайл.Ссылка);
				ЗаполнитьЗначенияСвойств(Корень.Строки.Добавить(), ПодчиненныйФайл);
			КонецЦикла;
		Иначе        
			
			МассивФайлов = ПодчиненныеФайлы.ВыгрузитьКолонку("Ссылка");
			МассивКомбинацийРолей = Новый Массив;
			
			ТаблицаФайлы = Делопроизводство.ПолучитьДанныеФайловДляСписка(МассивФайлов,
				Документ,,,МассивКомбинацийРолей);
				
			Для Каждого ОписаниеРоли Из МассивКомбинацийРолей Цикл
				
				Ветка = Корень.Строки.Добавить();
				Ветка.ЭтоРольФайла = Истина;

				Ветка.Наименование = Строка(ОписаниеРоли.Роль);
				Если ОписаниеРоли.Роль = ПредопределенноеЗначение("Справочник.РолиФайлов.ПустаяСсылка") Тогда
					Ветка.Наименование = "<>";
				КонецЕсли;	
				
				Ветка.ЭтоРольФайла = Истина;
				Ветка.ИндексКартинки = 2;
				Ветка.Задачи = 3;
				Ветка.РедактируетТекущийПользователь = Ложь;
				Ветка.Редактирует = Справочники.Сотрудники.ПустаяСсылка();
				
				Для Каждого Стр Из ТаблицаФайлы Цикл
					Если Стр.РольФайла = ОписаниеРоли.Роль Тогда
						ВсеКомплектующие.Добавить(Стр.Ссылка);
						ЗаполнитьЗначенияСвойств(Ветка.Строки.Добавить(), Стр);
					КонецЕсли;
				КонецЦикла;	
				
			КонецЦикла;	
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

// Возвращает соответствие из массива структур. Ключ - реквизит структуры, значение - сама структура.
//
Функция СоответствиеИзМассиваСтруктур(МассивСтруктур, ИмяРеквизита)
	Результат = Новый Соответствие;
	Для каждого Элемент Из МассивСтруктур Цикл
		Результат.Вставить(Элемент[ИмяРеквизита], Элемент);
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция МассивСтруктурИзДерева(Дерево)
	Результат = Новый Массив;
	ДобавитьВеткуВМассивСтруктур(Результат, Дерево);
	Возврат Результат;
КонецФункции

Процедура ДобавитьВеткуВМассивСтруктур(КореньВМассиве, КореньВДереве)
	Для каждого ЭлементДерева Из КореньВДереве.Строки Цикл
		ЭлементМассива = Новый Структура("Значение, Элементы");
		ЭлементМассива.Вставить("Значение", Новый Структура("Ссылка, Наименование, Состояние, Задачи, ИндексКартинки, РедактируетТекущийПользователь, Редактирует, ПодписанЭП, Комментарий, Порядок"));
		ЭлементМассива.Вставить("Элементы", Новый Массив);
		ЗаполнитьЗначенияСвойств(ЭлементМассива.Значение, ЭлементДерева);
		ДобавитьВеткуВМассивСтруктур(ЭлементМассива.Элементы, ЭлементДерева);
		КореньВМассиве.Добавить(ЭлементМассива);
	КонецЦикла;
КонецПроцедуры

Процедура СоставКомплектаОбновитьСписок(Форма, ФормаКомплектующиеИнфо)
	Дерево = ПолучитьДеревоКомплектаДокументов(ФормаКомплектующиеИнфо);
	Форма.СоставКомплекта.ПолучитьЭлементы().Очистить();
	СкопироватьЭлементы(Форма.СоставКомплекта, Дерево);
	Форма.КоличествоЭлементовКомплекта = Форма.СоставКомплекта.ПолучитьЭлементы().Количество();
	Форма.Модифицированность = Истина;
КонецПроцедуры


// ОБРАБОТЧИКИ СОБЫТИЙ

// Заполняет дерево комплекта в карточке документа при чтении на сервере
//
Процедура ДокументПриЧтенииНаСервере(Форма) Экспорт
	
	КэшДокументыПредприятияФормаЭлемента =
		КэшиНаВремяВызоваПовтИсп.КэшДокументыПредприятияФормаЭлемента();
	Если КэшДокументыПредприятияФормаЭлемента.Инициализирован
		И КэшДокументыПредприятияФормаЭлемента.КэшДокумента.ВидДокумента = Форма.Объект.ВидДокумента Тогда
		Форма.ЯвляетсяКомплектом = ЗначениеЗаполнено(КэшДокументыПредприятияФормаЭлемента.КэшДокумента.ВидДокумента) 
			И КэшДокументыПредприятияФормаЭлемента.КэшВидаДокумента.ЯвляетсяКомплектомДокументов;
	Иначе
		Форма.ЯвляетсяКомплектом = ЗначениеЗаполнено(Форма.Объект.ВидДокумента) 
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Форма.Объект.ВидДокумента, "ЯвляетсяКомплектомДокументов");
	КонецЕсли;
		
	Если Форма.ЯвляетсяКомплектом Тогда
		КомплектующиеИнфо = ПолучитьИнформациюОКомплектующих(Форма.Объект.Ссылка);
		Дерево = ПолучитьДеревоКомплектаДокументов(КомплектующиеИнфо);
		Форма.СоставКомплекта.ПолучитьЭлементы().Очистить();
		СкопироватьЭлементы(Форма.СоставКомплекта, Дерево);
		Форма.КоличествоЭлементовКомплекта = Форма.СоставКомплекта.ПолучитьЭлементы().Количество();
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьЭлементКомплекта(КомплектИнфо, КомплектСсылка, Ссылка, Комментарий)
	
	Если КомплектИнфо.Элементы.Найти(Ссылка) <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Ссылка = КомплектСсылка Тогда
		Возврат;
	КонецЕсли;
	Если Не ЭтоДокументИлиФайл(Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	КомплектИнфо.Элементы.Добавить(Ссылка);
	НоваяСтрока = Новый Структура;
	НоваяСтрока.Вставить("Ссылка", Ссылка);
	НоваяСтрока.Вставить("Комментарий", Комментарий);
	НоваяСтрока.Вставить("Порядок", -1);
	КомплектИнфо.Строки.Добавить(НоваяСтрока);
	
КонецПроцедуры

// Заполняет дерево комплекта в карточке документа при создании на сервере,
// обрабатывает передаваемые в форму параметры "ДобавляемыеЭлементыКомплекта",
// "ШаблонДокумента"
//
Процедура ДокументПриСозданииНаСервере(Форма) Экспорт
	
	Если Форма.Параметры.Свойство("ВидКомплекта") Тогда
		Форма.Объект.ВидДокумента = Форма.Параметры.ВидКомплекта;
	КонецЕсли;
	
	КэшДокументыПредприятияФормаЭлемента =
		КэшиНаВремяВызоваПовтИсп.КэшДокументыПредприятияФормаЭлемента();
	Если КэшДокументыПредприятияФормаЭлемента.Инициализирован
		И КэшДокументыПредприятияФормаЭлемента.КэшДокумента.ВидДокумента = Форма.Объект.ВидДокумента Тогда
		Форма.ЯвляетсяКомплектом = (ЗначениеЗаполнено(КэшДокументыПредприятияФормаЭлемента.КэшДокумента.ВидДокумента) 
			И КэшДокументыПредприятияФормаЭлемента.КэшВидаДокумента.ЯвляетсяКомплектомДокументов);
	ИначеЕсли ТипЗнч(Форма.ВидДокументаКэш) = Тип("Структура") Тогда
		Форма.ЯвляетсяКомплектом = Форма.ВидДокументаКэш.ЯвляетсяКомплектомДокументов;
	Иначе
		Форма.ЯвляетсяКомплектом = (ЗначениеЗаполнено(Форма.Объект.ВидДокумента) 
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Форма.Объект.ВидДокумента, "ЯвляетсяКомплектомДокументов"));
	КонецЕсли;
	Форма.Элементы.ГруппаСоставКомплекта.Видимость = Форма.ЯвляетсяКомплектом;
	
	Если Форма.ЯвляетсяКомплектом Тогда
		Если Форма.Параметры.Свойство("ДобавляемыеЭлементыКомплекта") Тогда
			КомплектИнфо = ПолучитьИнформациюОКомплектующих(Форма.Объект.Ссылка);
			Для каждого ДобавляемыйЭлемент Из Форма.Параметры.ДобавляемыеЭлементыКомплекта Цикл
				ДобавитьЭлементКомплекта(КомплектИнфо, Форма.Объект.Ссылка, ДобавляемыйЭлемент, "");
			КонецЦикла;
			СоставКомплектаОбновитьСписок(Форма, КомплектИнфо);
		ИначеЕсли Форма.Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Форма.Параметры.ЗначениеКопирования) Тогда
			КомплектИнфо = ПолучитьИнформациюОКомплектующих(Форма.Параметры.ЗначениеКопирования);
			СоставКомплектаОбновитьСписок(Форма, КомплектИнфо);
		ИначеЕсли Форма.Параметры.Свойство("ШаблонДокумента") И ЗначениеЗаполнено(Форма.Параметры.ШаблонДокумента) Тогда
			КомплектИнфо = ПолучитьИнформациюОКомплектующих(Форма.Параметры.ШаблонДокумента);
			СоставКомплектаОбновитьСписок(Форма, КомплектИнфо);
		КонецЕсли;
		
		Форма.Элементы.ФормаПодписать.Видимость = Ложь;
		Форма.Элементы.ГруппаЭП.Видимость = Ложь;
		// Видимость группы хранения
		Форма.Элементы.СоставСтрока.Видимость = Ложь;
		Форма.Элементы.НоменклатураДел.Видимость = Ложь;
		Форма.Элементы.ДелоТекст.Видимость = Ложь;
		Форма.Элементы.ДекорацияХранение.Видимость = Истина;
		Форма.Элементы.ГруппаХранение.ОтображатьЗаголовок = Ложь;	
		Форма.Элементы.УтверждениеТекст.Видимость = Ложь;
		Форма.Элементы.ПодписьТекст.Видимость = Ложь;
	КонецЕсли;
	
	Форма.ПраваДоступа = "";
	Если ПравоДоступа("Чтение", Метаданные.Справочники.ДокументыПредприятия) Тогда
		ДобавитьЗначениеКСтрокеЧерезРазделитель(Форма.ПраваДоступа, ", ", "ДокументыПредприятия.Чтение");
	КонецЕсли;
	Если ПравоДоступа("Чтение", Метаданные.Справочники.Файлы) Тогда
		ДобавитьЗначениеКСтрокеЧерезРазделитель(Форма.ПраваДоступа, ", ", "Файлы.Чтение");
	КонецЕсли;
	
КонецПроцедуры

// Управляет видимостью элементов управления, связанных с комплектом
// в зависимости от вида документа
//
Процедура ДокументПриИзмененииВидаДокументаНаСервере(Форма) Экспорт
	
	КэшДокументыПредприятияФормаЭлемента =
		КэшиНаВремяВызоваПовтИсп.КэшДокументыПредприятияФормаЭлемента();
	Если КэшДокументыПредприятияФормаЭлемента.Инициализирован
		И КэшДокументыПредприятияФормаЭлемента.КэшДокумента.ВидДокумента = Форма.Объект.ВидДокумента Тогда
		Форма.ЯвляетсяКомплектом = (ЗначениеЗаполнено(КэшДокументыПредприятияФормаЭлемента.КэшДокумента.ВидДокумента) 
			И КэшДокументыПредприятияФормаЭлемента.КэшВидаДокумента.ЯвляетсяКомплектомДокументов);
	ИначеЕсли ТипЗнч(Форма.ВидДокументаКэш) = Тип("Структура") Тогда
		Форма.ЯвляетсяКомплектом = Форма.ВидДокументаКэш.ЯвляетсяКомплектомДокументов;
	Иначе
		Форма.ЯвляетсяКомплектом = (ЗначениеЗаполнено(Форма.Объект.ВидДокумента) 
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Форма.Объект.ВидДокумента, "ЯвляетсяКомплектомДокументов"));
	КонецЕсли;
	
	Если Форма.ЯвляетсяКомплектом Тогда
		Форма.Элементы.ФормаПодписать.Видимость = Ложь;
		Форма.Элементы.ГруппаЭП.Видимость = Ложь;
		// Видимость группы хранения
		Форма.Элементы.СоставСтрока.Видимость = Ложь;
		Форма.Элементы.НоменклатураДел.Видимость = Ложь;
		Форма.Элементы.ДелоТекст.Видимость = Ложь;
		Форма.Элементы.ДекорацияХранение.Видимость = Истина;
		Форма.Элементы.ГруппаХранение.ОтображатьЗаголовок = Ложь;	
		
		Форма.Элементы.УтверждениеТекст.Видимость = Ложь;
		Форма.Элементы.ПодписьТекст.Видимость = Ложь;
		Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаСоставКомплекта;
	Иначе
		Форма.СоставКомплекта.ПолучитьЭлементы().Очистить();
		Форма.КоличествоЭлементовКомплекта = 0;
		Форма.Элементы.ФормаПодписать.Видимость = Истина;
		Форма.Элементы.ГруппаЭП.Видимость = Истина;
		// Видимость группы хранения
		Форма.Элементы.СоставСтрока.Видимость = Истина;
		Форма.Элементы.НоменклатураДел.Видимость = Истина;
		Форма.Элементы.ДелоТекст.Видимость = Истина;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьНоменклатуруДел") 
		Или ПолучитьФункциональнуюОпцию("ИспользоватьСоставДокументов")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьНоменклатуруДелВоВнутренних") Тогда
			Форма.Элементы.ДекорацияХранение.Видимость = Ложь;
			Форма.Элементы.ГруппаХранение.ОтображатьЗаголовок = Истина;		
		Иначе
			Форма.Элементы.ДекорацияХранение.Видимость = Истина;
			Форма.Элементы.ГруппаХранение.ОтображатьЗаголовок = Ложь;		
		Конецесли;
	КонецЕсли;
	УстановитьВидимостьСоставаКомплекта(Форма);
	
КонецПроцедуры


// ПРОВЕРКИ ТИПА

Функция ЭтоФайл(Значение)
	
	Возврат ТипЗнч(Значение) = Тип("СправочникСсылка.Файлы");
	
КонецФункции

Функция ЭтоДокумент(Значение)
	
	Возврат ТипЗнч(Значение) = Тип("СправочникСсылка.ДокументыПредприятия");
	
КонецФункции

Функция ЭтоДокументИлиФайл(Значение)
	
	Возврат ТипЗнч(Значение) = Тип("СправочникСсылка.ДокументыПредприятия")
		Или ТипЗнч(Значение) = Тип("СправочникСсылка.Файлы");
	
КонецФункции

Функция ЭтоКомплектДокументов(ДокументСсылка)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДокументыПредприятия.Ссылка
		|ИЗ
		|	Справочник.ДокументыПредприятия КАК ДокументыПредприятия
		|ГДЕ
		|	ДокументыПредприятия.ВидДокумента.ЯвляетсяКомплектомДокументов
		|	И ДокументыПредприятия.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

// Устанавливает является ли документ комплектом
//
// Параметры
//    Документ - любая ссылка - проверяемый документ
//
// Возвращаемое значение
//    Булево - Истина, если документ является комплектом, Ложь в противном случае
//
Функция ЭтоКомплект(Документ) Экспорт
	
	Возврат
		ТипЗнч(Документ) = Тип("СправочникСсылка.ДокументыПредприятия")
		И ЗначениеЗаполнено(Документ.ВидДокумента)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ.ВидДокумента, "ЯвляетсяКомплектомДокументов");
	
КонецФункции

#КонецОбласти