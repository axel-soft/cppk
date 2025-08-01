﻿// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает индекс картинки в коллекции "Коллекция состояния задач".
//
// Параметры:
//  ХарактерРезультата - ПеречислениеСсылка.ХарактерыРезультатов - Характер результата.
// 
// Возвращаемое значение:
//  Число - Индекс картинки.
//
Функция ИндексКартинкиСостояния(ХарактерРезультата) Экспорт
	
	Если ХарактерРезультата = Нейтральный Тогда
		
		Возврат 6;
		
	ИначеЕсли ХарактерРезультата = Отрицательный Тогда
		
		Возврат 7;
		
	ИначеЕсли ХарактерРезультата = Положительный Тогда
		
		Возврат 9;
		
	ИначеЕсли ХарактерРезультата = ПоложительныйСЗамечаниями Тогда
		
		Возврат 8;
		
	Иначе
		
		Возврат -1;
		
	КонецЕсли;

	
КонецФункции

// Возвращает картинку состояния.
//
// Параметры:
//  ХарактерРезультата - ПеречислениеСсылка.ХарактерыРезультатов.
// 
// Возвращаемое значение:
//  Картинка - Картинка состояния.
//
Функция КартинкаСостояния(ХарактерРезультата) Экспорт
	
	Если ХарактерРезультата = Нейтральный Тогда
		
		Возврат БиблиотекаКартинок.СостояниеЗадачиНейтральныйРезультат;
		
	ИначеЕсли ХарактерРезультата = Отрицательный Тогда
		
		Возврат БиблиотекаКартинок.СостояниеЗадачиОтрицательныйРезультат;
		
	ИначеЕсли ХарактерРезультата = Положительный Тогда
		
		Возврат БиблиотекаКартинок.СостояниеЗадачиПоложительныйРезультат;
		
	ИначеЕсли ХарактерРезультата = ПоложительныйСЗамечаниями Тогда
		
		Возврат БиблиотекаКартинок.СостояниеЗадачиПоложительныйСЗамечаниямиРезультат;
		
	Иначе
		
		Возврат Новый Картинка;
		
	КонецЕсли;
	
КонецФункции

// Возвращает цвет результата строкой.
//
// Параметры:
//  ХарактерРезультата - ПеречислениеСсылка.ХарактерыРезультатов.
// 
// Возвращаемое значение:
//  Строка - Цвет результата строкой.
//
Функция ЦветСтрокой(ХарактерРезультата) Экспорт
	
	Если ХарактерРезультата = Нейтральный Тогда
		
		Возврат "";
		
	ИначеЕсли ХарактерРезультата = Отрицательный Тогда
		
		Возврат "#B22222";
		
	ИначеЕсли ХарактерРезультата = Положительный Тогда
		
		Возврат "#008000";
		
	ИначеЕсли ХарактерРезультата = ПоложительныйСЗамечаниями Тогда
		
		Возврат "#008000";
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции

// Возвращает цвет текста команды указанного характера.
//
// Параметры:
//  ХарактерРезультата - ПеречислениеСсылка.ХарактерыРезультатов - Характер результата.
// 
// Возвращаемое значение:
//  Цвет - Цвет текста команды.
Функция ЦветТекстаКоманды(ХарактерРезультата) Экспорт
	
	Если ХарактерРезультата = Нейтральный Тогда
		
		Возврат ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
		
	ИначеЕсли ХарактерРезультата = Отрицательный Тогда
		
		Возврат ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
		
	ИначеЕсли ХарактерРезультата = Положительный Тогда
		
		Возврат ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
		
	ИначеЕсли ХарактерРезультата = ПоложительныйСЗамечаниями Тогда
		
		Возврат ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
		
	Иначе
		
		Возврат ЦветаСтиля.ЦветТекстаФормы;
		
	КонецЕсли;
	
КонецФункции

// Возвращает порядок состояния указанного характера.
//
// Параметры:
//  ХарактерРезультата - ПеречислениеСсылка.ХарактерыРезультатов.
// 
// Возвращаемое значение:
//  Число.
// 
Функция ПорядокСостояния(ХарактерРезультата) Экспорт
	
	Если ХарактерРезультата = Нейтральный Тогда
		
		Возврат 4;
		
	ИначеЕсли ХарактерРезультата = Отрицательный Тогда
		
		Возврат 1;
		
	ИначеЕсли ХарактерРезультата = Положительный Тогда
		
		Возврат 3;
		
	ИначеЕсли ХарактерРезультата = ПоложительныйСЗамечаниями Тогда
		
		Возврат 2;
		
	Иначе
		
		Возврат 5;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли