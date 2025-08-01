﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("СотрудникиПользователя", Сотрудники.СотрудникиПользователя());
	Список.Параметры.УстановитьЗначениеПараметра("Понедельник", Перечисления.ДниНедели.Понедельник);
	Список.Параметры.УстановитьЗначениеПараметра("Вторник", 	Перечисления.ДниНедели.Вторник);
	Список.Параметры.УстановитьЗначениеПараметра("Среда", 		Перечисления.ДниНедели.Среда);
	Список.Параметры.УстановитьЗначениеПараметра("Четверг", 	Перечисления.ДниНедели.Четверг);
	Список.Параметры.УстановитьЗначениеПараметра("Пятница", 	Перечисления.ДниНедели.Пятница);
	Список.Параметры.УстановитьЗначениеПараметра("Суббота", 	Перечисления.ДниНедели.Суббота);
	Список.Параметры.УстановитьЗначениеПараметра("Воскресенье", Перечисления.ДниНедели.Воскресенье);
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		НастроитьЭлементыФормыДляМобильногоУстройства();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьЭлементыФормыДляМобильногоУстройства()
	
	// Подготовим колонки таблицы.
	Элементы.ДлительностьРабот.АвтоМаксимальнаяШирина = Ложь;
	Элементы.ДлительностьРабот.МаксимальнаяШирина = 4;
	Элементы.ДлительностьРабот.Ширина = 0;
	Элементы.ДлительностьРабот.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Центр;
	
	Элементы.Дата.АвтоМаксимальнаяШирина = Ложь;
	Элементы.Дата.МаксимальнаяШирина = 8;
	Элементы.Дата.Ширина = 0;
	Элементы.Дата.Формат = "ДЛФ=D";
	
КонецПроцедуры

#КонецОбласти
