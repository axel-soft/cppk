﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОтвета = МЭДОСтруктурыДанных.НовыйЛегкийОтвет();
	
	// Проверка на уникальность по полю документ, должен быть только один документ "Данные документа МЭДО",
	// кроме ситуации повторной отправки (ПропуститьПроверкуУникальности):
	Если ЭтоНовый() И Не ДополнительныеСвойства.Свойство("ПропуститьПроверкуУникальности") Тогда
		ДанныеПоЭтомуЖеДокументу = Документы.ДанныеДокументаМЭДО.ДанныеДокументаМЭДО(
			Документ, "Ссылка", ДанныеОтвета);
		Если ЗначениеЗаполнено(ДанныеПоЭтомуЖеДокументу.Ссылка) Тогда
			ТекстОшибкиПодробно = СтрШаблон(
				НСтр("ru = 'Попытка второй раз создать ""Данные документа МЭДО"", уже есть другой объект: %1'"),
				ДанныеПоЭтомуЖеДокументу.Ссылка);
			МЭДО.ЗаписьВЖурналСобытий(
				Перечисления.УровниСобытийМЭДО.Ошибка,
				ДанныеПоЭтомуЖеДокументу.Ссылка,
				НСтр("ru = 'Ошибка при записи ""Данных документа МЭДО""'"),
				ТекстОшибкиПодробно,
				ДанныеОтвета);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		МЭДО.ПрисвоитьЗаполненное(Ответственный, МЭДОПереопределяемый.ТекущийОтветственный());
	КонецЕсли;
	
	// Пометка удаления должна быть такая же, как у родительского документа:
	//@skip-check bsl-legacy-check-string-literal
	ПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "ПометкаУдаления");
	
	Если Не ПометкаУдаления Тогда
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
	КонецЕсли;
	
	
	Если ЭтоНовый() Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	// Часть реквизитов можно достать сразу из родительского документа:
	Если МЭДОПереопределяемый.ЭтоИсходящийДокумент(Документ) Тогда
		
		// Для исходящего документа присвоим свой идентификатор из ссылки на документ:
		Если Не ЗначениеЗаполнено(ИдентификаторДокумента) Тогда
			ИдентификаторДокумента = НРег("" + Документ.УникальныйИдентификатор());
		КонецЕсли;
	
		РеквизитыДокумента = МЭДОПереопределяемый.ТребуемыеДанныеИсходящегоДокумента(
			Документ, "Организация, Контрагенты, ГрифДоступа, ДатаРегистрации");
		ГрифДоступа = РеквизитыДокумента.ГрифДоступа;
		Организация = РеквизитыДокумента.Организация;
		
		// Определяем версии для отправки, у всех контрагентов, в общем случае их может быть несколько.
		// Делим сообщение на пакеты по версиям, в итоге по МЭДО будет отправлено столько сообщений,
		// сколько разных версий МЭДО у контрагентов.
		Контрагенты = Новый Массив();
		Для Каждого СтруктураКонтрагент Из РеквизитыДокумента.Контрагенты Цикл
			Контрагенты.Добавить(СтруктураКонтрагент.Контрагент);
		КонецЦикла;
		ТаблицаНастроек = РегистрыСведений.НастройкиКонтрагентовМЭДО.НастройкиМассиваКонтрагентов(
			Контрагенты, ДанныеОтвета);
		Если Не ДанныеОтвета.Успех И Не ПометкаУдаления Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		ТаблицаНастроек.Свернуть("ВерсияФорматаМЭДО");
		Если ТаблицаНастроек.Количество() = 0 Тогда // Если не заданы, то версия всем по умолчанию - последняя.
			СтрокаТЗ = ТаблицаНастроек.Добавить();
			СтрокаТЗ.ВерсияФорматаМЭДО = Перечисления.ВерсииФорматаМЭДО.ПоследняяВерсия();
		КонецЕсли;
		// Идентификаторы в ТЧ Пакеты не должны меняться, если они там уже есть, поэтому
		// только добавление строк:
		Для Каждого СтрокаТЗВерсии Из ТаблицаНастроек Цикл
			ВерсияМЭДО = МЭДО.ЗаполненноеЗначение(
				СтрокаТЗВерсии.ВерсияФорматаМЭДО, Перечисления.ВерсииФорматаМЭДО.ПоследняяВерсия());
			
			СтрокаТЧ = Пакеты.Найти(ВерсияМЭДО, "ВерсияМЭДО");
			Если СтрокаТЧ = Неопределено Тогда
				СтрокаТЧ = Пакеты.Добавить();
				СтрокаТЧ.ВерсияМЭДО = ВерсияМЭДО;
				СтрокаТЧ.ИдентификаторСообщения = "" + Новый УникальныйИдентификатор();
			КонецЕсли;
		КонецЦикла;
		
		Направление = Перечисления.НаправленияСообщенийМЭДО.Исходящее;
		МЭДО.ПрисвоитьЗаполненное(ДатаРегистрации, НачалоДня(РеквизитыДокумента.ДатаРегистрации));
	
	ИначеЕсли МЭДОПереопределяемый.ЭтоВходящийДокумент(Документ) Тогда
		
		РеквизитыДокумента = МЭДОПереопределяемый.ТребуемыеДанныеВходящегоДокумента(
			Документ, "Организация, Контрагент, ГрифДоступа, ДатаРегистрации");
		ГрифДоступа = РеквизитыДокумента.ГрифДоступа;
		Организация = РеквизитыДокумента.Организация;
		
		// Во входящем документе один контрагент:
		// Определяем версию для отправки по контрагенту, если не проставлено, 
		// то останется по умолчанию:
		НастройкиКонтрагента = РегистрыСведений.НастройкиКонтрагентовМЭДО.НастройкиКонтрагента(
				РеквизитыДокумента.Контрагент, ДанныеОтвета);
		Если Не ДанныеОтвета.Успех И Не ПометкаУдаления Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		СтрокаТЧ = Неопределено;
		Если Пакеты.Количество() = 0 Тогда
			СтрокаТЧ = Пакеты.Добавить();
			СтрокаТЧ.ИдентификаторСообщения
				= "" + МЭДОПереопределяемый.СсылкаНовогоОбъекта(ЭтотОбъект).УникальныйИдентификатор();
		Иначе
			СтрокаТЧ = Пакеты[0];
		КонецЕсли;
		СтрокаТЧ.ВерсияМЭДО = МЭДО.ЗаполненноеЗначение(
			НастройкиКонтрагента.ВерсияФорматаМЭДО, Перечисления.ВерсииФорматаМЭДО.ПоследняяВерсия());
		
		Направление = Перечисления.НаправленияСообщенийМЭДО.Входящее;
		МЭДО.ПрисвоитьЗаполненное(ДатаРегистрации, НачалоДня(РеквизитыДокумента.ДатаРегистрации));
		
	КонецЕсли;
	
	Если ГотовКОтправке И Не ЗначениеЗаполнено(ДатаРегистрации) Тогда
		МЭДО.ЗаписьВЖурналСобытий(
			Перечисления.УровниСобытийМЭДО.Ошибка,
			Ссылка,
			НСтр("ru = 'Ошибка при записи ""Данных документа МЭДО""'"),
			НСтр("ru = 'Незарегистрированный документ не может быть отправлен!'"),
			ДанныеОтвета);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	
	Если Не ЗначениеЗаполнено(ГлавныйФайл) Тогда
		ГлавныйФайл = МЭДОПереопределяемый.ПопытатьсяОпределитьГлавныйФайл(Документ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.СостоянияДокументовМЭДО.Записывать = Истина;
	Счетчик = 0;
	
	Для Каждого СтрокаТЧ Из Пакеты Цикл
	
		Движение = Движения.СостоянияДокументовМЭДО.Добавить();
		ЗаполнитьЗначенияСвойств(
			Движение, ЭтотОбъект, "Направление, Документ, ИдентификаторДокумента");
		Движение.ИдентификаторСообщения = СтрокаТЧ.ИдентификаторСообщения;
		Счетчик = Счетчик + 1;
		Движение.Период = Дата + Счетчик;
		Движение.ПредметСообщения = Ссылка;
		
		Если Направление = Перечисления.НаправленияСообщенийМЭДО.Исходящее Тогда
			Движение.Состояние = Перечисления.СостоянияДокументовМЭДО.ИсходящийДокументЕщеНеОтправлен;
		ИначеЕсли Направление = Перечисления.НаправленияСообщенийМЭДО.Входящее Тогда
			Движение.Состояние = Перечисления.СостоянияДокументовМЭДО.ДокументПолучен;
		КонецЕсли;
		
	КонецЦикла;
	
	
	// Второе движение:
	Состояние2 = Неопределено;
	Если ЗначениеЗаполнено(ДатаРегистрации) Тогда
		Если Направление = Перечисления.НаправленияСообщенийМЭДО.Исходящее Тогда
			Если Отправлен Тогда
				Состояние2 = Перечисления.СостоянияДокументовМЭДО.ДокументОтправлен;
			ИначеЕсли ГотовКОтправке И ЗначениеЗаполнено(ДатаРегистрации) Тогда 
				Состояние2 = Перечисления.СостоянияДокументовМЭДО.ДокументЗарегистрированГотовКОтправке;
			КонецЕсли;
		ИначеЕсли Направление = Перечисления.НаправленияСообщенийМЭДО.Входящее Тогда
			Состояние2 = Перечисления.СостоянияДокументовМЭДО.ВходящийДокументЗарегистрирован;
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(Состояние2) Тогда
		Для Каждого СтрокаТЧ Из Пакеты Цикл
			Движение = Движения.СостоянияДокументовМЭДО.Добавить();
			Счетчик = Счетчик + 1;
			ДатаДвижения2 = ДатаРегистрации + Счетчик;
			Если ДатаДвижения2 < Дата + Счетчик Тогда
				ДатаДвижения2 = Дата + Счетчик; // Второе движение должно быть позднее первого.
			КонецЕсли;
			
			Движение.Период = ДатаДвижения2;
			Движение.ПредметСообщения = Ссылка;
			ЗаполнитьЗначенияСвойств(
				Движение, ЭтотОбъект, "Направление, Документ, ИдентификаторДокумента");
			Движение.ИдентификаторСообщения = СтрокаТЧ.ИдентификаторСообщения;
			Движение.Состояние = Состояние2;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе

#Область Инициализация
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецОбласти

#КонецЕсли
