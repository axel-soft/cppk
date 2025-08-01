﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат 
		"Ссылка,
		|Папка,
		|ГрифДоступа,
		|Организация,
		|Подразделение,
		|Руководитель";
	
КонецФункции

// Проверяет наличие метода.
// 
Функция ЕстьМетодЗаполнитьДескрипторыОбъекта() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет переданную таблицу дескрипторов объекта.
// 
Процедура ЗаполнитьДескрипторыОбъекта(ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав = Неопределено) Экспорт
	
	ДокументооборотПраваДоступа.ЗаполнитьДескрипторыОбъектаСтандартно(
		ОбъектДоступа, ТаблицаДескрипторов);
	
	ДокументооборотПраваДоступа.ДобавитьИндивидуальныйДескриптор(
		ОбъектДоступа, ТаблицаДескрипторов, ОбъектДоступа.Руководитель, Истина);
	
	Если ПротоколРасчетаПрав <> Неопределено Тогда
		ЗаписьПротокола = Новый Структура("Элемент, Описание",
			ОбъектДоступа.Руководитель,
			НСтр("ru = 'Руководитель'"));
		ПротоколРасчетаПрав.Добавить(ЗаписьПротокола);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ГрифДоступа = ОбъектДоступа.ГрифДоступа;
	ДескрипторДоступа.Организация = ОбъектДоступа.Организация;
	ДескрипторДоступа.Подразделение = ОбъектДоступа.Подразделение;
	
	// Папка
	ДокументооборотПраваДоступа.ЗаполнитьПапкуДескриптораОбъекта(ОбъектДоступа, ДескрипторДоступа);
	
КонецПроцедуры

// Проверяет наличие метода.
// 
Функция ЕстьМетодПолучитьПравилаОбработкиНастроекПравПапки() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает таблицу значений с правилами обработки настроек прав папки,
// которые следует применять для расчета прав объекта
// 
Функция ПолучитьПравилаОбработкиНастроекПравПапки() Экспорт
	
	ТаблицаПравил = ДокументооборотПраваДоступа.ТаблицаПравилОбработкиНастроекПапки();
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ЧтениеПапокИПроектов";
	Стр.Чтение = Истина;
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ДобавлениеПапокИПроектов";
	Стр.Добавление = Истина;
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ИзменениеПапокИПроектов";
	Стр.Изменение = Истина;
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ПометкаУдаленияПапокИПроектов";
	Стр.Удаление = Истина;
	
	Возврат ТаблицаПравил;
	
КонецФункции

// Конец УправлениеДоступом

// Проверяет, подходит ли объект к шаблону бизнес-процесса
Функция ШаблонПодходитДляАвтозапускаБизнесПроцессаПоОбъекту(ШаблонСсылка, ПредметСсылка, Подписчик, ВидСобытия, Условие) Экспорт
	
	Возврат БизнесСобытияВызовСервера.ШаблонПодходитДляАвтозапускаБизнесПроцессаПоПредмету(ШаблонСсылка, 
		ПредметСсылка, Подписчик, ВидСобытия, Условие);
	
КонецФункции

// Возвращает признак наличия метода ДобавитьУчастниковВТаблицу у менеджера объекта
//
Функция ЕстьМетодДобавитьУчастниковВТаблицу() Экспорт
	Возврат Истина;
КонецФункции

// Добавляет участников документа в переданную таблицу
//
Процедура ДобавитьУчастниковВТаблицу(ТаблицаНабора, Проект) Экспорт
	
	Для Каждого ЧленКоманды Из Проект.ПроектнаяКоманда Цикл
		Если ТипЗнч(ЧленКоманды.Исполнитель) = Тип("СправочникСсылка.Пользователи")
			ИЛИ ТипЗнч(ЧленКоманды.Исполнитель) = Тип("СправочникСсылка.ПолныеРоли")
			Или ТипЗнч(ЧленКоманды.Исполнитель) = Тип("СправочникСсылка.Сотрудники") Тогда
			
			РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора,
				ЧленКоманды.Исполнитель);
			
		КонецЕсли;
	КонецЦикла;
	
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора,
		Проект.Руководитель, Истина);
	
КонецПроцедуры

// Возвращает имя предмета процесса по умолчанию
//
Функция ПолучитьИмяПредметаПоУмолчанию(Ссылка) Экспорт
	
	Возврат НСтр("ru='Проект'");
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Карточка
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Справочник.Проекты";
	КомандаПечати.Идентификатор = "Карточка";
	КомандаПечати.Представление = НСтр("ru = 'Карточка проекта'");
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
    Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Карточка") Тогда

        // Формируем табличный документ и добавляем его в коллекцию печатных форм
        УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
            "Карточка", "Проект", ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати),
			,
			"Справочник.Проекты.ПФ_MXL_Карточка");
			
	КонецЕсли;
		
