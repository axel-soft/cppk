﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ВидДокумента = Параметры.ВидДокумента;
	
	// читаем из РС - если есть привязка (по виду документа) 
	//- то заполняем оттуда ("по умолчанимю" выключена и поля дизеблены)
	//
	// иначе заполняем из констант.  "по умолчанимю" Включена
	//  но еще из группы видов надо искать. и тогда инф надпись вместо "по умолчанию" (поля дизеблены)
	
	Заголовок = СтрШаблон(НСтр("ru = 'Настройка вставки штампа ЭП (%1)'"), ВидДокумента);

	Настройка = РегистрыСведений.НастройкиГенерацииШтамповЭППоВидамДокументов.ПолучитьНастройку(ВидДокумента);
	Если Настройка = Неопределено Тогда
		
		ГруппаВида = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДокумента, "Родитель");
		Если ЗначениеЗаполнено(ГруппаВида) Тогда
			Настройка = РегистрыСведений.НастройкиГенерацииШтамповЭППоВидамДокументов.ПолучитьНастройку(
				ГруппаВида);
			
			Если Настройка <> Неопределено Тогда

				НастройкаИзГруппыВидаДокумента = Истина;
					
				Элементы.ФормаЗаписать.Видимость = Ложь;
				Элементы.ГруппаИнфо.Видимость = Истина;
				Элементы.ДекорацияНадпись.Заголовок = СтрШаблон(
					НСтр("ru = 'Для изменения настройки откройте группу вида документа ""%1"" '"), 
					ГруппаВида);
				
				Элементы.ПоУмолчанию.Видимость = Ложь;
				Элементы.ГруппаНастроек.ТолькоПросмотр = Истина;
				
				РеквНастройки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Настройка,
					"РасположениеШтампаЭП, СтраницаВставкиШтампаЭП");
				РасположениеШтампаЭП = РеквНастройки.РасположениеШтампаЭП;
				СтраницаВставкиШтампаЭП = РеквНастройки.СтраницаВставкиШтампаЭП;
				
				Возврат;
			КонецЕсли;	
				
		КонецЕсли;	
		
		УстановитьПривилегированныйРежим(Истина);
		
		НастройкаПрочитанаИзВидаДокумента = Ложь;
		
		ПоУмолчанию = Истина;
		Элементы.ГруппаНастроек.ТолькоПросмотр = Истина;
		Элементы.ГруппаНастроек.Доступность = Ложь;

		РасположениеШтампаЭП = Константы.РасположениеШтампаЭПВPdf.Получить();
		СтраницаВставкиШтампаЭП = Константы.СтраницаВставкиШтампаЭП.Получить();
	
	Иначе
		
		ПоУмолчанию = Ложь;
		
		НастройкаПрочитанаИзВидаДокумента = Истина;

		РеквНастройки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Настройка,
			"РасположениеШтампаЭП, СтраницаВставкиШтампаЭП");
		РасположениеШтампаЭП = РеквНастройки.РасположениеШтампаЭП;
		СтраницаВставкиШтампаЭП = РеквНастройки.СтраницаВставкиШтампаЭП;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоУмолчаниюПриИзменении(Элемент)
	ПоУмолчаниюПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПоУмолчаниюПриИзмененииНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	НастройкаПрочитанаИзВидаДокумента = Не НастройкаПрочитанаИзВидаДокумента;
	ПоУмолчанию = Не НастройкаПрочитанаИзВидаДокумента;
	
	Элементы.ГруппаНастроек.ТолькоПросмотр = Не НастройкаПрочитанаИзВидаДокумента;
	Элементы.ГруппаНастроек.Доступность = НастройкаПрочитанаИзВидаДокумента;
	
	Модифицированность = Истина;
	
	Если ПоУмолчанию Тогда // прочитаем значения по умолчанию
		
		РасположениеШтампаЭП = Константы.РасположениеШтампаЭПВPdf.Получить();
		СтраницаВставкиШтампаЭП = Константы.СтраницаВставкиШтампаЭП.Получить();
		
	КонецЕсли;	  

КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьНаСервере();
	Оповестить("ИзмененыНастройкиШтампаЭП", ВидДокумента);	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура РасположениеШтампаЭППриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СтраницаВставкиШтампаЭППриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);

	Настройка = РегистрыСведений.НастройкиГенерацииШтамповЭППоВидамДокументов.ПолучитьНастройку(ВидДокумента);
	
	Если ПоУмолчанию Тогда

		// Удалим настройку.
		// пометим на удаление справочник и удалим запись РС
			
		Если Настройка <> Неопределено Тогда
			НастройкаОбъект = Настройка.ПолучитьОбъект();
			НастройкаОбъект.УстановитьПометкуУдаления(Истина);
		КонецЕсли;	
		
		РегистрыСведений.НастройкиГенерацииШтамповЭППоВидамДокументов.УдалитьЗапись(ВидДокумента);
		Возврат;
	КонецЕсли;	
	
	Если Настройка = Неопределено Тогда
		НастройкаОбъект = Справочники.НастройкиГенерацииШтамповЭП.СоздатьЭлемент();
		НастройкаОбъект.Наименование = Строка(ВидДокумента); 
	Иначе
		НастройкаОбъект = Настройка.ПолучитьОбъект();
	КонецЕсли;
			
	НастройкаОбъект.РасположениеШтампаЭП = РасположениеШтампаЭП;
	НастройкаОбъект.СтраницаВставкиШтампаЭП = СтраницаВставкиШтампаЭП;
			
	НастройкаОбъект.Записать();			
	
	РегистрыСведений.НастройкиГенерацииШтамповЭППоВидамДокументов.ДобавитьЗапись(
		ВидДокумента, НастройкаОбъект.Ссылка);
	
КонецПроцедуры



#КонецОбласти