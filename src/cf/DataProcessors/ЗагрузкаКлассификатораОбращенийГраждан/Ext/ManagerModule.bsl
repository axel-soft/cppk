﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует описание классификатора обращений граждан
// Параметры:
//	Отсутствуют
//
// Возвращает:
//	Структуру, содержащую поля соответствующие видам элементов классификатора:
//		Разделы - Структура - см. описание ПодготовитьОписаниеЭлементаКлассификатора 
//		Тематики - Структура - см. описание ПодготовитьОписаниеЭлементаКлассификатора 
//		Темы - Структура - см. описание ПодготовитьОписаниеЭлементаКлассификатора 
//		Вопросы - Структура - см. описание ПодготовитьОписаниеЭлементаКлассификатора 
Функция ПолучитьДанныеКлассификатора() Экспорт
		
	Классификатор = ПолучитьОбщийМакет("КлассификаторОбращенийГраждан");
	Разделы	 = Классификатор.ПолучитьОбласть("Разделы");
	Тематики = Классификатор.ПолучитьОбласть("Тематики");
	Темы	 = Классификатор.ПолучитьОбласть("Темы");
	Вопросы	 = Классификатор.ПолучитьОбласть("Вопросы");
	
	ОбластьКодЛево			 = Классификатор.Области.Код.Лево;
	ОбластьКодПраво			 = Классификатор.Области.Код.Право;
	ОбластьНаименованиеЛево	 = Классификатор.Области.Наименование.Лево;
	ОбластьНаименованиеПраво = Классификатор.Области.Наименование.Право;
	
	СтруктураКлассификатора = Новый Структура("Разделы, Тематики, Темы, Вопросы",
		ПодготовитьОписаниеЭлементаКлассификатора(1),
		ПодготовитьОписаниеЭлементаКлассификатора(2),
		ПодготовитьОписаниеЭлементаКлассификатора(3, 2),
		ПодготовитьОписаниеЭлементаКлассификатора(4));
		
	Для Каждого ЭлементКлассификатора Из СтруктураКлассификатора Цикл
		ОбластьЭлемента = Классификатор.ПолучитьОбласть(ЭлементКлассификатора.Ключ);
		
		Для НомерСтроки = 1 По ОбластьЭлемента.ВысотаТаблицы Цикл
			ОписаниеЭлемента = ЭлементКлассификатора.Значение;
			
			ОписаниеКода = СтрРазделить(ОбластьЭлемента.Область(НомерСтроки, ОбластьКодЛево, НомерСтроки, ОбластьКодПраво).Текст, ".");
			Наименование = ОбластьЭлемента.Область(НомерСтроки, ОбластьНаименованиеЛево, НомерСтроки, ОбластьНаименованиеПраво).Текст;
			
			КодЭлемента	 = 
				?(ОписаниеЭлемента.ПозицияКода > 0 И ОписаниеКода.Количество() >= ОписаниеЭлемента.ПозицияКода,
					ОписаниеКода[ОписаниеЭлемента.ПозицияКода - 1],
					"");
					
			КодВладельца =
				?(ОписаниеЭлемента.ПозицияКодаВладельца > 0 И ОписаниеКода.Количество() >= ОписаниеЭлемента.ПозицияКодаВладельца,
					ОписаниеКода[ОписаниеЭлемента.ПозицияКодаВладельца - 1],
					"");
			
			ЗаполнитьЗначенияСвойств(ЭлементКлассификатора.Значение.Данные.Добавить(),
				Новый Структура("Код, КодВладельца, Наименование", КодЭлемента, КодВладельца, Наименование));
		КонецЦикла;
	КонецЦикла;
	
	Возврат СтруктураКлассификатора;
		
КонецФункции

