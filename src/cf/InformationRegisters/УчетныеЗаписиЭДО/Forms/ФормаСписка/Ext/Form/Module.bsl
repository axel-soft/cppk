﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") Тогда
		ПредопределенныйОтбор = Новый ФиксированнаяСтруктура(Параметры.Отбор);
		
		Если ПредопределенныйОтбор.Свойство("Организация") Тогда
			Заголовок = СтрШаблон("%1 (%2)",
				Метаданные.РегистрыСведений.УчетныеЗаписиЭДО.Синоним, ПредопределенныйОтбор.Организация);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Заголовок) Тогда
		АвтоЗаголовок = Истина;
	КонецЕсли;
	
	УстановитьУсловноеОформлениеСписка();
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата"             , ТекущаяДатаСеанса());
	Список.Параметры.УстановитьЗначениеПараметра("ВсеСертификатыПросрочены", НСтр("ru = 'Все сертификаты просрочены'"));
	Список.Параметры.УстановитьЗначениеПараметра("СертификатыЗаканчиваются", НСтр("ru = 'Заканчивается срок действия сертификатов'"));
	Список.Параметры.УстановитьЗначениеПараметра("Неизвестный", НСтр("ru = 'Неизвестный'"));
	Список.Параметры.УстановитьЗначениеПараметра("ИспользоватьПрямойОбмен",
		НастройкиЭДО.ИспользуетсяПрямойОбменЭлектроннымиДокументами());
	Список.Параметры.УстановитьЗначениеПараметра("СпособыПрямогоОбмена", СинхронизацияЭДО.СпособыПрямогоОбмена());
	Если Не ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.УчетныеЗаписиЭДО) Тогда
		Элементы.СоздатьОбменЧерезСервисЭДО.Видимость = Ложь;
	КонецЕсли;
	
	НастроитьОтображениеГруппыСоздать();
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД
	КонтекстныеПодсказкиБЭД.КонтекстныеПодсказки_ПриСозданииНаСервере(ЭтотОбъект, 
																		Элементы.ПанельКонтекстныхНовостей, 
																		Элементы.ГруппаКонтекстныхПодсказок);
	СформироватьКонтекст();
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД
	
	ОбменСКонтрагентамиДОСобытия.УчетнаяЗаписьЭДОФормаСпискаПриСозданииНаСервере(
		ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД
	КонтекстныеПодсказкиБЭДКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СозданПрофиль1СЭДО"
		Или ИмяСобытия = "ОбновленСписокУчетныхЗаписей1СЭДО" Тогда
		Элементы.Список.Обновить();
	ИначеЕсли ИмяСобытия = "Запись_НаборКонстант"
		И Источник = "ИспользоватьПрямойОбменЭлектроннымиДокументами" Тогда
		ПриИзмененииИспользованияПрямогоОбмена();
	КонецЕсли;
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД
	КонтекстныеПодсказкиБЭДКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами.КонтекстныеПодсказкиБЭД

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьЧерезОблачныйЭДО(Команда)
	
	Организация = Неопределено;
	Если ЗначениеЗаполнено(ПредопределенныйОтбор) Тогда
		ПредопределенныйОтбор.Свойство("Организация", Организация);
	КонецЕсли;
	
	ПараметрыСоздания = УчетныеЗаписиЭДОКлиент.НовыеПараметрыСозданияУчетнойЗаписи();
	ПараметрыСоздания.Организация = Организация;
	ПараметрыСоздания.ВладелецФормы = ЭтотОбъект;
	ПараметрыСоздания.ЧерезОблачныйЭДО = Истина;
	УчетныеЗаписиЭДОКлиент.СоздатьУчетнуюЗапись(ПараметрыСоздания);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОбменЧерезСервисЭДО(Команда)
	
	Организация = Неопределено;
	Если ЗначениеЗаполнено(ПредопределенныйОтбор) Тогда
		ПредопределенныйОтбор.Свойство("Организация", Организация);
	КонецЕсли;
	
	ПараметрыСоздания = УчетныеЗаписиЭДОКлиент.НовыеПараметрыСозданияУчетнойЗаписи();
	ПараметрыСоздания.Организация = Организация;
	ПараметрыСоздания.ВладелецФормы = ЭтотОбъект;
	УчетныеЗаписиЭДОКлиент.СоздатьУчетнуюЗапись(ПараметрыСоздания);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрямойОбмен(Команда)
	
	Организация = Неопределено;
	Если ЗначениеЗаполнено(ПредопределенныйОтбор) Тогда
		ПредопределенныйОтбор.Свойство("Организация", Организация);
	КонецЕсли;
	
	УчетныеЗаписиЭДОСлужебныйКлиент.СоздатьУчетнуюЗаписьПрямогоОбмена(Организация, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеСписка()
	
	Список.УсловноеОформление.Элементы.Очистить();
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Предупреждения.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Предупреждения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Предупреждения.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Предупреждения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Отсутствуют>'"));
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОператорЭДО.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЭтоПрямойОбмен");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст",
		Новый ПолеКомпоновкиДанных("СпособОбменаПредставление"));
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеГруппыСоздать()
	
	Если НастройкиЭДО.ИспользуетсяПрямойОбменЭлектроннымиДокументами() Тогда
		Элементы.ГруппаСоздать.Вид = ВидГруппыФормы.Подменю;
		Элементы.ГруппаСоздать.Картинка = БиблиотекаКартинок.СоздатьЭлементСписка;
		Элементы.СоздатьОбменЧерезСервисЭДО.Заголовок = НСтр("ru = 'через сервис ЭДО'");
		Элементы.СоздатьОбменЧерезСервисЭДО.Картинка = БиблиотекаКартинок.Пустая;
	Иначе
		Элементы.ГруппаСоздать.Вид = ВидГруппыФормы.ГруппаКнопок;
		Элементы.СоздатьОбменЧерезСервисЭДО.Заголовок = НСтр("ru = 'Создать'");
		Элементы.СоздатьОбменЧерезСервисЭДО.Картинка = БиблиотекаКартинок.СоздатьЭлементСписка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииИспользованияПрямогоОбмена()
	
	Список.Параметры.УстановитьЗначениеПараметра("ИспользоватьПрямойОбмен",
		НастройкиЭДО.ИспользуетсяПрямойОбменЭлектроннымиДокументами());
	НастроитьОтображениеГруппыСоздать();
	
КонецПроцедуры

#Область КонтекстныеПодсказки

&НаКлиенте
Процедура Подключаемый_ПанельКонтекстныхНовостей_ЭлементУправленияНажатие(Элемент)
	
	КонтекстныеПодсказкиБЭДКлиент.ЭлементУправленияНажатие(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьКонтекст(КатегорииПересчета = Неопределено)
	
	Если Не КонтекстныеПодсказкиБЭД.ФункционалКонтекстныхПодсказокДоступен() Тогда 
		Возврат;
	КонецЕсли;
	
	КонтекстныеПодсказкиБЭД.ОтобразитьАктуальныеДляКонтекстаНовости(ЭтотОбъект);
	
КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные).
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";	
	КонтекстныеПодсказкиБЭДКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПанельКонтекстныхНовостейОбработкаНавигационнойСсылки(Элемент, ПараметрНавигационнаяСсылка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	КонтекстныеПодсказкиБЭДКлиент.ПанельКонтекстныхНовостей_ЭлементПанелиНовостейОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		Элемент,
		ПараметрНавигационнаяСсылка,
		СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти 

#КонецОбласти