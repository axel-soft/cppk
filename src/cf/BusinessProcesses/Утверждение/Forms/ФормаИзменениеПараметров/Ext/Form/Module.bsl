﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Учет переносов сроков выполнения
	ПереносСроковВыполненияЗадач.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// Сроки выполнения
	УстановитьУсловноеОформлениеИстекшихСроков();
	СрокиИсполненияПроцессов.КарточкаПроцессаПриСозданииНаСервере(
		ЭтаФорма, БизнесПроцессы.Утверждение.ТочкиМаршрута.Ознакомиться, Истина);
	
	УстановитьДоступностьПоШаблону();
	
	Мультипредметность.ПроцессПриСозданииНаСервере(ЭтаФорма, Объект);
	
	ПроверятьОтсутствие = Отсутствия.ПредупреждатьОбОтсутствии();
	
	СформироватьЗаголовкиИПодсказкиЭлементовФормы();
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		НастроитьЭлементыФормыДляМобильногоУстройства();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	МультипредметностьКлиентСервер.ЗаполнитьТаблицуПредметовФормы(Объект);
	Мультипредметность.ОбработатьОписаниеПредметовПроцесса(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Учет переноса сроков
	ПереносСроковВыполненияЗадач.ПередатьПричинуИЗаявкуНаПереносаСрока(ТекущийОбъект, ПараметрыЗаписи);
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ЭтоВыполнениеЗадачиОбрабатывающегоРезультат", Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Мультипредметность.ПроцессПослеЗаписиНаСервере(ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("БизнесПроцессИзменен", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоличествоИтерацийПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.КоличествоИтерацийПриИзменении(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы_Исполнитель

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.УчастникСоСрокомИсполненияПриИзменении(ЭтаФорма, "Исполнитель");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникСоСрокомИсполненияНачалоВыбора(
		Элемент, Объект.Исполнитель, СтандартнаяОбработка, ЭтаФорма, "Исполнитель");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОчистка(Элемент, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникСоСрокомИсполненияОчистка(СтандартнаяОбработка,
		ЭтаФорма, "Исполнитель");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОткрытие(Элемент, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникОткрытие(СтандартнаяОбработка,
		ЭтаФорма, "Исполнитель");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникОбработкаВыбора(
		Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
		
	СотрудникиКлиент.СотрудникОбработкаВыбора(
		Элемент.ТекущиеДанные.Исполнитель, "Исполнитель", ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникАвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.
		УчастникОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка,
			ЭтаФорма, "Исполнитель");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы_СрокИсполненияПредставление

&НаКлиенте
Процедура СрокИсполненияПредставлениеПриИзменении(Элемент)
	
	ДопПараметры = СрокиИсполненияПроцессовКлиент.ДопПараметрыДляИзмененияСрокаПоПредставлению();
	ДопПараметры.Форма = ЭтаФорма;
	ДопПараметры.Поле = "СрокИсполненияПредставление";
	ДопПараметры.НаименованиеИзмененногоРеквизита = "СрокИсполнения";
	ДопПараметры.Исполнитель = Объект.Исполнитель;
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияУчастникаПроцессаПоПредставлению(
		Объект.СрокИсполнения,
		Объект.СрокИсполненияДни,
		Объект.СрокИсполненияЧасы,
		Объект.СрокИсполненияМинуты,
		Объект.ВариантУстановкиСрокаИсполнения,
		СрокИсполненияПредставление,
		ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыВыбораСрока = СрокиИсполненияПроцессовКлиент.ПараметрыВыбораСрокаУчастникаПроцесса();
	ПараметрыВыбораСрока.Форма = ЭтаФорма;
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполнения = "СрокИсполнения";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияДни = "СрокИсполненияДни";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияЧасы = "СрокИсполненияЧасы";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияМинуты = "СрокИсполненияМинуты";
	ПараметрыВыбораСрока.ИмяРеквизитаВариантУстановкиСрока = "ВариантУстановкиСрокаИсполнения";
	ПараметрыВыбораСрока.ИмяРеквизитаПредставлениеСрока = "СрокИсполненияПредставление";
	ПараметрыВыбораСрока.ИмяОбъектаФормы = "Объект";
	ПараметрыВыбораСрока.НаименованиеСрокаУчастника = "СрокИсполнения";
	ПараметрыВыбораСрока.Участник = Объект.Исполнитель;
	
	СрокиИсполненияПроцессовКлиент.ВыбратьСрокУчастникаПроцесса(ПараметрыВыбораСрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьОтносительныйСрокУчастникаПроцесса(
		ЭтаФорма,
		Объект.СрокИсполнения,
		Объект.СрокИсполненияДни,
		Объект.СрокИсполненияЧасы,
		Объект.СрокИсполненияМинуты,
		СрокИсполненияПредставление,
		Объект.ВариантУстановкиСрокаИсполнения,
		Направление,
		"СрокИсполнения");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы_СрокОбработкиРезультатовПредставление

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеПриИзменении(Элемент)
	
	ДопПараметры = СрокиИсполненияПроцессовКлиент.ДопПараметрыДляИзмененияСрокаПоПредставлению();
	ДопПараметры.Форма = ЭтаФорма;
	ДопПараметры.Поле = "СрокОбработкиРезультатовПредставление";
	ДопПараметры.НаименованиеИзмененногоРеквизита = "СрокОбработкиРезультатов";
	ДопПараметры.Исполнитель = Объект.ОбрабатывающийРезультат;
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияУчастникаПроцессаПоПредставлению(
		Объект.СрокОбработкиРезультатов,
		Объект.СрокОбработкиРезультатовДни,
		Объект.СрокОбработкиРезультатовЧасы,
		Объект.СрокОбработкиРезультатовМинуты,
		Объект.ВариантУстановкиСрокаОбработкиРезультатов,
		СрокОбработкиРезультатовПредставление,
		ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыВыбораСрока = СрокиИсполненияПроцессовКлиент.ПараметрыВыбораСрокаУчастникаПроцесса();
	ПараметрыВыбораСрока.Форма = ЭтаФорма;
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполнения = "СрокОбработкиРезультатов";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияДни = "СрокОбработкиРезультатовДни";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияЧасы = "СрокОбработкиРезультатовЧасы";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияМинуты = "СрокОбработкиРезультатовМинуты";
	ПараметрыВыбораСрока.ИмяРеквизитаВариантУстановкиСрока = "ВариантУстановкиСрокаОбработкиРезультатов";
	ПараметрыВыбораСрока.ИмяРеквизитаПредставлениеСрока = "СрокОбработкиРезультатовПредставление";
	ПараметрыВыбораСрока.ИмяОбъектаФормы = "Объект";
	ПараметрыВыбораСрока.СрокиПредшественников = Объект.СрокИсполнения;
	ПараметрыВыбораСрока.НаименованиеСрокаУчастника = "СрокОбработкиРезультатов";
	ПараметрыВыбораСрока.Участник = Объект.ОбрабатывающийРезультат;
	
	СрокиИсполненияПроцессовКлиент.ВыбратьСрокУчастникаПроцесса(ПараметрыВыбораСрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьОтносительныйСрокУчастникаПроцесса(
		ЭтаФорма,
		Объект.СрокОбработкиРезультатов,
		Объект.СрокОбработкиРезультатовДни,
		Объект.СрокОбработкиРезультатовЧасы,
		Объект.СрокОбработкиРезультатовМинуты,
		СрокОбработкиРезультатовПредставление,
		Объект.ВариантУстановкиСрокаОбработкиРезультатов,
		Направление,
		"СрокОбработкиРезультатов");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если НЕ ЗначениеЗаполнено(РезультатВыполнения) Тогда
		
		СообщениеОбОшибке = НСтр("ru = 'Не заполнен комментарий'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СообщениеОбОшибке,,
			"РезультатВыполнения");
		
		Возврат;
		
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОК_ПослеПодтвержденияПереносаСрока", ЭтотОбъект);
	
	СрокиИсполненияПроцессовКлиент.ПодтвердитьПереносСрокаПроцессаПриВозвратеНаДоработку(
		ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК_ПослеПодтвержденияПереносаСрока(Результат, Параметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОК_ПослеПроверкиОтсутствия", ЭтотОбъект);
	Если Не ОтсутствияКлиент.ПроверитьОтсутствиеПоПроцессу(ЭтаФорма, ОписаниеОповещения) Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК_ПослеПроверкиОтсутствия(Результат, Параметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	РезультатВыполненияЗадачи = СтруктураРезультата();
	
	Если Модифицированность Тогда 
		Если ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры <> Неопределено 
			И ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Свойство("ИдентификаторБлокировкиПроцесса") Тогда
			ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ИдентификаторБлокировкиПроцесса = 
				УникальныйИдентификатор;
		КонецЕсли;
		ОчиститьСообщения();
		
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("ПричинаПереносаСрока", ПричинаПереносаСрока);
		
		Если Записать(ПараметрыЗаписи) Тогда 
			// Сроки выполнения
			СрокиИсполненияПроцессовКлиент.ОповеститьОПереносеСроков(ЭтаФорма);
			
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Изменение:'"),
				ПолучитьНавигационнуюСсылку(Объект.Ссылка),
				Строка(Объект.Ссылка),
				БиблиотекаКартинок.Информация32);
			РезультатВыполненияЗадачи.КодВозврата = КодВозвратаДиалога.ОК;
			Закрыть(РезультатВыполненияЗадачи);
		КонецЕсли;
	Иначе
		РезультатВыполненияЗадачи.КодВозврата = КодВозвратаДиалога.ОК;
		Закрыть(РезультатВыполненияЗадачи);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть(СтруктураРезультата());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьДоступностьПоШаблону()
	
	ДоступностьПоШаблону = Истина;
	
	Если Не ЗначениеЗаполнено(Объект.Шаблон) И Не ЗначениеЗаполнено(Объект.ВедущаяЗадача) Тогда 
		Возврат;
	КонецЕсли;
	
	ДоступностьПоШаблону = ШаблоныБизнесПроцессов.ДоступностьПоШаблону(Объект);
	
	Если ЗначениеЗаполнено(Объект.Исполнитель) Тогда 
		Элементы.Исполнитель.ТолькоПросмотр = Не ДоступностьПоШаблону;
	Иначе
		Элементы.Исполнитель.ТолькоПросмотр = Ложь;
	КонецЕсли;
	Элементы.Исполнитель.ТолькоПросмотр = Элементы.Исполнитель.ТолькоПросмотр ИЛИ ТолькоПросмотр;
	
	ПараметрыДоступности = 
		СрокиИсполненияПроцессовКлиентСервер.ПараметрыДоступностиЭлементаУправления();
	ПараметрыДоступности.ДоступностьПоШаблону = ДоступностьПоШаблону;
	
	СрокиИсполненияПроцессовКлиентСервер.НастроитьЭлементУправленияСроком(
		ЭтаФорма,
		Элементы.СрокИсполненияПредставление,
		СрокИсполненияПредставление,
		ПараметрыДоступности);
		
	СрокиИсполненияПроцессовКлиентСервер.НастроитьЭлементУправленияСроком(
		ЭтаФорма,
		Элементы.СрокОбработкиРезультатовПредставление,
		СрокОбработкиРезультатовПредставление,
		ПараметрыДоступности);
	
	СрокиИсполненияПроцессовКлиентСервер.НастроитьЭлементУправленияСроком(
		ЭтаФорма,
		Элементы.КоличествоИтераций,
		Объект.КоличествоИтераций,
		ПараметрыДоступности);
	
КонецПроцедуры

// Возвращает структуру результата для процедур закрытия формы.
//
&НаКлиенте
Функция СтруктураРезультата()
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("РезультатВыполнения", РезультатВыполнения);
	СтруктураРезультата.Вставить("КодВозврата", КодВозвратаДиалога.Отмена);
	СтруктураРезультата.Вставить("Исполнитель", Объект.Исполнитель);
	СтруктураРезультата.Вставить("ВладелецРоли", Неопределено);
	СтруктураРезультата.Вставить("ОсновнойОбъектАдресации", Неопределено);
	СтруктураРезультата.Вставить("ДополнительныйОбъектАдресации", Неопределено);
	
	СтруктураРезультата.Вставить("СрокИсполнения", Объект.СрокИсполнения);
	СтруктураРезультата.Вставить("СрокИсполненияДни", Объект.СрокИсполненияДни);
	СтруктураРезультата.Вставить("СрокИсполненияЧасы", Объект.СрокИсполненияЧасы);
	СтруктураРезультата.Вставить("СрокИсполненияМинуты", Объект.СрокИсполненияМинуты);
	СтруктураРезультата.Вставить("ВариантУстановкиСрокаИсполнения", Объект.ВариантУстановкиСрокаИсполнения);
	
	СтруктураРезультата.Вставить("СрокОбработкиРезультатов", Объект.СрокОбработкиРезультатов);
	СтруктураРезультата.Вставить("СрокОбработкиРезультатовДни", Объект.СрокОбработкиРезультатовДни);
	СтруктураРезультата.Вставить("СрокОбработкиРезультатовЧасы", Объект.СрокОбработкиРезультатовЧасы);
	СтруктураРезультата.Вставить("СрокОбработкиРезультатовМинуты", Объект.СрокОбработкиРезультатовМинуты);
	СтруктураРезультата.Вставить("ВариантУстановкиСрокаОбработкиРезультатов", Объект.ВариантУстановкиСрокаОбработкиРезультатов);
	
	СтруктураРезультата.Вставить("СрокИсполненияПроцесса", Объект.СрокИсполненияПроцесса);
	
	СтруктураРезультата.Вставить("ПричинаПереносаСрока", ПричинаПереносаСрока);
	
	СтруктураРезультата.Вставить("КоличествоИтераций", Объект.КоличествоИтераций);
	
	Возврат СтруктураРезультата;
	
КонецФункции

&НаСервере
Процедура СформироватьЗаголовкиИПодсказкиЭлементовФормы()
	
	Заголовок = НСтр("ru = 'Повтор утверждения'");
	Элементы.СрокИсполненияПредставление.Заголовок = НСтр("ru = 'Срок утверждения'");
	Элементы.СрокИсполненияПредставление.Подсказка = НСтр("ru = 'Срок утверждения (по графику работ)'");
	Команды.ОК.Заголовок = НСтр("ru = 'Отправить на повторное утверждение'");
	Команды.ОК.Подсказка = НСтр("ru = 'Отправить на повторное утверждение'");

КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыДляМобильногоУстройства()
	
	Элементы.Исполнитель.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	Элементы.СрокИсполненияПредставление.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	Элементы.СрокОбработкиРезультатовПредставление.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	
	Элементы.СрокИсполненияПроцессаПредставление.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	Элементы.СрокИсполненияПроцессаПредставление.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСлева;
	
	Элементы.Отмена.Видимость = Ложь;
	
	Элементы.РезультатВыполнения.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСверху;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_СрокиИсполненияПроцессов

// Заполняет представление сроков в карточке процесса
//
&НаСервере
Процедура ОбновитьСрокиИсполненияНаСервере() Экспорт
	
	ПараметрыДляРасчетаСроков = СрокиИсполненияПроцессов.ПараметрыДляРасчетаСроков();
	ПараметрыДляРасчетаСроков.ДатаОтсчета = ДатаОтсчетаДляРасчетаСроков;
	ПараметрыДляРасчетаСроков.РеквизитТаблицаСИзмененнымСроком = РеквизитСИзмененнымСроком;
	ПараметрыДляРасчетаСроков.ТекущаяИтерация = Объект.НомерИтерации + 1;
	ПараметрыДляРасчетаСроков.ЗаполнятьСрокПроцессаТолькоПриПревышении = Истина;
	
	СрокиИсполненияПроцессов.РассчитатьСрокиУтверждения(Объект, ПараметрыДляРасчетаСроков);
	
	СрокиИсполненияПроцессов.ПроверитьИзменениеСроковВФормеПроцесса(ЭтаФорма);
		
	РеквизитСИзмененнымСроком = "";
	
	ОбновитьПризнакиИстекшихСроков();
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковИсполненияВФорме(ЭтаФорма);
	
КонецПроцедуры

// см. ОбновитьСрокиИсполненияНаСервере
&НаКлиенте
Процедура ОбновитьСрокиИсполнения()
	
	ОбновитьСрокиИсполненияНаСервере();
	
КонецПроцедуры

// см. ОбновитьСрокиИсполнения
&НаКлиенте
Процедура ОбновитьСрокиИсполненияОтложенно(Реквизит = "") Экспорт
	
	РеквизитСИзмененнымСроком = Реквизит;
	
	ПодключитьОбработчикОжидания("ОбновитьСрокиИсполнения", 0.2, Истина);
	
КонецПроцедуры

// Заполняет представление сроков исполнения в карточке процесса.
//
&НаКлиенте
Процедура ЗаполнитьПредставлениеСроковИсполнения() Экспорт
	
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковИсполненияВФорме(ЭтаФорма);
	
КонецПроцедуры

// Устанавливает условное оформление истекших сроков.
//
&НаСервере
Процедура УстановитьУсловноеОформлениеИстекшихСроков()
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок исполнения истек (Исполнитель)'"),
		"СрокИсполненияИстек",
		"СрокИсполненияПредставление");
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок обработки результатов истек'"),
		"СрокОбработкиРезультатовИстек",
		"СрокОбработкиРезультатовПредставление");
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок исполнения процесса истек'"),
		"СрокИсполненияПроцессаИстек",
		"СрокИсполненияПроцессаПредставление");
	
КонецПроцедуры

// Обновляет признаки истекших сроков в карточке.
//
&НаСервере
Процедура ОбновитьПризнакиИстекшихСроков()
	
	СрокиИсполненияПроцессов.ОбновитьПризнакИстекшегоСрокаУчастника(
		Объект.СрокИсполнения,
		СрокИсполненияИстек,
		ТекущаяДатаСеанса(),
		"Исполнитель");
	
	СрокиИсполненияПроцессов.ОбновитьПризнакИстекшегоСрокаУчастника(
		Объект.СрокОбработкиРезультатов,
		СрокОбработкиРезультатовИстек,
		ТекущаяДатаСеанса(),
		"ОбрабатывающийРезультат");
		
	СрокиИсполненияПроцессов.ОбновитьПризнакИстекшегоСрокаПроцесса(
		Объект.СрокИсполненияПроцесса, Объект.ДатаЗавершения, СрокИсполненияПроцессаИстек);
	
КонецПроцедуры

#КонецОбласти
