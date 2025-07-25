﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает отслеживаемые реквизиты для дополнительного свойства ПредыдущиеЗначенияРеквизитов.
//
// Возвращаемое значение:
//  Строка - Отслеживаемые реквизиты.
//
Функция ОтслеживаемыеРеквизиты() Экспорт
	
	ОтслеживаемыеРеквизиты = "Наименование";
	
	Возврат ОтслеживаемыеРеквизиты;
	
КонецФункции

// Заполняет поставляемые данные.
// 
Процедура ЗаполнитьПоставляемыеДанные() Экспорт
	
	ВидДействияЗадачОбъект = Зарегистрировать.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Зарегистрировать'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаЗарегистрировать;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Комментарий'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не регистрировалось'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Регистрация'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = "";
	ВидДействияЗадачОбъект.ШаблонЗаголовка = "%1";
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
	ВидДействияЗадачОбъект = Исполнить.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Исполнить'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаИсполнить;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Отчет об исполнении'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не исполнялось'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Исполнение'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = НСтр("ru = 'Все исполнители'");
	ВидДействияЗадачОбъект.ШаблонЗаголовка = "%1";
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
	ВидДействияЗадачОбъект = ОбеспечитьПодписание.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Обеспечить подписание'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаОбеспечитьПодписание;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Комментарий'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не обеспечивалось подписание'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Обеспечение подписания'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = НСтр("ru = 'Все подписывающие'");
	ВидДействияЗадачОбъект.ШаблонЗаголовка = НСтр("ru = 'Обеспечить подписание ""%1""'");
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
	ВидДействияЗадачОбъект = ОбработатьРезолюцию.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Обработать резолюцию'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаОбработатьРезолюцию;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Комментарий'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не обрабатывалось'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Обработка резолюции'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = "";
	ВидДействияЗадачОбъект.ШаблонЗаголовка = НСтр("ru = 'Обработать резолюцию ""%1""'");
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
	ВидДействияЗадачОбъект = ОбработатьРезультат.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Обработать результат'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаОбработатьРезультат;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Комментарий'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не обрабатывалось'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Обработка результата'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = НСтр("ru = 'Результаты'");
	ВидДействияЗадачОбъект.ШаблонЗаголовка = НСтр("ru = 'Обработать результат ""%1""'");
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
	ВидДействияЗадачОбъект = Ознакомиться.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Ознакомиться'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаОзнакомиться;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Комментарий'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не ознакомились'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Ознакомление'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = НСтр("ru = 'Все ознакомляемые'");
	ВидДействияЗадачОбъект.ШаблонЗаголовка = "%1";
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
	ВидДействияЗадачОбъект = ОзнакомитьсяСРезультатом.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Ознакомиться с результатом'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаОзнакомитьсяСРезультатом;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Комментарий'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не ознакомились'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Ознакомление с результатом'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = НСтр("ru = 'Результаты'");
	ВидДействияЗадачОбъект.ШаблонЗаголовка = НСтр("ru = 'Ознакомиться с результатом ""%1""'");
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
	ВидДействияЗадачОбъект = Подписать.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Подписать'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаПодписать;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Комментарий'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не подписывалось'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Подписание'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = НСтр("ru = 'Все подписывающие'");
	ВидДействияЗадачОбъект.ШаблонЗаголовка = "%1";
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
	ВидДействияЗадачОбъект = ПринятьПриглашение.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Принять приглашение'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаПригласить;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Комментарий'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не принималось'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Принятие приглашения'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = НСтр("ru = 'Все приглашенные'");
	ВидДействияЗадачОбъект.ШаблонЗаголовка = "%1";
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
	ВидДействияЗадачОбъект = Проверить.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Проверить'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаПроверитьИсполнение;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Результат проверки'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не проверялась'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Проверка'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = НСтр("ru = 'Результаты'");
	ВидДействияЗадачОбъект.ШаблонЗаголовка = НСтр("ru = 'Проверить ""%1""'");
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
	ВидДействияЗадачОбъект = Рассмотреть.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Рассмотреть'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаРассмотреть;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Резолюция'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не рассматривалось'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Рассмотрение'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = НСтр("ru = 'Все исполнители'");
	ВидДействияЗадачОбъект.ШаблонЗаголовка = "%1";
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
	ВидДействияЗадачОбъект = РассмотретьВопрос.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Рассмотреть вопрос'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаРешениеВопросовРассмотреть;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Комментарий'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не рассматривался'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Рассмотрение вопроса'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = "";
	ВидДействияЗадачОбъект.ШаблонЗаголовка = НСтр("ru = 'Рассмотреть вопрос ""%1""'");
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
	ВидДействияЗадачОбъект = РассмотретьЗапрос.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Рассмотреть запрос'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаРешениеВопросовПереносСрока;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Комментарий'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не рассматривался'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Рассмотрение запроса'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = "";
	ВидДействияЗадачОбъект.ШаблонЗаголовка = НСтр("ru = 'Рассмотреть запрос ""%1""'");
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
	ВидДействияЗадачОбъект = Согласовать.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Согласовать'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаСогласовать;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Комментарий'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не согласовывалось'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Согласование'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = НСтр("ru = 'Все согласующие'");
	ВидДействияЗадачОбъект.ШаблонЗаголовка = "%1";
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
	ВидДействияЗадачОбъект = Утвердить.ПолучитьОбъект();
	ВидДействияЗадачОбъект.Наименование = НСтр("ru = 'Утвердить'");
	ВидДействияЗадачОбъект.ОбластьПримененияШаблоновТекстов =
		Перечисления.ОбластиПримененияШаблоновТекстов.ЗадачаУтвердить;
	ВидДействияЗадачОбъект.РезультатТекстом = НСтр("ru = 'Комментарий'");
	ВидДействияЗадачОбъект.ТерминБудущегоДействия = НСтр("ru = 'Не утверждалось'");
	ВидДействияЗадачОбъект.ТерминДействия = НСтр("ru = 'Утверждение'");
	ВидДействияЗадачОбъект.ТерминСоисполнители = "";
	ВидДействияЗадачОбъект.ШаблонЗаголовка = "%1";
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(ВидДействияЗадачОбъект);
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
    МультиязычностьКлиентСервер.ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
    МультиязычностьКлиентСервер.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("СтрокаПоиска", ?(Параметры.СтрокаПоиска = Неопределено, "", Параметры.СтрокаПоиска) + "%");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыДействийЗадач.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыДействийЗадач КАК ВидыДействийЗадач
	|ГДЕ
	|	НЕ ВидыДействийЗадач.ПометкаУдаления
	|	И ВидыДействийЗадач.Наименование ПОДОБНО &СтрокаПоиска
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидыДействийЗадач.Наименование";
	
	ОбъектМетаданных = Метаданные.Справочники.ВидыДействийЗадач;
	Если Не МультиязычностьПовтИсп.КонфигурацияИспользуетТолькоОдинЯзык(ОбъектМетаданных.ТабличныеЧасти.Найти("Представления") = Неопределено) Тогда
		
		Если МультиязычностьСервер.ИспользуетсяПервыйДополнительныйЯзык() Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст,
				"ВидыДействийЗадач.Наименование ПОДОБНО &СтрокаПоиска",
				"(ВидыДействийЗадач.Наименование ПОДОБНО &СтрокаПоиска ИЛИ ВидыДействийЗадач.НаименованиеЯзык1 ПОДОБНО &СтрокаПоиска)");
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеВыбора = Новый СписокЗначений;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли