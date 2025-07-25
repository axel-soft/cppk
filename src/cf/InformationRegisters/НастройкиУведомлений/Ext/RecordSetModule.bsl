﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 1 Тогда
		
		ЭлементЗаписи = Получить(0);
		Настройка = ЭлементЗаписи.Настройка;
		ВидСобытия = Перечисления.СобытияУведомлений.ВидБизнесСобытия(ЭлементЗаписи.ВидСобытия);
		Значение = ЭлементЗаписи.Значение;
		Если Настройка <> Перечисления.НастройкиУведомлений.Подписка
			Или ТипЗнч(ВидСобытия) <> Тип("СправочникСсылка.ВидыБизнесСобытий")
			Или ТипЗнч(Значение) <> Тип("Булево") Тогда
			Возврат;
		КонецЕсли;
		
		Если Значение Тогда
			ПриДобавленииПодписки(ВидСобытия);
		Иначе
			ПриУдаленииПодписки(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли Количество() = 0 Тогда // удаление
		
		ВидСобытия = Перечисления.СобытияУведомлений.ВидБизнесСобытия(Отбор.ВидСобытия.Значение);
		Если ТипЗнч(ВидСобытия) <> Тип("СправочникСсылка.ВидыБизнесСобытий") Тогда
			Возврат;
		КонецЕсли;
		
		ПриУдаленииПодписки(ВидСобытия);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет количество подписчиков на вид бизнес-события.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий - Вид события.
//
// Возвращаемое значение:
//  Число - Количество подписчиков.
//
Функция КоличествоПодписчиков(ВидСобытия)
	
	ВидыСобытийПодписки = Перечисления.СобытияУведомлений.ВидыСобытийПодписки(ВидСобытия);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиУведомлений.ВидСобытия
		|ИЗ
		|	РегистрСведений.НастройкиУведомлений КАК НастройкиУведомлений
		|ГДЕ
		|	НастройкиУведомлений.Настройка = ЗНАЧЕНИЕ(Перечисление.НастройкиУведомлений.Подписка)
		|	И НастройкиУведомлений.ВидСобытия В (&ВидыСобытийПодписки)
		|	И НастройкиУведомлений.Значение = ИСТИНА";
	Запрос.УстановитьПараметр("ВидыСобытийПодписки", ВидыСобытийПодписки);
	
	КоличествоПодписчиков = Запрос.Выполнить().Выгрузить().Количество();
	
	Возврат КоличествоПодписчиков;
	
КонецФункции

// Обработка при добавлении подписки на вид события.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий - Вид события.
//
Процедура ПриДобавленииПодписки(ВидСобытия)
	
	БизнесСобытияВызовСервера.СохранитьПодпискуНаБизнесСобытия(ВидСобытия,
		Перечисления.ПотребителиБизнесСобытий.РассылкаУведомлений);
	
КонецПроцедуры

// Обработка при удалении подписки на вид события.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий - Вид события.
//
Процедура ПриУдаленииПодписки(ВидСобытия)
	
	КоличествоПодписчиков = КоличествоПодписчиков(ВидСобытия);
	Если КоличествоПодписчиков = 0 Тогда
		БизнесСобытияВызовСервера.УдалитьПодпискуНаБизнесСобытия(ВидСобытия,
			Перечисления.ПотребителиБизнесСобытий.РассылкаУведомлений);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли