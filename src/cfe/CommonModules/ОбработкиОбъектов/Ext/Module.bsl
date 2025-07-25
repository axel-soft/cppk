﻿
&ИзменениеИКонтроль("ПрерватьОбработкуОбъекта")
Процедура ЦППК_ПрерватьОбработкуОбъекта(ОбъектОбработки, ПричинаПрерывания)

	ОбработкаОбъекта = Справочники.ОбработкиОбъектов.ОбработкаОбъекта(ОбъектОбработки);
	Если Не ЗначениеЗаполнено(ОбработкаОбъекта) Тогда
		Возврат;
	КонецЕсли;

	ПараметрыОбъектаОбработки = ДействияСервер.ПараметрыОбъектаОбработки(ОбъектОбработки);	
	ТекущийПользователь = Пользователи.ТекущийПользователь();

#Удаление
	Если Не ДействияСервер.ЕстьПравоОстановкиОбработки(
		ПараметрыОбъектаОбработки, 
		ТекущийПользователь) Тогда

		Если ТипЗнч(ОбъектОбработки) = Тип("СправочникСсылка.ДокументыПредприятия") Тогда

			Если ПараметрыОбъектаОбработки.Свойство("РегистрационныйНомер")
				И ЗначениеЗаполнено(ПараметрыОбъектаОбработки.РегистрационныйНомер) Тогда
				ТекстИсключения = 
				НСтр("ru = 'Документ зарегистрирован, у Вас недостаточно прав для прерывания обработки.
				|Обратитесь к администратору.'");
			Иначе
				ТекстИсключения = 
				НСтр("ru = 'У Вас недостаточно прав для прерывания обработки.
				|Обратитесь к автору документа.'");
			КонецЕсли;

		ИначеЕсли ТипЗнч(ОбъектОбработки) = Тип("СправочникСсылка.Мероприятия") Тогда

			ТекстИсключения = 
			НСтр("ru = 'У Вас недостаточно прав для прерывания обработки.
			|Обратитесь к ответственному за мероприятие.'");

		Иначе

			ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Неизвестный объект обработки %1 (%2).'"),
			ОбъектОбработки,
			ТипЗнч(ОбъектОбработки));

		КонецЕсли;

		ВызватьИсключение ТекстИсключения;

	КонецЕсли;
#КонецУдаления

	ПрерватьОбработку(ОбработкаОбъекта, ПричинаПрерывания);

КонецПроцедуры

&ИзменениеИКонтроль("ПрерватьОбработку")
Процедура ЦППК_ПрерватьОбработку(Знач Обработка, ПричинаПрерывания, ПометкаУдаления)

	Если (ТипЗнч(Обработка) <> Тип("СправочникСсылка.ОбработкиОбъектов"))
		Или Не ЗначениеЗаполнено(Обработка) Тогда

		Возврат;
	КонецЕсли;

	УстановитьПривилегированныйРежим(Истина);

	НачатьТранзакцию();

	Попытка

		// Помещаем в историю обработку документа.  
		// при прерывании обработки не проверяем блокирвоку.

		ОбработкаОбъект = Обработка.ПолучитьОбъект();
		// Если Обработка завершена, то ее не прерываем, а просто помещаем в историю
		ОбработкаЗавершена = ОбработкаОбъект.Состояние = Перечисления.СостоянияОбработкиОбъектов.Завершена;
		ОбработкаОбъект.ПоместилВИсторию = Сотрудники.ОсновнойСотрудник();
		Если Не ОбработкаЗавершена Тогда
			ОбработкаОбъект.Состояние = Перечисления.СостоянияОбработкиОбъектов.Прервана;
			ОбработкаОбъект.Прервал = ОбработкаОбъект.ПоместилВИсторию;
			ОбработкаОбъект.ПричинаПрерывания = ПричинаПрерывания;
			ОбработкаОбъект.ДатаОкончания = ТекущаяДатаСеанса();
		КонецЕсли;				
		ОбработкаОбъект.ПомещенаВИсторию = Истина;
		Если ОбработкаОбъект.ДатаНачала = '00010101' Тогда
			ОбработкаОбъект.ДатаНачала = ОбработкаОбъект.ДатаОкончания;
		КонецЕсли;
		ОбработкаОбъект.ПометкаУдаления = ПометкаУдаления;

		ОбработкаОбъект.Записать();
#Удаление
		УстановитьПривилегированныйРежим(Ложь);
#КонецУдаления

		// Помещаем в историю ее действия.
		ДействияОбработки = РегистрыСведений.ДействияОбработкиОбъектов.ДействияОбработки(Обработка);
		Для Каждого ДействиеОбработки Из ДействияОбработки Цикл
			ДействияСервер.ПоместитьДействиеВИсторию(ДействиеОбработки, ПричинаПрерывания);
		КонецЦикла;

		Если Не ОбработкаЗавершена Тогда
			Событие = РегистрыСведений.ХодОбработки.СтруктураСобытия();
			Событие.Обработка = Обработка;
			Событие.Описание = ПричинаПрерывания;
			Событие.ТипСобытия = Перечисления.ТипСобытияХодаОбработки.ПрерываниеОбработки;
			РегистрыСведений.ХодОбработки.ЗаписатьСобытие(Событие);

			// Регистрируем бизнес-событие.
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(
			Обработка,
			Справочники.ВидыБизнесСобытий.ОстановкаОбработки);
		КонецЕсли;
		Документ = ОбработкаОбъект.Владелец;

		ВладелецОбъект = ОбработкаОбъект.Владелец.ПолучитьОбъект();
		ВладелецОбъект.ДополнительныеСвойства.Вставить("ИсключитьТекущийУзелИС", Ложь);
		ОбработкаЗапросовXDTOОбмен.ОбменСИнтегрированнымиСистемамиПередЗаписью(
		ВладелецОбъект,
		Ложь);

		ЗафиксироватьТранзакцию();

		Если ДелопроизводствоКлиентСервер.ЭтоДокументПредприятия(Документ) Тогда
			РаботаСФайламиВызовСервера.ОчиститьФайлыВЛокалКэше(Документ);
		КонецЕсли;	

	Исключение

		ОтменитьТранзакцию();
		ВызватьИсключение;

	КонецПопытки;

КонецПроцедуры
