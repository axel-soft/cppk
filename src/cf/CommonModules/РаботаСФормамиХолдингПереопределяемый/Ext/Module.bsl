﻿
#Область ПрограммныйИнтерфейс

// Позволяет переопределить стандартное изменение формы настроек программы.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма, в которой необходимо установить доступность элементов.
//	СтандартнаяОбоработка - Булево - Признак стандартной обработки
//
Процедура ИзменитьФормуНастроекПрограммы(Форма, СтандартнаяОбоработка) Экспорт
	
КонецПроцедуры

// Позволяет переопределить список элементов формы настроек, для которых будет установлен-запрет редактирования.
//
// Параметры:
//	ЭлементыФормы - Массив Из ГруппаФормы,
//							ДекорацияФормы,
//							КнопкаФормы,
//							ПолеФормы,
//							ТаблицаФормы - Список элементов соответствующие настройкам, которые необходимо
//											запретить редактирования.
//
Процедура ЭлементыФормыНастроекПрограммыЗапретРедактирования(ЭлементыФормы) Экспорт
	
КонецПроцедуры

#КонецОбласти
