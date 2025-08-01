﻿// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Стандартная структура-контсруктор простого ответа без файла, для передачи на клиент.
// 
// Возвращаемое значение:
//  Структура - Новый легкий ответ:
//   * Успех - Булево
//   * СообщениеОбОшибке - Строка 
Функция НовыйЛегкийОтвет() Экспорт
	
	Данные = Новый Структура();
	Данные.Вставить("Успех", Истина);
	Данные.Вставить("СообщениеОбОшибке", "");
	
	Возврат Данные;
	
КонецФункции

// Показать результат отправки. Либо выдать переданный текст, либо показать какая ошибка. При отправке всех видов
// сообщений МЭДО
// 
// Параметры:
//  ТекстПриУспехе - Строка - Текст, что объект успешно отправлен
//  ДанныеОтвета - См. НовыйЛегкийОтвет
Процедура ПоказатьРезультатОтправки(ТекстПриУспехе, ДанныеОтвета) Экспорт
	
	ТекстОтвета = ТекстПриУспехе;
	Если ДанныеОтвета.Успех И ДанныеОтвета.СообщениеОбОшибке <> "" Тогда
		ТекстОтвета = ДанныеОтвета.СообщениеОбОшибке; // Формально ошибки нет, но информационное сообщение есть.
	ИначеЕсли Не ДанныеОтвета.Успех Тогда
		ТекстОтвета = СтрШаблон(НСтр("ru = 'При отправке возникли ошибки: %1'"), ДанныеОтвета.СообщениеОбОшибке);
	КонецЕсли;
	ПоказатьПредупреждение(, ТекстОтвета);
	
КонецПроцедуры

// Создать ответное уведомление на входящий документ. Сначала дает выбрать тип уведомления, потом открывает форму
// документа - "Уведомление МЭДО".
// 
// Параметры:
//  Документ - ОпределяемыйТип.ПредметМЭДО
//  ФормаВладелец - ФормаКлиентскогоПриложения - Форма-владелец, вызвавшая процедуру
Процедура СоздатьОтветноеУведомление(Документ, ФормаВладелец) Экспорт
	
	ТипУведомления = Неопределено;
	ДопПараметры = Новый Структура("Документ, ФормаВладелец", Документ, ФормаВладелец);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуУведомленияНужногоТипа", ЭтотОбъект, ДопПараметры);
	ПоказатьВводЗначения(
		ОписаниеОповещения,
		ТипУведомления,
		НСтр("ru = 'Будет создано ответное уведомление, укажите его тип'"),
		Тип("ПеречислениеСсылка.ТипыУведомленийМЭДО"));
	
КонецПроцедуры

#Область АвтосозданиеУведомленияОбОтказеВРегистрации

// Начинает цепочку процедур по созданию уведомления об отказе. В зависимости от настроек, задает вопрос
// документа - "Уведомление МЭДО".
// 
// Параметры:
//  Документ - ОпределяемыйТип.ПредметМЭДО
//  ФормаВладелец - ФормаКлиентскогоПриложения - Форма-владелец, вызвавшая процедуру
//  ЕстьДоступКМЭДО - Булево - У пользователя есть права на уведомления (Ответственный по 
Асинх Процедура НачатьСозданиеУведомленияОбОтказе(Документ, ФормаВладелец, ЕстьДоступКМЭДО) Экспорт
	
	Если ЕстьДоступКМЭДО Тогда
		Фраза = НСтр("ru = 'Регистрация документа отменена, создать уведомление МЭДО об отказе в регистрации?'");
		Если Ждать ВопросАсинх(Фраза, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
		
		ВыбратьПричинуОтказаДляУведомления(Документ, ФормаВладелец);
	Иначе
		// Доступа нет, но надо дать понять, что уведомление все-таки нужно:
		ПоказатьПредупреждение(
			, НСтр("ru = 'Регистрация документа отменена.
			|Обратитесь к ответственному за МЭДО для создания уведомления об отказе в регистрации.'"));
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Завершение ввода типа уведомления - открытие формы нового уведомления
// 
// Параметры:
//  ТипУведомления - ПеречислениеСсылка.ТипыУведомленийМЭДО
//  ДопПараметры - Структура:
//   * Документ - ОпределяемыйТип.ПредметМЭДО
//   * ФормаВладелец - ФормаКлиентскогоПриложения - Форма-владелец, вызвавшая процедуру
Процедура ОткрытьФормуУведомленияНужногоТипа(ТипУведомления, ДопПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(ТипУведомления) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ЭтоПрограммноеСоздание", Истина);
	ПараметрыФормы.Вставить("ТипУведомления", ТипУведомления);
	ПараметрыФормы.Вставить("Документ", ДопПараметры.Документ);
	ОткрытьФорму("Документ.УведомлениеМЭДО.Форма.ФормаДокумента", ПараметрыФормы, ДопПараметры.ФормаВладелец);
	
КонецПроцедуры

// Создать ответное уведомление об отказе в регистрации на входящий документ. Сначала дает выбрать причину отказа,
// потом открывает форму документа - "Уведомление МЭДО".
// 
// Параметры:
//  Документ - ОпределяемыйТип.ПредметМЭДО
//  ФормаВладелец - ФормаКлиентскогоПриложения - Форма-владелец, вызвавшая процедуру
Процедура ВыбратьПричинуОтказаДляУведомления(Документ, ФормаВладелец)
	
	ПричинаОтказа = Неопределено;
	Фраза = СтрШаблон(
		НСтр("ru = 'Укажите причину отказа в регистрации документа %1
		|Будет создано уведомление о причине отказа.'"),
		Документ);
	ДопПараметры = Новый Структура("Документ, ФормаВладелец", Документ, ФормаВладелец);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуУведомленияОбОтказе", ЭтотОбъект, ДопПараметры);
	ПоказатьВводЗначения(
		ОписаниеОповещения, ПричинаОтказа, Фраза, Тип("СправочникСсылка.ПричиныОтказаВРегистрацииМЭДО"));
	
КонецПроцедуры

// Завершение ввода типа уведомления - открытие формы нового уведомления
// 
// Параметры:
//  ПричинаОтказа - СправочникСсылка.ПричиныОтказаВРегистрацииМЭДО -
//  ДопПараметры - Структура:
//   * Документ - ОпределяемыйТип.ПредметМЭДО
//   * ФормаВладелец - ФормаКлиентскогоПриложения - Форма-владелец, вызвавшая процедуру
Процедура ОткрытьФормуУведомленияОбОтказе(ПричинаОтказа, ДопПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(ПричинаОтказа) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ЭтоПрограммноеСоздание", Истина);
	ПараметрыФормы.Вставить(
		"ТипУведомления", ПредопределенноеЗначение("Перечисление.ТипыУведомленийМЭДО.ОбОтказеВРегистрации"));
	ПараметрыФормы.Вставить("Документ", ДопПараметры.Документ);
	ОтказВРегистрации = Новый Структура();
	ОтказВРегистрации.Вставить("ПричинаОтказаСсылка", ПричинаОтказа);
	ПараметрыФормы.Вставить("ОтказВРегистрации", ОтказВРегистрации);
	ОткрытьФорму("Документ.УведомлениеМЭДО.Форма.ФормаДокумента", ПараметрыФормы, ДопПараметры.ФормаВладелец);
	
КонецПроцедуры

#КонецОбласти
