﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ВызватьИсключение
		НСтр("ru = 'Для копирования следует использовать фнукцию:
		|РаботаСКомплекснымиБизнесПроцессамиСервер.СкопироватьСхемуКомплексногоПроцесса.'");	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбщегоНазначенияДокументооборот.ЭтоЗагрузкаИзУзлаРИБ(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если МиграцияДанныхИзВнешнихСистемСервер.ЭтоОбъектИзДругойСистемы(ИсточникДанных) Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияДокументооборот.УстановитьДополнительноеСвойствоПредыдущиеЗначенияРеквизитов(ЭтотОбъект);
	
	ЗаполнитьОбъектДоступа();
	ЗаполнитьПорядокСортировки();	
	
	ПроверитьВозможностьИзмененияПараметровСхемы();
		
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбщегоНазначенияДокументооборот.ЭтоЗагрузкаИзУзлаРИБ(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если МиграцияДанныхИзВнешнихСистемСервер.ЭтоОбъектИзДругойСистемы(ИсточникДанных) Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущиеЗначенияРеквизитов = ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов;
	
	Если ПредыдущиеЗначенияРеквизитов.ПометкаУдаления <> ПометкаУдаления Тогда
		ПометитьНаУдалениеНастройкиЭлементов();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбщегоНазначенияДокументооборот.ЭтоЗагрузкаИзУзлаРИБ(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если МиграцияДанныхИзВнешнихСистемСервер.ЭтоОбъектИзДругойСистемы(ИсточникДанных) Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьВозможностьИзмененияПараметровСхемы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Отключает в объекте проверку возможности изменения текущим пользователь.
//
Процедура ОтключитьПроверкуВозможностиИзменения() Экспорт
	
	ДополнительныеСвойства.Вставить("ПроверкуВозможностиИзмененияОтключена", Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции 

// Возвращает признак отключения возможности изменения объекта.
// 
// Возвращаемое значение:
//  Булево
//  
Функция ПроверкаВозможностиИзмененияОтключена()
	
	Если ДополнительныеСвойства.Свойство("ПроверкуВозможностиИзмененияОтключена")
		И ДополнительныеСвойства.ПроверкуВозможностиИзмененияОтключена Тогда
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Заполняет реквизит ОбъектДоступа.
//
Процедура ЗаполнитьОбъектДоступа()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеЗаполнено(ОбъектДоступа) Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектДоступа = 
		Справочники.ПараметрыСхемДляКомплексныхПроцессов.ОбъектДоступаПараметровПоВладельцуСхемы(
			ВладелецСхемы);
	
КонецПроцедуры

// Проверяет возможность изменения текущих параметров схемы.
// Если возможности изменения нет у текущего пользователя,
// то вызывается исключение с соответствующим описанием.
// 
// Это низкоуровневая проверка.
// Дополнительные проверки должны быть предусмотрены в интерфейсах редактирования схем. 
//
Процедура ПроверитьВозможностьИзмененияПараметровСхемы()
	
	Если ПроверкаВозможностиИзмененияОтключена() Тогда
		Возврат;
	КонецЕсли;
	
	ДоступностьИзменения = 
		Справочники.ПараметрыСхемДляКомплексныхПроцессов.ДоступностьИзмененияПараметровСхемы(
			ЭтотОбъект);
	
	Если Не ДоступностьИзменения Тогда
		ВызватьИсключение
			НСтр("ru = 'Не достаточно прав для изменения параметров схемы.
			|Требуется право изменения комплексного процесса или шаблона к которому относятся
			|параметры схемы.'");
	КонецЕсли; 
		
КонецПроцедуры

// Заполняет порядок сортировки элементов в таб. части НастройкиЭлементов
//
Процедура ЗаполнитьПорядокСортировки()
		
	ПорядокСортировкиЭлементов = НастройкиЭлементов.Выгрузить(, "ИмяЭлемента");
	ПорядокСортировкиЭлементов.Колонки.Добавить("ПорядковыйНомер");
		
	КэшСтрокПорядка = Новый Соответствие();
	Для Каждого СтрокаТаблицы Из ПорядокСортировкиЭлементов Цикл
		СтрокаТаблицы.ПорядковыйНомер = -1;
		КэшСтрокПорядка[СтрокаТаблицы.ИмяЭлемента] = СтрокаТаблицы; 
	КонецЦикла;
	
	ДанныеСхемы = Справочники.СхемыПроцессов.ДанныеСхемыПроцесса(Схема);
	ПутиСхемы = СхемыПроцессовСервер.ПутиСхемыПроцесса(
		СхемыПроцессовКлиентСервер.ИмяЭлементаСтартаСхемы(ДанныеСхемы),
		СхемыПроцессовСервер.ПредшественникиЭлементовПоДаннымСхемы(ДанныеСхемы));
	
	Для Каждого ПутьСхемы Из ПутиСхемы Цикл
		ИндексЭлемента = ПутьСхемы.Количество() - 1;
		Пока ИндексЭлемента >= 0 Цикл
			
			ИмяЭлемента = ПутьСхемы[ИндексЭлемента];
			ПорядковыйНомер = ИндексЭлемента + 1;
			
			ИндексЭлемента = ИндексЭлемента - 1; 
			
			Если КэшСтрокПорядка[ИмяЭлемента] = Неопределено Тогда
				Продолжить;
			КонецЕсли;
					
			Если КэшСтрокПорядка[ИмяЭлемента].ПорядковыйНомер = -1 Тогда
				КэшСтрокПорядка[ИмяЭлемента].ПорядковыйНомер = ПорядковыйНомер;
			Иначе
				КэшСтрокПорядка[ИмяЭлемента].ПорядковыйНомер =
					Мин(ПорядковыйНомер, КэшСтрокПорядка[ИмяЭлемента].ПорядковыйНомер);
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;
	
	ПорядокСортировкиЭлементов.Сортировать("ПорядковыйНомер Возр");
	
	Для Каждого СтрокаТаблицы Из НастройкиЭлементов Цикл
		СтрокаСПорядком = КэшСтрокПорядка[СтрокаТаблицы.ИмяЭлемента];
		СтрокаТаблицы.ПорядокСортировки = ПорядокСортировкиЭлементов.Индекс(СтрокаСПорядком) + 1; 
	КонецЦикла;
	
КонецПроцедуры

//Помечает на удаление настройки элементов, которые принадлежат только параметрам схемы.
//
Процедура ПометитьНаУдалениеНастройкиЭлементов()
	
	Для Каждого СтрокаНастройки Из НастройкиЭлементов Цикл
		Если ШаблоныБизнесПроцессовКлиентСервер.ЭтоШаблонПроцесса(СтрокаНастройки.Настройка)
			И ОбщегоНазначения.СсылкаСуществует(СтрокаНастройки.Настройка) Тогда
			
			СтрокаНастройки.Настройка.ПолучитьОбъект().УстановитьПометкуУдаления(ПометкаУдаления);
		КонецЕсли;		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти
			
#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли