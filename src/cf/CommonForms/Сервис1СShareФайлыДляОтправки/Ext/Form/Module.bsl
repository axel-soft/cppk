﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.ЭлектронныйДокумент) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЭлектронныйДокумент = Параметры.ЭлектронныйДокумент; // СправочникСсылка.ДокументыПредприятия
	РеквизитыДО = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭлектронныйДокумент, "Организация, Контрагент,
		|ВидДокумента, ДатаРегистрации");
	НастройкиВидаДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РеквизитыДО.ВидДокумента, "ВестиУчетСторон,
		|ЯвляетсяДоговором, ЯвляетсяИсходящейКорреспонденцией, ВестиУчетПоОрганизациям"); // Булево
	
	ИнтеграцияShareДокументооборот.ПроверитьЗаполнениеРеквизитовДокумента(ЭлектронныйДокумент, РеквизитыДО,
		НастройкиВидаДокумента, Отказ);	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.РезультатПроверкиПакета <> Неопределено
		И Параметры.РезультатПроверкиПакета.ПревышенРазмерПакета Тогда
		ПревышенРазмерПакета = Истина;
		ДанныеФайлов = Параметры.РезультатПроверкиПакета.ДанныеФайловКПубликации;
		РазмерПакетаБезПрисоединенныхФайлов = РазмерФайлаИзБайтовВКилобайты(
			Параметры.РезультатПроверкиПакета.РазмерПакетаБезПрисоединенныхФайлов);
		МаксимальныйРазмерПакетаВКилоБайтах = РазмерФайлаИзБайтовВКилобайты(
			Параметры.РезультатПроверкиПакета.МаксимальныйРазмерПакета);
	Иначе
		МаксимальныйРазмерПакетаВКилоБайтах = 0;
		ДанныеФайлов = Новый Массив;
		ПараметрыДокумента = ИнтеграцияShare.ПараметрыОбъектаУчетаКПубликации(ЭлектронныйДокумент);
		ДанныеФайлов = ПараметрыДокумента.ДанныеФайлов;
	КонецЕсли;
	
	ПроверятьПревышениеРазмераПакета = ЗначениеЗаполнено(МаксимальныйРазмерПакетаВКилоБайтах);
	ПревышенРазмерПакета = ПроверятьПревышениеРазмераПакета И ПревышенРазмерПакета;
	
	Если Не ЗначениеЗаполнено(ДанныеФайлов) Тогда
		Возврат; // Нет дополнительных файлов по документу для выбора к публикации.
	КонецЕсли;
	
	ЕстьФайлыКВыбору = Ложь;
	ЗаполнитьДополнительныеФайлы(ДанныеФайлов, ЕстьФайлыКВыбору);
	
	Если Не ЕстьФайлыКВыбору Тогда
		Возврат; // Файлы не поддерживаются.
	КонецЕсли;
	
	ЕстьДополнительныеФайлы = Истина;
	
	УстановитьВидимостьОшибкиПревышенияРазмера(ПревышенРазмерПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЕстьДополнительныеФайлы Тогда
		РассчитатьИтогиВыбранныхДополнительныхФайлов();
		Если Не ПревышенРазмерПакета И ВыбраноФайлов = 1 Тогда
			Отказ = Истина;
			ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗакрытии, РезультатВыбораФайловДокументаКПубликации());
		КонецЕсли;	
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Нет файлов, отмеченных к отправке.'"));
		Отказ = Истина;
		Возврат;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДополнительныеФайлы

&НаКлиенте
Процедура ДополнительныеФайлыИндексВыбораФайлаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДополнительныеФайлы.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Не ТекущиеДанные.ЭтоГруппаФайлов Тогда
		Если ТекущиеДанные.ИндексВыбораФайла = 2 Тогда
			ТекущиеДанные.ИндексВыбораФайла = 0;
		КонецЕсли;
		ТекущиеДанные.ФайлВыбран = ТекущиеДанные.ИндексВыбораФайла = 1;
		
	Иначе // снимаем/устанавливаем по всем файлам
		ГруппаФайлов = ДополнительныеФайлы;
		
		Если ТекущиеДанные.ИндексВыбораФайла = 2 Тогда
			ИндексВыбораФайла = 0;
			ТекущиеДанные.ИндексВыбораФайла = ИндексВыбораФайла;
		Иначе
			ИндексВыбораФайла = ТекущиеДанные.ИндексВыбораФайла; // Число
		КонецЕсли;
		
		Для Каждого СтрокаФайла Из ГруппаФайлов.ПолучитьЭлементы() Цикл
			Если Не СтрокаФайла.РасширениеФайлаРазрешено Тогда
				Продолжить;
			КонецЕсли;
			СтрокаФайла.ИндексВыбораФайла = ИндексВыбораФайла;
			СтрокаФайла.ФайлВыбран        = ИндексВыбораФайла = 1;
		КонецЦикла;

	КонецЕсли;
	
	РассчитатьИтогиВыбранныхДополнительныхФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеФайлыИмяФайлаОткрытие(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДополнительныеФайлы.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено
		Или ТекущиеДанные.СсылкаНаФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,ТекущиеДанные.СсылкаНаФайл);

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеФайлыИмяФайлаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) 
	
	Если Поле.Имя <> Элементы.ДополнительныеФайлыИмяФайла.Имя Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ДополнительныеФайлы.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.СсылкаНаФайл = Неопределено Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоделитьсяДокументом(Команда)
	
	Если ПревышенРазмерПакета
		И РазмерПакетаВКилоБайтах > МаксимальныйРазмерПакетаВКилоБайтах Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстПревышенияРазмера());
		Возврат;
	КонецЕсли;
	
	РезультатВыбораФайлов = РезультатВыбораФайловДокументаКПубликации();
	Если РезультатВыбораФайлов.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Нет файлов, отмеченных к отправке.'"));
		Возврат;
	КонецЕсли;
		
	Закрыть(РезультатВыбораФайлов);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	Для Каждого Файл Из ДополнительныеФайлы.ПолучитьЭлементы() Цикл
		Файл.ФайлВыбран = Истина;
		Файл.ИндексВыбораФайла = 1;
	КонецЦикла	
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделение(Команда)
	
	Для Каждого Файл Из ДополнительныеФайлы.ПолучитьЭлементы() Цикл
		Файл.ФайлВыбран = Ложь;
		Файл.ИндексВыбораФайла = 0;
	КонецЦикла	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РассчитатьИтогиВыбранныхДополнительныхФайлов()

	ГруппаФайлов = ДополнительныеФайлы;
	ФайлыВГруппе = ГруппаФайлов.ПолучитьЭлементы();
	
	ВсегоФайлов           = 0;
	ВыбраноФайлов         = 0;
	РазмерВыбранныхФайлов = 0;
	Для Каждого СтрокаФайла Из ФайлыВГруппе Цикл
		
		Если Не СтрокаФайла.РасширениеФайлаРазрешено Тогда
			Продолжить;
		КонецЕсли;

		Если СтрокаФайла.ИндексВыбораФайла = 1 Тогда
			ВыбраноФайлов = ВыбраноФайлов + 1;
			РазмерВыбранныхФайлов = РазмерВыбранныхФайлов + СтрокаФайла.Размер;
		КонецЕсли;
		
		ВсегоФайлов = ВсегоФайлов + 1;
		
	КонецЦикла;
	
	РазмерПакетаВКилоБайтах = РазмерВыбранныхФайлов + РазмерПакетаБезПрисоединенныхФайлов;
	ПревышенРазмерПакета = ПроверятьПревышениеРазмераПакета
		И МаксимальныйРазмерПакетаВКилоБайтах < РазмерПакетаВКилоБайтах;
	
	УставновитьТекстВПодвалеДополнительныеФайлы();
	УстановитьВидимостьОшибкиПревышенияРазмера(ПревышенРазмерПакета);
	
КонецПроцедуры

&НаКлиенте
Функция РезультатВыбораФайловДокументаКПубликации()
	
	Результат = Новый Массив; // Массив Из СправочникСсылка.Файлы
	
	ГруппаФайлов = ДополнительныеФайлы;
	КэшФайлов = Новый Массив; // Массив Из СправочникСсылка.Файлы 
	Для Каждого СтрокаФайла Из ГруппаФайлов.ПолучитьЭлементы() Цикл
		
		Если Не СтрокаФайла.ФайлВыбран Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеФайла = ИнтеграцияShareКлиентСервер.НовыеДанныеФайлаДляВыбораКПубликации();
		ЗаполнитьЗначенияСвойств(ДанныеФайла, СтрокаФайла);
		Результат.Добавить(ДанныеФайла);
		КэшФайлов.Добавить(СтрокаФайла.СсылкаНаФайл);
		
	КонецЦикла;
	
	 ЗаписатьКэшФайлов(КэшФайлов);
	
	Возврат Результат;
	
КонецФункции

// Записвает файлы в РегистрСведений.Сервис1СShareКэшФайловОтправки.
// 
// Параметры:
//  КэшФайлов - Массив Из СправочникСсылка.Файлы
//
&НаСервере
Процедура ЗаписатьКэшФайлов(КэшФайлов)
	
	Если КэшФайлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
		
	РегистрыСведений.Сервис1СShareКэшФайловОтправки.ЗаписатьФайлы(ЭлектронныйДокумент, КэшФайлов);	
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьДополнительныеФайлы(Знач ДанныеФайлов, ЕстьФайлыКВыбору)
	
	КэшФайлов = Новый Соответствие;
	Для Каждого ДанныеФайла Из ДанныеФайлов Цикл
		
		Если ПревышенРазмерПакета И Не ДанныеФайла.ФайлВыбран Тогда
			Продолжить; // Отображаем только выбранные ранее файлы.
		КонецЕсли;
		
		НоваяСтрока = ДополнительныеФайлы.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеФайла);
		НоваяСтрока.ФайлВыбран = Истина;
		
		НоваяСтрока.ИндексВыбораФайла   = ?(НоваяСтрока.ФайлВыбран, 1, 0);
		НоваяСтрока.ИндексКартинкиФайла = ИнтеграцияShareКлиентСервер.ПолучитьИндексПиктограммыФайла(
			НоваяСтрока.Расширение);
		НоваяСтрока.ИмяФайла            = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
			ДанныеФайла.Наименование, ДанныеФайла.Расширение);
		
		НоваяСтрока.РасширениеФайлаРазрешено = ИнтеграцияShare.РасширениеФайлаДоступно(
			НоваяСтрока.Расширение, НоваяСтрока.ДвоичныеДанныеФайла);
			
		Если НоваяСтрока.РасширениеФайлаРазрешено = Ложь Тогда
			ШаблонТекста = НСтр("ru = '(тип файла недоступен для отправки)'");
			НоваяСтрока.ИмяФайла = СтрШаблон("%1 %2", НоваяСтрока.ИмяФайла, ШаблонТекста);
			НоваяСтрока.ФайлВыбран = Ложь;
		Иначе
			ЕстьФайлыКВыбору = Истина;
		КонецЕсли;
		
		НоваяСтрока.Размер = РазмерФайлаИзБайтовВКилобайты(ДанныеФайла.ДвоичныеДанныеФайла.Размер());
		КэшФайлов.Вставить(ДанныеФайла.СсылкаНаФайл, НоваяСтрока.ПолучитьИдентификатор());
	КонецЦикла;
	
	ЗаполнитьДополнитеныеСвойстваФайлов(КэшФайлов);
	
	Если Не ЕстьФайлыКВыбору Тогда
		ДанныеФайлов = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// Заполнить дополнительные свойства файлов.
// 
// Параметры:
//  КэшФайлов - Соответствие Из КлючИЗначение:
// * Ключ - СправочникСсылка.Файлы
// * Значение - Число - Идентификатор строки дерева
//
&НаСервере
Процедура ЗаполнитьДополнитеныеСвойстваФайлов(КэшФайлов)
	
	МассивФайлов = Новый Массив; // Массив Из СправочникСсылка.Файлы
	Для Каждого ФайлСтрока Из КэшФайлов Цикл
		МассивФайлов.Добавить(ФайлСтрока.Ключ);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Файлы.Ссылка КАК Файл,
		|	ЕСТЬNULL(СведенияОФайлахДокументооборот.ЯвляетсяОригиналом, ЛОЖЬ) КАК ЭтоОригинал
		|ИЗ
		|	РегистрСведений.СведенияОФайлахДокументооборот КАК СведенияОФайлахДокументооборот
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Файлы КАК Файлы
		|		ПО СведенияОФайлахДокументооборот.Файл = Файлы.Ссылка
		|ГДЕ
		|	Файлы.Ссылка В (&МассивФайлов)";

	Запрос.УстановитьПараметр("МассивФайлов", МассивФайлов);
	
	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл
		СтрокаФайлов = ДополнительныеФайлы.ПолучитьЭлементы().Получить(КэшФайлов[Выборка.Файл]);
		ЗаполнитьЗначенияСвойств(СтрокаФайлов, Выборка);
	КонецЦикла;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РазмерФайлаИзБайтовВКилобайты(Знач РазмерФайла)
	
	Возврат Окр(РазмерФайла/1024, 3); // КБ
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьОшибкиПревышенияРазмера(Знач ВключитьВидимость)
	
	Элементы.ГруппаОшибкаПревышенияРазмера.Видимость = ВключитьВидимость;
	Элементы.ДополнительныеФайлы.ПоложениеЗаголовка  =
		?(ВключитьВидимость, ПоложениеЗаголовкаЭлементаФормы.Нет, ПоложениеЗаголовкаЭлементаФормы.Верх);
	
КонецПроцедуры

&НаКлиенте
Процедура УставновитьТекстВПодвалеДополнительныеФайлы()
	
	Если ПроверятьПревышениеРазмераПакета И РазмерПакетаВКилоБайтах > МаксимальныйРазмерПакетаВКилоБайтах Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДополнительныеФайлы", "Подвал", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДополнительныеФайлыРазмер",
			"ТекстПодвала", РазмерПакетаВКилоБайтах);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДополнительныеФайлыИмяФайла",
			"ТекстПодвала", ТекстПревышенияРазмера());
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДополнительныеФайлыРазмер",
			"ЦветТекстаПодвала", WebЦвета.Красный);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДополнительныеФайлы", "Подвал", Ложь);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ТекстПревышенияРазмера()
	
	Возврат СтрШаблон(НСтр("ru = 'Превышен максимальный размер файлов %1 (Кб)'"),
		МаксимальныйРазмерПакетаВКилоБайтах);
	
КонецФункции

#КонецОбласти
