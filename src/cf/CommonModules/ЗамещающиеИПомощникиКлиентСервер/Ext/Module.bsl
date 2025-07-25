﻿#Область ПрограммныйИнтерфейс

// Представление отбора
//
// Параметры:
//  СтрокаДерева - ДанныеФормыЭлементДерева:
// * ДоступенОтбор - Булево
// * ЗначенияОтбора - СписокЗначений Из СправочникСсылка.ВидыДокументов
// * Область - СправочникСсылка.ОбластиЗамещения
// * Пометка - Число
// * ПредставлениеОтбора - Строка
// 
// Возвращаемое значение:
//  Строка
//
Функция ПредставлениеОтбора(СтрокаДерева) Экспорт
	
	#Если Не ВнешнееСоединение Тогда
	ДоступенОтбор = СтрокаДерева.ДоступенОтбор;
	Если Не ДоступенОтбор Тогда
		Возврат "";
	КонецЕсли;

	СписокЗначенийОтбора = СтрокаДерева.ЗначенияОтбора;
	Если СписокЗначенийОтбора = Неопределено Или СписокЗначенийОтбора.Количество() = 0 Тогда
		ПредставлениеОтбора = НСтр("ru = 'Все виды'");
	Иначе
		ПредставлениеОтбора = Строка(СписокЗначенийОтбора);
	КонецЕсли;
	
	Возврат ПредставлениеОтбора;
	#Иначе
	Возврат ""; // Перестраховка. Потенциально невозможная ситуация.
	#КонецЕсли
	
КонецФункции

// Заполняет ТЧ ВопросыЗамещения объекта по данным ДереваВопросовЗамещения
//
// Параметры:
//  Объект - СправочникОбъект.ЗамещающиеИПомощники -
//  	   - См. Справочник.ЗамещающиеИПомощники.Форма.ФормаЭлемента.Объект
//  ДеревоВопросовЗамещения - ДанныеФормыДерево,ДеревоЗначений
//  ПереданыВсеОбласти - Булево - Если Истина, то полное замещение
//
Процедура ЗаполнитьВопросыЗамещенияПоДаннымДерева(Объект, ДеревоВопросовЗамещения, ПереданыВсеОбласти) Экспорт
	
	Объект.ВопросыЗамещения.Очистить();
	
	Если ПереданыВсеОбласти Тогда
		СтрокаТЧ = Объект.ВопросыЗамещения.Добавить();
		СтрокаТЧ.Область = ПредопределенноеЗначение("Справочник.ОбластиЗамещения.ВсеОбласти");
		Возврат;
	КонецЕсли;
	
	СтрокиКОбработке = Новый Массив;
	ЕстьНеотмеченные = Ложь;
	СерверныйВызов = Не (ТипЗнч(ДеревоВопросовЗамещения) = Тип("ДанныеФормыДерево"));
	
	ЭлементыДерева = Неопределено;
	Если СерверныйВызов Тогда
		ЭлементыДерева = ДеревоВопросовЗамещения.Строки;
	Иначе
		ЭлементыДерева = ДеревоВопросовЗамещения.ПолучитьЭлементы();
	КонецЕсли;
	
	Для Каждого Стр Из ЭлементыДерева Цикл
		СтрокиКОбработке.Добавить(Стр);
		Если Стр.Пометка <> 1 Тогда
			ЕстьНеотмеченные = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьНеотмеченные Тогда
		СтрокаТЧ = Объект.ВопросыЗамещения.Добавить();
		СтрокаТЧ.Область = ПредопределенноеЗначение("Справочник.ОбластиЗамещения.ВсеОбласти");
		Возврат;
	КонецЕсли;
	
	Пока СтрокиКОбработке.Количество() > 0 Цикл
		Стр = СтрокиКОбработке[0];
		Если Стр.Пометка = 1 Тогда
			СтрокаТЧ = Объект.ВопросыЗамещения.Добавить();
			СтрокаТЧ.Область = Стр.Область;
		ИначеЕсли Стр.Пометка = 2 Тогда
			// Либо есть подчиненные, и не все они отмечены, либо есть список отбора.
			// Для элемента с подчиненными отбор не предусмотрен. 
			
			Если СерверныйВызов Тогда
				ПодчиненныеСтроки = Стр.Строки;
			Иначе
				ПодчиненныеСтроки = Стр.ПолучитьЭлементы();
			КонецЕсли;
			
			Если ПодчиненныеСтроки.Количество() = 0 Тогда
				Для Каждого ЭлементСписка Из Стр.ЗначенияОтбора Цикл
					СтрокаТЧ = Объект.ВопросыЗамещения.Добавить();
					СтрокаТЧ.Область = Стр.Область;
					СтрокаТЧ.ЗначениеОтбора = ЭлементСписка.Значение;
				КонецЦикла;
			Иначе
				Для Каждого ПодчиненнаяСтр Из ПодчиненныеСтроки Цикл
					СтрокиКОбработке.Добавить(ПодчиненнаяСтр);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		СтрокиКОбработке.Удалить(0);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти