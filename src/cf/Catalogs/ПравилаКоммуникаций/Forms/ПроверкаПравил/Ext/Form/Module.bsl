﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолеВыбора = Справочники.Сотрудники.ПустаяСсылка();
	НазначениеНастроить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НазначениеПриИзменении(Элемент)
	
	Если ЭтотОбъект[Элемент.Имя] = Неопределено Тогда
		ЭтотОбъект[Элемент.Имя] = НазначениеПоУмолчанию(Элемент.Имя, Элемент.ДоступныеТипы);
	КонецЕсли;
	
	НазначениеНастроить(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура НазначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Элемент.ВыбиратьТип Тогда
		Элемент.ОграничениеТипа = Элемент.ДоступныеТипы;
	КонецЕсли;
	
	Если Элемент.СписокВыбора.Количество() Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьВыборИзСписка(
			Новый ОписаниеОповещения("НазначениеОбработкаОповещения", ЭтотОбъект, Элемент.Имя),
			Элемент.СписокВыбора, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НазначениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если Элемент.СписокВыбора.Количество() Тогда
		СтандартнаяОбработка = Ложь;
		
		Если Текст <> "" Тогда
			Подстрока = НРег(Текст);
			Длина = СтрДлина(Подстрока);
			//@skip-check new-color
			ЦветВыделения = Новый Цвет(0, 153, 0);
			
			ДанныеВыбора = Новый СписокЗначений;
			Для Каждого Выборка Из Элемент.СписокВыбора Цикл
				Если НРег(Лев(Выборка.Представление, Длина)) = Подстрока Тогда
					//@skip-check new-font
					ДанныеВыбора.Добавить(Выборка.Значение, 
						Новый ФорматированнаяСтрока(
							Новый ФорматированнаяСтрока(
								Лев(Выборка.Представление, Длина),
								Новый Шрифт(,, Истина),
								ЦветВыделения),
							Сред(Выборка.Представление, Длина + 1)));
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеВыбораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСАдреснойКнигойКлиент.ВыбратьУчастника(
		ЭтотОбъект,
		Элемент,
		СтандартнаяОбработка,
		ПолеВыбора,,,
		Новый Структура("ПравилаКоммуникаций", КонтекстВыбора()));
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеВыбораОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если РаботаСАдреснойКнигойКлиент.ОбработатьВыборУчастника(
			ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Тогда
		
		ПолеВыбора = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеВыбораАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ПараметрыПолученияДанных.Вставить("ПравилаКоммуникаций", КонтекстВыбора());
	
	РаботаСАдреснойКнигойКлиент.ПодобратьУчастника(
		ЭтотОбъект,
		Элемент,
		Текст,
		ДанныеВыбора,
		ПараметрыПолученияДанных,
		Ожидание,
		СтандартнаяОбработка,
		ПолеВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеВыбораОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ПараметрыПолученияДанных.Вставить("ПравилаКоммуникаций", КонтекстВыбора());
	
	РаботаСАдреснойКнигойКлиент.ПодобратьУчастника(
		ЭтотОбъект,
		Элемент,
		Текст,
		ДанныеВыбора,
		ПараметрыПолученияДанных,
		0,
		СтандартнаяОбработка,
		ПолеВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеВыбораПриИзменении(Элемент)
	
	Если ПолеВыбора = Неопределено Тогда
		ПолеВыбора = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициаторОбработкаВыбора(Элемент, ВыбранноеЗначение, ДополнительныеДанные, СтандартнаяОбработка)
	
	СотрудникиКлиент.СотрудникОбработкаВыбора(ЭтотОбъект, "Инициатор", ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПравила

&НаКлиенте
Процедура ПравилаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элементы.Правила.ТекущиеДанные.Значение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НазначениеОбработкаОповещения(ВыбранноеЗначение, ИмяЭлемента) Экспорт
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		ЭтотОбъект[ИмяЭлемента] = ВыбранноеЗначение.Значение;
		НазначениеПриИзменении(Элементы[ИмяЭлемента]);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НазначениеНастроить(ЭлементИмя = Неопределено)
	
	Если ЭлементИмя <> Неопределено Тогда
		Элемент = Элементы[ЭлементИмя];
	КонецЕсли;
	
	Если Элемент = Неопределено Или Элемент.Имя = "Предмет" Тогда
		Если Предмет = ПредопределенноеЗначение("Перечисление.ПравилаКоммуникацийПредметы.Документ") Тогда
			Элементы.Вид.ДоступныеТипы = Новый ОписаниеТипов(
				"СправочникСсылка.ВидыДокументов, СправочникСсылка.ТематикиДокументов");
		ИначеЕсли Предмет = ПредопределенноеЗначение("Перечисление.ПравилаКоммуникацийПредметы.Задача") Тогда
			Элементы.Вид.ДоступныеТипы = Новый ОписаниеТипов(
				"СправочникСсылка.ВидыЗадач");
		ИначеЕсли Предмет = ПредопределенноеЗначение("Перечисление.ПравилаКоммуникацийПредметы.Мероприятие") Тогда
			Элементы.Вид.ДоступныеТипы = Новый ОписаниеТипов(
				"СправочникСсылка.ВидыМероприятий");
		Иначе
			Элементы.Вид.ДоступныеТипы = Новый ОписаниеТипов(
				"СправочникСсылка.ВидыДокументов,
				|СправочникСсылка.ТематикиДокументов,
				|СправочникСсылка.ВидыЗадач,
				|СправочникСсылка.ВидыМероприятий");
		КонецЕсли;
		Вид = Элементы.Вид.ДоступныеТипы.ПривестиЗначение(Вид);
		
		ПараметрВыбора = Новый ПараметрВыбора(
			"Отбор.Ссылка",
			Справочники.ПравилаКоммуникаций.ПоддерживаемыеВидыПредметов(Предмет));
		
		Элементы.Вид.ПараметрыВыбора =
			Новый ФиксированныйМассив(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрВыбора));
			
		Справочники.ПравилаКоммуникаций.НастроитьПолеПозиции(ЭтотОбъект);
	КонецЕсли;
	
	Если Элемент = Неопределено Или Элемент.Имя = "Вид" Тогда
		Справочники.ПравилаКоммуникаций.НастроитьПолеПозиции(ЭтотОбъект);
	КонецЕсли;
	
	Если Элемент = Неопределено Или Элемент.Имя = "Предмет" Или Элемент.Имя = "Позиция" Тогда
		Элементы.Этап.Доступность = НазначениеДоступенЭтап(Предмет, Позиция);
		Если Элементы.Этап.Доступность Тогда
			Если Элементы.Этап.СписокВыбора.Количество() = 0 Тогда
				Для Каждого Выборка Из РаботаСЭтапамиВызовСервера.ДанныеВыбора("", Неопределено, Новый Массив) Цикл
					ЗаполнитьЗначенияСвойств(Элементы.Этап.СписокВыбора.Добавить(), Выборка);
				КонецЦикла;		
			КонецЕсли;
		Иначе
			Этап = НазначениеПоУмолчанию("Этап", Элементы.Этап.ДоступныеТипы);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НазначениеПоУмолчанию(ИмяПоля, ТипЗначения)
	
	Если ИмяПоля = "Позиция" Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ПравилаКоммуникацийПредметы.ПустаяСсылка");
	ИначеЕсли ИмяПоля = "Вид" Тогда
		Возврат ПредопределенноеЗначение("Справочник.ВидыДокументов.ПустаяСсылка");
	ИначеЕсли ТипЗначения.Типы().Количество() > 1 Тогда
		Возврат Новый(ТипЗначения.Типы()[0]);
	Иначе
		Возврат ТипЗначения.ПривестиЗначение();
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция НазначениеДоступенЭтап(Предмет, Позиция)
	
	Возврат Предмет <> Перечисления.ПравилаКоммуникацийПредметы.Задача
			И (ЗначениеЗаполнено(Позиция)
				И (Позиция = Перечисления.ФункцииУчастниковСогласования.Согласующий
					Или Позиция = Перечисления.ФункцииУчастниковПодписания.Подписывающий));
	
КонецФункции

&НаКлиенте
Функция КонтекстВыбора()
	
	Контекст = ПоляНазначения();
	ЗаполнитьЗначенияСвойств(Контекст, ЭтотОбъект);
	
	Если ТипЗнч(Вид) = Тип("СправочникСсылка.ТематикиДокументов") Тогда
		Контекст.Вставить("Тематика", Вид);
		Контекст.Вставить("Вид", ?(ЗначениеЗаполнено(Вид),
			ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Вид, "ВидДокумента"),
			ПредопределенноеЗначение("Справочник.ВидыДокументов.ПустаяСсылка")));
	КонецЕсли;
	
	Возврат Контекст;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПоляНазначения()
	
	ПоляНазначения = Новый Структура;
	ПоляНазначения.Вставить("РежимОтладки", Истина);
	ПоляНазначения.Вставить("Предмет", Неопределено);
	ПоляНазначения.Вставить("Позиция", Неопределено);
	ПоляНазначения.Вставить("Этап", Неопределено);
	ПоляНазначения.Вставить("Вид", Неопределено);
	ПоляНазначения.Вставить("Инициатор", Неопределено);
	
	Возврат ПоляНазначения;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Контекст = ПоляНазначения();
	ЗаполнитьЗначенияСвойств(Контекст, ЭтотОбъект);
	
	Если ТипЗнч(Вид) = Тип("СправочникСсылка.ТематикиДокументов") Тогда
		Контекст.Вставить("Тематика", Вид);
		Контекст.Вставить("Вид", ?(ЗначениеЗаполнено(Вид),
			ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Вид, "ВидДокумента"),
			ПредопределенноеЗначение("Справочник.ВидыДокументов.ПустаяСсылка")));
	КонецЕсли;
	
	Правила.ЗагрузитьЗначения(Справочники.ПравилаКоммуникаций.ПодобратьПравило(Контекст, Истина));
	
КонецПроцедуры

#КонецОбласти
