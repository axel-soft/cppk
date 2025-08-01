﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПротоколированиеРаботыСотрудников.ЗаписатьОткрытие(Объект.Ссылка);
	РаботаСПоследнимиОбъектами.ЗаписатьОбращениеКОбъекту(Объект.Ссылка);
	
	ИспользоватьУчетПоОрганизациям = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям");
	
	Если Объект.ДелаХраненияДокументов.Количество() > 0 Тогда 
		ЗаполнитьРеквизитыСтрок();
	КонецЕсли;
	
	УстановитьСостояниеДокумента();
	
	УстановитьВидимостьДоступность();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Оповестить("ОбновитьСписокПоследних");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") И ЭтоАдресВременногоХранилища(ВыбранноеЗначение) Тогда 
		ЗагрузитьДелаИзВременногоХранилища(ВыбранноеЗначение);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьРеквизитыСтрок();
	УстановитьСостояниеДокумента();
	УстановитьВидимостьДоступность();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не Объект.Проведен
		И ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение
		И (Не ПараметрыЗаписи.Свойство("ПоказанВопросОбУничтоженииДокументов")
			Или ПараметрыЗаписи.ПоказанВопросОбУничтоженииДокументов <> Истина) Тогда
			
		КоличествоДокументовКУничтожению = КоличествоДокументовКУничтожению();
		Если КоличествоДокументовКУничтожению > 0 Тогда
			Отказ = Истина;
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"ПередЗаписьюПродолжениеПослеВопросаОбУничтоженииДокументов", ЭтотОбъект, ПараметрыЗаписи);
			ТекстВопроса = СтрШаблон(
				НСтр("ru = 'Проведение приведет к уничтожению %1. Файлы %2 будут безвозвратно удалены. Продолжить?'"),
				ОбщегоНазначенияДокументооборотВызовСервера.СклоненияСтрокиПоЧислу(
					НСтр("ru = 'документ'"), КоличествоДокументовКУничтожению,,, "ПД=Родительный", "ЧГ=0"),
				?(КоличествоДокументовКУничтожению = 1, НСтр("ru = 'документа'"), НСтр("ru = 'документов'")));
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да);
			Возврат;
		Иначе
			ПараметрыЗаписи.Вставить("ПоказанВопросОбУничтоженииДокументов", Истина);
		КонецЕсли;
	Иначе
		ПараметрыЗаписи.Вставить("ПоказанВопросОбУничтоженииДокументов", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюПродолжениеПослеВопросаОбУничтоженииДокументов(Результат, ПараметрыЗаписи) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаписи.Вставить("ПоказанВопросОбУничтоженииДокументов", Истина);
	Если Записать(ПараметрыЗаписи) Тогда
		ПослеЗаписиКлиент(ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", Не ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПротоколированиеРаботыСотрудников.ЗаписатьСоздание(Объект.Ссылка, ПараметрыЗаписи.ЭтоНовыйОбъект);
	ПротоколированиеРаботыСотрудников.ЗаписатьИзменение(Объект.Ссылка);
	
	ЗаполнитьРеквизитыСтрок();
	УстановитьСостояниеДокумента();
	
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина Тогда
		РаботаСПоследнимиОбъектами.ЗаписатьОбращениеКОбъекту(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПослеЗаписиКлиент(ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ЗаполнитьРеквизитыСтрок();
	
КонецПроцедуры

&НаКлиенте
Процедура ДелоХраненияДокументовПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДелаХраненияДокументов.ТекущиеДанные;
	Строка = Новый Структура("ДелоХраненияДокументов, Индекс, ДатаНачала, ДатаОкончания, СрокХранения, УжеХранится");
	ЗаполнитьЗначенияСвойств(Строка, ТекущиеДанные);
	
	ЗаполнитьРеквизитыСтроки(Строка);
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, Строка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДелоХраненияДокументовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	АдресВременногоХранилища = ПоместитьДелаВоВременноеХранилище();
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", "ИзУничтоженияДел");
	ПараметрыФормы.Вставить("АдресВременногоХранилища", АдресВременногоХранилища);
	ПараметрыФормы.Вставить("СостояниеНаДату", ?(Объект.Ссылка.Пустая(), КонецДня(Объект.Дата), Объект.Дата));
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	ПараметрыФормы.Вставить("Подразделение", Объект.Подразделение);
	ПараметрыФормы.Вставить("ФормаДокумента", Объект.ФормаДокументов);
	ПараметрыФормы.Вставить("ГрифДоступа", Объект.ГрифДоступа);
	
	ОткрытьФорму("Справочник.ДелаХраненияДокументов.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДелоХраненияДокументовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораДелаХранения(Текст, Объект.Организация, 
			?(Объект.Ссылка.Пустая(), КонецДня(Объект.Дата), Объект.Дата),
			Объект.ФормаДокументов, Объект.ГрифДоступа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДелоХраненияДокументовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораДелаХранения(Текст, Объект.Организация, 
			?(Объект.Ссылка.Пустая(), КонецДня(Объект.Дата), Объект.Дата),
			Объект.ФормаДокументов, Объект.ГрифДоступа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, ДополнительныеДанные, СтандартнаяОбработка)
	
	СотрудникиКлиент.СотрудникОбработкаВыбора(Объект, "Ответственный", ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыДелаХраненияДокументов

&НаКлиенте
Процедура ДелаХраненияДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Не ТолькоПросмотр И Не Элементы.ДелаХраненияДокументов.ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ДелаХраненияДокументов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ДелоХраненияДокументов) Тогда
		ПоказатьЗначение(, ТекущиеДанные.ДелоХраненияДокументов);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Закрыть", Истина);
	ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если ИспользоватьУчетПоОрганизациям И Не ЗначениеЗаполнено(Объект.Организация) Тогда 
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			РедакцииКонфигурацииКлиентСервер.ОшибкаНеЗаполненоПолеОрганизация(),
			,,"Объект.Организация");
	    Возврат;
	КонецЕсли;	
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПродолжение", ЭтотОбъект);
	
	МассивДел = Новый Массив;
	Для Каждого Строка Из Объект.ДелаХраненияДокументов Цикл
		Если ЗначениеЗаполнено(Строка.ДелоХраненияДокументов) Тогда 
			МассивДел.Добавить(Строка.ДелоХраненияДокументов);
		КонецЕсли;	
	КонецЦикла;
	
	Если МассивДел.Количество() > 0 Тогда 
		ТекстВопроса = НСтр("ru = 'Перед заполнением табличная часть будет очищена. Продолжить?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса,
			РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	Иначе 	
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	АдресВременногоХранилища = ПоместитьДелаВоВременноеХранилище();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", "ИзУничтоженияДел");
	ПараметрыФормы.Вставить("АдресВременногоХранилища", АдресВременногоХранилища);
	ПараметрыФормы.Вставить("СостояниеНаДату", ?(Объект.Ссылка.Пустая(), КонецДня(Объект.Дата), Объект.Дата-1));
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	
	ОткрытьФорму("Справочник.ДелаХраненияДокументов.Форма.ФормаПодбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция СформироватьДанныеВыбораДелаХранения(Знач Текст, Знач Организация,
			Знач ДатаСреза, Знач ФормаДокументов, Знач ГрифДоступа)
	
	ДанныеВыбора = Новый СписокЗначений;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДелаХраненияДокументов.Ссылка,
	|	ДелаХраненияДокументов.Наименование,
	|	ДелаХраненияДокументов.НоменклатураДел,
	|	ДелаХраненияДокументов.НоменклатураДел.Индекс КАК Индекс,
	|	ДелаХраненияДокументов.НоменклатураДел.СрокХранения КАК СрокХранения,
	|	ДелаХраненияДокументов.ДатаОкончания
	|ИЗ
	|	Справочник.ДелаХраненияДокументов КАК ДелаХраненияДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДелХраненияДокументов.СрезПоследних(&НаДату, ) КАК СостоянияДел
	|		ПО (СостоянияДел.ДелоХраненияДокументов = ДелаХраненияДокументов.Ссылка)
	|ГДЕ
	|	ЕСТЬNULL(СостоянияДел.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияДелХраненияДокументов.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Перечисление.СостоянияДелХраненияДокументов.Уничтожено)
	|	И (ДелаХраненияДокументов.Наименование ПОДОБНО &Текст
	|			ИЛИ ДелаХраненияДокументов.НоменклатураДел.Индекс + "" "" + ДелаХраненияДокументов.Наименование ПОДОБНО &Текст)
	|	И ДелаХраненияДокументов.ДелоЗакрыто
	|	И ДелаХраненияДокументов.НоменклатураДел.КатегорияДела <> ЗНАЧЕНИЕ(Перечисление.КатегорииДел.Постоянное)
	|	И ДелаХраненияДокументов.ФормаДокументов = &ФормаДокументов";

	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
		Запрос.Текст = Запрос.Текст +"
			|	И ДелаХраненияДокументов.Организация = &Организация";
		Запрос.УстановитьПараметр("Организация", Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГрифДоступа) Тогда
		Запрос.Текст = Запрос.Текст +"
			|	И ДелаХраненияДокументов.НоменклатураДел.ГрифДоступа = &ГрифДоступа";
		Запрос.УстановитьПараметр("ГрифДоступа", ГрифДоступа);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НаДату", Новый Граница(ДатаСреза, ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	Запрос.УстановитьПараметр("Дата", ДатаСреза);
	Запрос.УстановитьПараметр("ФормаДокументов", ФормаДокументов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ТипЗнч(Выборка.СрокХранения) = Тип("Число")
			И Год(Выборка.ДатаОкончания) + Выборка.СрокХранения + 1 > Год(ДатаСреза) Тогда 
			Продолжить;
		КонецЕсли;
		ДанныеВыбора.Добавить(Выборка.Ссылка, Выборка.Индекс + " " + Выборка.Наименование);
	КонецЦикла;
		
	Возврат ДанныеВыбора;
	
КонецФункции

&НаСервере
Функция ПоместитьДелаВоВременноеХранилище()

	Возврат ПоместитьВоВременноеХранилище(Объект.ДелаХраненияДокументов.Выгрузить(,"ДелоХраненияДокументов"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗагрузитьДелаИзВременногоХранилища(АдресВременногоХранилища)

	Объект.ДелаХраненияДокументов.Загрузить(ПолучитьИзВременногоХранилища(АдресВременногоХранилища));
	ЗаполнитьРеквизитыСтрок();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыСтрок(Знач СтрокиДляЗаполнения = Неопределено, ТолькоПредставлениеСроков = Ложь)
	
	Если СтрокиДляЗаполнения = Неопределено Тогда
		СтрокиДляЗаполнения = Объект.ДелаХраненияДокументов;
	КонецЕсли;
	
	Дела = Новый Массив;
	Для Каждого Строка Из СтрокиДляЗаполнения Цикл
		Если ЗначениеЗаполнено(Строка.ДелоХраненияДокументов) Тогда 
			Дела.Добавить(Строка.ДелоХраненияДокументов);
		КонецЕсли;
	КонецЦикла;
	
	РеквизитыДел = Новый Соответствие;
	Если Не ТолькоПредставлениеСроков Тогда
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ДелаХраненияДокументов.Ссылка КАК Ссылка,
			|	ДелаХраненияДокументов.ДатаНачала КАК ДатаНачала,
			|	ДелаХраненияДокументов.ДатаОкончания КАК ДатаОкончания,
			|	НоменклатураДелСпр.Индекс КАК НоменклатураДелИндекс,
			|	НоменклатураДелСпр.СрокХранения КАК НоменклатураДелСрокХранения
			|ИЗ
			|	Справочник.ДелаХраненияДокументов КАК ДелаХраненияДокументов
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НоменклатураДел КАК НоменклатураДелСпр
			|		ПО ДелаХраненияДокументов.НоменклатураДел = НоменклатураДелСпр.Ссылка
			|ГДЕ
			|	ДелаХраненияДокументов.Ссылка В(&Дела)");
		Запрос.УстановитьПараметр("Дела", Дела);
		РеквизитыДел = Новый Соответствие;
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			РеквизитыДел[Выборка.Ссылка] = Новый Структура(
				"ДатаНачала, ДатаОкончания, НоменклатураДелИндекс, НоменклатураДелСрокХранения",
				Выборка.ДатаНачала, Выборка.ДатаОкончания,
				Выборка.НоменклатураДелИндекс, Выборка.НоменклатураДелСрокХранения);
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого СтрокаДела Из СтрокиДляЗаполнения Цикл
	
		Если Не ЗначениеЗаполнено(Строка.ДелоХраненияДокументов) Тогда 
			Продолжить;
		КонецЕсли;
		
		Если Не ТолькоПредставлениеСроков Тогда
			РеквизитыДела = РеквизитыДел[Строка.ДелоХраненияДокументов];
			СтрокаДела.Индекс = РеквизитыДела.НоменклатураДелИндекс;
			СтрокаДела.СрокХранения = РеквизитыДела.НоменклатураДелСрокХранения;
			СтрокаДела.ДатаНачала = РеквизитыДела.ДатаНачала;
			СтрокаДела.ДатаОкончания = РеквизитыДела.ДатаОкончания;
		КонецЕсли;
		
		СрокХранения = СтрокаДела.СрокХранения;
		Если ТипЗнч(СрокХранения) = Тип("Число") Тогда 
			СтрокаДела.СрокХранения = Строка(СрокХранения) + " "
				+ ДелопроизводствоКлиентСервер.ПодписьЛет(СрокХранения);
		КонецЕсли;
		
		СтрокаДела.УжеХранится = "";
		Если ЗначениеЗаполнено(СтрокаДела.ДелоХраненияДокументов)
				И ЗначениеЗаполнено(СтрокаДела.ДатаОкончания)
				И Объект.Дата >= СтрокаДела.ДатаОкончания Тогда
			УжеХранится = Год(Объект.Дата) - Год(СтрокаДела.ДатаОкончания) - 1;
			Если УжеХранится < 1 Тогда
				СтрокаДела.УжеХранится = НСтр("ru = 'Менее года'");
			Иначе	
				СтрокаДела.УжеХранится = Строка(УжеХранится) + " "
					+ ДелопроизводствоКлиентСервер.ПодписьЛет(УжеХранится);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыСтроки(СтрокаДела)
	
	ЗаполнитьРеквизитыСтрок(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтрокаДела));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДелаКУничтожению()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДелаХраненияДокументов.Ссылка КАК ДелоХраненияДокументов,
		|	ДелаХраненияДокументов.ДатаНачала КАК ДатаНачала,
		|	ДелаХраненияДокументов.ДатаОкончания КАК ДатаОкончания,
		|	НоменклатураДелСпр.Ссылка КАК НоменклатураДел,
		|	НоменклатураДелСпр.Индекс КАК Индекс,
		|	НоменклатураДелСпр.СрокХранения КАК СрокХранения
		|ИЗ
		|	Справочник.ДелаХраненияДокументов КАК ДелаХраненияДокументов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НоменклатураДел КАК НоменклатураДелСпр
		|		ПО ДелаХраненияДокументов.НоменклатураДел = НоменклатураДелСпр.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДелХраненияДокументов КАК СостоянияДел
		|		ПО ДелаХраненияДокументов.Ссылка = СостоянияДел.ДелоХраненияДокументов
		|			И СостоянияДел.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияДелХраненияДокументов.Уничтожено)
		|ГДЕ
		|	НЕ ДелаХраненияДокументов.ПометкаУдаления
		|	И ДелаХраненияДокументов.ДелоЗакрыто
		|	И ДелаХраненияДокументов.ФормаДокументов = &ФормаДокументов
		|	И СостоянияДел.ДелоХраненияДокументов ЕСТЬ NULL
		|	И НоменклатураДелСпр.КатегорияДела <> ЗНАЧЕНИЕ(Перечисление.КатегорииДел.Постоянное)
		|	И ТИПЗНАЧЕНИЯ(НоменклатураДелСпр.СрокХранения) = ТИП(ЧИСЛО)
		|	И ГОД(ДелаХраненияДокументов.ДатаОкончания) + (ВЫРАЗИТЬ(НоменклатураДелСпр.СрокХранения КАК ЧИСЛО(10, 0))) + 1 <= ГОД(&НаДату)";
	
	Запрос.УстановитьПараметр("ФормаДокументов", Объект.ФормаДокументов);
	Запрос.УстановитьПараметр("НаДату", Объект.Дата);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
		Запрос.Текст = Запрос.Текст + Символы.ПС + "	И ДелаХраненияДокументов.Организация = &Организация";
		Запрос.УстановитьПараметр("Организация", Объект.Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		Запрос.Текст = Запрос.Текст + Символы.ПС + "	И ДелаХраненияДокументов.Подразделение = &Подразделение";
		Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ГрифДоступа) Тогда
		Запрос.Текст = Запрос.Текст + Символы.ПС + " И НоменклатураДелСпр.ГрифДоступа = &ГрифДоступа";
		Запрос.УстановитьПараметр("ГрифДоступа", Объект.ГрифДоступа);
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + "
		|
		|УПОРЯДОЧИТЬ ПО
		|	НоменклатураДелСпр.Индекс,
		|	ДелаХраненияДокументов.Наименование";
	
	ТаблицаДел = Запрос.Выполнить().Выгрузить();
	
	// Исключение томов, в делах которых есть другие незакрытые тома, в т.ч. переходящие.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ОтноситсяКНоменклатуреДелТЧ.НоменклатураДел КАК НоменклатураДел
		|ИЗ
		|	Справочник.ДелаХраненияДокументов.ОтноситсяКНоменклатуреДел КАК ОтноситсяКНоменклатуреДелТЧ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДелаХраненияДокументов КАК ДелаХраненияДокументов
		|		ПО ОтноситсяКНоменклатуреДелТЧ.Ссылка = ДелаХраненияДокументов.Ссылка
		|ГДЕ
		|	ОтноситсяКНоменклатуреДелТЧ.НоменклатураДел В(&НоменклатураДел)
		|	И НЕ ДелаХраненияДокументов.ПометкаУдаления
		|	И НЕ ДелаХраненияДокументов.ДелоЗакрыто");
	Запрос.УстановитьПараметр("Дела", ТаблицаДел.ВыгрузитьКолонку("ДелоХраненияДокументов"));
	Запрос.УстановитьПараметр("НоменклатураДел", ОбщегоНазначенияКлиентСервер.СвернутьМассив(
		ТаблицаДел.ВыгрузитьКолонку("НоменклатураДел")));
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	Пока Выборка.Следующий() Цикл
		СтрокиКУдалению = ТаблицаДел.НайтиСтроки(Новый Структура("НоменклатураДел", Выборка.НоменклатураДел));
		Для Каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
			ТаблицаДел.Удалить(СтрокаКУдалению);
		КонецЦикла;
	КонецЦикла;
	
	// Заполнение ТЧ.
	Объект.ДелаХраненияДокументов.Загрузить(ТаблицаДел);
	ЗаполнитьРеквизитыСтрок(, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПродолжение(Результат, Параметры) Экспорт 

	Если Результат = КодВозвратаДиалога.Нет Тогда 
		Возврат;
	КонецЕсли;
	
	Объект.ДелаХраненияДокументов.Очистить();
	
	ЗаполнитьДелаКУничтожению();
	Модифицированность = Истина;
	
	Если Объект.ДелаХраненияДокументов.Количество() = 0 Тогда 
		ТекстСообщения = НСтр("ru = 'Дела (тома) с истекшим сроком хранения не найдены!'");
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	Если Объект.ПометкаУдаления Тогда
		СостояниеДокумента = 2;
	ИначеЕсли Объект.Проведен Тогда
		СостояниеДокумента = 1;
	Иначе
		СостояниеДокумента = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Элементы.ГруппаЗагруженИзАрхива.Видимость = Объект.ЗагруженИз1САрхива;
	Элементы.Ответственный.Видимость = Не Объект.ЗагруженИз1САрхива; // Не заполняется при получении из Архива.
	Если Объект.ЗагруженИз1САрхива Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция КоличествоДокументовКУничтожению()
	
	КоличествоДокументов = 0;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЕСТЬNULL(КОЛИЧЕСТВО(ДокументыПредприятия.Ссылка), 0) КАК КолДок
		|ИЗ
		|	Справочник.ДокументыПредприятия КАК ДокументыПредприятия
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДелаХраненияДокументов КАК ДелаХраненияДокументов
		|		ПО ДокументыПредприятия.Дело = ДелаХраненияДокументов.Ссылка
		|ГДЕ
		|	ДокументыПредприятия.Дело В(&Дела)
		|	И НЕ ДокументыПредприятия.ПометкаУдаления");
	
	Запрос.УстановитьПараметр("Дела",
		Объект.ДелаХраненияДокументов.Выгрузить().ВыгрузитьКолонку("ДелоХраненияДокументов"));
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		КоличествоДокументов = Выборка.КолДок;
	КонецЕсли;
	
	Возврат КоличествоДокументов;
	
КонецФункции

&НаКлиенте
Процедура ЗакрытьПослеПроведения()

	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Изменение:'"),
		ПолучитьНавигационнуюСсылку(Объект.Ссылка),
		Строка(Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
		
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиКлиент(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("Закрыть")
		И ПараметрыЗаписи.Свойство("ПоказанВопросОбУничтоженииДокументов")
		И ПараметрыЗаписи.ПоказанВопросОбУничтоженииДокументов = Истина Тогда
		ЗакрытьПослеПроведения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