КонецПроцедуры

Функция ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ИспользоватьДополнительныеРеквизитыИСведения = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения");
	
	// Создаем табличный документ и устанавливаем имя параметров печати
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_КарточкаСообщения";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.Проекты.ПФ_MXL_Карточка");
	ОбластьПроектШапка = Макет.ПолучитьОбласть("ПроектШапка");
	
	ПервыйДокумент = Истина;
	
	Для Каждого ОбъектПечати Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		// Запомним номер строки с которой начали выводить текущий документ
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;		
		
		// Заполнение шапки проекта
		ОбластьПроектШапка.Параметры.Наименование = ОбъектПечати.Наименование + " (" + ТипЗнч(ОбъектПечати) + ")";
		ОбластьПроектШапка.Параметры.Описание = ОбъектПечати.Описание;
		ОбластьПроектШапка.Параметры.РуководительПроекта = ОбъектПечати.Руководитель;
		ОбластьПроектШапка.Параметры.Заказчик = ОбъектПечати.Заказчик;
		ОбластьПроектШапка.Параметры.Начало = ОбъектПечати.ТекущийПланНачало;
		ОбластьПроектШапка.Параметры.Окончание = ОбъектПечати.ТекущийПланОкончание;
		ОбластьПроектШапка.Параметры.Трудозатраты = Строка(ОбъектПечати.ТекущийПланТрудозатраты);
		ОбластьПроектШапка.Параметры.Гриф = ОбъектПечати.ГрифДоступа;
		ОбластьПроектШапка.Параметры.Состояние = ОбъектПечати.Состояние;
		ОбластьПроектШапка.Параметры.Вид = ОбъектПечати.ВидПроекта;
		ОбластьПроектШапка.Параметры.Организация = ОбъектПечати.Организация;
		ОбластьПроектШапка.Параметры.СинонимОрганизация = РедакцииКонфигурацииКлиентСервер.Организация();
		
		ТабличныйДокумент.Вывести(ОбластьПроектШапка);
		
		// Проектная команда
		Если ОбъектПечати.ПроектнаяКоманда.Количество() > 0 Тогда
			ОбластьКомандаШапка = Макет.ПолучитьОбласть("ПроектнаяКомандаШапка");
			ТабличныйДокумент.Вывести(ОбластьКомандаШапка);
			Для Каждого УчастникПроекта Из ОбъектПечати.ПроектнаяКоманда Цикл
				ОбластьКомандаСтрока = Макет.ПолучитьОбласть("ПроектнаяКомандаУчастник");
				ОбластьКомандаСтрока.Параметры.Участник = УчастникПроекта.Исполнитель;
				ОбластьКомандаСтрока.Параметры.РольУчастника = УчастникПроекта.РольВПроекте;
				ТабличныйДокумент.Вывести(ОбластьКомандаСтрока);
			КонецЦикла;
		КонецЕсли;
		
		// Контроль исполнения
		ЗапросПроектныеЗадачи = Новый Запрос;
		ЗапросПроектныеЗадачи.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ПроектныеЗадачи.Ссылка,
			|	ПроектныеЗадачи.Наименование,
			|	ПроектныеЗадачи.КодСДР КАК КодСДР,
			|	СрокиПроектныхЗадач.ТекущийПланНачало,
			|	СрокиПроектныхЗадач.ТекущийПланОкончание,
			|	ВЫБОР
			|		КОГДА СрокиПроектныхЗадач.ОкончаниеФакт <> ДАТАВРЕМЯ(1, 1, 1)
			|			ТОГДА &Завершены
			|		КОГДА СрокиПроектныхЗадач.НачалоФакт <> ДАТАВРЕМЯ(1, 1, 1)
			|				И СрокиПроектныхЗадач.ТекущийПланОкончание >= &ТекущаяДата
			|			ТОГДА &ВыполняютсяБезПросрочки
			|		КОГДА СрокиПроектныхЗадач.НачалоФакт <> ДАТАВРЕМЯ(1, 1, 1)
			|				И СрокиПроектныхЗадач.ТекущийПланОкончание < &ТекущаяДата
			|			ТОГДА &ВыполняютсяСПросрочкой
			|		КОГДА СрокиПроектныхЗадач.НачалоФакт = ДАТАВРЕМЯ(1, 1, 1)
			|				И СрокиПроектныхЗадач.ТекущийПланНачало < &ТекущаяДата
			|			ТОГДА &НеНачатыВовремя
			|		КОГДА СрокиПроектныхЗадач.НачалоФакт = ДАТАВРЕМЯ(1, 1, 1)
			|				И СрокиПроектныхЗадач.ТекущийПланНачало >= &ТекущаяДата
			|			ТОГДА &НеНачаты
			|	КОНЕЦ КАК ТекущееСостояниеПроектнойЗадачи,
			|	ПроектныеЗадачи.НомерЗадачиВУровне КАК НомерЗадачиВУровне
			|ИЗ
			|	Справочник.ПроектныеЗадачи КАК ПроектныеЗадачи
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СрокиПроектныхЗадач КАК СрокиПроектныхЗадач
			|		ПО ПроектныеЗадачи.Ссылка = СрокиПроектныхЗадач.ПроектнаяЗадача
			|ГДЕ
			|	ПроектныеЗадачи.Владелец = &Проект
			|	И НЕ ПроектныеЗадачи.ПометкаУдаления
			|
			|УПОРЯДОЧИТЬ ПО
			|	КодСДР,
			|	НомерЗадачиВУровне";
			
		ДатаФормирования = ТекущаяДатаСеанса();
		ЗапросПроектныеЗадачи.УстановитьПараметр("Проект", ОбъектПечати);
		ЗапросПроектныеЗадачи.УстановитьПараметр("ТекущаяДата", ДатаФормирования);
		ЗапросПроектныеЗадачи.УстановитьПараметр("Завершены", НСтр("ru = 'Завершены'"));
		ЗапросПроектныеЗадачи.УстановитьПараметр("ВыполняютсяБезПросрочки", НСтр("ru = 'Выполняются без просрочки'"));
		ЗапросПроектныеЗадачи.УстановитьПараметр("ВыполняютсяСПросрочкой", НСтр("ru = 'Выполняются c просрочкой'"));
		ЗапросПроектныеЗадачи.УстановитьПараметр("НеНачатыВовремя", НСтр("ru = 'Не начаты вовремя'"));
		ЗапросПроектныеЗадачи.УстановитьПараметр("НеНачаты", НСтр("ru = 'Не начаты'"));
		
		ТаблицаЗадачи = ЗапросПроектныеЗадачи.Выполнить().Выгрузить();
		
		Если ТаблицаЗадачи.Количество() > 0 Тогда
			ОбластьКонтрольВыполненияШапка = Макет.ПолучитьОбласть("КонтрольВыполненияШапка");
			ОбластьКонтрольВыполненияШапка.Параметры.ДатаФормирования = Формат(ДатаФормирования, "ДФ='dd.MM.yyyy HH:mm'");
			ТабличныйДокумент.Вывести(ОбластьКонтрольВыполненияШапка);
			
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Завершены'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Выполняются без просрочки'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Выполняются c просрочкой'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Не начаты вовремя'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Не начаты'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
		КонецЕсли;
		
		// В табличном документе зададим имя области в которую был 
		// выведен объект. Нужно для возможности печати по-комплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ОбъектПечати);
	КонецЦикла;		

	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ВывестиЗадачиВУказанномСостоянии(Состояние, ТабличныйДокумент, Макет, ТаблицаЗадачи)
	
	ПараметрыОтбора = Новый Структура("ТекущееСостояниеПроектнойЗадачи", Состояние);
	НайденныеСтроки = ТаблицаЗадачи.НайтиСтроки(ПараметрыОтбора);
	Если НайденныеСтроки.Количество() > 0 Тогда
		ОбластьСостояниеСтрока = Макет.ПолучитьОбласть("СостояниеСтрока");
		ОбластьСостояниеСтрока.Параметры.Состояние = Состояние;
		ТабличныйДокумент.Вывести(ОбластьСостояниеСтрока);

		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ОбластьЗадача = Макет.ПолучитьОбласть("ЗадачаСтрока");
			ОбластьЗадача.Параметры.КодСДР = НайденнаяСтрока.КодСДР;
			ОбластьЗадача.Параметры.Наименование = НайденнаяСтрока.Наименование;
			ОбластьЗадача.Параметры.НачалоПлан = Формат(НайденнаяСтрока.ТекущийПланНачало, "ДФ='dd.MM.yy HH:mm'");
			ОбластьЗадача.Параметры.ОкончаниеПлан = Формат(НайденнаяСтрока.ТекущийПланОкончание, "ДФ='dd.MM.yy HH:mm'");
			ТабличныйДокумент.Вывести(ОбластьЗадача);
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры

// ВерсионированиеОбъектов
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры
// Конец ВерсионированиеОбъектов

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
КонецПроцедуры

// Возвращает признак того, что проектная команда была изменена.
//
// Параметры:
//	Объект - СправочникОбъект.Проекты - Объект, для которого получить сведения.
//
// Возвращаемое значение:
//	Булево - Признак того, что проектная команда была изменена.
//
Функция ПроектнаяКомандаИзменена(Объект) Экспорт
	
	ПроектнаяКомандаИзменена = Ложь;
	
	НоваяПроектнаяКоманда = Объект.ПроектнаяКоманда.Выгрузить();
	НоваяПроектнаяКоманда.Свернуть("Исполнитель");
	НоваяПроектнаяКоманда = НоваяПроектнаяКоманда.ВыгрузитьКолонку("Исполнитель");
	
	Если Объект.ЭтоНовый() Тогда
		СтараяПроектнаяКоманда = Новый Массив;
	Иначе
		ПредыдущиеЗначенияРеквизитов = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
			Объект.ДополнительныеСвойства, "ПредыдущиеЗначенияРеквизитов");
		
		Если ПредыдущиеЗначенияРеквизитов <> Неопределено Тогда
			СтараяПроектнаяКоманда = ПредыдущиеЗначенияРеквизитов.ПроектнаяКоманда;
		Иначе
			СтараяПроектнаяКоманда =
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ПроектнаяКоманда").Выгрузить();	
		КонецЕсли; 
			
		СтараяПроектнаяКоманда.Свернуть("Исполнитель");
		СтараяПроектнаяКоманда = СтараяПроектнаяКоманда.ВыгрузитьКолонку("Исполнитель");
	КонецЕсли;
		
	Для Каждого УчастникПроекта ИЗ НоваяПроектнаяКоманда Цикл
		ТипУчастника = ТипЗнч(УчастникПроекта);
		Если ТипУчастника <> Тип("СправочникСсылка.Пользователи")
				И ТипУчастника <> Тип("СправочникСсылка.ПолныеРоли")
				И ТипУчастника <> Тип("СправочникСсылка.Сотрудники") Тогда
			
			Продолжить;
		КонецЕсли;
		
		Если СтараяПроектнаяКоманда.Найти(УчастникПроекта) = Неопределено Тогда
			ПроектнаяКомандаИзменена = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого УчастникПроекта ИЗ СтараяПроектнаяКоманда Цикл
		ТипУчастника = ТипЗнч(УчастникПроекта);
		Если ТипУчастника <> Тип("СправочникСсылка.Пользователи")
				И ТипУчастника <> Тип("СправочникСсылка.ПолныеРоли")
				И ТипУчастника <> Тип("СправочникСсылка.Сотрудники") Тогда
			
			Продолжить;
		КонецЕсли;
		
		Если НоваяПроектнаяКоманда.Найти(УчастникПроекта) = Неопределено Тогда
			ПроектнаяКомандаИзменена = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПроектнаяКомандаИзменена;
	
КонецФункции

// Возвращает отслеживаемые реквизиты для дополнительного свойства ПредыдущиеЗначенияРеквизитов.
//
// Возвращаемое значение:
//  Строка - Отслеживаемые реквизиты.
//
Функция ОтслеживаемыеРеквизиты() Экспорт
	
	ОтслеживаемыеРеквизиты =
		"ПометкаУдаления, Руководитель, Папка, ПроектнаяКоманда, Наименование, ТекущийПланНачало,
		|ТекущийПланОкончание, СпособПланирования, АвтоматическиРассчитыватьПланПроекта, Состояние";
	
	Возврат ОтслеживаемыеРеквизиты;
	
КонецФункции

// Определяет активность проекта. 
// Только активные проекты отображаются в реестре "Задачи по проектам".
// 
// Параметры:
//  Состояние - ПеречислениеСсылка.СостоянияПроектов.
//  ПометкаУдаления - Булево.
// 
// Возвращаемое значение:
//  Булево.
// 
Функция ПроектАктивен(Состояние, ПометкаУдаления) Экспорт
	
	ПроектАктивен =
		Состояние = Перечисления.СостоянияПроектов.Исполняется
		И Не ПометкаУдаления;
	
	Возврат ПроектАктивен;
	
КонецФункции

#Область ОбновлениеДанныхКэширующихОбъектов

// Конструктор параметров обновления данных кэширующих объектов.
//
// Возвращаемое значение:
//	Структура:
//		* ОбъектыДляОбновленияСотрудниковВКонтейнерах - Массив Из СправочникСсылка.РабочиеГруппы - Список объектов, по которым необходимо обновить данные РС СотрудникиВКонтейнерах.
//		* ПараметрыОбновленияАдреснойКниги - Структура Из КлючИЗначение - Параметры обновления адресной книги см. ПараметрыОбновленияАдреснойКниги.
//
Функция ПараметрыОбновленияДанныхКэширующихОбъектов() Экспорт
	
	ПараметрыОбновления = Новый Структура;	
	ПараметрыОбновления.Вставить("ОбъектыДляОбновленияСотрудниковВКонтейнерах", Новый Массив);
	ПараметрыОбновления.Вставить("ПараметрыОбновленияАдреснойКниги", ПараметрыОбновленияАдреснойКниги());
	
	Возврат ПараметрыОбновления;
	
КонецФункции

