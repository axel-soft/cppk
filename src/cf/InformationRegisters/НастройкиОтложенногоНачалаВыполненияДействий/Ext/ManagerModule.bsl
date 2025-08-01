﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет действие в очередь для отложенного старта
//
// Параметры:
//   Действие - СправочникССылка.ДействияОзнакомления
//   ДатаСтарта - Дата - дата отложенного старта
//   ДобавлениеБезСтарта - Булево - Если Истина, тогда действие будет добавлено в очередь отложенного старта,
//                                  но не будет стартовано (его стояние будет равно 
//                                  Перечисления.СостоянияДействийДляЗапуска.ПустаяСсылка)
//
Процедура Добавить(Действие, ДатаСтарта, ДобавлениеБезСтарта = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиОтложенногоНачалаВыполненияДействий");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Действие", Действие);
	
	НачатьТранзакцию();
	
	Попытка
	
		Блокировка.Заблокировать();
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Действие.Установить(Действие);
		
		Запись = НаборЗаписей.Добавить();
		Запись.Действие = Действие;
		Запись.ДатаОтложенногоСтарта = ДатаСтарта;    
		
		РеквДействия = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Действие, "Предмет, УзелОбработки");
		Запись.УзелОбработки = РеквДействия.УзелОбработки;
		Запись.Предмет = РеквДействия.Предмет;   
		
		Запись.АвторДобавленияЗаписи = Сотрудники.ОсновнойСотрудник();
		
		Если Не ДобавлениеБезСтарта Тогда
			Запись.Состояние = Перечисления.СостоянияЗапускаДействий.ГотовоКСтарту;
		КонецЕсли;
		
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Удаляет действие из очереди для фонового старта
//
// Параметры:
//   - Действие - СправочникССылка.ДействияОзнакомления
//
Процедура Удалить(Ознакомление) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиОтложенногоНачалаВыполненияДействий");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Действие", Ознакомление);
	
	НачатьТранзакцию();
	
	Попытка
	
		Блокировка.Заблокировать();
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Действие.Установить(Ознакомление);
		
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Возвращает сведения о запуске для Действие
//
// Параметры:
//   - Действие - СправочникССылка.ДействияОзнакомления
//
// Возвращаемое значение:
//   - Неопределено - Возвращается если сведений нет.
//   - Структура - если есть.
//       - Действие - СправочникССылка.ДействияОзнакомления
//       - ДатаОтложенногоСтарта - ДатаИВремя
//       - Состояние - ПеречислениеСсылка.СостоянияДействийДляЗапуска
//
Функция ПолучитьСведенияОЗапускеДействия(Действие) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Неопределено;
	
	Если Не ЗначениеЗаполнено(Действие) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДействияДляЗапуска.Действие КАК Действие,
		|	ДействияДляЗапуска.ДатаОтложенногоСтарта КАК ДатаОтложенногоСтарта,
		|	ДействияДляЗапуска.Состояние КАК Состояние
		|ИЗ
		|	РегистрСведений.НастройкиОтложенногоНачалаВыполненияДействий КАК ДействияДляЗапуска
		|ГДЕ
		|	ДействияДляЗапуска.Действие = &Действие";
	Запрос.УстановитьПараметр("Действие", Действие);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Результат = Новый Структура;
		Результат.Вставить("Действие", Выборка.Действие);
		Результат.Вставить("ДатаОтложенногоСтарта", Выборка.ДатаОтложенногоСтарта);
		Результат.Вставить("Состояние", Выборка.Состояние);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Увеличивает счетчик попыток старта действия
//
// Параметры:
//   - Действие - СправочникССылка.ДействияОзнакомления
//
Процедура ЗарегистрироватьПопыткуСтарта(Ознакомление) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	УстановитьБезопасныйРежим(Истина);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиОтложенногоНачалаВыполненияДействий");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Действие", Ознакомление);
	
	НачатьТранзакцию();
	
	Попытка
	
		Блокировка.Заблокировать();
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Действие.Установить(Ознакомление);
		
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0 Тогда
			Запись = НаборЗаписей[0];
			Запись.КоличествоПопытокОбработки = Запись.КоличествоПопытокОбработки + 1;
			НаборЗаписей.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Добавляет сведения об успешном старте действия
//
// Параметры:
//   - Действие - СправочникССылка.ДействияОзнакомления
//
Процедура ЗарегистрироватьСтарт(Ознакомление) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиОтложенногоНачалаВыполненияДействий");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Действие", Ознакомление);
	
	НачатьТранзакцию();
	
	Попытка
	
		Блокировка.Заблокировать();
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Действие.Установить(Ознакомление);
		
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0 Тогда
			НаборЗаписей[0].Состояние = Перечисления.СостоянияЗапускаДействий.Стартовано;
			НаборЗаписей.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Добавляет сведенья об отмене старта действия
//
// Параметры:
//   - Действие - СправочникССылка.ДействияОзнакомления
//
Процедура ЗарегистрироватьОтменуСтарта(Ознакомление, ПричинаОтмены) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиОтложенногоНачалаВыполненияДействий");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Действие", Ознакомление);
	
	НачатьТранзакцию();
	
	Попытка
	
		Блокировка.Заблокировать();
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Действие.Установить(Ознакомление);
		
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0 Тогда
			НаборЗаписей[0].Состояние = Перечисления.СостоянияЗапускаДействий.СтартОтменен;
			НаборЗаписей[0].ТекстОшибки = ПричинаОтмены;
			НаборЗаписей.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
