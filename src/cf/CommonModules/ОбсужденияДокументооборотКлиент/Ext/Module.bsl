﻿
////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с обсуждениями.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Процедура ПриНачалеРаботыСистемы() Экспорт
	
	Если Не СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРаботыКлиентаПриЗапуске =
		СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	ИДОбсужденийДляСлужебныхОповещенийСтроками =
		ПараметрыРаботыКлиентаПриЗапуске.ИДОбсужденийДляСлужебныхОповещенийСтроками;
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаСлужебногоОповещения", ЭтотОбъект);
	Для Каждого ИДОбсужденияСтрокой Из ИДОбсужденийДляСлужебныхОповещенийСтроками Цикл
		ИДОбсуждения = Новый ИдентификаторОбсужденияСистемыВзаимодействия(ИДОбсужденияСтрокой);
		СистемаВзаимодействия.НачатьПодключениеОбработчикаНовыхСообщений(, ИДОбсуждения, ОписаниеОповещения);
	КонецЦикла;
	
	КаналыОбсужденийКлиент.ПриНачалеРаботыСистемы();
	
КонецПроцедуры

// Сообщение - служебное сообщение СВ
// 	* Данные - Структура - структура со свойствами
// 		* Событие - Строка - имя события
// 		* Параметры - Произвольный - произвольные параметры, переданные при отправке оповещения
// 
Процедура ОбработкаСлужебногоОповещения(Сообщение, ДополнительныеПараметры) Экспорт
	
	Данные = Сообщение.Данные;
	Если ТипЗнч(Данные) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Данные.Событие = "ДобавлениеВКанал" Тогда
		КаналыОбсужденийКлиент.ОбработкаСлужебногоОповещения(Данные.Событие, Данные.Параметры);
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает одноименное событие модуля приложения.
//
// Параметры:
//  См. описание параметров в синтаксис-помощнике.
//
Процедура ОбработкаПолученияФормыВыбораПользователейСистемыВзаимодействия(
			НазначениеВыбора, Форма, ИдентификаторОбсуждения, Параметры, ВыбраннаяФорма, СтандартнаяОбработка) Экспорт
	
	// Запрет на добавление в автообновляемые чаты.
#Если Не МобильныйКлиент Тогда
	Если НазначениеВыбора = НазначениеВыбораПользователейСистемыВзаимодействия.УчастникОбсуждения Тогда
		КлючОбсуждения = ОбсужденияДокументооборотКлиентПовтИсп.КлючОбсуждения(
			Строка(ИдентификаторОбсуждения));
		Если Не РедактированиеУчастниковОбсужденияРазрешено(КлючОбсуждения) Тогда
			ТекстВопроса = НСтр("ru = 'Это автоматически обновляемое обсуждение. Добавление участников вручную запрещено.'");
			Если СтрНайти(КлючОбсуждения, "Проекты") Тогда
				ТекстВопроса = НСтр("ru = 'Это автоматически обновляемое обсуждение.
					|Добавление участников вручную разрешено только руководителю проекта.'");
			ИначеЕсли СтрНайти(КлючОбсуждения, "СтруктураПредприятия") Тогда
				ТекстВопроса = НСтр("ru = 'Это автоматически обновляемое обсуждение.
					|Добавление участников вручную разрешено только руководителю подразделения.'");
			КонецЕсли;
			СтандартнаяОбработка = Ложь;
			СписокДоступныхВариантов = Новый СписокЗначений;
			СписокДоступныхВариантов.Добавить("Да", НСтр("ru = 'Понятно'"));
			Параметры.Вставить("Заголовок", "");
			Параметры.Вставить("СписокДоступныхВариантов", СписокДоступныхВариантов);
			Параметры.Вставить("ВариантОтветаПоУмолчанию", СписокДоступныхВариантов[0].Значение);
			Параметры.Вставить("ТекстВопроса", ТекстВопроса);
			ВыбраннаяФорма = "ОбщаяФорма.РасширенныйВопрос";
			Возврат;
		КонецЕсли;
	КонецЕсли;
#КонецЕсли

	// Адресная книга.
	СтандартнаяОбработка = Ложь;
	Параметры.Вставить("ЗаголовокСпискаАдреснойКниги", НСтр("ru = 'Все пользователи'"));
	Параметры.Вставить("ЗаголовокСпискаВыбранных", НСтр("ru = 'Выбранные участники'"));
	Параметры.Вставить("РежимРаботыФормы", 2);
	Параметры.Вставить("ОтображатьСотрудников", Ложь);
	Параметры.Вставить("ОтображатьПользователей", Истина);
	Параметры.Вставить("ВыбиратьПользователейСистемыВзаимодействия", Истина);
	Если Форма <> Неопределено И Форма <> Null Тогда
		Если Форма.ИмяФормы = "Справочник.Файлы.Форма.РедактированиеHtmlФайла"
			Или Форма.ИмяФормы = "Справочник.Файлы.Форма.РедактированиеТекстовогоФайла" Тогда
			Параметры.Вставить("ОбъектДляОтбораПоПравам", Форма.Файл);
		ИначеЕсли ЗначениеЗаполнено(Форма.Параметры.Ключ) Тогда
			Параметры.Вставить("ОбъектДляОтбораПоПравам", Форма.Параметры.Ключ);
		КонецЕсли;
	КонецЕсли;
	ВыбраннаяФорма = "Справочник.АдреснаяКнига.ФормаСписка";
	
КонецПроцедуры

// Обрабатывает одноименное событие модуля приложения.
//
// Параметры:
//  См. описание параметров в синтаксис-помощнике.
//
Процедура АвтоПодборПользователейСистемыВзаимодействия(
			Текст, ДанныеВыбора, НазначениеВыбора, Форма, ИдентификаторОбсуждения) Экспорт
	
	КонтекстСсылка = Неопределено;
	
	Если Форма <> Неопределено И Форма <> Null Тогда
		Если Форма.ИмяФормы = "Справочник.Файлы.Форма.РедактированиеHtmlФайла"
			Или Форма.ИмяФормы = "Справочник.Файлы.Форма.РедактированиеТекстовогоФайла" Тогда
			КонтекстСсылка = Форма.Файл;
		ИначеЕсли ЗначениеЗаполнено(Форма.Параметры.Ключ) Тогда
			КонтекстСсылка = Форма.Параметры.Ключ;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеОбсуждения = ДанныеОбсужденияДляАвтоподбора(
		Строка(ИдентификаторОбсуждения),
		КонтекстСсылка);
	
	Если ДанныеОбсуждения = Неопределено Тогда
		// Стандартное поведение.
		Возврат;
	КонецЕсли;
	
	Если НазначениеВыбора = НазначениеВыбораПользователейСистемыВзаимодействия.УчастникОбсуждения Тогда
		КлючОбсуждения = ДанныеОбсуждения.Ключ;
		Если Не РедактированиеУчастниковОбсужденияРазрешено(КлючОбсуждения) Тогда
			ДанныеВыбора.Очистить();
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеОбсуждения.ПользователиИБСПравамиНаКонтекст <> Неопределено Тогда
		ИдентификаторыПользователейИБ =
			ОбсужденияДокументооборотВызовСервера.ИдПользователейИБПоИдПользователейСВ(
				ДанныеВыбора.ВыгрузитьЗначения());
		ПустойИдентификаторСтрокой = Строка(УникальныйИдентификаторПустой());
		КолСтрок = ДанныеВыбора.Количество();
		Для Сч = 1 По КолСтрок Цикл
			Индекс = КолСтрок - Сч;
			ЭлементСписка = ДанныеВыбора[Индекс];
			Если Строка(ЭлементСписка.Значение) = ПустойИдентификаторСтрокой Тогда
				Продолжить;
			КонецЕсли;
			ИдПользователяИБ = ИдентификаторыПользователейИБ[ЭлементСписка.Значение];
			Если ДанныеОбсуждения.ПользователиИБСПравамиНаКонтекст[ИдПользователяИБ] = Неопределено Тогда
				ДанныеВыбора.Удалить(ЭлементСписка);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает данные, необходимые для автоподбора пользователей СВ.
//
// Параметры:
//  ИдентификаторОбсужденияСтрокой - идентификатор обсуждения, преобразованный в строку.
//  КонтекстСсылка - Ссылка, Неопределено - контекст обсуждения.
//
// Возвращаемое значение:
//  Строка - ключ обсуждения.
//
Функция ДанныеОбсужденияДляАвтоподбора(ИдентификаторОбсужденияСтрокой, КонтекстСсылка) Экспорт
	
	Если Не ЗначениеЗаполнено(ИдентификаторОбсужденияСтрокой)
		И Не ЗначениеЗаполнено(КонтекстСсылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИдентификаторОбсуждения = Неопределено;
	Если ЗначениеЗаполнено(ИдентификаторОбсужденияСтрокой) Тогда
		ИдентификаторОбсуждения = Новый ИдентификаторОбсужденияСистемыВзаимодействия(
			ИдентификаторОбсужденияСтрокой);
	КонецЕсли;
	
	Возврат ОбсужденияДокументооборотВызовСервера.ДанныеОбсужденияДляАвтоподбора(
		ИдентификаторОбсуждения, КонтекстСсылка);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РедактированиеУчастниковОбсужденияРазрешено(КлючОбсуждения)
	
	Если СтрНайти(КлючОбсуждения, "Auto") = 0
		Или СтрНайти(КлючОбсуждения, "Мероприятия") > 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если СтрНайти(КлючОбсуждения, "РабочиеГруппы") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ОбсужденияДокументооборотВызовСервера.РедактированиеУчастниковОбсужденияРазрешено(КлючОбсуждения);
		
КонецФункции

#КонецОбласти
