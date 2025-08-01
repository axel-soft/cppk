﻿
&ИзменениеИКонтроль("ОбработатьДанныеВыполнения")
Процедура ЦППК_ОбработатьДанныеВыполнения(КонтекстВыполненияЗадачи, ФормаВладелец) Экспорт
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("КонтекстВыполненияЗадачи", КонтекстВыполненияЗадачи);
	ПараметрыОповещения.Вставить("ФормаВладелец", ФормаВладелец);
	
	Если КонтекстВыполненияЗадачи.ДанныеВыполнения.ВернутьсяКЗадаче Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если КонтекстВыполненияЗадачи.ДанныеВыполнения.ЗадачиНельзяВыполнить.Количество() <> 0 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗадачиНельзяВыполнить",
			КонтекстВыполненияЗадачи.ДанныеВыполнения.ЗадачиНельзяВыполнить);
		ПараметрыФормы.Вставить("ЧислоЗадач", КонтекстВыполненияЗадачи.ДанныеВыполнения.ЧислоЗадач);
		ПараметрыФормы.Вставить("ДействияЗадач", КонтекстВыполненияЗадачи.ДействияЗадач);
		ПараметрыФормы.Вставить("РезультатДействия", КонтекстВыполненияЗадачи.РезультатДействия);
		
		ОткрытьФорму("Задача.ЗадачаИсполнителя.Форма.ОшибкиГрупповогоВыполнения", 
			ПараметрыФормы,
			,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
		
		Возврат;
		
	КонецЕсли;
	
	Если КонтекстВыполненияЗадачи.ДанныеВыполнения.ЗапретВыполнения Тогда
		
		ОткрытьФорму("ОбщаяФорма.ЗапретВыполнения",
			Новый Структура(
				"ТекстПредупреждения",
				КонтекстВыполненияЗадачи.ДанныеВыполнения.ПричинаЗапретаВыполнения));
		
		Возврат;
		
	КонецЕсли;
	
	Если КонтекстВыполненияЗадачи.ДанныеВыполнения.ВерсииДанныхРазличаются Тогда
		
		Оповестить("ЗадачаИзмениласьПередПопыткойИсполненияИлиИзменения",
			КонтекстВыполненияЗадачи.ИдентификаторФормы);
		Возврат;
		
	КонецЕсли;
	
	Если КонтекстВыполненияЗадачи.ДанныеВыполнения.ПоказатьПредупреждение Тогда
		
		Если КонтекстВыполненияЗадачи.ДанныеВыполнения.ПредупредитьОЗаполненииДополнительныхРеквизитов Тогда
			Оповестить("ПредупредитьОЗаполненииДополнительныхРеквизитов", КонтекстВыполненияЗадачи.ИдентификаторФормы);
		Иначе
			ПредупреждениеЗаполняемыхПредметов = СтрСоединить(
				КонтекстВыполненияЗадачи.ДанныеВыполнения.Предупреждения,
				Символы.ПС + Символы.ПС);
			ПоказатьПредупреждение(, ПредупреждениеЗаполняемыхПредметов);
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	Если КонтекстВыполненияЗадачи.ДанныеВыполнения.ВыбратьИсполнителяЗадачи Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбработатьДанныеВыполненияПослеВыбораИсполнителя",
			ЭтотОбъект,
			ПараметрыОповещения);
		
		ОткрытьФорму("ОбщаяФорма.ВыборФактическогоИсполнителяЗадачи", 
			КонтекстВыполненияЗадачи,
			ФормаВладелец,
			КонтекстВыполненияЗадачи.ИдентификаторФормы,,,
			ОписаниеОповещения);
		
		Возврат;
		
	КонецЕсли;
	
	Если КонтекстВыполненияЗадачи.ДанныеВыполнения.ВыбратьПомощника Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбработатьДанныеВыполненияПослеВыбораПомощника",
			ЭтотОбъект,
			ПараметрыОповещения);
		
		ОткрытьФорму("ОбщаяФорма.ВыборПомощникаДляОбработкиРезолюции", 
			КонтекстВыполненияЗадачи, , , , ,
			ОписаниеОповещения);
		Возврат;
		
	КонецЕсли;
	
	Если КонтекстВыполненияЗадачи.ДанныеВыполнения.ПредложитьЗакрытьПодзадачи Тогда
		
#Вставка
		// Не выполнять подзадачи / 24.01.2024г. / Князев Д.С.
		// Исправил вызов процедуры после обновления на 3.0.14.31 / 05.08.2024 г. / Елбашов Д.И, 
		// РаботаСЗадачамиКлиент.ОбработатьДанныеВыполненияПослеПредложенияЗакрытьПодзадачи(КодВозвратаДиалога.Нет, КонтекстВыполненияЗадачи);
		ОбработатьДанныеВыполненияПослеПредложенияЗакрытьПодзадачи(КодВозвратаДиалога.Нет, ПараметрыОповещения);
		Возврат; // выход из процедуры		
#КонецВставки
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбработатьДанныеВыполненияПослеПредложенияЗакрытьПодзадачи",
			ЭтотОбъект,
			ПараметрыОповещения);
		
		ПредложитьЗакрытьПодзадачи(
			КонтекстВыполненияЗадачи.ДанныеВыполнения.КоличествоНезавершенныхПодзадач,
			ОписаниеОповещения);
		
		Возврат;
		
	КонецЕсли;
	
	Если КонтекстВыполненияЗадачи.ДанныеВыполнения.ПроверитьЗанятыеФайлы Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбработатьДанныеВыполненияПослеПроверкиЗанятыхФайлов",
			ЭтотОбъект,
			ПараметрыОповещения);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СообщениеВопрос", НСтр("ru = 'Выполнить задачу?'"));
		ПараметрыФормы.Вставить("СообщениеЗаголовок", НСтр("ru = 'Некоторые файлы приложенных документов заняты для редактирования:'"));
		ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Выполнение задачи'"));
		ПараметрыФормы.Вставить("ТекстКнопкиЗакончитьИЗакрыть", НСтр("ru = 'Закончить редактирование и выполнить'"));
		ПараметрыФормы.Вставить("ТекстКнопкиЗакрыть", НСтр("ru = 'Выполнить'"));
		ПараметрыФормы.Вставить("ФайлыДляПроверки", КонтекстВыполненияЗадачи.ДанныеВыполнения.ФайлыДляПроверки);
		ПараметрыФормы.Вставить("Редактирует", ПользователиКлиент.ТекущийПользователь());
		
		ФиксированныйМассивВсеСотрудникиТекущегоПользователя =
			СотрудникиКлиент.ВсеСотрудникиТекущегоПользователя();
		МассивВсеСотрудникиТекущегоПользователя = Новый Массив(
			ФиксированныйМассивВсеСотрудникиТекущегоПользователя);
		СотрудникиТекущегоПользователя = Новый СписокЗначений();
		СотрудникиТекущегоПользователя.ЗагрузитьЗначения(МассивВсеСотрудникиТекущегоПользователя);
		ПараметрыФормы.Вставить("СотрудникиТекущегоПользователя", СотрудникиТекущегоПользователя);
		
		ТекущийПользователь = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ТекущийПользователь;
		ПараметрыФормы.Вставить("ТекущийПользователь", ТекущийПользователь);
		
		РаботаСФайламиКлиент.ОткрытьДиалогСписокЗанятыхФайлов(ПараметрыФормы, ОписаниеОповещения);
		Если ПараметрыФормы.КоличествоЗанятыхФайлов > 0 Тогда
			Возврат;
		Иначе
			КонтекстВыполненияЗадачи.ДанныеВыполнения.ПроверитьЗанятыеФайлы = Ложь;
			КонтекстВыполненияЗадачи.ПараметрыВыполнения.ЗанятыеФайлыПроверены = Истина;
			КонтекстВыполненияЗадачи.ТребуетсяПовторитьВыполнениеЗадачи = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если КонтекстВыполненияЗадачи.ДанныеВыполнения.ТребуетсяВвестиПричинуВозврата Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбработатьДанныеВыполненияПослеВводаПричиныВозврата",
			ЭтотОбъект,
			ПараметрыОповещения);
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить(
			"ЗадачаИлиДействие",
			КонтекстВыполненияЗадачи.ДанныеВыполнения.ЗадачаДляВозврата);
		ПараметрыОткрытия.Вставить(
			"ОбщаяПричинаВозврата",
			КонтекстВыполненияЗадачи.ДанныеВыполнения.ОбщаяПричинаВозврата);
		
		ОткрытьФорму(
			"Документ.Задача.Форма.ВводПричиныВозврата",
			ПараметрыОткрытия,,,,,
			ОписаниеОповещения);
		
		Возврат;
		
	КонецЕсли;
	
	Если КонтекстВыполненияЗадачи.ДанныеВыполнения.ПредупредитьОбОтсутствиях Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбработатьДанныеВыполненияПослеПредупрежденияОбОтсутствиях",
			ЭтотОбъект,
			ПараметрыОповещения);
		
		ОтсутствияКлиент.ПредупредитьОбОтсутствиях(
			КонтекстВыполненияЗадачи.ДанныеВыполнения.РезультатПроверкиОтсутствий,
			ОписаниеОповещения);
		
		Возврат;
		
	КонецЕсли;
	
	Если КонтекстВыполненияЗадачи.ДанныеВыполнения.ПроизвольныйВопрос.ЗадатьВопрос Тогда
		Обработчик = Новый ОписаниеОповещения(
			"ОбработатьДанныеВыполненияПослеПодтверждающегоВопроса",
			ЭтотОбъект,
			ПараметрыОповещения);
		Если НагрузочноеТестированиеКлиент.ЭтоНагрузочноеТестирование() Тогда
			// При нагрузочном тестировании вопросы не нужны, вызов обработчика напрямую.
			ВыполнитьОбработкуОповещения(Обработчик, КодВозвратаДиалога.Да);
			Возврат;
		КонецЕсли;
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.ЗагрузитьЗначения(КонтекстВыполненияЗадачи.ДанныеВыполнения.ПроизвольныйВопрос.Кнопки);
		
		ПоказатьВопрос(Обработчик, КонтекстВыполненияЗадачи.ДанныеВыполнения.ПроизвольныйВопрос.Текст, СписокКнопок);
		Возврат;
	КонецЕсли;
	
	Если ИнтеграцияЗадачКлиент.ОбработатьДанныеВыполнения(КонтекстВыполненияЗадачи, ФормаВладелец) Тогда
		Возврат;
	КонецЕсли;
	
	Если КонтекстВыполненияЗадачи.ТребуетсяПовторитьВыполнениеЗадачи Тогда
		
		КонтекстВыполненияЗадачи.ТребуетсяПовторитьВыполнениеЗадачи = Ложь;
		
		АвтоЗавершение = Ложь;
		Если КонтекстВыполненияЗадачи.ДействияЗадач.Количество() = 1 Тогда	
#Удаление
			КлючевыеОперации = "ВыполнитьДействиеЗадачиОднаЗадача";
#КонецУдаления
#Вставка
		Если КонтекстВыполненияЗадачи.РезультатДействия = ПредопределенноеЗначение("Справочник.РезультатыДействийЗадач.Выполнена")
			И ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(КонтекстВыполненияЗадачи.ДействияЗадач[0], "ВидДействия") = ПредопределенноеЗначение("Справочник.ВидыДействийЗадач.Исполнить") Тогда
			КлючевыеОперации = "ЗадачаИсполненияВыполнениеКомандыВыполнена";
		Иначе
			КлючевыеОперации = "ВыполнитьДействиеЗадачиОднаЗадача";
		КонецЕсли;
#КонецВставки
			УИДЗамера = ОценкаПроизводительностиКлиент.ЗамерВремени(КлючевыеОперации,,АвтоЗавершение);
		Иначе
			КлючевыеОперации = "ВыполнитьДействиеЗадачиНесколькоЗадач";
			УИДЗамера = ОценкаПроизводительностиКлиент.ЗамерВремени(КлючевыеОперации,АвтоЗавершение);
		КонецЕсли;	
		КонтекстВыполненияЗадачи.УИДЗамера = УИДЗамера;
		
		КонтекстВыполненияЗадачи.ДанныеВыполнения = РаботаСЗадачамиВызовСервера.ВыполнитьДействиеЗадачи(
			КонтекстВыполненияЗадачи.ДействияЗадач,
			КонтекстВыполненияЗадачи.РезультатДействия,
			КонтекстВыполненияЗадачи.ПараметрыВыполнения);
		
		#Вставка 
		//++AxelSoft Шарапова 24.01.2025 САНФ-030728
		//Если КонтекстВыполненияЗадачи.РезультатДействия = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Справочник.РезультатыДействийЗадач.ПеренесенСрок")
		//	И КонтекстВыполненияЗадачи.ДействияЗадач.Количество() Тогда
		//			
		//	РаботаСЗадачамиВызовСервера.ЦППК_ОбработатьОшибкуРелиза(КонтекстВыполненияЗадачи);
		//
		//КонецЕсли;	
		//--AxelSoft Шарапова 24.01.2025 САНФ-030728
		#КонецВставки
		ОбработатьДанныеВыполнения(КонтекстВыполненияЗадачи, ФормаВладелец);
		
		Возврат;
		
	КонецЕсли;
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(КонтекстВыполненияЗадачи.УИДЗамера);
	ОбработатьВыполнениеДействияЗадачи(
		КонтекстВыполненияЗадачи.ДействияЗадач,
		КонтекстВыполненияЗадачи.ИдентификаторФормы,
		КонтекстВыполненияЗадачи.ДанныеВыполнения);
	
КонецПроцедуры

&ИзменениеИКонтроль("ВыполнитьДействиеЗадачи")
Процедура ЦППК_ВыполнитьДействиеЗадачи(
	ДействияЗадач, РезультатДействия, ФормаВладелец, ВерсииДанных = Неопределено) Экспорт
	
	Если ДействияЗадач.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	АвтоЗавершение = Ложь;
	Если ДействияЗадач.Количество() = 1 Тогда
#Удаление
		КлючевыеОперации = "ВыполнитьДействиеЗадачиОднаЗадача";
#КонецУдаления
#Вставка
		Если РезультатДействия = ПредопределенноеЗначение("Справочник.РезультатыДействийЗадач.Выполнена")
			И ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(ДействияЗадач[0], "ВидДействия") = ПредопределенноеЗначение("Справочник.ВидыДействийЗадач.Исполнить") Тогда
			КлючевыеОперации = "ЗадачаИсполненияВыполнениеКомандыВыполнена";
		Иначе
			КлючевыеОперации = "ВыполнитьДействиеЗадачиОднаЗадача";
		КонецЕсли;
#КонецВставки
		УИДЗамера = ОценкаПроизводительностиКлиент.ЗамерВремени(КлючевыеОперации,,АвтоЗавершение);
	Иначе
		КлючевыеОперации = "ВыполнитьДействиеЗадачиНесколькоЗадач";
		УИДЗамера = ОценкаПроизводительностиКлиент.ЗамерВремени(КлючевыеОперации,АвтоЗавершение);
	КонецЕсли;	
	
	Попытка
		
		ПараметрыВыполнения = РаботаСЗадачамиКлиентСервер.НовыйПараметрыВыполненияДействийЗадач();
		Если ВерсииДанных <> Неопределено Тогда
			ПараметрыВыполнения.ВерсииДанных = ВерсииДанных;
		КонецЕсли;
		ПараметрыВыполнения.ДанныеФормыВладельца.ИмяФормы = ФормаВладелец.ИмяФормы;
		ПараметрыВыполнения.ДанныеФормыВладельца.ИдентификаторФормы = ФормаВладелец.УникальныйИдентификатор;
		
		ДанныеВыполнения = РаботаСЗадачамиВызовСервера.ВыполнитьДействиеЗадачи(
			ДействияЗадач,
			РезультатДействия,
			ПараметрыВыполнения);
		
		КонтекстВыполненияЗадачи = НовыйКонтекстВыполненияЗадачи();
		КонтекстВыполненияЗадачи.ДействияЗадач = ДействияЗадач;
		КонтекстВыполненияЗадачи.РезультатДействия = РезультатДействия;
		КонтекстВыполненияЗадачи.ИдентификаторФормы = ФормаВладелец.УникальныйИдентификатор;
		КонтекстВыполненияЗадачи.ПараметрыВыполнения = ПараметрыВыполнения;
		КонтекстВыполненияЗадачи.ДанныеВыполнения = ДанныеВыполнения;
		КонтекстВыполненияЗадачи.УИДЗамера = УИДЗамера;
		
		ОбработатьДанныеВыполнения(КонтекстВыполненияЗадачи, ФормаВладелец);
		
	Исключение
		
		ОповеститьОбИсключении();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&ИзменениеИКонтроль("ПоказатьПриложение")
Процедура ЦППК_ПоказатьПриложение(Приложение)

	Если Не ЗначениеЗаполнено(Приложение) Тогда
		Возврат;
	КонецЕсли;

	Если Не РаботаСЗадачамиКлиентСервер.ЭтоПриложениеБезПрав(Приложение) Тогда
#Удаление
		ПоказатьЗначение(, Приложение);
#КонецУдаления
#Вставка
		КлючеваяОперация = "ОткрытиеФормыЭлементаСправочникаДокументыПредприятияИзЗадач";
		ЭтоДокументПредприятия = ТипЗнч(Приложение) = Тип("СправочникСсылка.ДокументыПредприятия");
		
		Если ЭтоДокументПредприятия Тогда
			УИДЗамера = ОценкаПроизводительностиКлиент.ЗамерВремени(КлючеваяОперация, , Ложь);
		КонецЕсли;
		
		ПоказатьЗначение(, Приложение);
		
		Если ЭтоДокументПредприятия Тогда
			ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);
		КонецЕсли;
#КонецВставки
		Возврат;
	КонецЕсли;

	ДанныеВложенногоПисьма = РаботаСЗадачамиВызовСервера.ДанныеВложенногоПисьма(Приложение);
	Если ДанныеВложенногоПисьма = Неопределено Тогда
		ПоказатьЗначение(, Приложение);
		Возврат;
	КонецЕсли;

	ПараметрыОткрытия = Новый Структура("ДвоичныеДанные", ДанныеВложенногоПисьма);
	ОткрытьФорму(
	"ЖурналДокументов.ЭлектроннаяПочта.Форма.ПросмотрВложенногоПисьма", 
	ПараметрыОткрытия);

КонецПроцедуры

&ИзменениеИКонтроль("НаправитьНаИсполнениеПослеЗавершенияДлительнойОперации")
Процедура ЦППК_НаправитьНаИсполнениеПослеЗавершенияДлительнойОперации(Результат, ДополнительныеПараметры)

	Если Результат = Неопределено Тогда
		ОповеститьОбИсключении();
		Возврат;
	КонецЕсли;

	Если Результат.Статус = "Выполнено" Тогда

		РезультатНаправленияНаИсполнение = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		ОбработатьРезультатНаправленияНаИсполнение(РезультатНаправленияНаИсполнение);

	ИначеЕсли Результат.Статус = "Ошибка" Тогда

		ОповеститьОбИсключении();

#Удаление
		ВызватьИсключение Результат.ПодробноеПредставлениеОшибки;
#КонецУдаления
#Вставка
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
#КонецВставки

	Иначе

		ОповеститьОбИсключении();

		ВызватьИсключение СтрШаблон(
		НСтр("ru = 'Неизвестный статус длительной операции %1'"),
		Результат.Статус);

	КонецЕсли;

КонецПроцедуры
