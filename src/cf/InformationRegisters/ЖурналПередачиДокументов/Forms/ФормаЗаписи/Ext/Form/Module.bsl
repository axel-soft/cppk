﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПоказатьДержателяДокумента") Тогда 
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЖурналПередачиДокументов.ТипЭкземпляра КАК ТипЭкземпляра,
		|	ЖурналПередачиДокументов.Период КАК Период,
		|	ЖурналПередачиДокументов.Документ КАК Документ,
		|	ЖурналПередачиДокументов.НомерЭкземпляра КАК НомерЭкземпляра
		|ИЗ
		|	РегистрСведений.ЖурналПередачиДокументов КАК ЖурналПередачиДокументов
		|ГДЕ
		|	ЖурналПередачиДокументов.Документ = &Документ
		|	И ЖурналПередачиДокументов.Возвращен = ЛОЖЬ";
		Запрос.УстановитьПараметр("Документ", Параметры.ПоказатьДержателяДокумента);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда 
			МенеджерЗаписи = РегистрыСведений.ЖурналПередачиДокументов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Документ 		= Выборка.Документ;
			МенеджерЗаписи.ТипЭкземпляра 	= Выборка.ТипЭкземпляра;
			МенеджерЗаписи.Период 			= Выборка.Период;
			МенеджерЗаписи.НомерЭкземпляра 	= Выборка.НомерЭкземпляра;
			МенеджерЗаписи.Прочитать();
			
			ЗначениеВРеквизитФормы(МенеджерЗаписи, "Запись");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда 
		Запись.Период = ТекущаяДатаСеанса();
		Запись.СрокВозврата = '00010101';
		Запись.Возвращен = Ложь;
		Запись.ДатаВозврата = '00010101';
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Запись.Документ) Тогда
		ДокументТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 (%2)'"), Запись.Документ, ТипЗнч(Запись.Документ));
		Элементы.Пользователь.АктивизироватьПоУмолчанию = Истина;
	Иначе
		ДокументТекст = Неопределено;
		Элементы.ДокументТекст.АктивизироватьПоУмолчанию = Истина;
	КонецЕсли;
	
	// Инструкции
	ПоказыватьИнструкции = ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции");
	ПолучитьИнструкции();
	
	Если Параметры.Ключ.Пустой() Тогда 
		ЭтоНоваяЗапись = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
	ВывестиПросроченоДней();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьИЗакрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Запись.Возвращен Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЭтоНоваяЗапись И Не ПараметрыЗаписи.Свойство("ПродолжитьЗаписьПослеВопроса") Тогда 
		ТекстВопроса = "";
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("Документ", Запись.Документ);
		СтруктураЗаписи.Вставить("Пользователь", Запись.Пользователь);
		СтруктураЗаписи.Вставить("НомерЭкземпляра", Запись.НомерЭкземпляра);
		СтруктураЗаписи.Вставить("ТипЭкземпляра", Запись.ТипЭкземпляра);
		СтруктураЗаписи.Вставить("Период", Запись.Период);
		
		Если Не ДокументМожетБытьПередан(СтруктураЗаписи, ТекстВопроса, Отказ) И Не Отказ Тогда 
			Отказ = Истина;
			ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗаписьюПродолжение", ЭтотОбъект, ПараметрыЗаписи);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0, КодВозвратаДиалога.Нет);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюПродолжение(Результат, ПараметрыЗаписи) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("Документ", Запись.Документ);
		СтруктураЗаписи.Вставить("НомерЭкземпляра", Запись.НомерЭкземпляра);
		СтруктураЗаписи.Вставить("ТипЭкземпляра", Запись.ТипЭкземпляра);
		СтруктураЗаписи.Вставить("Период", Запись.Период);
		
		ОтразитьВозвратОтПрежнегоДержателя(СтруктураЗаписи);
		ПараметрыЗаписи.Вставить("ПродолжитьЗаписьПослеВопроса", Истина);
		Записать(ПараметрыЗаписи)
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзмененЖурналПередачи", Запись.Документ);
	ЭтоНоваяЗапись = Ложь;
	
	Если ПараметрыЗаписи.Свойство("Закрыть") Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Запись.Возвращен Тогда 
		ПроверяемыеРеквизиты.Добавить("ДатаВозврата");
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ДокументТекст) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Документ"" не заполнен'"),,
			"ДокументТекст",, 
			Отказ);
	КонецЕсли;
	
	Если Запись.ТипЭкземпляра = Перечисления.ТипыЭкземпляров.Оригинал
	   И ЗначениеЗаполнено(Запись.Документ)
	   И Запись.НомерЭкземпляра > Запись.Документ.КоличествоЭкземпляров 
	   И Запись.Документ.КоличествоЭкземпляров > 0 Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Указанный номер экземпляра превышает количество экземпляров документа'"),,
			"Запись.НомерЭкземпляра",,
			Отказ);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Запись.СрокВозврата) И КонецДня(Запись.СрокВозврата) < Запись.Период Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Срок возврата меньше даты передачи'"),,
			"Запись.СрокВозврата",,
			Отказ);	
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Запись.ДатаВозврата) И КонецДня(Запись.ДатаВозврата) < Запись.Период Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Дата возврата меньше даты передачи'"),,
			"Запись.ДатаВозврата",,
			Отказ);	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)

	Если Настройки["ПоказыватьИнструкции"] <> Неопределено
		И ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции") Тогда
		ПолучитьИнструкции();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнструкцияПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСИнструкциямиКлиент.ОткрытьСсылку(ДанныеСобытия.Href, ДанныеСобытия.Element, Элемент.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвращенПриИзменении(Элемент)
	
	Если Запись.Возвращен Тогда
		Запись.ДатаВозврата = ТекущаяДата();
	Иначе
		Запись.ДатаВозврата = '00010101';
	КонецЕсли;	
	
	УстановитьДоступность();
	
	ВывестиПросроченоДней();
	
КонецПроцедуры

&НаКлиенте
Процедура СрокВозвратаПриИзменении(Элемент)
	
	ВывестиПросроченоДней();
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("ОбщаяФорма.ВыборПользователяКонтактноеЛицо",
		Новый Структура("ТекущаяСтрока", Запись.Пользователь), Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КонтактныеЛица")
		Или ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Контрагенты") 
		Или ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи")
		Или ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Сотрудники") Тогда
		Запись.Пользователь = ВыбранноеЗначение;
	КонецЕсли;
	
	Модифицированность = Истина; 
	
	СотрудникиКлиент.СотрудникОбработкаВыбора(Запись, "Пользователь", ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораПолучателяДляЖурналаПередачи(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораПолучателяДляЖурналаПередачи(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументТекстПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ДокументТекст) Тогда 
		Запись.Документ = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументТекстНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Справочник.ДокументыПредприятия.ФормаВыбора", , Элемент);
		
КонецПроцедуры

&НаКлиенте
Процедура ДокументТекстОчистка(Элемент, СтандартнаяОбработка)
	
	Запись.Документ = Неопределено;
	ДокументТекст = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументТекстОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ДокументТекст) Тогда
		ПоказатьЗначение(, Запись.Документ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументТекстОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ДелопроизводствоКлиентСервер.ЭтоДокумент(ВыбранноеЗначение) Тогда 
		
		СтандартнаяОбработка = Ложь;
		Документ = ВыбранноеЗначение;
				
		Если ЗначениеЗаполнено(Документ) Тогда
			ДокументТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 (%2)'"), Документ, ТипЗнч(Документ));
		Иначе
			ДокументТекст = Неопределено;
		КонецЕсли;
		
		Запись.Документ = Документ;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументТекстАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораДокументаДляЖурналаПередачи(Текст);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДокументТекстОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораДокументаДляЖурналаПередачи(Текст);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьИнструкции(Команда)
	
	ПоказыватьИнструкции = Не ПоказыватьИнструкции;
	ПолучитьИнструкции();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИЗакрыть()
	
	ПараметрыЗаписи = Новый Структура();
	ПараметрыЗаписи.Вставить("Закрыть", Истина);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДокументМожетБытьПередан(СтруктураЗаписи, ТекстВопроса, Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЖурналПередачиДокументовСрезПоследних.Пользователь,
	|	ЖурналПередачиДокументовСрезПоследних.Возвращен,
	|	ЖурналПередачиДокументовСрезПоследних.Период
	|ИЗ
	|	РегистрСведений.ЖурналПередачиДокументов.СрезПоследних(
	|			,
	|			Документ = &Документ
	|				И НомерЭкземпляра = &НомерЭкземпляра
	|				И ТипЭкземпляра = &ТипЭкземпляра) КАК ЖурналПередачиДокументовСрезПоследних";
	
	Запрос.УстановитьПараметр("Документ", 		 СтруктураЗаписи.Документ);
	Запрос.УстановитьПараметр("НомерЭкземпляра", СтруктураЗаписи.НомерЭкземпляра);
	Запрос.УстановитьПараметр("ТипЭкземпляра", 	 СтруктураЗаписи.ТипЭкземпляра);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат Истина;
	КонецЕсли;	
		
	Если Выборка.Возвращен Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Если Выборка.Пользователь = СтруктураЗаписи.Пользователь И Выборка.Период <> СтруктураЗаписи.Период Тогда 
		
		ТекстСообщения  = СтрШаблон(НСтр("ru = 'Документ уже находится у ""%1""'"),
			Строка(СтруктураЗаписи.Пользователь));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Запись.Пользователь",, Отказ);
		
	ИначеЕсли ТипЗнч(Выборка.Пользователь) <> Тип("СправочникСсылка.Пользователи")
		И ТипЗнч(Выборка.Пользователь) <> Тип("СправочникСсылка.Сотрудники") Тогда
		
		Если ДокументооборотПраваДоступа.ПраваПользователяПоОбъекту(Выборка.Пользователь).Чтение Тогда 
			Если ТипЗнч(СтруктураЗаписи.Пользователь) = Тип("СправочникСсылка.КонтактныеЛица") Тогда 
				ТекстВопроса = СтрШаблон(
					НСтр("ru = 'Документ находится у контактного лица ""%1"". Отразить передачу контактному лицу ""%2""?'"),
					Строка(Выборка.Пользователь), Строка(СтруктураЗаписи.Пользователь));
			Иначе 
				ТекстВопроса = СтрШаблон(
					НСтр("ru = 'Документ находится у контактного лица ""%1"". Отразить передачу пользователю ""%2""?'"),
					Строка(Выборка.Пользователь), Строка(СтруктураЗаписи.Пользователь));
			КонецЕсли;
		Иначе
			Если ТипЗнч(СтруктураЗаписи.Пользователь) <> Тип("СправочникСсылка.Пользователи")
				И ТипЗнч(СтруктураЗаписи.Пользователь) <> Тип("СправочникСсылка.Сотрудники") Тогда 
				ТекстВопроса = СтрШаблон(
					НСтр("ru = 'Документ находится у другого лица. Отразить передачу контактному лицу ""%1""?'"),
					Строка(СтруктураЗаписи.Пользователь));
			Иначе 
				ТекстВопроса = СтрШаблон(
					НСтр("ru = 'Документ находится у другого лица. Отразить передачу пользователю ""%1""?'"),
					Строка(СтруктураЗаписи.Пользователь));
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		Если ТипЗнч(СтруктураЗаписи.Пользователь) <> Тип("СправочникСсылка.Пользователи") 
			И ТипЗнч(СтруктураЗаписи.Пользователь) <> Тип("СправочникСсылка.Сотрудники") Тогда 
			ТекстВопроса = СтрШаблон(
				НСтр("ru = 'Документ находится у пользователя ""%1"". Отразить передачу контактному лицу ""%2""?'"),
				Строка(Выборка.Пользователь), Строка(СтруктураЗаписи.Пользователь));
		Иначе 
			ТекстВопроса = СтрШаблон(
				НСтр("ru = 'Документ находится у пользователя ""%1"". Отразить передачу пользователю ""%2""?'"),
				Строка(Выборка.Пользователь), Строка(СтруктураЗаписи.Пользователь));
		КонецЕсли;
		
	КонецЕсли;
			
	Возврат Ложь;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтразитьВозвратОтПрежнегоДержателя(СтруктураЗаписи)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЖурналПередачиДокументовСрезПоследних.Период,
	|	ЖурналПередачиДокументовСрезПоследних.Документ,
	|	ЖурналПередачиДокументовСрезПоследних.НомерЭкземпляра,
	|	ЖурналПередачиДокументовСрезПоследних.ТипЭкземпляра,
	|	ЖурналПередачиДокументовСрезПоследних.Возвращен
	|ИЗ
	|	РегистрСведений.ЖурналПередачиДокументов.СрезПоследних(
	|			,
	|			Документ = &Документ
	|				И НомерЭкземпляра = &НомерЭкземпляра
	|				И ТипЭкземпляра = &ТипЭкземпляра) КАК ЖурналПередачиДокументовСрезПоследних";
	
	Запрос.УстановитьПараметр("Документ", 			СтруктураЗаписи.Документ);
	Запрос.УстановитьПараметр("НомерЭкземпляра", 	СтруктураЗаписи.НомерЭкземпляра);
	Запрос.УстановитьПараметр("ТипЭкземпляра", 		СтруктураЗаписи.ТипЭкземпляра);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Не Выборка.Возвращен Тогда
			МенеджерЗаписи = РегистрыСведений.ЖурналПередачиДокументов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Период = Выборка.Период;
			МенеджерЗаписи.Документ = СтруктураЗаписи.Документ;
			МенеджерЗаписи.ТипЭкземпляра = СтруктураЗаписи.ТипЭкземпляра;
			МенеджерЗаписи.НомерЭкземпляра = СтруктураЗаписи.НомерЭкземпляра;
			МенеджерЗаписи.Прочитать();
			
			МенеджерЗаписи.Возвращен = Истина;
			МенеджерЗаписи.ДатаВозврата = ТекущаяДатаСеанса();
			МенеджерЗаписи.Записать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступность()
	
	Элементы.ДатаВозврата.ТолькоПросмотр = Не Запись.Возвращен;
	
КонецПроцедуры	

&НаКлиенте
Процедура ВывестиПросроченоДней()
	
	ТекущаяДата = ТекущаяДата();
	Если НачалоДня(ТекущаяДата) > НачалоДня(Запись.СрокВозврата) И ЗначениеЗаполнено(Запись.СрокВозврата) И Не Запись.Возвращен Тогда 
		ПросроченоДней = (НачалоДня(ТекущаяДата) - НачалоДня(Запись.СрокВозврата)) / (24 * 3600);
		Элементы.ДекорацияПросрочка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '(просрочено %1 %2)'"), 
			Формат(ПросроченоДней, "ЧН=; ЧГ="), 
			ДелопроизводствоКлиентСервер.ПолучитьПодписьДней(ПросроченоДней));
	Иначе
		Элементы.ДекорацияПросрочка.Заголовок = "";
	КонецЕсли;	
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ИНСТРУКЦИИ

&НаСервере
Процедура ПолучитьИнструкции()
	
	РаботаСИнструкциями.ПолучитьИнструкции(ЭтаФорма, 75, 105);
	
КонецПроцедуры

#КонецОбласти
