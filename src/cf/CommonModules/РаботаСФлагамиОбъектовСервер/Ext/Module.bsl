﻿
////////////////////////////////////////////////////////////////////////////////
// РАБОТА С ФЛАГАМИ ОБЪЕКТОВ СЕРВЕР
// Модуль содержит серверные процедуры и
// функции для работы с флагами объектов.
// Выполняется на сервере.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Устанавливает флаг массиву объектов для основного сотрудника текущего пользователя
//
// Параметры:
//	Объекты - Массив - массив объектов, которым устанавливается флаг.
//	Флаг - ПеречислениеСсылка.ФлагиОбъектов
//
Процедура УстановитьФлагОбъектам(Объекты, Флаг) Экспорт
	
	ФизическоеЛицоПользователя = ПараметрыСеанса.ФизическоеЛицоПользователя;
	
	Для Каждого Объект Из Объекты Цикл
		УстановитьФлагОбъекту(Объект, Флаг, ФизическоеЛицоПользователя);
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает флаг объекту от имени основного сотрудника текущего пользователя.
// 
// Параметры:
//  Объект - ДокументСсылка.ВходящееПисьмо,
//           ЗадачаСсылка.ЗадачаИсполнителя,
//           ДокументСсылка.ИсходящееПисьмо.
//  Флаг - ПеречислениеСсылка.ФлагиОбъектов
//  ОтключитьОбновлениеЗадач - Булево.
//
Процедура УстановитьФлагОбъектуОтОсновногоСотрудника(Объект, Флаг, ОтключитьОбновлениеЗадач = Ложь) Экспорт
	
	УстановитьФлагОбъекту(Объект, Флаг, ПараметрыСеанса.ФизическоеЛицоПользователя, ОтключитьОбновлениеЗадач);
	
КонецПроцедуры

// Сохраняет флаг для объекта из формы. При этом в форме должны быть реквизиты
// Флаг и Объект. В случае если данные реквизиты будут отсутствовать, то будет
// сформировано исключение.
//
// Параметры;
//	 - ФормаОбъекта - ФормаКлиентскогоПриложения - форма из которой следует сохранить значение
//					  флага для основного объекта формы.
//
Процедура СохранитьФлагОбъектаИзФормы(ФормаОбъекта) Экспорт
	
	Попытка
		Ссылка = ФормаОбъекта.Объект.Ссылка;
	Исключение
		ВызватьИсключение НСтр("ru = 'Ошибка при получении ссылки основного объекта формы!'");
	КонецПопытки;
	
	Попытка
		Флаг = ФормаОбъекта.Флаг;
	Исключение
		ВызватьИсключение НСтр("ru = 'Ошибка при получении реквизита Флаг формы!'");
	КонецПопытки;
	
	УстановитьФлагОбъектуОтОсновногоСотрудника(Ссылка, Флаг);
	
КонецПроцедуры

// Заполняет значение реквизита Флаг и отображает соответствующую ему картинку в
// элементе формы ПодменюФлаги.
//
// Параметры:
//	 - ФормаОбъекта - ФормаКлиентскогоПриложения - форма, в которой следует отобразить флаг
//					  объекта.
//
Процедура ОтобразитьФлагВФормеОбъекта(ФормаОбъекта) Экспорт
	
	Попытка
		СсылкаНаОбъект = ФормаОбъекта.Объект.Ссылка;
	Исключение
		ВызватьИсключение НСтр("ru = 'Ошибка при получении ссылки основного объекта формы!'");
	КонецПопытки;
	
	ИнформацияОФлагеЗадачи = ПолучитьИнформациюОФлагеОбъекта(СсылкаНаОбъект);
	
	Попытка
		ФормаОбъекта.Флаг = ИнформацияОФлагеЗадачи.Флаг;
	Исключение
		ВызватьИсключение НСтр("ru = 'Ошибка при заполнении реквизита Флаг в форме!'");
	КонецПопытки;
	
	Попытка
		ФормаОбъекта.Элементы.ПодменюФлаги.Картинка = ИнформацияОФлагеЗадачи.Картинка;
	Исключение
		ВызватьИсключение НСтр("ru = 'Ошибка при обращении к элементу ПодменюФлаги в форме!'");
	КонецПопытки;
	
КонецПроцедуры

// Возвращает флаг по умолчанию для задач для текущего пользователя.
// Если у пользователя отсутствуют настройка, то возвращается значение
// Перечисления.ФлагиОбъектов.Красный.
// 
// Возвращаемое значение:
//	 - ПеречислениеСсылка.ФлагиОбъектов
//
Функция ПолучитьФлагДляЗадачПоУмолчанию() Экспорт
	
	ФлагЗадачПоУмолчанию = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ФлагиОбъектов",
		"ФлагПоУмолчаниюДляЗадач",
		Перечисления.ФлагиОбъектов.Красный);
		
	Возврат ФлагЗадачПоУмолчанию;
	
КонецФункции

// Возвращает флаг по умолчанию для писем для текущего пользователя.
// Если у пользователя отсутствуют настройка, то возвращается значение
// Перечисления.ФлагиОбъектов.Красный.
// 
// Возвращаемое значение:
//	 - ПеречислениеСсылка.ФлагиОбъектов
//
Функция ПолучитьФлагДляПисемПоУмолчанию() Экспорт
	
	ФлагЗадачПоУмолчанию = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ФлагиОбъектов",
		"ФлагПоУмолчаниюДляПисем",
		Перечисления.ФлагиОбъектов.Красный);
		
	Возврат ФлагЗадачПоУмолчанию;
	
КонецФункции

// Переключает флаг письма между значениями пустого флага
// и флагом по умолчанию для основного сотрудника текущего пользователя.
// В случае если письму назначен флаг отличный от флага по
// умолчанию, то произойдет установка пустого значения.
//
Процедура ПереключитьФлагПисьма(Письмо) Экспорт
	
	ФлагПисемПоУмолчанию = ПолучитьФлагДляПисемПоУмолчанию();
	ФизическоеЛицоПользователя = ПараметрыСеанса.ФизическоеЛицоПользователя;
	
	РегистрыСведений.ФлагиОбъектов.ПереключитьФлаг(
		Письмо,
		ФизическоеЛицоПользователя,
		ФлагПисемПоУмолчанию);
	
КонецПроцедуры

// Возвращает номер флага.
// Соответствие номеров и флагов:
//	Перечисления.ФлагиОбъектов.ПустаяСсылка - 0
//	Перечисления.ФлагиОбъектов.Красный - 1
//	Перечисления.ФлагиОбъектов.Синий - 2
//	Перечисления.ФлагиОбъектов.Желтый - 3
//	Перечисления.ФлагиОбъектов.Зеленый - 4
//	Перечисления.ФлагиОбъектов.Оранжевый - 5
//	Перечисления.ФлагиОбъектов.Лиловый - 6
//
// Возвращаемое значение:
//	 - Число
//
Функция ПолучитьНомерФлага(Флаг) Экспорт
	
	Результат = 0;
	
	Если Флаг = Перечисления.ФлагиОбъектов.Красный Тогда
		Результат = 1;
	ИначеЕсли Флаг = Перечисления.ФлагиОбъектов.Синий Тогда
		Результат = 2;
	ИначеЕсли Флаг = Перечисления.ФлагиОбъектов.Желтый Тогда
		Результат = 3;
	ИначеЕсли Флаг = Перечисления.ФлагиОбъектов.Зеленый Тогда
		Результат = 4;
	ИначеЕсли Флаг = Перечисления.ФлагиОбъектов.Оранжевый Тогда
		Результат = 5;
	ИначеЕсли Флаг = Перечисления.ФлагиОбъектов.Лиловый Тогда
		Результат = 6;
	Иначе
		Результат = 0;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьИнформациюОФлагеОбъекта(Объект) Экспорт
	
	Флаг = РегистрыСведений.ФлагиОбъектов.ПолучитьФлаг(Объект, ПараметрыСеанса.ФизическоеЛицоПользователя);
	
	Если Флаг = Перечисления.ФлагиОбъектов.Красный Тогда
		Картинка = БиблиотекаКартинок.КрасныйФлаг;
	ИначеЕсли Флаг = Перечисления.ФлагиОбъектов.Синий Тогда
		Картинка = БиблиотекаКартинок.СинийФлаг;
	ИначеЕсли Флаг = Перечисления.ФлагиОбъектов.Желтый Тогда
		Картинка = БиблиотекаКартинок.ЖелтыйФлаг;
	ИначеЕсли Флаг = Перечисления.ФлагиОбъектов.Зеленый Тогда
		Картинка = БиблиотекаКартинок.ЗеленыйФлаг;
	ИначеЕсли Флаг = Перечисления.ФлагиОбъектов.Оранжевый Тогда
		Картинка = БиблиотекаКартинок.ОранжевыйФлаг;
	ИначеЕсли Флаг = Перечисления.ФлагиОбъектов.Лиловый Тогда
		Картинка = БиблиотекаКартинок.ЛиловыйФлаг;
	Иначе
		Картинка = БиблиотекаКартинок.ПустойФлаг;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Флаг", Флаг);
	Результат.Вставить("Картинка", Картинка);
	
	Возврат Результат;
	
КонецФункции

// Установить флаг объекту.
// 
// Параметры:
//  Объект - ДокументСсылка.ВходящееПисьмо,
//           ЗадачаСсылка.ЗадачаИсполнителя,
//           ДокументСсылка.ИсходящееПисьмо.
//  Флаг - ПеречислениеСсылка.ФлагиОбъектов
//  ТекущийСотрудник - СправочникСсылка.Сотрудники.
//  ОтключитьОбновлениеЗадач - Булево.
//
Процедура УстановитьФлагОбъекту(Объект, Флаг, ТекущийСотрудник, ОтключитьОбновлениеЗадач = Ложь)
	
	Если ЗначениеЗаполнено(Объект) Тогда
		Если ЗначениеЗаполнено(Флаг) Тогда
			РегистрыСведений.ФлагиОбъектов.УстановитьФлаг(
				Объект,
				ТекущийСотрудник,
				Флаг,
				ОтключитьОбновлениеЗадач);
		Иначе
			РегистрыСведений.ФлагиОбъектов.ОчиститьФлаг(
				Объект,
				ТекущийСотрудник,
				ОтключитьОбновлениеЗадач);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Переключает флаг задачи между значениями пустого флага
// и флагом по умолчанию для основного сотрдуника текущего пользователя.
// Данная процедура предназначена для использования из
// процедуры РаботаСФлагамиОбъектовКлиент.ПереключитьФлагЗадачи
//
Процедура ПереключитьФлагЗадачи(Задача) Экспорт
	
	ФлагЗадачПоУмолчанию = ПолучитьФлагДляЗадачПоУмолчанию();
	ФизическоеЛицоПользователя = ПараметрыСеанса.ФизическоеЛицоПользователя;
	
	РегистрыСведений.ФлагиОбъектов.ПереключитьФлаг(
		Задача,
		ФизическоеЛицоПользователя,
		ФлагЗадачПоУмолчанию);
	
КонецПроцедуры
