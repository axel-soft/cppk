﻿////////////////////////////////////////////////////////////////////////////////
// Работа с HTML.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает ссылку в поле HTML документа.
//
// Параметры:
//  Элемент - ПолеФормы - Элемент
//  ДанныеСобытия - Структура - Данные события.
//  СтандартнаяОбработка - Булево - Стандартная обработка.
//  Форма - ФормаКлиентскогоПриложения
//
Процедура ОткрытьСсылку(Элемент, ДанныеСобытия, СтандартнаяОбработка, Форма) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ВыбраннаяСсылка = Неопределено;
	Если ДанныеСобытия.Href <> Неопределено Тогда
		// Если у данных события заполнено свойство Href - будем считать что переход будет по этой ссылке.
		ВыбраннаяСсылка = ДанныеСобытия.Href;
	Иначе
		Попытка
			// Если у элемента события заполнено свойство Href и элемент AREA - будем считать что переход будет по этой ссылке.
			Если ВРег(ДанныеСобытия.Element.tagName) = "AREA" Тогда
				ВыбраннаяСсылка = ДанныеСобытия.Element.Href;
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	Если ПустаяСтрока(ВыбраннаяСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПерейтиПоВстроеннойСсылке(Элемент.Документ, ВыбраннаяСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	СхемаСсылки = ОпределитьСхемуСсылки(ВыбраннаяСсылка);
	
	Если СхемаСсылки = "v8doc:" Тогда
		
		ОбработатьСсылку1СДокументооборота(ВыбраннаяСсылка, Форма);
		
	ИначеЕсли СхемаСсылки = "e1c://" Тогда
		
		Если СтрНайти(ВыбраннаяСсылка, "Справочник.Файлы")
			И Форма <> Неопределено Тогда
			
			Файл = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(ВыбраннаяСсылка);
			Если ЗначениеЗаполнено(Файл) Тогда
				РаботаСФайламиКлиент.ОткрытьФайлДокумента(Файл, Форма);
				Возврат;
			КонецЕсли; 	
			
		КонецЕсли; 	
		
		ПерейтиПоНавигационнойСсылке(ВыбраннаяСсылка);
		
	ИначеЕсли (СхемаСсылки = "http://" И Найти(ВыбраннаяСсылка, "e1cib") > 0)
		ИЛИ (СхемаСсылки = "https://" И Найти(ВыбраннаяСсылка, "e1cib") > 0) Тогда
		
		Если Не ПерейтиПоВнутреннейНавигационнойСсылке(ВыбраннаяСсылка) Тогда
			ПерейтиПоНавигационнойСсылке(ВыбраннаяСсылка);
		КонецЕсли;
		
	ИначеЕсли СхемаСсылки = "http://"
		Или СхемаСсылки = "https://"
		Или СхемаСсылки = "ftp://"
		Или СхемаСсылки = "file://" Тогда
		
		#Если ВебКлиент Тогда
		ПерейтиПоНавигационнойСсылке(ВыбраннаяСсылка);
		#Иначе
		ЗапуститьПриложение(ВыбраннаяСсылка);
		#КонецЕсли
		
	Иначе
		
		ПерейтиПоНавигационнойСсылке(ВыбраннаяСсылка);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет попытку перехода по ссылке, встроенной в HTML документ.
//
// Параметры:
//  HTMLДокумент    - ВнешнийОбъект - Поле HTML документа.
//  ВыбраннаяСсылка - Строка        - Выбранная ссылка.
// 
// Возвращаемое значение:
//  Булево - Выполнен переход по встроенной в HTML документ ссылке.
//
Функция ПерейтиПоВстроеннойСсылке(HTMLДокумент, ВыбраннаяСсылка) Экспорт
	
	Попытка
		
		ПозицияРазделителя = СтрНайти(ВыбраннаяСсылка, "#");
		АдресБазы = ПолучитьНавигационнуюСсылкуИнформационнойБазы();
		
		Если ПозицияРазделителя = 1
			Или (ПозицияРазделителя <> 0
				И СтрНайти(ВыбраннаяСсылка, АдресБазы) = 1)
			Или (ПозицияРазделителя <> 0
				И СтрНайти(ВыбраннаяСсылка, "%") <> 0
				И СтрНайти(ВыбраннаяСсылка, РаботаС_HTMLВызовСервера.КодироватьСсылку(АдресБазы)) = 1) Тогда
			
			TargetHref = Сред(ВыбраннаяСсылка, ПозицияРазделителя + 1);
			TargetElement = HTMLДокумент.getElementById(TargetHref);
			Если TargetElement = Неопределено Тогда
				
				ElementsByName = HTMLДокумент.getElementsByName(TargetHref);
				Если ElementsByName.length > 0 Тогда
					TargetElement = ElementsByName["0"];
				КонецЕсли;
				
			КонецЕсли;
			
			Если TargetElement <> Неопределено Тогда
				TargetElement.scrollIntoView(true);
				Возврат Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		// В некоторых случаях что-то могло пойти не так, например на Mac.
	КонецПопытки;
	
	Возврат Ложь;
	
КонецФункции

// Обрабатывает ссылку 1С:Документооборота.
//
// Параметры:
//  Ссылка1СДокументооборота - Строка - Обрабатываемая ссылка.
//  Форма - ФормаКлиентскогоПриложения
//
Процедура ОбработатьСсылку1СДокументооборота(Ссылка1СДокументооборота, Форма = Неопределено) Экспорт
	
	СхемаСсылок1СДокументооборота = "v8doc:";
	
	Если  ОпределитьСхемуСсылки(Ссылка1СДокументооборота) <> СхемаСсылок1СДокументооборота Тогда
		Возврат;
	КонецЕсли;
	
	Ссылка1СДокументооборотаБезСхемы =
		Сред(Ссылка1СДокументооборота, СтрДлина(СхемаСсылок1СДокументооборота) + 1);
	
	ОбработатьСсылку1СДокументооборотаБезСхемы(Ссылка1СДокументооборотаБезСхемы, Форма);
	
КонецПроцедуры

// Обрабатывает ссылку 1С:Документооборота без схемы.
//
// Параметры:
//  Ссылка1СДокументооборота - Строка - Обрабатываемая ссылка.
//  Форма - ФормаКлиентскогоПриложения.
//  БазоваяНавигационнаяСсылка - Строка
//
Процедура ОбработатьСсылку1СДокументооборотаБезСхемы(Ссылка1СДокументооборота, Форма = Неопределено,
		БазоваяНавигационнаяСсылка = "") Экспорт
	
	ТипСсылки = ОпределитьТипСсылки1СДокументооборота(Ссылка1СДокументооборота);
	
	Если ТипСсылки = "e1cib/" Или ТипСсылки = "e1ccs/" Тогда
		
		Если СтрНайти(Ссылка1СДокументооборота, "Справочник.Файлы")
			И Форма <> Неопределено Тогда
			
			Файл = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если ЗначениеЗаполнено(Файл) Тогда
				РаботаСФайламиКлиент.ОткрытьФайлДокумента(Файл, Форма);
				Возврат;
			КонецЕсли; 	
			
		КонецЕсли; 	
		
		ПерейтиПоНавигационнойСсылке(Ссылка1СДокументооборота);
		
	ИначеЕсли ТипСсылки = "tasks/" Тогда
		
		Если СтрНайти(Ссылка1СДокументооборота, "ShowCancellationReason") Тогда
			
			Задача = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если Не ЗначениеЗаполнено(Задача) Тогда
				Возврат;
			КонецЕсли;
			
			РаботаСЗадачамиКлиент.ПоказатьПричинуОтмены(Задача);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowProcessRollbackReason") Тогда
			
			ПричинаОтменыВыполнения = Сред(
				Ссылка1СДокументооборота,
				СтрДлина("tasks/ShowProcessRollbackReason/") + 1);
			ПричинаОтменыВыполнения = РаботаС_HTMLВызовСервера.РаскодироватьСсылку(ПричинаОтменыВыполнения);
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Ошибка при выполнении задачи'"));
			ПараметрыФормы.Вставить("ТекстСообщения", ПричинаОтменыВыполнения);
			ОткрытьФорму("ОбщаяФорма.Сообщение", ПараметрыФормы);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ChangeDueDate") Тогда
			
			Задача = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если Не ЗначениеЗаполнено(Задача) Тогда
				Возврат;
			КонецЕсли;
			
			РаботаСЗадачамиКлиент.СогласоватьПереносСрока(Задача);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowPerformanceHistory") Тогда
			
			Задача = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если Не ЗначениеЗаполнено(Задача) Тогда
				Возврат;
			КонецЕсли;
			
			ПараметрыФормы = Новый Структура("ЗадачаСсылка", Задача);
			ОткрытьФорму("БизнесПроцесс.Исполнение.Форма.ФормаИсторияИсполнения", ПараметрыФормы);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowInvitationHistory") Тогда
			
			Задача = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если Не ЗначениеЗаполнено(Задача) Тогда
				Возврат;
			КонецЕсли;
			
			ПараметрыФормы = Новый Структура("ЗадачаСсылка", Задача);
			ОткрытьФорму("БизнесПроцесс.Приглашение.Форма.ФормаИсторияПриглашения", ПараметрыФормы);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowSigningHistory") Тогда
			
			Задача = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если Не ЗначениеЗаполнено(Задача) Тогда
				Возврат;
			КонецЕсли;
			
			ПараметрыФормы = Новый Структура("ЗадачаСсылка", Задача);
			ОткрытьФорму("БизнесПроцесс.Подписание.Форма.ФормаИсторияПодписания", ПараметрыФормы);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowRegistrationHistory") Тогда
			
			Задача = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если Не ЗначениеЗаполнено(Задача) Тогда
				Возврат;
			КонецЕсли;
			
			ПараметрыФормы = Новый Структура("ЗадачаСсылка", Задача);
			ОткрытьФорму("БизнесПроцесс.Регистрация.Форма.ФормаИсторияРегистрации", ПараметрыФормы);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowReconciliationHistory") Тогда
			
			Задача = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если Не ЗначениеЗаполнено(Задача) Тогда
				Возврат;
			КонецЕсли;
			
			ПараметрыФормы = Новый Структура("ЗадачаСсылка", Задача);
			ОткрытьФорму("БизнесПроцесс.Согласование.Форма.ФормаИсторияСогласования", ПараметрыФормы);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowConfirmationHistory") Тогда
			
			Задача = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если Не ЗначениеЗаполнено(Задача) Тогда
				Возврат;
			КонецЕсли;
			
			ПараметрыФормы = Новый Структура("ЗадачаСсылка", Задача);
			ОткрытьФорму("БизнесПроцесс.Утверждение.Форма.ФормаИсторияУтверждения", ПараметрыФормы);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowApprovalSheet") Тогда // лист согласования
			
			Документ = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если Не ЗначениеЗаполнено(Документ) Тогда
				Возврат;
			КонецЕсли;
			
			МассивДокументов = Новый Массив;
			МассивДокументов.Добавить(Документ);
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.ДокументыПредприятия",
				"ЛистСогласования",
				МассивДокументов,
				Форма);

		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ListOfDisagreements") Тогда // протокол разногласий
			
			Документ = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если Не ЗначениеЗаполнено(Документ) Тогда
				Возврат;
			КонецЕсли;
			
			МассивДокументов = Новый Массив;
			МассивДокументов.Добавить(Документ);
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.ДокументыПредприятия",
				"ПротоколРазногласий",
				МассивДокументов,
				Форма);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowCorrespondence") Тогда
			
			ОбзорЗадачКлиент.ОткрытьПереписку(Ссылка1СДокументооборота);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowLinks") Тогда
			
			ОбзорСпискаДокументовКлиент.ПоказатьСвязи(Ссылка1СДокументооборота);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "goods") Тогда
			
			ОбзорЗадачКлиент.ОткрытьПредметСТоварами(Ссылка1СДокументооборота);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowHistory") Тогда
			
			Задача = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если Не ЗначениеЗаполнено(Задача) Тогда
				Возврат;
			КонецЕсли;
			
			РаботаСЗадачамиКлиент.ПоказатьИсториюВыполнения(Задача);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowFile") Тогда
			
			СсылкаПоНавигационной = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если Не ЗначениеЗаполнено(СсылкаПоНавигационной) Тогда
				Возврат;
			КонецЕсли;
			
			Файл = Неопределено;
			ВерсияФайла = Неопределено;
			Если ТипЗнч(СсылкаПоНавигационной) = Тип("СправочникСсылка.Файлы") Тогда
				
				Файл = СсылкаПоНавигационной;
				
			ИначеЕсли ТипЗнч(СсылкаПоНавигационной) = Тип("СправочникСсылка.ВерсииФайлов") Тогда
				
				ВерсияФайла = СсылкаПоНавигационной;
				
			Иначе
				
				ВызватьИсключение СтрШаблон(
					НСтр("ru = 'Неизвестный тип навигационной ссылки %1 (%2).'"),
					СсылкаПоНавигационной,
					ТипЗнч(СсылкаПоНавигационной));
				
			КонецЕсли;
			
			ИдентификаторФормы =
				?(Форма <> Неопределено, Форма.УникальныйИдентификатор, Неопределено);
			
			ДанныеФайлаДляОткрытия = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(
				Файл,
				ВерсияФайла,
				ИдентификаторФормы);
			
			РаботаСФайламиКлиент.Открыть(
				ДанныеФайлаДляОткрытия,
				ИдентификаторФормы);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowTaskAction") Тогда
			
			ЗадачаИлиДействиеЗадачи = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если Не ЗначениеЗаполнено(ЗадачаИлиДействиеЗадачи) Тогда
				Возврат;
			КонецЕсли;
			
			РаботаСЗадачамиКлиент.ОткрытьКарточкуЗадачи(ЗадачаИлиДействиеЗадачи);
		
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowInReplyTo") Тогда
			
			Если Форма <> Неопределено И Форма.ИмяФормы = "Справочник.ДокументыПредприятия.Форма.ФормаЭлемента" Тогда
				Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаОсновные;
			Иначе
				ОбзорСпискаДокументовКлиент.ПоказатьСвязи(Ссылка1СДокументооборота, Ложь, Истина);
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ТипСсылки = "files/" Тогда
		
		Если СтрНайти(Ссылка1СДокументооборота, "Recognize") Тогда
			
			Файл = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если ЗначениеЗаполнено(Файл) Тогда
				
				Расширение = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Файл,
					"ТекущаяВерсияРасширение");
				Обработчик = Новый ОписаниеОповещения("ПослеРаспознавания", ЭтотОбъект, Файл);
				
				Если ТаймлистКлиентСервер.ЭтоРасширениеФайлаТаймлист(Расширение) Тогда
					
					ОповещениеОЗакрытииФормыТаймлист = Новый ОписаниеОповещения("ПослеУказанияКоличестваСпикеров", ЭтотОбъект,
						Обработчик);
					
					ТаймлистКлиент.НачатьРасшифровку(Форма, Файл, ОповещениеОЗакрытииФормыТаймлист);
					
				Иначе
					
					КомандыРаботыСФайламиКлиент.РаспознатьФайлСОповещением(Обработчик, Файл);
					
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "GetAutoprotocol") Тогда
			
			Файл = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если ЗначениеЗаполнено(Файл) Тогда
				СписокОтбора = Новый СписокЗначений;
				Если ДелопроизводствоКлиентСервер.ЭтоФормаМероприятия(Форма.ИмяФормы) Тогда
					Для Каждого СтрокаУчастник Из Форма.Участники Цикл
						Если ЗначениеЗаполнено(СтрокаУчастник.Исполнитель) Тогда
							СписокОтбора.Добавить(СтрокаУчастник.Исполнитель);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				
				Оповещение = Новый ОписаниеОповещения("НачатьПолучениеАвтопротокола", Форма, Файл);
				
				ТаймлистКлиент.НачатьПолучениеАвтопротокола(Форма, Файл, Оповещение, СписокОтбора);
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ТипСсылки = "events/" Тогда
		
		Если СтрНайти(Ссылка1СДокументооборота, "ShowStatus") Тогда
			
			Мероприятие = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			УправлениеМероприятиямиКлиент.ПоказатьСостояниеМероприятия(Мероприятие);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowProgramPoint") Тогда
			
			Мероприятие = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			
			РазделеннаяСсылка = СтрРазделить(Ссылка1СДокументооборота, "/");
			НомерПункта = Число(РазделеннаяСсылка[2]);
			
			УправлениеМероприятиямиКлиент.ПоказатьПунктПрограммы(Мероприятие, НомерПункта);
			
		КонецЕсли;
		
	ИначеЕсли ТипСсылки = "MXLDetails/" Тогда
		
		Если СтрНайти(Ссылка1СДокументооборота, "ShowApprovedFileVersions") Тогда
			
			РаботаСВизамиСогласованияКлиент.ОткрытьВерсииСогласованныхФайловПоСсылке(Ссылка1СДокументооборота, Форма);
			
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowFamiliarizationFileVersions") Тогда
			
			ДанныеОзнакомленияПодПодпись = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			Если Не ЗначениеЗаполнено(ДанныеОзнакомленияПодПодпись) Тогда
				Возврат;
			КонецЕсли;
			
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("Ключ", ДанныеОзнакомленияПодПодпись);
			
			ОткрытьФорму("Справочник.ДанныеОзнакомленияПодПодпись.Форма.ВерсииФайловОзнакомления",
				ПараметрыОткрытия, Форма); 
				
		ИначеЕсли СтрНайти(Ссылка1СДокументооборота, "ShowESRecord") Тогда
			
			ИдентификаторПодписиСтрока = Сред(Ссылка1СДокументооборота, 
				СтрНайти(Ссылка1СДокументооборота, "/", НаправлениеПоиска.СКонца) + 1);
			
			ИдентификаторПодписи = Новый УникальныйИдентификатор(ИдентификаторПодписиСтрока);
			ОткрытьФорму("РегистрСведений.ЭлектронныеПодписи.ФормаЗаписи", 
				Новый Структура("ИдентификаторПодписи", ИдентификаторПодписи));
			
		КонецЕсли;
		
	ИначеЕсли ТипСсылки = "processing/" Тогда
		
		Если СтрНайти(Ссылка1СДокументооборота, "ShowAction") Тогда
			
			ДействиеОбработки = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			
			ИмяСправочника = ДействияКлиент.ИмяСправочникаПоДействию(ДействиеОбработки);
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Ключ", ДействиеОбработки);
			ПараметрыФормы.Вставить("ОткрытьКарточкуДействия", Истина);
			
			ИмяФормыОбъекта = СтрШаблон("Справочник.%1.ФормаОбъекта", ИмяСправочника);
			
			ОткрытьФорму(ИмяФормыОбъекта, ПараметрыФормы, Форма);
			
		КонецЕсли;
		
	ИначеЕсли ТипСсылки = "employees/" Тогда
		
		Если СтрНайти(Ссылка1СДокументооборота, "AddPhoto") Тогда
			
			Сотрудник = РаботаС_HTMLВызовСервера.СсылкаПоНавигационной(Ссылка1СДокументооборота);
			
			ПраваПоОбъекту = ДокументооборотПраваДоступа.ПраваПользователяПоОбъекту(
				Сотрудник,
				ПользователиКлиент.ТекущийПользователь());
			
			Если Не ПраваПоОбъекту.Изменение Тогда
				ПоказатьПредупреждение(, НСтр("ru = 'Нет прав на изменение контакта.'"));
				Возврат;
			КонецЕсли;
			
			ИдентификаторФормы =
				?(Форма <> Неопределено, Форма.УникальныйИдентификатор, Неопределено);
			
			ПараметрыОписания = Новый Структура;
			ПараметрыОписания.Вставить("АдресВременногоХранилищаФайла", "");
			ПараметрыОписания.Вставить("ИдентификаторФормы", ИдентификаторФормы);
			ПараметрыОписания.Вставить("Сотрудник", Сотрудник);
			
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"ПослеВыбораФотографии",
				ЭтотОбъект,
				ПараметрыОписания);
			
			ФайловыеФункцииКлиент.ВыбратьКартинкуИПоместитьВХранилище(
				ОписаниеОповещения,
				ИдентификаторФормы);
			
		КонецЕсли;
	
	ИначеЕсли ТипСсылки = "share/" Тогда
		
		СсылкаДляСкачиванияДокумента = Ссылка1СДокументооборота;
		Если Не СтрНачинаетсяС(Ссылка1СДокументооборота, БазоваяНавигационнаяСсылка) Тогда
			СсылкаДляСкачиванияДокумента = СтрШаблон("%1%2", БазоваяНавигационнаяСсылка,
				Ссылка1СДокументооборота);
		КонецЕсли;
				
		Отказ = Ложь;
		ОписаниеОшибки = "";
		РезультатПоиска = ИнтеграцияShareДокументооборотВызовСервера.РезультатПоискаДокументаПоПубличнойСсылке(
			СсылкаДляСкачиванияДокумента, Отказ, ОписаниеОшибки);
		Если РезультатПоиска = Неопределено Тогда
			Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
				ИнтеграцияShareДокументооборотКлиент.ВывестиОписаниеОшибкиЗагрузки(ОписаниеОшибки,
					НСтр("ru = 'Ошибка поиска документа по ссылке.'"));
			КонецЕсли;	
			Возврат;
		КонецЕсли;
		
		ОписаниеЭлектронногоДокумента = РезультатПоиска.ОписаниеЭлектронногоДокумента;
		Если ОписаниеЭлектронногоДокумента = Неопределено Или Отказ Или ЗначениеЗаполнено(ОписаниеОшибки) Тогда
			Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
				ИнтеграцияShareДокументооборотКлиент.ВывестиОписаниеОшибкиЗагрузки(ОписаниеОшибки,
					НСтр("ru = 'Ошибка поиска документа по ссылке.'"));
			КонецЕсли;	
			Возврат;
		КонецЕсли;
		
		СсылкаНаОбъект = Неопределено;
		ПараметрыОтраженияВУчете = РезультатПоиска.НастройкиЗагрузки.ПараметрыОтраженияВУчете;
		Если ПараметрыОтраженияВУчете.Количество() > 0 Тогда
			СсылкаНаОбъект = ПараметрыОтраженияВУчете[0].СсылкаНаОбъектУчетаВБазе;
		КонецЕсли;
		Если ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
			Если ОбщегоНазначенияСлужебныйКлиент.ЭтоНавигационнаяСсылка(СсылкаНаОбъект) Тогда
				ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(СсылкаНаОбъект);
			Иначе
				ПоказатьЗначение(, СсылкаНаОбъект);			
			КонецЕсли;
			Возврат;	
		КонецЕсли;		
		
		Форма = ОткрытьФорму("Обработка.СервисShare.Форма.ЗагрузитьДокументПоСсылке");
		Форма.Заголовок = НСтр("ru = 'Загрузка документа из 1С:Share'");
		Форма.СсылкаДляСкачиванияДокумента = СсылкаДляСкачиванияДокумента;
		ЭлементыФормы = Форма.Элементы;
		ЭлементыФормы.СтраницыФормы.ТекущаяСтраница = ЭлементыФормы.СтраницаОжидания;
		
		Оповещение = Новый ОписаниеОповещения("ОбработатьРезультатПоискаДокументаПоПубличнойССылке", Форма);
		ИнтеграцияShareКлиент.ЗагрузитьЭлектронныйДокументПоИдентификаторуВФоне(ОписаниеЭлектронногоДокумента,
			Оповещение, Форма);
			
	КонецЕсли;
	
КонецПроцедуры

// Определяет тип ссылки 1С:Документооборота.
//
// Параметры:
//  Ссылка - Строка - Ссылка.
// 
// Возвращаемое значение:
//  Строка - Тип ссылки.
//
Функция ОпределитьТипСсылки1СДокументооборота(Знач Ссылка) Экспорт
	
	Ссылка = НРег(Ссылка);
	Если СтрНачинаетсяС(Ссылка, "e1cib/") Тогда
		
		Возврат "e1cib/";
		
	ИначеЕсли СтрНачинаетсяС(Ссылка, "e1ccs/") Тогда
		
		Возврат "e1ccs/"
		
	ИначеЕсли СтрНачинаетсяС(Ссылка, "mail/") Тогда
		
		Возврат "mail/"
		
	ИначеЕсли СтрНачинаетсяС(Ссылка, "tasks/") Тогда
		
		Возврат "tasks/"
		
	ИначеЕсли СтрНачинаетсяС(Ссылка, "files/") Тогда
		
		Возврат "files/"
		
	ИначеЕсли СтрНачинаетсяС(Ссылка, "events/") Тогда
		
		Возврат "events/"
		
	ИначеЕсли СтрНачинаетсяС(Ссылка, "mxldetails/") Тогда
		
		Возврат "MXLDetails/";
		
	ИначеЕсли СтрНачинаетсяС(Ссылка, "processing/") Тогда
		
		Возврат "processing/";
		
	ИначеЕсли СтрНачинаетсяС(Ссылка, "employees/") Тогда
		
		Возврат "employees/";
	
	ИначеЕсли Не СтрНачинаетсяС(Ссылка, "api.whatsapp.com") И Не СтрНачинаетсяС(Ссылка, "t.me/share/url?url=")
		И ИнтеграцияShareКлиент.ЭтоДоменСервисаКороткихСсылокShare(Ссылка) Тогда
		
		Возврат "share/";
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции

// Проверяет, что ссылку можно обработать перед переходом
// 
// Параметры:
//  ТипСсылки - Строка
//  ПараметрыСсылки - Соответствие Из КлючИЗначение
// 
// Возвращаемое значение:
//  Булево - Ссылку можно обработать
//
Функция СсылкуМожноОбработать(ТипСсылки, ПараметрыСсылки) Экспорт
	
	Возврат ЗначениеЗаполнено(ТипСсылки) И ТипСсылки <> "e1cib/" И ТипСсылки <> "e1ccs/"
		И Не ИнтеграцияShareДокументооборотКлиент.ЭтоПереходПоСсылкеВБраузер(ПараметрыСсылки);
		
КонецФункции
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет схему ссылки.
//
// Параметры:
//  Ссылка - Строка - Ссылка.
// 
// Возвращаемое значение:
//  Строка - Схема ссылки.
//
Функция ОпределитьСхемуСсылки(Знач Ссылка)
	
	Ссылка = НРег(Ссылка);
	Если СтрНачинаетсяС(Ссылка, "v8doc:") Тогда
		
		Возврат "v8doc:";
		
	ИначеЕсли СтрНачинаетсяС(Ссылка, "http://") Тогда
		
		Возврат "http://";
		
	ИначеЕсли СтрНачинаетсяС(Ссылка, "https://") Тогда
		
		Возврат "https://";
		
	ИначеЕсли СтрНачинаетсяС(Ссылка, "ftp://") Тогда
		
		Возврат "ftp://";
		
	ИначеЕсли СтрНачинаетсяС(Ссылка, "e1c://") Тогда
		
		Возврат "e1c://";
		
	ИначеЕсли СтрНачинаетсяС(Ссылка, "file://") Тогда
		
		Возврат "file://";
		
	ИначеЕсли СтрНачинаетсяС(Ссылка, "mailto:") Тогда
		
		Возврат "mailto:";
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции

// Выполняет попытку перехода по внутренней навигационной ссылке
//
// Параметры:
//  НавигационнаяСсылка - Строка - Навигационная ссылка.
// 
// Возвращаемое значение:
//  Булево - Переход выполнен успешно.
//
Функция ПерейтиПоВнутреннейНавигационнойСсылке(НавигационнаяСсылка)
	
	ПозицияВнутреннейНавигационнойСсылки = Найти(НавигационнаяСсылка, "#e1cib/");
	Если ПозицияВнутреннейНавигационнойСсылки = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВнутренняяНавигационнаяСсылка = Сред(НавигационнаяСсылка, ПозицияВнутреннейНавигационнойСсылки + 1);
	Попытка
		ПерейтиПоНавигационнойСсылке(ВнутренняяНавигационнаяСсылка);
	Исключение
		// Внутренней навигационный ссылки может не быть в базе.
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// Обработчик оповещения ОбработатьСсылку1СДокументооборота.
// 
// Параметры:
//  Результат - Соответствие из КлючИЗначение:
//   * Ключ - СправочникСсылка.Файлы
//   * Значение - Число
//  Обработчик - ОписаниеОповещения
//
Процедура ПослеУказанияКоличестваСпикеров(Результат, Обработчик) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Элемент Из Результат Цикл
		
		КомандыРаботыСФайламиКлиент.РаспознатьФайлСОповещением(Обработчик,
			Элемент.Ключ,, Результат);
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик оповещения ОбработатьСсылку1СДокументооборота.
// 
// Параметры:
//  Результат - Неопределено.
//  Файл - СправочникСсылка.Файлы.
//
Процедура ПослеРаспознавания(Результат, Файл) Экспорт
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайла(Файл);
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Событие", "ДанныеФайлаИзменены");
	ПараметрыОповещения.Вставить("Файл", Файл);
	ПараметрыОповещения.Вставить("Владелец", ДанныеФайла.Владелец);
	ПараметрыОповещения.Вставить("ЕстьЗанятыеФайлы", Неопределено);
	ПараметрыОповещения.Вставить("ИдентификаторРодительскойФормы", Неопределено);
	
	Оповестить("Запись_Файл", ПараметрыОповещения, Файл);
	
КонецПроцедуры


// Обработчик оповещения ОбработатьСсылку1СДокументооборота.
// 
// Параметры:
//  Результат - Булево
//  Параметры - Структура:
//   * АдресВременногоХранилищаФайла - Строка
//   * Сотрудник - СправочникСсылка.Сотрудники
// 
Процедура ПослеВыбораФотографии(Результат, Параметры) Экспорт
	
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	РаботаС_HTMLВызовСервера.ЗаписатьФотографиюСотрудника(
		Параметры.АдресВременногоХранилищаФайла,
		Параметры.ИдентификаторФормы,
		Параметры.Сотрудник);
		
	ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъекта(Параметры.Сотрудник);
	
КонецПроцедуры

#КонецОбласти