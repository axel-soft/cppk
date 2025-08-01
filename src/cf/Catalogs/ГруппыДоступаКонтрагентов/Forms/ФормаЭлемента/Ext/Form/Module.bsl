﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьИнформациюОЗапрещенныхУчастниках();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОбщегоНазначенияДокументооборотКлиент.УдалитьПустыеСтрокиТаблицы(Объект.Доступ, "Участник");
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьИнформациюОЗапрещенныхУчастниках();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредупреждениеОЗапрещенныхНажатие(Элемент)
	
	ПараметрыФормыЗапрещенных = Новый Структура("ГруппаДоступаКонтрагентов", Объект.Ссылка);
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработкаЗакрытияФормыЗапрещенных", ЭтотОбъект);
	ОткрытьФорму("Справочник.ГруппыДоступаКонтрагентов.Форма.ЗапрещенныеУчастникиДоступа",
		ПараметрыФормыЗапрещенных, ЭтотОбъект,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДоступ

&НаКлиенте
Процедура ДоступПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Участник = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ЕстьИзменения = Ложь;
	
	Для Каждого Значение Из ВыбранноеЗначение Цикл
		Если Объект.Доступ.НайтиСтроки(Новый Структура("Участник", Значение)).Количество() = 0 Тогда
			Строка = Объект.Доступ.Добавить();
			Строка.Участник = Значение;
			ЕстьИзменения = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьИзменения Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступУчастникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка= Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ПодменятьПользователейСотрудниками", Истина);
	ПараметрыФормы.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
	
	Если Элементы.Доступ.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("ВыбранныеАдресаты",
			Элементы.Доступ.ТекущиеДанные.Участник);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор сотрудника, подразделения, группы, роли'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаАдреснойКниги", НСтр("ru = 'Все сотрудники'"));
	
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыФормы, Элементы.ДоступУчастник, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступУчастникОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СотрудникиКлиент.ОбработкаВыбораКонтейнера(
		Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступУчастникАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СотрудникиВызовСервера.СформироватьДанныеВыборасКонтейнерами(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступУчастникОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СотрудникиВызовСервера.СформироватьДанныеВыборасКонтейнерами(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, ДополнительныеДанные, СтандартнаяОбработка)
	
	СотрудникиКлиент.СотрудникОбработкаВыбора(Объект, "Ответственный", ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьСотрудниковДоступ(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 2);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ПодменятьПользователейСотрудниками", Истина);
	ПараметрыФормы.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
	
	ВыбранныеАдресаты = Новый Массив;
	Для Каждого Строка Из Объект.Доступ Цикл
		ВыбранныеАдресаты.Добавить(Строка.Участник);
	КонецЦикла;
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыбранныеАдресаты);
	
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Подбор сотрудников, подразделений, групп, ролей'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаАдреснойКниги", НСтр("ru = 'Все сотрудники'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаВыбранных", НСтр("ru = 'Выбранные сотрудники'"));
	
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыФормы, Элементы.Доступ, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьИнформациюОЗапрещенныхУчастниках()
	
	КолОбъектов = 0;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		КолОбъектов = Справочники.ГруппыДоступаКонтрагентов.ОбъектыСЗапрещеннымиУчастникамиДоступа(
			Истина, Объект.Ссылка);
	КонецЕсли;
	Элементы.ГруппаПредупреждениеОЗапрещенных.Видимость = КолОбъектов > 0;
	Элементы.ПредупреждениеОЗапрещенных.Заголовок = СтрШаблон(
		НСтр("ru = '%1 с запрещенными участниками доступа'"), 
		СтрокаСЧислом(НСтр("ru = ';Обнаружен %1 объект;;
				|Обнаружено %1 объекта;Обнаружено %1 объектов;
				|Обнаружено %1 объектов'"),
			КолОбъектов, ВидЧисловогоЗначения.Количественное));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗакрытияФормыЗапрещенных(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьИнформациюОЗапрещенныхУчастниках();
	
КонецПроцедуры

#КонецОбласти
