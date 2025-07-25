﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПриСозданииНаСервереРедакцииКонфигурации();
	
	ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.Списком;
	Элементы.Список.ПодчиненныеЭлементы.Папка.Видимость = Истина;
	Элементы.СписокСоздать.Доступность = Истина;
	
	Документ = Параметры.Документ;
	Контрагент = Параметры.Контрагент;
	Организация = Параметры.Организация;
	Проект = Параметры.Проект;
	КомментарийТипаСвязи = "";
	ВидДокумента = Неопределено;
	Если Параметры.ОбязательныеСвязи.Количество() = 1 Тогда
		
		Строка = Параметры.ОбязательныеСвязи[0];
		
		ТипСвязи = Строка.ТипСвязи;
		СсылкаНа = Строка.СсылкаНа;
		ВидДокумента = СсылкаНа;
		КомментарийТипаСвязи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТипСвязи, "Комментарий");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КомментарийТипаСвязи) Тогда
		Элементы.ДекорацияОписание.Заголовок = СтрШаблон(
			НСтр("ru = 'Чтобы завершить создание документа, необходимо указать связь ""%1 (%2)"". 
			|Выберите документ для создания связи.'"),
			ТипСвязи,
			КомментарийТипаСвязи);
	Иначе
		Элементы.ДекорацияОписание.Заголовок = СтрШаблон(
				НСтр("ru = 'Чтобы завершить создание документа, необходимо указать связь ""%1"". 
				|Выберите документ для создания связи.'"),
				ТипСвязи);
	КонецЕсли;
	
	// Виды документов
	Если ЗначениеЗаполнено(ВидДокумента) Тогда
		Если ТипЗнч(ВидДокумента) = Тип("СправочникСсылка.ВидыДокументов") И ВидДокумента.ЭтоГруппа Тогда
			Список.Параметры.УстановитьЗначениеПараметра("ГруппаВидаДокумента", ВидДокумента);
		Иначе
			Список.Параметры.УстановитьЗначениеПараметра("ВидДокумента", ВидДокумента);
		КонецЕсли;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ОтборПоКонтрагенту", Истина);
		Список.Параметры.УстановитьЗначениеПараметра("КонтрагентОтбор", Контрагент);			
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"Организация",
				Организация);
		КонецЕсли;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Проект) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Проект",
			Проект);
	КонецЕсли;
	
	Если Параметры.Свойство("ПоказыватьКомандуСоздать") Тогда
		Элементы.СписокСоздать.Видимость = (Параметры.ПоказыватьКомандуСоздать = Истина);
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	//кешируем наличие доступных шаблонов документов
	ЕстьДоступныеШаблоныДокументов = Делопроизводство.ЕстьДоступныеШаблоныДокументов();
	Делопроизводство.СписокДокументовУсловноеОформлениеПомеченныхНаУдаление(Список);
	ПоказатьУдаленные();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Обработчик ожидания для периодического обновления количества доступных шаблонов документов через каждые 20 минут.
	ПодключитьОбработчикОжидания("ОбновитьКоличествоДоступныхШаблонов", 1200, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
	ПоказатьУдаленные();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ДокументИзмененДляСписков" Тогда
		Если ТипЗнч(Источник) = Тип("ФормаКлиентскогоПриложения") 
		   И Источник.ВладелецФормы = Элементы.Список 
		   И Элементы.Список.ТекущаяСтрока <> Параметр Тогда 
		   
		   КлючЗаписиДляУстановки = Параметр; 
		   Элементы.Список.ТекущаяСтрока = КлючЗаписиДляУстановки;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.Списком") Тогда
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ТекущиеДанные = РаботаСоСпискамиДокументовКлиент.ПолучитьДанныеТекущейСтрокиСписка(Элементы.Список,
		Элементы.Список.ТекущаяСтрока);

	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбрана строка.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыВозврата = Новый Структура("ТипСвязи, СсылкаНа, СвязанныйОбъект, Комментарий", 
		ТипСвязи, СсылкаНа, ТекущиеДанные.Ссылка, "");
		
	МассивВозврата = Новый Массив;
	МассивВозврата.Добавить(ПараметрыВозврата);
	
	Закрыть(МассивВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;     
	
	ТекущиеДанные = РаботаСоСпискамиДокументовКлиент.ПолучитьДанныеТекущейСтрокиСписка(Элементы.Список,
		Элементы.Список.ТекущаяСтрока);

	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбрана строка.'"));
		Возврат;
	КонецЕсли;
		
	ПараметрыВозврата = Новый Структура("ТипСвязи, СсылкаНа, СвязанныйОбъект, Комментарий", 
		ТипСвязи, СсылкаНа, ТекущиеДанные.Ссылка, "");
		
	МассивВозврата = Новый Массив;
	МассивВозврата.Добавить(ПараметрыВозврата);
	
	Закрыть(МассивВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	СоздатьНовыйДокумент(Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйДокумент(Копирование)
	
	ТекущийДокумент = Элементы.Список.ТекущаяСтрока;
	ПараметрыФормы = Новый Структура;
	Если Копирование Тогда 
		ПараметрыФормы.Вставить("ЗначениеКопирования", ТекущийДокумент);
		Открытьформу("Справочник.ДокументыПредприятия.ФормаОбъекта", ПараметрыФормы, Элементы.Список);
		Возврат;
	КонецЕсли;
	
	
	Если ЕстьДоступныеШаблоныДокументов Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"СоздатьНовыйДокументПродолжение",
			ЭтотОбъект,
			ПараметрыФормы);
		РаботаСШаблонамиДокументовКлиент.ПоказатьФормуСозданияДокументаПоШаблону(
			ОписаниеОповещения,
			"ШаблоныДокументов");
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(ДелопроизводствоКлиентСервер.Текст_НетШаблоновИлиДоступаКНим());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйДокументПродолжение(Результат, ПараметрыФормы) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяПапка = Неопределено;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Папка", ТекущаяПапка);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ПараметрыФормы.Вставить("ШаблонДокумента", Результат);
	Иначе
		ПараметрыФормы.Вставить("ШаблонДокумента", Результат.ШаблонДокумента);
	КонецЕсли;
	
	Открытьформу("Справочник.ДокументыПредприятия.ФормаОбъекта", 
		ПараметрыФормы, Элементы.Список, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКоличествоДоступныхШаблонов()
	
	ЕстьДоступныеШаблоныДокументов = Делопроизводство.ЕстьДоступныеШаблоныДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(Организация) Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"Организация");
	Иначе	
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Организация",
			Организация);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(Контрагент) Тогда	
		Список.Параметры.УстановитьЗначениеПараметра("ОтборПоКонтрагенту", Ложь);
		Список.Параметры.УстановитьЗначениеПараметра("КонтрагентОтбор", Неопределено);
	Иначе			
		Список.Параметры.УстановитьЗначениеПараметра("ОтборПоКонтрагенту", Истина);
		Список.Параметры.УстановитьЗначениеПараметра("КонтрагентОтбор", Контрагент);			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПроектПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Проект) Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"Проект");
	Иначе	
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Проект",
			Проект);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьУдаленные()
	
	Если ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	Иначе	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь);
	КонецЕсли;	
	
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
КонецПроцедуры          

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	
	ПоказатьУдаленные();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервереРедакцииКонфигурации()	
	
	Элементы.ОтборОрганизация.ПодсказкаВвода = РедакцииКонфигурацииКлиентСервер.Организация();
		
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ) 
	
	РаботаСоСпискамиДокументовКлиент.СписокПередНачаломИзменения(
		Элементы.Список, Элементы.Список.ТекущаяСтрока, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;

КонецПроцедуры

#КонецОбласти