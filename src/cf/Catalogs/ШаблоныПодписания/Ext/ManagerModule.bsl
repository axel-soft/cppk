﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ИмяПроцесса(ШаблонСсылка) Экспорт
	
	Возврат "Подписание";
	
КонецФункции

Функция СинонимПроцесса(ИмяПроцесса, РеквизитыШаблона) Экспорт
	
	Возврат Метаданные.БизнесПроцессы[ИмяПроцесса].Синоним;
	
КонецФункции

// Заполняет html обзор данными шаблона процесса.
//
// Параметры:
//   HTMLТекст - Строка
//   Шаблон - СправочникСсылка.ШаблоныСогласования - ссылка на шаблон
//
Процедура ЗаполнитьОбзорШаблона(HTMLТекст, Шаблон) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	РеквизитыШаблона = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Шаблон,
		"КоличествоИтераций,
		|СпособПодписания,
		|Этапы,
		|Участники");
		
	Участники = РеквизитыШаблона.Участники.Выгрузить();
	Этапы = РеквизитыШаблона.Этапы.Выгрузить();
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Если ИспользоватьДатуИВремяВСрокахЗадач Тогда
		ФорматСрока = "ДФ='dd.MM.yyyy HH:mm'";
	Иначе
		ФорматСрока = "ДФ='dd.MM.yyyy'";
	КонецЕсли;
	
	Участники.Колонки.Добавить("НомерУчастника");
	Участники.Колонки.Добавить("НаименованиеЭтапа");
	Участники.Колонки.Добавить("ПорядокВыполненияУчастниками");
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Число"));	
	Участники.Колонки.Добавить("НомерЭтапа", Новый ОписаниеТипов(МассивТипов));
	
	Этапы.Колонки.Добавить("ЧислоУчастников", Новый ОписаниеТипов(МассивТипов));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Булево"));	
	Этапы.Колонки.Добавить("ДобавленВТаблицу", Новый ОписаниеТипов(МассивТипов));
	
	НомерУчастника = 0;
	Для Каждого Исполнитель Из Участники Цикл
		
		Исполнитель.НомерУчастника = НомерУчастника;
		НомерУчастника = НомерУчастника + 1;
		
		ЭтапСтр = Этапы.Найти(Исполнитель.Этап, "Идентификатор");
		Если ЭтапСтр <> Неопределено Тогда
			Исполнитель.НомерЭтапа = Этапы.Индекс(ЭтапСтр) + 1;
			Исполнитель.НаименованиеЭтапа = ЭтапСтр.НаименованиеЭтапа;
			Исполнитель.ПорядокВыполненияУчастниками = ЭтапСтр.ПорядокВыполненияУчастниками;
			
			ЭтапСтр.ЧислоУчастников = ЭтапСтр.ЧислоУчастников + 1;
			
		КонецЕсли;	
		
	КонецЦикла;	
	
	Участники.Сортировать("НомерЭтапа, НомерУчастника");
	
	ОбработкаСрокИсполнения = Неопределено;
	ОбработкаСрокИсполненияДни = 0;
	ОбработкаСрокИсполненияМинуты = 0;
	ОбработкаСрокИсполненияЧасы = 0;
	ВариантУстановкиСрокаИсполнения = Неопределено;
	ОбработкаУчастник = Неопределено;
	
	ЧислоУчастниковПодписантов = 0;
	Для Каждого Исполнитель Из Участники Цикл
		Если Исполнитель.ТочкаМаршрута <> БизнесПроцессы.Подписание.ТочкиМаршрута.ОбработатьРезультат Тогда
			ЧислоУчастниковПодписантов = ЧислоУчастниковПодписантов + 1;
		КонецЕсли;
	КонецЦикла;		
	
	Если ЧислоУчастниковПодписантов > 0 Тогда
		
		HTMLТекст = HTMLТекст + "<p>";
		
		HTMLТекст = HTMLТекст + "<table class=""frame"">";
		
		//Формирование заголовка таблицы
		HTMLТекст = HTMLТекст + "<tr>";
		
		Если Этапы.Количество() <> 0 Тогда
			HTMLТекст = HTMLТекст + "<td align=""left"" class=""frame"">";
			ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Этап'"));
			HTMLТекст = HTMLТекст + "</td>";
		КонецЕсли;
		
		HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"">";
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Участники'"));
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"">";
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Срок'"));
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "</tr>";
		
		НомерШага = 1;
		
		//Заполнение таблицы исполнителями
		Для Каждого Исполнитель Из Участники Цикл
			
			Если Исполнитель.ТочкаМаршрута = БизнесПроцессы.Подписание.ТочкиМаршрута.ОбработатьРезультат Тогда
				
				ОбработкаСрокИсполнения = Исполнитель.СрокИсполнения;
				ОбработкаСрокИсполненияДни = Исполнитель.СрокИсполненияДни;
				ОбработкаСрокИсполненияМинуты = Исполнитель.СрокИсполненияМинуты;
				ОбработкаСрокИсполненияЧасы = Исполнитель.СрокИсполненияЧасы;
				ВариантУстановкиСрокаИсполнения = Исполнитель.ВариантУстановкиСрокаИсполнения;
				ОбработкаУчастник = Исполнитель.Участник;
				
				Продолжить;
				
			КонецЕсли;	
			
			HTMLТекст = HTMLТекст + "<tr>";
			
			Если Этапы.Количество() <> 0 Тогда
				
				ЭтапСтр = Этапы.Найти(Исполнитель.Этап, "Идентификатор");
				Если ЭтапСтр <> Неопределено И ЭтапСтр.ДобавленВТаблицу = Ложь Тогда
					
					ЭтапСтр.ДобавленВТаблицу = Истина;
				
					ПредставлениеЭтапа = "";
					Если ЗначениеЗаполнено(Исполнитель.НаименованиеЭтапа) Тогда
						ПредставлениеЭтапа = Исполнитель.НаименованиеЭтапа
							 + ", " + Строка(Исполнитель.ПорядокВыполненияУчастниками);
					Иначе	
						НомерШага = Исполнитель.НомерЭтапа;
						Если НомерШага = 0 Тогда
							НомерШага = 1;
						КонецЕсли;
						ПредставлениеЭтапа = Строка(НомерШага);
					КонецЕсли;	
					
					HTMLТекст = HTMLТекст 
						+ СтрШаблон("<td align=""left"" class=""frame"" rowspan=%1>", ЭтапСтр.ЧислоУчастников);
					ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, ПредставлениеЭтапа, "");
					HTMLТекст = HTMLТекст + "</td>";
					
				КонецЕсли;
				
			КонецЕсли;
			
			HTMLТекст = HTMLТекст + "<td class=""frame"">";
			Если ЗначениеЗаполнено(Исполнитель.Участник) Тогда
				ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, Исполнитель.Участник, "");
			КонецЕсли;
			HTMLТекст = HTMLТекст + "</td>";
			
			HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"">";
			ПредставлениеСрока = ОбзорПроцессовВызовСервера.ПредставлениеСрокаИсполнения(
				Исполнитель.СрокИсполнения, Исполнитель.СрокИсполненияДни, 
				Исполнитель.СрокИсполненияЧасы, Исполнитель.СрокИсполненияМинуты, 
				ИспользоватьДатуИВремяВСрокахЗадач, Исполнитель.ВариантУстановкиСрокаИсполнения);
				
			ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, ПредставлениеСрока, "");
			HTMLТекст = HTMLТекст + "</td>";
			
			HTMLТекст = HTMLТекст + "</tr>";
		КонецЦикла;
		
		
		HTMLТекст = HTMLТекст + "</table>";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОбработкаУчастник) Тогда
		HTMLТекст = HTMLТекст + "<p>";
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Обрабатывающий результат:'"));
		ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, Строка(ОбработкаУчастник), "");
	КонецЕсли;	
	
	HTMLТекст = HTMLТекст + "<br>";
	
	Если ЗначениеЗаполнено(ОбработкаСрокИсполнения) 
		Или ЗначениеЗаполнено(ОбработкаСрокИсполненияДни) 
		Или ЗначениеЗаполнено(ОбработкаСрокИсполненияМинуты) 
		Или ЗначениеЗаполнено(ОбработкаСрокИсполненияЧасы) Тогда
		
		HTMLТекст = HTMLТекст + "<p>";
		
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Срок обработки результатов:'"));
		
		ПредставлениеСрока = ОбзорПроцессовВызовСервера.ПредставлениеСрокаИсполнения(
			ОбработкаСрокИсполнения, 
			ОбработкаСрокИсполненияДни, 
			ОбработкаСрокИсполненияЧасы, 
			ОбработкаСрокИсполненияМинуты, 
			ИспользоватьДатуИВремяВСрокахЗадач, 
			ВариантУстановкиСрокаИсполнения);
		
		ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, ПредставлениеСрока, "");
		
	КонецЕсли;
	
	ДлительностьПроцесса = СрокиИсполненияПроцессов.ДлительностьИсполненияПроцесса(Шаблон);
	
	Если ЗначениеЗаполнено(ДлительностьПроцесса.СрокИсполненияПроцессаДни)
		Или ЗначениеЗаполнено(ДлительностьПроцесса.СрокИсполненияПроцессаЧасы)
		Или ЗначениеЗаполнено(ДлительностьПроцесса.СрокИсполненияПроцессаМинуты) Тогда
		
		HTMLТекст = HTMLТекст + "<p>";
		
		ПредставлениеДлительности = СрокиИсполненияПроцессовКлиентСервер.ПредставлениеДлительности(
			ДлительностьПроцесса.СрокИсполненияПроцессаДни,
			ДлительностьПроцесса.СрокИсполненияПроцессаЧасы,
			ДлительностьПроцесса.СрокИсполненияПроцессаМинуты);
		
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Срок процесса:'"));
		ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, ПредставлениеДлительности, "");
		
		Если РеквизитыШаблона.КоличествоИтераций <> 0 Тогда
			
			HTMLТекст = HTMLТекст + " (";
			
			ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Кол. циклов:'"));
			ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, 
				Формат(РеквизитыШаблона.КоличествоИтераций, "ЧЦ=2"), "");
			
			HTMLТекст = HTMLТекст + ")";
			
		КонецЕсли;		
		
	КонецЕсли;
	
	HTMLТекст = HTMLТекст + "<p>";
	ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Способ подписания:'"));
	ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, Строка(РеквизитыШаблона.СпособПодписания), "");
	
КонецПроцедуры

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт



КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат 
		"Ответственный,
		|Ссылка,
		|ЭтоГруппа,
		|ШаблонВКомплексномПроцессе,
		|ВладелецШаблона,
		|КомплексныйПроцесс";
	
КонецФункции

// Проверяет наличие метода.
// 
Функция ЕстьМетодЗаполнитьДескрипторыОбъекта() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет переданную таблицу дескрипторов объекта.
// 
Процедура ЗаполнитьДескрипторыОбъекта(ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав = Неопределено) Экспорт
	
	ШаблоныБизнесПроцессов.ЗаполнитьДескрипторыОбъекта(
		ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_Предметы

// Возвращает участников для проверки прав на предметы.
//
// Параметры:
//  Шаблон - СправочникОбъект.ШаблоныПодписания, СправочникСсылка.ШаблоныПодписания - шаблон
//
// Возвращаемое значение:
//  ТаблицаЗначений
//   * Участник
//   * Изменение
//
Функция УчастникиДляПроверкиПрав(Шаблон) Экспорт
	
	ТаблицаУчастников = РаботаСРабочимиГруппами.ПолучитьПустуюТаблицуУчастников();
	
	РаботаСБизнесПроцессами.ДобавитьУчастниковПодписанияВТаблицу(ТаблицаУчастников, Шаблон);
	
	Возврат ТаблицаУчастников;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс_ПоддержкаКомплексныхПроцессов

// Возвращает реквизиты, которые используются для определения значений
// вычисляемых полей комплексного процесса.
//
// Параметры:
//  Процесс - СправочникСсылка.ШаблоныПодписания - ссылка на шаблон
//
// Возвращаемое значение:
//  Структура
//
Функция РеквизитыЭтапаДляВычисляемыхПолей(Процесс) Экспорт
	
	РеквизитыСтрокой = 
		"НаименованиеБизнесПроцесса,
		|ИсходныйШаблон,
		|Описание,
		|Важность,
		|Этапы,
		|Участники,
		|СрокОтложенногоСтарта";
	
	РеквизитыПроцесса = ОбщегоНазначенияДокументооборот.
		ЗначенияРеквизитовОбъектаВПривилегированномРежиме(Процесс, РеквизитыСтрокой);
		
	РеквизитыПроцесса.Этапы = РеквизитыПроцесса.Этапы.Выгрузить();
	РеквизитыПроцесса.Участники = РеквизитыПроцесса.Участники.Выгрузить();
	
	Возврат РеквизитыПроцесса;
	
КонецФункции

// Получает строковое представление исполнителей шаблона процесса
//
// Параметры:
//  РеквизитыПроцесса - Струкута - см. РеквизитыЭтапаДляВычисляемыхПолей
//
// Возаращаемое значение:
//  Строка
//
Функция ПолучитьСтроковоеПредставлениеИсполнителей(РеквизитыПроцесса) Экспорт
	
	Результат = "";
	
	ТочкиМаршрута = БизнесПроцессы.Подписание.ТочкиМаршрута;
	
	Разделитель = "";
	Для Каждого СтрокаУчастника Из РеквизитыПроцесса.Участники Цикл
		
		Если СтрокаУчастника.ТочкаМаршрута <> ТочкиМаршрута.Подписать
			И СтрокаУчастника.ТочкаМаршрута <> ТочкиМаршрута.ОбеспечитьПодписание Тогда
			
			Продолжить
		КонецЕсли;
		
		Результат = Результат
			+ Разделитель
			+ СтрокаУчастника.Участник;
		Разделитель = ", ";
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#Область КэшДанныхДействий

// Возвращает выборку данных действий.
//
// Параметры:
//  ТаблицаДействий - ТаблицаЗначений
//   * Действие - ОпределяемыйТип.ШаблонДействияКомплексногоПроцесса
//
// Возвращаемое значение:
//  ВыборкаДанных
//
Функция ВыборкаДанныхДействий(ТаблицаДействий) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДействий.Действие
		|ПОМЕСТИТЬ ТаблицаДействий
		|ИЗ
		|	&ТаблицаДействий КАК ТаблицаДействий
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ШаблоныПодписания.Ссылка,
		|	ШаблоныПодписания.Наименование,
		|	ШаблоныПодписания.Этапы,
		|	ШаблоныПодписания.Участники,
		|	ШаблоныПодписания.КоличествоИтераций,
		|	ШаблоныПодписания.СрокИсполненияПроцесса
		|ИЗ
		|	ТаблицаДействий КАК ТаблицаДействий
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ШаблоныПодписания КАК ШаблоныПодписания
		|		ПО ТаблицаДействий.Действие = ШаблоныПодписания.Ссылка";
		
	Запрос.УстановитьПараметр("ТаблицаДействий", ТаблицаДействий);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

// Возвращает данные процесса, являющегося действием комплексного процесса.
//
// Параметры:
//  Объект - СправочникСсылка.ШаблоныИсполнения, ВыборкаДанных
//
// Возвращаемое значение:
//  Структура - см. функцию РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.СтруктураДанныхДействия
//
Функция ДанныеДействия(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеПроцесса = РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.СтруктураДанныхДействия();
	
	ТипОбъект = ТипЗнч(Объект);
	
	РеквизитыОбъектаСтрокой = "
		|Ссылка,
		|Наименование,
		|СпособПодписания,
		|Этапы,
		|Участники,
		|КоличествоИтераций,
		|СрокИсполненияПроцесса";
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипОбъект) Тогда
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект, РеквизитыОбъектаСтрокой);
		РеквизитыОбъекта.Этапы = РеквизитыОбъекта.Этапы.Выгрузить();
		РеквизитыОбъекта.Участники = РеквизитыОбъекта.Участники.Выгрузить();
	ИначеЕсли ТипОбъект = Тип("ВыборкаИзРезультатаЗапроса") Тогда
		РеквизитыОбъекта = Новый Структура(РеквизитыОбъектаСтрокой);
		ЗаполнитьЗначенияСвойств(РеквизитыОбъекта, Объект,, "Этапы, Участники");
		РеквизитыОбъекта.Этапы = Объект.Этапы.Выгрузить();
		РеквизитыОбъекта.Участники = Объект.Участники.Выгрузить();
	Иначе
		РеквизитыОбъекта = Объект;
	КонецЕсли;
	
	ДанныеПроцесса.Описание = НСтр("ru = 'Подписание: '") + РеквизитыОбъекта.Наименование;
	
	ДанныеПроцесса.СрокИсполненияПроцесса = РеквизитыОбъекта.СрокИсполненияПроцесса;
	
	ДлительностьИсполнения = СрокиИсполненияПроцессов.ДлительностьИсполненияПроцесса(РеквизитыОбъекта);
	ЗаполнитьЗначенияСвойств(ДанныеПроцесса, ДлительностьИсполнения);
	
	ТочкиМаршрута = БизнесПроцессы.Подписание.ТочкиМаршрута;
	
	МассивИсполнителей = Новый Массив;
	Для Каждого СтрокаУчастника Из РеквизитыОбъекта.Участники Цикл
		
		Если СтрокаУчастника.ТочкаМаршрута <> ТочкиМаршрута.Подписать
			И СтрокаУчастника.ТочкаМаршрута <> ТочкиМаршрута.ОбеспечитьПодписание Тогда
			
			Продолжить
		КонецЕсли;
		
		РаботаСКомплекснымиБизнесПроцессамиСервер.ДобавитьИсполнителяПроцессаВМассив(
			МассивИсполнителей, СтрокаУчастника.Участник);
	КонецЦикла;
	
	ДанныеПроцесса.Исполнители = 
		РаботаСКомплекснымиБизнесПроцессамиСервер.ИсполнителиСтрокой(МассивИсполнителей);
	
	Возврат ДанныеПроцесса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ПрограммныйИнтерфейс_Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ВыбраннаяФорма = "Справочник.ШаблоныПодписания.Форма.ФормаЭлемента";
		
		Если Не Параметры.Свойство("ВладелецШаблона") И Параметры.Свойство("Ключ") Тогда
			ВладелецШаблона = ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
				Параметры.Ключ, "ВладелецШаблона");
				
			Если (ТипЗнч(ВладелецШаблона) = Тип("СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов")
					Или ТипЗнч(ВладелецШаблона) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс")) Тогда
				
				Параметры.Вставить("ВладелецШаблона", ВладелецШаблона);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ВидФормы = "ФормаВыбора" Тогда
		
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ОбщаяФорма.ВыборШаблонаБизнесПроцесса";
		Параметры.Вставить("ТипШаблона", "Подписание");
		ИзменятьСоставСтрок = БизнесПроцессы[ИмяПроцесса(Неопределено)].МожетЗапускатьсяИнтерактивно();
		Параметры.Вставить("ИзменятьСоставСтрок", ИзменятьСоставСтрок);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли