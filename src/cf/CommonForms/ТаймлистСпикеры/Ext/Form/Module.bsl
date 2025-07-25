﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	Если Параметры.РежимПолученияАвтопротокола Тогда
		
		РежимПолученияАвтопротокола = Параметры.РежимПолученияАвтопротокола;
		Элементы.ГруппаСпикерыРасшифровкаНесколькоФайлов.Видимость = Ложь;
		Элементы.ГруппаСпикерыРасшифровкаОдинФайл.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Укажите спикеров'");
		Элементы.Готово.Заголовок = НСтр("ru = 'Получить автопротокол'");
		ЗаполнитьСпикеровДляПолученияАвтопротокола();
		Если Параметры.ОтборСотрудников.Количество() > 0 Тогда
			ОтборСотрудников = Параметры.ОтборСотрудников;
		КонецЕсли;
		
	ИначеЕсли Параметры.РежимПолученияРасшифровки Тогда
		
		РежимПолученияРасшифровки = Параметры.РежимПолученияРасшифровки;
		ЗаполнитьСпикеровДляПолученияРасшифровки();
		Элементы.ГруппаСпикерыАвтопротокол.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Укажите количество спикеров'");
		
		Если ЗначениеЗаполнено(ФайлНаРасшифровку) Тогда
			Элементы.ГруппаСпикерыРасшифровкаНесколькоФайлов.Видимость = Ложь;
		Иначе
			Элементы.ГруппаСпикерыРасшифровкаОдинФайл.Видимость = Ложь;
		КонецЕсли;
		
		Элементы.Готово.Заголовок = НСтр("ru = 'Получить расшифровку'");
		
	Иначе
		
		Отказ = Истина;
		
	КонецЕсли;
	
	ЭтоМобильныйКлиент = ПараметрыСеанса.ЭтоМобильныйКлиент;
	Если ЭтоМобильныйКлиент Тогда
		МК_НастроитьЭлементыФормы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСпикерыАвтопротокол

&НаКлиенте
Процедура СпикерыАвтопротоколПредставлениеУчастникаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Элементы.СпикерыАвтопротокол.ТекущиеДанные.ПредставлениеУчастника) Тогда
		Элементы.СпикерыАвтопротокол.ТекущиеДанные.Участник = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпикерыАвтопротоколПредставлениеУчастникаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ОтборСотрудников.Количество() > 0 Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("СпикерыАвтопротоколПредставлениеУчастникаНачалоВыбораЗавершение",
			ЭтотОбъект);
		ДанныеВыбораУчастника = СформироватьДанныеВыбораУчастника();
		Если ДанныеВыбораУчастника.Количество() > 10 Тогда
			ДанныеВыбораУчастника.ПоказатьВыборЭлемента(
				ОписаниеОповещения,
				НСтр("ru = 'Выбор участника'"),
				ДанныеВыбораУчастника.НайтиПоЗначению(Элементы.СпикерыАвтопротокол.ТекущиеДанные.Участник));
		Иначе
			ДанныеВыбора = ДанныеВыбораУчастника;
		КонецЕсли;
		
	Иначе
		
		СотрудникиКлиент.ВыбратьСотрудникаИзАдреснойКниги(Элемент, Элементы.СпикерыАвтопротокол.ТекущиеДанные.Участник,
			НСтр("ru = 'Выбор участника'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпикерыАвтопротоколПредставлениеУчастникаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.СпикерыАвтопротокол.ТекущиеДанные.ПредставлениеУчастника = Результат.Значение;
	Элементы.СпикерыАвтопротокол.ТекущиеДанные.Участник = Результат.Значение;
	
КонецПроцедуры

&НаКлиенте
Процедура СпикерыАвтопротоколПредставлениеУчастникаОбработкаВыбора(Элемент, ВыбранноеЗначение, ДополнительныеДанные,
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	УчастникЗначение = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка");
	ПредставлениеУчастника = "";
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Сотрудники") Тогда
		УчастникЗначение = ВыбранноеЗначение;
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("ЭлементСпискаЗначений")
		И ТипЗнч(ВыбранноеЗначение.Значение) = Тип("СправочникСсылка.Сотрудники") Тогда
		УчастникЗначение = ВыбранноеЗначение.Значение;
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		ПредставлениеУчастника = ВыбранноеЗначение;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УчастникЗначение) Тогда
		ЧастиПредставленияУчастника = СтрРазделить(Строка(УчастникЗначение), " ");
		ПредставлениеУчастника = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(СтрШаблон("%1 %2 %3",
			ЧастиПредставленияУчастника[0],
			ЧастиПредставленияУчастника[1],
			ЧастиПредставленияУчастника[2]));
	КонецЕсли;
	
	Элементы.СпикерыАвтопротокол.ТекущиеДанные.ПредставлениеУчастника = ПредставлениеУчастника;
	Элементы.СпикерыАвтопротокол.ТекущиеДанные.Участник = УчастникЗначение;
	
КонецПроцедуры

&НаКлиенте
Процедура СпикерыАвтопротоколПредставлениеУчастникаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных,
	Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если ОтборСотрудников.Количество() > 0 Тогда
			ДанныеВыбора = СформироватьДанныеВыбораУчастника(Текст);
			Если ДанныеВыбора.Количество() = 0 Тогда
				ДанныеВыбора.Добавить(Текст);
			КонецЕсли;
		Иначе
			ПараметрыПолученияДанных.Вставить("ПравилаКоммуникаций", Ложь);
			РаботаСАдреснойКнигойКлиент.ПодобратьУчастника(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных,
				Ожидание, СтандартнаяОбработка,, Ложь);
			Если ДанныеВыбора.Количество() = 0 Тогда
				ДанныеВыбора.Добавить(Текст);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпикерыАвтопротоколПредставлениеУчастникаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора,
	ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ДанныеВыбора = СформироватьДанныеВыбораУчастника(Текст);
		Если ДанныеВыбора.Количество() = 1 Тогда
			Элементы.СпикерыАвтопротокол.ТекущиеДанные.Участник = ДанныеВыбора[0].Значение;
		Иначе
			ДанныеВыбора.Добавить(Текст);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	ОчиститьСообщения();
	
	Если РежимПолученияАвтопротокола Тогда
		
		МассивСпикеров = Новый Массив;
		
		Для Каждого Спикер Из СпикерыАвтопротокол Цикл
			
			Если Не ЗначениеЗаполнено(Спикер.ПредставлениеУчастника) Тогда
				
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не указано имя спикера.'"),,
					"СпикерыАвтопротоколПредставлениеУчастника",
					"СпикерыАвтопротокол.ПредставлениеУчастника");
				
				Возврат;
				
			КонецЕсли;
			
			ОписаниеСпикера = Новый Структура("initialName, newName, role");
			
			ОписаниеСпикера.initialName = Спикер.ИзРасшифровки;
			ОписаниеСпикера.newName = Спикер.ПредставлениеУчастника;
			ОписаниеСпикера.role = ?(Спикер.Важный, "true", "");
			
			МассивСпикеров.Добавить(ОписаниеСпикера);
			
		КонецЦикла;
		
		СпикерыДляАвтопротокола = Новый Структура("СпикерыДляАвтопротокола", МассивСпикеров);
		
		Закрыть(СпикерыДляАвтопротокола);
		
	Иначе
		
		ПараметрыЗакрытия = Новый Соответствие;
		
		Если ЗначениеЗаполнено(ФайлНаРасшифровку) Тогда
			ПараметрыЗакрытия.Вставить(ФайлНаРасшифровку, КоличествоСпикеров);
		Иначе
			Для Каждого Строка Из СпикерыРасшифровка Цикл
				ПараметрыЗакрытия.Вставить(Строка.Файл, Строка.Количество);
			КонецЦикла;
		КонецЕсли;
		
		Закрыть(ПараметрыЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСпикеровДляПолученияРасшифровки()
	
	Если ТипЗнч(Параметры.ФайлыНаРасшифровку) = Тип("СписокЗначений") Тогда
		
		Для Каждого Файл Из Параметры.ФайлыНаРасшифровку Цикл
			Строка = СпикерыРасшифровка.Добавить();
			Строка.Файл = Файл.Значение;
		КонецЦикла;
		
	Иначе
		
		ФайлНаРасшифровку = Параметры.ФайлыНаРасшифровку;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпикеровДляПолученияАвтопротокола()
	
	ВерсияФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ФайлНаПолучениеАвтопротокола, "ТекущаяВерсия");
	
	СпикерыФайлаХранилище = Таймлист.ДанныеРаботыСервиса(ВерсияФайла, "Спикеры").Спикеры;
	СпикерыФайлаТаблица = СпикерыФайлаХранилище.Получить();
	
	Для Каждого Спикер Из СпикерыФайлаТаблица Цикл
		Строка = СпикерыАвтопротокол.Добавить();
		Строка.ИзРасшифровки = Спикер.initialName;
		Строка.Важный = ?(Спикер.role = "true", Истина, Ложь);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция СформироватьДанныеВыбораУчастника(Текст = "")
	
	ДанныеВыбора = Новый СписокЗначений;
	Для Каждого Сотрудник Из ОтборСотрудников Цикл
		Если Текст <> "" И НРег(Лев(Сотрудник, СтрДлина(Текст))) <> НРег(Текст) Тогда
			Продолжить;
		КонецЕсли;
		ДанныеВыбора.Добавить(Сотрудник, Строка(Сотрудник));
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции

#Область СлужебныеПроцедурыИФункции_МобильныйКлиент

&НаСервере
Процедура МК_НастроитьЭлементыФормы()
	
	СворачиваниеЭлементовПоВажности = СворачиваниеЭлементовФормыПоВажности.НеИспользовать;
	ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Половинный;
	
	МК_ЭлементыСтиля = МК_ПовтИсп.ЭлементыСтиля();
	
	МК.ОформитьАкцентнуюКнопку(Элементы.Готово);
	Элементы.Отмена.Видимость = Ложь;
	
	Элементы.МК_ДекорацияОтступПередПодвалом.Видимость = Истина;
	Элементы.ОсновнаяГруппа.ЦветФона = ЦветаСтиля.МК_ЦветФонаГруппы;
	
	Элементы.СпикерыРасшифровка.Шапка = Ложь;
	Элементы.СпикерыАвтопротокол.Шапка = Ложь;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
