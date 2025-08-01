﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ЭлектронныйДокумент", ЭлектронныйДокумент) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Параметры.РезультатПроверкиПакета <> Неопределено
		И Параметры.РезультатПроверкиПакета.ПревышенРазмерПакета Тогда
		ПревышенРазмерПакета = Истина;
		ДанныеФайлов = Параметры.РезультатПроверкиПакета.ДанныеФайловКПубликации;
		РазмерПакетаБезПрисоединенныхФайлов = РазмерФайлаИзБайтовВКилобайты(Параметры.РезультатПроверкиПакета.РазмерПакетаБезПрисоединенныхФайлов);
		МаксимальныйРазмерПакетаВБайтах     = РазмерФайлаИзБайтовВКилобайты(Параметры.РезультатПроверкиПакета.МаксимальныйРазмерПакета);
	Иначе
		ДанныеФайлов = Параметры.ФайлыДокумента;
	КонецЕсли;
	
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
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗакрытии, Новый Массив);
	
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
		ГруппаФайлов = ДополнительныеФайлы.ПолучитьЭлементы()[ИндексГруппыПрисоединенныеФайлы()];
		
		Если ТекущиеДанные.ИндексВыбораФайла = 2 Тогда
			ИндексВыбораФайла = 0;
			ТекущиеДанные.ИндексВыбораФайла = ИндексВыбораФайла;
		Иначе
			ИндексВыбораФайла = ТекущиеДанные.ИндексВыбораФайла;
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
	
	ИнтеграцияС1СДокументооборотом = 
		ТекущиеДанные.ВидФайла = ИнтеграцияShareКлиентСервер.ВидыХраненияФайловВБазе().ИнтеграцияС1СДокументооборот;
	
	Если ТекущиеДанные = Неопределено
		Или ТекущиеДанные.СсылкаНаФайл = Неопределено
		И Не ИнтеграцияС1СДокументооборотом Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если ИнтеграцияС1СДокументооборотом Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент = 
			ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент");

		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьФайл(ТекущиеДанные.ИдентификаторФайла, ТекущиеДанные.Наименование,
			ТекущиеДанные.Расширение, УникальныйИдентификатор);
		
	Иначе
		ПоказатьЗначение(, ТекущиеДанные.СсылкаНаФайл);
	КонецЕсли;

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
	
	ИнтеграцияС1СДокументооборотом = 
		ТекущиеДанные.ВидФайла = ИнтеграцияShareКлиентСервер.ВидыХраненияФайловВБазе().ИнтеграцияС1СДокументооборот;
	
	Если ТекущиеДанные.СсылкаНаФайл = Неопределено
		И Не ИнтеграцияС1СДокументооборотом Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоделитьсяДокументом(Команда)
	
	Если ПревышенРазмерПакета
		И РазмерПакетаВБайтах > МаксимальныйРазмерПакетаВБайтах Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстПревышенияРазмера());
		Возврат;
	КонецЕсли;
	
	РезультатВыбораФайлов = РезультатВыбораФайловДокументаКПубликации();
	Закрыть(РезультатВыбораФайлов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РассчитатьИтогиВыбранныхДополнительныхФайлов()

	ГруппаФайлов = ДополнительныеФайлы.ПолучитьЭлементы()[ИндексГруппыПрисоединенныеФайлы()];
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
	ГруппаФайлов.Размер = РазмерВыбранныхФайлов;
	РазмерПакетаВБайтах = РазмерВыбранныхФайлов + РазмерПакетаБезПрисоединенныхФайлов;
	
	Если ВыбраноФайлов = 0 Тогда
		ГруппаФайлов.ИндексВыбораФайла = 0; // нет выбранных файлов
	ИначеЕсли ВыбраноФайлов > 0 И ВыбраноФайлов <> ВсегоФайлов Тогда
		ГруппаФайлов.ИндексВыбораФайла = 2; // частично выбраны файлы
	Иначе
		ГруппаФайлов.ИндексВыбораФайла = 1; // все файлы выбраны
	КонецЕсли;
	
	УставновитьТекстВПодвалеДополнительныеФайлы();
	
КонецПроцедуры

&НаКлиенте
Функция РезультатВыбораФайловДокументаКПубликации()
	
	Результат = Новый Массив;
	
	ГруппаФайлов = ДополнительныеФайлы.ПолучитьЭлементы()[ИндексГруппыПрисоединенныеФайлы()];
	
	Для Каждого СтрокаФайла Из ГруппаФайлов.ПолучитьЭлементы() Цикл
		
		Если Не СтрокаФайла.ФайлВыбран Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеФайла = ИнтеграцияShareКлиентСервер.НовыеДанныеФайлаДляВыбораКПубликации();
		ЗаполнитьЗначенияСвойств(ДанныеФайла, СтрокаФайла);
		Результат.Добавить(ДанныеФайла);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДополнительныеФайлы(Знач ДанныеФайлов, ЕстьФайлыКВыбору)
	
	// Добавляем основной документ
	НоваяСтрока = ДополнительныеФайлы.ПолучитьЭлементы().Добавить();
	НоваяСтрока.СсылкаНаФайл             = ЭлектронныйДокумент;
	НоваяСтрока.ИмяФайла                 = Строка(ЭлектронныйДокумент);
	НоваяСтрока.ИндексКартинкиФайла      = -1;
	НоваяСтрока.ИндексВыбораФайла        = 1;
	НоваяСтрока.ОсновнойФайл             = Истина;
	НоваяСтрока.ФайлВыбран               = Истина;
	НоваяСтрока.РасширениеФайлаРазрешено = Истина;
	НоваяСтрока.Размер                   = РазмерПакетаБезПрисоединенныхФайлов;
	
	// Добавляем группу "Присоединенные файлы"
	НоваяСтрокаГруппа = ДополнительныеФайлы.ПолучитьЭлементы().Добавить();
	НоваяСтрокаГруппа.ИмяФайла                 = НСтр("ru = 'Присоединенные файлы'", ОбщегоНазначения.КодОсновногоЯзыка());
	НоваяСтрокаГруппа.ИндексКартинкиФайла      = 2;
	НоваяСтрокаГруппа.ИндексВыбораФайла        = 0;
	НоваяСтрокаГруппа.ЭтоГруппаФайлов          = Истина;
	НоваяСтрокаГруппа.РасширениеФайлаРазрешено = Истина;
	
	Для Каждого ДанныеФайла Из ДанныеФайлов Цикл
		
		Если ПревышенРазмерПакета И Не ДанныеФайла.ФайлВыбран Тогда
			Продолжить; // Отображаем только выбранные ранее файлы.
		КонецЕсли;
		
		НоваяСтрока = НоваяСтрокаГруппа.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеФайла);
		
		НоваяСтрока.ИндексВыбораФайла   = ?(НоваяСтрока.ФайлВыбран, 1, 0);
		НоваяСтрока.ИндексКартинкиФайла = ИнтеграцияShareКлиентСервер.ПолучитьИндексПиктограммыФайла(НоваяСтрока.Расширение);
		НоваяСтрока.ИмяФайла            = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
			ДанныеФайла.Наименование, ДанныеФайла.Расширение);
			
		Если Не ПустаяСтрока(НоваяСтрока.Расширение) Тогда
			НоваяСтрока.РасширениеФайлаРазрешено = ИнтеграцияShare.РасширениеФайлаДоступно(
				НоваяСтрока.Расширение, НоваяСтрока.ДвоичныеДанныеФайла);
		КонецЕсли;
		
		Если НоваяСтрока.РасширениеФайлаРазрешено = Ложь Тогда
			ШаблонТекста = НСтр("ru = '(тип файла недоступен для отправки)'", ОбщегоНазначения.КодОсновногоЯзыка());
			НоваяСтрока.ИмяФайла = СтрШаблон("%1 %2", НоваяСтрока.ИмяФайла, ШаблонТекста);
		Иначе
			ЕстьФайлыКВыбору = Истина;
		КонецЕсли;
		
		НоваяСтрока.Размер = РазмерФайлаИзБайтовВКилобайты(ДанныеФайла.ДвоичныеДанныеФайла.Размер());
	КонецЦикла;
	
	Если Не ЕстьФайлыКВыбору Тогда
		ДанныеФайлов = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РазмерФайлаИзБайтовВКилобайты(Знач РазмерФайла)
	
	Возврат Окр(РазмерФайла/1024, 3); // КБ
	
КонецФункции

&НаКлиенте
Функция ИндексГруппыПрисоединенныеФайлы()
	
	Возврат 1;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьОшибкиПревышенияРазмера(Знач ВключитьВидимость)
	
	Элементы.ГруппаОшибкаПревышенияРазмера.Видимость = ВключитьВидимость;
	Элементы.ДополнительныеФайлы.ПоложениеЗаголовка  =
		?(ВключитьВидимость, ПоложениеЗаголовкаЭлементаФормы.Нет, ПоложениеЗаголовкаЭлементаФормы.Верх);
	
КонецПроцедуры

&НаКлиенте
Процедура УставновитьТекстВПодвалеДополнительныеФайлы()
	
	Если Не ПревышенРазмерПакета Тогда
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДополнительныеФайлы", "Подвал", Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДополнительныеФайлыРазмер", "ТекстПодвала",
		РазмерПакетаВБайтах);

	Если РазмерПакетаВБайтах > МаксимальныйРазмерПакетаВБайтах Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДополнительныеФайлыИмяФайла",
			"ТекстПодвала", ТекстПревышенияРазмера());
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДополнительныеФайлыРазмер",
			"ЦветТекстаПодвала", WebЦвета.Красный);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДополнительныеФайлыИмяФайла",
			"ТекстПодвала", "");
		// Установка цвета по умолчанию
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДополнительныеФайлыРазмер",
			"ЦветТекстаПодвала", Новый Цвет);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ТекстПревышенияРазмера()
	
	Возврат СтрШаблон(НСтр("ru = 'Превышен максимальный размер файлов %1 (КБ)'",
		ОбщегоНазначенияКлиент.КодОсновногоЯзыка()), МаксимальныйРазмерПакетаВБайтах);
	
КонецФункции

#КонецОбласти