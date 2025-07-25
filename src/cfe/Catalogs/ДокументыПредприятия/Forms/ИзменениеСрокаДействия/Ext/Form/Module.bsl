﻿
&НаСервере
&ИзменениеИКонтроль("ПолучитьРеквизитыСрокаДействия")
Функция ЦППК_ПолучитьРеквизитыСрокаДействия(ДокументСсылка)

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДокументыПредприятия.ДатаНачалаДействия КАК ДатаНачалаДействия,
	|	ДокументыПредприятия.ДатаОкончанияДействия КАК ДатаОкончанияДействия,
	|	ДокументыПредприятия.Бессрочный КАК Бессрочный,
	|	ДокументыПредприятия.ПорядокПродления КАК ПорядокПродления 
#Вставка
	//++
	|	,ДокументыПредприятия.ДоИсполненияОбязательств КАК ДоИсполненияОбязательств
	//--
#КонецВставки
	|ИЗ
	|	Справочник.ДокументыПредприятия КАК ДокументыПредприятия
	|ГДЕ
	|	ДокументыПредприятия.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);

	Возврат Запрос.Выполнить().Выгрузить()[0];

КонецФункции

&НаКлиенте
&ИзменениеИКонтроль("СрокВведенНеКорректно")
Функция ЦППК_СрокВведенНеКорректно()

	ОчиститьСообщения();

	Отказ = Ложь;

	Если ЗначениеЗаполнено(ДатаНачалаДействия)
		И ЗначениеЗаполнено(ДатаОкончанияДействия)
		И ДатаНачалаДействия > ДатаОкончанияДействия Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		НСтр("ru = 'Дата окончания действия договора меньше даты начала действия.'"),,
		"ДатаОкончанияДействия",,
		Отказ);
		Возврат Не Отказ;
	КонецЕсли;

	Если ДокументЗарегистрирован Тогда
		ПроверитьЗначениеЗаполнено(
		ДатаНачалаДействия,
		Отказ,
		"ДатаНачалаДействия",
		НСтр("ru = 'Поле ""Дата начала"" не заполнено'"));
		
#Удаление 
		Если Не Бессрочный Тогда
#КонецУдаления
#Вставка
		Если Не Бессрочный  И не ЭтотОбъект["ДоИсполненияОбязательств"] Тогда
			//--
#КонецВставки
			ПроверитьЗначениеЗаполнено(
			ДатаОкончанияДействия,
			Отказ,
			"ДатаОкончанияДействия",
			НСтр("ru = 'Поле ""Дата окончания"" не заполнено'"));

			ПроверитьЗначениеЗаполнено(
			ПорядокПродления,
			Отказ,
			"ПорядокПродления",
			НСтр("ru = 'Поле ""Порядок продления"" не заполнено'"));
		КонецЕсли;
#Удаление 
	ИначеЕсли ЗначениеЗаполнено(ДатаНачалаДействия) И Не Бессрочный Тогда 
#КонецУдаления
#Вставка
	ИначеЕсли ЗначениеЗаполнено(ДатаНачалаДействия) И (Не Бессрочный  И не ЭтотОбъект["ДоИсполненияОбязательств"]) Тогда 
		//--
#КонецВставки

		ТекстВопроса = "";
		Если Не ЗначениеЗаполнено(ДатаОкончанияДействия) И Не ЗначениеЗаполнено(ПорядокПродления) Тогда 
			ТекстВопроса = НСтр("ru = '""Дата окончания"" и ""Порядок продления"" не заполнены. 
			|Продолжить?'");
		ИначеЕсли Не ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда 
			ТекстВопроса = НСтр("ru = '""Дата окончания"" не заполнена.
			|Продолжить?'");
		ИначеЕсли Не ЗначениеЗаполнено(ПорядокПродления) Тогда 
			ТекстВопроса = НСтр("ru = '""Порядок продления"" не заполнен.
			|Продолжить?'");
		КонецЕсли;

		Если ЗначениеЗаполнено(ТекстВопроса) Тогда 
			ОписаниеОповещения = Новый ОписаниеОповещения(
			"СрокВведенНеКорректноПродолжение",
			ЭтотОбъект);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);

			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;

	Возврат Не Отказ;

КонецФункции

&НаКлиенте
&ИзменениеИКонтроль("ИзменитьСрокДействияДокумента")
Процедура ЦППК_ИзменитьСрокДействияДокумента()

	Результат = Новый Структура;
	Результат.Вставить("Документ", Документ);
	Результат.Вставить("ДатаНачалаДействия", ДатаНачалаДействия);
	Результат.Вставить("ДатаОкончанияДействия", ДатаОкончанияДействия);
	Результат.Вставить("Бессрочный", Бессрочный);
	Результат.Вставить("ПорядокПродления", ПорядокПродления);
	Результат.Вставить("ДокументИсточникИзменения", ДокументИсточникИзменения);
	Результат.Вставить("Комментарий", Комментарий);
#Вставка
	//Zayc 18.04.2016 +
	Результат.Вставить("ДоИсполненияОбязательств", ЭтотОбъект["ДоИсполненияОбязательств"]);
	//Zayc 18.04.2016 -
#КонецВставки

	Если ИзменятьСрокДействия Тогда
		ИзменитьСрокДействияДокументаНаСервере(Результат);
		ОповеститьОбИзменении(Документ);
		Закрыть();
	Иначе
		Закрыть(Результат);
	КонецЕсли;

КонецПроцедуры

&НаСервере
&ИзменениеИКонтроль("ОбновитьСвойстваЭлементовФормы")
Процедура ЦППК_ОбновитьСвойстваЭлементовФормы()

#Удаление 
	Если Бессрочный Тогда
#КонецУдаления
#Вставка
	Если ЭтотОбъект["ДоИсполненияОбязательств"] или Бессрочный Тогда
#КонецВставки
		Элементы.ДатаОкончанияДействия.Доступность = Ложь;
		Элементы.ДатаОкончанияДействия.АвтоОтметкаНезаполненного = Ложь;
		Элементы.ПорядокПродления.Доступность = Ложь;
		Элементы.ПорядокПродления.АвтоОтметкаНезаполненного = Ложь;
	Иначе
		Элементы.ДатаОкончанияДействия.Доступность = Истина;
		Элементы.ДатаОкончанияДействия.АвтоОтметкаНезаполненного = ДокументЗарегистрирован;
		Элементы.ПорядокПродления.Доступность = Истина;
		Элементы.ПорядокПродления.АвтоОтметкаНезаполненного = ДокументЗарегистрирован;
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура ЦППК_ДоИсполненияОбязательствПриИзменении(Элемент)
	
	Модифицированность = Истина;
	Если ЭтотОбъект["ДоИсполненияОбязательств"] Тогда
		ДатаОкончанияДействия = '00010101';
		ПорядокПродления = Неопределено;
	КонецЕсли;
	
	ОбновитьСвойстваЭлементовФормы();

КонецПроцедуры

&НаСервере
&Перед("ПриСозданииНаСервере")
Процедура ЦППК_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Zayc 18.04.2016 + Добавлен новый реквизит  
	ЦППК_ПодключаемыеКоманды.ЦППК_ПриСозданииНаСервере(ЭтаФорма,Неопределено);
	Параметры.Свойство("ДоИсполненияОбязательств", ЭтотОбъект["ДоИсполненияОбязательств"]);
	// Zayc 18.04.2016 -
КонецПроцедуры

