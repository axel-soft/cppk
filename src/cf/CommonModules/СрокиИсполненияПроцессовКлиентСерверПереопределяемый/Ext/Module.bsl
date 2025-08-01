﻿
////////////////////////////////////////////////////////////////////////////////
// Сроки исполнения процессов клиент сервер переопределяемый: модуль содержит переопределяемые
// процедуры для поддержки особой логики работы сроков исполнения в редакциях КОРП и ДГУ.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс_КарточкиПроцессовИШаблонов

// Вызывается из СрокиИсполненияПроцессовКлиентСервер.ПараметрыДоступностиЭлементаУправления при
// определении параметров доступности элемента управления.
//
// Параметры:
//  ПараметрыДоступности - Структура - в этот параметр следует поместить структуру с параметрами доступности.
//  СтандартнаяОбработка - Булево - в случае значения Истина параметры доступности будет определены
//                                  способом по умолчанию.
//
Процедура ПриОпределенииПараметровДоступностиЭлементаУправления(ПараметрыДоступности, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыДоступности = СрокиИсполненияПроцессовКлиентСерверКОРП.ПараметрыДоступностиЭлементаУправления();
	
КонецПроцедуры

// Вызывается из СрокиИсполненияПроцессовКлиентСервер.НастроитьЭлементУправленияСроком при
// настройке элемента управления сроком.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма процесса.
//  ЭлементУправленияСроком - ПолеФормы - поле формы управления сроком.
//  РеквизитПредставлениеСрока - Строка - реквизит содержащий представление срока.
//  ПараметрыДоступности - Структура - см. функцию ПараметрыДоступностиЭлементаУправления.
//  СтандартнаяОбработка - Булево - в случае значения Истина настройка будет осуществляться
//                                  способом по умолчанию.
//
Процедура ПриНастройкеЭлементаУправленияСроком(Форма,
	ЭлементУправленияСроком,
	РеквизитПредставлениеСрока,
	ПараметрыДоступности,
	СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	СрокиИсполненияПроцессовКлиентСерверКОРП.НастроитьЭлементУправленияСроком(
		Форма, ЭлементУправленияСроком, РеквизитПредставлениеСрока, ПараметрыДоступности);
	
КонецПроцедуры

#КонецОбласти
