﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Записывает настройку календаря в регистр сведений
Функция УстановитьНастройку(ФизическоеЛицо, Событие, Настройка, ЗначениеНастройки) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
	
		ИзмененоЗначениеНастройки = Ложь;
		
		МенеджерЗаписи = РегистрыСведений.НастройкиОтображенияЗаписейРабочегоКалендаря.СоздатьМенеджерЗаписи();
		
		МенеджерЗаписи.ФизическоеЛицо = ФизическоеЛицо;
		МенеджерЗаписи.Событие = Событие;
		МенеджерЗаписи.Настройка = Настройка;
		
		МенеджерЗаписи.Прочитать();
		
		Если МенеджерЗаписи.ЗначениеНастройки <> ЗначениеНастройки Тогда
			
			ИзмененоЗначениеНастройки = Истина;
			
			МенеджерЗаписи.ФизическоеЛицо = ФизическоеЛицо;
			МенеджерЗаписи.Событие = Событие;
			МенеджерЗаписи.Настройка = Настройка;
			МенеджерЗаписи.ЗначениеНастройки = ЗначениеНастройки;
			МенеджерЗаписи.Записать();
			
			// Удаляем записи из устаревшего регистра.
			Запрос = Новый Запрос;
			Запрос.Текст =
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	НастройкиОтображенияЗаписейРабочегоКалендаряПользователя.Пользователь
				|ИЗ
				|	РегистрСведений.НастройкиОтображенияЗаписейРабочегоКалендаряПользователя КАК
				|		НастройкиОтображенияЗаписейРабочегоКалендаряПользователя
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
				|		ПО НастройкиОтображенияЗаписейРабочегоКалендаряПользователя.Пользователь = Пользователи.Ссылка
				|ГДЕ
				|	Пользователи.ФизЛицо = &ФизЛицо
				|	И НастройкиОтображенияЗаписейРабочегоКалендаряПользователя.Событие = &Событие
				|	И НастройкиОтображенияЗаписейРабочегоКалендаряПользователя.Настройка = &Настройка";
			
			Запрос.УстановитьПараметр("ФизЛицо", ФизическоеЛицо);
			Запрос.УстановитьПараметр("Событие", Событие);
			Запрос.УстановитьПараметр("Настройка", Настройка);
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				Набор = РегистрыСведений.НастройкиОтображенияЗаписейРабочегоКалендаряПользователя.СоздатьНаборЗаписей();
				Набор.Отбор.Пользователь.Установить(Выборка.Пользователь);
				Набор.Записать();
			КонецЦикла;
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат ИзмененоЗначениеНастройки;
	
КонецФункции

// Читает настройку календаря из регистра сведений
Функция ПолучитьНастройку(ФизическоеЛицо, Событие, Настройка) Экспорт
		
	Если НЕ ЗначениеЗаполнено(Событие) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	НастройкиОтображенияЗаписейРабочегоКалендаря.ЗначениеНастройки
		|ИЗ
		|	РегистрСведений.НастройкиОтображенияЗаписейРабочегоКалендаря КАК НастройкиОтображенияЗаписейРабочегоКалендаря
		|ГДЕ
		|	НастройкиОтображенияЗаписейРабочегоКалендаря.ФизическоеЛицо = &ФизЛицоПользователя
		|	И НастройкиОтображенияЗаписейРабочегоКалендаря.Событие = &Событие
		|	И НастройкиОтображенияЗаписейРабочегоКалендаря.Настройка = &Настройка");
	Запрос.УстановитьПараметр("ФизЛицоПользователя", ФизическоеЛицо);
	Запрос.УстановитьПараметр("Событие", Событие);
	Запрос.УстановитьПараметр("Настройка", Настройка);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		// Если настроек не найдено, то ищем в устаревшем регистре.
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	НастройкиОтображенияЗаписейРабочегоКалендаря.ЗначениеНастройки
			|ИЗ
			|	РегистрСведений.НастройкиОтображенияЗаписейРабочегоКалендаряПользователя КАК НастройкиОтображенияЗаписейРабочегоКалендаря
			|ГДЕ
			|	НастройкиОтображенияЗаписейРабочегоКалендаря.Пользователь = &Пользователь
			|	И НастройкиОтображенияЗаписейРабочегоКалендаря.Событие = &Событие
			|	И НастройкиОтображенияЗаписейРабочегоКалендаря.Настройка = &Настройка";
		
		Запрос.УстановитьПараметр("Пользователь", ПользователиДокументооборот.ПользовательФизЛица(ФизическоеЛицо));
		Запрос.УстановитьПараметр("Событие", Событие);
		Запрос.УстановитьПараметр("Настройка", Настройка);
		
		Результат = Запрос.Выполнить();
		
	КонецЕсли;
	
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.ЗначениеНастройки;
	
КонецФункции

#КонецОбласти

#КонецЕсли