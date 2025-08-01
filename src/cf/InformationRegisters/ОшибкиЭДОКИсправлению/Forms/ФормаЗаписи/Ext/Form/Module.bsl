﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПредметОшибки") Тогда
		ПредметОшибки = Параметры.ПредметОшибки;
	КонецЕсли;
	
	ОбновитьДанныеПоПредметуОшибки();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновленоСостояниеЭДДО"
		И Параметр.Свойство("Документы")
		И Параметр.Документы.Найти(ПредметОшибки) <> Неопределено Тогда
		
		ОбновитьДанныеПоПредметуОшибки();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьДокументПринудительно(Команда)
	
	Если ТипЗнч(Запись.ПредметОшибки) = Тип("СправочникСсылка.ДокументыПредприятия") Тогда
		ОбменСКонтрагентамиДОСлужебныйКлиент.ЗакрытьДокументыПринудительно(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Запись.ПредметОшибки),
			Новый ОписаниеОповещения("ЗакрытьДокументПринудительноЗавершение",ЭтотОбъект));
	Иначе
		ОбменСКонтрагентамиДОСлужебныйКлиент.ЗакрытьПринудительноЭД(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Запись.ПредметОшибки),
			Новый ОписаниеОповещения("ЗакрытьДокументПринудительноЗавершение",ЭтотОбъект));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьДокументПринудительноЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Ошибки.Количество() > 0 Тогда
		Для Каждого Ошибка Из Результат.Ошибки Цикл
			ОбщегоНазначенияКлиент.СообщитьПользователю(Ошибка);
		КонецЦикла;
	Иначе
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставитьВОчередьНаОтправку(Команда)
	
	Поставлен = ОбменСКонтрагентамиДОСлужебныйКлиент.ПоставитьДокументыВОчередьНаОтправкуПоЭДО(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Запись.ПредметОшибки));
	
	Если Поставлен Тогда
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставитьВОчередьПриема(Команда)
	
	Поставлен =
		ОбменСКонтрагентамиДОСлужебныйКлиент.ПоставитьДокументыЭДОКАвтоматическомуОтражению(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Запись.ПредметОшибки));
	
	Если Поставлен Тогда
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДанныеПоПредметуОшибки()
	
	ЗаписьОбОшибке = ЗаписьОбОшибкеПоПредмету(ПредметОшибки);
	
	Если ЗаписьОбОшибке <> Неопределено Тогда
		ЗначениеВРеквизитФормы(ЗаписьОбОшибке, "Запись");
		НесуществующаяЗапись = Ложь;
	Иначе
		ЗначениеВРеквизитФормы(РегистрыСведений.ОшибкиЭДОКИсправлению.СоздатьМенеджерЗаписи(), "Запись");
		Запись.ПредметОшибки = ПредметОшибки;
		Запись.ОписаниеПроблемы =
			НСтр("ru = 'Не найдено записи о ошибке обмена по данному предмету.'");
		НесуществующаяЗапись = Истина;
	КонецЕсли;
	
	Если ТипЗнч(ПредметОшибки) = Тип("СправочникСсылка.ДокументыПредприятия") Тогда
		СостояниеЭДО =
			РегистрыСведений.СостояниеДокументовПоЭДО.ДанныеСостоянияДокументаПоЭДО(ПредметОшибки);
	ИначеЕсли ТипЗнч(ПредметОшибки) = Тип("ДокументСсылка.ЭлектронныйДокументВходящийЭДО") Тогда
		ДанныеПоОтражениюДокумента =
			ОбменСКонтрагентамиДОВызовСервера.ДанныеПоОтражениюДокументаЭДО(ПредметОшибки);
		
		ОжидаетАвтоматическогоСоздания = ДанныеПоОтражениюДокумента.ОжидаетАвтоматическогоОтражения;
	КонецЕсли;
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаСервере
Функция ЗаписьОбОшибкеПоПредмету(ПредметОшибки)
	
	Если Не ЗначениеЗаполнено(ПредметОшибки) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.ОшибкиЭДОКИсправлению.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ПредметОшибки = ПредметОшибки;
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		Возврат МенеджерЗаписи;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	Элементы.НастройкиЭДО.Видимость = ЗначениеЗаполнено(Запись.НастройкиЭДО);
	
	Элементы.ФормаПоставитьВОчередьНаОтправку.Видимость = Ложь;
	Элементы.ФормаЗакрытьДокументПринудительно.Видимость = Ложь;
	Элементы.ФормаПоставитьВОчередьПриема.Видимость = Ложь;
	Элементы.ФормаОтмена.Видимость = Ложь;
	
	Если НесуществующаяЗапись Тогда
		Элементы.ФормаОтмена.Видимость = Истина;
	ИначеЕсли ТипЗнч(Запись.ПредметОшибки) = Тип("СправочникСсылка.ДокументыПредприятия") Тогда
		Если СостояниеЭДО = Перечисления.СостоянияЭДОДокументооборот.ОшибкаПередачи Тогда
			Элементы.ФормаПоставитьВОчередьНаОтправку.Видимость = Истина;
			Элементы.ФормаЗакрытьДокументПринудительно.Видимость = Истина;
		КонецЕсли;
		Элементы.ФормаОтмена.Видимость = Истина;
	ИначеЕсли ТипЗнч(Запись.ПредметОшибки) = Тип("ДокументСсылка.ЭлектронныйДокументВходящийЭДО") Тогда
		Если Не ОжидаетАвтоматическогоСоздания Тогда
			Элементы.ФормаПоставитьВОчередьПриема.Видимость = Истина;
			Элементы.ФормаЗакрытьДокументПринудительно.Видимость = Истина;
		КонецЕсли;
		Элементы.ФормаОтмена.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
