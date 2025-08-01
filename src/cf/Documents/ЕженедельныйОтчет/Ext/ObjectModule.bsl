﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДлительностьВсегоМин = 0;
	ДлительностьРабочегоВремениМин = 0;
	Если Работы.Количество() <> 0 Тогда
		Длительность = Новый Соответствие;
		ДлительностьРабочегоВремени = Новый Соответствие;
		СоответствиеДнейНедели = СоответствиеДнейНедели();
		ВидыРабот = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Работы.ВыгрузитьКолонку("ВидРабот"));
		ВидыВремени = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(ВидыРабот, "ВидВремени");
		Для Каждого Строка Из Работы Цикл
			Для Каждого КлючИЗначение Из СоответствиеДнейНедели() Цикл
				ДлительностьВДне = Час(Строка[КлючИЗначение.Значение]) * 60 + Минута(Строка[КлючИЗначение.Значение]);
				ДлительностьВсегоМин = ДлительностьВсегоМин + ДлительностьВДне;
				ВидВремени = ВидыВремени[Строка.ВидРабот].ВидВремени;
				Если ВидВремени = ПредопределенноеЗначение("Перечисление.ВидыВремени.Рабочее") Тогда
					ДлительностьРабочегоВремениМин = ДлительностьРабочегоВремениМин + ДлительностьВДне;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	Иначе
		Для Каждого Строка Из ДниНедели Цикл
			РазделеннаяДлительность = СтрРазделить(Строка.ДлительностьРабот, ":");
			Если РазделеннаяДлительность.Количество() = 2 Тогда
				ДлительностьВсегоМин = ДлительностьВсегоМин 
					+ Число(РазделеннаяДлительность[0]) * 60
					+ Число(РазделеннаяДлительность[1]);
			КонецЕсли;
			РазделеннаяДлительность = СтрРазделить(Строка.ДлительностьРабочая, ":");
			Если РазделеннаяДлительность.Количество() = 2 Тогда
				ДлительностьРабочегоВремениМин = ДлительностьРабочегоВремениМин 
					+ Число(РазделеннаяДлительность[0]) * 60
					+ Число(РазделеннаяДлительность[1]);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	ДлительностьРабот = УчетВремениКлиентСервер.ПолучитьВВидеДатыИзМин(ДлительностьВсегоМин);
	ДлительностьРабочая = УчетВремениКлиентСервер.ПолучитьВВидеДатыИзМин(ДлительностьРабочегоВремениМин);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Движения.РабочееВремяСотрудников.Записывать = Истина;
	Движения.РабочееВремяСотрудников.Очистить();
	
	Если ПометкаУдаления Тогда 
		Возврат;
	КонецЕсли;
	
	// Очистим "регистратор" существующих записей.
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФактическиеТрудозатраты.Сотрудник,
	|	ФактическиеТрудозатраты.Источник,
	|	ФактическиеТрудозатраты.Проект,
	|	ФактическиеТрудозатраты.ПроектнаяЗадача,
	|	ФактическиеТрудозатраты.ВидРабот,
	|	ФактическиеТрудозатраты.ДатаДобавления,
	|	ФактическиеТрудозатраты.НомерДобавления,
	|	ФактическиеТрудозатраты.Начало,
	|	ФактическиеТрудозатраты.Окончание
	|ИЗ
	|	РегистрСведений.ФактическиеТрудозатраты КАК ФактическиеТрудозатраты
	|ГДЕ
	|	ФактическиеТрудозатраты.ЕжедневныйОтчет = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи = РегистрыСведений.ФактическиеТрудозатраты.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Прочитать();
		
		МенеджерЗаписи.ЕжедневныйОтчет = Неопределено;
		МенеджерЗаписи.Записать();
	КонецЦикла;
	
	Политика = Константы.ПолитикаУчетаРабочегоВремени.Получить();
	Если Политика <> Перечисления.ПолитикиУчетаРабочегоВремени.ИспользоватьЕженедельныеОтчеты Тогда
		Возврат;
	КонецЕсли;
	
	// Очистим записи за период.
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФактическиеТрудозатраты.Сотрудник КАК Сотрудник,
	|	ФактическиеТрудозатраты.Источник КАК Источник,
	|	ФактическиеТрудозатраты.Проект КАК Проект,
	|	ФактическиеТрудозатраты.ПроектнаяЗадача КАК ПроектнаяЗадача,
	|	ФактическиеТрудозатраты.ВидРабот КАК ВидРабот,
	|	ФактическиеТрудозатраты.ДатаДобавления КАК ДатаДобавления,
	|	ФактическиеТрудозатраты.НомерДобавления КАК НомерДобавления,
	|	ФактическиеТрудозатраты.Начало КАК Начало,
	|	ФактическиеТрудозатраты.Окончание КАК Окончание
	|ИЗ
	|	РегистрСведений.ФактическиеТрудозатраты КАК ФактическиеТрудозатраты
	|ГДЕ
	|	(ФактическиеТрудозатраты.ДатаДобавления МЕЖДУ &ДатаНачала И &ДатаОкончания
	|				И ФактическиеТрудозатраты.Сотрудник = &Сотрудник
	|			ИЛИ ФактическиеТрудозатраты.Источник = &Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДатаНачала", УчетВремениКлиентСервер.ДатаНачалаОтчетаЗаНеделю(Дата));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(Дата));
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи = РегистрыСведений.ФактическиеТрудозатраты.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Удалить();
	КонецЦикла;
	
	// Выполняем движения по данным еженедельного отчета.
	Запрос = Новый Запрос;
	ШаблонДня = 
		"ВЫБРАТЬ
		|	Работы.Проект КАК Проект,
		|	Работы.ПроектнаяЗадача КАК ПроектнаяЗадача,
		|	Работы.ВидРабот КАК ВидРабот,
		|	Работы.ВидРабот.ВидВремени КАК ВидВремени,
		|	Работы.Работа КАК Работа,
		|	Работы.Источник КАК Источник,
		|	Работы.ДатаДобавления КАК ДатаДобавления,
		|	ДОБАВИТЬКДАТЕ(&ДатаНачала, ДЕНЬ, %1) КАК Дата,
		|	СУММА(ЧАС(Работы.%2) * 3600 + МИНУТА(Работы.%2) * 60) КАК Длительность,
		|	СУММА(ВЫБОР КОГДА Работы.ВидРабот.ВидВремени = ЗНАЧЕНИЕ(Перечисление.ВидыВремени.Рабочее)
		|		ТОГДА ЧАС(Работы.%2) * 3600 + МИНУТА(Работы.%2) * 60
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК ДлительностьРабочая
		|ИЗ
		|	Документ.ЕженедельныйОтчет.Работы КАК Работы
		|ГДЕ
		|	Работы.Ссылка = &Ссылка
		|	И ЧАС(Работы.%2) * 3600 + МИНУТА(Работы.%2) * 60 <> 0
		|СГРУППИРОВАТЬ ПО
		|	Работы.Проект,
		|	Работы.ПроектнаяЗадача,
		|	Работы.ВидРабот,
		|	Работы.ВидРабот.ВидВремени,
		|	Работы.Работа,
		|	Работы.Источник,
		|	Работы.ДатаДобавления,
		|	ДОБАВИТЬКДАТЕ(&ДатаНачала, ДЕНЬ, %1)
		|";
	Запрос.Текст = Запрос.Текст +
		СтрШаблон(ШаблонДня, "0", "Сб") + "
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	Запрос.Текст = Запрос.Текст +
		СтрШаблон(ШаблонДня, "1", "Вс") + "
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	Запрос.Текст = Запрос.Текст +
		СтрШаблон(ШаблонДня, "2", "Пн") + "
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	Запрос.Текст = Запрос.Текст +
		СтрШаблон(ШаблонДня, "3", "Вт") + "
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	Запрос.Текст = Запрос.Текст +
		СтрШаблон(ШаблонДня, "4", "Ср") + "
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	Запрос.Текст = Запрос.Текст +
		СтрШаблон(ШаблонДня, "5", "Чт") + "
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	Запрос.Текст = Запрос.Текст +
		СтрШаблон(ШаблонДня, "6", "Пт") + "
		|УПОРЯДОЧИТЬ ПО ДатаДобавления
		|ИТОГИ СУММА(Длительность), СУММА(ДлительностьРабочая) ПО Дата
		|";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДатаНачала", УчетВремениКлиентСервер.НачалоПонедельника(Дата) - 3600 * 24 * 2);
	СписокДниНедели = Новый Структура("Сб, Вс, Пн, Вт, Ср, Чт, Пт");
	
	ГрафикРаботы = ГрафикиРаботы.ГрафикРаботыСотрудника(Сотрудник);
	
	ВыборкаДни = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаДни.Следующий() Цикл
		
		ЭтоРабочийДень = ГрафикиРаботы.ЭтоРабочийДень(ВыборкаДни.Дата, ГрафикРаботы);
		ДлительностьРабочегоДня = ГрафикиРаботы.ПолучитьДлительностьРабочегоДня(ВыборкаДни.Дата, ГрафикРаботы);
		ДлительностьСверхурочно = ?(ДлительностьРабочегоДня >= ВыборкаДни.ДлительностьРабочая,
			0,
			ВыборкаДни.ДлительностьРабочая - ДлительностьРабочегоДня);
		ВыборкаДетальные = ВыборкаДни.Выбрать();
		НомерДобавления = 1;
		
		Пока ВыборкаДетальные.Следующий() Цикл
			
			Движение = Движения.РабочееВремяСотрудников.Добавить();
			ЗаполнитьЗначенияСвойств(Движение, ВыборкаДетальные);
			Движение.Регистратор = Ссылка;
			Движение.Сотрудник = Сотрудник;
			Движение.Период = ВыборкаДетальные.Дата;
			Движение.ДлительностьВсего = ВыборкаДетальные.Длительность;
			Движение.ДлительностьРабочая = ВыборкаДетальные.ДлительностьРабочая;
			Если ЭтоРабочийДень Тогда
				Если ВыборкаДетальные.ДлительностьРабочая >= ДлительностьСверхурочно Тогда
					Движение.ДлительностьСверхурочно = ДлительностьСверхурочно;
					ДлительностьСверхурочно = 0;
				Иначе
					Движение.ДлительностьСверхурочно = ВыборкаДетальные.ДлительностьРабочая;
					ДлительностьСверхурочно = ДлительностьСверхурочно - ВыборкаДетальные.ДлительностьРабочая;
				КонецЕсли;
			Иначе
				Движение.ДлительностьВВыходные = ВыборкаДетальные.ДлительностьРабочая;
			КонецЕсли;
			
			МенеджерЗаписи = РегистрыСведений.ФактическиеТрудозатраты.СоздатьМенеджерЗаписи();
			
			МенеджерЗаписи.Сотрудник = Сотрудник;
			
			МенеджерЗаписи.ОписаниеРаботы = ВыборкаДетальные.Работа;
			МенеджерЗаписи.ВидРабот = ВыборкаДетальные.ВидРабот;
			МенеджерЗаписи.Источник = ВыборкаДетальные.Источник;
			
			МенеджерЗаписи.Проект = ВыборкаДетальные.Проект;
			МенеджерЗаписи.ПроектнаяЗадача = ВыборкаДетальные.ПроектнаяЗадача;
				
			МенеджерЗаписи.Длительность = Движение.ДлительностьВсего;
			МенеджерЗаписи.ДлительностьСверхурочно = Движение.ДлительностьСверхурочно;
			МенеджерЗаписи.ДлительностьВВыходные = Движение.ДлительностьВВыходные;
			
			МенеджерЗаписи.ДатаДобавления = ?(ЗначениеЗаполнено(ВыборкаДетальные.ДатаДобавления),
				ВыборкаДетальные.ДатаДобавления,
				ВыборкаДетальные.Дата);
			МенеджерЗаписи.НомерДобавления = НомерДобавления;
			НомерДобавления = НомерДобавления + 1;
			
			МенеджерЗаписи.ЕжедневныйОтчет = Ссылка;
			МенеджерЗаписи.Удалена = Ложь;
			
			МенеджерЗаписи.Записать();
			
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НастройкиУчетаВремени = УчетВремени.ПолучитьПерсональныеНастройкиУчетаВремениСервер();
	ВестиУчетПоПроектам = ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам");
	
	Для Каждого Строка Из Работы Цикл
		
		ИндексСтроки = Работы.Индекс(Строка);
		ВидВремени = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Строка.ВидРабот, "ВидВремени");
		
		Если ЗначениеЗаполнено(Строка.ВидРабот) 
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Строка.ВидРабот, "ПометкаУдаления") Тогда 
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В строке %1 указан вид деятельности, помеченный на удаление.'"),
				Строка.НомерСтроки);
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"Работы[" + ИндексСтроки + "].ВидРабот",, 
				Отказ);	
		КонецЕсли;
		
		Если ВестиУчетПоПроектам Тогда 
			Если ЗначениеЗаполнено(Строка.Проект) 
				И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Строка.Проект, "ПометкаУдаления") Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В строке %1 указан проект, помеченный на удаление.'"),
					Строка.НомерСтроки);
					
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"Работы[" + ИндексСтроки + "].ПроектЗадача",, 
					Отказ);	
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Сотрудник = Сотрудники.ОсновнойСотрудникПользователя(
		ПользователиКлиентСервер.ТекущийПользователь());
	Автор = Сотрудник;
	Дата = КонецДня(ТекущаяДатаСеанса());
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Дата") Тогда 
			Дата = КонецДня(ДанныеЗаполнения.Дата);
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Сотрудник") Тогда 
			Сотрудник = ДанныеЗаполнения.Сотрудник;
		КонецЕсли;
	КонецЕсли;
	
	ДатаНачала = УчетВремениКлиентСервер.ДатаНачалаОтчетаЗаНеделю(Дата);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = КонецДня(ТекущаяДатаСеанса());
	ДатаНачала = УчетВремениКлиентСервер.ДатаНачалаОтчетаЗаНеделю(Дата);
	Автор = Сотрудники.ОсновнойСотрудникПользователя(
		ПользователиКлиентСервер.ТекущийПользователь());
	Сотрудник = Сотрудники.ОсновнойСотрудникПользователя(Сотрудник);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоответствиеДнейНедели()

	Соответствие = Новый Соответствие;
	Соответствие[ПредопределенноеЗначение("Перечисление.ДниНедели.Суббота")] = "Сб";
	Соответствие[ПредопределенноеЗначение("Перечисление.ДниНедели.Воскресенье")] = "Вс";
	Соответствие[ПредопределенноеЗначение("Перечисление.ДниНедели.Понедельник")] = "Пн";
	Соответствие[ПредопределенноеЗначение("Перечисление.ДниНедели.Вторник")] = "Вт";
	Соответствие[ПредопределенноеЗначение("Перечисление.ДниНедели.Среда")] = "Ср";
	Соответствие[ПредопределенноеЗначение("Перечисление.ДниНедели.Четверг")] = "Чт";
	Соответствие[ПредопределенноеЗначение("Перечисление.ДниНедели.Пятница")] = "Пт";
	Возврат Соответствие;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли