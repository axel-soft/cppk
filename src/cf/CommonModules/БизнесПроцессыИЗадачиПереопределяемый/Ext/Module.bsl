﻿///////////////////////////////////////////////////////////////////////////////
// ИНТЕРФЕЙСНАЯ ЧАСТЬ ПЕРЕОПРЕДЕЛЯЕМОГО МОДУЛЯ

// Возвращает адрес электронной почты пользователя ПользовательСсылка.
//
// Параметры
//  ПользовательСсылка  - СправочникСсылка.Пользователи
//  Адрес               - Строка - возвращаемый адрес электронной почты.
//
Процедура ПолучитьАдресЭлектроннойПочты(Знач ПользовательСсылка, Адрес) Экспорт
	
	// КонтактнаяИнформация
	Адрес = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
		ПользовательСсылка,
		Справочники.ВидыКонтактнойИнформации.EmailПользователя,,
		ТекущаяДатаСеанса());
	// Конец КонтактнаяИнформация
	
КонецПроцедуры 

// Вызывается для обновления данных бизнес-процесса в регистре сведений 
// ДанныеБизнесПроцессов.
// 
// Параметры
//  Запись       - РегистрСведенийЗапись.ДанныеБизнесПроцессов
//
Процедура ПриЗаписиСпискаБизнесПроцессов(Запись) Экспорт
КонецПроцедуры

// Вызывается для проверки прав на остановку и продолжение бизнес-процесса
// Параметры
//  БизнесПроцесс       - Ссылка на бизнес-процесс
//
Функция ЕстьПраваНаОстановкуБизнесПроцесса(БизнесПроцесс) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Вызывается для заполнения реквизита ГлавнаяЗадача из данных заполнения
// Параметры
//  БизнесПроцессОбъект       - бизнес-процесс
//  ДанныеЗаполнения		  - данные заполнения, которые передаются в обработчик заполнения	
//
Функция ЗаполнитьГлавнуюЗадачу(БизнесПроцессОбъект, ДанныеЗаполнения) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает Истина, если используется подсистема ВнешниеЗадачиИБизнесПроцессы
Функция ИспользоватьВнешниеЗадачиИБизнесПроцессы() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает содержание переданного объекта
// Параметры
// Объект - объект, представление которого надо сформировать
// Возвращает содержание в виде HTML или MXL документа
Функция ПолучитьСодержание(Объект) Экспорт
	
КонецФункции

// Возвращает массив объектов типа ОписаниеПередаваемогоФайла
// или Неопределено
Функция ПолучитьСписокФайлов(Источник) Экспорт
	
КонецФункции

// Возвращает Истина, если задача является внешней 
Функция ЭтоВнешняяЗадача(ЗадачаСсылка) Экспорт
	
КонецФункции

// Помечает задачу-источник как выполненную
Процедура ВыполнитьЗадачуИсточник(БизнесПроцесс) Экспорт
	
КонецПроцедуры

// Вызывается для заполнения параметров формы внешней задачи
//
// Параметры:
//  ИмяБизнесПроцесса           - Строка - название бизнес-процесса
//  ЗадачаСсылка                - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//  ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка.Задание - действие.
//  ПараметрыФормы              - Структура - описание выполнения задачи.
//   Ключ "ИмяФормы" содержит имя формы, передаваемое в метод контекста ОткрытьФорму(). 
//   Ключ "ПараметрыФормы" содержит параметры формы.
//
// Пример заполнения:
//  Если ИмяБизнесПроцесса = "Задание" Тогда
//      ИмяФормы = "БизнесПроцесс.Задание.Форма.ВнешнееДействие" + ТочкаМаршрутаБизнесПроцесса.Имя;
//      ПараметрыФормы.Вставить("ИмяФормы", ИмяФормы);
//  КонецЕсли;
//
Процедура ПриПолученииФормыВыполненияЗадачи(ИмяБизнесПроцесса, ЗадачаСсылка,
											ТочкаМаршрутаБизнесПроцесса, ПараметрыФормы) Экспорт
	
КонецПроцедуры
