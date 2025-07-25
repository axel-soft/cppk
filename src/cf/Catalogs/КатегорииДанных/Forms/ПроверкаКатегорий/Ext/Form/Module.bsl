﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаголовокСписокДокументыПредприятия = Элементы.ДокументыПредприятия.Заголовок;
	ЗаголовокСписокФайлы = Элементы.Файлы.Заголовок;
	ЗаголовокСписокМероприятия = Элементы.Мероприятия.Заголовок;
	ЗаголовокСписокПроекты = Элементы.Проекты.Заголовок;
	ЗаголовокСписокПроектныеЗадачи = Элементы.ПроектныеЗадачи.Заголовок;
	
	СписокДокументыПредприятия.Параметры.УстановитьЗначениеПараметра("ПустаяСсылкаНаПравило", Справочники.ПравилаАвтоматическойКатегоризацииДанных.ПустаяСсылка());
	СписокФайлы.Параметры.УстановитьЗначениеПараметра("ПустаяСсылкаНаПравило", Справочники.ПравилаАвтоматическойКатегоризацииДанных.ПустаяСсылка());
	СписокМероприятия.Параметры.УстановитьЗначениеПараметра("ПустаяСсылкаНаПравило", Справочники.ПравилаАвтоматическойКатегоризацииДанных.ПустаяСсылка());
	СписокПроекты.Параметры.УстановитьЗначениеПараметра("ПустаяСсылкаНаПравило", Справочники.ПравилаАвтоматическойКатегоризацииДанных.ПустаяСсылка());
	СписокПроектныеЗадачи.Параметры.УстановитьЗначениеПараметра("ПустаяСсылкаНаПравило", Справочники.ПравилаАвтоматическойКатегоризацииДанных.ПустаяСсылка());
	ТекущийСотруник = Сотрудники.ОсновнойСотрудник();
	
	ИспользоватьАвтоматическуюКатегоризациюДанных = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюКатегоризациюДанных");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокФайлы.Отбор,
		"КатегорииПроверены",
		Ложь,
		ВидСравненияКомпоновкиДанных.Равно);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокДокументыПредприятия.Отбор,
		"КатегорииПроверены",
		Ложь,
		ВидСравненияКомпоновкиДанных.Равно);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокФайлы.Отбор,
		"КатегорииПроверены",
		Ложь,
		ВидСравненияКомпоновкиДанных.Равно);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокМероприятия.Отбор,
		"КатегорииПроверены",
		Ложь,
		ВидСравненияКомпоновкиДанных.Равно);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокПроекты.Отбор,
		"КатегорииПроверены",
		Ложь,
		ВидСравненияКомпоновкиДанных.Равно);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокПроектныеЗадачи.Отбор,
		"КатегорииПроверены",
		Ложь,
		ВидСравненияКомпоновкиДанных.Равно);
		
	Если НЕ ИспользоватьАвтоматическуюКатегоризациюДанных Тогда	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокФайлы.Отбор,
			"АвтоКатегоризацияВыполнена",
			Ложь,
			ВидСравненияКомпоновкиДанных.Равно);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокДокументыПредприятия.Отбор,
			"АвтоКатегоризацияВыполнена",
			Ложь,
			ВидСравненияКомпоновкиДанных.Равно);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокМероприятия.Отбор,
			"АвтоКатегоризацияВыполнена",
			Ложь,
			ВидСравненияКомпоновкиДанных.Равно);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокПроекты.Отбор,
			"АвтоКатегоризацияВыполнена",
			Ложь,
			ВидСравненияКомпоновкиДанных.Равно);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокПроектныеЗадачи.Отбор,
			"АвтоКатегоризацияВыполнена",
			Ложь,
			ВидСравненияКомпоновкиДанных.Равно);			
	КонецЕсли;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	УстановитьКоличестваВЗаголовки();
	СписокРаскрытыхКатегорий = ХранилищеНастроекДанныхФорм.Загрузить("ФормаПроверкаКатегорий", "РаскрытыеКатегории");
	ТекущаяКатегорияВДереве = ХранилищеНастроекДанныхФорм.Загрузить("ФормаПроверкаКатегорий", "ТекущаяКатегория");
	
	ПостроитьДеревоКатегорий();
	
	ПоказыватьКолонкуРазмер = РаботаСФайламиВызовСервера.ПолучитьПоказыватьКолонкуРазмер();
	Если ПоказыватьКолонкуРазмер = Ложь Тогда
		Элементы.СписокФайлыРазмер.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ЭлектроннаяПодпись.ИспользоватьЭлектронныеПодписи() Тогда
		Элементы.СписокДокументыПредприятияПодписан.Видимость = Ложь;
		Элементы.СписокФайлыПодписан.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыИЗадачи") Тогда 
		Элементы.СписокДокументыПредприятияЗадачи.Видимость = Ложь;
	КонецЕсли;
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНоменклатуруДел") Тогда 
		Элементы.ИндексСостоянияДела.Видимость = Ложь;
	КонецЕсли;
	
	Делопроизводство.СписокДокументовУсловноеОформлениеПомеченныхНаУдаление(СписокДокументыПредприятия);
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		НастроитьЭлементыФормыДляМобильногоУстройства();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	СписокРаскрытыхКатегорий.Очистить();
	РаботаСКатегориямиДанныхКлиент.ПолучитьМассивРаскрытыхКатегорий(Элементы.ДеревоКатегорий, ДеревоКатегорий.ПолучитьЭлементы(), СписокРаскрытыхКатегорий);
	ПриЗакрытииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	ХранилищеНастроекДанныхФорм.Сохранить("ФормаПроверкаКатегорий", "РаскрытыеКатегории", СписокРаскрытыхКатегорий);
	ХранилищеНастроекДанныхФорм.Сохранить("ФормаПроверкаКатегорий", "ТекущаяКатегория", ТекущаяКатегорияВДереве);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РаботаСКатегориямиДанныхКлиент.УстановитьРазвернутостьЭлементовДерева(Элементы.ДеревоКатегорий, ДеревоКатегорий, СписокРаскрытыхКатегорий);
	РаботаСКатегориямиДанныхКлиентСервер.УстановитьТекущуюКатегориюВДеревеПоСсылке(Элементы.ДеревоКатегорий, ДеревоКатегорий, ТекущаяКатегорияВДереве);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ЗаполнитьСписокКатегорий();
	СписокКатегорийОбъектаПриАктивизацииСтроки(Элементы.СписокКатегорийОбъекта);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВыборСтраницыМКОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = "ДокументыПредприятия" Тогда
		Элементы.ОбъектыКатегоризации.ТекущаяСтраница = Элементы.ДокументыПредприятия;
		
	ИначеЕсли ВыбранноеЗначение = "Мероприятия" Тогда
		Элементы.ОбъектыКатегоризации.ТекущаяСтраница = Элементы.Мероприятия;
	
	ИначеЕсли ВыбранноеЗначение = "Файлы" Тогда
		Элементы.ОбъектыКатегоризации.ТекущаяСтраница = Элементы.Файлы;
		
	ИначеЕсли ВыбранноеЗначение = "Проекты" Тогда
		Элементы.ОбъектыКатегоризации.ТекущаяСтраница = Элементы.Проекты;
		
	ИначеЕсли ВыбранноеЗначение = "ПроектныеЗадачи" Тогда
		Элементы.ОбъектыКатегоризации.ТекущаяСтраница = Элементы.ПроектныеЗадачи;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыКатегоризацииПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущийЭлементИмя = "Список" + ТекущаяСтраница.Имя;
	ЗаполнитьСписокКатегорий();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументыПредприятия
	
&НаКлиенте
Процедура СписокДокументыПредприятияПриАктивизацииСтроки(Элемент)
	
	//ЗаполнитьСписокКатегорий(Элемент, Истина);
	ТекущийЭлементИмя = Элемент.Имя;	
	ПодключитьОбработчикОжидания("ЗаполнитьСписокКатегорий", 0.2, Истина);
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокФайлы

&НаКлиенте
Процедура СписокФайлыПриАктивизацииСтроки(Элемент)
	

	//ЗаполнитьСписокКатегорий(Элемент, Истина);
	ТекущийЭлементИмя = Элемент.Имя;	
	ПодключитьОбработчикОжидания("ЗаполнитьСписокКатегорий", 0.2, Истина);

	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоКатегорий

&НаКлиенте
Процедура ДеревоКатегорийПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяКатегорияВДереве = Элемент.ТекущиеДанные.Ссылка;
	
	СписокВыбранныхКатегорий.Очистить();
	Для Каждого ВыделеннаяСтрока Из Элемент.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элемент.ДанныеСтроки(ВыделеннаяСтрока);
		НоваяСтрока = СписокВыбранныхКатегорий.Добавить();
		НоваяСтрока.Значение = ДанныеСтроки.Ссылка;
		НоваяСтрока.ПолноеНаименование = ДанныеСтроки.ПолноеНаименование;
	КонецЦикла;
	
КонецПроцедуры
	
&НаКлиенте
Процедура ДеревоКатегорийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьКатегорию(Неопределено);
	
#Если МобильныйКлиент Тогда
	Элементы.ГруппаОтступ.Скрыть();
#КонецЕсли
	 
КонецПроцедуры
	
&НаКлиенте
Процедура СписокКатегорийОбъектаПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элемент.ТекущиеДанные = Неопределено Тогда
		ТекущаяКатегорияВДереве = Элемент.ТекущиеДанные.Ссылка;
		РаботаСКатегориямиДанныхКлиентСервер.УстановитьТекущуюКатегориюВДеревеПоСсылке(Элементы.ДеревоКатегорий, ДеревоКатегорий, ТекущаяКатегорияВДереве);
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокМероприятия

&НаКлиенте
Процедура СписокМероприятияПриАктивизацииСтроки(Элемент)
	
	ТекущийЭлементИмя = Элемент.Имя;	
	ПодключитьОбработчикОжидания("ЗаполнитьСписокКатегорий", 0.2, Истина);
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокПроекты

&НаКлиенте
Процедура СписокПроектыПриАктивизацииСтроки(Элемент)
	
	ТекущийЭлементИмя = Элемент.Имя;	
	ПодключитьОбработчикОжидания("ЗаполнитьСписокКатегорий", 0.2, Истина);

КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокПроектныеЗадачи

&НаКлиенте
Процедура СписокПроектныеЗадачиПриАктивизацииСтроки(Элемент)
	
	ТекущийЭлементИмя = Элемент.Имя;	
	ПодключитьОбработчикОжидания("ЗаполнитьСписокКатегорий", 0.2, Истина);

КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьКатегорию(Команда)
	
	СписокРаскрытыхКатегорий.Очистить();
	РаботаСКатегориямиДанныхКлиент.ПолучитьМассивРаскрытыхКатегорий(Элементы.ДеревоКатегорий, ДеревоКатегорий.ПолучитьЭлементы(), СписокРаскрытыхКатегорий);
	ТекущаяКатегорияПослеОбновления = ТекущаяКатегорияВДереве;
	Для Каждого ВыбраннаяКатегория Из СписокВыбранныхКатегорий Цикл
		Если СписокКатегорийОбъекта.Количество() > 0 Тогда
			ДобавитьКатегориюКлиент(ВыбраннаяКатегория.Значение, ВыбраннаяКатегория.ПолноеНаименование);
		КонецЕсли;
	КонецЦикла;
	
	Если СписокВыбранныхКатегорий.Количество() = 0
		И НЕ Элементы.ДеревоКатегорий.ТекущиеДанные = Неопределено Тогда
		ДобавитьКатегориюКлиент(Элементы.ДеревоКатегорий.ТекущиеДанные.Ссылка,Элементы.ДеревоКатегорий.ТекущиеДанные.ПолноеНаименование);			
	КонецЕсли;
	
	РаботаСКатегориямиДанныхКлиент.УстановитьРазвернутостьЭлементовДерева(Элементы.ДеревоКатегорий, ДеревоКатегорий, СписокРаскрытыхКатегорий);
	РаботаСКатегориямиДанныхКлиент.УстановитьПризнакВыбораЭлементовДерева(Элементы.ДеревоКатегорий, ДеревоКатегорий, СписокВыбранныхКатегорий);
	РаботаСКатегориямиДанныхКлиентСервер.УстановитьТекущуюКатегориюВДеревеПоСсылке(Элементы.ДеревоКатегорий, ДеревоКатегорий, ТекущаяКатегорияПослеОбновления);
	
КонецПроцедуры

&НаКлиенте
Процедура КатегорииПроверены(Команда)
	
	Если Элементы.ОбъектыКатегоризации.ТекущаяСтраница = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Элемент = Элементы["Список" + Элементы.ОбъектыКатегоризации.ТекущаяСтраница.Имя];
	
	Если Элемент.ВыделенныеСтроки.Количество() > 0 Тогда
		МассивЭлементовДляОбновления = Новый Массив;
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Отметить выбранные объекты (%1) как проверенные?'"),
			Строка(Элемент.ВыделенныеСтроки.Количество()));	
		ЗаголовокВопроса = НСтр("ru = 'Подтверждение проверки категорий'");
		
		СписокВариантовОтветов = Новый СписокЗначений;
		СписокВариантовОтветов.Добавить(Строка(КодВозвратаДиалога.Да));
		СписокВариантовОтветов.Добавить(Строка(КодВозвратаДиалога.Нет));

		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("МассивЭлементовДляОбновления", МассивЭлементовДляОбновления);
		ПараметрыОповещения.Вставить("Элемент", Элемент);
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"КатегорииПровереныПродолжение",
			ЭтотОбъект,
			ПараметрыОповещения);

		ДелопроизводствоКлиент.ПоказатьРасширеннуюФормуВопроса(ЭтаФорма,
			ЗаголовокВопроса,
			Текст,
			"ПроверкаКатегорий",
			"ПоказыватьПодтверждениеПроверкиКатегорий",
			СписокВариантовОтветов,,
			ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КатегорииПровереныПродолжение(Результат, Параметры)Экспорт 
	
	Если Результат = КодВозвратаДиалога.Нет ИЛИ Результат = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	МассивЭлементовДляОбновления = Параметры.МассивЭлементовДляОбновления;
	Элемент = Параметры.Элемент;
	Для Каждого ВыделеннаяСтрока Из Элемент.ВыделенныеСтроки Цикл
		МассивЭлементовДляОбновления.Добавить(ВыделеннаяСтрока);	
	КонецЦикла;
	Если МассивЭлементовДляОбновления.Количество() > 0 Тогда
		УстановитьПризнакПроверкиКатегорий(МассивЭлементовДляОбновления);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьКатегорииИзСпискаКатегорийОбъекта(Команда)
	
	Если Элементы.СписокКатегорийОбъекта.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СписокРаскрытыхКатегорий.Очистить();
	РаботаСКатегориямиДанныхКлиент.ПолучитьМассивРаскрытыхКатегорий(Элементы.ДеревоКатегорий, ДеревоКатегорий.ПолучитьЭлементы(), СписокРаскрытыхКатегорий);

	МассивСтрокДляУдаления = Новый Массив;
	МассивКатегорийДляУдаления = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.СписокКатегорийОбъекта.ВыделенныеСтроки Цикл
		МассивСтрокДляУдаления.Добавить(СписокКатегорийОбъекта.НайтиПоИдентификатору(ВыделеннаяСтрока));
		МассивКатегорийДляУдаления.Добавить(СписокКатегорийОбъекта.НайтиПоИдентификатору(ВыделеннаяСтрока).Ссылка);
	КонецЦикла;
	Для Каждого СтрокаДляУдаления Из МассивСтрокДляУдаления Цикл
		СписокКатегорийОбъекта.Удалить(СтрокаДляУдаления);
	КонецЦикла;
	Если МассивСтрокДляУдаления.Количество() > 0 Тогда
		УдалитьСписокКатегорийУОбъекта(МассивКатегорийДляУдаления, ТекущийОбъектВСписке);	
		РаботаСКатегориямиДанныхКлиент.УстановитьРазвернутостьЭлементовДерева(Элементы.ДеревоКатегорий, ДеревоКатегорий, СписокРаскрытыхКатегорий);
		РаботаСКатегориямиДанныхКлиент.УстановитьПризнакВыбораЭлементовДерева(Элементы.ДеревоКатегорий, ДеревоКатегорий, СписокВыбранныхКатегорий);
		РаботаСКатегориямиДанныхКлиентСервер.УстановитьТекущуюКатегориюВДеревеПоСсылке(Элементы.ДеревоКатегорий, ДеревоКатегорий, ТекущаяКатегорияВДереве);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПризнакАвтоКатегорий(Команда)
	
	Если Элементы.ОбъектыКатегоризации.ТекущаяСтраница = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элемент = Элементы["Список" + Элементы.ОбъектыКатегоризации.ТекущаяСтраница.Имя];
	
	Если Элемент.ВыделенныеСтроки.Количество() > 0 Тогда
		МассивЭлементовДляОбновления = Новый Массив;
		
		Режим = Новый СписокЗначений;
		Режим.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Да, отметить'"));
		Режим.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Нет, не отмечать'"));

		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Отметить выделенные элементы (%1 шт.) для повторной автоматической категоризации?'"),
			Строка(Элемент.ВыделенныеСтроки.Количество()));
			
		ЗаголовокВопроса = НСтр("ru = 'Повторная категоризация'");
		
		СписокВариантовОтветов = Новый СписокЗначений;
		СписокВариантовОтветов.Добавить(Строка(КодВозвратаДиалога.Да));
		СписокВариантовОтветов.Добавить(Строка(КодВозвратаДиалога.Нет));

		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("МассивЭлементовДляОбновления", МассивЭлементовДляОбновления);
		ПараметрыОповещения.Вставить("Элемент", Элемент);
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"СнятьПризнакАвтоКатегорийПродолжение",
			ЭтотОбъект,
			ПараметрыОповещения);

		ДелопроизводствоКлиент.ПоказатьРасширеннуюФормуВопроса(ЭтаФорма,
			ЗаголовокВопроса,
			Текст,
			"ПроверкаКатегорий",
			"ПоказыватьПодтверждениеПовторнойКатегоризации",
			СписокВариантовОтветов,,
			ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПризнакАвтоКатегорийПродолжение(Результат, Параметры)Экспорт 
	
	Если Результат = КодВозвратаДиалога.Нет ИЛИ Результат = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	МассивЭлементовДляОбновления = Параметры.МассивЭлементовДляОбновления;
	Элемент = Параметры.Элемент;
	Для Каждого ВыделеннаяСтрока Из Элемент.ВыделенныеСтроки Цикл
		МассивЭлементовДляОбновления.Добавить(ВыделеннаяСтрока);	
	КонецЦикла;	
	Если МассивЭлементовДляОбновления.Количество() > 0 Тогда
		СнятьПризнакАК(МассивЭлементовДляОбновления);
		ЗаполнитьСписокКатегорий();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьКоличестваВЗаголовки()
	
	Для Каждого Страница Из Элементы.ОбъектыКатегоризации.ПодчиненныеЭлементы Цикл
		Если ТипЗнч(Страница) = Тип("ГруппаФормы") Тогда
			Запрос = Новый Запрос;
			
			МетаданныеСправочник = Метаданные.Справочники.Найти(Страница.Имя);
			МетаданныеБизнесПроцесс = Метаданные.БизнесПроцессы.Найти(Страница.Имя);
			Если МетаданныеСправочник = Неопределено И МетаданныеБизнесПроцесс = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			МетаданныеВЗапрос = ?(МетаданныеСправочник = Неопределено, МетаданныеБизнесПроцесс, МетаданныеСправочник);
			Если НЕ ИспользоватьАвтоматическуюКатегоризациюДанных Тогда	
				ВнутреннееСоединение =  
					" И НЕ (ОбработкаПравилами.Автор В (ВЫБРАТЬ Ссылка
					|								ИЗ Справочник.ПравилаАвтоматическойКатегоризацииДанных КАК Правила)) ";	
			Иначе
				ВнутреннееСоединение = ""
			КонецЕсли;
				
			Если МетаданныеВЗапрос = Метаданные.Справочники.Файлы Тогда
				ВнутреннееСоединение = ВнутреннееСоединение + " ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПапкиФайлов КАК Папки
										|ПО ОбъектыКатегоризации.ВладелецФайла = Папки.Ссылка ";
							
			КонецЕсли;
			
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОбъектыКатегоризации.Код) КАК КодКоличество
				|ИЗ
				|	" + МетаданныеВЗапрос.ПолноеИмя()+ " КАК ОбъектыКатегоризации 
				|ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КатегорииОбъектов КАК ОбработкаПравилами
				|	ПО ОбработкаПравилами.ОбъектДанных = ОбъектыКатегоризации.Ссылка "
				+ ВнутреннееСоединение + 
				"ГДЕ
				|	ЛОЖЬ = ВЫБОР
				|		КОГДА ЛОЖЬ В
				|			(ВЫБРАТЬ ПЕРВЫЕ 1
				|				ЛОЖЬ
				|			ИЗ
				|				РегистрСведений.КатегорииОбъектов КАК Реестр
				|			ГДЕ
				|				Реестр.ОбъектДанных = ОбъектыКатегоризации.Ссылка
				|				И Реестр.НазначениеКатегорииПроверено = ЛОЖЬ
				|				И НЕ(Реестр.Автор = &ПустаяСсылкаНаПравило))
				|		ТОГДА ЛОЖЬ
				|		ИНАЧЕ ИСТИНА
				|		КОНЕЦ ";
				
			Запрос.УстановитьПараметр("ПустаяСсылкаНаПравило", Справочники.ПравилаАвтоматическойКатегоризацииДанных.ПустаяСсылка());
			Результат = Запрос.Выполнить();
			Если НЕ Результат = Неопределено
				И Результат.Выбрать().Количество() > 0 Тогда
				Выборка = Результат.Выбрать();
				Выборка.Следующий();
				Страница.Заголовок = ЭтаФорма["ЗаголовокСписок" + МетаданныеВЗапрос.Имя] + 
					" (" + 
					Выборка.КодКоличество + 
					")";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПостроитьДеревоКатегорий()
	
	Если Элементы.ОбъектыКатегоризации.ТекущаяСтраница <> Неопределено Тогда
		ТипОбъектов = Перечисления.ТипыОбъектов[Элементы.ОбъектыКатегоризации.ТекущаяСтраница.Имя];
	Иначе
		Возврат;
	КонецЕсли;
	
	Дерево = РеквизитФормыВЗначение("ДеревоКатегорий");
	Дерево = РаботаСКатегориямиДанных.ПостроитьДеревоКатегорий(Дерево, , Истина, ТипОбъектов, , Ложь);	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоКатегорий");
	ТекущаяСтраница = Элементы.ОбъектыКатегоризации.ТекущаяСтраница.Имя;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокКатегорий()
	
	СписокРаскрытыхКатегорий.Очистить();
	РаботаСКатегориямиДанныхКлиент.ПолучитьМассивРаскрытыхКатегорий(Элементы.ДеревоКатегорий, ДеревоКатегорий.ПолучитьЭлементы(), СписокРаскрытыхКатегорий);
	Элементы.ГруппаКатегории.Доступность = Истина;
	Элемент = Элементы[ТекущийЭлементИмя];
	Если Элемент.ТекущиеДанные = Неопределено
		ИЛИ Элемент.ТекущиеДанные.Ссылка = Неопределено 
		ИЛИ Элемент.ТекущиеДанные.Ссылка.Пустая() 
		ИЛИ Элемент.ВыделенныеСтроки.Количество() > 1 Тогда
		СписокКатегорийОбъекта.Очистить();
		ТекущийОбъектВСписке = Неопределено;
		УстановитьЗаголовокСпискаКатегорий(ТекущийОбъектВСписке);
		Элементы.ГруппаКатегории.Доступность = Ложь;
		Возврат;
	КонецЕсли;
	
	ТекущийОбъектВСписке = Элемент.ТекущиеДанные.Ссылка;	
	МассивКатегорийОбъекта = ПолучитьКатегорииОбъекта(ТекущийОбъектВСписке);
	СписокКатегорийОбъекта.Очистить();
	Для Каждого Категория Из МассивКатегорийОбъекта Цикл
		Если Категория.Персональная = Истина
			ИЛИ НЕ ЗначениеЗаполнено(Категория.Автор) Тогда
			Продолжить;
		КонецЕсли;
		Строка = СписокКатегорийОбъекта.Добавить();
		Строка.ПолноеНаименование = Категория.ПолноеНаименование;
		Строка.Ссылка = Категория.Ссылка;
		Строка.АвторКатегоризации = Категория.Автор;
	КонецЦикла;
	
#Если МобильныйКлиент Тогда
	ВыборСтраницыМК = Элементы.ОбъектыКатегоризации.ТекущаяСтраница.Имя;
#КонецЕсли
	
	РаботаСКатегориямиДанныхКлиент.УстановитьРазвернутостьЭлементовДерева(Элементы.ДеревоКатегорий, ДеревоКатегорий, СписокРаскрытыхКатегорий);
	РаботаСКатегориямиДанныхКлиент.УстановитьПризнакВыбораЭлементовДерева(Элементы.ДеревоКатегорий, ДеревоКатегорий, СписокВыбранныхКатегорий);
	
	УстановитьЗаголовокСпискаКатегорий(ТекущийОбъектВСписке);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокСпискаКатегорий(ТекущийОбъектВСписке)
	
	Если ТекущийОбъектВСписке <> Неопределено Тогда
		Если ТипЗнч(ТекущийОбъектВСписке) = Тип("СправочникСсылка.ДокументыПредприятия") Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Список категорий документа ""%1"":'"),
				Строка(ТекущийОбъектВСписке));
		ИначеЕсли ТипЗнч(ТекущийОбъектВСписке) = Тип("СправочникСсылка.Файлы") Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Список категорий файла ""%1"":'"),
				Строка(ТекущийОбъектВСписке));
		ИначеЕсли ТипЗнч(ТекущийОбъектВСписке) = Тип("СправочникСсылка.Мероприятия") Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Список категорий мероприятия ""%1"":'"),
				Строка(ТекущийОбъектВСписке));
		ИначеЕсли ТипЗнч(ТекущийОбъектВСписке) = Тип("СправочникСсылка.Проекты") Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Список категорий проекта ""%1"":'"),
				Строка(ТекущийОбъектВСписке));
		ИначеЕсли ТипЗнч(ТекущийОбъектВСписке) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Список категорий проектной задачи ""%1"":'"),
				Строка(ТекущийОбъектВСписке));				
		КонецЕсли;
	Иначе
		Текст = НСтр("ru = 'Список категорий выделенного объекта:'");
	КонецЕсли;
	ЗаголовокСпискаКатегорийОбъекта = Текст;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКатегорииОбъекта(ОбъектСсылка)
	
	Если Элементы.ОбъектыКатегоризации.ТекущаяСтраница = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	КатегорииОбъекта = Новый Массив;

	Если НЕ ЗначениеЗаполнено(ОбъектСсылка) Тогда
		Возврат КатегорииОбъекта;	
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.КатегорииОбъектов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОбъектДанных.Установить(ОбъектСсылка);
	НаборЗаписей.Прочитать();
	Для Каждого Запись Из НаборЗаписей Цикл 
		Если ДокументооборотПраваДоступа.ПраваПользователяПоОбъекту(Запись.КатегорияДанных).Чтение Тогда
			ДанныеОКатегории = Новый Структура("ПолноеНаименование, Ссылка, Персональная, Автор", 
				РаботаСКатегориямиДанных.ПолучитьПолныйПутьКатегорииДанных(Запись.КатегорияДанных),
				Запись.КатегорияДанных,
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.КатегорияДанных, "Персональная"),
				Запись.Автор);
			КатегорииОбъекта.Добавить(ДанныеОКатегории);
		КонецЕсли;
	КонецЦикла;
	
	Если ТекущаяСтраница <> Элементы.ОбъектыКатегоризации.ТекущаяСтраница.Имя Тогда
		ПостроитьДеревоКатегорий();
		ТекущаяСтраница = Элементы.ОбъектыКатегоризации.ТекущаяСтраница.Имя;
	КонецЕсли;
	
	Возврат КатегорииОбъекта;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьКатегориюКлиент(Категория, ПолноеНаименование)
	
	Отбор = Новый Структура();
	Отбор.Вставить("Ссылка", Категория);
	Строки = СписокКатегорийОбъекта.НайтиСтроки(Отбор);
	Если Строки.Количество() = 0 Тогда
		//добавление категории на форму
		НоваяСтрока = СписокКатегорийОбъекта.Добавить();
		НоваяСтрока.Ссылка = Категория;
		НоваяСтрока.ПолноеНаименование = ПолноеНаименование;
		НоваяСтрока.АвторКатегоризации = ТекущийСотруник;
		//добавление категории в регистр сведений
		НазначитьКатегориюОбъекту(Категория, ТекущийОбъектВСписке);
	КонецЕсли;
			
КонецПроцедуры

&НаСервере
Процедура НазначитьКатегориюОбъекту(Категория, Объект)
	
	РаботаСКатегориямиДанных.УстановитьКатегориюУОбъекта(Пользователи.ТекущийПользователь(), Категория, Объект);
	ПостроитьДеревоКатегорий();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакПроверкиКатегорий(МассивЭлементовДляОбновления)
	
	УстановитьПривилегированныйРежим(Истина);
	Для Каждого ОбъектСсылка Из МассивЭлементовДляОбновления Цикл 
		НаборЗаписей = РегистрыСведений.КатегорииОбъектов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ОбъектДанных.Установить(ОбъектСсылка);
		НаборЗаписей.Прочитать();
		Для Каждого Запись Из НаборЗаписей Цикл
			Если НЕ Запись.Автор.Пустая() Тогда
				Запись.НазначениеКатегорииПроверено = Истина;
			КонецЕсли;
		КонецЦикла;
		НаборЗаписей.Записать();
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Для Каждого ОбъектСсылка Из МассивЭлементовДляОбновления Цикл
		
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	КатегорииОбъектов.ОбъектДанных,
			|	КатегорииОбъектов.КатегорияДанных
			|ИЗ
			|	РегистрСведений.КатегорииОбъектов КАК КатегорииОбъектов
			|ГДЕ
			|	КатегорииОбъектов.ОбъектДанных = &ОбъектДанных";

		Запрос.УстановитьПараметр("ОбъектДанных", ОбъектСсылка);
		Результат = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			ЗаписьОКатегории = РегистрыСведений.КатегорииОбъектов.СоздатьМенеджерЗаписи();
			ЗаписьОКатегории.ОбъектДанных = ВыборкаДетальныеЗаписи.ОбъектДанных;
			ЗаписьОКатегории.КатегорияДанных = ВыборкаДетальныеЗаписи.КатегорияДанных;
			ЗаписьОКатегории.Прочитать();
			Если ЗаписьОКатегории.Выбран() Тогда
				ЗаписьОКатегории.НазначениеКатегорииПроверено = Истина;
				ЗаписьОКатегории.Записать();
			КонецЕсли;
		
		КонецЦикла;
	КонецЦикла;
		
	УстановитьКоличестваВЗаголовки();
	
КонецПроцедуры

&НаСервере
Процедура СнятьПризнакАК(МассивЭлементовДляОбновления)
	
	Для Каждого ОбъектСсылка Из МассивЭлементовДляОбновления Цикл 
		РаботаСКатегориямиДанных.СнятьПризнакОбработкиОбъектаПравилами(ОбъектСсылка);  
	КонецЦикла;
	УстановитьКоличестваВЗаголовки();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСписокКатегорийУОбъекта(СписокКатегорий, Объект)
	
	Для Каждого Категория Из СписокКатегорий Цикл
		РаботаСКатегориямиДанных.УдалитьКатегориюУОбъекта(Категория, Объект);
	КонецЦикла;
	ПостроитьДеревоКатегорий();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыДляМобильногоУстройства()
	
	Элементы.КатегорииПроверены.Отображение = ОтображениеКнопки.Картинка;
	
	Элементы.ВыборСтраницыМК.Видимость = Истина;
	Элементы.ОбъектыКатегоризации.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	Элементы.ГруппаКатегории.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	
	Элементы.ГруппаКнопка.Видимость = Ложь;
	Элементы.СписокКатегорийОбъекта.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Верх;
	
	Элементы.ГруппаОтступ.Заголовок = "Добавить категорию";
	Элементы.ГруппаОтступ.ОтображатьЗаголовок = Истина;
	Элементы.ГруппаОтступ.Поведение = ПоведениеОбычнойГруппы.Всплывающая;

	Элементы.УдалитьКатегорииИзСпискаВыбранных.Заголовок = "Удалить категорию";
	Элементы.УдалитьКатегорииИзСпискаВыбранных.Отображение = ОтображениеКнопки.Текст;
	Элементы.Переместить(Элементы.УдалитьКатегорииИзСпискаВыбранных, Элементы.СписокКатегорийОбъекта.КонтекстноеМеню,Элементы.СписокКатегорийОбъекта.КонтекстноеМеню);
	
КонецПроцедуры

#КонецОбласти