// Устанавливает значения параметров обновления данных кэширующих объектов по данным объекта.
//
// Параметры:
//	Объект - СправочникОбъект.Проекты - Объект, для которго необходимо определить параметры обновления.
//
// Возвращаемое значение:
//	Структура: см. ПараметрыОбновленияДанныхКэширующихОбъектов.
//
Функция ЗначенияПараметровОбновленияДанныхКэширующихОбъектов(Объект) Экспорт
	
	ПараметрыОбновления = ПараметрыОбновленияДанныхКэширующихОбъектов();
	
	ПредыдущиеЗначенияРеквизитов = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		Объект.ДополнительныеСвойства, "ПредыдущиеЗначенияРеквизитов");
	
	СсылкаНаОбъект = Объект.Ссылка;
	
	Если Объект.ЭтоНовый() Тогда
		Если Объект.ПолучитьСсылкуНового().Пустая() Тогда // Установим ссылку нового, если ее нет
			СсылкаНаОбъект = ПолучитьСсылку(Новый УникальныйИдентификатор);
			Объект.УстановитьСсылкуНового(СсылкаНаОбъект);
		Иначе // Если ссылку нового уже установили ранее, возьмем ее
			СсылкаНаОбъект = Объект.ПолучитьСсылкуНового();
		КонецЕсли;
	КонецЕсли;
	
	Если ПредыдущиеЗначенияРеквизитов = Неопределено Тогда
		ПредыдущиеЗначенияРеквизитов =
			ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаНаОбъект, ОтслеживаемыеРеквизиты());	
	КонецЕсли;
	
	Если ПредыдущиеЗначенияРеквизитов.Руководитель <> Объект.Руководитель Тогда
		КонтейнерРуководитель = Справочники.ПроектыКонтейнеры.НайтиПроектКонтейнер(
			СсылкаНаОбъект,
			Перечисления.СпособВключенияУчастниковПроекта.ТолькоРуководитель);
		
		КонтейнерВсеУчастники = Справочники.ПроектыКонтейнеры.НайтиПроектКонтейнер(
			СсылкаНаОбъект,
			Перечисления.СпособВключенияУчастниковПроекта.ВсеУчастники);
			
		ПараметрыОбновления.ОбъектыДляОбновленияСотрудниковВКонтейнерах.Добавить(КонтейнерРуководитель);
		ПараметрыОбновления.ОбъектыДляОбновленияСотрудниковВКонтейнерах.Добавить(КонтейнерВсеУчастники);
	ИначеЕсли ПроектнаяКомандаИзменена(Объект) Тогда
		КонтейнерВсеУчастники = Справочники.ПроектыКонтейнеры.НайтиПроектКонтейнер(
			СсылкаНаОбъект,
			Перечисления.СпособВключенияУчастниковПроекта.ВсеУчастники);
		
		ПараметрыОбновления.ОбъектыДляОбновленияСотрудниковВКонтейнерах.Добавить(КонтейнерВсеУчастники);
	КонецЕсли;
	
	ПараметрыОбновления.ПараметрыОбновленияАдреснойКниги = ЗначенияПараметровОбновленияАдреснойКнигиПоОбъекту(Объект); 
	
	Возврат ПараметрыОбновления;
	
КонецФункции

// Обновляет данные зависимых объектов согласно установленным параметрам.
//
// Параметры:
//	Объект - СправочникОбъект.СтруктураПредприятия - Объект, по данным которого необходимо обновить адресной книги.
//	ПараметрыОбновления - Структура Из КлючИЗначение - см. ПараметрыОбновленияДанныхКэширующихОбъектов.
//
Процедура ОбновитьДанныеКэширующихОбъектов(Объект, ПараметрыОбновления) Экспорт
	
	Если ПараметрыОбновления.ОбъектыДляОбновленияСотрудниковВКонтейнерах.Количество() Тогда
		РегистрыСведений.СотрудникиВКонтейнерах.ОбновитьДанныеКонтейнеров(
			ПараметрыОбновления.ОбъектыДляОбновленияСотрудниковВКонтейнерах);
	КонецЕсли;
		
	ОбновитьАдреснуюКнигу(Объект, ПараметрыОбновления.ПараметрыОбновленияАдреснойКниги);
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеАдреснойКниги

// Конструктор параметров обновления адресной книги.
//
// Возвращаемое значение:
//	Структура:
//		* ОбновитьДанныеОбъекта - Булево - Признак обновления данных по объекту.
//		* ОбновитьСловаПоискаПоОбъекту - Булево - Признак обновления слов поиска по объекту.
//		* ОбновитьДоступностьВПоискеПоОбъекту - Булево - Признак обновления доступности в результатах поиска.
//		* СоставПроектнойКоманды - Массив Из СправочникСсылка.Пользователи,
//											 СправочникСсылка.ПолныеРоли,
//											 СправочникСсылка.Сотрудники - Список участников проектной команды,
//																		   сведения о которых нужно обновить.
//
Функция ПараметрыОбновленияАдреснойКниги() Экспорт

	ПараметрыОбновленияАдреснойКниги = Новый Структура;
	ПараметрыОбновленияАдреснойКниги.Вставить("ОбновитьДанныеОбъекта", Ложь);
	ПараметрыОбновленияАдреснойКниги.Вставить("ОбновитьСловаПоискаПоОбъекту", Ложь);
	ПараметрыОбновленияАдреснойКниги.Вставить("ОбновитьДоступностьВПоискеПоОбъекту", Ложь);
	ПараметрыОбновленияАдреснойКниги.Вставить("СоставПроектнойКоманды", Новый Массив);
	
	Возврат ПараметрыОбновленияАдреснойКниги;
	
КонецФункции

// Устанавливает значения параметров обновления адресной книги по данным объекта.
//
// Параметры:
//	Объект - СправочникОбъект.Проекты - Объект, для которго необходимо определить параметры обновления.
//
// Возвращаемое значение:
//	Структура: см. ПараметрыОбновленияАдреснойКниги.
//
Функция ЗначенияПараметровОбновленияАдреснойКнигиПоОбъекту(Объект) Экспорт
	
	ПараметрыОбновленияАдреснойКниги = ПараметрыОбновленияАдреснойКниги();
		
	Если Не РаботаСАдреснойКнигой.ТребуетсяОбновлениеАдреснойКниги(Объект) Тогда
		Возврат ПараметрыОбновленияАдреснойКниги; 
	КонецЕсли;
	
	ОбновитьСоставПроектнойКомандыВАдреснойКниге = Ложь;
	
	НоваяПроектнаяКоманда = Объект.ПроектнаяКоманда.Выгрузить();
	НоваяПроектнаяКоманда.Свернуть("Исполнитель");
	НоваяПроектнаяКоманда = НоваяПроектнаяКоманда.ВыгрузитьКолонку("Исполнитель");
		
	Если Объект.ЭтоНовый() Тогда
		ПараметрыОбновленияАдреснойКниги.ОбновитьДанныеОбъекта = Истина;
		ПараметрыОбновленияАдреснойКниги.ОбновитьСловаПоискаПоОбъекту = Истина;
		ОбновитьСоставПроектнойКомандыВАдреснойКниге = Истина;
	Иначе
		ПредыдущиеЗначенияРеквизитов = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
			Объект.ДополнительныеСвойства, "ПредыдущиеЗначенияРеквизитов");
		
		Если ПредыдущиеЗначенияРеквизитов = Неопределено Тогда
			ПредыдущиеЗначенияРеквизитов =
				ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Ссылка, ОтслеживаемыеРеквизиты());	
		КонецЕсли; 

		Если ПредыдущиеЗначенияРеквизитов.Папка <> Объект.Папка Тогда
			ПараметрыОбновленияАдреснойКниги.ОбновитьДанныеОбъекта = Истина;
		КонецЕсли;
		
		Если ПредыдущиеЗначенияРеквизитов.ПометкаУдаления <> Объект.ПометкаУдаления Тогда
			ПараметрыОбновленияАдреснойКниги.ОбновитьДоступностьВПоискеПоОбъекту = Истина;
			ПараметрыОбновленияАдреснойКниги.ОбновитьДанныеОбъекта = Истина;
			ОбновитьСоставПроектнойКомандыВАдреснойКниге = Истина;
		КонецЕсли;

		Если ПредыдущиеЗначенияРеквизитов.Наименование <> Объект.Наименование Тогда
			ПараметрыОбновленияАдреснойКниги.ОбновитьСловаПоискаПоОбъекту = Истина;
			ПараметрыОбновленияАдреснойКниги.ОбновитьДанныеОбъекта = Истина;
		КонецЕсли;
		
		ПроектнаяКомандаИзменена = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
			Объект.ДополнительныеСвойства, "ПроектнаяКомандаИзменена");
		Если ПроектнаяКомандаИзменена = Неопределено Тогда
			ПроектнаяКомандаИзменена = ПроектнаяКомандаИзменена(Объект);
		КонецЕсли;
		
		Если ПроектнаяКомандаИзменена Тогда
			ОбновитьСоставПроектнойКомандыВАдреснойКниге = Истина;
			ПараметрыОбновленияАдреснойКниги.ОбновитьСловаПоискаПоОбъекту = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбновитьСоставПроектнойКомандыВАдреснойКниге Тогда
		ИндексУчастникаПроекта = НоваяПроектнаяКоманда.Количество() - 1;
		Пока ИндексУчастникаПроекта >= 0 Цикл
			УчастникПроекта = НоваяПроектнаяКоманда[ИндексУчастникаПроекта];
			ТипУчастника = ТипЗнч(УчастникПроекта);
			Если ТипУчастника <> Тип("СправочникСсылка.Пользователи")
					И ТипУчастника <> Тип("СправочникСсылка.ПолныеРоли")
					И ТипУчастника <> Тип("СправочникСсылка.Сотрудники") Тогда
				
				НоваяПроектнаяКоманда.Удалить(ИндексУчастникаПроекта);
			КонецЕсли;
						
			ИндексУчастникаПроекта = ИндексУчастникаПроекта - 1;
		КонецЦикла;
	КонецЕсли;

	ПараметрыОбновленияАдреснойКниги.СоставПроектнойКоманды = НоваяПроектнаяКоманда;
	
	Возврат ПараметрыОбновленияАдреснойКниги;

КонецФункции

// Обновляет адресную книгу, согласно установленным параметрам.
//
// Параметры:
//	Объект - СправочникОбъект.Проекты - Объект, по данным которого необходимо обновить адресной книги.
//	ПараметрыОбновления - Структура Из КлючИЗначение - см. ПараметрыОбновленияАдреснойКниги.
//
Процедура ОбновитьАдреснуюКнигу(Объект, ПараметрыОбновления) Экспорт
	
	Если ПараметрыОбновления.ОбновитьДанныеОбъекта Тогда
		Справочники.АдреснаяКнига.ОбновитьДанныеОбъекта(
			Объект.Ссылка, Объект.Папка, Справочники.АдреснаяКнига.ПоПроектам, Объект.Ссылка);
	КонецЕсли;
	
	Если ПараметрыОбновления.СоставПроектнойКоманды.Количество() > 0 Тогда
		Справочники.АдреснаяКнига.ОбновитьСписокПодчиненныхОбъектов(
			Объект.Ссылка,
			Неопределено,
			ПараметрыОбновления.СоставПроектнойКоманды,
			Справочники.АдреснаяКнига.ПоПроектам,
			Объект.Ссылка);
	КонецЕсли;
	
	Если ПараметрыОбновления.ОбновитьСловаПоискаПоОбъекту Тогда
		РегистрыСведений.ОбъектыПоискаВАдреснойКниге.ОбновитьСловаПоискаПоПроекту(Объект);
	КонецЕсли;
	
	Если ПараметрыОбновления.ОбновитьДоступностьВПоискеПоОбъекту Тогда
		РегистрыСведений.ОбъектыПоискаВАдреснойКниге.ОбновитьДоступностьВПоиске(Объект);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

#Область ОбновлениеКэширующихДанных

// Обрабатывает обновление кэширующих данных.
// 
// Параметры:
//  Выборка - ВыборкаИзРезультатаЗапроса - Выборка из очереди обновления кэширующих данных:
//   * ОтметкаВремени - ОпределяемыйТип.ОтметкаВремени.
//   * ЗависимыйОбъектМетаданных - СправочникСсылка.ИдентификаторыОбъектовМетаданных.
//   * ВлияющийОбъектМетаданных - СправочникСсылка.ИдентификаторыОбъектовМетаданных.
//   * КлючВлияющихДанных - ЛюбаяСсылка.
//   * Автор - СправочникСсылка.Пользователи.
//   * ЗагрузкаОбработанныхДанныхИзДругойСистемы - Булево.
//   * ИзмененияВлияющихДанных - ХранилищеЗначения.
//   * Попыток - Число.
//   * ДатаКОбработке - Дата.
// 
Процедура ОбновитьКэширующиеДанные(Выборка) Экспорт
	
	Если ТипЗнч(Выборка.КлючВлияющихДанных) = Тип("СправочникСсылка.ЗамещающиеИПомощники") Тогда
		
		ОбновитьКэширующиеДанныеПоЗамещающимИПомощникам(Выборка);
		
	ИначеЕсли ТипЗнч(Выборка.КлючВлияющихДанных) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ОбновитьКэширующиеДанныеПоСотруднику(Выборка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
    МультиязычностьКлиентСервер.ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
    МультиязычностьКлиентСервер.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
    МультиязычностьСервер.ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка, Метаданные.Справочники.Проекты);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обновить кэширующие данные по замещающему или помощнику.
