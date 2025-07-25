﻿// @strict-types

#Область ПрограммныйИнтерфейс

// Добавляет задание определения дескриптора доступа набора записей.
//
// Параметры:
//	Объект - РегистрСведенийНаборЗаписей - Объект, для которого необходимо добавить задание.
//
// Возвращаемое значение:
//	Булево - Истина - Задание добавлено.
//
Функция ДобавитьЗаданиеОпределитьДескрипторДоступаНабораЗаписей(Объект) Экспорт
	
	Если Не ОбщегоНазначенияДокументооборот.ЭтоДокументооборотХолдинга()
			Или Не ОбщегоНазначенияДокументооборотХолдинг.ЭтоЗагрузкаОбъекта(Объект) Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Если КОДПовтИсп.ИспользуетсяОтложеннаяОбработкаДанныхКОД() Тогда
		КОДСлужебный.ДобавитьЗаданиеОтложеннойОбработки(
			Перечисления.ТипыОтложеннойОбработки.ОпределитьДескрипторДоступаНабораЗаписей,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
				Новый Структура("Объект, Параметры", Объект, Объект.ДополнительныеСвойства)));
	Иначе
		КОДСлужебный.ДобавитьЗаданиеПостобработкиВХранилищеОтложеннойЗаписи(
			Перечисления.ТипыОтложеннойОбработки.ОпределитьДескрипторДоступаНабораЗаписей,
			Новый Структура("Объект, Параметры", Объект, Объект.ДополнительныеСвойства));
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Добавляет задание определения дескриптора доступа объекта.
//
// Параметры:
//	Объект - РегистрСведенийНаборЗаписей - Объект, для которого необходимо добавить задание.
//
// Возвращаемое значение:
//	Булево - Истина - Задание добавлено.
//
Функция ДобавитьЗаданиеОпределитьДескрипторДоступаОбъекта(Объект) Экспорт
	
	Если Не ОбщегоНазначенияДокументооборот.ЭтоДокументооборотХолдинга()
			Или Не ОбщегоНазначенияДокументооборотХолдинг.ЭтоЗагрузкаОбъекта(Объект) Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Если КОДПовтИсп.ИспользуетсяОтложеннаяОбработкаДанныхКОД() Тогда
		КОДСлужебный.ДобавитьЗаданиеОтложеннойОбработки(
			Перечисления.ТипыОтложеннойОбработки.ОпределитьДескрипторДоступаОбъекта,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
				Новый Структура("Объект, Параметры", Объект, Объект.ДополнительныеСвойства)));
	Иначе
		КОДСлужебный.ДобавитьЗаданиеПостобработкиВХранилищеОтложеннойЗаписи(
			Перечисления.ТипыОтложеннойОбработки.ОпределитьДескрипторДоступаОбъекта,
			Новый Структура("Объект, Параметры", Объект, Объект.ДополнительныеСвойства));
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Добавляет задание обработки записи правообразующего регистра.
//
// Параметры:
//	Объект - РегистрСведенийНаборЗаписей - Объект, для которого необходимо добавить задание.
//
// Возвращаемое значение:
//	Булево - Истина - Задание добавлено.
//
Функция ДобавитьЗаданиеОбработатьЗаписьПравообразующегоРегистра(Объект) Экспорт
	
	Если Не ОбщегоНазначенияДокументооборот.ЭтоДокументооборотХолдинга()
			Или Не ОбщегоНазначенияДокументооборотХолдинг.ЭтоЗагрузкаОбъекта(Объект) Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Если КОДПовтИсп.ИспользуетсяОтложеннаяОбработкаДанныхКОД() Тогда
		КОДСлужебный.ДобавитьЗаданиеОтложеннойОбработки(
			Перечисления.ТипыОтложеннойОбработки.ОбработатьЗаписьПравообразующегоРегистра,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
				Новый Структура("Объект, Параметры", Объект, Объект.ДополнительныеСвойства)));
	Иначе
		КОДСлужебный.ДобавитьЗаданиеПостобработкиВХранилищеОтложеннойЗаписи(
			Перечисления.ТипыОтложеннойОбработки.ОбработатьЗаписьПравообразующегоРегистра,
			Новый Структура("Объект, Параметры", Объект, Объект.ДополнительныеСвойства));
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Добавляет задание обработки записи правообразующего регистра.
//
// Параметры:
//	Объект - СправочникОбъект - Объект, для которого необходимо добавить задание.
//
// Возвращаемое значение:
//	Булево - Истина - Задание добавлено.
//
Функция ДобавитьЗаданиеОбработатьЗаписьПравообразующегоОбъекта(Объект) Экспорт
	
	Если Не ОбщегоНазначенияДокументооборот.ЭтоДокументооборотХолдинга()
			Или Не ОбщегоНазначенияДокументооборотХолдинг.ЭтоЗагрузкаОбъекта(Объект) Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Если КОДПовтИсп.ИспользуетсяОтложеннаяОбработкаДанныхКОД() Тогда
		КОДСлужебный.ДобавитьЗаданиеОтложеннойОбработки(
			Перечисления.ТипыОтложеннойОбработки.ОбработатьЗаписьПравообразующегоОбъекта,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
				Новый Структура("Объект, Параметры", Объект, Объект.ДополнительныеСвойства)));
	Иначе
		КОДСлужебный.ДобавитьЗаданиеПостобработкиВХранилищеОтложеннойЗаписи(
			Перечисления.ТипыОтложеннойОбработки.ОбработатьЗаписьПравообразующегоОбъекта,
			Новый Структура("Объект, Параметры", Объект, Объект.ДополнительныеСвойства));
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Добавляет задание обработки записи файла.
//
// Параметры:
//	Файл - СправочникОбъект.Файлы - Файл, для которого необходимо добавить задание.
//
// Возвращаемое значение:
//	Булево - Истина - Задание добавлено.
//
Функция ДобавитьЗаданиеОпределитьПраваФайла(Файл) Экспорт
	
	Если Не ОбщегоНазначенияДокументооборот.ЭтоДокументооборотХолдинга()
			Или Не ОбщегоНазначенияДокументооборотХолдинг.ЭтоЗагрузкаОбъекта(Файл) Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Если КОДПовтИсп.ИспользуетсяОтложеннаяОбработкаДанныхКОД() Тогда
		КОДСлужебный.ДобавитьЗаданиеОтложеннойОбработки(
			Перечисления.ТипыОтложеннойОбработки.ОпределитьПраваФайла,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
				Новый Структура("Объект, Параметры", Файл, Файл.ДополнительныеСвойства)));
	Иначе
		КОДСлужебный.ДобавитьЗаданиеПостобработкиВХранилищеОтложеннойЗаписи(
			Перечисления.ТипыОтложеннойОбработки.ОбработатьЗаписьПравообразующегоОбъекта,
			Новый Структура("Объект, Параметры", Файл, Файл.ДополнительныеСвойства));
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#Область ПереопределениеМетодовКОД

// Дополняет сопровождающие данные объектов при выгрузке в узлы КОД
// 
// Параметры:
//  ИмяОбъектаМетаданных - Строка - Полное имя объекта метаданных, сопровождающие данные которого необходимо дополнить
//  Ключи - Массив Из ЛюбаяСсылка - Массив ключей, по которым необходимо получить сопровождающие данные
//  СопровождающиеДанныеОбъектов - Соответствие Из КлючИЗначение:
//    * Ключ - Строка - Полное имя объекта метаданных сопровождающих данных
//    * Значение - Массив Из ЛюбаяСсылка - Ссылки на сопровождающие данные
Процедура ДополнитьСопровождающиеДанныеОбъектов(ИмяОбъектаМетаданных, Ключи, СопровождающиеДанныеОбъектов) Экспорт
	
	Если ИмяОбъектаМетаданных = ИмяРегистраРабочихГрупп() Тогда
		
		ДополнитьСопровождающиеДанныеДокументамиРабочихГрупп(Ключи, СопровождающиеДанныеОбъектов);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДополнениеСопровождающихДанныхКОД

// Возвращает имя регистра рабочих групп
// 
// Возвращаемое значение:
//  Строка
Функция ИмяРегистраРабочихГрупп()
	
	Возврат Метаданные.РегистрыСведений.РабочиеГруппы.ПолноеИмя();
	
КонецФункции

// Выполняет дополнение сопровождающих данных КОД документами по идентификаторам отметок времени изменений рабочих групп
// 
// Параметры:
//  КлючиРабочихГрупп - Массив Из УникальныйИдентификатор
//  СопровождающиеДанные - Соответствие Из КлючИЗначение:
//    * Ключ - Строка - Имя объекта метаданных
//    * Значение - Массив Из ЛюбаяСсылка, УникальныйИдентификатор - Ключи объектов
// 
Процедура ДополнитьСопровождающиеДанныеДокументамиРабочихГрупп(КлючиРабочихГрупп, СопровождающиеДанные)
	
	ОбъектыПоКлючам = ОбъектыРабочихГруппПоКлючамОтметокВремени(КлючиРабочихГрупп);
	
	ДокументыКСопровождающимДанным = Новый Массив(); // Массив Из СправочникСсылка.ДокументыПредприятия
	Для Каждого Элемент Из ОбъектыПоКлючам Цикл
		
		Объект = Элемент.Значение;
		Если ТипЗнч(Объект) = Тип("СправочникСсылка.ДокументыПредприятия")
			И ЗначениеЗаполнено(Объект) Тогда
			
			ДокументыКСопровождающимДанным.Добавить(Объект);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДокументыКСопровождающимДанным.Количество() > 0 Тогда
		
		ИмяСправочникаДокументов = Метаданные.Справочники.ДокументыПредприятия.ПолноеИмя();
		
		СопровождающиеДокументы = СопровождающиеДанные[ИмяСправочникаДокументов]; // Массив Из СправочникСсылка.ДокументыПредприятия
		Если СопровождающиеДокументы = Неопределено Тогда
			СопровождающиеДокументы = Новый Массив();
			СопровождающиеДанные[ИмяСправочникаДокументов] = СопровождающиеДокументы;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
			СопровождающиеДокументы, ДокументыКСопровождающимДанным, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает объекты рабочих групп по идентификаторам отметок времени записей регистра
// 
// Параметры:
//  Ключи - Массив Из УникальныйИдентификатор
// 
// Возвращаемое значение:
//  Соответствие Из КлючИЗначение:
//    * Ключ - УникальныйИдентификатор
//    * Значение - СправочникСсылка.ТемыОбсуждений - 
//               - СправочникСсылка.ШаблоныУтверждения - 
//               - СправочникСсылка.Проекты - 
//               - СправочникСсылка.ШаблоныОзнакомления - 
//               - СправочникСсылка.ЗаписиРабочегоКалендаря - 
//               - СправочникСсылка.ШаблоныРассмотрения - 
//               - СправочникСсылка.ШаблоныСогласования - 
//               - ДокументСсылка.Задача - 
//               - СправочникСсылка.ШаблоныДокументов - 
//               - СправочникСсылка.ДокументыПредприятия - 
//               - ДокументСсылка.ДействиеЗадачи - 
//               - СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов -
//               - СправочникСсылка.ГруппыКонтактовПользователей -
//               - СправочникСсылка.ШаблоныПриглашения - 
//               - СправочникСсылка.ШаблоныИсполнения - 
//               - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - 
//               - СправочникСсылка.ШаблоныПодписания - 
//               - СправочникСсылка.ШаблоныРегистрации - 
//               - СправочникСсылка.Мероприятия - 
//               - СправочникСсылка.ПроектныеЗадачи - 
//               - БизнесПроцессСсылка -
//               - Неопределено -
//
Функция ОбъектыРабочихГруппПоКлючамОтметокВремени(Ключи)
	
	ОбъектыПоКлючам = Новый Соответствие();
	Для Каждого Ключ Из Ключи Цикл
		ОбъектыПоКлючам[Ключ] = Неопределено;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РабочиеГруппы.ИдентификаторОтметкиВремени КАК Ключ,
		|	РабочиеГруппы.Объект КАК Объект
		|ИЗ
		|	РегистрСведений.РабочиеГруппы КАК РабочиеГруппы
		|ГДЕ
		|	РабочиеГруппы.ИдентификаторОтметкиВремени В (&КлючиРабочихГрупп)";
	Запрос.УстановитьПараметр("КлючиРабочихГрупп", Ключи);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ОбъектыПоКлючам[Выборка.Ключ] = Выборка.Объект;
	КонецЦикла;
	
	Возврат ОбъектыПоКлючам;
	
КонецФункции

#КонецОбласти

#КонецОбласти