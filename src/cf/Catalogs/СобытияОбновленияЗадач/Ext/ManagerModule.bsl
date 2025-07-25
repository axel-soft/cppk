﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет поставляемые данные.
// 
Процедура ЗаполнитьПоставляемыеДанные() Экспорт
	
	СобытиеОбновленияЗадачиОбъект = ЗарегистрированОтветныйДокумент.ПолучитьОбъект();
	СобытиеОбновленияЗадачиОбъект.Наименование = НСтр("ru = 'Зарегистрирован ответный документ'");
	СобытиеОбновленияЗадачиОбъект.Описание = НСтр("ru = 'Зарегистрирован исходящий'");
	СтрокаВытесняемогоСобытия = СобытиеОбновленияЗадачиОбъект.ВытесняемыеСобытия.Добавить();
	СтрокаВытесняемогоСобытия.ВытесняемоеСобытие = СозданОтветныйДокумент;
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(СобытиеОбновленияЗадачиОбъект);
	
	СобытиеОбновленияЗадачиОбъект = ИсполненаЗадачаОтветственногоИсполнителя.ПолучитьОбъект();
	СобытиеОбновленияЗадачиОбъект.Наименование = НСтр("ru = 'Исполнена задача ответственного исполнителя'");
	СобытиеОбновленияЗадачиОбъект.Описание = НСтр("ru = 'Ответственный исполнитель закрыл свою задачу'");
	СтрокаВытесняемогоСобытия = СобытиеОбновленияЗадачиОбъект.ВытесняемыеСобытия.Добавить();
	СтрокаВытесняемогоСобытия.ВытесняемоеСобытие = ИсполненаЗадачаСоисполнителя;
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(СобытиеОбновленияЗадачиОбъект);
	
	СобытиеОбновленияЗадачиОбъект = ИсполненаЗадачаСоисполнителя.ПолучитьОбъект();
	СобытиеОбновленияЗадачиОбъект.Наименование = НСтр("ru = 'Исполнена задача соисполнителя'");
	СобытиеОбновленияЗадачиОбъект.Описание = НСтр("ru = 'Соисполнитель закрыл свою задачу'");
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(СобытиеОбновленияЗадачиОбъект);
	
	СобытиеОбновленияЗадачиОбъект = ИсполненаПодзадача.ПолучитьОбъект();
	СобытиеОбновленияЗадачиОбъект.Наименование = НСтр("ru = 'Исполнена подзадача'");
	СобытиеОбновленияЗадачиОбъект.Описание = НСтр("ru = 'Есть исполненные подзадачи'");
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(СобытиеОбновленияЗадачиОбъект);
	
	СобытиеОбновленияЗадачиОбъект = СозданОтветныйДокумент.ПолучитьОбъект();
	СобытиеОбновленияЗадачиОбъект.Наименование = НСтр("ru = 'Создан ответный документ'");
	СобытиеОбновленияЗадачиОбъект.Описание = НСтр("ru = 'Исходящий не зарегистрирован'");
	ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(СобытиеОбновленияЗадачиОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
    МультиязычностьКлиентСервер.ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
    МультиязычностьКлиентСервер.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
    МультиязычностьСервер.ОбработкаПолученияДанныхВыбора(ДанныеВыбора, 
    Параметры, СтандартнаяОбработка, Метаданные.Справочники.СобытияОбновленияЗадач);
КонецПроцедуры

#КонецОбласти

#КонецЕсли