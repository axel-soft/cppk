﻿
#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьАдресатовПоФИО(МассивВозвратаАргумент, ТекстОшибок) Экспорт
	
	ИспользованныеАдреса = Новый Соответствие;
	МассивВозврата = Новый Массив;
	
	Для каждого СтруктураПочтовогоАдреса Из МассивВозвратаАргумент Цикл
		
		Если ИспользованныеАдреса.Получить(СтруктураПочтовогоАдреса.ФИО) = Неопределено Тогда
			
			ИспользованныеАдреса.Вставить(СтруктураПочтовогоАдреса.ФИО, 1);    
			
			Контакт = СтруктураПочтовогоАдреса.ФИО;
			Адрес = ВстроеннаяПочтаСервер.ПолучитьОсновнойАдрес(Контакт);
			Если ЗначениеЗаполнено(Адрес) Тогда         
				
				СтруктураПочтовогоАдреса.Вставить("Контакт", Контакт);
				СтруктураПочтовогоАдреса.Вставить("Адрес", Адрес);
				
				Адресат = ВстроеннаяПочтаСервер.ПолучитьПочтовогоАдресата(Адрес);
				СтруктураПочтовогоАдреса.Вставить("Адресат", Адресат); 
				
				ПредставлениеАдресата = ВстроеннаяПочтаСервер.ПолучитьПредставлениеИКонтактАдресата(Адресат);
				СтруктураПочтовогоАдреса.Представление = ПредставлениеАдресата.Представление;
				
				СтруктураПочтовогоАдреса.Внешний = ПредставлениеАдресата.Внешний;
				СтруктураПочтовогоАдреса.ВидМаршрутизации = ПредставлениеАдресата.ВидМаршрутизации;
				
				МассивВозврата.Добавить(СтруктураПочтовогоАдреса);
				
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ТекстОшибок) Тогда 
		ТекстОшибок = ТекстОшибок + Символы.ПС +
			НСтр("ru = 'Проверьте правильность написания перечисленных адресатов и повторите добавление пользователей'");
	КонецЕсли;
	
	МассивВозвратаАргумент = МассивВозврата;
	
КонецПроцедуры

#КонецОбласти