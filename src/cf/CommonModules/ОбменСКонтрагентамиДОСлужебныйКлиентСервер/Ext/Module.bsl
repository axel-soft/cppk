﻿ 
#Область ПрограммныйИнтерфейс

// Формирует представление результата создания документов ДО по входящим ЭД
//
// Параметры:
//	КСозданию - Число - Сколько документов было к созданию
//	Создано - Число - Сколько из них было создано
//	СозданоСОшибками - Число - Сколько из них было создано с ошибками
//
// Возвращаемое значение:
//	Строка -- Представление результата формирования
Функция ОписаниеРезультатаСозданияДокументовДОПоВходящимЭД(КСозданию, Создано, СозданоСОшибками) Экспорт
	
	ТекстРезультата = НСтр("ru = 'Нет входящих электронных документов к отражению в учете.'");
	
	Если КСозданию <= 0 Тогда
		Возврат ТекстРезультата;
	КонецЕсли;
	
	Если Создано <= 0 Тогда
		ТекстРезультата = СтрШаблон(
			НСтр("ru = 'Не удалось отразить электронных документов: %1. Подробности в журнале регистрации'"),
			КСозданию);
		
		Возврат ТекстРезультата;
	КонецЕсли;
	
	Если КСозданию = Создано Тогда
		
		Если СозданоСОшибками <= 0 Тогда
		
			ТекстРезультата = СтрШаблон(
				НСтр("ru = 'Создано документов: %1'"),
				Создано);
			
		Иначе
			
			ТекстРезультата = СтрШаблон(
				НСтр("ru = 'Создано документов: %1, из них с ошибками: %2'"),
				Создано,
				СозданоСОшибками);
		
		КонецЕсли;
		
	Иначе
		
		Если СозданоСОшибками <= 0 Тогда
		
			ТекстРезультата = СтрШаблон(
				НСтр("ru = 'Создано документов: %1 из %2'"),
				Создано,
				КСозданию);
			
		Иначе
			
			ТекстРезультата = СтрШаблон(
				НСтр("ru = 'Создано документов: %1 из %2, из них с ошибками %3'"),
				Создано,
				КСозданию,
				СозданоСОшибками);
			
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат ТекстРезультата;
	
КонецФункции // ()

// Формирует представление результата создания ЭД по документам ДО
//
// Параметры:
//	КСозданию - Число - Сколько документов нужно создать
//	Создано - Число - Сколько из них было создано
//
// Возвращаемое значение:
//	Строка -- Представление результата формирования
Функция ОписаниеРезультатаСозданияЭДПоДокументамДО(КСозданию, Создано) Экспорт
	
	ТекстРезультата = НСтр("ru = 'Нет документов 1С:Документооборот к отправке.'");
	
	Если КСозданию <= 0 Тогда
		Возврат ТекстРезультата;
	КонецЕсли;
	
	Если Создано <= 0 Тогда
		ТекстРезультата = СтрШаблон(
			НСтр("ru = 'Не удалось отразить создать электронных документов: %1. Подробности смотрите в журнале регистрации'"),
			КСозданию);
		
		Возврат ТекстРезультата;
	КонецЕсли;
	
	Если Создано = КСозданию Тогда
		
		ТекстРезультата = СтрШаблон(
			НСтр("ru = 'Успешно создано электронных документов: %1'"),
			Создано);
		
	Иначе
		
		ТекстРезультата = СтрШаблон(
			НСтр("ru = 'Создано электронных документов: %1 из %2'"),
			Создано,
			КСозданию);
		
	КонецЕсли;
	
	Возврат ТекстРезультата;
	
КонецФункции // ()

// Возвращает новые параметры формирования электронных документов по документам ДО
// 
// Возвращаемое значение:
// 	Структура - Параметны формирования документов ЭДО:
// * ДокументыДО - Массив из ОпределяемыйТип.ДокументДОДляЭДО - Массив документов ДО для создания документов ЭДО
// * НастройкиСозданияДокументов - Соответствие Из КлючИЗначение - Особые настройки создания для документов ЭДО:
//     ** Ключ - ОпределяемыйТип.ДокументДОДляЭДО - Документ ДО для особых настроек
//     ** Значение - Структура - Особые настройки создания документов ЭДО:
//         *** ВидДокументаЭДО - СправочникСсылка.ВидыДокументовЭДО - Вид документа ЭДО
//         *** Формат - Строка - Идентификатор формата документа
//         *** ТребоватьОтветнуюПодпись - Булево - Требовать ответную подпись
//         *** ТребоватьИзвещениеОПолучении - Булево - Требовать ли извещение о получении документа
// * ЭтоРегламентноеЗадание - Булево - Истина, если формирование документа ЭДО происпходит в регламентном задании, в фоне.
Функция НовыеПараметрыФормированияЭДПоДокументамДО() Экспорт
	
	ПараметрыФормирования = Новый Структура;
	
	ПараметрыФормирования.Вставить("ДокументыДО", Новый Массив);
	ПараметрыФормирования.Вставить("НастройкиСозданияДокументов", Новый Соответствие);
	ПараметрыФормирования.Вставить("ЭтоРегламентноеЗадание", Ложь);
	
	Возврат ПараметрыФормирования;
	
КонецФункции

// Возможные действия по исходящим по ЭДО документам
// 
// Возвращаемое значение:
// 	Структура - Возможные действия:
// * Подписать - Строка - Имя действия подписания
// * Отправить - Строка - Имя действия отправки
Функция ДействияПоИсходящимДокументам() Экспорт
	
	ДействияПоИсходящим = Новый Структура;
	
	ДействияПоИсходящим.Вставить("Подписать", "Подписать");
	ДействияПоИсходящим.Вставить("Отправить", "Отправить");
	
	Возврат ДействияПоИсходящим;
	
КонецФункции

// Технические этапы выполнения действий по исходящим по ЭДО документам
// 
// Возвращаемое значение:
// 	Структура - Имена этапов:
// * Подписание - Строка - Подписание
// * ФормированиеЭД - Строка - Фромирование исходящих документов ЭДО
// * ФормированиеПакетовЭДО - Строка - Формирование пакетов ЭДО
// * Отправка - Строка - Отправка
Функция ЭтапыВыполненияДействийПоИсходящимДокументам() Экспорт
	
	ЭтапыВыполненияДействий = Новый Структура;
	
	ЭтапыВыполненияДействий.Вставить("Подписание", "Подписание");
	ЭтапыВыполненияДействий.Вставить("ФормированиеЭД", "ФормированиеЭД");
	ЭтапыВыполненияДействий.Вставить("ФормированиеПакетовЭДО", "ФормированиеПакетовЭДО");
	ЭтапыВыполненияДействий.Вставить("Отправка", "Отправка");
	
	Возврат ЭтапыВыполненияДействий;
	
КонецФункции

// Возможные действия по входящим по ЭДО документам
// 
// Возвращаемое значение:
// 	Структура - Возможные действия:
// * Принять - Строка - Имя действия 
// * Отклонить - Строка - Имя действия отклонения
Функция ДействияПоВходящимДокументам() Экспорт
	
	ВозможныеДействия = Новый Структура;
	ВозможныеДействия.Вставить("Принять", "Принять");
	ВозможныеДействия.Вставить("Отклонить", "Отклонить");
	
	Возврат ВозможныеДействия;
	
КонецФункции

// Технические операции при выполнении действий по входящим по ЭДО документам
// 
// Возвращаемое значение:
// 	Структура - Имена операций:
// * ОтклонениеДокументовЭДО - Строка - Имя операции отклонения документов БЭД
// * ПриемДокументовЭДО - Строка - Имя операции приема документов БЭД
// * ПодписаниеДокументовДО - Строка - Имя операции подписания документов ДО
Функция ОперацииВыполненияДействийПоВходящимДокументам() Экспорт
	
	ЭтапыПоВходящим = Новый Структура;
	ЭтапыПоВходящим.Вставить("ПодписаниеДокументовДО", "ПодписаниеДО");
	ЭтапыПоВходящим.Вставить("ПриемДокументовЭДО", "ПриемЭДО");
	
	ЭтапыПоВходящим.Вставить("ОтклонениеДокументовЭДО", "ОтклонениеДокументовЭДО");
	
	Возврат ЭтапыПоВходящим;
	
КонецФункции

// Возвращает текст сообщения при блокировке обмена при миграции данных из 2.1
// 
// Возвращаемое значение:
// 	Строка - текст сообщения.
Функция ТекстСообщенияОБлокировкеПриМиграции() Экспорт
	
	Возврат НСтр("ru = 'Обмен по ЭДО производится в 1С:Документооборот 2.1.'");
	
КонецФункции

Функция ДействияСпискаИсходящихДокументов() Экспорт
	
	ДействияСпискаИсходящих = Новый Структура;
	ДействияСпискаИсходящих.Вставить("Подписать", "Подписать");
	ДействияСпискаИсходящих.Вставить("Отправить", "Отправить");
	ДействияСпискаИсходящих.Вставить("СоздатьПакет", "СоздатьПакет");
	ДействияСпискаИсходящих.Вставить("ДобавитьКПакету", "ДобавитьКПакету");
	ДействияСпискаИсходящих.Вставить("ИзменитьСоставПакета", "ИзменитьСоставПакета");
	Возврат ДействияСпискаИсходящих;
	
КонецФункции

#Область ОтражениеДокументовВДО

Функция НовыйКонтекстОтраженияДокументовВДО() Экспорт
	
	КонтекстОтражения = Новый Структура;
	КонтекстОтражения.Вставить("ДокументЭДО", Неопределено);
	КонтекстОтражения.Вставить("АвтоматическоеВыполнение", Истина);
	
	КонтекстОтражения.Вставить("СообщениеЭДО", Неопределено);
	КонтекстОтражения.Вставить("ФайлЭДО", Неопределено);
	
	КонтекстОтражения.Вставить("ОснованиеЗаполненияДокумента", НовоеОснованиеЗаполненияДокументаДО());
	КонтекстОтражения.Вставить("ФайлыДляСоздания", Новый Массив);
	
	КонтекстОтражения.Вставить("ДокументДО", Неопределено);
	КонтекстОтражения.Вставить("ФайлДО", Неопределено);
	КонтекстОтражения.Вставить("ВерсияФайлаДО", Неопределено);
	
	КонтекстОтражения.Вставить("Ошибки", Новый Массив);
	КонтекстОтражения.Вставить("Отказ", Ложь);
	
	Возврат КонтекстОтражения;
	
КонецФункции

Функция НовоеОснованиеЗаполненияДокументаДО() Экспорт
	
	ДанныеДляОтраженияПоЭДО = Новый Структура;
	ДанныеДляОтраженияПоЭДО.Вставить("Заголовок", "");
	ДанныеДляОтраженияПоЭДО.Вставить("Содержание", "");
	ДанныеДляОтраженияПоЭДО.Вставить("ВидДокумента", Неопределено);
	ДанныеДляОтраженияПоЭДО.Вставить("Тематика", Неопределено);
	ДанныеДляОтраженияПоЭДО.Вставить("Комментарий", "");
	ДанныеДляОтраженияПоЭДО.Вставить("Организация", Неопределено);
	ДанныеДляОтраженияПоЭДО.Вставить("Контрагент", Неопределено);
	ДанныеДляОтраженияПоЭДО.Вставить("Сумма", 0);
	ДанныеДляОтраженияПоЭДО.Вставить("ГрифДоступа", Неопределено);
	ДанныеДляОтраженияПоЭДО.Вставить("Папка", Неопределено);
	ДанныеДляОтраженияПоЭДО.Вставить("Ответственный", Неопределено);
	ДанныеДляОтраженияПоЭДО.Вставить("Валюта", Неопределено);
	ДанныеДляОтраженияПоЭДО.Вставить("ВопросДеятельности", Неопределено);
	ДанныеДляОтраженияПоЭДО.Вставить("ДатаСоздания", Дата(1, 1, 1));
	ДанныеДляОтраженияПоЭДО.Вставить("ФормаДокумента", Неопределено);
	ДанныеДляОтраженияПоЭДО.Вставить("Важность", ПредопределенноеЗначение("Перечисление.ВариантыВажностиОбъектов.Обычная"));
	
	ДанныеДляОтраженияПоЭДО.Вставить("Стороны", Новый Массив);
	
	ОснованиеЗаполнения = Новый Структура;
	ОснованиеЗаполнения.Вставить("ДанныеДляОтраженияПоЭДО", ДанныеДляОтраженияПоЭДО);
	
	Возврат ОснованиеЗаполнения;
	
КонецФункции

Функция НовоеОписаниеСтороныДокументаДО() Экспорт
	
	Сторона = Новый Структура;
	Сторона.Вставить("Сторона", Неопределено);
	Сторона.Вставить("КонтактноеЛицо", Неопределено);
	Сторона.Вставить("ДатаПодписи", Дата(1, 1, 1));
	Сторона.Вставить("Подписан", Ложь);
	Сторона.Вставить("Подписал", Неопределено);
	
	Возврат Сторона;
	
КонецФункции

Функция НовоеОписаниеФайлаДОДляСоздания() Экспорт
	
	ОписаниеФайла = Новый Структура;
	ОписаниеФайла.Вставить("СведенияОФайле", РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией"));
	ОписаниеФайла.Вставить("ЭлектронныеПодписи", Новый Массив);
	
	Возврат ОписаниеФайла;
	
КонецФункции

Функция НоваяОшибкаКонтекстаОтражения() Экспорт
	
	Ошибка = Новый Структура;
	Ошибка.Вставить("Описание", "");
	Ошибка.Вставить("ПредметОшибки", Неопределено);
	Ошибка.Вставить("Критическая", Истина);
	
	Возврат Ошибка;
	
КонецФункции

#КонецОбласти

// Входящий документ можно принять.
// 
// Параметры:
//  Действия - см. ЭлектронныеДокументыЭДО.ДействияПоСостояниюДокумента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
// 
// Возвращаемое значение:
//  Булево - Входящий документ можно принять
Функция ВходящийДокументМожноПринять(Действия, Состояние) Экспорт
	
	ДействиеУтвердить = ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.Утвердить");
	ДействиеПодписать = ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.Подписать");
	
	Если Действия[ДействиеУтвердить] <> Истина
		И Действия[ДействиеПодписать] <> Истина Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Если ЭтоСостояниеПодписанияПоОтклонению(Состояние) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Входящий документ можно отклонить.
// 
// Параметры:
//  Действия - см. ЭлектронныеДокументыЭДО.ДействияПоСостояниюДокумента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
// 
// Возвращаемое значение:
//  Булево - Входящий документ можно отклонить
Функция ВходящийДокументМожноОтклонить(Действия, Состояние) Экспорт
	
	ДействиеПодписать = ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.Подписать");
	ДействиеОтклонить = ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.Отклонить");
	ДействиеОтклонитьПодписание = ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.ОтклонитьПодписание");
	
	Если ЭтоСостояниеПодписанияПоОтклонению(Состояние)
		И Действия[ДействиеПодписать] = Истина Тогда
		
		Возврат Истина;
	КонецЕсли;
	
	Если Действия[ДействиеОтклонить] <> Истина
		И Действия[ДействиеОтклонитьПодписание] <> Истина Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#Область СпецификаРазличныхРедакцийДокументооборота

// Пустой документ ДО.
// 
// Возвращаемое значение:
//  ОпределяемыйТип.ДокументДОДляЭДО
Функция ПустойДокументДО() Экспорт
	
	Возврат ПредопределенноеЗначение("Справочник.ДокументыПредприятия.ПустаяСсылка");
	
КонецФункции

// Имя справочника документов ДО.
// 
// Возвращаемое значение:
//  Строка
Функция ИмяСправочникаДокументовДО() Экспорт
	
	Возврат "ДокументыПредприятия";
	
КонецФункции

// Тип документа ДО.
// 
// Возвращаемое значение:
//  Тип
Функция ТипДокументаДО() Экспорт
	
	Возврат Тип("СправочникСсылка.ДокументыПредприятия");
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоСостояниеПодписанияПоОтклонению(Состояние)
	
	Возврат Состояние = ПредопределенноеЗначение("Перечисление.СостоянияДокументовЭДО.ТребуетсяПодписаниеОтклонения");
	
КонецФункции

#КонецОбласти
