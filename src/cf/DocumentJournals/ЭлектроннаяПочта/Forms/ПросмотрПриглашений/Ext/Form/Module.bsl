﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ФайлСсылка") И ЗначениеЗаполнено(Параметры.ФайлСсылка) Тогда 
		
		ФайлСсылка = Параметры.ФайлСсылка;
		Письмо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ФайлСсылка, "ВладелецФайла");
		
		ИдентификаторПриглашения = Неопределено;
		РеквизитыПриглашения = Новый Структура;
		ТекстСообщения = ВстроеннаяПочтаСервер.ПолучитьТекстПриглашения(ФайлСсылка, ИдентификаторПриглашения, РеквизитыПриглашения);
		
		// по ИдентификаторПриглашения найдем запись календаря, и прочитаем статус принятия
		СсылкаЗаписьКалендаря = Неопределено;
		РаботаСРабочимКалендаремСервер.УжеЕстьТакаяЗаписьКалендаря(
			СотрудникиПовтИсп.ВсеСотрудникиТекущегоПользователя(), 
			ИдентификаторПриглашения,
			СсылкаЗаписьКалендаря);  
			
		ОбновитьСтатус();
			
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСтандартнымПриложением(Команда)
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(ФайлСсылка, Неопределено, 
		УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла, УникальныйИдентификатор);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Принять(Команда) 
	Состояние(НСтр("ru = 'Отправка ответа на приглашение...'"));
	ПринятьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Отклонить(Команда)      
	Состояние(НСтр("ru = 'Отправка ответа на приглашение...'"));
	ОтклонитьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПринятьНаСервере()  
	
	// Принято приглашение        
	Состояние = Перечисления.СостоянияПриглашения.Принято;
	ВстроеннаяПочтаСервер.ВыполнитьОтветНаСервере(Письмо, Состояние);  
	УстановитьСостояниеЗаписиКалендаря(Состояние);
	
КонецПроцедуры

&НаСервере
Процедура ОтклонитьНаСервере()
	
	// Принято приглашение
	Состояние = Перечисления.СостоянияПриглашения.НеПринято;
	ВстроеннаяПочтаСервер.ВыполнитьОтветНаСервере(Письмо, Состояние);
	УстановитьСостояниеЗаписиКалендаря(Состояние);

КонецПроцедуры    

&НаСервере
Процедура  УстановитьСостояниеЗаписиКалендаря(Состояние)    
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРабочийКалендарь") Тогда
	
		СостояниеКалендаря = Неопределено;
		Если Состояние = Перечисления.СостоянияПриглашения.НеПринято Тогда
			СостояниеКалендаря = Перечисления.СостоянияЗаписейРабочегоКалендаря.Отклонено;
		ИначеЕсли Состояние = Перечисления.СостоянияПриглашения.Принято Тогда
			СостояниеКалендаря = Перечисления.СостоянияЗаписейРабочегоКалендаря.Принято;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(СсылкаЗаписьКалендаря) Тогда
			
			ОбъектЗаписьКалендаря = СсылкаЗаписьКалендаря.ПолучитьОбъект();
			ОбъектЗаписьКалендаря.Состояние = СостояниеКалендаря;  
			ОбъектЗаписьКалендаря.Записать();
			
		Иначе	              
			
			Тема = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Письмо, "Тема");		
			
			ИдентификаторПриглашения = Неопределено;     
			РеквизитыПриглашения = Новый Структура;    
			ТекстСообщения = ВстроеннаяПочтаСервер.ПолучитьТекстПриглашения(ФайлСсылка, ИдентификаторПриглашения, РеквизитыПриглашения);
			
			Описание = РаботаС_HTML.ПолучитьТекстИзHTML(ТекстСообщения);	
			ДваПереводаСтроки = Символы.ВК + Символы.ВК; 
			Описание = СтрЗаменить(Описание, ДваПереводаСтроки, Символы.ВК);
			ДваПереводаСтроки = Символы.ПС + Символы.ПС; 
			Описание = СтрЗаменить(Описание, ДваПереводаСтроки, Символы.ПС);
			
			ПометкаУдаления = Ложь;
			
			СсылкаЗаписьКалендаря = РаботаСРабочимКалендаремСервер.СоздатьЗаписьКалендаряПоПредмету(
				Письмо, Сотрудники.ОсновнойСотрудник(), 
				Описание, 
				РеквизитыПриглашения.ДатаНачала, РеквизитыПриглашения.ДатаОкончания, 
				Тема,
				ИдентификаторПриглашения,
				СостояниеКалендаря,
				ПометкаУдаления);
			
		КонецЕсли;	  
		
	КонецЕсли;
		
	ОбновитьСтатус();
	
КонецПроцедуры    	

&НаСервере
Процедура ОбновитьСтатус()

	Элементы.Закрыть.Видимость = Истина;
	Элементы.Принять.Видимость = Ложь;
	Элементы.Отклонить.Видимость = Ложь;   
	
	Элементы.ГруппаИнфо.Видимость = Ложь;
	
	Если ЗначениеЗаполнено(СсылкаЗаписьКалендаря) Тогда  // есть запись календаря
		
		РеквЗаписи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаЗаписьКалендаря, "Состояние, ПометкаУдаления");
		Состояние = РеквЗаписи.Состояние;
		ПометкаУдаления = РеквЗаписи.ПометкаУдаления;
		
		Если ПометкаУдаления Тогда
			
			Элементы.ГруппаИнфо.Видимость = Истина;
			Элементы.ДекорацияИнфо.Заголовок = НСтр("ru = 'Собрание отменено организатором'");
			
		ИначеЕсли Состояние <> Перечисления.СостоянияЗаписейРабочегоКалендаря.Отклонено 
			И Состояние <> Перечисления.СостоянияЗаписейРабочегоКалендаря.Принято Тогда
			
			//  покажем кнопки Принять Отклонить
			Элементы.Закрыть.Видимость = Ложь;
			Элементы.Принять.Видимость = Истина;
			Элементы.Отклонить.Видимость = Истина;
			
		Иначе
			
			Элементы.ГруппаИнфо.Видимость = Истина;
			
			Если Состояние = Перечисления.СостоянияЗаписейРабочегоКалендаря.Принято И Не ПометкаУдаления Тогда
				Элементы.ДекорацияИнфо.Заголовок = НСтр("ru = 'Вы приняли приглашение'");
			ИначеЕсли Состояние = Перечисления.СостоянияЗаписейРабочегоКалендаря.Отклонено И Не ПометкаУдаления Тогда
				Элементы.ДекорацияИнфо.Заголовок = НСтр("ru = 'Вы отклонили приглашение'");
			КонецЕсли;	
			
		КонецЕсли;	
		
	Иначе	

		// нет записи календаря -  покажем кнопки Принять Отклонить
		Элементы.Закрыть.Видимость = Ложь;
		Элементы.Принять.Видимость = Истина;
		Элементы.Отклонить.Видимость = Истина;
		
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти