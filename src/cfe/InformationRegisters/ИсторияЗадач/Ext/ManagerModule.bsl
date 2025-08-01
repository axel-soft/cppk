﻿
&ИзменениеИКонтроль("ПредставлениеИсполнителяДляИсторииВыполнения")
Функция ЦППК_ПредставлениеИсполнителяДляИсторииВыполнения(Контекст, Событие, КодЯзыка)
	
	МассивВозврата = Новый Массив;  //  массив структур ПредставлениеИсполнителя, ПредставлениеРезультата
	
	Если Не ЗначениеЗаполнено(Контекст) Или Событие <> Справочники.СобытияЗадач.Выполнение Тогда				
		
		Описание = Новый Структура("ПредставлениеИсполнителя, ПредставлениеРезультата",
			"", "" );
		МассивВозврата.Добавить(Описание);
		Возврат МассивВозврата;
		
	КонецЕсли;	
	
	Если Контекст.Свойство("ФактическийПодписант")
		И ЗначениеЗаполнено(Контекст.ФактическийПодписант) Тогда		
		
		Описание = Новый Структура("ПредставлениеИсполнителя, ПредставлениеРезультата",
			Контекст.ФактическийПодписант, Строка(Контекст.РезультатДействия) );
		МассивВозврата.Добавить(Описание);
		
	КонецЕсли;
	
	Если Контекст.Свойство("ФактическийИсполнитель")
		И ЗначениеЗаполнено(Контекст.ФактическийИсполнитель) Тогда		
		
		Описание = Новый Структура("ПредставлениеИсполнителя, ПредставлениеРезультата",
			Строка(Контекст.ФактическийИсполнитель), "");
			
		Если Контекст.Свойство("ФактическийПодписант")
			И ЗначениеЗаполнено(Контекст.ФактическийПодписант) Тогда		
			Описание.ПредставлениеРезультата = НСтр("ru = 'Обеспечил(а) подписание'", КодЯзыка);
		КонецЕсли;	
		
		
		МассивВозврата.Добавить(Описание);
		Возврат МассивВозврата;
		
	КонецЕсли;
	
	Если Контекст.Свойство("УточненныйИсполнитель")
		И ЗначениеЗаполнено(Контекст.УточненныйИсполнитель)
		И Контекст.УточненныйИсполнитель <> Контекст.Исполнитель Тогда
		
		#Удаление
		ПредставлениеИсполнителя = СтрШаблон(
			НСтр("ru = '%1 (отметил(а) %2)'", КодЯзыка),
				Строка(Контекст.УточненныйИсполнитель),
				Строка(Контекст.Исполнитель));
		#КонецУдаления
		#Вставка 
		ПредставлениеИсполнителя = Строка(Контекст.УточненныйИсполнитель);
		#КонецВставки 
				
		Описание = Новый Структура("ПредставлениеИсполнителя, ПредставлениеРезультата",
			ПредставлениеИсполнителя, "");
		МассивВозврата.Добавить(Описание);
		Возврат МассивВозврата;
		
	КонецЕсли;
	
	ПредставлениеИсполнителя = Строка(Контекст.Исполнитель);
	Если Не ЗначениеЗаполнено(Контекст.ОснованиеФактическогоИсполнителя) 
		И (Не ЗначениеЗаполнено(Контекст.ПлановыйИсполнитель) Или Контекст.ПлановыйИсполнитель = Контекст.Исполнитель) Тогда
		
		Описание = Новый Структура("ПредставлениеИсполнителя, ПредставлениеРезультата",
			ПредставлениеИсполнителя, "");
		МассивВозврата.Добавить(Описание);
		Возврат МассивВозврата;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контекст.ОснованиеФактическогоИсполнителя) Тогда
		
		РеквизитыЗамещения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Контекст.ОснованиеФактическогоИсполнителя,
			"ВидЗамещения, Сотрудник, Замещающий");			
		Если РеквизитыЗамещения.ВидЗамещения = Перечисления.ВидыЗамещения.Замещающие Тогда
			
			ПредставлениеИсполнителя = СтрШаблон(
				НСтр("ru = '%1 (за %2)'", КодЯзыка),
				Строка(Контекст.Исполнитель),
				СклонениеПредставленийОбъектовДокументооборот.ПросклонятьПредставление(
					РеквизитыЗамещения.Сотрудник,
					4)); // Винительный
			
		Иначе
			
			#Удаление
			ПредставлениеИсполнителя = СтрШаблон(
				НСтр("ru = '%1 (отметил(а) %2)'", КодЯзыка),
					Строка(Контекст.Исполнитель),
					Строка(РеквизитыЗамещения.Замещающий));
            #КонецУдаления
			#Вставка 
			ПредставлениеИсполнителя = Строка(Контекст.Исполнитель);
			#КонецВставки 
			
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(Контекст.ПлановыйИсполнитель) Тогда
		
		ПредставлениеИсполнителя = СтрШаблон(
			НСтр("ru = '%1 (за %2)'", КодЯзыка),
			Строка(Контекст.Исполнитель),
			СклонениеПредставленийОбъектовДокументооборот.ПросклонятьПредставление(
				Контекст.ПлановыйИсполнитель,
				2)); // Родительный
		
	КонецЕсли;
	
	Описание = Новый Структура("ПредставлениеИсполнителя, ПредставлениеРезультата",
		ПредставлениеИсполнителя, "");
	МассивВозврата.Добавить(Описание);
	
	Возврат МассивВозврата;
	
КонецФункции
