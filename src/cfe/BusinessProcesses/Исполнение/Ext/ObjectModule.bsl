﻿
&ИзменениеИКонтроль("ОбработкаЗаполнения")
Процедура ЦППК_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если ЭтоНовый() Тогда 
		Дата = ТекущаяДатаСеанса();
		Важность = Перечисления.ВариантыВажностиОбъектов.Обычная;
		НомерИтерации = 0;
		Проверяющий = Сотрудники.ОсновнойСотрудник();
		ВариантИсполнения = Перечисления.ВариантыМаршрутизацииЗадач.Параллельно;		
		Если Не ЗначениеЗаполнено(Автор) Тогда
			Автор = Сотрудники.ОсновнойСотрудник();
		КонецЕсли;		
		Если Не ЗначениеЗаполнено(Проект) Тогда 
			Проект = РаботаСПроектами.ПолучитьПроектПоУмолчанию();
		КонецЕсли;
#Вставка
		// ++
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
			Если ДанныеЗаполнения.Свойство("ЗадачаИсполнителя") Тогда
				Если ЗначениеЗаполнено(ДанныеЗаполнения.ЗадачаИсполнителя.Исполнитель) и НЕ ЗначениеЗаполнено(ДанныеЗаполнения.ЗадачаИсполнителя.РольИсполнителя) Тогда
					Автор = ДанныеЗаполнения.ЗадачаИсполнителя.Исполнитель;
					Проверяющий = ДанныеЗаполнения.ЗадачаИсполнителя.Исполнитель; 
					//Если ДанныеЗаполнения.ЗадачаИсполнителя.БизнесПроцесс.Метаданные().Реквизиты.Найти("Проверяющий") <> Неопределено 
					//	и ЗначениеЗаполнено(ДанныеЗаполнения.ЗадачаИсполнителя.БизнесПроцесс.Проверяющий) Тогда
					//Проверяющий = ДанныеЗаполнения.ЗадачаИсполнителя.БизнесПроцесс.Проверяющий; 
					//КонецЕсли;
				КонецЕсли;                
			КонецЕсли;                  		
		КонецЕсли;

		// { *Андрей Анохин (ТТС) [28.03.2018]
		Если ДанныеЗаполнения = неопределено или  ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") или Не 
			(ДанныеЗаполнения.Свойство("Шаблон") и ЗначениеЗаполнено(ДанныеЗаполнения.Шаблон.Контролер)) тогда 
			ТТС_КонтролерПоУмолчанию = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТТС_КонтролерПоУмолчанию","ТТС_КонтролерПоУмолчанию");
			Если ЗначениеЗаполнено(ТТС_КонтролерПоУмолчанию) Тогда
				Контролер = ТТС_КонтролерПоУмолчанию;
			КонецЕсли;
		КонецЕсли;                        
		// }	
#КонецВставки		
	КонецЕсли;

	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
		Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ДанныеЗаполнения, Ложь, Истина);
	КонецЕсли;

	Если ТипЗнч(ДанныеЗаполнения) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ЗадачаСсылка = ДанныеЗаполнения;
		ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ДокументыПредприятия") Тогда 
		Описание = "";
		Резолюции = РаботаСРезолюциями.ПолучитьРезолюции(ДанныеЗаполнения);
		Если Резолюции.Количество() > 0 Тогда
			Описание = Резолюции[0].ТекстРезолюции;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда

		Если ДанныеЗаполнения.Свойство("ВедущаяЗадача") Тогда
			ВедущаяЗадача = ДанныеЗаполнения.ВедущаяЗадача;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("Важность") Тогда
			Важность = ДанныеЗаполнения.Важность;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("Наименование") Тогда
			Наименование = ДанныеЗаполнения.Наименование;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("Шаблон") Тогда
			Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ДанныеЗаполнения.Шаблон, ЭтотОбъект);
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("Предметы") Тогда
			Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ДанныеЗаполнения.Предметы, Ложь, Истина);
			Проект = МультипредметностьПереопределяемый.ПолучитьОсновнойПроектПоПредметам(ДанныеЗаполнения.Предметы);
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("АвторСобытия") Тогда
			Автор = ДанныеЗаполнения.АвторСобытия;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			Автор = ДанныеЗаполнения.Автор;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("ИдентификаторКонтролера") Тогда
			ИдентификаторКонтролера = ДанныеЗаполнения.ИдентификаторКонтролера;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("Проверяющий") Тогда
			Проверяющий = ДанныеЗаполнения.Проверяющий;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("ИдентификаторПроверяющего") Тогда
			ИдентификаторПроверяющего = ДанныеЗаполнения.ИдентификаторПроверяющего;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("Шаблон") Тогда
			ЗаполнитьПоШаблону(ДанныеЗаполнения.Шаблон);
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("ПроектнаяЗадача") Тогда
			ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения.ПроектнаяЗадача);
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("Проект") Тогда
			Проект = ДанныеЗаполнения.Проект;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("Исполнители") Тогда
			Если ТипЗнч(ДанныеЗаполнения.Исполнители) = Тип("ТаблицаЗначений") Тогда
				Для Каждого Исполнитель ИЗ ДанныеЗаполнения.Исполнители Цикл
					Строка = Исполнители.Добавить();
					Строка.Исполнитель = Исполнитель.Исполнитель;
					Строка.ИдентификаторИсполнителя = Исполнитель.ИдентификаторИсполнителя;
					Строка.ВариантУстановкиСрокаИсполнения = Исполнитель.ВариантУстановкиСрокаИсполнения;
					Строка.СрокИсполнения = Исполнитель.СрокИсполнения;
					Строка.СрокИсполненияДни = Исполнитель.СрокИсполненияДни;
					Строка.СрокИсполненияЧасы = Исполнитель.СрокИсполненияЧасы;
					Строка.СрокИсполненияМинуты = Исполнитель.СрокИсполненияМинуты;
					Строка.ПорядокИсполнения = Исполнитель.ПорядокИсполнения;
					Строка.НаименованиеЗадачи = Исполнитель.НаименованиеЗадачи;
					Строка.Описание = Исполнитель.Описание;
					Строка.Ответственный = Исполнитель.Ответственный;
				КонецЦикла;
			ИначеЕсли ТипЗнч(ДанныеЗаполнения.Исполнители)= Тип("Массив") Тогда
				Для Каждого Исполнитель Из ДанныеЗаполнения.Исполнители Цикл
					Если ТипЗнч(Исполнитель) = Тип("Структура") Тогда
						Строка = Исполнители.Добавить();
						ЗаполнитьЗначенияСвойств(Строка, Исполнитель);
					Иначе
						Строка = Исполнители.Добавить();
						Строка.Исполнитель = Исполнитель;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("ВариантУстановкиСрокаОбработкиРезультатов") Тогда
			ВариантУстановкиСрокаОбработкиРезультатов = 
			ДанныеЗаполнения.ВариантУстановкиСрокаОбработкиРезультатов;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("СрокОбработкиРезультатов") Тогда
			СрокОбработкиРезультатов = ДанныеЗаполнения.СрокОбработкиРезультатов;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("СрокОбработкиРезультатовДни") Тогда
			СрокОбработкиРезультатовДни = ДанныеЗаполнения.СрокОбработкиРезультатовДни;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("СрокОбработкиРезультатовЧасы") Тогда
			СрокОбработкиРезультатовЧасы = ДанныеЗаполнения.СрокОбработкиРезультатовЧасы;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("СрокОбработкиРезультатовМинуты") Тогда
			СрокОбработкиРезультатовМинуты = ДанныеЗаполнения.СрокОбработкиРезультатовМинуты;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("КоличествоИтераций") Тогда
			КоличествоИтераций = ДанныеЗаполнения.КоличествоИтераций;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("ТрудозатратыПланКонтролера") Тогда
			ТрудозатратыПланКонтролера = ДанныеЗаполнения.ТрудозатратыПланКонтролера;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("ТрудозатратыПланПроверяющего") Тогда
			ТрудозатратыПланПроверяющего = ДанныеЗаполнения.ТрудозатратыПланПроверяющего;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("Шаблон") Тогда
			Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ДанныеЗаполнения.Шаблон, ЭтотОбъект);
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("Предметы") Тогда
			Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ДанныеЗаполнения.Предметы, Ложь, Истина);
			Проект = МультипредметностьПереопределяемый.ПолучитьОсновнойПроектПоПредметам(ДанныеЗаполнения.Предметы);
			ТипыПредметов = Новый Массив;
			ТипыПредметов.Добавить(Тип("СправочникСсылка.ДокументыПредприятия"));

			ОбрабатываемыеПредметы = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ЭтотОбъект, ТипыПредметов, Истина);
			Если ОбрабатываемыеПредметы.Количество() > 0 Тогда
				Описание = "";
				Для каждого Предмет из ОбрабатываемыеПредметы Цикл
					Резолюции = РаботаСРезолюциями.ПолучитьРезолюции(Предмет);
					Если Резолюции.Количество() > 0 Тогда
						Описание = ?(ПустаяСтрока(Описание),"",Символы.ПС + Символы.ПС) 
						+ Резолюции[0].ТекстРезолюции;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("АвторСобытия") Тогда
			Автор = ДанныеЗаполнения.АвторСобытия;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("Шаблон") Тогда
			ЗаполнитьПоШаблону(ДанныеЗаполнения.Шаблон);
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("ЗадачаИсполнителя") Тогда
			ЗадачаСсылка = ДанныеЗаполнения.ЗадачаИсполнителя;
			ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка);
			#Вставка
			//+ЦППК САНФ-023245 30.01.2024
			Автор_ = ЦППК_ОбщийМодульКлиентСервер.ПолучитьПроверяющегоАвтора();
			Если Автор_ <> Неопределено Тогда
				Автор = Автор_;
				Проверяющий = Автор;
			КонецЕсли;
			//-ЦППК 30.01.2024
			//+ЦППК САНФ-023288 31.01.2024			
			ТипыПредметов = Новый Массив;
			ТипыПредметов.Добавить(Тип("СправочникСсылка.ДокументыПредприятия"));
			ОбрабатываемыеПредметы = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ЭтотОбъект, ТипыПредметов, Истина);
			СрокИсполнения = ЦППК_ОбщийМодульВызовСервера.ЗаполнитьСрокИсполнения(ОбрабатываемыеПредметы, ДанныеЗаполнения.ЗадачаИсполнителя);
			
			Если ЗначениеЗаполнено(СрокИсполнения) Тогда
				
				ВариантУстановкиСрокаОбработкиРезультатов = Перечисления.ВариантыУстановкиСрокаИсполнения.ТочныйСрок;
				
				СрокИсполненияПроцесса = СрокИсполнения;
				
				СрокОбработкиРезультатов = СрокИсполнения;
				СрокОбработкиРезультатовДни = (НачалоДня(СрокИсполнения) - НачалоДня(Дата)) / (60 * 60 * 24);
				СрокОбработкиРезультатовМинуты = Минута(СрокИсполнения);   
				СрокОбработкиРезультатовЧасы = Час(СрокИсполнения);
				
			КонецЕсли;  				
			//-ЦППК 31.01.2024					
			#КонецВставки
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ПроектнаяЗадача") Тогда
			ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения.ПроектнаяЗадача);
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("Проект") Тогда
			Проект = ДанныеЗаполнения.Проект;
		КонецЕсли;

		Если ДанныеЗаполнения.Свойство("ЗаписиИсполнения") Тогда
			ЗаписиИсполнения = ДанныеЗаполнения.ЗаписиИсполнения;

			Для Каждого Запись Из ЗаписиИсполнения Цикл
				НоваяСтрока = Исполнители.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Запись);
			КонецЦикла;	

			Проверяющий = ЗаписиИсполнения[0].Проверяющий;
		КонецЕсли;

		ТипыПисем = МультипредметностьПереопределяемый.ПолучитьТипыПисем();
		ОсновныеПисьма = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ЭтотОбъект, ТипыПисем, Истина);
		Для Каждого Письмо Из ОсновныеПисьма Цикл
			Тема = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Письмо, "Тема");
			Проект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Письмо, "Проект");
			Если Не ЗначениеЗаполнено(Наименование) Тогда
				Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Исполнить ""%1""'"),
				Тема);
			КонецЕсли;
			Прервать;
		КонецЦикла;

		Если ДанныеЗаполнения.Свойство("Описание") Тогда
			Описание = ДанныеЗаполнения.Описание;
		КонецЕсли;

	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда 
		ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения);

	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Наименование) И Предметы.Количество() > 0 Тогда
		МультипредметностьКлиентСервер.ЗаполнитьНаименованиеПроцесса(ЭтотОбъект, НСтр("ru = 'Исполнить'"));
	КонецЕсли;
	
	#Вставка
	//++МельниченкоНН 16.08.2024 САНФ-027815
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.Наименование) И ДанныеЗаполнения.Свойство("ЗадачаИсполнителя") Тогда
		ЦППК_ОбщийМодульВызовСервера.СформироватьНаименованиеБП_ПоПриложениямЗадачи(ЭтотОбъект, ДанныеЗаполнения.ЗадачаИсполнителя);
	КонецЕсли;
	//--МельниченкоНН 16.08.2024 САНФ-027815
	#КонецВставки
	
	БизнесПроцессыИЗадачиСервер.ЗаполнитьГлавнуюЗадачу(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

&После("ЗаполнитьБизнесПроцессПоЗадаче")
Процедура ЦППК_ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка)
	
	//{Грошев Александр ТТС [11.01.2017]
	КопироватьОписаниеЗадачДляПодзадач = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ТТС_НастройкиОписанияЗадач",
			"ТТС_КопироватьОписаниеЗадачДляПодзадач",Ложь);
	Если КопироватьОписаниеЗадачДляПодзадач Тогда
		Описание = ЗадачаСсылка.Описание;		
	КонецЕсли;			
	//}
	
КонецПроцедуры
