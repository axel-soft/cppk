﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(Организация) Тогда 
		Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
	Если ЭтоНовый() Тогда 
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьГрифыДоступа") Тогда
			ГрифДоступа = Константы.ГрифДоступаПоУмолчанию.Получить();
		КонецЕсли;
		
		ФормаДокументов = Перечисления.ВариантыФормДокументов.Бумажная;
		СрокОперативногоХранения = 1;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Раздел) И (Год <> Раздел.Год) Тогда
		ОбщегоНазначения.СообщитьПользователю(	
			НСтр("ru = 'Год элемента номенклатуры дел не совпадает с годом раздела'"),
			ЭтотОбъект, "Год",, Отказ);
	КонецЕсли;
	
	Если ТипЗнч(СрокХранения) = Тип("Число") И СрокХранения < СрокОперативногоХранения Тогда
		ОбщегоНазначения.СообщитьПользователю(	
			НСтр("ru = 'Срок оперативного хранения не должен превышать общий срок'"),
			ЭтотОбъект, "СрокОперативногоХранения",, Отказ);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда 
		Если ЗначениеЗаполнено(Раздел) И ЗначениеЗаполнено(Организация) 
			И Организация <> Раздел.Организация Тогда 
			ОбщегоНазначения.СообщитьПользователю(	
				РедакцииКонфигурацииКлиентСервер.ОшибкаНоменклатураОрганизации(),
				ЭтотОбъект, "Организация",, Отказ);
		КонецЕсли;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НоменклатураДел.Ссылка
		|ИЗ
		|	Справочник.НоменклатураДел КАК НоменклатураДел
		|ГДЕ
		|	НоменклатураДел.Индекс = &Индекс
		|	И НоменклатураДел.Год = &Год
		|	И НоменклатураДел.Ссылка <> &Ссылка";
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
		Запрос.Текст = Запрос.Текст + " И (Организация = &Организация) ";
		Запрос.УстановитьПараметр("Организация", Организация);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Индекс", Индекс);
	Запрос.УстановитьПараметр("Год", Год);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда 
		ОбщегоНазначения.СообщитьПользователю(	
			НСтр("ru = 'Элемент номенклатуры дел с указанным индексом уже зарегистрирован'"),
			ЭтотОбъект,
			"Индекс",,
			Отказ);
	КонецЕсли;
	
	ПроверяемыеРеквизиты.Добавить("ФормаДокументов");
	
	Если ЗначениеЗаполнено(ФормаДокументов) И Не Ссылка.Пустая() Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Документы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ДокументыПредприятия КАК Документы
		|ГДЕ
		|	НЕ Документы.ПометкаУдаления
		|	И (Документы.НоменклатураДел = &Ссылка
		|			ИЛИ Документы.Дело.НоменклатураДел = &Ссылка)
		|	И Документы.ФормаДокумента <> &ФормаДокумента";
		
		Запрос.УстановитьПараметр("ФормаДокумента", ФормаДокументов);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда 
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'В дело списаны документы с другой формой хранения. Выбрать указанное значение ""%1"" нельзя.'"), 
				ФормаДокументов);
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения, ЭтотОбъект, "ФормаДокументов",, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ПолноеНаименованиеСтарое",
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПолноеНаименование"));
	
	Наименование = Делопроизводство.НаименованиеДела(ЭтотОбъект);
	
	ВидыДокументовЗаполнены = (ВидыДокументов.Количество() > 0);
	КонтрагентыЗаполнены = (Контрагенты.Количество() > 0);
	ВопросыДеятельностиЗаполнены = (ВопросыДеятельности.Количество() > 0);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЭтоНовый() Тогда 
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Дела.Ссылка
			|ИЗ
			|	Справочник.ДелаХраненияДокументов КАК Дела
			|ГДЕ
			|	Дела.НоменклатураДел = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			ДелоОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Если ДополнительныеСвойства.Свойство("ПолноеНаименованиеСтарое")
				И ДополнительныеСвойства.ПолноеНаименованиеСтарое <> ПолноеНаименование Тогда
				ДелоОбъект.ДополнительныеСвойства.Вставить("ЗаголовокНоменклатурыСтарый",
					ДополнительныеСвойства.ПолноеНаименованиеСтарое);
			КонецЕсли;
			ДелоОбъект.Записать();
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли