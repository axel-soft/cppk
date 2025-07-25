﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует соответствие структур значений показателей.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи.
//  ИдентификаторКлиента - УникальныйИдентификатор.
//
// Возвращаемое значение:
//  Соответствие - Соответствие структур значений показателей.
//
Функция ЗначенияПоказателей(Пользователь, ИдентификаторКлиента) Экспорт
	
	ЗначенияПоказателей = Новый Соответствие;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗначенияПоказателейВиджетов.Показатель КАК Показатель,
		|	ЗначенияПоказателейВиджетов.ЗначениеПоказателя КАК ЗначениеПоказателя,
		|	ЗначенияПоказателейВиджетов.ДатаРасчета КАК ДатаРасчета,
		|	ЗначенияПоказателейВиджетов.ИменаСвойствСоЗначениямиДата КАК ИменаСвойствСоЗначениямиДата
		|ИЗ
		|	РегистрСведений.ЗначенияПоказателейВиджетов КАК ЗначенияПоказателейВиджетов
		|ГДЕ
		|	ЗначенияПоказателейВиджетов.Пользователь = &Пользователь
		|	И ЗначенияПоказателейВиджетов.ИдентификаторКлиента = &ИдентификаторКлиента");
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("ИдентификаторКлиента", ИдентификаторКлиента);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтруктураЗначенияПоказателя = СтруктураЗначенияПоказателя();
		СтруктураЗначенияПоказателя.Показатель = Выборка.Показатель;
		СтруктураЗначенияПоказателя.ЗначениеПоказателя = ЗначениеПоказателя(
			Выборка.ЗначениеПоказателя,
			Выборка.ИменаСвойствСоЗначениямиДата);
		СтруктураЗначенияПоказателя.ДатаРасчета = Выборка.ДатаРасчета;
		
		ЗначенияПоказателей.Вставить(Выборка.Показатель, СтруктураЗначенияПоказателя);
		
	КонецЦикла;
	
	Возврат ЗначенияПоказателей;
	
КонецФункции

// Обновляет значение показателя.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи.
//  Показатель - СправочникСсылка.ПоказателиВиджетов.
//  ЗначениеПоказателя - Число.
//
Процедура ОбновитьЗначениеПоказателя(Пользователь, ИдентификаторКлиента, Показатель, ЗначениеПоказателя) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	НаборЗаписей.Отбор.ИдентификаторКлиента.Установить(ИдентификаторКлиента);
	НаборЗаписей.Отбор.Показатель.Установить(Показатель);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Пользователь = Пользователь;
	НоваяЗапись.ИдентификаторКлиента = ИдентификаторКлиента;
	НоваяЗапись.Показатель = Показатель;
	
	СоответствиеЗначениеПоказателя = Новый Соответствие;
	СоответствиеЗначениеПоказателя.Вставить("ЗначениеПоказателя", ЗначениеПоказателя);
	
	НоваяЗапись.ЗначениеПоказателя = ХранимоеЗначениеПоказателя(СоответствиеЗначениеПоказателя);
	НоваяЗапись.ИменаСвойствСоЗначениямиДата = ИменаСвойствСоЗначениямиДата(СоответствиеЗначениеПоказателя);
	
	НоваяЗапись.ДатаРасчета = ТекущаяДатаСеанса();
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Обновляет значения показателей.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи.
//  Показатель - СправочникСсылка.ПоказателиВиджетов.
//  ЗначенияПоказателей - Соответствие.
//
Процедура ОбновитьЗначенияПоказателей(Пользователь, ИдентификаторКлиента, ЗначенияПоказателей) Экспорт
	
	Если ЗначенияПоказателей.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	НаборЗаписей.Отбор.ИдентификаторКлиента.Установить(ИдентификаторКлиента);
	
	ДатаРасчета = ТекущаяДатаСеанса();
	
	ПериодУстареванияЗначенийПоказателейВиджетов = 600;
	ДопустимаяДатаРасчета = ДатаРасчета - ПериодУстареванияЗначенийПоказателейВиджетов;
	
	// Прочитаем данные, которые уже есть в базе.
	// Если по ним есть значения - актуализируем.
	// Если по ним нет новых значений и они устарели - удалим.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗначенияПоказателейВиджетов.Показатель КАК Показатель,
		|	ЗначенияПоказателейВиджетов.ЗначениеПоказателя КАК ЗначениеПоказателя,
		|	ЗначенияПоказателейВиджетов.ДатаРасчета КАК ДатаРасчета,
		|	ЗначенияПоказателейВиджетов.ИменаСвойствСоЗначениямиДата КАК ИменаСвойствСоЗначениямиДата
		|ИЗ
		|	РегистрСведений.ЗначенияПоказателейВиджетов КАК ЗначенияПоказателейВиджетов
		|ГДЕ
		|	ЗначенияПоказателейВиджетов.Пользователь = &Пользователь
		|	И ЗначенияПоказателейВиджетов.ИдентификаторКлиента = &ИдентификаторКлиента");
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("ИдентификаторКлиента", ИдентификаторКлиента);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НовоеЗначениеПоказателя = ЗначенияПоказателей[Выборка.Показатель];
		
		Если НовоеЗначениеПоказателя = Неопределено
			И Выборка.ДатаРасчета < ДопустимаяДатаРасчета Тогда
			Продолжить;
		КонецЕсли;
		
		СтараяЗапись = НаборЗаписей.Добавить();
		СтараяЗапись.Пользователь = Пользователь;
		СтараяЗапись.ИдентификаторКлиента = ИдентификаторКлиента;
		СтараяЗапись.Показатель = Выборка.Показатель;
		
		Если НовоеЗначениеПоказателя <> Неопределено Тогда
			
			СоответствиеЗначениеПоказателя = Новый Соответствие;
			СоответствиеЗначениеПоказателя.Вставить("ЗначениеПоказателя", НовоеЗначениеПоказателя);
			
			СтараяЗапись.ЗначениеПоказателя = ХранимоеЗначениеПоказателя(СоответствиеЗначениеПоказателя);
			СтараяЗапись.ИменаСвойствСоЗначениямиДата = ИменаСвойствСоЗначениямиДата(СоответствиеЗначениеПоказателя);
			
			СтараяЗапись.ДатаРасчета = ДатаРасчета;
			
			ЗначенияПоказателей.Удалить(СтараяЗапись.Показатель);
			
		Иначе
			
			СтараяЗапись.ЗначениеПоказателя = Выборка.ЗначениеПоказателя;
			СтараяЗапись.ИменаСвойствСоЗначениямиДата = Выборка.ИменаСвойствСоЗначениямиДата;
			СтараяЗапись.ДатаРасчета = Выборка.ДатаРасчета;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Добавим новые записи.
	Для Каждого КлючИзначение Из ЗначенияПоказателей Цикл
		
		Показатель = КлючИзначение.Ключ;
		ЗначениеПоказателя = КлючИзначение.Значение;
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Пользователь = Пользователь;
		НоваяЗапись.ИдентификаторКлиента = ИдентификаторКлиента;
		НоваяЗапись.Показатель = Показатель;
		
		СоответствиеЗначениеПоказателя = Новый Соответствие;
		СоответствиеЗначениеПоказателя.Вставить("ЗначениеПоказателя", ЗначениеПоказателя);
		
		НоваяЗапись.ЗначениеПоказателя = ХранимоеЗначениеПоказателя(СоответствиеЗначениеПоказателя);
		НоваяЗапись.ИменаСвойствСоЗначениямиДата = ИменаСвойствСоЗначениямиДата(СоответствиеЗначениеПоказателя);
		
		НоваяЗапись.ДатаРасчета = ДатаРасчета;
		
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Формирует пустую структуру значения показателя.
// 
// Возвращаемое значение:
//  Структура - Пустая структура значения показателя.
//
Функция СтруктураЗначенияПоказателя() Экспорт
	
	Возврат Новый Структура("Показатель, ЗначениеПоказателя, ДатаРасчета");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Преобразует значение показателя в хранимое значение показателя.
//
// Параметры:
//  СоответствиеЗначениеПоказателя - Соответствие.
// 
// Возвращаемое значение:
//  Строка - Хранимое значение показателя.
//
Функция ХранимоеЗначениеПоказателя(СоответствиеЗначениеПоказателя)
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	
	НастройкиСериализации = Новый НастройкиСериализацииJSON;
	НастройкиСериализации.ВариантЗаписиДаты = ВариантЗаписиДатыJSON.ЛокальнаяДата;
	НастройкиСериализации.ФорматСериализацииДаты = ФорматДатыJSON.ISO;
	ЗаписатьJSON(ЗаписьJSON, СоответствиеЗначениеПоказателя);
	
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

// Преобразует значение показателя в имена свойств со значениями дата.
//
// Параметры:
//  СоответствиеЗначениеПоказателя - Соответствие.
// 
// Возвращаемое значение:
//  Строка - Хранимое значение показателя.
//
Функция ИменаСвойствСоЗначениямиДата(СоответствиеЗначениеПоказателя)
	
	ТекущийПуть = "";
	МассивИмен = Новый Массив;
	
	ИменаСвойствСоЗначениямиДатаИтерация(СоответствиеЗначениеПоказателя, МассивИмен, ТекущийПуть);
	
	МассивИмен = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивИмен);
	
	ИменаСвойствСоЗначениямиДата = СтрСоединить(МассивИмен, ",");
	
	Возврат ИменаСвойствСоЗначениямиДата;
	
КонецФункции

// Выполняет итерацию преобразования значение показателя в имена свойств со значениями дата.
//
// Параметры:
//  ТекущийЭлемент - Произвольный.
//  МассивИмен - Массив из Строка.
//  ТекущийПуть - Строка.
//
Процедура ИменаСвойствСоЗначениямиДатаИтерация(ТекущийЭлемент, МассивИмен, ТекущийПуть)
	
	Если ТипЗнч(ТекущийЭлемент) = Тип("Соответствие")
		Или ТипЗнч(ТекущийЭлемент) = Тип("Структура") Тогда
		
		Для Каждого КлючИЗначение Из ТекущийЭлемент Цикл
			
			Элемент = КлючИЗначение.Значение;
			
			ИменаСвойствСоЗначениямиДатаИтерация(Элемент, МассивИмен, КлючИЗначение.Ключ);
			
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ТекущийЭлемент) = Тип("Массив") Тогда
		
		Для Каждого Элемент Из ТекущийЭлемент Цикл
			ИменаСвойствСоЗначениямиДатаИтерация(Элемент, МассивИмен, ТекущийПуть);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ТекущийЭлемент) = Тип("Дата") Тогда
		
		МассивИмен.Добавить(ТекущийПуть);
		
	КонецЕсли;
	
КонецПроцедуры

// Преобразует храимое значение показателя в значение показателя.
//
// Параметры:
//  ХранимоеЗначениеПоказателя - Строка - Хранимое значение показателя.
// 
// Возвращаемое значение:
//  Произвольный - Значение показателя.
//
Функция ЗначениеПоказателя(ХранимоеЗначениеПоказателя, ИменаСвойствСоЗначениямиДата)
	
	Если ЗначениеЗаполнено(ИменаСвойствСоЗначениямиДата) Тогда
		МассивИмен = СтрРазделить(ИменаСвойствСоЗначениямиДата, ",");
	Иначе
		МассивИмен = Новый Массив;
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ХранимоеЗначениеПоказателя);
	СоответствиеЗначениеПоказателя = ПрочитатьJSON(ЧтениеJSON,, МассивИмен, ФорматДатыJSON.ISO);
	ЧтениеJSON.Закрыть();
	
	Возврат СоответствиеЗначениеПоказателя.ЗначениеПоказателя;
	
КонецФункции

#КонецОбласти

#КонецЕсли