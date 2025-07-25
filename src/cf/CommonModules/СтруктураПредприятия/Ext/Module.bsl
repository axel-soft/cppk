﻿// @strict-types

#Область ПрограммныйИнтерфейс

// Возвращает руководителя для подразделения.
// 
// Если у переданного разделения руководитель не заполнен, то для него является руководителем
// ближайший вверх по иерархии.
// 
// Параметры:
//  Подразделение - СправочникСсылка.СтруктураПредприятия,
//                  СправочникОбъект.СтруктураПредприятия.
//  ИспользоватьКэш - Булево - признак использования кэша (РС ПодчиненностьПодразделений).
// 
// Возвращаемое значение:
//  СправочникСсылка.Сотрудники
//
Функция РуководительПодразделения(Подразделение, ИспользоватьКэш = Истина) Экспорт
	
	Если ИспользоватьКэш Тогда
		Возврат РегистрыСведений.ПодчиненностьПодразделений.РуководительПодразделения(Подразделение);
	Иначе
		Возврат Справочники.СтруктураПредприятия.РуководительПодразделения(Подразделение);
	КонецЕсли;
	
КонецФункции

// Возвращает всех руководителей предприятия.
// 
// Возвращаемое значение:
//  Массив из СправочникСсылка.Сотрудники
//
Функция ВсеРуководителиПредприятия() Экспорт
	
	РуководителиПредприятия = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СтруктураПредприятия.Руководитель
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|ГДЕ
		|	СтруктураПредприятия.ПометкаУдаления = ЛОЖЬ";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Руководитель) Тогда 
			РуководителиПредприятия.Добавить(Выборка.Руководитель);
		КонецЕсли;
	КонецЦикла;
	
	Возврат РуководителиПредприятия;
	
КонецФункции

// Возвращает все подразделения, подчиненные руководителю.
// 
// Параметры:
//  Руководитель - СправочникСсылка.Сотрудники, Массив из СправочникСсылка.Сотрудники - руководитель или массив руководителей.
//  СУчитетомИерархии - Булево - определяет включение в результат подразделений находящихся ниже
//                               по иерархии, от подразделений, которыми непосредственно руководит
//                               сотрудник (Руководитель).
//
// Возвращаемое значение:
//  Массив из СправочникСсылка.СтруктураПредприятия
//
Функция ПодчиненныеПодразделения(Руководитель, СУчитетомИерархии = Ложь) Экспорт
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПодчиненностьПодразделений.Подчиненное КАК Подразделение
		|ИЗ
		|	РегистрСведений.ПодчиненностьПодразделений КАК ПодчиненностьПодразделений
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|		ПО ПодчиненностьПодразделений.Подчиненное = СтруктураПредприятия.Ссылка
		|ГДЕ
		|	ПодчиненностьПодразделений.РуководительВышестоящего В (&Руководители)
		|	И ПодчиненностьПодразделений.Подчиненное = ПодчиненностьПодразделений.Вышестоящее
		|	И СтруктураПредприятия.ПометкаУдаления = ЛОЖЬ";
	
	Если СУчитетомИерархии Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
			"ПодчиненностьПодразделений.Подчиненное = ПодчиненностьПодразделений.Вышестоящее",
			"ИСТИНА");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Если ТипЗнч(Руководитель) = Тип("СправочникСсылка.Сотрудники") Тогда
		Руководители = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Руководитель);
	Иначе
		Руководители = Руководитель;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Руководители", Руководители);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Подразделение");
	
КонецФункции

// Возвращает все подразделения, подчиненные указанному.
// 
// Параметры:
//  Подразделение - СправочникСсылка.СтруктураПредприятия
//
// Возвращаемое значение:
//  Массив из СправочникСсылка.СтруктураПредприятия
//
Функция ПодчиненныеПодразделенияИерархия(Подразделение) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СтруктураПредприятия.Ссылка КАК Подразделение
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|ГДЕ
		|	СтруктураПредприятия.Ссылка В ИЕРАРХИИ (&Подразделение)";
		
	ПодчиненныеПодразделения = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Подразделение");
	
	Возврат ПодчиненныеПодразделения;
	
КонецФункции

// Возвращает руководителей подчиненных подразделений, которые непосредственно подчинены
// переданному руководителю.
// 
// Параметры:
//  Руководитель - СправочникСсылка.Сотрудники
//  ТолькоДействующих - Булево
// 
// Возвращаемое значение:
//  Массив из СправочникСсылка.Сотрудники
//
Функция РуководителиПодразделенийВНепосредственномПодчинении(Руководитель, ТолькоДействующих = Истина) Экспорт
	
	ТекстЗапрос =
		"ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Ссылка
		|ИЗ
		|	РегистрСведений.ПодчиненностьПодразделений КАК ПодчиненностьПодразделений
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
		|		ПО Сотрудники.Ссылка = ПодчиненностьПодразделений.РуководительПодчиненного
		|ГДЕ
		|	ПодчиненностьПодразделений.РуководительВышестоящего = &Руководитель
		|	И ПодчиненностьПодразделений.УровеньВышестоящегоОтПодчиненного = 1
		|	И Сотрудники.Действует = ИСТИНА";
	
	Если Не ТолькоДействующих Тогда
		ТекстЗапрос = СтрЗаменить(ТекстЗапрос, "Сотрудники.Действует = ИСТИНА", "ИСТИНА");
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапрос);
	Запрос.УстановитьПараметр("Руководитель", Руководитель);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Проверяет, является ли указанный сотрудник руководителем.
//
// Параметры:
//  Сотрудник - СправочникСсылка.Сотрудники, Массив из СправочникСсылка.Сотрудники - проверяемый сотрудник или массив сотрудников.
//  УчитыватьПомеченныеНаУдаленияПодразделения - Булево
//
// Возвращаемое значение:
//  Булево
//
Функция ЭтоРуководитель(Сотрудник, УчитыватьПомеченныеНаУдаленияПодразделения = Ложь) Экспорт 
	
	ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|ГДЕ
		|	СтруктураПредприятия.Руководитель В (&Сотрудники)
		|	И НЕ СтруктураПредприятия.ПометкаУдаления";
	
	Если УчитыватьПомеченныеНаУдаленияПодразделения Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "НЕ СтруктураПредприятия.ПометкаУдаления", "ИСТИНА");
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Если ТипЗнч(Сотрудник) = Тип("СправочникСсылка.Сотрудники") Тогда
		СотрудникиРуководители = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник);
	Иначе
		СотрудникиРуководители = Сотрудник;
	КонецЕсли;
	
	Запрос.Параметры.Вставить("Сотрудники", СотрудникиРуководители); 
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

// Определяет руководителей подразделений по иерархии.
// 
// Параметры:
//  Подразделения - Массив из СправочникСсылка.СтруктураПредприятия.
// 
// Возвращаемое значение:
//  См. РегистрыСведений.ПодчиненностьПодразделений.РуководителиПодразделенийПоИерархии.
// 
Функция РуководителиПодразделенийПоИерархии(Подразделения) Экспорт
	
	РуководителиПодразделенийПоИерархии =
		РегистрыСведений.ПодчиненностьПодразделений.РуководителиПодразделенийПоИерархии(
			Подразделения);
	
	Возврат РуководителиПодразделенийПоИерархии;
	
КонецФункции

#КонецОбласти