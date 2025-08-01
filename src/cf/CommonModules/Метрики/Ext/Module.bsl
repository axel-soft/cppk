﻿
// Выполняет замеры метрик и записывает результаты в РС
// 
Процедура ВыполнитьЗамеры() Экспорт
	
	Отказ = Ложь;
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ИзмерениеМетрик, Отказ);
	
	Если Отказ = Истина Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Метрики.Ссылка КАК Метрика,
		|	Метрики.Выражение КАК Выражение
		|ИЗ
		|	Справочник.Метрики КАК Метрики
		|ГДЕ
		|	Метрики.Ссылка В
		|			(ВЫБРАТЬ
		|				Метрики.Ссылка КАК Ссылка
		|			ИЗ
		|				Справочник.Метрики КАК Метрики
		|					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамерыМетрик КАК ЗамерыМетрик
		|					ПО
		|						ЗамерыМетрик.Показатель = Метрики.Ссылка
		|			ГДЕ
		|				НЕ Метрики.Недействителен
		|			СГРУППИРОВАТЬ ПО
		|				Метрики.Ссылка,
		|				Метрики.ПериодЗамеров
		|			ИМЕЮЩИЕ
		|				МАКСИМУМ(ЗамерыМетрик.Дата) ЕСТЬ NULL
		|					ИЛИ РАЗНОСТЬДАТ(МАКСИМУМ(ЗамерыМетрик.Дата), &ДатаЗамера, МИНУТА) >= Метрики.ПериодЗамеров)");
	
	ДатаЗамера = ТекущаяДатаСеанса();
	Запрос.УстановитьПараметр("ДатаЗамера", ДатаЗамера);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗначениеМетрики = ПолучитьРезультатЗамера(Выборка.Метрика, Выборка.Выражение);
		Если ЗначениеМетрики <> Неопределено Тогда
			Запись = РегистрыСведений.ЗамерыМетрик.СоздатьМенеджерЗаписи();
			Запись.Дата = ДатаЗамера;
			Запись.Показатель = Выборка.Метрика;
			Запись.Результат = ЗначениеМетрики;
			Запись.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьРезультатЗамера(Метрика, Выражение) Экспорт
	
	Результат = Неопределено;
	
	Если ЗначениеЗаполнено(Выражение) Тогда
		Попытка
			Выполнить(Выражение);
		Исключение
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Измерение метрик'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,, Метрика,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает значения показателей за период
// 
// Параметры:
//  ДатаНачала - Дата - дата начала периода
//  ДатаОкончания - Дата - дата окончания периода
//  ВыбранныеПоказатели - Массив - показатели, значения которых нужно получить
//  КоличествоТочек - Число - количество точек, выводимых в отчете
//  ТаблицаПоказателей - ТаблицаЗначений - таблица, в которую будут выведены значения максимумов, минимумов и т.д.
// 
// Возвращаемое значение - Таблица значений  - значения показателей в точках, умноженные на коэффициент
//  
Функция ПолучитьДанныеДляВыводаОтчета(
			ДатаНачала, ДатаОкончания,
			ВыбранныеПоказатели, 
			Знач КоличествоТочек = 0,
			АвтоМасштаб = Истина) Экспорт
	
	ЗначенияПоказателейПоПериодам = Новый ТаблицаЗначений;
	ЗначенияПоказателейПоПериодам.Колонки.Добавить("ОтображаемаяДата");
	ЗначенияПоказателейПоПериодам.Колонки.Добавить("НачалоПериода");
	ЗначенияПоказателейПоПериодам.Колонки.Добавить("КонецПериода");
	ЗначенияПоказателейПоПериодам.Колонки.Добавить("Показатель");
	ЗначенияПоказателейПоПериодам.Колонки.Добавить("Результат");
	ЗначенияПоказателейПоПериодам.Колонки.Добавить("Коэффициент");
	
	// Подготовка отрезков периода
	
	Если КоличествоТочек = 0 Тогда
		КоличествоТочек = 101;
	КонецЕсли;
	
	ДлинаОтрезка = Окр((ДатаОкончания - ДатаНачала) / (КоличествоТочек - 1));
	ПоловинаДлиныОтрезка = Окр(ДлинаОтрезка / 2);
	
	ОтрезкиПериода = Новый ТаблицаЗначений;
	ОтрезкиПериода.Колонки.Добавить("ОтображаемаяДата", Новый ОписаниеТипов("Дата"));
	ОтрезкиПериода.Колонки.Добавить("НачалоПериода", Новый ОписаниеТипов("Дата"));
	ОтрезкиПериода.Колонки.Добавить("КонецПериода", Новый ОписаниеТипов("Дата"));
	
	Для Сч = 0 По КоличествоТочек - 1 Цикл
		
		Отрезок = ОтрезкиПериода.Добавить();
		Отрезок.ОтображаемаяДата = ДатаНачала + ДлинаОтрезка * Сч;
		Отрезок.НачалоПериода = Отрезок.ОтображаемаяДата - ПоловинаДлиныОтрезка;
		Отрезок.КонецПериода  = Отрезок.ОтображаемаяДата + ПоловинаДлиныОтрезка;
		
		Если Отрезок.ОтображаемаяДата > ДатаОкончания Тогда
			Отрезок.ОтображаемаяДата = ДатаОкончания;
		КонецЕсли;
		
	КонецЦикла;
	
	// Вычисление средних значений на отрезках
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗамерыМетрик.Показатель КАК Показатель,
		|	МАКСИМУМ(ЗамерыМетрик.Дата) КАК Дата
		|ПОМЕСТИТЬ ДатыПервыхЗамеров
		|ИЗ
		|	РегистрСведений.ЗамерыМетрик КАК ЗамерыМетрик
		|ГДЕ
		|	ЗамерыМетрик.Показатель В(&ВыбранныеПоказатели)
		|	И ЗамерыМетрик.Дата < &ДатаНачала
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗамерыМетрик.Показатель
		|
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗамерыМетрик.Показатель,
		|	ЗамерыМетрик.Результат
		|ПОМЕСТИТЬ НачальныеЗначения
		|ИЗ
		|	ДатыПервыхЗамеров КАК ДатыПервыхЗамеров
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗамерыМетрик КАК ЗамерыМетрик
		|		ПО ДатыПервыхЗамеров.Показатель = ЗамерыМетрик.Показатель
		|			И ДатыПервыхЗамеров.Дата = ЗамерыМетрик.Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтрезкиПериода.ОтображаемаяДата,
		|	ОтрезкиПериода.НачалоПериода,
		|	ОтрезкиПериода.КонецПериода
		|ПОМЕСТИТЬ ОтрезкиПериода
		|ИЗ
		|	&ОтрезкиПериода КАК ОтрезкиПериода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтрезкиПериода.ОтображаемаяДата,
		|	ОтрезкиПериода.НачалоПериода КАК НачалоПериода,
		|	ОтрезкиПериода.КонецПериода КАК КонецПериода,
		|	Метрики.Ссылка КАК Показатель,
		|	Метрики.МинимальныйМасштаб
		|ПОМЕСТИТЬ ОтрезкиПериодаСПоказателями
		|ИЗ
		|	ОтрезкиПериода КАК ОтрезкиПериода,
		|	Справочник.Метрики КАК Метрики
		|ГДЕ
		|	Метрики.Ссылка В(&ВыбранныеПоказатели)
		|
		|СГРУППИРОВАТЬ ПО
		|	Метрики.Ссылка,
		|	ОтрезкиПериода.НачалоПериода,
		|	ОтрезкиПериода.КонецПериода,
		|	ОтрезкиПериода.ОтображаемаяДата
		|
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтрезкиПериодаСПоказателями.ОтображаемаяДата КАК ОтображаемаяДата,
		|	ОтрезкиПериодаСПоказателями.НачалоПериода,
		|	ОтрезкиПериодаСПоказателями.КонецПериода,
		|	ОтрезкиПериодаСПоказателями.Показатель КАК Показатель,
		|	СРЕДНЕЕ(ЕСТЬNULL(ЗамерыМетрик.Результат, ВЫБОР
		|				КОГДА ОтрезкиПериодаСПоказателями.ОтображаемаяДата = &ДатаНачала
		|					ТОГДА ЕСТЬNULL(НачальныеЗначения.Результат, 0)
		|				ИНАЧЕ 0
		|			КОНЕЦ)) КАК Результат,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА ЗамерыМетрик.Результат ЕСТЬ NULL 
		|					И ОтрезкиПериодаСПоказателями.ОтображаемаяДата <> &ДатаНачала
		|				ТОГДА ЛОЖЬ
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ) КАК ЕстьЗамеры,
		|	ОтрезкиПериодаСПоказателями.МинимальныйМасштаб
		|ПОМЕСТИТЬ ЗначенияПоказателей
		|ИЗ
		|	ОтрезкиПериодаСПоказателями КАК ОтрезкиПериодаСПоказателями
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамерыМетрик КАК ЗамерыМетрик
		|		ПО ОтрезкиПериодаСПоказателями.Показатель = ЗамерыМетрик.Показатель
		|			И ОтрезкиПериодаСПоказателями.НачалоПериода < ЗамерыМетрик.Дата
		|			И ОтрезкиПериодаСПоказателями.КонецПериода >= ЗамерыМетрик.Дата
		|		ЛЕВОЕ СОЕДИНЕНИЕ НачальныеЗначения КАК НачальныеЗначения
		|		ПО ОтрезкиПериодаСПоказателями.Показатель = НачальныеЗначения.Показатель
		|
		|СГРУППИРОВАТЬ ПО
		|	ОтрезкиПериодаСПоказателями.Показатель,
		|	ОтрезкиПериодаСПоказателями.НачалоПериода,
		|	ОтрезкиПериодаСПоказателями.ОтображаемаяДата,
		|	ОтрезкиПериодаСПоказателями.КонецПериода,
		|	ОтрезкиПериодаСПоказателями.МинимальныйМасштаб
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗначенияПоказателей.ОтображаемаяДата КАК ОтображаемаяДата,
		|	ЗначенияПоказателей.НачалоПериода,
		|	ЗначенияПоказателей.КонецПериода,
		|	ЗначенияПоказателей.Показатель КАК Показатель,
		|	ЗначенияПоказателей.Результат,
		|	ЗначенияПоказателей.ЕстьЗамеры,
		|	ВЫБОР
		|		КОГДА ЗначенияПоказателей.Результат >= 0
		|			ТОГДА ЗначенияПоказателей.Результат
		|		ИНАЧЕ -ЗначенияПоказателей.Результат
		|	КОНЕЦ КАК МаксРезультатПоМодулю,
		|	ЗначенияПоказателей.МинимальныйМасштаб КАК МинимальныйМасштаб
		|ИЗ
		|	ЗначенияПоказателей КАК ЗначенияПоказателей
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОтображаемаяДата
		|ИТОГИ
		|	МАКСИМУМ(МаксРезультатПоМодулю),
		|	МАКСИМУМ(МинимальныйМасштаб)
		|ПО
		|	Показатель");
	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ВыбранныеПоказатели", ВыбранныеПоказатели);
	Запрос.УстановитьПараметр("ОтрезкиПериода", ОтрезкиПериода);
	
	// Заполнение таблицы значений показателей
	
	ВыборкаПоПоказателям = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоПоказателям.Следующий() Цикл
		
		Коэф = 1;
		
		Если АвтоМасштаб И ВыборкаПоПоказателям.МаксРезультатПоМодулю <> 0 Тогда
			
			// Коэффициенты подбираются так, чтобы максимальное по модулю значение всегда было между 10 и 100
			// для наглядного отображения нескольких показателей на диаграмме
			БазовыйЛогарифм = 1;
			Логарифм = Log10(ВыборкаПоПоказателям.МаксРезультатПоМодулю);
			ЛогарифмОкругленный = ?(Логарифм < 0, Цел(Логарифм - 1), Цел(Логарифм));
			Коэф = Pow(10, ЛогарифмОкругленный - БазовыйЛогарифм);
			
			Если ВыборкаПоПоказателям.МинимальныйМасштаб <> 0 Тогда
				Коэф = Макс(Коэф, ВыборкаПоПоказателям.МинимальныйМасштаб);
			КонецЕсли;
			
		КонецЕсли;
		
		ПредыдущийРезультат = 0;
		Выборка = ВыборкаПоПоказателям.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НСтр = ЗначенияПоказателейПоПериодам.Добавить();
			ЗаполнитьЗначенияСвойств(НСтр, Выборка);
			НСтр.Коэффициент = Коэф;
			
			Если Выборка.ЕстьЗамеры Тогда
				НСтр.Результат = Выборка.Результат / Коэф;
			Иначе
				НСтр.Результат = ПредыдущийРезультат;
			КонецЕсли;
			
			ПредыдущийРезультат = НСтр.Результат;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ЗначенияПоказателейПоПериодам;
	
КонецФункции
