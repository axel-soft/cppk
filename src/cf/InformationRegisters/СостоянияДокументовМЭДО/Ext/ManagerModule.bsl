﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Получает таблицу состояний документов для различных ситуаций.
// 
// Параметры:
//  Направление - ПеречислениеСсылка.НаправленияСообщенийМЭДО,Неопределено - Направление, относящееся к документу,
//  																		а не к уведомлению или квитанции
//  																		в регистре состояний.
//  Поля - Строка - Поля регистра, через запятую, которые нужно получить, можно указать * - т.е. все поля.
//  				Можно получать поля через точку, т.е. передавать Поля, как часть запроса для ВЫБРАТЬ.
//  ДатаСреза - Дата, Неопределено - на какую получить состояние.
//  МассивСостояний - Массив из ПеречислениеСсылка.СостоянияДокументовМЭДО, Неопределено - Массив состояний для отбора.
//  																					Если Неопределено, то любые.
//  МассивДокументов - Массив из ОпределяемыйТип.ПредметМЭДО, Неопределено - Массив документов.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица состояний документов, могут быть не все колонки (если задан параметр Поля):
//   * Направление - ПеречислениеСсылка.НаправленияСообщенийМЭДО -
//   * ПредметСообщения - ОпределяемыйТип.ПредметСообщенияМЭДО -
//   * Документ - ОпределяемыйТип.ПредметМЭДО -
//   * ИдентификаторДокумента - Строка -
//   * ИдентификаторСообщения - Строка -
//   * Состояние - ПеречислениеСсылка.СостоянияДокументовМЭДО -
Функция СрезСостоянияДокументов(
	Направление,
	Поля,
	ДатаСреза = Неопределено,
	МассивСостояний = Неопределено,
	МассивДокументов = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	*
		|ИЗ
		|	РегистрСведений.СостоянияДокументовМЭДО.СрезПоследних(
		|		&ДатаСреза, Направление = &Направление И &ОтборПоДокументам) КАК Состояния
		|ГДЕ
		|	&ОтборПоСостояниям");
	Если ЗначениеЗаполнено(Направление) Тогда
		Запрос.УстановитьПараметр("Направление", Направление);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Направление = &Направление", "ИСТИНА");
	КонецЕсли;
	Запрос.УстановитьПараметр("ДатаСреза", ДатаСреза);
	
	// Удалим лишние колонки
	Если Поля <> "*" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "*", Поля);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МассивДокументов) Тогда
		Запрос.Текст = СтрЗаменить(
			Запрос.Текст, "&ОтборПоДокументам", "Документ В (&МассивДокументов)");
		Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоДокументам", "ИСТИНА");
	КонецЕсли;
	
	Если МассивСостояний <> Неопределено Тогда
		Запрос.Текст = СтрЗаменить(
			Запрос.Текст, "&ОтборПоСостояниям", "Состояния.Состояние В (&МассивСостояний)");
		Запрос.УстановитьПараметр("МассивСостояний", МассивСостояний);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоСостояниям", "Истина");
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Получает состояние одного документа, "обертка" предыдущей функции.
// 
// Параметры:
//  Документ - ОпределяемыйТип.ПредметМЭДО - документ.
//  Направление - ПеречислениеСсылка.НаправленияСообщенийМЭДО, Неопределено - Направление, относящееся к документу,
//  																		а не к уведомлению или квитанции
//  																		в регистре состояний.
//  Поля - Строка - Поля регистра, через запятую, которые нужно получить, можно указать * - т.е. все поля.
//  				Можно получать поля через точку, т.е. передавать Поля, как часть запроса для ВЫБРАТЬ.
//  ДатаСреза - Дата, Неопределено - на какую получить состояние.
//  МассивСостояний - Неопределено, Массив из ПеречислениеСсылка.СостоянияДокументовМЭДО - Массив состояний для отбора.
//  																					Если Неопределено, то любые.
// 
// Возвращаемое значение:
//  Структура - Состояние документа по срезу из регистра, если не найдено, то все поля = Неопределено.
//  						Поля структуры (если не задан Поля):
//   * Направление - ПеречислениеСсылка.НаправленияСообщенийМЭДО, Неопределено -
//   * Документ - ОпределяемыйТип.ПредметМЭДО -
//   * ИдентификаторДокумента - Строка -
//   * ИдентификаторСообщения - Строка -
//   * ПредметСообщения - ОпределяемыйТип.ПредметСообщенияМЭДО -
//   * Состояние - ПеречислениеСсылка.СостоянияДокументовМЭДО -
Функция СрезСостоянияДокумента(
	Документ, Направление, Поля, ДатаСреза = Неопределено, МассивСостояний = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Документ) Тогда
		ВызватьИсключение НСтр("ru = 'Не задан документ для получения состояния!'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	*
		|ИЗ
		|	РегистрСведений.СостоянияДокументовМЭДО.СрезПоследних(
		|		&ДатаСреза, &ОтборНаправление И Документ = &Документ) КАК Состояния
		|ГДЕ
		|	&ОтборПоСостояниям");
	Если ЗначениеЗаполнено(Направление) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборНаправление", "Направление = &Направление");
		Запрос.УстановитьПараметр("Направление", Направление);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборНаправление", "ИСТИНА");
	КонецЕсли;
	Запрос.УстановитьПараметр("ДатаСреза", ДатаСреза);
	
	// Удалим лишние колонки
	Если Поля <> "*" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "*", Поля);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Документ", Документ);
	
	Если МассивСостояний <> Неопределено Тогда
		Запрос.Текст = СтрЗаменить(
			Запрос.Текст, "&ОтборПоСостояниям", "Состояния.Состояние В (&МассивСостояний)");
		Запрос.УстановитьПараметр("МассивСостояний", МассивСостояний);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоСостояниям", "ИСТИНА");
	КонецЕсли;
	
	Возврат МЭДОСтруктурыДанных.РезультатЗапросаВСтруктуру(Запрос.Выполнить()); //@skip-check constructor-function-return-section
	
КонецФункции

// Получить одно определенное состояние документа. Если в одном состоянии документ был несколько раз, то последнее.
// 
// Параметры:
//  Документ - ОпределяемыйТип.ПредметМЭДО - документ.
//  Состояние - ПеречислениеСсылка.СостоянияДокументовМЭДО - Состояние
//  Поля - Строка - Поля регистра, через запятую, которые нужно получить, если все поля, можно указать "*".
//  ДоДаты - Дата - Историю состояний проверять до этой даты.
// 
// Возвращаемое значение:
//  Структура - Поля структуры (если Поля = "*"):
//   * Направление - ПеречислениеСсылка.НаправленияСообщенийМЭДО -
//   * Документ - ОпределяемыйТип.ПредметМЭДО -
//   * ИдентификаторДокумента - Строка -
//   * ИдентификаторСообщения - Строка -
//   * ПредметСообщения - ОпределяемыйТип.ПредметСообщенияМЭДО -
//   * Состояние - ПеречислениеСсылка.СостоянияДокументовМЭДО -
Функция СостояниеДокумента(Документ, Состояние, Поля, ДоДаты) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	*
		|ИЗ
		|	РегистрСведений.СостоянияДокументовМЭДО КАК Состояния
		|ГДЕ
		|	Документ = &Документ И Состояние = &Состояние И Период <= &ДоДаты
		|УПОРЯДОЧИТЬ ПО
		|	Период УБЫВ");
	Если Поля <> "*" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "*", Поля);
	КонецЕсли;
	Запрос.УстановитьПараметр("Документ", Документ);
	Запрос.УстановитьПараметр("ДоДаты", ДоДаты);
	Запрос.УстановитьПараметр("Состояние", Состояние);
	Возврат МЭДОСтруктурыДанных.РезультатЗапросаВСтруктуру(Запрос.Выполнить()); //@skip-check constructor-function-return-section

КонецФункции

// Получить историю состояний по документу для показа на форме документа.
// 
// Параметры:
//  Документ - ОпределяемыйТип.ПредметМЭДО
// 
// Возвращаемое значение:
//  ТаблицаЗначений:
//   * ПредметСообщения - ОпределяемыйТип.ПредметСообщенияМЭДО
//   * Направление - ПеречислениеСсылка.НаправленияСообщенийМЭДО
//   * ИдентификаторСообщения - Строка
//   * ИдентификаторДокумента - Строка
//   * Состояние - ПеречислениеСсылка.СостоянияДокументовМЭДО
//   * ТипУведомления - ПеречислениеСсылка.ТипыУведомленийМЭДО
Функция ИсторияСостоянийПоДокументу(Документ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Состояния.Период,
		|	Состояния.ПредметСообщения,
		|	Состояния.ПредметСообщения.Направление КАК Направление,
		|	Состояния.ИдентификаторСообщения,
		|	Состояния.ИдентификаторДокумента,
		|	Состояния.Состояние,
		|	ВЫБОР
		|		КОГДА Состояния.ПредметСообщения ССЫЛКА Документ.УведомлениеМЭДО
		|			ТОГДА Состояния.ПредметСообщения.ТипУведомления
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыУведомленийМЭДО.ПустаяСсылка)
		|	КОНЕЦ КАК ТипУведомления
		|ИЗ
		|	РегистрСведений.СостоянияДокументовМЭДО КАК Состояния
		|ГДЕ
		|	Состояния.Документ = &Документ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Состояния.Период УБЫВ");
	Запрос.УстановитьПараметр("Документ", Документ);
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли