﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Документ = Параметры.Документ;
	Контрагент = Параметры.Контрагент;
	Организация = Параметры.Организация;
	Проект = Параметры.Проект;
	
	МассивТиповСвязей = Новый Массив;
	Для Каждого Строка Из Параметры.ОбязательныеСвязи Цикл
		МассивТиповСвязей.Добавить(Строка.ТипСвязи);
	КонецЦикла;
	КомментарииТиповСвязи = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивТиповСвязей, "Комментарий");
	
	Для Каждого Строка Из Параметры.ОбязательныеСвязи Цикл
		
		НоваяСтрока = ОбязательныеСвязи.Добавить();
		
		НоваяСтрока.ТипСвязи = Строка.ТипСвязи;
		НоваяСтрока.СсылкаНа = Строка.СсылкаНа;
		
		Если ЗначениеЗаполнено(КомментарииТиповСвязи.Получить(Строка.ТипСвязи)) Тогда
			НоваяСтрока.ПредставлениеТипа = СтрШаблон("%1 (%2)", 
				Строка(Строка.ТипСвязи),
				КомментарииТиповСвязи.Получить(Строка.ТипСвязи));
		Иначе
			НоваяСтрока.ПредставлениеТипа = Строка(Строка.ТипСвязи);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ОчиститьСообщения();
	
	Для Каждого Строка Из ОбязательныеСвязи Цикл
		
		Если Не ЗначениеЗаполнено(Строка.СвязанныйДокумент) Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Нужно указать связанный документ.'"));
			Возврат;
		КонецЕсли;	
		
	КонецЦикла;	
	
	МассивВозврата = Новый Массив;
	
	Для Каждого Строка Из ОбязательныеСвязи Цикл
		
		ПараметрыВозврата = Новый Структура("ТипСвязи, СсылкаНа, СвязанныйОбъект, Комментарий", 
			Строка.ТипСвязи, Строка.СсылкаНа, Строка.СвязанныйДокумент, Строка.Комментарий);
			
		МассивВозврата.Добавить(ПараметрыВозврата);
		
	КонецЦикла;	
	
	Закрыть(МассивВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбязательныеСвязиСвязанныйДокументНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.ОбязательныеСвязи.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ТекущиеДанные = Элементы.ОбязательныеСвязи.ТекущиеДанные;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СвязанныйДокументНачалоВыбораПродолжение",
		ЭтотОбъект);
	
	ОбязательныеСвязиПараметр = Новый Массив;
			
	ПараметрыСвязи = Новый Структура("ТипСвязи, СсылкаНа",
		ТекущиеДанные.ТипСвязи, ТекущиеДанные.СсылкаНа);
	
	ОбязательныеСвязиПараметр.Добавить(ПараметрыСвязи);
	
	ПараметрыОткрытияФормы = Новый Структура(
		"Документ, ОбязательныеСвязи, Контрагент, Организация, Проект", 
		Документ, ОбязательныеСвязиПараметр,
		Контрагент, Организация, Проект);	
		
	ИмяФормыСозданияСвязи = "";	
		
	СтрокаПараметров = ТекущиеДанные;
	Если ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("СправочникСсылка.ДокументыПредприятия")
		Или ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("СправочникСсылка.ВидыДокументов") Тогда
		ИмяФормыСозданияСвязи = "Справочник.ДокументыПредприятия.Форма.ФормаВыбораДляСозданияСвязи";
	ИначеЕсли ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("СправочникСсылка.Файлы") Тогда
		ИмяФормыСозданияСвязи = "Справочник.Файлы.Форма.ФормаВыбораДляСозданияСвязи";
	ИначеЕсли ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("СправочникСсылка.Мероприятия") Тогда
		ИмяФормыСозданияСвязи = "Справочник.Мероприятия.Форма.ФормаВыбораДляСозданияСвязи";
	ИначеЕсли ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("СправочникСсылка.Проекты") Тогда
		ИмяФормыСозданияСвязи = "Справочник.Проекты.Форма.ФормаВыбораДляСозданияСвязи";
	ИначеЕсли ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("ДокументСсылка.ВходящееПисьмо") Тогда
		ИмяФормыСозданияСвязи = "Документ.ВходящееПисьмо.Форма.ФормаВыбораДляСозданияСвязи";
	ИначеЕсли ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("ДокументСсылка.ИсходящееПисьмо") Тогда
		ИмяФормыСозданияСвязи = "Документ.ИсходящееПисьмо.Форма.ФормаВыбораДляСозданияСвязи";
	Иначе	
		ИмяФормыСозданияСвязи = "РегистрСведений.СвязиОбъектов.Форма.ФормаВнешнегоРесурсаДляСозданияСвязи";
	КонецЕсли;	
	
	ОткрытьФорму(ИмяФормыСозданияСвязи, 
		ПараметрыОткрытияФормы, ЭтаФорма,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СвязанныйДокументНачалоВыбораПродолжение(Результат, Параметры) Экспорт 
	
	Если ЗначениеЗаполнено(Результат) Тогда 
		
		Если Элементы.ОбязательныеСвязи.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;	
		
		ВыбранныеОбязательныеСвязи = Результат; // массив
		Если ВыбранныеОбязательныеСвязи.Количество() = 1 Тогда
			
			Строка = ВыбранныеОбязательныеСвязи[0];
			ТекущиеДанные = Элементы.ОбязательныеСвязи.ТекущиеДанные;
			ТекущиеДанные.СвязанныйДокумент = Строка.СвязанныйОбъект;
			ТекущиеДанные.Комментарий = Строка.Комментарий;
			
		КонецЕсли;	
		
	КонецЕсли;	

КонецПроцедуры
