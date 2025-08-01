﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных


Перем ТекущийГраф; // см. НовыйГраф - таблица значений, хранящая вершины и ребра графа. 

Перем Белый; // Число - используется в качестве константы для обозначения "белого цвета".

Перем Серый; // Число - используется в качестве константы для обозначения "серого цвета".

Перем Черный; // Число - используется в качестве константы для обозначения "черного цвета".

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Добавляет в граф вершину, соответствующую объекту метаданных.
//
// Параметры:
//  ИмяОбъектаМетаданных - Строка - имя объекта метаданных, соответствующий добавляемой вершине графа.
//  ТолькоПриОтсутствии - Булево - если Ложь то при попытке добавления неуникального значения
//    будет генерироваться исключение. В противном случае - попытка добавления неуникального
//    значения будет игнорироваться.
//
Процедура ДобавитьВершину(Знач ИмяОбъектаМетаданных, Знач ТолькоПриОтсутствии = Истина) Экспорт
	
	ОбъектМетаданных = ОбъектМетаданных(ИмяОбъектаМетаданных);
	УжеСуществует = (Вершина(ОбъектМетаданных, Ложь) <> Неопределено);
	
	Если УжеСуществует Тогда
		
		Если ТолькоПриОтсутствии Тогда
			Возврат;
		Иначе
			ВызватьИсключение НСтр("ru = 'Попытка дублирования.'");
		КонецЕсли;
		
	Иначе
		
		Граф = ТекущийГраф; // см. НовыйГраф
		Вершина = Граф.Добавить(); 
		Вершина.УникальныйИдентификатор = Новый УникальныйИдентификатор;
		Вершина.ОбъектМетаданных = ОбъектМетаданных;
		Вершина.Ребра = Новый Массив;
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет в граф ребро, соединяющее вершины.
//
// Параметры:
//  ИмяОбъектаМетаданных1 - ОбъектМетаданных - соответствующий первой вершине, соединяемой ребром,
//  ИмяОбъектаМетаданных2 - ОбъектМетаданных - соответствующий второй вершине, соединяемой ребром.
//
Процедура ДобавитьРебро(Знач ИмяОбъектаМетаданных1, Знач ИмяОбъектаМетаданных2) Экспорт
	
	ОбъектМетаданных1 = ОбъектМетаданных(ИмяОбъектаМетаданных1);
	ОбъектМетаданных2 = ОбъектМетаданных(ИмяОбъектаМетаданных2);
	
	Вершина1 = Вершина(ОбъектМетаданных1);
	Вершина2 = Вершина(ОбъектМетаданных2);
  
	Вершина1.Ребра.Добавить(Вершина2.УникальныйИдентификатор);
	Вершина1.КоличествоРебер = Вершина1.КоличествоРебер + 1;
	
КонецПроцедуры

// Выполняет топологическую сортировку вершин графа и возвращает результат сортировки.
//
// Возвращаемое значение:
//  Массив Из ОбъектМетаданных - массив объектов метаданных, отсортированный таким образом, чтобы
//    объекты метаданных, соответствующие вершинам, для которых были добавлены ребра к другим
//    вершинам, предшествовали в массиве перед объектами метаданных, соответствующих вершинам,
//    которые были добавлены в качестве ребер к другим вершинам.
//
Функция ТопологическаяСортировка() Экспорт
	
	// Изначально все вершины "белые"
	Для Каждого Вершина Из ТекущийГраф Цикл
		Вершина.Цвет = Белый;
	КонецЦикла;
	
	РезультатСортировки = Новый Массив();
	
	Для Каждого Вершина Из ТекущийГраф Цикл
		
		// Из каждой вершины проводим обход в глубину
		ПоискВГлубину(Вершина, РезультатСортировки);
		
	КонецЦикла;
	
	Возврат РезультатСортировки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает таблицу значений графа.
// Вершины хранятся как строки таблицы значений, ребра - как значение одной из колонок. 
// 
// Возвращаемое значение:
// 	ТаблицаЗначений - Описание:
//  * УникальныйИдентификатор - УникальныйИдентификатор - вершины графа.
//  * ОбъектМетаданных - ОбъектМетаданных - объект метаданных вершины графа.
//  * Ребра - Массив из УникальныйИдентификатор - массив ребер графа, в качестве элементов
//      массива используются значения типа УникальныйИдентификатор, соответствующие строкам
//      табличной части, описывающим другие вершины графа.
//  * КоличествоРебер - Число - количество ребер, заданных для текущей вершины.
//  * Цвет - Число - хранит "цвет" текущей вершины графа (см. область модуля ЛокальныеПеременные).
//
Функция НовыйГраф()

	Граф = Новый ТаблицаЗначений;
	Граф.Колонки.Добавить("УникальныйИдентификатор", Новый ОписаниеТипов("УникальныйИдентификатор"));
	Граф.Колонки.Добавить("ОбъектМетаданных");
	Граф.Колонки.Добавить("Ребра", Новый ОписаниеТипов("Массив"));
	Граф.Колонки.Добавить("КоличествоРебер", Новый ОписаниеТипов("Число"));
	Граф.Колонки.Добавить("Цвет", Новый ОписаниеТипов("Число"));
	Граф.Индексы.Добавить("УникальныйИдентификатор");
	
	Возврат Граф;
		
КонецФункции

// Возвращает объект метаданных по полному имени, при отсутствии объекта в текущей
// конфигурации - генерируется исключение.
//
// Параметры:
//  ПолноеИмя - Строка - полное имя объекта метаданных.
//
// Возвращаемое значение:
//   ОбъектМетаданных - объект метаданных по полному имени.
//
Функция ОбъектМетаданных(Знач ПолноеИмя)
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмя);
	Если ОбъектМетаданных = Неопределено Тогда
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'В текущей конфигурации отсутствует объект метаданных %1, присутствующих в файле данных.'"),
			ПолноеИмя);
		
	КонецЕсли;
	
	Возврат ОбъектМетаданных;
	
КонецФункции

// Возвращает строку таблицы значений, описывающей граф, которая соответствует заданному
// объекту метаданных.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - объект метаданных
//  ИсключениеПриОтсутствии - Булево - флаг генерации исключения для случая, когда заданный
//    объект метаданных отсутствует в вершинах текущего графа.
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений - строка таблицы значений ТекущийГраф:
//  * УникальныйИдентификатор - УникальныйИдентификатор - вершины графа.
//  * ОбъектМетаданных - ОбъектМетаданных - объект метаданных вершины графа.
//  * Ребра - Массив из УникальныйИдентификатор - массив ребер графа.
//  * КоличествоРебер - Число - количество ребер, заданных для текущей вершины.
//  * Цвет - Число - цвет текущей вершины графа (см. область модуля ЛокальныеПеременные).
//  Неопределено - если заданный ОбъектМетаданных отсутствует в текущем графе и ИсключениеПриОтсутствии = Ложь.
//
Функция Вершина(Знач ОбъектМетаданных, Знач ИсключениеПриОтсутствии = Истина)
	 
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ОбъектМетаданных", ОбъектМетаданных);
	
	Вершины = ТекущийГраф.НайтиСтроки(ПараметрыОтбора);

	Если Вершины.Количество() = 1 Тогда
		
		Возврат Вершины.Получить(0);
		
	ИначеЕсли Вершины.Количество() = 0 Тогда
		
		Если ИсключениеПриОтсутствии Тогда
			
			ВызватьИсключение СтрШаблон(НСтр("ru = 'В графе отсутствует вершина для объекта метаданных %1.'"),
				ОбъектМетаданных.ПолноеИмя());
			
		Иначе
			
			Возврат Неопределено;
			
		КонецЕсли;
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Нарушение уникальности граф для объекта метаданных %1.'"),
			ОбъектМетаданных.ПолноеИмя());
		
	КонецЕсли;
	
КонецФункции

// Выполняет поиск в глубину при топологической сортировке.
//
// Параметры:
//  Вершина - СтрокаТаблицыЗначений - строка таблицы значений ТекущийГраф,
//  РезультатСортировки - Массив Из ОбъектМетаданных - результат топологической сортировки.
//
Процедура ПоискВГлубину(Вершина, РезультатСортировки)
	
	// Если вошли в "серую" вершину - найден цикл, топологическая сортировка невозможна
	Если Вершина.Цвет = Серый Тогда
		
		ВызватьИсключение НСтр("ru = 'Рекурсивная зависимость.'");
		
	ИначеЕсли Вершина.Цвет = Белый Тогда
		
		// При входе в вершину делаем ее "серой"
		Вершина.Цвет = Серый;
		
		// Из каждой вершины проводим обход в глубину
		Для Каждого Ребро Из Вершина.Ребра Цикл
			ПоискВГлубину(ТекущийГраф.Найти(Ребро, "УникальныйИдентификатор"), РезультатСортировки);
		КонецЦикла;
		
		// При выходе из вершины делаем ее "черной"
		Вершина.Цвет = Черный;
		// И одновременно заносим ее в стек
		РезультатСортировки.Добавить(Вершина.ОбъектМетаданных);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ТекущийГраф = НовыйГраф();

Белый = 1;
Серый = 2;
Черный = 3;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли