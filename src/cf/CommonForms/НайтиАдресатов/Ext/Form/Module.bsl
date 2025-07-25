﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущиеПараметры = ПараметрыРаспознаванияРечи.ТекущиеПараметры(ЭтотОбъект);
	
	РаботаСРечьюДокументооборот.ОбновитьГрамматикуРаспознаванияРечиДляПользователей();
	
	АдресТаблицыСущностей = ПоместитьВоВременноеХранилище(ТаблицаСущностей(), УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
#Если ТолстыйКлиентУправляемоеПриложение Тогда
	ВызватьИсключение НСтр("ru = 'Распознавание речи не поддерживается в толстом клиенте.'");
#Иначе
	ИспользоватьТолькоДополнительныеГрамматики = Истина;
	ПараметрыМодели = Новый ПараметрыМоделиРаспознаванияРечи;
	ВариантИспользования = ВариантИспользованияРасположенияРаботыСРечью.Авто;
	
	НачатьРаспознавание();
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	РаботаСРечьюБМОКлиент.ОстановитьПотоковоеРаспознавание(УникальныйИдентификатор);
	РаботаСРечьюЖурналированиеКлиент.ОчиститьЖурнал(УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРаспознанныеСущности

&НаКлиенте
Процедура ПолучателиПолучательПриИзменении(Элемент)
	
	ТекущиеДанные = Элемент.Родитель.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДопСведенияПоИдентификаторуСтроки(Элемент.Родитель.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПолучательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Элемент.СписокВыбора.ЗагрузитьЗначения(Элемент.Родитель.ТекущиеДанные.ДоступныеУчетныеЗаписи.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПриАктивизацииСтроки(Элемент)
	
	ИзменитьСостояниеФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Пожаловаться(Команда)
	
	РаботаСРечьюЖурналированиеКлиент.СформироватьПисьмо(УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьЗапись(Команда)
	
	НачатьРаспознавание();
	
КонецПроцедуры

&НаКлиенте
Процедура ОстановитьЗапись(Команда)
	
	ОстановитьЗапись = Истина;
	ВыполняетсяРаспознавание = Не ПустаяСтрока(ТекущаяФраза);
	
	Если Не ВыполняетсяРаспознавание Тогда
		РаботаСРечьюБМОКлиент.ОстановитьПотоковоеРаспознавание(УникальныйИдентификатор);
	КонецЕсли;
	
	ИзменитьСостояниеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВФорму(Команда)
	
	Адресаты = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из Получатели Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Контакт) Тогда
			Продолжить;
		КонецЕсли;
		
		Адресат = Новый Структура;
		
		Адресат.Вставить("ТипАдреса", СтрокаТаблицы.ТипАдреса);
		Адресат.Вставить("ИмяПолучателя", СтрокаТаблицы.Контакт);
		
		Адресаты.Добавить(Адресат);
		
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("Адресаты", Адресаты);
	Если ПереноситьТекст Тогда 
		Результат.Вставить("Текст", ЗаконченнаяФраза);
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьФразу(Команда)
	
	Если ВыполняетсяРедактирование Тогда
		
		ВыполняетсяРедактирование = Ложь;
		ИзменитьСостояниеФормы();
		
	Иначе
		
		ВыполняетсяРедактирование = Истина;
		ИзменитьСостояниеФормы();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НачатьРаспознавание()
	
#Если ТолстыйКлиентУправляемоеПриложение Тогда
	ВызватьИсключение НСтр("ru = 'Распознавание речи не поддерживается в толстом клиенте.'");
#Иначе
	ПараметрыМодели = ПараметрыРаспознаванияРечиКлиент.ПараметрыМодели(ТекущиеПараметры);
	ВариантИспользования = ПараметрыРаспознаванияРечиКлиент.ВариантИспользования(ТекущиеПараметры);
	
	ПараметрыРаспознавания = Новый ПараметрыПотоковогоРаспознаванияРечи;
	ПараметрыРаспознавания.ДополнительныеГрамматики.Добавить("ГрамматикаПользователи");
	ПараметрыРаспознавания.ИспользоватьТолькоДополнительныеГрамматики = ИспользоватьТолькоДополнительныеГрамматики;
	ПараметрыРаспознавания.ОбработчикОстановкиАудиозаписи =
		Новый ОписаниеОповещения("ПриОстановкеАудиозаписи", ЭтотОбъект);
	
	Попытка
		РаботаСРечьюБМОКлиент.НачатьПотоковоеРаспознавание(
			УникальныйИдентификатор,
			Новый ОписаниеОповещения(
				"ПриПолученииРезультатаРаспознавания", ЭтотОбъект, ,
				"ПриОбработкеОшибкиРаспознавания", ЭтотОбъект),
			ПараметрыМодели,
			ВариантИспользования,
			ПараметрыРаспознавания
		);
		
		ОстановитьЗапись = Ложь;
		ВыполняетсяРаспознавание = Истина;
		ВремяНачалаРаспознавания = ТекущаяУниверсальнаяДатаВМиллисекундах();
		
	Исключение
		ПриОбработкеОшибкиРаспознавания(ИнформацияОбОшибке(), Истина, Неопределено);
	КонецПопытки;
	
	ИзменитьСостояниеФормы();
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПолученииРезультатаРаспознавания(РезультатРаспознавания, ПродолжитьРаспознавание, Контекст) Экспорт
	
	ВремяНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	ТекущаяФраза = РезультатРаспознавания.ДанныеФраз[0].Фраза;
	Если РезультатРаспознавания.РаспознаваниеФразыЗавершено Тогда
		
		ПерезаполнитьСущностиВТексте();
		
		ЗаконченнаяФраза = ?(ПустаяСтрока(ЗаконченнаяФраза), "", ЗаконченнаяФраза + " ") + ТекущаяФраза;
		ТекущаяФраза = "";
		
		Если (ОстановитьЗапись Или ОстановитьПослеОкончанияФразы) Тогда
			ПродолжитьРаспознавание = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	ИзменитьСостояниеФормы();
	
	ВремяКонца = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	РаботаСРечьюЖурналированиеКлиент.ДобавитьРезультатРаспознавания(
		УникальныйИдентификатор,
		РезультатРаспознавания,
		ВремяНачала,
		ВремяКонца
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОбработкеОшибкиРаспознавания(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	РаботаСРечьюЖурналированиеКлиент.ДобавитьИсключение(УникальныйИдентификатор, ИнформацияОбОшибке);
	
	ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОстановкеАудиозаписи(РезультатАудиозаписи, Контекст) Экспорт
	
	ВремяКонца = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	РаботаСРечьюЖурналированиеКлиент.ДобавитьАудио(
		УникальныйИдентификатор,
		РезультатАудиозаписи,
		ПараметрыМодели,
		ВариантИспользования,
		ВремяНачалаРаспознавания,
		ВремяКонца
	);
	
	ВыполняетсяРаспознавание = Ложь;
	ИзменитьСостояниеФормы();
	
КонецПроцедуры

&НаСервере
Функция ПерезаполнитьСущностиВТексте()
	
	Результат = СемантическийАнализ.ПолучитьСущностиВТексте(ТекущаяФраза, ПолучитьИзВременногоХранилища(АдресТаблицыСущностей));
	ВыполнитьПерезаполнениеРаспознанныхСущностейСервер(Результат);
	
КонецФункции

&НаСервереБезКонтекста
Функция ТаблицаСущностей()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Ссылка,
		|	""|"" + СТРЗАМЕНИТЬ(Сотрудники.Наименование, "" "", ""||"") + ""|"" КАК СтрокаДляПоиска
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Действует
		|	И НЕ Сотрудники.ПометкаУдаления";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаКлиенте
Процедура ИзменитьСостояниеФормы()
	
	Если ВыполняетсяРаспознавание Тогда
		Элементы.ПеренестиВФорму.Доступность = Ложь;
		
		Элементы.НачатьЗапись.Видимость = Ложь;
		Элементы.ОстановитьЗапись.Видимость = Истина;
		
		Элементы.РедактироватьФразу.Доступность = Ложь;
		
	Иначе
		Элементы.ПеренестиВФорму.Доступность = Истина;
		
		Элементы.НачатьЗапись.Видимость = Истина;
		Элементы.ОстановитьЗапись.Видимость = Ложь;
		
		Элементы.РедактироватьФразу.Доступность = Истина;
		
	КонецЕсли;
	
	Если ОстановитьЗапись Тогда
		Элементы.ОстановитьЗапись.Доступность = Ложь;
	Иначе
		Элементы.ОстановитьЗапись.Доступность = Истина;
	КонецЕсли;
	
	Если ВыполняетсяРедактирование Тогда
		
		Элементы.ВариантыПредставленияФразы.ТекущаяСтраница = Элементы.Редактирование;
		Элементы.РедактироватьФразу.Заголовок = НСтр("ru='Завершить'");
		Элементы.ПеренестиВФорму.Доступность = Ложь;
		Элементы.НачатьЗапись.Доступность = Ложь;
		
	Иначе
		
		Элементы.ВариантыПредставленияФразы.ТекущаяСтраница = Элементы.Просмотр;
		Элементы.РедактироватьФразу.Заголовок = НСтр("ru='Редактировать'");
		Элементы.ПеренестиВФорму.Доступность = Истина;
		Элементы.НачатьЗапись.Доступность = Истина;
		
	КонецЕсли;
	
	ПредставлениеЗаконченнаяФраза = ВыделитьОформлением(ЗаконченнаяФраза);
	ПредставлениеТекущаяФраза = Новый ФорматированнаяСтрока(
		?(ПустаяСтрока(ЗаконченнаяФраза), "", " ") + ТекущаяФраза, , 
		Новый Цвет(0, 110, 31)
	);
	Если ВыполняетсяРаспознавание Тогда
		ПредставлениеСлушаю = Новый ФорматированнаяСтрока(
			?(ПустаяСтрока(ТекущаяФраза), "", " ") + НСтр("ru = 'Слушаю...'"), , 
			Новый Цвет(153, 153, 153)
		);
	Иначе
		ПредставлениеСлушаю = "";
	КонецЕсли;
	ПредставлениеФразы = Новый ФорматированнаяСтрока(
		ПредставлениеЗаконченнаяФраза,
		ПредставлениеТекущаяФраза,
		ПредставлениеСлушаю
	);
	
КонецПроцедуры

&НаКлиенте
Функция ВыделитьОформлением(Строка)
	
	ТекущиеДанные = Элементы.Получатели.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат Новый ФорматированнаяСтрока(Строка);
	КонецЕсли;
	
	ИндексНачала = ТекущиеДанные.ИндексНачало;
	ИндексКонца = ТекущиеДанные.ИндексКонец;
	
	ПервыйСимвол = 0;
	ЧастиСтроки = Новый Массив;
	ОбработаннаяСтрока = Новый ФорматированнаяСтрока("");
	
	НеобрабатываемаяЧасть = Сред(Строка, ПервыйСимвол + 1, ИндексНачала - ПервыйСимвол);
	ВыделяемаяЧасть = Сред(Строка, ИндексНачала + 1, ИндексКонца - ИндексНачала);
	ПервыйСимвол = ИндексКонца;
	
	ВыделяемаяЧастьФорматированная = Новый ФорматированнаяСтрока(
		ВыделяемаяЧасть, , , 
		Новый Цвет(255, 255, 0)
	);
	
	ОбработаннаяСтрока = Новый ФорматированнаяСтрока(
			ОбработаннаяСтрока,
			НеобрабатываемаяЧасть,
			ВыделяемаяЧастьФорматированная
	);
	
	Возврат Новый ФорматированнаяСтрока(
		ОбработаннаяСтрока,
		Прав(Строка, СтрДлина(Строка) - ПервыйСимвол)
	);
	
КонецФункции

&НаСервере
Процедура ВыполнитьПерезаполнениеРаспознанныхСущностейСервер(Результат)
	
	ПоправкаИндекса = ?(ПустаяСтрока(ЗаконченнаяФраза), 0, СтрДлина(ЗаконченнаяФраза) + 1);
	
	Для Каждого Сущность Из Результат.РезультатЗапроса Цикл 
		
		Если Сущность.Тип = "$УчетныеЗаписи" Тогда
			
			НовыйАдресат = Получатели.Добавить();
			НовыйАдресат.ТипАдреса = Перечисления.ТипыАдресатов.Кому;
			НовыйАдресат.КакЕсть = Сущность.КакЕсть;
			НовыйАдресат.ДоступныеУчетныеЗаписи.ЗагрузитьЗначения(Сущность.Значение);
			НовыйАдресат.ИндексНачало = ПоправкаИндекса + Сущность.ИндексНачало;
			НовыйАдресат.ИндексКонец = ПоправкаИндекса + Сущность.ИндексКонец;
			
			Если Сущность.Значение.Количество() = 1 Тогда
				НовыйАдресат.Контакт = Сущность.Значение[0];
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Загрузка доп сведений
	Для Каждого Получатель Из Получатели Цикл
		ЗаполнитьДопСведения(Получатель);
	КонецЦикла;
	
	// Оформление
	
	УсловноеОформление.Элементы.Очистить();
	Для Каждого Получатель Из Получатели Цикл
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ПолучателиКонтакт");
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Получатели.КакЕсть");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Получатель.КакЕсть;
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Получатели.ИндексНачало");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Получатель.ИндексНачало;
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Получатели.Контакт");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(255, 0, 0));
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", СтрШаблон(НСтр("ru = 'Не сопоставлен: %1'"), Получатель.КакЕсть));
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДопСведенияПоИдентификаторуСтроки(Идентификатор)
	
	Получатель = Получатели.НайтиПоИдентификатору(Идентификатор);
	ЗаполнитьДопСведения(Получатель);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДопСведения(Получатель)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЭтоАдресВременногоХранилища(Получатель.Фотография) Тогда
		УдалитьИзВременногоХранилища(Получатель.Фотография);
	КонецЕсли;
	
	Получатель.Фотография = "";
	Получатель.ОписаниеКонтакта = "";        
	
	// Получатель.Контакт - СправочникСсылка.Сотрудники.
	
	Если ЗначениеЗаполнено(Получатель.Контакт) Тогда 
		
		//КонтейнерФотографии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Получатель.Контакт, "ФизЛицо");
		КонтейнерФотографии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Получатель.Контакт, "Владелец");
		
		ФайлФотографии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтейнерФотографии, "ФайлФотографии");
		
		Если ФайлФотографии <> Неопределено Тогда 
			ДвоичныеДанные = ФайлФотографии.Получить();
			Получатель.Фотография = ПоместитьВоВременноеХранилище(
				ПолучитьТрансформированнуюКартинку(ДвоичныеДанные, Неопределено, 50), УникальныйИдентификатор);
		КонецЕсли;
		
		Подразделение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Получатель.Контакт, "Подразделение");
		Получатель.ОписаниеКонтакта = Строка(Подразделение);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Получатель.Фотография) Тогда
		ДвоичныеДанные = БиблиотекаКартинок.ПользовательСмайл.ПолучитьДвоичныеДанные();
		Получатель.Фотография = ПоместитьВоВременноеХранилище(
			ПолучитьТрансформированнуюКартинку(ДвоичныеДанные, Неопределено, 50), УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТрансформированнуюКартинку(ДвоичныеДанные, Ширина, Высота)
	
	Картинка = Новый Картинка(ДвоичныеДанные);
	ОбрабатываемаяКартинка = Новый ОбрабатываемаяКартинка(Картинка);
	ОбрабатываемаяКартинка.УстановитьРазмер(Ширина, Высота);
	НоваяКартинка = ОбрабатываемаяКартинка.ПолучитьКартинку();
	Возврат НоваяКартинка.ПолучитьДвоичныеДанные();
	
КонецФункции

#КонецОбласти