// 
// Параметры:
//  Выборка - ВыборкаИзРезультатаЗапроса.
// 
Процедура ОбновитьКэширующиеДанныеПоЗамещающимИПомощникам(Выборка)
	
	ЗатронутыеСотрудники = Новый Массив;
	
	ИзмененияВлияющихДанных = Выборка.ИзмененияВлияющихДанных.Получить();
	Если ИзмененияВлияющихДанных <> Неопределено Тогда
		
		ПредыдущиеЗначенияРеквизитов = ИзмененияВлияющихДанных.ПредыдущиеЗначенияРеквизитов;
		НовыеЗначенияРеквизитов = ИзмененияВлияющихДанных.НовыеЗначенияРеквизитов;
		
		Если ЗначениеЗаполнено(НовыеЗначенияРеквизитов.Сотрудник) Тогда
			ЗатронутыеСотрудники.Добавить(НовыеЗначенияРеквизитов.Сотрудник);
		КонецЕсли;
		Если ЗначениеЗаполнено(ПредыдущиеЗначенияРеквизитов.Сотрудник)
			И ПредыдущиеЗначенияРеквизитов.Сотрудник <> НовыеЗначенияРеквизитов.Сотрудник Тогда
			ЗатронутыеСотрудники.Добавить(ПредыдущиеЗначенияРеквизитов.Сотрудник);
		КонецЕсли;
		
		ИзменилсяСотрудник =
			ПредыдущиеЗначенияРеквизитов.Сотрудник <> НовыеЗначенияРеквизитов.Сотрудник;
		
		ИзменилсяЗамещающий =
			ПредыдущиеЗначенияРеквизитов.Замещающий <> НовыеЗначенияРеквизитов.Замещающий;
		
		ИзменилосьДействует =
			ПредыдущиеЗначенияРеквизитов.Действует <> НовыеЗначенияРеквизитов.Действует;
		
		БылиВсеОбласти =
			ПредыдущиеЗначенияРеквизитов.ВопросыЗамещения.Найти(
				Справочники.ОбластиЗамещения.ВсеОбласти, "Область") <> Неопределено;
		БылаОбластьПроекты =
			ПредыдущиеЗначенияРеквизитов.ВопросыЗамещения.Найти(
				Справочники.ОбластиЗамещения.Проекты, "Область") <> Неопределено;
		ПредыдущееЗначениеЕстьОбласть = БылиВсеОбласти Или БылаОбластьПроекты;
		
		ЕстьВсеОбласти =
			НовыеЗначенияРеквизитов.ВопросыЗамещения.Найти(
				Справочники.ОбластиЗамещения.ВсеОбласти, "Область") <> Неопределено;
		ЕстьОбластьПроекты =
			НовыеЗначенияРеквизитов.ВопросыЗамещения.Найти(
				Справочники.ОбластиЗамещения.Проекты, "Область") <> Неопределено;
		НовоеЗначениеЕстьОбласть = ЕстьВсеОбласти Или ЕстьОбластьПроекты;
			
		ИзмениласьОбласть =
			ПредыдущееЗначениеЕстьОбласть <> НовоеЗначениеЕстьОбласть;
		
		ЕстьИзменения = 
			ИзменилосьДействует
			Или (НовыеЗначенияРеквизитов.Действует
				И (ИзменилсяСотрудник Или ИзменилсяЗамещающий Или ИзмениласьОбласть));
		
		Если Не ЕстьИзменения Тогда
			Возврат;
		КонецЕсли;
		
	Иначе
		
		ЗамещающийИлиПомощник = Выборка.КлючВлияющихДанных; // СправочникСсылка.ЗамещающиеИПомощники
		
		ЗатронутыйСотрудник =
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗамещающийИлиПомощник, "Сотрудник");
		Если ЗначениеЗаполнено(ЗатронутыйСотрудник) Тогда
			ЗатронутыеСотрудники.Добавить(ЗатронутыйСотрудник);
		КонецЕсли;
		
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Проекты.Ссылка
			|ИЗ
			|	Справочник.Проекты КАК Проекты
			|ГДЕ
			|	Проекты.Руководитель В (&ЗатронутыеСотрудники)";
		
		Запрос.УстановитьПараметр("ЗатронутыеСотрудники", ЗатронутыеСотрудники);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			РегистрыСведений.ОчередьОбновленияКэширующихДанных.Добавить(
				"Документ.Задача",
				"Справочник.Проекты",
				ВыборкаДетальныеЗаписи.Ссылка);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
		
КонецПроцедуры

// Обновить кэширующие данные по сотруднику.
// 
// Параметры:
//  Выборка - ВыборкаИзРезультатаЗапроса.
// 
Процедура ОбновитьКэширующиеДанныеПоСотруднику(Выборка)
	
	Сотрудник = Выборка.КлючВлияющихДанных; // СправочникСсылка.Сотрудники
	
	НачатьТранзакцию();
	Попытка
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Проекты.Ссылка
			|ИЗ
			|	Справочник.Проекты КАК Проекты
			|ГДЕ
			|	Проекты.Руководитель = &Сотрудник";
		
		Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			РегистрыСведений.ОчередьОбновленияКэширующихДанных.Добавить(
				"Документ.Задача",
				"Справочник.Проекты",
				ВыборкаДетальныеЗаписи.Ссылка);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли