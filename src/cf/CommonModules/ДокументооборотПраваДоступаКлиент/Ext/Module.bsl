﻿////////////////////////////////////////////////////////////////////////////////
// Документооборот права доступа (клиент)
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// В случае, если объект не записан в базу, записывает его, предварительно задвая вопрос
// и открывает форму с дополнительными данными по объекту.
// 
// Параметры:
//  ФормаОбъекта - ФормаКлиентскогоПриложения - форма объекта
//  ИмяОсновногоРеквизита - Строка - имя реквизита, указывающего на объект
//  ТекстВопроса - Строка - текст вопроса, который надо задать перед записью
//  ИмяПодчиненнойФормы - Строка - имя формы, которую нужно открыть
// 
Процедура ЗаписатьОбъектЕслиНовыйИОткрытьПодчиненнуюФорму(
			ФормаОбъекта, ИмяОсновногоРеквизита, ТекстВопроса, ИмяПодчиненнойФормы) Экспорт
	
	Действие = Новый ОписаниеОповещения(
		"ОткрытьПодчиненнуюФорму", ЭтотОбъект,
		Новый Структура("ФормаОбъекта, ИмяОсновногоРеквизита, ИмяПодчиненнойФормы",
			ФормаОбъекта, ИмяОсновногоРеквизита, ИмяПодчиненнойФормы));
	
	ОбщегоНазначенияДокументооборотКлиент.ЗаписатьОбъектЕслиНовыйИВыполнитьДействие(
		ФормаОбъекта, ИмяОсновногоРеквизита, ТекстВопроса, Действие);
	
КонецПроцедуры

// Служебная процедура.
Процедура ОткрытьПодчиненнуюФорму(Результат, Параметры) Экспорт
	
	СсылкаНаОбъект = Параметры.ФормаОбъекта[Параметры.ИмяОсновногоРеквизита].Ссылка;
	ПараметрыФормы = Новый Структура;
	
	ИмяПодчиненнойФормы = Параметры.ИмяПодчиненнойФормы;
	Если ИмяПодчиненнойФормы = "ОбщаяФорма.ДокументооборотПраваДоступаПоОбъекту" Тогда
		
		ПараметрыФормы.Вставить("ОбъектДоступа", СсылкаНаОбъект);
		
	ИначеЕсли ИмяПодчиненнойФормы = "ОбщаяФорма.НастройкиПравПапок" Тогда
		
		ПараметрыФормы.Вставить("СсылкаНаОбъект", СсылкаНаОбъект);
		
	КонецЕсли;
	
	ОткрытьФорму(ИмяПодчиненнойФормы, ПараметрыФормы, Параметры.ФормаОбъекта, СсылкаНаОбъект);
	
КонецПроцедуры

// Открывает форму прав доступа на для основого реквизита формы.
// Предварительно выполняет запись, если это форма нового объекта.
// 
// Параметры:
//  ФормаОбъекта - ФормаКлиентскогоПриложения - форма объекта, права которого нужно открыть.
//  ИмяОсновногоРеквизита - Строка - имя основного реквизита формы.
// 
Процедура ОткрытьФормуПравДоступа(ФормаОбъекта, ИмяОсновногоРеквизита = "Объект") Экспорт
	
	ИмяФормыПравДоступа = "ОбщаяФорма.ДокументооборотПраваДоступаПоОбъекту";
	
	ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
		|Выполнение команды ""Права доступа"" возможно только после записи данных.
		|Данные будут записаны.'");
	
	ДокументооборотПраваДоступаКлиент.ЗаписатьОбъектЕслиНовыйИОткрытьПодчиненнуюФорму(
		ФормаОбъекта, ИмяОсновногоРеквизита, ТекстВопроса, ИмяФормыПравДоступа);
		
КонецПроцедуры

// Выполняет полное обновление прав доступа
// 
// Параметры:
//  ОтложенноеОбновлениеПрав - Булево - признак отложенного обновления
// 
Процедура ОбновитьВсеПрава(ОтложенноеОбновлениеПрав) Экспорт
	
	// В случае отложенного обновления права будут обновлены регл. заданием
	Если Не ОтложенноеОбновлениеПрав Тогда
		Состояние(НСтр("ru = 'Выполняется очистка всех прав доступа.
			|Пожалуйста, подождите...'"));
	КонецЕсли;
		
	ДокументооборотПраваДоступа.УдалитьВсеДанныеОПравахДоступа();
	
	// В случае отложенного обновления права будут обновлены регл. заданием
	Если Не ОтложенноеОбновлениеПрав Тогда
		Состояние(НСтр("ru = 'Выполняется обновление прав доступа для всех данных информационной базы.
			|Пожалуйста, подождите...'"));
	КонецЕсли;
	
	ДокументооборотПраваДоступа.ОбновитьПраваВсехДанных();
	
	Состояние();
	
КонецПроцедуры

#КонецОбласти