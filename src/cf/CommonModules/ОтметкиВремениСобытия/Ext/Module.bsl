﻿
// @strict-types

#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Выполняет регистрацию отметки времени константы.
// 
// Параметры:
//	Источник - ОпределяемыйТип.ОтметкиВремениКонстанты - Константа, отметку времени которой нужно зарегистрировать.
//	Отказ - Булево - Признак отказа от записи.
//
Процедура КонстантыПриЗаписи(Источник, Отказ) Экспорт
	
	Если Отказ
			Или Не ОтметкиВремениИспользуются(Источник)
			Или ПараметрыСеанса.ЭтоУдалениеПомеченных Тогда
		
		Возврат;
	КонецЕсли;
	
	ПодготовитьИсточникПередЗаписьюОтметокВремени(Источник);
	
	ЗафиксироватьОтметкуВремениОбъекта(Источник);
	
КонецПроцедуры

// Выполняет регистрацию отметки времени ссылочного объекта (при записи объекта).
// 
// Параметры:
//	Источник - ОпределяемыйТип.ОтметкиВремениСсылочныеОбъекты - Объект, отметку времени которого нужно зарегистрировать.
//	Отказ - Булево - Признак отказа от записи.
//
Процедура СсылочныеОбъектыПриЗаписи(Источник, Отказ) Экспорт
	
	Если Отказ
			Или Не ОтметкиВремениИспользуются(Источник)
			Или ПараметрыСеанса.ЭтоУдалениеПомеченных Тогда
		
		Возврат;
	КонецЕсли;
	
	ПодготовитьИсточникПередЗаписьюОтметокВремени(Источник);
	
	ЗафиксироватьОтметкуВремениОбъекта(Источник);
	
КонецПроцедуры

// Выполняет регистрацию отметки времени ссылочного объекта (при удалении объекта).
// 
// Параметры:
//	Источник - ОпределяемыйТип.ОтметкиВремениСсылочныеОбъекты - Объект, отметку времени которого нужно зарегистрировать.
//	Отказ - Булево - Признак отказа от удаления.
//
Процедура СсылочныеОбъектыПередУдалением(Источник, Отказ) Экспорт
	
	Если Отказ
			Или Не ОтметкиВремениИспользуются(Источник)
			Или ПараметрыСеанса.ЭтоУдалениеПомеченных Тогда
		
		Возврат;
	КонецЕсли;
	
	ПодготовитьИсточникПередЗаписьюОтметокВремени(Источник);
	
	ЗафиксироватьОтметкуВремениОбъекта(Источник, Истина);
	
КонецПроцедуры

// Выполняет регистрацию отметки времени набора записей.
// 
// Параметры:
//	Источник - ОпределяемыйТип.ОтметкиВремениРегистры - Объект, отметку времени которого нужно зарегистрировать.
//	Отказ - Булево - Признак отказа от записи.
//	Замещение - Булево - Режим записи набора.
//
Процедура РегистрыПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	Если Отказ Или (Не Замещение И Не Источник.Количество())
			Или Не ОтметкиВремениИспользуются(Источник)
			Или ПараметрыСеанса.ЭтоУдалениеПомеченных Тогда
		
		Возврат;
	КонецЕсли;
	
	ПодготовитьИсточникПередЗаписьюОтметокВремени(Источник);
	
	ЗафиксироватьОтметкуВремениРегистра(Источник, Замещение);
	
КонецПроцедуры

// Фиксирует отметку времени для ссылочного объекта или константы.
//
// Параметры:
//	Источник - ОпределяемыйТип.ОтметкиВремениКонстанты -
//			 - ОпределяемыйТип.ОтметкиВремениСсылочныеОбъекты -
//			 - ЛюбаяСсылка - Объект, для которого необходимо зафиксировать отметку времени.
//	ЭтоУдалениеОбъекта - Булево - Признак удаления объекта.
//
Процедура ЗафиксироватьОтметкуВремениОбъекта(Источник, ЭтоУдалениеОбъекта = Ложь) Экспорт
	
	ОписаниеОтметкиВремени = ОписаниеОтметкиВремени(Источник);
	
	Набор = РегистрыСведений["ОтметкиВремениОчередь" + ТекущийНомерОчереди()].СоздатьНаборЗаписей(); // РегистрСведенийНаборЗаписей.ОтметкиВремениОчередь1
	
	Запись = Набор.Добавить(); // РегистрСведенийЗапись.ОтметкиВремениОчередь1
	ЗаполнитьЗначенияСвойств(Запись, ОписаниеОтметкиВремени);
	Запись.Удаление = ЭтоУдалениеОбъекта;
	
	//@skip-check statement-type-change
	Запись.Источник = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		Источник.ДополнительныеСвойства, "ОтметкиВремениИсточник"); 
	//@skip-check statement-type-change
	Запись.Отметка = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		Источник.ДополнительныеСвойства, "ОтметкаВремени", ОтметкиВремени.Текущая());
	
	Набор.Отбор.Отметка.Установить(Запись.Отметка);
	Набор.Отбор.ИдентификаторКлюча.Установить(Запись.ИдентификаторКлюча);
	Набор.Отбор.ТипКлюча.Установить(Запись.ТипКлюча);
	Набор.Отбор.Объект.Установить(Запись.Объект);
	
	ОтметкиВремени.ОтключитьРегистрацию(Набор);
	
	Набор.Записать();
	
КонецПроцедуры

// Фиксирует отметку времени для набора записей регистра.
// 
// Параметры:
//	Источник - ОпределяемыйТип.ОтметкиВремениРегистры - Объект, для которого необходимо зафиксировать отметку времени.
//	Замещение - Булево - Признак замещения набора записей.
//
Процедура ЗафиксироватьОтметкуВремениРегистра(Источник, Замещение) Экспорт
	
	ОписаниеОтметкиВремени = ОписаниеОтметкиВремени(Источник);
	
	ОтборНабораПолный = ОтборНабораПолный(Источник);
	ЭтоУдалениеНабора = Источник.Количество() = 0;
	
	Набор = РегистрыСведений["ОтметкиВремениОчередь" + ТекущийНомерОчереди()].СоздатьНаборЗаписей(); // РегистрСведенийНаборЗаписей.ОтметкиВремениОчередь1
	
	Запись = Набор.Добавить();
	ЗаполнитьЗначенияСвойств(Запись, ОписаниеОтметкиВремени);
	Запись.Удаление = ЭтоУдалениеНабора;
	
	//@skip-check statement-type-change
	Запись.Источник = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		Источник.ДополнительныеСвойства, "ОтметкиВремениИсточник");
	//@skip-check statement-type-change
	Запись.Отметка = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		Источник.ДополнительныеСвойства, "ОтметкаВремени", ОтметкиВремени.Текущая());
	
	Если ОтборНабораПолный И ЭтоУдалениеНабора
			И ОписаниеОтметкиВремени.ВидКлюча = Перечисления.ВидыКлючейОтметокВремени.КлючНабораИдентификаторНабораЗаписей Тогда
		
		Запись.ЗначенияКлюча = Новый ХранилищеЗначения(Источник.Отбор, Новый СжатиеДанных(9));
	КонецЕсли;
	
	Набор.Отбор.Отметка.Установить(Запись.Отметка);
	Набор.Отбор.ИдентификаторКлюча.Установить(Запись.ИдентификаторКлюча);
	Набор.Отбор.ТипКлюча.Установить(Запись.ТипКлюча);
	Набор.Отбор.Объект.Установить(Запись.Объект);
	
	ОтметкиВремени.ОтключитьРегистрацию(Набор);
	
	Набор.Записать();
	
	Если Не ОтборНабораПолный И (Замещение Или ЭтоУдалениеНабора)
			И ОписаниеОтметкиВремени.ВидКлюча = Перечисления.ВидыКлючейОтметокВремени.КлючНабораИдентификаторНабораЗаписей Тогда
		
		КлючиОтборыЗамещаемыхЗаписей = КлючиОтборыЗамещаемыхЗаписей(
			ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ОписаниеОтметкиВремени.Объект), Источник.Отбор);
		
		Для Каждого ЗамещаемаяЗапись Из КлючиОтборыЗамещаемыхЗаписей Цикл
			Запись.ИдентификаторКлюча = ЗамещаемаяЗапись.ИдентификаторКлюча;
			Запись.ТипКлюча = Неопределено;
			Запись.ЗначенияКлюча = ЗамещаемаяЗапись.ЗначенияОтбораКлюча;
			Запись.Удаление = Истина;
			
			Набор.Отбор.ИдентификаторКлюча.Значение = Запись.ИдентификаторКлюча;
			Набор.Записать();
		КонецЦикла;
		
	КонецЕсли;

	Если ЗначениеЗаполнено(ОписаниеОтметкиВремени.КлючиИсточника) Тогда
		Для Каждого Строка Из ОписаниеОтметкиВремени.КлючиИсточника Цикл
			Если Строка.ИдентификаторКлюча <> Запись.ИдентификаторКлюча Или Строка.ТипКлюча <> Запись.ТипКлюча Тогда
				Запись.ИдентификаторКлюча = Строка.ИдентификаторКлюча;
				Запись.ТипКлюча = Строка.ТипКлюча;
				
				Набор.Отбор.ИдентификаторКлюча.Значение = Запись.ИдентификаторКлюча;
				Набор.Отбор.ТипКлюча.Значение = Запись.ТипКлюча;
				Набор.Записать();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Фиксирует отметку времени для ссылки.
//
// Параметры:
//	Ссылка - ЛюбаяСсылка - Ссылка, для которой необходимо зафиксировать отметку времени.
//	ОтметкаВремени - Число - Отметка времени.
//	ЭтоУдаление - Булево - Признак удаления объекта.
//	Источник - ОпределяемыйТип.ИсточникиДляОтметокВремени - Источник отметки времени.
//
Процедура ЗафиксироватьОтметкуВремениСсылки(Ссылка, ОтметкаВремени = Неопределено, ЭтоУдаление = Ложь, Источник = Неопределено) Экспорт
	
	ИдентификаторОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Ссылка));
	
	ОписаниеКлюча = ОтметкиВремени.ОписаниеКлючаОтметкиВремени(Ссылка);
	
	Если ОписаниеКлюча.ВидКлюча = Неопределено Тогда
		ВызватьИсключение СтрШаблон("%1 %2 ""%3""",
			НСтр("ru = 'Не удалось определить вид ключа'", ОбщегоНазначения.КодОсновногоЯзыка()),
			НСтр("ru = 'для'", ОбщегоНазначения.КодОсновногоЯзыка()),
			ИдентификаторОбъекта);
	КонецЕсли;
	
	Набор = РегистрыСведений["ОтметкиВремениОчередь" + ТекущийНомерОчереди()].СоздатьНаборЗаписей(); // РегистрСведенийНаборЗаписей.ОтметкиВремениОчередь1
	
	Запись = Набор.Добавить(); // РегистрСведенийЗапись.ОтметкиВремениОчередь1
	ЗаполнитьЗначенияСвойств(Запись, ОписаниеКлюча);
	Запись.Объект = ИдентификаторОбъекта;
	Запись.Удаление = ЭтоУдаление;
	Запись.Источник = Источник; 
	Запись.Отметка = ?(ОтметкаВремени = Неопределено, ОтметкиВремени.Текущая(), ОтметкаВремени);
	
	Набор.Отбор.Отметка.Установить(Запись.Отметка);
	Набор.Отбор.ИдентификаторКлюча.Установить(Запись.ИдентификаторКлюча);
	Набор.Отбор.ТипКлюча.Установить(Запись.ТипКлюча);
	Набор.Отбор.Объект.Установить(Запись.Объект);
	
	ОтметкиВремени.ОтключитьРегистрацию(Набор);
	
	Набор.Записать();
	
КонецПроцедуры

// При необходимости подготавливает источник перед записью отметки времени
// 
// Параметры:
//	Источник - ОпределяемыйТип.ОтметкиВремениКонстанты -
//			 - ОпределяемыйТип.ОтметкиВремениСсылочныеОбъекты -
//			 - ОпределяемыйТип.ОтметкиВремениРегистры - Объект, который необходимо подготовить к регистрации отметки.
//
Процедура ПодготовитьИсточникПередЗаписьюОтметокВремени(Источник) Экспорт
	
	ИдентификаторОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Источник));
	
	Если ОтметкиВремениПовтИсп.ВидКлючаОбъекта(ИдентификаторОбъекта) =
			Перечисления.ВидыКлючейОтметокВремени.КлючНабораИдентификаторНабораЗаписей Тогда
		
		ОтметкиВремени.ЗаполнитьИдентификаторыНабораЗаписей(Источник);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет возможность регистрации отметки времени для источника.
//
// Параметры:
//	Источник - ОпределяемыйТип.ОтметкиВремениКонстанты -
//			 - ОпределяемыйТип.ОтметкиВремениСсылочныеОбъекты -
//			 - ОпределяемыйТип.ОтметкиВремениРегистры - Объект, для которого необходимо проверить возможность.
//														регистрации отметки времени.
//
// Возвращаемое значение:
//	Булево - Истина - Отметка времени может быть зарегистрирована.
//
Функция ОтметкиВремениИспользуются(Источник)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОтметкиВремени")
			Или Источник.ДополнительныеСвойства.Свойство("ОтключитьОтметкиВремени") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Конструктор параметров отметки времени.
//
// Возвращаемое значение:
//	Структура:
//		* ИдентификаторКлюча - УникальныйИдентификатор - Идентификатор ключа отметки времени.
//		* ТипКлюча - СправочникСсылка.ИдентификаторыОбъектовМетаданных - Тип ключа, если ключ является ссылочным объектом.
//				   - СправочникСсылка.ИдентификаторыОбъектовРасширений -
//				   - Неопределено - Если ключ не является ссылочным объектом.
//		* Объект - СправочникСсылка.ИдентификаторыОбъектовМетаданных -
//				 - СправочникСсылка.ИдентификаторыОбъектовРасширений -
//				 - Неопределено -Тип объекта-источника отметок времени.
//		* ВидКлюча - ПеречислениеСсылка.ВидыКлючейОтметокВремени, Неопределено - Вид ключа отметок времени
//																				 (см. ОтметкиВремени.ВидКлючаОбъекта).
//		* ЗначенияКлюча - ХранилищеЗначения, Неопределено - Значения элементов отбора объекта-источника.
//		* КлючиИсточника - ТаблицаЗначений:
//			** ИдентификаторКлюча - УникальныйИдентификатор - Идентификатор ключа источника отметки времени
//			** ТипКлюча - СправочникСсылка.ИдентификаторыОбъектовМетаданных - Тип ключа, если ключ является ссылочным объектом.
//						- СправочникСсылка.ИдентификаторыОбъектовРасширений -
//
Функция ОписаниеСвойствОтметкиВремени()
	
	КлючиИсточника = Новый ТаблицаЗначений;
	КлючиИсточника.Колонки.Добавить("ИдентификаторКлюча", Новый ОписаниеТипов("УникальныйИдентификатор"));
	КлючиИсточника.Колонки.Добавить("ТипКлюча", Новый ОписаниеТипов(
		"СправочникСсылка.ИдентификаторыОбъектовМетаданных,
		|СправочникСсылка.ИдентификаторыОбъектовРасширений"));
	
	ПараметрыОтметкиВремени = Новый Структура();
	ПараметрыОтметкиВремени.Вставить("ИдентификаторКлюча", ОбщегоНазначенияКлиентСервер.ПустойУникальныйИдентификатор());
	ПараметрыОтметкиВремени.Вставить("ТипКлюча", Неопределено);
	ПараметрыОтметкиВремени.Вставить("Объект", Неопределено);
	ПараметрыОтметкиВремени.Вставить("ВидКлюча", Перечисления.ВидыКлючейОтметокВремени.ПустаяСсылка());
	ПараметрыОтметкиВремени.Вставить("ЗначенияКлюча", Неопределено);
	ПараметрыОтметкиВремени.Вставить("КлючиИсточника", КлючиИсточника);
	
	Возврат ПараметрыОтметкиВремени;
	
КонецФункции

// Возвращает структуру, описывающую параметры отметки времени для переданного объекта.
//
// Параметры:
//	Источник - ОпределяемыйТип.ОтметкиВремениКонстанты -
//			 - ОпределяемыйТип.ОтметкиВремениСсылочныеОбъекты -
//			 - ОпределяемыйТип.ОтметкиВремениРегистры - Объект, для которого необходимо определить параметры отметки времени.
//
// Возвращаемое значение:
//	Структура - см. ОписаниеСвойствОтметкиВремени.
//
Функция ОписаниеОтметкиВремени(Источник)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Источник));
	
	ОписаниеКлюча = ОтметкиВремени.ОписаниеКлючаОтметкиВремени(Источник);
	
	Если ОписаниеКлюча.ВидКлюча = Неопределено Тогда
		ВызватьИсключение СтрШаблон("%1 %2 ""%3""",
			НСтр("ru = 'Не удалось определить вид ключа'", ОбщегоНазначения.КодОсновногоЯзыка()),
			НСтр("ru = 'для'", ОбщегоНазначения.КодОсновногоЯзыка()),
			ИдентификаторОбъекта);
	КонецЕсли;
	
	ОписаниеОтметкиВремени = ОписаниеСвойствОтметкиВремени();
	ОписаниеОтметкиВремени.Объект = ИдентификаторОбъекта;
	ОписаниеОтметкиВремени.ВидКлюча = ОписаниеКлюча.ВидКлюча;
	ОписаниеОтметкиВремени.ИдентификаторКлюча = ОписаниеКлюча.ИдентификаторКлюча;
	ОписаниеОтметкиВремени.ТипКлюча = ОписаниеКлюча.ТипКлюча;
	
	Если ОписаниеКлюча.ВидКлюча = Перечисления.ВидыКлючейОтметокВремени.КлючНабораПервоеСсылочноеИзмерение
			И Источник.Количество() > 1 Тогда
		
		ПолеКлюча = ОтметкиВремениПовтИсп.ПолеКлючаОбъекта(ИдентификаторОбъекта);
		
		ЗначенияПоля = Источник.Выгрузить(, ПолеКлюча);
		ЗначенияПоля.Свернуть(ПолеКлюча);
		
		Для Каждого ЗначениеПоля Из ЗначенияПоля Цикл
			ЗначениеКлючевогоПоля = ЗначениеПоля[ПолеКлюча]; // ЛюбаяСсылка

			КлючИсточника = ОписаниеОтметкиВремени.КлючиИсточника.Добавить();
			КлючИсточника.ИдентификаторКлюча = ЗначениеКлючевогоПоля.УникальныйИдентификатор();
			КлючИсточника.ТипКлюча = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(ЗначениеКлючевогоПоля));
		КонецЦикла;
	ИначеЕсли ОписаниеКлюча.ВидКлюча = Перечисления.ВидыКлючейОтметокВремени.КлючНабораИдентификаторНабораЗаписей
			И Источник.Количество() > 1 Тогда
		
		ЗначенияПоля = Источник.Выгрузить(, "ИдентификаторОтметкиВремени");
		ЗначенияПоля.Свернуть("ИдентификаторОтметкиВремени");
		
		Для Каждого ЗначениеПоля Из ЗначенияПоля Цикл
			КлючИсточника = ОписаниеОтметкиВремени.КлючиИсточника.Добавить();
			КлючИсточника.ИдентификаторКлюча = ЗначениеПоля["ИдентификаторОтметкиВремени"]; //@skip-check statement-type-change
			КлючИсточника.ТипКлюча = Неопределено;
		КонецЦикла;
	КонецЕсли;

	Возврат ОписаниеОтметкиВремени;
	
КонецФункции

// Возвращает ключи и значения отборов записей замещаемого набора.
//
// Параметры:
//	ОбъектМетаданных - ОбъектМетаданных - Объект, записи которого необходимо получить.
//	Отбор - Отбор - Отбор, согласно которому необходимо получить записи.
//
// Возвращаемое значение:
//	Массив Из Структура:
//		* ИдентификаторКлюча - УникальныйИдентификатор - ИдентификаторКлюча ключа записи.
//		* ЗначенияОтбораКлюча - ХранилищеЗначения - Отбор соответствующий записи.
//
Функция КлючиОтборыЗамещаемыхЗаписей(ОбъектМетаданных, Отбор)
	
	КлючиЗаписейЗамещаемогоОтбора = Новый Массив; // Массив Из Структура
	
	Запрос = Новый Запрос;
	
	Поля = Новый Массив; // Массив Из Строка
	Условия = Новый Массив; // Массив Из Строка
	
	Для Каждого Элемент Из Отбор Цикл
		Поля.Добавить(СтрШаблон(", Таблица.%1 КАК %1", Элемент.Имя));
		Если Элемент.Использование Тогда
			Условия.Добавить(СтрШаблон(" И Таблица.%1 = &Параметр%1", Элемент.Имя));
			Запрос.УстановитьПараметр(СтрШаблон("Параметр%1", Элемент.Имя), Элемент.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Запрос.Текст = СтрШаблон(
		"ВЫБРАТЬ
		|	ИСТИНА КАК ПолеИстина %1
		|ИЗ
		|	%2 КАК Таблица
		|ГДЕ
		|	ИСТИНА %3",
		СтрСоединить(Поля),
		ОбъектМетаданных.ПолноеИмя(),
		СтрСоединить(Условия));
		
	КлючевойНабор = РегистрыСведений[ОбъектМетаданных.Имя].СоздатьНаборЗаписей(); // ОпределяемыйТип.ОтметкиВремениРегистры
	Для Каждого Поле Из КлючевойНабор.Отбор Цикл
		Поле.Использование = Истина;
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗамещаемыеЗаписи = Запрос.Выполнить().Выбрать();
	Пока ЗамещаемыеЗаписи.Следующий() Цикл
		Для Каждого Элемент Из КлючевойНабор.Отбор Цикл
			Элемент.Значение = Элемент.ТипЗначения.ПривестиЗначение(ЗамещаемыеЗаписи[Элемент.Имя]);
		КонецЦикла;
		
		КлючЗаписи = ОтметкиВремени.ИдентификаторНабораЗаписей(КлючевойНабор);
		ЗначенияОтбора = Новый ХранилищеЗначения(КлючевойНабор.Отбор, Новый СжатиеДанных(9));
		
		КлючиЗаписейЗамещаемогоОтбора.Добавить(
			Новый Структура("ИдентификаторКлюча, ЗначенияОтбораКлюча", КлючЗаписи, ЗначенияОтбора));
	КонецЦикла;
	
	Возврат КлючиЗаписейЗамещаемогоОтбора;
	
КонецФункции

// Возвращает номер очереди, в которую будет записана отметка времени.
//
// Возвращаемое значение:
//  Число - Номер очереди.
//
Функция ТекущийНомерОчереди()
	
	Возврат (НомерСоединенияИнформационнойБазы() % 3) + 1;
	
КонецФункции

// Определяет, является ли отбор набора записей полным.
// 
// Параметры:
//  Источник - ОпределяемыйТип.ОтметкиВремениРегистры - Набор записей, полноту отбора которого нужно определить.
// 
// Возвращаемое значение:
//  Булево - Отбор набора записей является полным.
//
Функция ОтборНабораПолный(Источник)
	
	Для Каждого Поле Из Источник.Отбор Цикл
		Если Не Поле.Использование Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
