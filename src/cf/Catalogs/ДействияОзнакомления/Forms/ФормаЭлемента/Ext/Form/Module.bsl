﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РежимДиалога = Параметры.РежимДиалога;
	
	ДействияСобытия.ЗаполнитьДанныеДействия(ЭтотОбъект, ИзменениеДействияРазрешено());
	
	ДействияСервер.УстановитьДоступностьИзмененияУчастников(ЭтотОбъект, Разрешения);
	
	ОбновитьДеревоУчастниковПоОбъекту();
	
	ДействияСервер.УстановитьВидимостьУсловийУчастников(ЭтотОбъект);
	ДействияСервер.ЗаполнитьСостоянияИРезультатыВФормеДействия(ЭтотОбъект);
	
	ЗаполнитьСостоянияОзнакомления();
	
	ДействияКлиентСервер.ЗапомнитьУчастниковПриОткрытииКарточки(ЭтотОбъект);
	
	// Завершенное действие можно направить новым участникам.
	ДействияСервер.УстановитьВидимостьНаправленияНовымУчастникам(ЭтотОбъект);  
	
	Элементы.ОжидатьЗавершения.Доступность = Не ЗначениеЗаполнено(Объект.НастройкаДействия);
	Элементы.ПодписыватьУЭП.Видимость = 
		ПолучитьФункциональнуюОпцию("ИспользоватьОзнакомлениеСУЭП") 
		И ТипЗнч(Объект.Предмет) = Тип("СправочникСсылка.ДокументыПредприятия"); 
		
	Элементы.ПодписыватьУЭП.Доступность = Не ЗначениеЗаполнено(Объект.НастройкаДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьПредставлениеСроков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.Ссылка.Пустая() Или Модифицированность Тогда 
		ПараметрыЗаписи.Вставить("ТребуетсяОбновление", Истина);
	КонецЕсли;
		
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", Объект.Ссылка.Пустая());
	ОбновитьОбъектПоДеревуУчастников(Отказ);
	
	Если ИсполнениеДействияСНовымиУчастниками
		И Не ДействияКлиентСервер.УчастникиДействияИзмененыВКарточке(ЭтотОбъект) Тогда
		
		ПоказатьПредупреждение(,
			НСтр("ru = 'Новые участники не добавлены. 
				|Для запуска нового ознакомления добавьте участников.'"));
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	ДействияКлиент.ОтложенноеНачалоВыполненияПередЗаписью(ЭтотОбъект);
	
	Если ПараметрыЗаписи.Свойство("НеПроверятьУчастников") И ПараметрыЗаписи.НеПроверятьУчастников Тогда
		Возврат;
	КонецЕсли;
	ПроверитьУчастников(Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ИсполнениеДействияСНовымиУчастниками Тогда
		ДействияСервер.УстановитьПризнакЗаписиИсполненияДействияСНовымиУчастниками(ТекущийОбъект);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкаОбработки) Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("НастройкаОбработки", НастройкаОбработки);
	КонецЕсли;
	 
	Если ДействияСервер.ПризнакЗаписиИсполненияДействияСНовымиУчастниками(ТекущийОбъект) Тогда

		ТекущийОбъект.ДополнительныеСвойства.Вставить("РазрешитьЗаписьОбъектаИзДругойСистемы", Истина);
			
	КонецЕсли;
	 
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ДействияСобытия.ДействияПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ДействияКлиент.ДействияПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);
	
	ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъекта(Объект.Ссылка);
	
	Если ПараметрыЗаписи.Свойство("Закрыть") Тогда
		Закрыть(КодВозвратаДиалога.ОК);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИсполнениеДействияСНовымиУчастниками =
		ДействияСервер.ДействиеИсполняетсяСНовымиУчастниками(ТекущийОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АвторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТипОбъекта = ОбщегоНазначенияДокументооборотКлиентСервер.ТипОбъекта(Объект.Предмет);
	НастройкиДействийКлиент.НастройкиДействияАвторНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка, ТипОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	НастройкиДействийКлиент.НастройкиДействияАвторОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
	СотрудникиКлиент.СотрудникОбработкаВыбора(Объект, "Автор", ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ТипОбъекта = ОбщегоНазначенияДокументооборотКлиентСервер.ТипОбъекта(Объект.Предмет);
	НастройкиДействийКлиент.НастройкиДействияАвторАвтоПодбор(
		ЭтотОбъект, Текст, ДанныеВыбора, СтандартнаяОбработка, ТипОбъекта);
		
КонецПроцедуры

&НаКлиенте
Процедура АвторОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ТипОбъекта = ОбщегоНазначенияДокументооборотКлиентСервер.ТипОбъекта(Объект.Предмет);
	НастройкиДействийКлиент.НастройкиДействияАвторОкончаниеВводаТекста(
		ЭтотОбъект, Текст, ДанныеВыбора, СтандартнаяОбработка, ТипОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеОтложенногоНачалаВыполненияНажатие(Элемент, СтандартнаяОбработка)
	
	ДействияКлиент.ОписаниеОтложенногоНачалаВыполненияНажатие(ЭтаФорма, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУчастники

&НаКлиенте
Процедура УчастникиПриИзменении(Элемент)
	
	ОбновитьПредставленияВДеревеУчастников(Участники);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Участники.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	Если Поле = Элементы.ЕстьОсобоеНаименованиеОписание Тогда
		
		Если ТекущиеДанные = Неопределено Или ТекущиеДанные.ЭтоЭтап 
			Или ТекущиеДанные.Функция = ПредопределенноеЗначение("Перечисление.ФункцииУчастниковПодписания.ОбрабатывающийРезультат") Тогда
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Описание", ТекущиеДанные.Описание);
		ПараметрыФормы.Вставить("ТолькоОписание", Истина);
		ПараметрыФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр
			Или Разрешения[0].Разрешение = ПредопределенноеЗначение("Перечисление.ВариантыДоступностиИзмененияДействий.Запрещено")
			Или (МожноТолькоДобавлятьУчастников И ТекущиеДанные.Недоступно));
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ЗавершитьНастройкуОсобогоОписания", ЭтотОбъект, ТекущиеДанные);
			
		ОткрытьФорму("ОбщаяФорма.РедактированиеОсобогоНаименованияИОписанияЗадачи",
			ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения);
		
		Возврат;
	КонецЕсли;
	
	Если ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.УчастникиУсловиеПредставление
		И ТекущиеДанные <> Неопределено 
		И ЗначениеЗаполнено(ТекущиеДанные.Условие) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, ТекущиеДанные.Условие);
		
	ИначеЕсли Поле = Элементы.УчастникиЗащищенный Тогда
		
		ДействияКлиент.Защищенный(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры УчастникиВыбор
//
&НаКлиенте
Процедура ЗавершитьНастройкуОсобогоОписания(
	НаименованиеИОписание, СтрокаУчастника) Экспорт
	
	Если НаименованиеИОписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаУчастника.Описание = НаименованиеИОписание.Описание;
	
	СтрокаУчастника.ЕстьОсобоеНаименованиеОписание =
		ЗначениеЗаполнено(СтрокаУчастника.Описание);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьЭлементовФормы();
	ДействияКлиент.УчастникиПриАктивизацииСтроки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	ВариантыУстановкиСрока = СрокиИсполненияПроцессовКлиентСервер.ВариантыУстановкиСрокаИсполнения();
	
	СтрокиДействия = Участники.ПолучитьЭлементы();
	
	СтрокаУчастника = СтрокиДействия.Добавить();
	СтрокаУчастника.Участник = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка");
	СтрокаУчастника.Идентификатор = Новый УникальныйИдентификатор;
	СтрокаУчастника.ПредставлениеСтроки = ДействияКлиентСервер.ПредставлениеУчастника(СтрокаУчастника.Участник);
	СтрокаУчастника.Функция = ПредопределенноеЗначение("Перечисление.ФункцииУчастниковОзнакомления.Ознакомляемый");
	
	ИндексПредыдущегоЭлемента = СтрокиДействия.Количество() - 2;
	Если ИндексПредыдущегоЭлемента >= 0 Тогда
		
		СтрокаУчастника.ВариантУстановкиСрока = 
			СтрокиДействия[ИндексПредыдущегоЭлемента].ВариантУстановкиСрока;
		
		Если СтрокаУчастника.ВариантУстановкиСрока = ВариантыУстановкиСрока.ТочныйСрок Тогда
			СтрокаУчастника.Срок = СтрокиДействия[ИндексПредыдущегоЭлемента].Срок;
		Иначе
			СтрокаУчастника.СрокДни = СтрокиДействия[ИндексПредыдущегоЭлемента].СрокДни;
			СтрокаУчастника.СрокЧасы = СтрокиДействия[ИндексПредыдущегоЭлемента].СрокЧасы;
			СтрокаУчастника.СрокМинуты = СтрокиДействия[ИндексПредыдущегоЭлемента].СрокМинуты;
		КонецЕсли;
		
	Иначе
		
		СтрокаУчастника.ВариантУстановкиСрока = ВариантыУстановкиСрока.ОтносительныйСрок;
		
	КонецЕсли;
	
	Элементы.Участники.ТекущаяСтрока = СтрокаУчастника.ПолучитьИдентификатор();
	
	ЗаполнитьПредставлениеСроков();
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПередУдалением(Элемент, Отказ)
	
	ДействияКлиент.УчастникиПередУдалением(ЭтотОбъект, Отказ);	
	ОбновитьПредставленияВДеревеУчастников(Участники);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПередНачаломИзменения(Элемент, Отказ)
	
	ДействияКлиент.УчастникиПередНачаломИзменения(ЭтотОбъект, Отказ);
	
	ТекущиеДанные = Элементы.Участники.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено
		И ИсточникДанныхАктивен И ЗначениеЗаполнено(ТекущиеДанные.ИсточникДанных) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = Неопределено Или ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	УдаленыНекоторыеУчастники = Ложь;
	ДобавленыНовыеУчастники = Ложь;
	
	// Массив выбранных участников с обратной сортировкой.
	ВыбранныеУчастники = Новый Массив;
	ИндексСтроки = ВыбранноеЗначение.Количество() - 1;
	Пока ИндексСтроки >= 0 Цикл
		ВыбранныеУчастники.Добавить(ВыбранноеЗначение[ИндексСтроки]);
		ИндексСтроки = ИндексСтроки - 1;
	КонецЦикла;
	
	// Определение порядка выполнения, сроков и т.д. для новых строк.
	ВариантыУстановкиСрока = СрокиИсполненияПроцессовКлиентСервер.ВариантыУстановкиСрокаИсполнения();
	ЗначенияКолонокДляНовыхСтрок = Новый Структура;
	ЗначенияКолонокДляНовыхСтрок.Вставить("ВариантУстановкиСрока",
		ВариантыУстановкиСрока.ОтносительныйСрок);
	ЗначенияКолонокДляНовыхСтрок.Вставить("Срок", Дата(1,1,1));
	ЗначенияКолонокДляНовыхСтрок.Вставить("СрокДни", 0);
	ЗначенияКолонокДляНовыхСтрок.Вставить("СрокЧасы", 0);
	ЗначенияКолонокДляНовыхСтрок.Вставить("СрокМинуты", 0);
	
	// Удаление неактуальных участников.
	СтрокиУчастников = Участники.ПолучитьЭлементы();
	ИндексСтроки = СтрокиУчастников.Количество() - 1;
	Пока ИндексСтроки >= 0 Цикл
		
		СтрокаУчастника = СтрокиУчастников[ИндексСтроки];
		
		Если ИндексСтроки = СтрокиУчастников.Количество() - 1 Тогда
			ЗаполнитьЗначенияСвойств(ЗначенияКолонокДляНовыхСтрок, СтрокаУчастника);
		КонецЕсли;
		
		// Пропускаем существующих участников.
		ВыбранныйУчастник = ВыбранныеУчастники.Найти(СтрокаУчастника.Участник);
		Если ВыбранныйУчастник <> Неопределено Тогда
			ВыбранныеУчастники.Удалить(ВыбранныйУчастник);
			ИндексСтроки = ИндексСтроки - 1;
			Продолжить;
		КонецЕсли;
		
		// Завершивших свои задачи менять нельзя
		Если СтрокаУчастника.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияВыполненияДействий.Завершено") Тогда
			ИндексСтроки = ИндексСтроки - 1;
			Продолжить;
		КонецЕсли;
		
		// Защищенных участников удалять нельзя
		Если СтрокаУчастника.Защищенный Тогда
			ИндексСтроки = ИндексСтроки - 1;
			Продолжить;
		КонецЕсли;
		
		Если СтрокаУчастника.Недоступно Тогда
			ИндексСтроки = ИндексСтроки - 1;
			Продолжить;
		КонецЕсли;
		
		СтрокиУчастников.Удалить(СтрокаУчастника);
		УдаленыНекоторыеУчастники = Истина;
		
		ИндексСтроки = ИндексСтроки - 1;
		
	КонецЦикла;
	
	// Добавление новых участников.
	ИндексСтроки = ВыбранныеУчастники.Количество() - 1;
	Пока ИндексСтроки >= 0 Цикл
		
		ВыбранныйУчастник = ВыбранныеУчастники[ИндексСтроки];
		
		СтрокаУчастника = СтрокиУчастников.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаУчастника, ЗначенияКолонокДляНовыхСтрок);
		СтрокаУчастника.Идентификатор = Новый УникальныйИдентификатор;
		СтрокаУчастника.Участник = ВыбранныйУчастник;
		
		ВыбранныеУчастники.Удалить(ИндексСтроки);
		ДобавленыНовыеУчастники = Истина;
		ИндексСтроки = ИндексСтроки - 1;
		
	КонецЦикла;
	
	Если ДобавленыНовыеУчастники Тогда
		ОбновитьПредставленияВДеревеУчастников(Участники);
		ЗаполнитьПредставлениеСроков();
	КонецЕсли;
	
	Если УдаленыНекоторыеУчастники Или ДобавленыНовыеУчастники Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Работа с УчастникиПредставлениеСтроки

&НаКлиенте
Процедура ПредставлениеСтрокиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Участники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Участник = ТекущиеДанные.ПредставлениеСтроки;
	ТекущиеДанные.ИзНастройки = Ложь;
	
	ДействияКлиент.УчастникиПриАктивизацииСтроки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗаголовокФормы = НСтр("ru = 'Выбор ознакомляемого'");
	
	ОписаниеТиповСтрока 
	= "СправочникСсылка.Сотрудники, СправочникСсылка.ПолныеРоли, СправочникСсылка.РабочиеГруппы, СправочникСсылка.ПодразделенияКонтейнеры";
	
	ДействияКлиент.ПредставлениеСтрокиНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка, ЗаголовокФормы, ОписаниеТиповСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиОткрытие(Элемент, СтандартнаяОбработка)
	
	ДействияКлиент.ПредставлениеСтрокиОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиОчистка(Элемент, СтандартнаяОбработка)
	
	ДействияКлиент.ПредставлениеСтрокиОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Участники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДействияКлиент.ПредставлениеСтрокиОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	// Если значение требует уточнения, будет вызвана форма для ввода уточняющих данных.
	// Обработка выбора не должна выполняться в этом случае.
	ТипыДляУточнения = Новый Массив;
	ТипыДляУточнения.Добавить(Тип("Структура"));
	ТипыДляУточнения.Добавить(Тип("СправочникСсылка.РолиИсполнителей"));
	ТипыДляУточнения.Добавить(Тип("СправочникСсылка.СтруктураПредприятия"));
	ТипыДляУточнения.Добавить(Тип("СправочникСсылка.Проекты"));
	Если ТипыДляУточнения.Найти(ТипЗнч(ВыбранноеЗначение)) <> Неопределено Тогда
		СотрудникиКлиент.ОбработкаВыбораКонтейнера(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
		// Повторная проверка (значение могло быть изменено).
		Если ТипыДляУточнения.Найти(ТипЗнч(ВыбранноеЗначение)) <> Неопределено Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ТекущиеДанные.Участник = ВыбранноеЗначение;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДополнениеТипа = Новый ОписаниеТипов(
		"СправочникСсылка.Сотрудники, СправочникСсылка.ПолныеРоли, СправочникСсылка.РабочиеГруппы, СправочникСсылка.ПодразделенияКонтейнеры");
	
	ДействияКлиент.ПредставлениеСтрокиАвтоПодбор(
		ЭтотОбъект,Текст, ДанныеВыбора, СтандартнаяОбработка, ДополнениеТипа);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ДействияКлиент.ПредставлениеСтрокиОкончаниеВводаТекста(
		ЭтотОбъект, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

// Работа с УчастникиСрокПредставление

&НаКлиенте
Процедура СрокПредставлениеПриИзменении(Элемент)
	
	ДействияКлиент.СрокПредставлениеПриИзменении(ЭтотОбъект, Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДействияКлиент.СрокПредставлениеНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ДействияКлиент.СрокПредставлениеРегулирование(ЭтотОбъект, Элемент, Направление, СтандартнаяОбработка, Истина);
	ЗаполнитьПредставлениеСроков();
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ДействияКлиент.СрокПредставлениеОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, Истина);
	ЗаполнитьПредставлениеСроков();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	ДействияКлиент.ГотовоИзКарточкиДействия(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьДиалог(Команда)
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

&НаКлиенте
Процедура Защищенный(Команда)

	ДействияКлиент.Защищенный(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	ВыбранныеАдресаты = Новый Массив;
	Для Каждого СтрокаУчастника Из Участники.ПолучитьЭлементы() Цикл
		Если ЗначениеЗаполнено(СтрокаУчастника.Участник) Тогда
			СтруктураАдресата = Новый Структура("Участник, Недоступно",
				СтрокаУчастника.Участник, СтрокаУчастника.Недоступно Или СтрокаУчастника.Защищенный);
			ВыбранныеАдресаты.Добавить(СтруктураАдресата);
		КонецЕсли;
	КонецЦикла;
	
	ДоступныеТипы = Новый ОписаниеТипов("СправочникСсылка.Сотрудники, 
		|СправочникСсылка.ПолныеРоли,СправочникСсылка.РабочиеГруппы, СправочникСсылка.ПодразделенияКонтейнеры,");
	
	ПараметрыПолученияДанных = Новый Структура;
	ПараметрыПолученияДанных.Вставить("ВыборМножества", Истина);
	ПараметрыПолученияДанных.Вставить("КонтролироватьСотрудниковБезПользователя", Истина);
	
	РаботаСАдреснойКнигойКлиент.ВыбратьУчастника(ЭтотОбъект, Элементы.Участники, Ложь,
		ВыбранныеАдресаты, ДоступныеТипы, НСтр("ru = 'Подбор ознакомляемых'"), ПараметрыПолученияДанных);
		
КонецПроцедуры

&НаКлиенте
Процедура НаправитьНовымУчастникам(Команда)
	
	ИсполнениеДействияСНовымиУчастниками = Истина;
	ТолькоПросмотр = Ложь;
	Элементы.ЗаписатьИЗакрыть.Видимость = Истина;
	Элементы.ЗаписатьИЗакрыть.КнопкаПоУмолчанию = Истина;
	УстановитьДоступностьЭлементовФормы();
	
	ВариантыУстановкиСрока = СрокиИсполненияПроцессовКлиентСервер.ВариантыУстановкиСрокаИсполнения();
	
	// Сразу добавим новую строку
	СтрокиУчастников = Участники.ПолучитьЭлементы();
	СтрокаУчастника = СтрокиУчастников.Добавить();
	СтрокаУчастника.Участник = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка");
	СтрокаУчастника.ПредставлениеСтроки = ДействияКлиентСервер.ПредставлениеУчастника(СтрокаУчастника.Участник);
	
	ИндексПредыдущегоЭлемента = СтрокиУчастников.Количество() - 2;
	Если ИндексПредыдущегоЭлемента >= 0 Тогда
		
		СтрокаУчастника.ВариантУстановкиСрока = 
			СтрокиУчастников[ИндексПредыдущегоЭлемента].ВариантУстановкиСрока;
		
		Если СтрокаУчастника.ВариантУстановкиСрока = ВариантыУстановкиСрока.ТочныйСрок Тогда
			СтрокаУчастника.Срок = СтрокиУчастников[ИндексПредыдущегоЭлемента].Срок;
		Иначе
			СтрокаУчастника.СрокДни = СтрокиУчастников[ИндексПредыдущегоЭлемента].СрокДни;
			СтрокаУчастника.СрокЧасы = СтрокиУчастников[ИндексПредыдущегоЭлемента].СрокЧасы;
			СтрокаУчастника.СрокМинуты = СтрокиУчастников[ИндексПредыдущегоЭлемента].СрокМинуты;
		КонецЕсли;
		
	Иначе
		
		СтрокаУчастника.ВариантУстановкиСрока = ВариантыУстановкиСрока.ОтносительныйСрок;
		
	КонецЕсли;

	СтрокаУчастника.Функция = ПредопределенноеЗначение(
		"Перечисление.ФункцииУчастниковОзнакомления.Ознакомляемый");
	Элементы.Участники.ТекущаяСтрока = СтрокаУчастника.ПолучитьИдентификатор();
	
	ЗаполнитьПредставлениеСроков();
	
	Элементы.НаправитьНовымУчастникам.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗадержку(Команда)
	
	ДействияКлиент.ОчиститьЗадержку(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеВыполненоВнеПрограммы(Команда)

	ДействияКлиент.ВводРезультатаВыполненияВнеПрограммыИзФормыДействия(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ИзменениеДействияРазрешено()
	
	ПредметДействия = Неопределено;
	Если ЗначениеЗаполнено(Объект.Предмет) Тогда
		ПредметДействия = Объект.Предмет
	ИначеЕсли Параметры.Свойство("Предмет") Тогда
		ПредметДействия = Параметры.Предмет;
	КонецЕсли;
	
	Возврат ДействияСервер.ИзменениеДействияРазрешено(Объект.Ссылка, ПредметДействия);
	
КонецФункции

// Заполняет представление сроков в карточке процесса.
//
&НаКлиенте
Процедура ЗаполнитьПредставлениеСроков() Экспорт
	
	ЭлементыУчастники = Участники.ПолучитьЭлементы();
	
	Для Каждого ЭлементУчастник Из ЭлементыУчастники Цикл
		
		ЭлементУчастник.СрокПредставление = 
			СрокиИсполненияПроцессовКлиентСервер.ПредставлениеСрокаИсполнения(
				ЭлементУчастник.Срок,
				ЭлементУчастник.СрокДни,
				ЭлементУчастник.СрокЧасы,
				ЭлементУчастник.СрокМинуты,
				ИспользоватьДатуИВремяВСрокахЗадач,
				ЭлементУчастник.ВариантУстановкиСрока);
			
	КонецЦикла;
	
КонецПроцедуры

// Признак недоступности строки, переопределяемый для данного вида действия участника.
// Вызывается для строк с участниками, т.е. "нижнего" уровня дерева.
// 
// Параметры:
//  СтрокаДерева - ДанныеФормыЭлементДерева - Строка дерева "Участники".
//  СтрокаРодитель - Неопределено, ДанныеФормыЭлементДерева - Строка родитель строки дерева.
// 
// Возвращаемое значение:
//  Булево - Признак, что строка должна быть недоступна.
&НаКлиенте
Функция СтрокаУчастникаНедоступна(СтрокаДерева, СтрокаРодитель) Экспорт
	
	Возврат СтрокаДерева.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияВыполненияДействий.Завершено") 
		Или (ИсточникДанныхАктивен И ЗначениеЗаполнено(СтрокаДерева.ИсточникДанных))
		Или (МожноТолькоДобавлятьУчастников И СтрокаДерева.Недоступно)
		Или СтрокаДерева.НедоступноГруппа;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступностьЭлементовФормы() Экспорт
	
	Если Элементы.Участники.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Участники.ТекущиеДанные;
	
	Индекс = Участники.ПолучитьЭлементы().Индекс(ТекущиеДанные);
	ЭтоПервыйЭлемент = (Индекс = 0);
	
	ТолькоПросмотрСтроки = СтрокаУчастникаНедоступна(ТекущиеДанные, Неопределено);
	Элементы.ПредставлениеСтроки.ТолькоПросмотр = ТолькоПросмотрСтроки;
	Элементы.СрокПредставление.ТолькоПросмотр = ТолькоПросмотрСтроки
		Или МожноТолькоДобавлятьУчастников И Не ЭтоПервыйЭлемент;
	
	Элементы.ПредставлениеСтроки.КнопкаВыбора = Истина;
	
	Элементы.Подобрать.Доступность = Не ТолькоПросмотр Или ИсполнениеДействияСНовымиУчастниками
		Или МожноТолькоДобавлятьУчастников;
	Элементы.Удалить.Доступность = Не ТолькоПросмотрСтроки;
	Элементы.КонтекстУдалить.Доступность = Не ТолькоПросмотрСтроки;
	Элементы.ЕстьОсобоеНаименованиеОписание.Доступность = Не ТолькоПросмотрСтроки;
	ДействияКлиент.УстановитьТолькоПросмотрИУдалениеУчастникаПоЗащищенности(ЭтотОбъект);
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции_Участники

// Заполняет дерево участников по объекту.
//
&НаСервере
Процедура ОбновитьДеревоУчастниковПоОбъекту()
	
	ЭлементыУчастники = Участники.ПолучитьЭлементы();
	ЭлементыУчастники.Очистить();
	
	МаксимальноеЧислоУчастниковДляПоказа = Справочники.ДействияОзнакомления.МаксимальноеЧислоУчастниковДляПоказа();
	
	ПолноеКоличество = РегистрыСведений.УчастникиОзнакомлений.ЧислоУчастниковДействия(Объект.Ссылка);
	
	Для Каждого Участник Из Объект.Участники Цикл
		
		ЭлементУчастник = ЭлементыУчастники.Добавить();
		ЗаполнитьЗначенияСвойств(ЭлементУчастник, Участник);
		ЭлементУчастник.Функция = Перечисления.ФункцииУчастниковОзнакомления.Ознакомляемый;
		ЭлементУчастник.УсловиеПредставление = Строка(Участник.Условие);
		ЭлементУчастник.ЕстьОсобоеНаименованиеОписание = ЗначениеЗаполнено(ЭлементУчастник.Описание);
		ЭлементУчастник.Недоступно = МожноТолькоДобавлятьУчастников;
		
		Если ЗначениеЗаполнено(ЭлементУчастник.ИсточникДанных) Тогда
			ИсточникДанныхАктивен = ОбщегоНазначенияДокументооборотПовтИсп.ИсточникАктивен(ЭлементУчастник.ИсточникДанных);
		КонецЕсли;	
		
		Если ТолькоПросмотр И ЭлементыУчастники.Количество() >= МаксимальноеЧислоУчастниковДляПоказа Тогда
			
			Если ПолноеКоличество = 0 Тогда
				ПолноеКоличество = Объект.Участники.Количество();
			КонецЕсли;	
			
			ЭлементУчастник.ДопОписаниеОзнакомиться
				= СтрШаблон(
				НСтр("ru = ' и др., всего %1, см ""Ход ознакомления"". '"), ПолноеКоличество);
			Прервать;
				
		КонецЕсли;	
		
	КонецЦикла;
	
	ОбновитьПредставленияВДеревеУчастников(Участники);
	
	ДействияСервер.УстановитьЗащищенностьУчастниковВНастройке(ЭтотОбъект);
	
КонецПроцедуры

// Заполняет объект по дереву участников.
//
&НаКлиенте
Процедура ОбновитьОбъектПоДеревуУчастников(Отказ)
	
	СсылкаНеуказанногоСотрудники = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка");
	Объект.Участники.Очистить();
	
	ЭлементыУчастники = Участники.ПолучитьЭлементы();
	
	Для Каждого ЭлементУчастник Из ЭлементыУчастники Цикл
		
		Если Не ЗначениеЗаполнено(ЭлементУчастник.Участник)
			Или ЭлементУчастник.Участник = СсылкаНеуказанногоСотрудники Тогда
			Продолжить;
		КонецЕсли;
		
		Отбор = Новый Структура("Участник,  Описание", 
			ЭлементУчастник.Участник,  ЭлементУчастник.Описание);
		Если ЭлементУчастник.Защищенный Тогда
			// Все дубли должны быть отмечены как защищенные. Найдем неотмеченных.
			Отбор.Вставить("Защищенный", Ложь);
		КонецЕсли;
		НайденныеСотрудники = Объект.Участники.НайтиСтроки(Отбор);
		
		Если НайденныеСотрудники.Количество() > 0 Тогда
			Отказ = Истина;
			ПоказатьПредупреждение(, СтрШаблон(
				НСтр("ru = 'Повторяется участник ознакомления: %1.
				|Удалите дубли, укажите особое описание или установите участнику признак ""Защищенный""'"),
					ЭлементУчастник.Участник));
			Возврат;
		КонецЕсли;
		
		Участник = Объект.Участники.Добавить();
		ЗаполнитьЗначенияСвойств(Участник, ЭлементУчастник);
		Участник.Участник = ЭлементУчастник.Участник;
		
	КонецЦикла;
	
КонецПроцедуры

// Обновляет представления строк в дереве участников.
//
// Параметры:
//  Участники - ДанныеФормыДерево - дерево с участниками.
//
&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставленияВДеревеУчастников(Участники)
	
	ЭлементыУчастники = Участники.ПолучитьЭлементы();
	
	Для Каждого ЭлементУчастник Из ЭлементыУчастники Цикл
		
		Если ЗначениеЗаполнено(ЭлементУчастник.Участник) Тогда                      
			
			Если ЗначениеЗаполнено(ЭлементУчастник.ДопОписаниеОзнакомиться) Тогда
				
				ЭлементУчастник.ПредставлениеСтроки = 
					Строка(ЭлементУчастник.Участник) + ЭлементУчастник.ДопОписаниеОзнакомиться;
				
			Иначе

				ЭлементУчастник.ПредставлениеСтроки = 
					Строка(ЭлементУчастник.Участник) + "                              ";
				
			КонецЕсли;	
			
		Иначе
			ЭлементУчастник.ПредставлениеСтроки = 
				Строка(ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка")) 
				+ "                              ";
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьУчастников(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	РезультатПроверкиДействительностиУчастников = 
		РаботаСУчастникамиКлиент.ПроверитьДействительностьУчастников(ЭтотОбъект);
	Если Не РезультатПроверкиДействительностиУчастников.ВсеДействительны Тогда
		
		Отказ = Истина;
		
		Обработчик = Новый ОписаниеОповещения("ОбработатьРезультатПроверкиДействительностиУчастниковПродолжение",
			ЭтотОбъект);
		
		РаботаСУчастникамиКлиент.ОбработатьРезультатПроверкиДействительностиУчастников(
			РезультатПроверкиДействительностиУчастников,
			Обработчик);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработать результат проверки действительности участников продолжение.
// 
// Параметры:
//  Результат - Структура - результат проверки и выбор пользователя:
//   * РезультатПроверки - см. РаботаСУчастникамиВызовСервера.ПроверитьДействительностьУчастников
//   * ВариантОбработки - Число, КодВозвратаДиалога - 0 - заменить, 1 - оставить как есть,
//                                                    КодВозвратаДиалога.Отмена - отмена.
//  ДополнительныеПараметры - Произвольный
//
&НаКлиенте
Процедура ОбработатьРезультатПроверкиДействительностиУчастниковПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ВариантОбработки = Результат.ВариантОбработки;
	
	// Выбрана отмена.
	Если ВариантОбработки = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	// Хочет продолжить как есть.
	Если ВариантОбработки = 1 Тогда
		ЗаписатьЗакрытьБезПроверкиУчастников();
		Возврат;
	КонецЕсли;
	
	// Согласился заменить участников.
	Если ВариантОбработки = 0 Тогда
		ОбработчикЗамены = Новый ОписаниеОповещения("УчастникиЗамена", ЭтотОбъект);
		ОткрытьФорму("ОбщаяФорма.ФормаЗаменыУчастников", Результат.РезультатПроверки, ЭтотОбъект,,,,
			ОбработчикЗамены);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗакрытьБезПроверкиУчастников(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не Записать(Новый Структура("НеПроверятьУчастников", Истина)) Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиЗамена(Замены, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Замены = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаменитьУчастниковНаСервере(Замены);
	
КонецПроцедуры

// Заменить участников на сервере.
// 
// Параметры:
//  Замены - Массив Из Структура:
//   * ВидУчастника - СправочникСсылка.ВидыУчастниковЗадач
//   * Участник - СправочникСсылка.Сотрудники
//   * УчастникЗаменитьНа - СправочникСсылка.Сотрудники
&НаСервере
Процедура ЗаменитьУчастниковНаСервере(Замены)
	
	БылиЗамены = Ложь;
	
	Для Каждого Замена Из Замены Цикл
		
		КлючиСтруктурыОтбора = "Участник";
		СтруктураОтбора = Новый Структура(КлючиСтруктурыОтбора);
		ЗаполнитьЗначенияСвойств(СтруктураОтбора, Замена, КлючиСтруктурыОтбора);
		НайденныеСтрокиУчастников = Объект.Участники.НайтиСтроки(СтруктураОтбора);
		
		Для Каждого СтрокаУчастника Из НайденныеСтрокиУчастников Цикл
			СтрокаУчастника.Участник = Замена.УчастникЗаменитьНа;
			БылиЗамены = Истина;
		КонецЦикла; 
		
	КонецЦикла;
	
	Если БылиЗамены Тогда
		
		Модифицированность = Истина;
		ОбновитьДеревоУчастниковПоОбъекту();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСостоянияОзнакомления()
	
	ЕстьЗаписиРС = Ложь;
	РезультатыОзнакомлений = Справочники.ДействияОзнакомления.РезультатыОзнакомлений(Объект.Ссылка, ЕстьЗаписиРС);
	
	ЭлементыУчастники = Участники.ПолучитьЭлементы();
	
	Для Каждого ЭлементУчастник Из ЭлементыУчастники Цикл
		
		СтруктураОзнакомления = РезультатыОзнакомлений.Получить(ЭлементУчастник.Идентификатор);
		Если СтруктураОзнакомления <> Неопределено Тогда   
			
			Если СтруктураОзнакомления.СколькоОзнакомлено <> 0 Тогда // если не 0  - значит кто то уже выполнил
				ЭлементУчастник.Недоступно = Истина;   
				ЭлементУчастник.НедоступноГруппа = Истина;   
			КонецЕсли;	

			Если СтруктураОзнакомления.СколькоОзнакомлено < СтруктураОзнакомления.СколькоВсегоНадоОзнакомить Тогда
				ЭлементУчастник.Состояние = Перечисления.СостоянияВыполненияДействий.Выполняется;
				ЭлементУчастник.Результат = Перечисления.РезультатыОзнакомления.ПустаяСсылка();
			Иначе
				ЭлементУчастник.Состояние = Перечисления.СостоянияВыполненияДействий.Завершено;    
				ЭлементУчастник.Результат = Перечисления.РезультатыОзнакомления.Ознакомлен;
			КонецЕсли;	 
			
			ЭлементУчастник.НомерКартинки = ДействияКлиентСервер.НомерКартинкиРезультата(ЭлементУчастник.Результат, ЭлементУчастник.Состояние, Ложь);
			
		КонецЕсли;	
		
	КонецЦикла;
	
КонецПроцедуры	

#КонецОбласти

#КонецОбласти