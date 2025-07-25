﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкиДействий.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	ОбновитьДеревоУчастниковПоОбъекту();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьПредставлениеСроков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", Объект.Ссылка.Пустая());
	ОбновитьОбъектПоДеревуУчастников(Отказ);
	ДействияКлиент.ОтложенноеНачалоВыполненияПередЗаписью(ЭтотОбъект);
	
	Если ПараметрыЗаписи.Свойство("НеПроверятьУчастников") И ПараметрыЗаписи.НеПроверятьУчастников Тогда
		Возврат;
	КонецЕсли;
	ПроверитьУчастников(Отказ);
	
	Если Не ЗначениеЗаполнено(Объект.МоментРазыменованияУчастников) Тогда
		Объект.МоментРазыменованияУчастников = ПредопределенноеЗначение("Перечисление.МоментыРазыменованияУчастниковДействий.ПриСозданииДействия");
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	НастройкиДействий.ПриЗаписиНаСервере(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	НастройкиДействий.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_НастройкиДействий", Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КлючОбщейНастройкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, ОбщаяНастройка);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
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
	
	НастройкиДействийКлиент.НастройкиДействияАвторАвтоПодбор(
		ЭтотОбъект, Текст, ДанныеВыбора, СтандартнаяОбработка, ТипОбъекта);
		
КонецПроцедуры

&НаКлиенте
Процедура АвторОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
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
	РазвернутьДеревоУчастников();
	ДействияКлиент.УстановитьДоступностьКомандыЗащищенный(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.ЕстьОсобоеНаименованиеОписание Тогда
		
		ТекущиеДанные = Участники.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ТекущиеДанные = Неопределено
			Или ТекущиеДанные.ЭтоЭтап
			Или ТекущиеДанные.Функция <> ПредопределенноеЗначение("Перечисление.ФункцииУчастниковРегистрации.Регистратор") Тогда
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Описание", ТекущиеДанные.Описание);
		ПараметрыФормы.Вставить("ТолькоОписание", Истина);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ЗавершитьНастройкуОсобогоОписания", ЭтотОбъект, ТекущиеДанные);
			
		ОткрытьФорму("ОбщаяФорма.РедактированиеОсобогоНаименованияИОписанияЗадачи",
			ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения);
			
	ИначеЕсли Поле = Элементы.УчастникиЗащищенный Тогда
		
		ДействияКлиент.Защищенный(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПередУдалением(Элемент, Отказ)
	
	НастройкиДействийКлиент.УчастникиПередУдалением(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	НастройкиДействийКлиент.УчастникиПередНачаломДобавления(
		ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа, Параметр);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Участники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоЭтап Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура УчастникиПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьЭлементовФормы();
	ДействияКлиент.УчастникиПриАктивизацииСтроки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьНастройкуОсобогоОписания(Результат, СтрокаУчастника) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаУчастника.Описание = Результат.Описание;
	СтрокаУчастника.ЕстьОсобоеНаименованиеОписание =
		ЗначениеЗаполнено(СтрокаУчастника.Описание);
	
	Модифицированность = Истина;
	
КонецПроцедуры

// Работа с УчастникиПредставлениеСтроки

&НаКлиенте
Процедура ПредставлениеСтрокиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Участники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоЭтап Тогда
		ТекущиеДанные.НаименованиеЭтапа = ТекущиеДанные.ПредставлениеСтроки;
	Иначе
		ТекущиеДанные.Участник = ТекущиеДанные.ПредставлениеСтроки;
		Если Не ЗначениеЗаполнено(ТекущиеДанные.ПредставлениеСтроки) Тогда
			ТекущиеДанные.Защищенный = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЭтоОбрабатывающийРезультат = Ложь;
	ТекущиеДанные = Элементы.Участники.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Если ТекущиеДанные.Функция = ПредопределенноеЗначение("Перечисление.ФункцииУчастниковРегистрации.ОбрабатывающийРезультат") Тогда
			ЭтоОбрабатывающийРезультат = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ЗаголовокФормы = НСтр("ru = 'Выбор регистратора'");
	НастройкиДействийКлиент.ПредставлениеСтрокиНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка,
		ЗаголовокФормы, Истина, Не ЭтоОбрабатывающийРезультат, ТипОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиОткрытие(Элемент, СтандартнаяОбработка)
	
	НастройкиДействийКлиент.ПредставлениеСтрокиОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиОчистка(Элемент, СтандартнаяОбработка)
	
	НастройкиДействийКлиент.ПредставлениеСтрокиОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Участники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоЭтап Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	НастройкиДействийКлиент.ПредставлениеСтрокиОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
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
	
	РазвернутьДеревоУчастников();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДополнениеТипа = Новый ОписаниеТипов(
		"СправочникСсылка.ПолныеРоли, СправочникСсылка.АвтоподстановкиДляОбъектов,
		|СправочникСсылка.Сотрудники");
	
	НастройкиДействийКлиент.ПредставлениеСтрокиАвтоПодбор(ЭтотОбъект, Элемент, Текст, ДанныеВыбора,
		ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка, ДополнениеТипа, ТипОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ДополнениеТипа = Новый ОписаниеТипов(
		"СправочникСсылка.ПолныеРоли, СправочникСсылка.АвтоподстановкиДляОбъектов,
		|СправочникСсылка.Сотрудники");
	
	НастройкиДействийКлиент.ПредставлениеСтрокиОкончаниеВводаТекста(ЭтотОбъект, Элемент, Текст, 
		ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка, ДополнениеТипа, ТипОбъекта);
	
КонецПроцедуры

// Работа с УчастникиСрокПредставление

&НаКлиенте
Процедура СрокПредставлениеПриИзменении(Элемент)
	
	ДействияКлиент.СрокПредставлениеПриИзменении(
		ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ДействияКлиент.СрокПредставлениеРегулирование(
		ЭтаФорма, Элемент, Направление, СтандартнаяОбработка);
	ЗаполнитьПредставлениеСроков();
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Участники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВариантыУстановкиСрока = 
		СрокиИсполненияПроцессовКлиентСервер.ВариантыУстановкиСрокаИсполнения();
	
	ТекущиеДанные.Срок = ВыбранноеЗначение;
	ТекущиеДанные.СрокДни = 0;
	ТекущиеДанные.СрокЧасы = 0;
	ТекущиеДанные.СрокМинуты = 0;
	ТекущиеДанные.ВариантУстановкиСрока = ВариантыУстановкиСрока.ТочныйСрок;
	
	ЗаполнитьПредставлениеСроков();
	
КонецПроцедуры

// Работа с УчастникиОписание
&НаКлиенте
Процедура ОписаниеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Участники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ЕстьОсобоеНаименованиеОписание =
		ЗначениеЗаполнено(ТекущиеДанные.Описание);
	
КонецПроцедуры

// Работа с УчастникиУсловие
&НаКлиенте
Процедура УсловиеПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	НастройкиДействийКлиент.УсловиеПредставлениеОткрытие(
		ЭтотОбъект, Элемент, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура УсловиеПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	НастройкиДействийКлиент.УсловиеПредставлениеОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура УсловиеПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НастройкиДействийКлиент.УсловиеПредставлениеНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка, ТипОбъекта);
			
КонецПроцедуры
	
&НаКлиенте
Процедура УсловиеПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	НастройкиДействийКлиент.УсловиеПредставлениеОчистка(
		ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура УсловиеПредставлениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	НастройкиДействийКлиент.УсловиеПредставлениеАвтоПодбор(
		Текст, ДанныеВыбора, СтандартнаяОбработка, ТипОбъекта);

КонецПроцедуры

&НаКлиенте
Процедура УсловиеПредставлениеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	НастройкиДействийКлиент.УсловиеПредставлениеОкончаниеВводаТекста(
		Текст, ДанныеВыбора, СтандартнаяОбработка, ТипОбъекта);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Защищенный(Команда)
	
	ДействияКлиент.Защищенный(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	Если Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьУчастниковПоУмолчанию(Команда)
	
	ЗаполнитьУчастниковПоУмолчаниюНаСервере();
	
	ЗаполнитьПредставлениеСроков();
	
	РазвернутьДеревоУчастников();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗадержку(Команда)
	
	ДействияКлиент.ОчиститьЗадержку(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьУчастниковПоУмолчаниюНаСервере()
	
	ДействиеОбъект = РеквизитФормыВЗначение("Объект");
	ДействиеОбъект.ЗаполнитьУчастниковПоУмолчанию();
	ЗначениеВРеквизитФормы(ДействиеОбъект, "Объект");
	
	ОбновитьДеревоУчастниковПоОбъекту();
	
КонецПроцедуры

// Заполняет представление сроков в карточке процесса.
//
&НаКлиенте
Процедура ЗаполнитьПредставлениеСроков() Экспорт
	
	ЭтапыУчастников = Участники.ПолучитьЭлементы();
	Для Каждого ЭтапУчастников Из ЭтапыУчастников Цикл
		
		УчастникиЭтапа = ЭтапУчастников.ПолучитьЭлементы();
		
		Для Каждого УчастникЭтапа Из УчастникиЭтапа Цикл
			
			УчастникЭтапа.СрокПредставление = 
				СрокиИсполненияПроцессовКлиентСервер.ПредставлениеСрокаИсполнения(
					УчастникЭтапа.Срок,
					УчастникЭтапа.СрокДни,
					УчастникЭтапа.СрокЧасы,
					УчастникЭтапа.СрокМинуты,
					ИспользоватьДатуИВремяВСрокахЗадач,
					УчастникЭтапа.ВариантУстановкиСрока);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоУчастниковПоОбъекту()
	
	ДействиеОбъект = РеквизитФормыВЗначение("Объект");
	ЭтапыУчастников = Участники.ПолучитьЭлементы();
	ЭтапыУчастников.Очистить();
	
	// Регистрация
	ЭтапЗарегистрировать = ЭтапыУчастников.Добавить();
	ЭтапЗарегистрировать.ТочкаМаршрута = ТочкаЗарегистрировать();
	ЭтапЗарегистрировать.Функция = ПредопределенноеЗначение("Перечисление.ФункцииУчастниковРегистрации.Регистратор");
	ЭтапЗарегистрировать.НаименованиеЭтапа = НСтр("ru = 'Зарегистрировать'");
	ЭтапЗарегистрировать.ЭтоЭтап = Истина;
	
	УчастникиЭтапа = ЭтапЗарегистрировать.ПолучитьЭлементы();
	ДобавилиУчастника = Ложь;
	Для Каждого Регистратор Из ДействиеОбъект.Участники() Цикл
		УчастникЭтапа = УчастникиЭтапа.Добавить();
		ЗаполнитьЗначенияСвойств(УчастникЭтапа, Регистратор);
		УчастникЭтапа.Участник = Регистратор.Участник;
		УчастникЭтапа.Функция = Регистратор.ФункцияУчастника;
		УчастникЭтапа.СрокПредставление = СрокиИсполненияПроцессовКлиентСервер.ПредставлениеСрокаИсполнения(
			УчастникЭтапа.Срок,
			УчастникЭтапа.СрокДни,
			УчастникЭтапа.СрокЧасы,
			УчастникЭтапа.СрокМинуты,
			ИспользоватьДатуИВремяВСрокахЗадач,
			УчастникЭтапа.ВариантУстановкиСрока);
		УчастникЭтапа.ЕстьОсобоеНаименованиеОписание =
			ЗначениеЗаполнено(УчастникЭтапа.Описание);
		ДобавилиУчастника = Истина;
		УчастникЭтапа.УсловиеПредставление = УчастникЭтапа.Условие;
	КонецЦикла;
	
	Если Не ДобавилиУчастника Тогда 
		УчастникЭтапа = УчастникиЭтапа.Добавить();
		УчастникЭтапа.Функция = ЭтапЗарегистрировать.Функция;
	КонецЕсли;
	
	// ОбрабатывающийРезультат
	ЭтапОзнакомление = ЭтапыУчастников.Добавить();
	ЭтапОзнакомление.ТочкаМаршрута = ТочкаОзнакомиться();
	ЭтапОзнакомление.Функция = ПредопределенноеЗначение("Перечисление.ФункцииУчастниковРегистрации.ОбрабатывающийРезультат");
	ЭтапОзнакомление.НаименованиеЭтапа = НСтр("ru = 'Ознакомиться с результатом регистрации'");
	ЭтапОзнакомление.ЭтоЭтап = Истина;
	
	УчастникиЭтапа = ЭтапОзнакомление.ПолучитьЭлементы();
	ДобавилиУчастника = Ложь;
	Для Каждого ОбрабатывающийРезультат Из ДействиеОбъект.УчастникОбрабатывающийРезультат() Цикл
		УчастникЭтапа = УчастникиЭтапа.Добавить();
		ЗаполнитьЗначенияСвойств(УчастникЭтапа, ОбрабатывающийРезультат);
		УчастникЭтапа.Участник = ОбрабатывающийРезультат.Участник;
		УчастникЭтапа.Функция = ОбрабатывающийРезультат.ФункцияУчастника;
		УчастникЭтапа.СрокПредставление = СрокиИсполненияПроцессовКлиентСервер.ПредставлениеСрокаИсполнения(
			УчастникЭтапа.Срок,
			УчастникЭтапа.СрокДни,
			УчастникЭтапа.СрокЧасы,
			УчастникЭтапа.СрокМинуты,
			ИспользоватьДатуИВремяВСрокахЗадач,
			УчастникЭтапа.ВариантУстановкиСрока);
		ДобавилиУчастника = Истина;
	КонецЦикла;
	
	Если Не ДобавилиУчастника Тогда 
		УчастникЭтапа = УчастникиЭтапа.Добавить();
		УчастникЭтапа.Функция = ЭтапОзнакомление.Функция;
	КонецЕсли;
	
	ОбновитьПредставленияВДеревеУчастников(Участники);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОбъектПоДеревуУчастников(Отказ)
	
	НастройкиДействийКлиент.ОбновитьНастройкуДействияПоДеревуУчастников(
		ЭтотОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДеревоУчастников()
	
	Для Каждого Этап Из Участники.ПолучитьЭлементы() Цикл
		Элементы.Участники.Развернуть(Этап.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставленияВДеревеУчастников(Участники)
	
	Для Каждого СтрокаЭтапа Из Участники.ПолучитьЭлементы() Цикл
		СтрокаЭтапа.ПредставлениеСтроки = СтрокаЭтапа.НаименованиеЭтапа;
		Для Каждого СтрокаУчастника Из СтрокаЭтапа.ПолучитьЭлементы() Цикл
			СтрокаУчастника.ПредставлениеСтроки = Строка(СтрокаУчастника.Участник) + "                              ";
			Если Не ЗначениеЗаполнено(СтрокаУчастника.Участник) Тогда
				СтрокаУчастника.ПредставлениеСтроки = Строка(ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка"))
				+ "                              ";
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТочкаЗарегистрировать()
	
	Возврат ПредопределенноеЗначение("БизнесПроцесс.Регистрация.ТочкаМаршрута.Зарегистрировать");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТочкаОзнакомиться()
	
	Возврат ПредопределенноеЗначение("БизнесПроцесс.Регистрация.ТочкаМаршрута.Ознакомиться");
	
КонецФункции

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
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступностьЭлементовФормы() Экспорт
	
	ТекущиеДанные = Элементы.Участники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоЭтап Тогда
		
		Элементы.ПредставлениеСтроки.ТолькоПросмотр = Истина;
		Элементы.СрокПредставление.ТолькоПросмотр = Истина;
		
		Элементы.ЕстьОсобоеНаименованиеОписание.ТолькоПросмотр = Истина;
		Элементы.Описание.ТолькоПросмотр = Истина;
		Элементы.Добавить.Доступность = Не ДействияКлиентСервер.ЭтоФункцияОбработатьРезультат(ТекущиеДанные.Функция);
		Элементы.Удалить.Доступность = Ложь;
		
	ИначеЕсли ДействияКлиентСервер.ЭтоФункцияОбработатьРезультат(ТекущиеДанные.Функция) Тогда
		
		Элементы.ПредставлениеСтроки.ТолькоПросмотр = Ложь;
		Элементы.СрокПредставление.ТолькоПросмотр = Ложь;
		
		Элементы.ЕстьОсобоеНаименованиеОписание.ТолькоПросмотр = Ложь;
		Элементы.Описание.ТолькоПросмотр = Ложь;
		Элементы.Добавить.Доступность = Ложь;
		Элементы.Удалить.Доступность = Истина;
		
	Иначе
		
		Элементы.ПредставлениеСтроки.ТолькоПросмотр = Ложь;
		Элементы.СрокПредставление.ТолькоПросмотр = Ложь;
		
		Элементы.ЕстьОсобоеНаименованиеОписание.ТолькоПросмотр = Ложь;
		Элементы.Описание.ТолькоПросмотр = Ложь;
		Элементы.Добавить.Доступность = Истина;
		Элементы.Удалить.Доступность = Истина;
		
	КонецЕсли;
	
	Элементы.КонтекстДобавить.Доступность = Элементы.Добавить.Доступность;
	Элементы.КонтекстУдалить.Доступность = Элементы.Удалить.Доступность;
	ДействияКлиент.УстановитьТолькоПросмотрИУдалениеУчастникаПоЗащищенности(ЭтотОбъект);
	
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
	РазвернутьДеревоУчастников();
	
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
		
		КлючиСтруктурыОтбора = "ФункцияУчастника, Участник";
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

&НаКлиенте
Процедура МоментРазыменованияУчастниковОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти
