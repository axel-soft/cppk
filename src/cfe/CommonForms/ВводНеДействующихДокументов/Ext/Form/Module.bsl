﻿
&НаСервере
&После("ПриСозданииНаСервере")
Процедура ЦППК_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Котляров 10.07.2025 САНФ-034810 QR-7259012-1
	ЦППК_ПодключаемыеКоманды.СоздатьРеквизит(ЭтаФорма, "ЭтоФормаИзменения", ЦППК_ПодключаемыеКоманды.ОписаниеТипаБулево());
	ЭтаФорма.ЭтоФормаИзменения = Ложь;
	Если Параметры.Свойство("ЭтоФормаИзменения") Тогда	
		ЭтаФорма.Заголовок = "Ввод измененных документов";
		Элементы.ТаблицаДокументовДатаОтмены.Видимость = Ложь;
		ЭтаФорма.ЭтоФормаИзменения = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
&ИзменениеИКонтроль("Подбор")
Процедура ЦППК_Подбор(Команда)

	ПараметрыФормы = Новый Структура;

	Если ВидыОтменяемыхДокументов.Количество() <> 0 Тогда
		ПараметрыФормы.Вставить("Отбор", 
		Новый Структура("ВидДокумента, НеДействует", ВидыОтменяемыхДокументов, Ложь));
	Иначе		
		ПараметрыФормы.Вставить("Отбор", 
		Новый Структура("НеДействует", Ложь));
	КонецЕсли;
#Вставка	
Если ЭтаФорма.ЭтоФормаИзменения Тогда
		Если ВидыОтменяемыхДокументов.Количество() <> 0 Тогда
			СтруктураОтбора = Новый Структура("ВидДокумента, Изменен", ВидыОтменяемыхДокументов, Ложь);
		Иначе
			СтруктураОтбора = Новый Структура("Изменен", Ложь);
		КонецЕсли;
		ПараметрыФормы.Отбор = СтруктураОтбора;
	КонецЕсли;
#КонецВставки

	ПараметрыФормы.Вставить("ТолькоЗарегистрированные", Истина);
	ПараметрыФормы.Вставить("ИспользоватьИерархию", Ложь);

	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);

	ПараметрыФормы.Вставить("ПоказыватьКомандуСоздать", Ложь);

	МассивДокументов = Новый Массив;
	Для Каждого Строка Из ТаблицаДокументов Цикл 

		Если ЗначениеЗаполнено(Строка.Документ) Тогда 

			МассивДокументов.Добавить(Строка.Документ);	

		КонецЕсли;

	КонецЦикла;

	ПараметрыФормы.Вставить("ВыбранныеЗначения", МассивДокументов);

	ОткрытьФорму("Справочник.ДокументыПредприятия.ФормаВыбора", ПараметрыФормы, 
	Элементы.ТаблицаДокументов);

КонецПроцедуры

&НаКлиенте
&ИзменениеИКонтроль("ДокументНачалоВыбора")
Процедура ЦППК_ДокументНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если Элементы.ТаблицаДокументов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	

	Если Элементы.ТаблицаДокументов.ТекущиеДанные.УжеУстановлен Тогда
		Возврат;
	КонецЕсли;	

	ПараметрыФормы = Новый Структура;

	Если ВидыОтменяемыхДокументов.Количество() <> 0 Тогда
		ПараметрыФормы.Вставить("Отбор", 
		Новый Структура("ВидДокумента, НеДействует", ВидыОтменяемыхДокументов, Ложь));
	Иначе		
		ПараметрыФормы.Вставить("Отбор", 
		Новый Структура("НеДействует", Ложь));
	КонецЕсли;
#Вставка	
Если ЭтаФорма.ЭтоФормаИзменения Тогда
		Если ВидыОтменяемыхДокументов.Количество() <> 0 Тогда
			СтруктураОтбора = Новый Структура("ВидДокумента, Изменен", ВидыОтменяемыхДокументов, Ложь);
		Иначе
			СтруктураОтбора = Новый Структура("Изменен", Ложь);
		КонецЕсли;
		ПараметрыФормы.Отбор = СтруктураОтбора;
	КонецЕсли;
#КонецВставки
	

	ПараметрыФормы.Вставить("ТолькоЗарегистрированные", Истина);
	ПараметрыФормы.Вставить("ИспользоватьИерархию", Ложь);

	ПараметрыФормы.Вставить("ТекущаяСтрока", Элементы.ТаблицаДокументов.ТекущаяСтрока);

	ПараметрыФормы.Вставить("ПоказыватьКомандуСоздать", Ложь);

	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВводНеДействующихДокументов", ЭтаФорма);

	ОткрытьФорму("Справочник.ДокументыПредприятия.ФормаВыбора", ПараметрыФормы, Элементы.ТаблицаДокументовНаименование,,,,Оповещение);

КонецПроцедуры
