﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "СПАРКРиски".
// ОбщийМодуль.СПАРКРискиПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет свойства справочников контрагентов.
// Параметры:
//	СвойстваСправочников - ТаблицаЗначений - в таблице заполняется список
//		справочников контрагентов и их свойства. Колонки таблицы:
//		* Имя - Строка - имя справочника;
//		* Иерархический - Булево - справочник является иерархическим;
//		* РеквизитИНН - Строка- имя реквизита ИНН;
//		* ИмяФормыПодбора - Строка - если для справочника определена собственная
//			форма подбора контрагентов, в этом поле можно указать ее полное имя.
//			Форма должна возвращать в оповещении о выборе Массив ссылок на
//			элементы справочника контрагентов.
//			Если не определена, тогда используется стандартная форма подбора.
//
Процедура ПриОпределенииСвойствСправочниковКонтрагентов(СвойстваСправочников) Экспорт
	
	ОписаниеСправочника = СвойстваСправочников.Добавить();
	ОписаниеСправочника.Иерархический = Истина;
	ОписаниеСправочника.Имя           = "Контрагенты";
	ОписаниеСправочника.РеквизитИНН   = "ИНН";
	
КонецПроцедуры

// В методе заполняется список контрагентов для постановки на мониторинг и для
// снятия с мониторинга.
// Используется регламентным заданием ЗаполнениеКонтрагентовНаМониторингеСПАРКРиски
// и методом программного интерфейса СПАРКРиски.ЗаполнитьКонтрагентовНаМониторинге().
// При получении списком контрагентов можно использовать обращение к регистру сведений
// КонтрагентыНаМониторингеСПАРКРиски: если запись присутствует в регистре сведений,
// то это означает, что контрагент уже поставлен на мониторинг.
// Допускается обращение к регистру сведений КонтрагентыНаМониторингеСПАРКРиски:
// контрагент уже добавлен в список для мониторинга, если в регистре существует
// запись со значениями измерений:
//	- Контрагент = <Текущий контрагент>;
//	- РучноеДобавление = Ложь.
//
// Параметры:
//	ПоставитьНаМониторинг - Массив из ОпределяемыйТипСсылка.КонтрагентБИП - контрагенты для постановки на мониторинг;
//	СнятьСМониторинга - Массив из ОпределяемыйТипСсылка.КонтрагентБИП -  контрагенты для снятия с мониторинга;
//
//@skip-warning
Процедура КонтрагентыДляМониторинга(ПоставитьНаМониторинг, СнятьСМониторинга) Экспорт
	
	// Постановка всех контрагентов в ИБ.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК КонтрагентСсылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтрагентыНаМониторингеСПАРКРиски КАК КонтрагентыНаМониторингеСПАРКРиски
	|		ПО Контрагенты.Ссылка = КонтрагентыНаМониторингеСПАРКРиски.Контрагент
	|ГДЕ
	|	НЕ Контрагенты.ЭтоГруппа
	|	И НЕ Контрагенты.ПометкаУдаления
	|	И Контрагенты.ЮрФизЛицо В (ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ЮрЛицо), ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо),
	|		ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ИндивидуальныйПредприниматель))
	|	И КонтрагентыНаМониторингеСПАРКРиски.Контрагент ЕСТЬ NULL");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ПоставитьНаМониторинг.Добавить(Выборка.КонтрагентСсылка);
	КонецЦикла;
	
КонецПроцедуры

// Определяет параметры отображения отчетов.
//
// Параметры:
//	ПараметрыОтображения - Структура - параметры отображения отчетов.
//		Поля структуры:
//		* ИмяМакетаОформления - Строка - имя макета оформления отчетов,
//			По умолчанию используются стандартный макет оформления.
//
Процедура ПараметрыОтображенияОтчетов(ПараметрыОтображения) Экспорт
	
	ПараметрыОтображения.ИмяМакетаОформления = "Зеленый";
	
КонецПроцедуры

#Область ИндексыСПАРКРиски

// Вызывается из форм, в которые встроен показ индексов 1СПАРК Риски.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма, в которой инициировано событие;
//  КонтрагентОбъект     - Объект, Неопределено - заполняется в том случае, если форма - это форма
//                         элемента справочника, а не форма документа.
//  Контрагент           - ОпределяемыйТип.КонтрагентБИП, Строка - Контрагент или ИНН контрагента;
//  ВидКонтрагента       - ПеречислениеСсылка.ВидыКонтрагентовСПАРКРиски - вид проверки данных контрагента;
//  ПараметрыОтображения - Структура - прочие параметры. Возможные ключи:
//    * ВариантОтображения - Строка - см. описание в СПАРКРиски.ОтобразитьИндексыСПАРК.
//  ИспользованиеРазрешено          - Булево - признак разрешения использования функциональности;
//  СтандартнаяОбработкаБиблиотекой - Булево - в этот параметр возвратить Ложь, если надо запретить
//                                    стандартную обработку события библиотекой.
//
//@skip-warning
Процедура ПриСозданииНаСервере(
		Форма,
		КонтрагентОбъект,
		Контрагент,
		ВидКонтрагента,
		ПараметрыОтображения,
		ИспользованиеРазрешено,
		СтандартнаяОбработкаБиблиотекой) Экспорт

	Если Форма.ИмяФормы = "Справочник.ДокументыПредприятия.Форма.ФормаЭлемента" Тогда
		СтандартнаяОбработкаБиблиотекой = Ложь;
		РезультатИндексыКонтрагента = Форма.ИндексыСПАРКРиски;
		
		ИспользованиеРазрешено = СПАРКРиски.ИспользованиеРазрешено();
		Если ИспользованиеРазрешено Тогда 
			Объект = Форма.Объект;
			Если Форма.ВестиУчетПоКонтрагентам Тогда 
				Если Объект.Контрагенты.Количество() = 1 Тогда 
					РезультатИндексыКонтрагента = СПАРКРиски.ИндексыСПАРККонтрагента(
						Объект.Контрагенты[0].Контрагент,
						ОбщегоНазначенияДокументооборотКлиентСервер.ВидКонтрагентаСПАРК(Объект.Контрагенты[0].Контрагент),
						Истина);
						
				ИначеЕсли Объект.Контрагенты.Количество() > 1 Тогда 
					ИндексыКонтрагента = Новый СписокЗначений;
					Для Каждого СтрокаКонтрагент Из Объект.Контрагенты Цикл 
						ИндексыСПАРККонтрагент = СПАРКРиски.ИндексыСПАРККонтрагента(
							СтрокаКонтрагент.Контрагент,
							ОбщегоНазначенияДокументооборотКлиентСервер.ВидКонтрагентаСПАРК(СтрокаКонтрагент.Контрагент),
							Истина);
						ИндексыКонтрагента.Добавить(ИндексыСПАРККонтрагент);
					КонецЦикла;
						
					РезультатИндексыКонтрагента = ИндексыКонтрагента;
				Иначе 
					РезультатИндексыКонтрагента = СПАРКРиски.ИндексыСПАРККонтрагента(
						Справочники.Контрагенты.ПустаяСсылка(),
						Неопределено,
						Истина);
				КонецЕсли;
				
			ИначеЕсли Форма.ВидДокументаКэш.ВестиУчетСторон Тогда 
				ИндексыКонтрагента = Новый СписокЗначений;
				Для Каждого СтрокаСторона Из Объект.Стороны Цикл 
					Если ТипЗнч(СтрокаСторона.Сторона) <> Тип("СправочникСсылка.Контрагенты") Тогда 
						Продолжить;
					КонецЕсли;
					
					ИндексыСПАРККонтрагент = СПАРКРиски.ИндексыСПАРККонтрагента(
						СтрокаСторона.Сторона,
						ОбщегоНазначенияДокументооборотКлиентСервер.ВидКонтрагентаСПАРК(СтрокаСторона.Сторона),
						Истина);
					ИндексыКонтрагента.Добавить(ИндексыСПАРККонтрагент);
				КонецЦикла;
					
				РезультатИндексыКонтрагента = ИндексыКонтрагента;
			КонецЕсли;
		КонецЕсли;
		
		Форма.ИндексыСПАРКРиски = РезультатИндексыКонтрагента;
		
		СПАРКРискиКлиентСерверПереопределяемый.ОтобразитьИндексыСПАРК(
			РезультатИндексыКонтрагента,
			КонтрагентОбъект,
			Контрагент,
			Форма,
			ИспользованиеРазрешено,
			ПараметрыОтображения,
			СтандартнаяОбработкаБиблиотекой);
			
	КонецЕсли;
	
		
КонецПроцедуры

// Переопределяет время ожидания завершения фонового задания получения индексов СПАРК Риски.
//
// Параметры:
//  ОжидатьЗавершение - Число - значение ключа "ОжидатьЗавершение" для параметра ПараметрыВыполнения.ОжидатьЗавершение
//           процедуры ДлительныеОперации.ВыполнитьВФоне. Если = 0, то не ожидать завершения.
//
//@skip-warning
Процедура ВремяОжиданияФоновогоЗадания(ОжидатьЗавершение) Экспорт


КонецПроцедуры

// Запоминание результатов проверки контрагентов в сервисе СПАРК в дополнительные свойства.
//
// Параметры:
//  Форма			- ФормаКлиентскогоПриложения - Форма документа, в котором выполняется проверка контрагентов.
//  ТекущийОбъект	- ДокументОбъект - документ, запись которого выполняется.
//
Процедура ПередЗаписьюНаСервереДокумент(Форма, ТекущийОбъект) Экспорт
	
	Если Не Форма.ИспользоватьСервисСПАРКРиски Тогда 
		Возврат;
	КонецЕсли;
	
	Если Форма.ИмяФормы = "Справочник.ДокументыПредприятия.Форма.ФормаЭлемента" Тогда
		
		Объект = Форма.Объект;
		Если Форма.ВестиУчетПоКонтрагентам 
			И Объект.Контрагенты.Количество() > 1 Тогда 
			ТекущийОбъект.ДополнительныеСвойства.Вставить("ДанныеПроверкиКонтрагентовСпарк", 
				СоответствиеСпаркИндексовКонтрагентов(Объект.Контрагенты, "Контрагент"));
			
		ИначеЕсли Форма.ВидДокументаКэш.ВестиУчетСторон 
			И Объект.Стороны.Количество() > 1 Тогда 
			ТекущийОбъект.ДополнительныеСвойства.Вставить("ДанныеПроверкиКонтрагентовСпарк", 
				СоответствиеСпаркИндексовКонтрагентов(Объект.Стороны, "Сторона"));
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

// Возвращает соответствие текущих СПАРК индексов по таблице контрагентов.
//
Функция СоответствиеСпаркИндексовКонтрагентов(ТаблицаКонтрагенты, ИмяКолонки)
	
	ИндексыКонтрагента = Новый Соответствие;
	Для Каждого СтрокаКонтрагент Из ТаблицаКонтрагенты Цикл 
		ИндексыСПАРККонтрагент = Новый Структура;
		ИндексыСПАРККонтрагент.Вставить("СводныйИндикатор", СтрокаКонтрагент.СводныйИндикатор);
		ИндексыСПАРККонтрагент.Вставить("ИнформацияСпаркРиски", СтрокаКонтрагент.ИнформацияСпаркРиски);
		ИндексыСПАРККонтрагент.Вставить("ИндексыСПАРКРиски", СтрокаКонтрагент.ИндексыСПАРКРиски);
		
		ИндексыКонтрагента.Вставить(СтрокаКонтрагент[ИмяКолонки], ИндексыСПАРККонтрагент);
	КонецЦикла;
	
	Возврат ИндексыКонтрагента;
	
КонецФункции

// Восстановление результатов проверки контрагентов в сервисе СПАРК в табличной части после записи.
//
// Параметры:
//  Форма			- ФормаКлиентскогоПриложения - Форма документа, в котором выполняется проверка контрагентов.
//  ТекущийОбъект	- ДокументОбъект - документ, запись которого выполняется.
//
Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект) Экспорт
	
	Если Не Форма.ИспользоватьСервисСПАРКРиски Тогда 
		Возврат;
	КонецЕсли;
	
	Если Форма.ИмяФормы = "Справочник.ДокументыПредприятия.Форма.ФормаЭлемента" Тогда
		
		Объект = Форма.Объект; 
		ДанныеКонтрагентов = Неопределено;
		
		Если Форма.ВестиУчетПоКонтрагентам 
			И Объект.Контрагенты.Количество() > 1 Тогда 
			Если ТекущийОбъект.ДополнительныеСвойства.Свойство("ДанныеПроверкиКонтрагентовСпарк", ДанныеКонтрагентов) Тогда
				Для Каждого СтрокаКонтрагент Из Объект.Контрагенты Цикл 
					СохраненныеДанные = ДанныеКонтрагентов.Получить(СтрокаКонтрагент.Контрагент);
					Если СохраненныеДанные <> Неопределено Тогда 
						ЗаполнитьЗначенияСвойств(СтрокаКонтрагент, СохраненныеДанные);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
		ИначеЕсли Форма.ВидДокументаКэш.ВестиУчетСторон 
			И Объект.Стороны.Количество() > 1 Тогда 
			Если ТекущийОбъект.ДополнительныеСвойства.Свойство("ДанныеПроверкиКонтрагентовСпарк", ДанныеКонтрагентов) Тогда
				Для Каждого СтрокаКонтрагент Из Объект.Стороны Цикл 
					СохраненныеДанные = ДанныеКонтрагентов.Получить(СтрокаКонтрагент.Сторона);
					Если СохраненныеДанные <> Неопределено Тогда 
						ЗаполнитьЗначенияСвойств(СтрокаКонтрагент, СохраненныеДанные);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОтчетыСПАКРРиски

// Определяет данные входящего НДС для формирования отчета "Надежность входящего НДС 1СПАРК Риски".
//
// Параметры:
//  МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - менеджер в который должны быть
//                            помещена временная таблица с данными об НДС и именем "ВТ_ДанныеНДС".
//                            Таблица должна содержать поля:
//                              *Контрагент - ОпределяемыйТип.КонтрагентБИП - ссылка на объект контрагента;
//                              *Сумма - Число - общая сумма покупок за переданный период;
//                              *СуммаНДС - Число - общая сумма покупок за переданный период;
//  ПараметрыОтбора - Структура - настройки отбора отчета:
//   *ДатаНачала - Дата - начало периода отчета;
//   *ДатаОкончания - Дата - окончание периода отчета;
//   *Организация - ОпределяемыйТип.Организация, Неопределено - организация для которые необходимо сделать выборку.
//                  Если не заполнено, игнорировать отбор;
//   *Контрагенты - Массив из ОпределяемыйТип.КонтрагентБИП, Неопределено - список контрагентов,
//                  по которым формируется отчет. Если не заполнено, игнорировать отбор;
//  Использование - Булево - если Ложь пользователю будет показана ошибка. Следует использовать в программах
//                  в которых не ведется учет входящего НДС.
//
Процедура ПриФормированииОтчетаНадежностьВходящегоНДС(МенеджерВременныхТаблиц, ПараметрыОтбора, Использование) Экспорт
	
	
КонецПроцедуры

// Определяет данные дебиторской задолженности для формирования отчета "Надежность входящего НДС 1СПАРК Риски".
//
// Параметры:
//  МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - менеджер в который должны быть
//                            помещена временная таблица с данными о задолженности и именем "ВТ_Долги".
//                            Таблица должна содержать поля:
//                              *Раздел - Строка - поле группировки в отчете;
//                              *Контрагент - ОпределяемыйТип.КонтрагентБИП - ссылка на объект контрагента;
//                              *Задолженность - Число - общая сумма задолженности;
//  ПараметрыОтбора - Структура - настройки отбора отчета:
//   *Дата - Дата - дата на которую выполняется выборка данных;
//   *Организация - ОпределяемыйТип.Организация, Неопределено - организация для которые необходимо сделать выборку.
//                  Если не заполнено, игнорировать отбор;
//   *Контрагенты - Массив из ОпределяемыйТип.КонтрагентБИП, Неопределено - список контрагентов,
//                  по которым формируется отчет. Если не заполнено, игнорировать отбор;
//  Использование - Булево - если Ложь пользователю будет показана ошибка. Следует использовать в программах
//                  в которых не ведется учет входящего НДС.
//
Процедура ПриФормированииНадежностьДебиторов(МенеджерВременныхТаблиц, ПараметрыОтбора, Использование) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИБ

// Вызывается при переходе на версию конфигурации с внедренной подсистемой СПАРКРиски.
// Возвращает параметры, необходимые для начального заполнения данных
// в объектах метаданных подсистемы.
//
// Параметры:
//	ПараметрыЗаполнения - Структура - в параметре возвращаются значения для
//		начального заполнения данных подсистемы.
//		Поля структуры:
//		* ЗапросСвойствКонтрагентов - Строка - текст запроса для получения свойств
//			контрагентов, подлежащих проверке в сервисе 1СПАРК Риски: только
//			юридические лица, не являющиеся иностранными.
//			В запросе должны быть определены колонки:
//			** Контрагент - ОпределяемыйТип.КонтрагентБИП - ссылка на элемент
//				справочника контрагентов;
//			** ИНН - Строка - ИНН контрагента;
//			** СвояОрганизация - Булево - признак того, что контрагент является собственным -
//				дочерним по отношению к организации, в которой ведется учет.
//				Свойство может быть использовано для отбора данных в отчетах;
//			Значение по умолчанию: Неопределено.
//			Если значение свойства Неопределено, будет вызвано исключение.
//			Если значение - пустая строка - получение свойств контрагентов
//			не будет выполнено;
//		* ЗаполнитьКонтрагентовНаМониторинге - Булево - провести заполнение
//			списка контрагентов на мониторинге в соответствии с алгоритмом,
//			определенным в методе КонтрагентыДляМониторинга() текущего модуля.
//			Значение по умолчанию: Ложь;
//		* ЗаполнитьИндексыКонтрагентов - Булево - заполнить значения индексов
//			контрагентов. Истина - заполнить, Ложь - не заполнять.
//			Для заполненных индексов значения будут обновлены при следующем
//			обновлении значений индексов по расписанию (в регламентов).
//			Если индексы не заполнены, тогда контрагенты будут добавляться в
//			список индексов "По требованию";
//			Правило заполнения определяется значением поля
//			ЗапросКонтрагентовДляЗаполненияИндексов.
//		* ЗапросКонтрагентовДляЗаполненияИндексов - Строка - текст запроса для
//			получения контрагентов для заполнения индексов. Используется только
//			при ЗаполнитьИндексыКонтрагентов = Истина.
//			Если значение <Пустая строка>, список индексов будет заполнен
//			всеми контрагентами, полученными при выполнении запроса
//			ЗапросСвойствКонтрагентов, иначе - в соответствии с текстом запроса.
//			Значение по умолчанию: <Пустая строка>.
//			В запросе должна быть определена колонка:
//			** Контрагент - ОпределяемыйТип.КонтрагентБИП - ссылка на элемент
//				справочника контрагентов;
//
//@skip-warning
Процедура ПараметрыНачальногоЗаполненияДанных1СПАРКРискиЮридическихЛиц(ПараметрыЗаполнения) Экспорт
	
	ПараметрыЗаполнения.ЗапросСвойствКонтрагентов =
		"ВЫБРАТЬ
		|	Контрагенты.Ссылка КАК Контрагент,
		|	Контрагенты.ИНН КАК ИНН
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	НЕ Контрагенты.ЭтоГруппа
		|	И НЕ Контрагенты.ПометкаУдаления
		|	И Контрагенты.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ЮрЛицо)";
	
	ПараметрыЗаполнения.ЗаполнитьКонтрагентовНаМониторинге = Истина;
	ПараметрыЗаполнения.ЗаполнитьИндексыКонтрагентов       = Истина;
	
КонецПроцедуры

// Вызывается при переходе на версию конфигурации с внедренной подсистемой СПАРКРиски.
// Возвращает параметры, необходимые для начального заполнения данных
// в объектах метаданных подсистемы.
//
// Параметры:
//	ПараметрыЗаполнения - Структура - в параметре возвращаются значения для
//		начального заполнения данных подсистемы.
//		Поля структуры:
//		* ЗапросСвойствКонтрагентов - Строка - текст запроса для получения свойств
//			контрагентов, подлежащих проверке в сервисе 1СПАРК Риски: только
//			индивидуальных предпринимателей, не являющиеся иностранными.
//			В запросе должны быть определены колонки:
//			** Контрагент - ОпределяемыйТип.КонтрагентБИП - ссылка на элемент
//				справочника контрагентов;
//			** ИНН - Строка - ИНН контрагента;
//			** СвояОрганизация - Булево - признак того, что контрагент является собственным -
//				дочерним по отношению к организации, в которой ведется учет.
//				Свойство может быть использовано для отбора данных в отчетах;
//			Значение по умолчанию: Неопределено.
//			Если значение свойства Неопределено, будет вызвано исключение.
//			Если значение - пустая строка - получение свойств контрагентов
//			не будет выполнено;
//		* ЗаполнитьКонтрагентовНаМониторинге - Булево - провести заполнение
//			списка контрагентов на мониторинге в соответствии с алгоритмом,
//			определенным в методе КонтрагентыДляМониторинга() текущего модуля.
//			Значение по умолчанию: Ложь;
//		* ЗаполнитьИндексыКонтрагентов - Булево - заполнить значения индексов
//			контрагентов. Истина - заполнить, Ложь - не заполнять.
//			Для заполненных индексов значения будут обновлены при следующем
//			обновлении значений индексов по расписанию (в регламентов).
//			Если индексы не заполнены, тогда контрагенты будут добавляться в
//			список индексов "По требованию";
//			Правило заполнения определяется значением поля
//			ЗапросКонтрагентовДляЗаполненияИндексов.
//		* ЗапросКонтрагентовДляЗаполненияИндексов - Строка - текст запроса для
//			получения контрагентов для заполнения индексов. Используется только
//			при ЗаполнитьИндексыКонтрагентов = Истина.
//			Если значение <Пустая строка>, список индексов будет заполнен
//			всеми контрагентами, полученными при выполнении запроса
//			ЗапросСвойствКонтрагентов, иначе - в соответствии с текстом запроса.
//			Значение по умолчанию: <Пустая строка>.
//			В запросе должна быть определена колонка:
//			** Контрагент - ОпределяемыйТип.КонтрагентБИП - ссылка на элемент
//				справочника контрагентов;
//
//@skip-warning
Процедура ПараметрыНачальногоЗаполненияДанных1СПАРКРискиИндивидуальныхПредпринимателей(ПараметрыЗаполнения) Экспорт
	
	ПараметрыЗаполнения.ЗапросСвойствКонтрагентов =
		"ВЫБРАТЬ
		|	Контрагенты.Ссылка КАК Контрагент,
		|	Контрагенты.ИНН КАК ИНН
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	НЕ Контрагенты.ЭтоГруппа
		|	И НЕ Контрагенты.ПометкаУдаления
		|	И Контрагенты.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо)";
	
	ПараметрыЗаполнения.ЗаполнитьКонтрагентовНаМониторинге = Истина;
	ПараметрыЗаполнения.ЗаполнитьИндексыКонтрагентов       = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
