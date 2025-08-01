﻿
&ИзменениеИКонтроль("СформироватьДанныеВиджета")
Функция ЦППК_СформироватьДанныеВиджета(Выборка, ДанныеБлоковНавигации, ДанныеКоманд, ДанныеПоказателей)

	ДанныеВиджета = НовыйДанныеВиджета();
	ДанныеВиджета.Имя = ?(ЗначениеЗаполнено(Выборка.ИмяПредопределенныхДанных),
		Выборка.ИмяПредопределенныхДанных,
		СтрЗаменить(Строка(Выборка.Ссылка.УникальныйИдентификатор()), "-", ""));
	ДанныеВиджета.Ссылка = Выборка.Ссылка;
	
	ДанныеВиджета.Наименование = Выборка.Наименование;
	ДанныеВиджета.Заголовок = Выборка.Заголовок;
	ДанныеВиджета.ПредставлениеПустого = Выборка.ПредставлениеПустого;

	КонфигурацияИспользуетТолькоОдинЯзык = МультиязычностьПовтИсп.КонфигурацияИспользуетТолькоОдинЯзык(Ложь);
	Если Не КонфигурацияИспользуетТолькоОдинЯзык И Не МультиязычностьСервер.ЭтоОсновнойЯзык() Тогда
		ДанныеВиджета.Наименование = Выборка.НаименованиеЯзык1;
		ДанныеВиджета.Заголовок = Выборка.ЗаголовокЯзык1;
		ДанныеВиджета.ПредставлениеПустого = Выборка.ПредставлениеПустогоЯзык1;
	КонецЕсли;
	
	ДанныеВиджета.ПоложениеЗаголовка = Выборка.ПоложениеЗаголовка;
	ДанныеВиджета.КомандаНастройки = Выборка.КомандаНастройки;
	ДанныеВиджета.Компоновка = Выборка.Компоновка.Выгрузить();
	ДанныеВиджета.Компоновка.Сортировать("НомерСтроки Возр");
	ДанныеВиджета.Вид = Выборка.Вид;
	ДанныеВиджета.Цвет = Выборка.Цвет;
	ДанныеВиджета.ДоступенДляВыбора = Выборка.ДоступенДляВыбора;
	ДанныеВиджета.МинимальноеЗначение = Выборка.МинимальноеЗначение;
	ДанныеВиджета.МаксимальноеЗначение = Выборка.МаксимальноеЗначение;
	ДанныеВиджета.ВысотаСхемы = Выборка.ВысотаСхемы;
	ДанныеВиджета.ШиринаСхемы = Выборка.ШиринаСхемы;
	ДанныеВиджета.МаксимальноеЗначение = Выборка.МаксимальноеЗначение;
	
	Если ЗначениеЗаполнено(Выборка.Картинка) Тогда
		ДанныеВиджета.Картинка = БиблиотекаКартинок[Выборка.Картинка];
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Выборка.МК_Картинка) Тогда
		ДанныеВиджета.МК_Картинка = БиблиотекаКартинок[Выборка.МК_Картинка];
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Выборка.ТипДиаграммы) Тогда
		ДанныеВиджета.ТипДиаграммы = ТипДиаграммы[Выборка.ТипДиаграммы];
	КонецЕсли;
	
	Команды = Выборка.Команды.Выгрузить();
	Команды.Сортировать("НомерСтроки Возр");
	Для Каждого СтрокаКоманды Из Команды Цикл
		
		ДанныеКоманды = ДанныеКоманд[СтрокаКоманды.Команда];
		Если ДанныеКоманды = Неопределено Тогда
			ДанныеВиджета.ВиджетДоступен = Ложь;
			Продолжить;
		КонецЕсли;
		
		ДанныеВиджета.Команды.Добавить(ДанныеКоманды);
		
	КонецЦикла;
	
	ОсновныеПоказатели = Выборка.ОсновныеПоказатели.Выгрузить();
	ОсновныеПоказатели.Сортировать("НомерСтроки Возр");
	Для Каждого СтрокаПоказателя Из ОсновныеПоказатели Цикл
		
		ДанныеПоказателя = Справочники.ПоказателиВиджетов.ДанныеПоказателя(СтрокаПоказателя.Показатель);
		Если ДанныеПоказателя = Неопределено Тогда
			ДанныеВиджета.ВиджетДоступен = Ложь;
			Продолжить;
		КонецЕсли;
		
		ДанныеВиджета.ОсновныеПоказатели.Добавить(ДанныеПоказателя);
		
	КонецЦикла;
	
	ПоказателиЗаголовка = Выборка.ПоказателиЗаголовка.Выгрузить();
	ПоказателиЗаголовка.Сортировать("НомерСтроки Возр");
	Для Каждого СтрокаПоказателя Из ПоказателиЗаголовка Цикл
		
		ДанныеПоказателя = ДанныеПоказателей[СтрокаПоказателя.Показатель];
		Если ДанныеПоказателя = Неопределено Тогда
			ДанныеВиджета.ВиджетДоступен = Ложь;
			Продолжить;
		КонецЕсли;
		
		ДанныеВиджета.ПоказателиЗаголовка.Добавить(ДанныеПоказателя);
		
	КонецЦикла;
	
	ДополнительныеПоказатели = Выборка.ДополнительныеПоказатели.Выгрузить();
	ДополнительныеПоказатели.Сортировать("НомерСтроки Возр");
	Для Каждого СтрокаПоказателя Из ДополнительныеПоказатели Цикл
		
		ДанныеПоказателя = ДанныеПоказателей[СтрокаПоказателя.Показатель];
		Если ДанныеПоказателя = Неопределено Тогда
			ДанныеВиджета.ВиджетДоступен = Ложь;
			Продолжить;
		КонецЕсли;
		
		ДанныеВиджета.ДополнительныеПоказатели.Добавить(ДанныеПоказателя);
		
	КонецЦикла;
	
	ЕстьБлокиНавигации = Ложь;
	ЕстьДоступныеБлокиНавигации = Ложь;
	БлокиНавигации = Выборка.БлокиНавигации.Выгрузить();
	#Вставка
	Если БлокиНавигации.Количество() И Не Пользователи.РолиДоступны("ПолныеПрава") Тогда
		
		БлокНастройкиМДК = Справочники.БлокиНавигации.НайтиПоНаименованию("Настройки_МДК");
		БлокСправочникиМДК = Справочники.БлокиНавигации.НайтиПоНаименованию("Справочники_МДК");
		
		Если ЗначениеЗаполнено(БлокНастройкиМДК) И ЗначениеЗаполнено(БлокСправочникиМДК) Тогда
			
			БлокНастройкиТиповой = БлокиНавигации.Найти(Справочники.БлокиНавигации.Настройки);
			Если БлокНастройкиТиповой <> Неопределено Тогда
				
				НомерСтроки = БлокНастройкиТиповой.НомерСтроки;
				СсылкаБлока = БлокНастройкиТиповой.Ссылка; 
				БлокиНавигации.Удалить(БлокНастройкиТиповой);
				СтрокаНовая = БлокиНавигации.Добавить();
				СтрокаНовая.НомерСтроки = НомерСтроки;
				СтрокаНовая.Ссылка = СсылкаБлока;
				СтрокаНовая.БлокНавигации = БлокНастройкиМДК;
				
			КонецЕсли;
			
			БлокСправочникиТиповой = БлокиНавигации.Найти(Справочники.БлокиНавигации.БлокСправочники);
			Если БлокСправочникиТиповой <> Неопределено Тогда
				
				НомерСтроки = БлокСправочникиТиповой.НомерСтроки;
				СсылкаБлока = БлокСправочникиТиповой.Ссылка; 
				БлокиНавигации.Удалить(БлокСправочникиТиповой);
				СтрокаНовая = БлокиНавигации.Добавить();
				СтрокаНовая.НомерСтроки = НомерСтроки;
				СтрокаНовая.Ссылка = СсылкаБлока;
				СтрокаНовая.БлокНавигации = БлокСправочникиМДК;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	#КонецВставки
	БлокиНавигации.Сортировать("НомерСтроки Возр");
	Для Каждого СтрокаБлокаНавигации Из БлокиНавигации Цикл
		
		ЕстьБлокиНавигации = Истина;
		ДанныеБлокаНавигации = ДанныеБлоковНавигации[СтрокаБлокаНавигации.БлокНавигации];
		Если ДанныеБлокаНавигации = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЕстьДоступныеБлокиНавигации = Истина;
		ДанныеВиджета.БлокиНавигации.Добавить(ДанныеБлокаНавигации);
		
	КонецЦикла;
	Если ЕстьБлокиНавигации И Не ЕстьДоступныеБлокиНавигации Тогда
		ДанныеВиджета.ВиджетДоступен = Ложь;
	КонецЕсли;
	
	ДополнительныеКоманды = Выборка.ДополнительныеКоманды.Выгрузить();
	ДополнительныеКоманды.Сортировать("НомерСтроки Возр");
	Для Каждого СтрокаКоманды Из ДополнительныеКоманды Цикл
		
		ДанныеКоманды = ДанныеКоманд[СтрокаКоманды.Команда];
		Если ДанныеКоманды = Неопределено Тогда
			ДанныеВиджета.ВиджетДоступен = Ложь;
			Продолжить;
		КонецЕсли;
		
		ДанныеВиджета.ДополнительныеКоманды.Добавить(ДанныеКоманды);
		
	КонецЦикла;
	
	Если (ДанныеВиджета.Вид = Перечисления.ВидыВиджетов.Диаграмма
		Или ДанныеВиджета.Вид = Перечисления.ВидыВиджетов.ДиаграммаСЛегендой)
		И ДанныеВиджета.ТипДиаграммы <> ТипДиаграммы.ГистограммаСНакоплением
		И ДанныеВиджета.ТипДиаграммы <> ТипДиаграммы.Кольцевая Тогда
		ДанныеВиджета.ВиджетДоступен = Ложь;
	КонецЕсли;
	
	Возврат ДанныеВиджета
	
КонецФункции
