﻿#Область ПрограммныйИнтерфейс

// Возвращает данные выбора получателя заявки по введенному тексту.
//
Функция ДанныеВыбораПолучателя(Текст) Экспорт
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 20
		|	Контрагенты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Наименование ПОДОБНО &Текст
		|	И НЕ Контрагенты.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	Сотрудники.Ссылка
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Наименование ПОДОБНО &Текст
		|	И НЕ Сотрудники.ПометкаУдаления
		|	И Сотрудники.Действует
		|АВТОУПОРЯДОЧИВАНИЕ");
	
	Запрос.УстановитьПараметр("Текст", "%" + Текст + "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции

// Возвращает виды документов по связи "Авансовый отчет".
//
Функция ВидыДокументовПоСвязиАвансовыйОтчет(ВидДокументаЗаявкаНаОплату) Экспорт
	
	ВидыДокументов = Новый Массив;
	Документ = Новый Структура("ВидДокумента", ВидДокументаЗаявкаНаОплату);
	Настройки = СвязиОбъектов.ПолучитьНастройкиСвязи(Документ);
	Для Каждого Настройка Из Настройки Цикл
		Если Настройка.ТипСвязи = Справочники.ТипыСвязей.АвансовыйОтчет 
			И Настройка.ТипСсылкаНа = "СправочникСсылка.ДокументыПредприятия" Тогда
			ВидыДокументов.Добавить(Настройка.СсылкаНа);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВидыДокументов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти