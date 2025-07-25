﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ДействияКОбновлениюПрав;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Поиск действий для обновления прав.
	Если ДополнительныеСвойства.Свойство("ПропуститьОпределениеЗависимыхПрав")
		И ДополнительныеСвойства.ПропуститьОпределениеЗависимыхПрав = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДокументооборотПраваДоступаПовтИсп.ВключеноИспользованиеПравДоступа() Тогда
		Возврат;
	КонецЕсли;
	
	ДействияКОбновлениюПрав = Новый Массив;
	
	НаборДоИзменения = РегистрыСведений.ВсеИсполнителиДействийЗадач.СоздатьНаборЗаписей();
	ЕстьОтбор = Ложь;
	Для Каждого ЭлементОтбора Из Отбор Цикл
		Если ЭлементОтбора.Использование Тогда
			НаборДоИзменения.Отбор[ЭлементОтбора.Имя].Установить(ЭлементОтбора.Значение);
			ЕстьОтбор = Истина;
		КонецЕсли;
	КонецЦикла;
	Если Не ЕстьОтбор Тогда
		Возврат; // Обработка записи набора без отбора не предусмотрена.
	КонецЕсли;
	
	НаборДоИзменения.Прочитать();
	ТаблицаНабораДоИзменения = НаборДоИзменения.Выгрузить();
	ТаблицаНабораДоИзменения.Индексы.Добавить("ДействиеЗадачи, Исполнитель, Основание");
	
	СтруктураОтбора = Новый Структура("ДействиеЗадачи, Исполнитель, Основание");
	Для Каждого Стр Из ЭтотОбъект Цикл
		ЗаполнитьЗначенияСвойств(СтруктураОтбора, Стр);
		НайденныеСтроки = ТаблицаНабораДоИзменения.НайтиСтроки(СтруктураОтбора);
		Если НайденныеСтроки.Количество() > 0 Тогда
			ТаблицаНабораДоИзменения.Удалить(НайденныеСтроки[0]);
		Иначе
			ДействияКОбновлениюПрав.Добавить(Стр.ДействиеЗадачи);
		КонецЕсли;
	КонецЦикла;
	Для Каждого Стр Из ТаблицаНабораДоИзменения Цикл // Остались только ненайденные в этом наборе строки.
		ДействияКОбновлениюПрав.Добавить(Стр.ДействиеЗадачи);
	КонецЦикла;
	ДействияКОбновлениюПрав = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ДействияКОбновлениюПрав);
	// Во время удаления помеченных объектов действия может уже не быть.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДействиеЗадачи.Ссылка
		|ИЗ
		|	Документ.ДействиеЗадачи КАК ДействиеЗадачи
		|ГДЕ
		|	ДействиеЗадачи.Ссылка В (&ДействияКОбновлениюПрав)");
	Запрос.УстановитьПараметр("ДействияКОбновлениюПрав", ДействияКОбновлениюПрав);
	ДействияКОбновлениюПрав = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ПропуститьОпределениеЗависимыхПрав")
		И ДополнительныеСвойства.ПропуститьОпределениеЗависимыхПрав = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДокументооборотПраваДоступаПовтИсп.ВключеноИспользованиеПравДоступа() Тогда
		Возврат;
	КонецЕсли;
	
	// Определение дескрипторов для действий.
	Для Каждого Действие Из ДействияКОбновлениюПрав Цикл
		ДокументооборотПраваДоступа.ОпределитьДескрипторыОбъекта(Действие);
	КонецЦикла;
	
	// Определение дескрипторов для задач.
	ЗадачиДействий = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ДействияКОбновлениюПрав, "Задача");
	ОбработанныеЗадачи = Новый Соответствие;
	Для Каждого КлючИЗначение Из ЗадачиДействий Цикл
		Задача = КлючИЗначение.Значение;
		Если Не ЗначениеЗаполнено(Задача) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ОбработанныеЗадачи[Задача] = Неопределено Тогда
			ДокументооборотПраваДоступа.ОпределитьДескрипторыОбъекта(Задача);
			ОбработанныеЗадачи[Задача] = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