// Получает данные классификатора обращений граждан и выводит его на форму
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма, на которую требуется вывести данные классификатора.
//	 Должна содержать две таблицы значений "Разделы" и "Вопросы" и одно дерево значений
//	 "ТематикиИТемы"
//
Процедура ЗаполнитьТаблицыФормыДаннымиКлассификатора(Форма) Экспорт
		
	Форма.Разделы.Очистить();
	Форма.Вопросы.Очистить();
	Форма.ТематикиИТемы.ПолучитьЭлементы().Очистить();
	
	ДанныеКлассификатора = ПолучитьДанныеКлассификатора();
	ПодготовленныеДанные = ПодготовитьДанныеКлассификатораКОтображению(ДанныеКлассификатора);	
	
	Форма.Разделы.Загрузить(ПодготовленныеДанные.Разделы.Выгрузить());
	Форма.Вопросы.Загрузить(ПодготовленныеДанные.Вопросы.Выгрузить());
	
	ВыборкаТематика = ПодготовленныеДанные.ТематикиИТемы.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаТематика.Следующий() Цикл
		СтрокаТематика = Форма.ТематикиИТемы.ПолучитьЭлементы().Добавить();
		СтрокаТематика.Код = ВыборкаТематика.КодТематики;
		СтрокаТематика.Наименование = ВыборкаТематика.НаименованиеТематики;
		СтрокаТематика.Выбран = ?(
			ВыборкаТематика.ВыбранЧислом = 0,
			ВыборкаТематика.ВыбранЧислом,
			?(ВыборкаТематика.ВыбранЧислом = ВыборкаТематика.КодТемы, 1, 2));
		СтрокаТематика.ЭлементовНаУровне = ВыборкаТематика.КодТемы;
		СтрокаТематика.ЭлементовВыбрано = ВыборкаТематика.ВыбранЧислом;
		
		ВыборкаТемы = ВыборкаТематика.Выбрать();
		
		Пока ВыборкаТемы.Следующий() Цикл
			СтрокаТема = СтрокаТематика.ПолучитьЭлементы().Добавить();
			СтрокаТема.Код = ВыборкаТемы.КодТемы;
			СтрокаТема.Наименование = ВыборкаТемы.НаименованиеТемы;
			СтрокаТема.Выбран = ВыборкаТемы.Выбран;
		КонецЦикла;
	КонецЦикла;
		
КонецПроцедуры

// Загружает данные классификатора обращений граждан в информационную базу
// Параметры:
//	ДанныеДляЗагрузки - ТаблицаЗначений - см. ПодготовитьТаблицуДляВыводаДанных
//	ПолноеИмяОбъекта - Строка - полное имя объекта метаданых в который будет произведена запись данных
//
// Возвращает:
//	Булево, где Истина - запись данных выполнена успешно
Функция ЗаписатьДанныеКлассификатораВИнформационнуюБазу(ДанныеДляЗагрузки, ПолноеИмяОбъекта) Экспорт
	
	Результат = Истина;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
		ВыполнитьЗаписьДанныхКлассификатора(ДанныеДляЗагрузки, ПолноеИмяОбъекта);
		ЗафиксироватьТранзакцию();
	Исключение
		Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		
		Результат = Ложь;
		
		ВызватьИсключение КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

// Подготавливает данные дерева тематик и тем к записи в информационную базу
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма, из данных которой будет получена информация для записи.
//	 Должна содержать дерево значений "ТематикиИТемы"
//
// Возвращает:
//	Структуру, содержащую поля:
//		Тематики - ТаблицаЗначений - см. ПодготовитьТаблицуДляВыводаДанных
//		Темы - ТаблицаЗначений - см. ПодготовитьТаблицуДляВыводаДанных
Функция ПодготовитьДанныеДереваТематикИТемКЗагрузке(Форма) Экспорт
	
	ТаблицаТематик = ПодготовитьТаблицуДляВыводаДанных();
	ТаблицаТем	   = ПодготовитьТаблицуДляВыводаДанных();
	
	Для Каждого СтрокаТематика Из Форма.ТематикиИТемы.ПолучитьЭлементы() Цикл
		Если Не СтрокаТематика.Выбран Тогда
			Продолжить;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ТаблицаТематик.Добавить(), СтрокаТематика);
		
		Если СтрокаТематика.ПолучитьЭлементы().Количество() Тогда
			Для Каждого СтрокаТема Из СтрокаТематика.ПолучитьЭлементы() Цикл
				Если Не СтрокаТема.Выбран Тогда
					Продолжить;
				КонецЕсли;
				
				СтрокаТаблицыТем = ТаблицаТем.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицыТем, СтрокаТема);
				СтрокаТаблицыТем.КодВладельца = СтрокаТематика.Код;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый Структура("Тематики, Темы", ТаблицаТематик, ТаблицаТем);
	
КонецФункции

Процедура УстановитьСоответствияВопросов() Экспорт 
	
	ДанныеКлассификатора = ПолучитьДанныеКлассификатораУправленияПрезидента();
	ПодготовленныеДанные = ПодготовитьДанныеКлассификатораУправленияПрезидентаКОтображению(ДанныеКлассификатора);
	
	Тематики = ПодготовленныеДанные.Тематики.Выгрузить();
	ТематикиИТемы = ПодготовленныеДанные.ТематикиИТемы.Выгрузить();
	Вопросы = ПодготовленныеДанные.Вопросы.Выгрузить();
	
	СписокСоответствие = Новый Соответствие;
	Для Каждого Строка Из Тематики Цикл
		
		Если Не ЗначениеЗаполнено(Строка.Ссылка) Или Не ЗначениеЗаполнено(Строка.ВладелецСсылка)
			Или Строка.ВладелецВСсылке = Строка.ВладелецСсылка
			Или СписокСоответствие.Получить(Строка.Ссылка) <> Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		ОбъектЗаписи = Строка.Ссылка.ПолучитьОбъект();
		ОбъектЗаписи.Раздел = Строка.ВладелецСсылка;
		ОбъектЗаписи.Записать();
		
		СписокСоответствие.Вставить(Строка.Ссылка, Строка.Ссылка);
		
	КонецЦикла;
	
	СписокСоответствие = Новый Соответствие;
	Для Каждого Строка Из ТематикиИТемы Цикл
		
		Если Не ЗначениеЗаполнено(Строка.Ссылка) Или Не ЗначениеЗаполнено(Строка.ВладелецСсылка)
			Или Строка.ВладелецВСсылке = Строка.ВладелецСсылка
			Или СписокСоответствие.Получить(Строка.Ссылка) <> Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		ОбъектЗаписи = Строка.Ссылка.ПолучитьОбъект();
		ОбъектЗаписи.Тематика = Строка.ВладелецСсылка;
		ОбъектЗаписи.Записать();
		
		СписокСоответствие.Вставить(Строка.Ссылка, Строка.Ссылка);
		
	КонецЦикла;
	
	СписокСоответствие = Новый Соответствие;
	Для Каждого Строка Из Вопросы Цикл
		
		Если Не ЗначениеЗаполнено(Строка.Ссылка) Или Не ЗначениеЗаполнено(Строка.ВладелецСсылка)
			Или Строка.ВладелецВСсылке = Строка.ВладелецСсылка
			Или СписокСоответствие.Получить(Строка.Ссылка) <> Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		ОбъектЗаписи = Строка.Ссылка.ПолучитьОбъект();
		ОбъектЗаписи.Тема = Строка.ВладелецСсылка;
		ОбъектЗаписи.Записать();
		
		СписокСоответствие.Вставить(Строка.Ссылка, Строка.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьДанныеКлассификатораУправленияПрезидента() Экспорт
		
	Классификатор = ПолучитьОбщийМакет("КлассификаторОбращенийГражданУправленияПрезидента");
	Разделы	 = Классификатор.ПолучитьОбласть("Разделы");
	Тематики = Классификатор.ПолучитьОбласть("Тематики");
	Темы	 = Классификатор.ПолучитьОбласть("Темы");
	Вопросы	 = Классификатор.ПолучитьОбласть("Вопросы");
	
	ОбластьКодЛево			 = Классификатор.Области.Код.Лево;
	ОбластьКодПраво			 = Классификатор.Области.Код.Право;
	ОбластьНаименованиеЛево	 = Классификатор.Области.Наименование.Лево;
	ОбластьНаименованиеПраво = Классификатор.Области.Наименование.Право;
	
	СтруктураКлассификатора = Новый Структура("Разделы, Тематики, Темы, Вопросы",
		ПодготовитьОписаниеЭлементаКлассификатора(1),
		ПодготовитьОписаниеЭлементаКлассификатора(2, 1),
		ПодготовитьОписаниеЭлементаКлассификатора(3, 2),
		ПодготовитьОписаниеЭлементаКлассификатора(4, 3));
		
	Для Каждого ЭлементКлассификатора Из СтруктураКлассификатора Цикл
		ОбластьЭлемента = Классификатор.ПолучитьОбласть(ЭлементКлассификатора.Ключ);
		
		Для НомерСтроки = 1 По ОбластьЭлемента.ВысотаТаблицы Цикл
			ОписаниеЭлемента = ЭлементКлассификатора.Значение;
			
			ОписаниеКода = СтрРазделить(ОбластьЭлемента.Область(НомерСтроки, ОбластьКодЛево, НомерСтроки, ОбластьКодПраво).Текст, ".");
			Наименование = ОбластьЭлемента.Область(НомерСтроки, ОбластьНаименованиеЛево, НомерСтроки, ОбластьНаименованиеПраво).Текст;
			
			КодЭлемента	 = 
				?(ОписаниеЭлемента.ПозицияКода > 0 И ОписаниеКода.Количество() >= ОписаниеЭлемента.ПозицияКода,
					ОписаниеКода[ОписаниеЭлемента.ПозицияКода - 1],
					"");
					
			КодВладельца =
				?(ОписаниеЭлемента.ПозицияКодаВладельца > 0 И ОписаниеКода.Количество() >= ОписаниеЭлемента.ПозицияКодаВладельца,
					ОписаниеКода[ОписаниеЭлемента.ПозицияКодаВладельца - 1],
					"");
			
			ЗаполнитьЗначенияСвойств(ЭлементКлассификатора.Значение.Данные.Добавить(),
				Новый Структура("Код, КодВладельца, Наименование", КодЭлемента, КодВладельца, Наименование));
		КонецЦикла;
	КонецЦикла;
	
	Возврат СтруктураКлассификатора;
		
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет запись данных классификатора обращений граждан в информационную базу
// Параметры:
//	ДанныеДляЗагрузки - ТаблицаЗначений - см. ПодготовитьТаблицуДляВыводаДанных
//	ПолноеИмяОбъекта - Строка - полное имя объекта метаданых в который будет произведена запись данных
//
Процедура ВыполнитьЗаписьДанныхКлассификатора(ДанныеДляЗаписи, ПолноеИмяОбъекта)
	
	РедакцияКлассификатора = ДелопроизводствоСерверПовтИсп.РедакцияКлассификатора();
	Запрос = Новый Запрос(ПолучитьТекстЗапроса(ПолноеИмяОбъекта));
	Запрос.УстановитьПараметр("ВыбранныеЭлементы", ДанныеДляЗаписи);
	Запрос.УстановитьПараметр("РедакцияКлассификатора", РедакцияКлассификатора);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.Ссылка) Тогда
			СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
			СправочникОбъект.Заблокировать();
		Иначе 
			СправочникОбъект = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяОбъекта).СоздатьЭлемент();
			СправочникОбъект.Заблокировать();
			СправочникОбъект.РедакцияКлассификатора = РедакцияКлассификатора;
		КонецЕсли;
		
		Если Не СправочникОбъект.ПометкаУдаления = Выборка.ПометкаУдаления Тогда
			СправочникОбъект.УстановитьПометкуУдаления(Выборка.ПометкаУдаления);
			СправочникОбъект.Прочитать();
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СправочникОбъект, Выборка);
		СправочникОбъект.Записать();
		СправочникОбъект.Разблокировать();
	КонецЦикла;
		
КонецПроцедуры

Функция ПолучитьТекстЗапроса(ТипЭлемента)
	
	ТекстЗапроса =
		СтрШаблон(
		"ВЫБРАТЬ
		|	Таблица.Код КАК Код,
		|//ТЕМЫ	Таблица.КодВладельца КАК КодВладельца,
		|	Таблица.Наименование КАК Наименование
		|ПОМЕСТИТЬ ДанныеПользователя
		|ИЗ
		|	&ВыбранныеЭлементы КАК Таблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЕСТЬNULL(ДанныеПользователя.Код, Таблица.Код) КАК Код,
		|	ЕСТЬNULL(ДанныеПользователя.Наименование, Таблица.Наименование) КАК Наименование,
		|//ТЕМЫ	ЕСТЬNULL(ДанныеПользователя.КодВладельца, Таблица.Тематика.Код) КАК КодВладельца,
		|	ЕСТЬNULL(Таблица.Ссылка, ЗНАЧЕНИЕ(%1.ПустаяСсылка)) КАК Ссылка,
		|	ЕСТЬNULL(ДанныеПользователя.Код, """") = """" КАК ПометкаУдаления
		|ПОМЕСТИТЬ ПодготовленныеДанные
		|ИЗ
		|	ДанныеПользователя КАК ДанныеПользователя
		|		ПОЛНОЕ СОЕДИНЕНИЕ %1 КАК Таблица
		|		ПО ДанныеПользователя.Код = Таблица.Код
		|		И Таблица.РедакцияКлассификатора = &РедакцияКлассификатора
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПодготовленныеДанные.Код КАК Код,
		|	ПодготовленныеДанные.Наименование КАК Наименование,
		|	ПодготовленныеДанные.Наименование КАК ПолноеНаименование,
		|	ПодготовленныеДанные.Ссылка КАК Ссылка,
		|	ПодготовленныеДанные.ПометкаУдаления КАК ПометкаУдаления
		|//ТЕМЫ	, Тематики.Ссылка КАК Тематика
		|ИЗ
		|	ПодготовленныеДанные КАК ПодготовленныеДанные
		|//ТЕМЫ		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Тематики КАК Тематики
		|//ТЕМЫ		ПО ПодготовленныеДанные.КодВладельца = Тематики.Код
		|//ТЕМЫ		И Тематики.РедакцияКлассификатора = &РедакцияКлассификатора",
		ТипЭлемента);
		
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, 
		"//ТЕМЫ", 
		?(ТипЭлемента = "Справочник.Темы", "", "//ТЕМЫ"));
	
	Возврат ТекстЗапроса;

КонецФункции

Функция ПодготовитьДанныеКлассификатораКОтображению(ДанныеКлассификатора)
	
	РедакцияКлассификатора = ДелопроизводствоСерверПовтИсп.РедакцияКлассификатора();
	
	ШаблонВыборкиИзВнешнегоИсточника = 
		"ВЫБРАТЬ Таблица.Код КАК Код, %2 Таблица.Наименование КАК Наименование ПОМЕСТИТЬ вт%1 ИЗ &%1 КАК Таблица;";
	
	ШаблонВыборкиСУчетомДанныхИБ = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	вт%1.Код КАК Код,
		|	вт%1.Наименование КАК Наименование,
		|	НЕ ЕСТЬNULL(%1.Ссылка, ЗНАЧЕНИЕ(Справочник.%2.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.%2.ПустаяСсылка) КАК Выбран
		|ИЗ 
		|	вт%1 КАК вт%1
		|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.%2 КАК %1
		|		ПО вт%1.Код = %1.Код
		|			И (НЕ %1.ПометкаУдаления)
		|			И (%1.РедакцияКлассификатора = &РедакцияКлассификатора)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Код;";
	
	Запрос = Новый Запрос;
	
	Для Каждого ЭлементКлассификатора Из ДанныеКлассификатора Цикл
		Запрос.Текст = Запрос.Текст 
			+ ?(ПустаяСтрока(Запрос.Текст), "", Символы.ПС) 
			+ СтрШаблон(ШаблонВыборкиИзВнешнегоИсточника,
						ЭлементКлассификатора.Ключ,
						?(ЭлементКлассификатора.Ключ = "Темы", "Таблица.КодВладельца КАК КодВладельца,", ""));
				
		Запрос.УстановитьПараметр(ЭлементКлассификатора.Ключ, ЭлементКлассификатора.Значение.Данные);
	КонецЦикла;
	
	Запрос.Текст = Запрос.Текст + Символы.ПС + СтрШаблон(ШаблонВыборкиСУчетомДанныхИБ, "Разделы", "РазделыОбращений");
	Запрос.Текст = Запрос.Текст + Символы.ПС + СтрШаблон(ШаблонВыборкиСУчетомДанныхИБ, "Вопросы", "ВопросыОбращений");	
	Запрос.Текст = Запрос.Текст + Символы.ПС +
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	втТематики.Код КАК КодТематики,
		|	втТематики.Наименование КАК НаименованиеТематики,
		|	втТемы.Код КАК КодТемы,
		|	втТемы.Наименование КАК НаименованиеТемы,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(Тематики.Ссылка, ЗНАЧЕНИЕ(Справочник.ТематикиОбращений.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.ТематикиОбращений.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ НЕ ЕСТЬNULL(Темы.Ссылка, ЗНАЧЕНИЕ(Справочник.ТемыОбращений.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.ТемыОбращений.ПустаяСсылка)
		|	КОНЕЦ КАК Выбран,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(Тематики.Ссылка, ЗНАЧЕНИЕ(Справочник.ТематикиОбращений.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.ТематикиОбращений.ПустаяСсылка)
		|			ТОГДА 0
		|		ИНАЧЕ ВЫБОР
		|				КОГДА ЕСТЬNULL(Темы.Ссылка, ЗНАЧЕНИЕ(Справочник.ТемыОбращений.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.ТемыОбращений.ПустаяСсылка)
		|					ТОГДА 0
		|				ИНАЧЕ 1
		|			КОНЕЦ
		|	КОНЕЦ КАК ВыбранЧислом
		|ИЗ
		|	втТематики КАК втТематики
		|		ЛЕВОЕ СОЕДИНЕНИЕ втТемы КАК втТемы
		|		ПО втТематики.Код = втТемы.КодВладельца
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТематикиОбращений КАК Тематики
		|		ПО втТематики.Код = Тематики.Код
		|			И (НЕ Тематики.ПометкаУдаления)
		|			И (Тематики.РедакцияКлассификатора = &РедакцияКлассификатора)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТемыОбращений КАК Темы
		|		ПО (втТемы.Код = Темы.Код)
		|			И (НЕ Темы.ПометкаУдаления)
		|			И (Темы.РедакцияКлассификатора = &РедакцияКлассификатора)
		|
		|УПОРЯДОЧИТЬ ПО
		|	КодТематики,
		|	КодТемы
		|ИТОГИ
		|	МАКСИМУМ(НаименованиеТематики),
		|	КОЛИЧЕСТВО(КодТемы),
		|	МИНИМУМ(Выбран),
		|	СУММА(ВыбранЧислом)
		|ПО
		|	КодТематики";
	
	Запрос.Параметры.Вставить("РедакцияКлассификатора", РедакцияКлассификатора);
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Новый Структура("Разделы, Вопросы, ТематикиИТемы",
		РезультатЗапроса[РезультатЗапроса.ВГраница() - 2],
		РезультатЗапроса[РезультатЗапроса.ВГраница() - 1],
		РезультатЗапроса[РезультатЗапроса.ВГраница()]);
		
КонецФункции

// Формирует описание элемента классификатора
// Параметры:
//	ПозицияКода - Число - Позиция кода элемента в коде классификатора
//	ПозицияКодаВладельца - Число - Позиция кода элемента-владельца в коде классификатора (необязательный)
//
// Возвращает:
//	Структуру, содержащую поля:
//		ПозицияКода - Число - Позиция кода элемента в коде классификатора
//		ПозицияКодаВладельца - Число - Позиция кода элемента владельца в коде классификатора (необязательный)
//		Данные - ТаблицаЗначений - Таблица, в которую будут помещены полученные значения элемента классификатора
Функция ПодготовитьОписаниеЭлементаКлассификатора(ПозицияКода, ПозицияКодаВладельца = 0)
	
	Возврат Новый Структура("ПозицияКода, ПозицияКодаВладельца, Данные", 
		ПозицияКода, ПозицияКодаВладельца, ПодготовитьТаблицуДляВыводаДанных());
	
КонецФункции

// Формирует таблицу, в которую будут помещены полученные элементы классификатора
// Параметры:
//	Отсутствуют
//
// Возвращает:
//	Таблицу значений с полями:
//		Код - Строка - Код элемента классификатора
//		КодВладельца - Строка - Код элемента-владельца классификатора
//		Наименование - Строка - Наименование элемента классификатора
Функция ПодготовитьТаблицуДляВыводаДанных()
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Код", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(4)));
	Таблица.Колонки.Добавить("КодВладельца", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(4)));
	Таблица.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(500)));
	
	Возврат Таблица
	
КонецФункции

Функция ПодготовитьДанныеКлассификатораУправленияПрезидентаКОтображению(ДанныеКлассификатора)
	
	РедакцияКлассификатора = ДелопроизводствоСерверПовтИсп.РедакцияКлассификатора();
	
	ШаблонВыборкиИзВнешнегоИсточника = 
		"ВЫБРАТЬ Таблица.Код КАК Код, Таблица.КодВладельца КАК КодВладельца, Таблица.Наименование КАК Наименование ПОМЕСТИТЬ вт%1 ИЗ &%1 КАК Таблица;";
	
	ШаблонВыборкиСУчетомДанныхИБ = 
		"ВЫБРАТЬ 
		|	вт%1.Код КАК Код,
		|	вт%1.Наименование КАК Наименование,
		|	НЕ ЕСТЬNULL(%1.Ссылка, ЗНАЧЕНИЕ(Справочник.%2.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.%2.ПустаяСсылка) КАК Выбран
		|ИЗ 
		|	вт%1 КАК вт%1
		|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.%2 КАК %1
		|		ПО вт%1.Код = %1.Код
		|			И (НЕ %1.ПометкаУдаления)
		|			И (%1.РедакцияКлассификатора = &РедакцияКлассификатора)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Код;";
	
	Запрос = Новый Запрос;
	
	Для Каждого ЭлементКлассификатора Из ДанныеКлассификатора Цикл
		Запрос.Текст = Запрос.Текст 
			+ ?(ПустаяСтрока(Запрос.Текст), "", Символы.ПС) 
			+ СтрШаблон(ШаблонВыборкиИзВнешнегоИсточника,
						ЭлементКлассификатора.Ключ);
				
		Запрос.УстановитьПараметр(ЭлементКлассификатора.Ключ, ЭлементКлассификатора.Значение.Данные);
	КонецЦикла;
	
	Запрос.Текст = Запрос.Текст + Символы.ПС + СтрШаблон(ШаблонВыборкиСУчетомДанныхИБ, "Разделы", "РазделыОбращений");

	// Тематики
	Запрос.Текст = Запрос.Текст + Символы.ПС +
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	втТематики.Код КАК КодТематики,
		|	втТематики.Наименование КАК НаименованиеТематики,
		|	втРазделы.Код КАК КодРаздела,
		|	втРазделы.Наименование КАК НаименованиеРаздела,
		|	Тематики.Ссылка КАК Ссылка,
		|	Тематики.Раздел КАК ВладелецВСсылке,
		|	Разделы.Ссылка КАК ВладелецСсылка
		|ИЗ
		|	втТематики КАК втТематики
		|		ЛЕВОЕ СОЕДИНЕНИЕ втРазделы КАК втРазделы
		|		ПО втТематики.КодВладельца = втРазделы.Код
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТематикиОбращений КАК Тематики
		|		ПО втТематики.Код = Тематики.Код
		|			И (НЕ Тематики.ПометкаУдаления)
		|			И (Тематики.РедакцияКлассификатора = &РедакцияКлассификатора)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РазделыОбращений КАК Разделы
		|		ПО (втРазделы.Код = Разделы.Код)
		|			И (НЕ Разделы.ПометкаУдаления)
		|			И (Разделы.РедакцияКлассификатора = &РедакцияКлассификатора)
		|ГДЕ
		|	Тематики.Ссылка <> ЗНАЧЕНИЕ(Справочник.ТематикиОбращений.ПустаяСсылка)
		|	И НЕ Тематики.ПометкаУдаления
		|	И Разделы.Ссылка <> ЗНАЧЕНИЕ(Справочник.РазделыОбращений.ПустаяСсылка)
		|	И НЕ Разделы.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	КодРаздела,
		|	КодТематики;";
	
	// Вопросы
	Запрос.Текст = Запрос.Текст + Символы.ПС +
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	втВопросы.Код КАК КодВопроса,
		|	втВопросы.Наименование КАК НаименованиеВопроса,
		|	втТемы.Код КАК КодТемы,
		|	втТемы.Наименование КАК НаименованиеТемы,
		|	Вопросы.Ссылка КАК Ссылка,
		|	Вопросы.Тема КАК ВладелецВСсылке,
		|	Темы.Ссылка КАК ВладелецСсылка
		|ИЗ
		|	втВопросы КАК втВопросы
		|		ЛЕВОЕ СОЕДИНЕНИЕ втТемы КАК втТемы
		|		ПО втВопросы.КодВладельца = втТемы.Код
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВопросыОбращений КАК Вопросы
		|		ПО втВопросы.Код = Вопросы.Код
		|			И (НЕ Вопросы.ПометкаУдаления)
		|			И (Вопросы.РедакцияКлассификатора = &РедакцияКлассификатора)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТемыОбращений КАК Темы
		|		ПО (втТемы.Код = Темы.Код)
		|			И (НЕ Темы.ПометкаУдаления)
		|			И (Темы.РедакцияКлассификатора = &РедакцияКлассификатора)
		|ГДЕ
		|	Вопросы.Ссылка <> ЗНАЧЕНИЕ(Справочник.ВопросыОбращений.ПустаяСсылка)
		|	И НЕ Вопросы.ПометкаУдаления
		|	И Темы.Ссылка <> ЗНАЧЕНИЕ(Справочник.ТемыОбращений.ПустаяСсылка)
		|	И НЕ Темы.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	КодТемы,
		|	КодВопроса;";

	Запрос.Текст = Запрос.Текст + Символы.ПС +
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	втТематики.Код КАК КодТематики,
		|	втТематики.Наименование КАК НаименованиеТематики,
		|	втТемы.Код КАК КодТемы,
		|	втТемы.Наименование КАК НаименованиеТемы,
		|	Темы.Ссылка КАК Ссылка,
		|	Тематики.Ссылка КАК ВладелецСсылка,
		|	Темы.Тематика КАК ВладелецВСсылке
		|ИЗ
		|	втТематики КАК втТематики
		|		ЛЕВОЕ СОЕДИНЕНИЕ втТемы КАК втТемы
		|		ПО втТематики.Код = втТемы.КодВладельца
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТематикиОбращений КАК Тематики
		|		ПО втТематики.Код = Тематики.Код
		|			И (НЕ Тематики.ПометкаУдаления)
		|			И (Тематики.РедакцияКлассификатора = &РедакцияКлассификатора)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТемыОбращений КАК Темы
		|		ПО (втТемы.Код = Темы.Код)
		|			И (НЕ Темы.ПометкаУдаления)
		|			И (Темы.РедакцияКлассификатора = &РедакцияКлассификатора)
		|ГДЕ
		|	Тематики.Ссылка <> ЗНАЧЕНИЕ(Справочник.ТематикиОбращений.ПустаяСсылка)
		|	И НЕ Тематики.ПометкаУдаления
		|	И Темы.Ссылка <> ЗНАЧЕНИЕ(Справочник.ТемыОбращений.ПустаяСсылка)
		|	И НЕ Темы.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	КодТематики,
		|	КодТемы";
	
	Запрос.Параметры.Вставить("РедакцияКлассификатора", РедакцияКлассификатора);
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Новый Структура("Разделы, Тематики, Вопросы, ТематикиИТемы",
		РезультатЗапроса[РезультатЗапроса.ВГраница() - 3],
		РезультатЗапроса[РезультатЗапроса.ВГраница() - 2],
		РезультатЗапроса[РезультатЗапроса.ВГраница() - 1],
		РезультатЗапроса[РезультатЗапроса.ВГраница()]);
		
КонецФункции

#КонецОбласти

#КонецЕсли
