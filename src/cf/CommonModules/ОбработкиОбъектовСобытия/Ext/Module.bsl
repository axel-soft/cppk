﻿////////////////////////////////////////////////////////////////////////////////
// Обработки объектов (события)
//  
////////////////////////////////////////////////////////////////////////////////
#Область СлужебныйПрограммныйИнтерфейс

// Выполняется при завершении действия.
//
// Параметры:
//  Действие - ОпределяемыйТип.Действия
//  Состояние - ПеречислениеСсылка.СостоянияВыполненияДействий
//
Процедура ПриЗавершенииДействия(Действие, Состояние) Экспорт
		
	Если Состояние <> Перечисления.СостоянияВыполненияДействий.Завершено
		И Состояние <> Перечисления.СостоянияВыполненияДействий.Пропущено Тогда
		
		Возврат;
	КонецЕсли;
	
	// Стандартная обработка завершения действия.
	
	ОбработкаДействия = РегистрыСведений.ДействияОбработкиОбъектов.ОбработкаДействия(Действие);
	
	Событие = РегистрыСведений.ХодОбработки.СтруктураСобытия();
	Событие.Обработка = ОбработкаДействия;
	Событие.ТипСобытия = Перечисления.ТипСобытияХодаОбработки.ЗавершениеДействия;
	Событие.Действие = Действие;
	РегистрыСведений.ХодОбработки.ЗаписатьСобытие(Событие);
	
	Предмет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Действие, "Предмет");
	Если ДелопроизводствоКлиентСервер.ЭтоДокументПредприятия(Предмет) Тогда
		Если ДействияКлиентСервер.ЭтоДействиеПодписания(Действие)
			Или ДействияКлиентСервер.ЭтоДействиеУтверждения(Действие) Тогда
			// Нужно перезаполнить строку ПодписалУтвердил в предмете при завершении действий подписания и утверждения
			ПредметОбъект = Предмет.ПолучитьОбъект();
			ПредметОбъект.Записать();
		КонецЕсли;
		
		// Нужно проверить и скорректировать состояние предмета на случай нештатного завершения действия
		ФункцииУчастника = Новый Массив;
		Если ДействияКлиентСервер.ЭтоДействиеПодписания(Действие) Тогда
			ФункцииУчастника.Добавить(Перечисления.ФункцииУчастниковПодписания.Подписывающий);
		ИначеЕсли ДействияКлиентСервер.ЭтоДействиеУтверждения(Действие) Тогда
			ФункцииУчастника.Добавить(Перечисления.ФункцииУчастниковУтверждения.Утверждающий);
		ИначеЕсли ДействияКлиентСервер.ЭтоДействиеСогласования(Действие) Тогда
			ФункцииУчастника.Добавить(Перечисления.ФункцииУчастниковСогласования.Согласующий);
		ИначеЕсли ДействияКлиентСервер.ЭтоДействиеИсполнения(Действие) Тогда
			ФункцииУчастника.Добавить(Перечисления.ФункцииУчастниковИсполнения.Исполнитель);
			ФункцииУчастника.Добавить(Перечисления.ФункцииУчастниковИсполнения.Рассматривающий);
		КонецЕсли;
		Если ФункцииУчастника.Количество() Тогда
			
			ТаблицаСостояний = ДействияСервер.ТаблицаВозможныхСостоянийПредмета(Действие);
			
			Для Каждого ФункцияУчастника Из ФункцииУчастника Цикл
				
				РезультатДействия = РегистрыСведений.РезультатыДействий.РезультатДействияПоФункцииУчастников(Действие,
					 ФункцияУчастника);
					 
				Отбор = Новый Структура(
					"ТипПредмета, ЭтапОбработкиПредмета, СостояниеДействия, РезультатДействия, ФункцияУчастника");
				Отбор.ТипПредмета = ПредопределенноеЗначение("Перечисление.ТипыОбъектов.ДокументыПредприятия");
				Отбор.ЭтапОбработкиПредмета = Перечисления.ЭтапыОбработкиПредметов.ПустаяСсылка();
				Отбор.СостояниеДействия = Состояние;
				Отбор.РезультатДействия = РезультатДействия;
				Отбор.ФункцияУчастника = ФункцияУчастника;
				
				НайденныеСтроки = ТаблицаСостояний.НайтиСтроки(Отбор);
				Если НайденныеСтроки.Количество() > 0 Тогда
					СостояниеПредметаВРазрезеДействия = НайденныеСтроки[0].СостояниеДокумента;
				Иначе
					СостояниеПредметаВРазрезеДействия = Перечисления.СостоянияДокументов.ПустаяСсылка();
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СостояниеПредметаВРазрезеДействия) Тогда 
					Делопроизводство.ЗаписатьСостояниеДокумента(
						Предмет,
						ТекущаяДатаСеанса(),
						СостояниеПредметаВРазрезеДействия,
						,
						Действие,
						Истина);
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли; 
		
	ИначеЕсли ТипЗнч(Предмет) = Тип("СправочникСсылка.Мероприятия") Тогда
		
		Если ДействияКлиентСервер.ЭтоДействиеИсполнения(Действие) 
			И Состояние = Перечисления.СостоянияВыполненияДействий.Завершено Тогда
			
			ВидДействия = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Действие, "ВидДействия");
			ЭтапОбработкиПредмета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДействия, "ЭтапОбработкиПредмета");
			Если ЭтапОбработкиПредмета = Перечисления.ЭтапыОбработкиПредметов.ИсполнитьПротокол  Тогда
				
				Период = ТекущаяДатаСеанса();	
				
				УправлениеМероприятиями.ЗаписатьСостояниеМероприятия(
					Предмет,
					Период,
					Перечисления.СостоянияМероприятий.ПротоколИсполнен,
					Действие);
				
			КонецЕсли;	
			
		КонецЕсли;	
		
	КонецЕсли;
	
	// Регистрируем бизнес-событие.
	БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(
		Действие,
		Справочники.ВидыБизнесСобытий.ЗавершениеДействияОбработки);
	
КонецПроцедуры

// Выполняется при пропуске действия.
//
// Параметры:
//  Действие - ОпределяемыйТип.Действия
//
Процедура ПриПропускеДействия(Действие) Экспорт

	ОбработкаДействия = РегистрыСведений.ДействияОбработкиОбъектов.ОбработкаДействия(Действие);

	Событие = РегистрыСведений.ХодОбработки.СтруктураСобытия();
	Событие.Обработка = ОбработкаДействия;
	Событие.ТипСобытия = Перечисления.ТипСобытияХодаОбработки.ПропускДействия;
	Событие.Действие = Действие;
	РегистрыСведений.ХодОбработки.ЗаписатьСобытие(Событие);

КонецПроцедуры

// Выполняется при прерывании действия.
//
// Параметры:
//  Действие - ОпределяемыйТип.Действия
//
Процедура ПриПрерыванииДействия(Действие) Экспорт

	ОбработкаДействия = РегистрыСведений.ДействияОбработкиОбъектов.ОбработкаДействия(Действие);

	Событие = РегистрыСведений.ХодОбработки.СтруктураСобытия();
	Событие.Обработка = ОбработкаДействия;
	Событие.ТипСобытия = Перечисления.ТипСобытияХодаОбработки.ПрерываниеДействия;
	Событие.Действие = Действие;
	РегистрыСведений.ХодОбработки.ЗаписатьСобытие(Событие);

КонецПроцедуры

// Выполняется при удалении результатов действия.
//
// Параметры:
//  Действие - ОпределяемыйТип.Действия
//
Процедура ПриУдаленииРезультатовДействия(Действие) Экспорт

	ОбработкаДействия = РегистрыСведений.ДействияОбработкиОбъектов.ОбработкаДействия(Действие);

	Событие = РегистрыСведений.ХодОбработки.СтруктураСобытия();
	Событие.Обработка = ОбработкаДействия;
	Событие.ТипСобытия = Перечисления.ТипСобытияХодаОбработки.УдалениеРезультатовДействия;
	Событие.Действие = Действие;
	РегистрыСведений.ХодОбработки.ЗаписатьСобытие(Событие);

КонецПроцедуры

#КонецОбласти