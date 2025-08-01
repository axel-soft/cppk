﻿// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Проверка действительности участников.
// 
// Параметры:
//  ОбъектФормы - ДанныеФормыСтруктура - Объект формы инициатора проверки:
//   * Участники - ДанныеФормыКоллекция - коллекция участников формы.
//   * Ссылка - ДокументСсылка.Задача, ОпределяемыйТип.НастройкиДействий, ОпределяемыйТип.Действия - коллекция участников формы.
// 
// Возвращаемое значение:
//  Структура - Проверка действительности участников:
// * ВсеДействительны - Булево - Признак действительности всех сотрудников, т.е. действителен и сотрудник и хотя бы
//                               один пользователь сотрудника.
// * ЕстьВариантыЗамены - Булево - Признак наличия вариантов замены сотрудников. Например, на действительного сотрудника
//                                 того же пользователя.
// * ЕстьНедействительныеСотрудники - Булево - Признак наличия среди сотрудников таких, которые недействительны.
// * ЕстьНедействительныеПользователи - Булево - Признак наличия среди сотрудников таких, у которых Сотрудник
//                                               действителен, а Пользователь недействителен. 
// * УчитыватьПравилаКоммуникаций - Булево - В форме замены участников нужно учитывать правила коммуникаций.
// * ВладелецФормыДействия - Булево - Признак, что владелец - форма Справочник.Действия<...>.
// * ПредставленияНедействительныхУчастников - Массив Из Строка - представления вида Фамилия И. О.
// * Сведения - Массив Из Структура - Массив структур со сведениями о действительности сотрудника:
// ** Сотрудник - СправочникСсылка.Сотрудники - Ссылка на сотрудника.
// ** Действует - Булево - Признак действует сотрудника.
// ** ПользовательДействует - Булево - Признак наличия хотя бы одного действительного пользователя.
// ** Замены - Массив из СправочникСсылка.Сотрудники - Возможные варианты замены сотрудника.
//
Функция ПроверитьДействительностьУчастников(ОбъектФормы) Экспорт
	
	Участники = ОбъектФормы.Участники;
	ТипОбъекта = ТипЗнч(ОбъектФормы.Ссылка);
	
	ТипДействий = Метаданные.ОпределяемыеТипы.Действия.Тип;
	ВладелецФормыДействия = ТипДействий.СодержитТип(ТипОбъекта);
	
	Если ВладелецФормыДействия Тогда
		ОставитьТолькоДоступныхКИзменению(Участники, ОбъектФормы);
	КонецЕсли;
	
	// В строках таблицы формы на этом этапе не должно быть строк с пустым участником.
	ВсеУчастники = Участники.Выгрузить().ВыгрузитьКолонку("Участник");
	УчастникиСотрудники = ОбщегоНазначенияДокументооборотКлиентСервер.СоответствиеПоТипам(ВсеУчастники)[Тип(
		"СправочникСсылка.Сотрудники")];
	
	// Если нет участников-сотрудников, то не проверяем дальше.
	Если УчастникиСотрудники = Неопределено Тогда
		Результат = Сотрудники.ОписаниеРезультатаПроверкиСотрудниковНаДействительность();
		Результат.ВсеДействительны = Истина;
		Результат.Вставить("УчитыватьПравилаКоммуникаций", Ложь);
		Возврат Результат;
	КонецЕсли;
	
	РезультатПроверки = Сотрудники.ПроверитьСотрудниковНаДействительность(УчастникиСотрудники, Истина);
	Если РезультатПроверки.ВсеДействительны Тогда
		РезультатПроверки.Вставить("УчитыватьПравилаКоммуникаций", Ложь);
		Возврат РезультатПроверки;
	КонецЕсли;
	
	ТипНастройкиДействий = Метаданные.ОпределяемыеТипы.НастройкиДействий.Тип;
	УчитыватьПравилаКоммуникаций = Не ТипНастройкиДействий.СодержитТип(ТипОбъекта);
	РезультатПроверки.Вставить("УчитыватьПравилаКоммуникаций", УчитыватьПравилаКоммуникаций);
	
	РезультатПроверки.Вставить("ВладелецФормыДействия", ВладелецФормыДействия);
	
	ДополнитьСведения(РезультатПроверки.Сведения, ОбъектФормы, Участники, ВладелецФормыДействия);
	
	Возврат РезультатПроверки;
	
КонецФункции

// Заполнить результат проверки участников по правилам коммуникаций.
// 
// Параметры:
//  УчастникиПоВидамиУчастников - Соответствие Из КлючИЗначение - участники по видам участников:
//   * Ключ - СправочникСсылка.ВидыУчастниковЗадач
//   * Значение - Структура:
//     ** КонтекстПравилКоммуникации - Структура
//     ** Участники - Массив Из СправочникСсылка
//  РезультатПроверкиПравилКоммуникации - Структура:
//   * УчастникиПодходят - Булево - Признак того, что все участники подходят по правилам коммуникаций.
//   * НеПрошедшиеПроверку - Массив Из см. НеПрошедшийПроверкуПКУчастник
//
Процедура ЗаполнитьРезультатПроверкиУчастниковПоПравиламКоммуникаций(УчастникиПоВидамиУчастников,
	РезультатПроверкиПравилКоммуникации) Экспорт
	
	Для Каждого ЭлементПроверки Из УчастникиПоВидамиУчастников Цикл
		
		КонтекстПравилКоммуникации = ЭлементПроверки.Значение.КонтекстПравилКоммуникации;
		
		Участники = УчастникиСотрудникиИРолиИсполнителей(ЭлементПроверки.Значение.Участники);
		
		УчастникиПрошедшиеПроверку = Справочники.ПравилаКоммуникаций.ПроверитьЭлементы(Участники,
			КонтекстПравилКоммуникации, Истина);
		
		УчастникиНеПрошедшиеПроверку = ОбщегоНазначенияКлиентСервер.РазностьМассивов(Участники,
			УчастникиПрошедшиеПроверку);
		Если УчастникиНеПрошедшиеПроверку.Количество() <> 0 Тогда
			
			ПравилоКоммуникации = Справочники.ПравилаКоммуникаций.ПодобратьПравило(КонтекстПравилКоммуникации, Ложь);
			РезультатПроверкиПравилКоммуникации.УчастникиПодходят = Ложь;
			Для Каждого ЭлементУчастник Из УчастникиНеПрошедшиеПроверку Цикл
				
				НеПрошедшийПроверкуУчастник = НеПрошедшийПроверкуПКУчастник();
				НеПрошедшийПроверкуУчастник.ВидУчастника = ЭлементПроверки.Ключ;
				НеПрошедшийПроверкуУчастник.Участник = ЭлементУчастник;
				НеПрошедшийПроверкуУчастник.Правило = ПравилоКоммуникации;
				НеПрошедшийПроверкуУчастник.ПолУчастника =
					РаботаСЗадачамиПовтИсп.ПолУчастника(ЭлементУчастник);
				НеПрошедшийПроверкуУчастник.ПредставлениеУчастника =
					РаботаСЗадачамиПовтИсп.ПредставлениеУчастника(ЭлементУчастник);
				 
				РезультатПроверкиПравилКоммуникации.НеПрошедшиеПроверку.Добавить(НеПрошедшийПроверкуУчастник);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Не прошедший проверку участник.
// 
// Возвращаемое значение:
//  Структура - Не прошедший проверку участник:
// * ВидУчастника - СправочникСсылка.ВидыУчастниковЗадач, Неопределено - вид участника.
// * Участник - Неопределено -
// * Правило - СправочникСсылка.ПравилаКоммуникаций, Неопределено - правила коммникаций.
// * ПолУчастника - ПеречислениеСсылка.ПолФизическогоЛица, Неопределено - пол участника.
// * ПредставлениеУчастника - Строка, Неопределено - представление участника.
//
Функция НеПрошедшийПроверкуПКУчастник() Экспорт
	
	Участник = Новый Структура();
	Участник.Вставить("ВидУчастника", Неопределено);
	Участник.Вставить("Участник", Неопределено);
	Участник.Вставить("Правило", Неопределено);
	Участник.Вставить("ПолУчастника", Неопределено);
	Участник.Вставить("ПредставлениеУчастника", Неопределено);
	Возврат Участник;
	
КонецФункции

// Участники сотрудники и роли исполнителей.
// 
// Параметры:
//  ВсеУчастники - Массив из ОпределяемыйТип.УчастникЗадач - Все участники
// 
// Возвращаемое значение:
//  Массив из ОпределяемыйТип.УчастникЗадач - Участники сотрудники и роли исполнителей
//
Функция УчастникиСотрудникиИРолиИсполнителей(ВсеУчастники)
	
	Результат = Новый Массив;
	СоответствиеПоТипам = ОбщегоНазначенияДокументооборотКлиентСервер.СоответствиеПоТипам(ВсеУчастники);
	ТипПолныеРоли = Тип("СправочникСсылка.ПолныеРоли");
	
	Если СоответствиеПоТипам[ТипПолныеРоли] = Неопределено Тогда
		// Если полных ролей в списке участников нет, то ничего не делаем и возвращаем обратно тот же массив.
		Возврат ВсеУчастники;
	КонецЕсли; 
	
	РолиИсполнителейСоответствие = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(СоответствиеПоТипам[ТипПолныеРоли],
		"Владелец");
	РолиИсполнителей = ОбщегоНазначенияДокументооборотКлиентСервер.ЗначенияСоответствия(РолиИсполнителейСоответствие);
	
	Для Каждого КлючИЗначение Из СоответствиеПоТипам Цикл
		
		Если КлючИЗначение.Ключ = ТипПолныеРоли Тогда
			КДополнению = РолиИсполнителей;
		Иначе	
			КДополнению = КлючИЗначение.Значение;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Результат, КДополнению);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Дополнить сведениями о видах участников.
// 
// Параметры:
//  Сведения - Массив из Структура - Массив с участниками в поле структуры:
//   * Сотрудник - СправочникСсылка.Сотрудники
//  ОбъектФормы - ДанныеФормыСтруктура - Пункты, либо Этапы, либо ничего:
//   * Пункты - ДанныеФормыКоллекция:
//     ** Описание - Строка
//   * Этапы - ДанныеФормыКоллекция:
//     ** НаименованиеЭтапа - Строка
//  Участники - ДанныеФормыКоллекция - коллекция участников формы (либо ФункцияУчастника, либо ВидУчастника):
//   * ФункцияУчастник - ОпределяемыйТип.ФункцииУчастниковДействий
//   * ВидУчастника - СправочникСсылка.ВидыУчастниковЗадач
//   * Участник - СправочникСсылка.Сотрудники
//  ВладелецФормыДействия - Булево - Признак, что владелец - форма Справочник.Действия<...>.
//
Процедура ДополнитьСведения(Сведения, ОбъектФормы, Участники, ВладелецФормыДействия)
	
	КлючФункцииУчастника = "";
	ФункцияУчастника = Неопределено;
	ПолучатьФункциюУчастникаВСтроках = Истина;
	
	ТипОбъекта = ТипЗнч(ОбъектФормы.Ссылка);
	// Случаи, когда функция участника не указана в табличной части Участники.
	Если ТипОбъекта = Тип("СправочникСсылка.НастройкиДействийОзнакомления") 
		Или ТипОбъекта = Тип("СправочникСсылка.ДействияОзнакомления") Тогда
		
		ПолучатьФункциюУчастникаВСтроках = Ложь;
		КлючФункцииУчастника = "ФункцияУчастника";
		ФункцияУчастника = Перечисления.ФункцииУчастниковОзнакомления.Ознакомляемый;
	КонецЕсли;
	
	ЕстьВидУчастника = Ложь;
	ЕстьФункцияУчастника = Ложь;
	
	Если Участники.Количество() <> 0 Тогда
		ПервыйУчастник = Участники.Получить(0);
		Если СвойствоСтроки(ПервыйУчастник, "ВидУчастника") Тогда
			ЕстьВидУчастника = Истина;
		ИначеЕсли СвойствоСтроки(ПервыйУчастник, "ФункцияУчастника") Тогда
			ЕстьФункцияУчастника = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ПолучатьФункциюУчастникаВСтроках И Не ЕстьВидУчастника И Не ЕстьФункцияУчастника Тогда
		ВызватьИсключение НСтр("ru = 'Возникла непредвиденная ситуация при проверке участников на действительность.
			|Обратитесь к администратору.'");
	КонецЕсли;
	
	Для Каждого Элемент Из Сведения Цикл
		
		Если Не ПолучатьФункциюУчастникаВСтроках Тогда
			КонтекстУчастника = КонтекстУчастника();
			Если ЗначениеЗаполнено(ФункцияУчастника) И ЗначениеЗаполнено(КлючФункцииУчастника) Тогда
				КонтекстУчастника[КлючФункцииУчастника] = ФункцияУчастника;
				ЗаполнитьПредставлениеКонтекста(КонтекстУчастника);
			КонецЕсли;
			Элемент.Вставить("КонтекстыУчастника", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(КонтекстУчастника));
			Продолжить;
		КонецЕсли;
		
		КонтекстыУчастника = Новый Массив;
		
		КлючФункцииУчастника = ?(ЕстьВидУчастника, "ВидУчастника", "ФункцияУчастника");
		
		СтрокиУчастника = Участники.НайтиСтроки(Новый Структура("Участник", Элемент.Сотрудник));
		Для Каждого СтрокаУчастника Из СтрокиУчастника Цикл
			
			КонтекстУчастника = КонтекстУчастника();
			СвойствоСтроки(СтрокаУчастника, КлючФункцииУчастника, КонтекстУчастника[КлючФункцииУчастника]);
			НаименованиеПорядокЭтапаУчастника = НаименованиеПорядокЭтапаУчастника(ОбъектФормы, СтрокаУчастника,
				КонтекстУчастника.ФункцияУчастника);
			Если НаименованиеПорядокЭтапаУчастника <> Неопределено Тогда
				КонтекстУчастника.НаименованиеЭтапа = НаименованиеПорядокЭтапаУчастника.НаименованиеЭтапа;
				КонтекстУчастника.ПорядокЭтапа = НаименованиеПорядокЭтапаУчастника.ПорядокЭтапа;
			КонецЕсли;
			ЗаполнитьПредставлениеКонтекста(КонтекстУчастника);
			
			КонтекстыУчастника.Добавить(КонтекстУчастника);
			
		КонецЦикла;
		
		// Если найденных строк больше 1, значит у участника несколько видов в задаче, запомним это.
		Элемент.Вставить("КонтекстыУчастника", СвернутьКонтексты(КонтекстыУчастника));
		
	КонецЦикла;
	
КонецПроцедуры

// Наименование и порядок этапа по строке участника.
// 
// Параметры:
//  ОбъектФормы - ДанныеФормыСтруктура - Пункты, либо Этапы, либо ничего:
//   * Пункты - ДанныеФормыКоллекция:
//     ** Описание - Строка
//   * Этапы - ДанныеФормыКоллекция:
//     ** НаименованиеЭтапа - Строка
//  СтрокаУчастника - ДанныеФормыЭлементКоллекции, ДанныеФормыЭлементДерева - строка участника.
//  ФункцияУчастника - ОпределяемыйТип.ФункцииУчастниковДействий
// Возвращаемое значение:
//  Структура, Неопределено - Наименование этапа участника:
//   * НаименованиеЭтапа - Строка
//   * ПорядокЭтапа - Строка
//
Функция НаименованиеПорядокЭтапаУчастника(ОбъектФормы, СтрокаУчастника, ФункцияУчастника)
	
	КоллекцияЭтапов = Неопределено;
	КлючИдентификатораЭтапа = "";
	КлючНаименованияЭтапа = "";
	КлючПорядкаЭтапа = "";
	
	Если СвойствоСтроки(СтрокаУчастника, "ИдентификаторПункта") Тогда
		КоллекцияЭтапов			= ОбъектФормы.Пункты;
		КлючИдентификатораЭтапа	= "ИдентификаторПункта";
		КлючНаименованияЭтапа	= "Описание";
		КлючПорядкаЭтапа		= "НомерСтроки";
	КонецЕсли;
	Если СвойствоСтроки(СтрокаУчастника, "ИдентификаторЭтапа") Тогда
		КоллекцияЭтапов			= ОбъектФормы.Этапы;
		КлючИдентификатораЭтапа	= "ИдентификаторЭтапа";
		КлючНаименованияЭтапа	= "НаименованиеЭтапа";
		КлючПорядкаЭтапа		= "НомерСтроки";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КоллекцияЭтапов) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЗначениеИдентификатора = Неопределено;
	СвойствоСтроки(СтрокаУчастника, КлючИдентификатораЭтапа, ЗначениеИдентификатора);
	
	НайденныеЭтапы = КоллекцияЭтапов.НайтиСтроки(Новый Структура("Идентификатор", ЗначениеИдентификатора));
	
	НаименованиеЭтапа = Неопределено;
	ПорядокЭтапа = Неопределено;
	Если НайденныеЭтапы.Количество() <> 0 Тогда
		СвойствоСтроки(НайденныеЭтапы[0], КлючНаименованияЭтапа, НаименованиеЭтапа);
		СвойствоСтроки(НайденныеЭтапы[0], КлючПорядкаЭтапа, ПорядокЭтапа);
	КонецЕсли;
	
	Результат = Новый Структура;
	
	Если НаименованиеЭтапа <> Неопределено Тогда
		Результат.Вставить("НаименованиеЭтапа", НаименованиеЭтапа);
	Иначе
		Результат.Вставить("НаименованиеЭтапа", НаименованиеЭтапаПоФункцииУчастникаДейсвия(ФункцияУчастника));
	КонецЕсли;
	
	Если ПорядокЭтапа <> Неопределено Тогда
		Результат.Вставить("ПорядокЭтапа", ПорядокЭтапа);
	Иначе
		Результат.Вставить("ПорядокЭтапа", ПорядокЭтапаПоФункцииУчастникаДейсвия(ФункцияУчастника));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Порядок этапа по функции участника дейсвия.
// 
// Параметры:
//  ФункцияУчастника - ОпределяемыйТип.ФункцииУчастниковДействий
// 
// Возвращаемое значение:
//  Число - Порядок этапа по функции участника дейсвия.
//
Функция ПорядокЭтапаПоФункцииУчастникаДейсвия(ФункцияУчастника)
	Если ФункцияУчастника = Перечисления.ФункцииУчастниковПодписания.ОбрабатывающийРезультат Тогда
		Возврат 999;
	КонецЕсли;
	
	Результат = 0;
	
	// ФункцииУчастниковИсполнения.
	Если ФункцияУчастника = Перечисления.ФункцииУчастниковИсполнения.Рассматривающий Тогда
		Результат = 0;
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковИсполнения.Исполнитель Тогда
		Результат = 1;
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковИсполнения.ОбрабатывающийРезультат Тогда
		Результат = 999;
	// ФункцииУчастниковУтверждения.
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковУтверждения.Утверждающий Тогда
		Результат = 0;
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковУтверждения.ОбрабатывающийРезультат Тогда
		Результат = 999;
	// ФункцииУчастниковСогласования.
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковСогласования.Согласующий Тогда
		Результат = 0;
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковСогласования.ОбрабатывающийРезультат Тогда
		Результат = 999;
	// ФункцииУчастниковРегистрации.
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковРегистрации.Регистратор Тогда
		Результат = 0;
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковРегистрации.ОбрабатывающийРезультат Тогда
		Результат = 999;
	// ФункцииУчастниковПодписания.
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковПодписания.Подписывающий Тогда
		Результат = 0;
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковПодписания.ОбрабатывающийРезультат Тогда
		Результат = 999;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Наименование этапа по функции участника дейсвия.
// 
// Параметры:
//  ФункцияУчастника - ОпределяемыйТип.ФункцииУчастниковДействий
// 
// Возвращаемое значение:
//  Строка - Наименование этапа по функции участника дейсвия.
//
Функция НаименованиеЭтапаПоФункцииУчастникаДейсвия(ФункцияУчастника)
	
	Результат = "";
	
	// ФункцииУчастниковИсполнения.
	Если ФункцияУчастника = Перечисления.ФункцииУчастниковИсполнения.Рассматривающий Тогда
		Результат = НСтр("ru = 'Рассмотрение'");
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковИсполнения.Исполнитель Тогда
		Результат = НСтр("ru = 'Исполнение'");
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковИсполнения.ОбрабатывающийРезультат Тогда
		Результат = НСтр("ru = 'Обрабатывающий результат'");
	// ФункцииУчастниковУтверждения.
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковУтверждения.Утверждающий Тогда
		Результат = НСтр("ru = 'Утвердить'");
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковУтверждения.ОбрабатывающийРезультат Тогда
		Результат = НСтр("ru = 'Ознакомиться с результатом утверждения'");
	// ФункцииУчастниковСогласования.
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковСогласования.Согласующий Тогда
		Результат = НСтр("ru = 'Согласовать'");
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковСогласования.ОбрабатывающийРезультат Тогда
		Результат = НСтр("ru = 'Ознакомиться с результатом согласования'");
	// ФункцииУчастниковРегистрации.
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковРегистрации.Регистратор Тогда
		Результат = НСтр("ru = 'Зарегистрировать'");
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковРегистрации.ОбрабатывающийРезультат Тогда
		Результат = НСтр("ru = 'Ознакомиться с результатом регистрации'");
	// ФункцииУчастниковПодписания.
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковПодписания.Подписывающий Тогда
		Результат = НСтр("ru = 'Подписать'");
	ИначеЕсли ФункцияУчастника = Перечисления.ФункцииУчастниковПодписания.ОбрабатывающийРезультат Тогда
		Результат = НСтр("ru = 'Ознакомиться с результатом подписания'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Контекст участника.
// 
// Возвращаемое значение:
//  Структура - Контекст участника:
// * ВидУчастника - СправочникСсылка.ВидыУчастниковЗадач, Неопределено - ВидУчастника или Неопределено. 
// * ФункцияУчастника - ОпределяемыйТип.ФункцииУчастниковДействий, Неопределено - Функция участника или Неопределено. 
// * НаименованиеЭтапа - Строка, Неопределено - Наименование этапа или непопределено.
// * ПорядокЭтапа - Строка, Неопределено - Порядок сортировки этапов.
// * КонтекстУчастникаПредставление - Строка, Неопределено - Представление контекста.
//
Функция КонтекстУчастника()
	
	Контекст = Новый Структура();
	Контекст.Вставить("ВидУчастника", Неопределено);
	Контекст.Вставить("ФункцияУчастника", Неопределено);
	Контекст.Вставить("НаименованиеЭтапа", Неопределено);
	Контекст.Вставить("ПорядокЭтапа", Неопределено);
	Контекст.Вставить("КонтекстУчастникаПредставление", Неопределено);
	Возврат Контекст;
	
КонецФункции

// Заполнить представление контекста в свойстве структуры КонтекстУчастникаПредставление.
// 
// Параметры:
//  КонтекстУчастника см. КонтекстУчастника
//
Процедура ЗаполнитьПредставлениеКонтекста(КонтекстУчастника)
	
	Этап = НСтр("ru = 'этап'");
	ЭтапПробел = Этап + " ";
	
	Представление = "";
	Если ЗначениеЗаполнено(КонтекстУчастника.ВидУчастника) Тогда
		Представление = Представление + ?(ЗначениеЗаполнено(Представление), ", ", "") + 
			Строка(КонтекстУчастника.ВидУчастника);
	КонецЕсли;
	Если ЗначениеЗаполнено(КонтекстУчастника.ФункцияУчастника) Тогда
		Представление = Представление + ?(ЗначениеЗаполнено(Представление), ", ", "") + 
			Строка(КонтекстУчастника.ФункцияУчастника);
	КонецЕсли;
	Если ЗначениеЗаполнено(КонтекстУчастника.НаименованиеЭтапа) Тогда
		Представление = Представление + ?(ЗначениеЗаполнено(Представление), ", " + ЭтапПробел, ЭтапПробел) + 
			"""" + Строка(КонтекстУчастника.НаименованиеЭтапа) + """";
	КонецЕсли;
	
	КонтекстУчастника.КонтекстУчастникаПредставление = Представление;
	
КонецПроцедуры


// Возвращает новый массив контекстов, свёртка по КонтекстУчастникаПредставление и ПорядокЭтапа.
// 
// Параметры:
//  КонтекстыУчастников - Массив Из см. КонтекстУчастника
// 
// Возвращаемое значение:
//  Массив Из см. КонтекстУчастника
//
Функция СвернутьКонтексты(КонтекстыУчастников)
	
	Результат = Новый Массив;
	
	УникальныеЗначения = Новый Соответствие;
		
	Для Каждого Контекст Из КонтекстыУчастников Цикл
		КлючКонтекста = "" + Контекст.ПорядокЭтапа + Контекст.КонтекстУчастникаПредставление;
		Если УникальныеЗначения[КлючКонтекста] = Неопределено Тогда 
			УникальныеЗначения.Вставить(КлючКонтекста, Истина);
			Результат.Добавить(Контекст);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Оставить только доступных к изменению. В Действиях<...> есть логика доступности участника к изменению.
// 
// Параметры:
//  Участники - ДанныеФормыКоллекция:
//   * Участник - СправочникСсылка
//   * Идентификатор - УникальныйИдентификатор
//   * Защищенный - Булево
//   * ИзНастройки - Булево
//   * ФункцияУчастника - ОпределяемыйТип.ФункцииУчастниковДействий
//  ОбъектФормы - ДанныеФормыСтруктура:
//   * Предмет - ОпределяемыйТип.ПредметДействия
//
Процедура ОставитьТолькоДоступныхКИзменению(Участники, ОбъектФормы)
	
	Разрешения = Новый ТаблицаЗначений();
	Разрешения.Колонки.Добавить("ИдентификаторЭтапа", Новый ОписаниеТипов("УникальныйИдентификатор"));
	Разрешения.Колонки.Добавить("Разрешение",
		Новый ОписаниеТипов("ПеречислениеСсылка.ВариантыДоступностиИзмененияДействий"));
	Действие = ОбъектФормы.Ссылка;
	НастройкиДоступностиДействий.ЗаполнитьРазрешенияПоДействию(Действие, Разрешения);
	
	ОбщееРазрешение = Разрешения[0].Разрешение;
	Если ОбщееРазрешение = Перечисления.ВариантыДоступностиИзмененияДействий.Запрещено Тогда
		Участники.Очистить();
		Возврат;
	КонецЕсли;
	
	ПредметДействия = Неопределено; 
	
	Если ЗначениеЗаполнено(ОбъектФормы.Предмет) Тогда
		ПредметДействия = ОбъектФормы.Предмет
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПредметДействия) Тогда
		Участники.Очистить();
		Возврат;
	КонецЕсли;
	
	ПраваДоступа =
		ДокументооборотПраваДоступа.ПраваПользователяПоОбъекту(ПредметДействия);
		
	Состояние = РегистрыСведений.СостоянияДействий.СостояниеДействия(ОбъектФормы.Ссылка);
	
	// Значит выполняется и могут быть завершенные действия участников.
	ВсеСостоянияИРезультаты = Неопределено;
	Если Состояние <> Неопределено Тогда
		ВсеСостоянияИРезультаты = ДействияСервер.ВсеСостоянияИРезультаты(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
			ОбъектФормы.Ссылка));
	КонецЕсли;
	
	ЕстьПравоИзменения = 
		ПраваДоступа.Изменение
		И ((Состояние <> Перечисления.СостоянияВыполненияДействий.Завершено
			И Состояние <> Перечисления.СостоянияВыполненияДействий.Пропущено
			И Состояние <> Перечисления.СостоянияВыполненияДействий.Остановлено));
			
	Если Не ЕстьПравоИзменения Тогда
		Участники.Очистить();
		Возврат;
	КонецЕсли;
	
	МожноИзменятьЗащищенныхУчастников = ДействияСервер.РазрешеноИзменятьЗащищенныхУчастников();
	
	НедоступныеСтроки = МассивСтрокТаблицыЗначений();
	Для Каждого СтрокаУчастника Из Участники Цикл
		
		Защищенный = Неопределено;
		СвойствоСтроки(СтрокаУчастника, "Защищенный", Защищенный);
		ИзНастройки = Неопределено;
		СвойствоСтроки(СтрокаУчастника, "ИзНастройки", ИзНастройки);
		
		Если Защищенный И ИзНастройки И Не МожноИзменятьЗащищенныхУчастников Тогда
			НедоступныеСтроки.Добавить(СтрокаУчастника);
			Продолжить;
		КонецЕсли;
		
		СтрокаНедоступнаПоСостояниюДействия = Ложь;
		Идентификатор = Неопределено;
		СвойствоСтроки(СтрокаУчастника, "Идентификатор", Идентификатор);
		Если ВсеСостоянияИРезультаты <> Неопределено Тогда
			НайденныеСтроки = ВсеСостоянияИРезультаты.НайтиСтроки(
				Новый Структура("ИдентификаторУчастника", Идентификатор));
			Если НайденныеСтроки.Количество() Тогда
				НайденнаяСтрока = НайденныеСтроки[0];
				СтрокаНедоступнаПоСостояниюДействия = НайденнаяСтрока.Состояние
					= Перечисления.СостоянияВыполненияДействий.Завершено;
			КонецЕсли;
		КонецЕсли;
		
		Если СтрокаНедоступнаПоСостояниюДействия Тогда
			НедоступныеСтроки.Добавить(СтрокаУчастника);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого НедоступнаяСтрока Из НедоступныеСтроки Цикл
		Участники.Удалить(НедоступнаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

// Массив строк участников.
// 
// Возвращаемое значение:
//  Массив Из ДанныеФормыЭлементКоллекции
//
Функция МассивСтрокТаблицыЗначений()
	
	Возврат Новый Массив;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СвойствоСтроки(Строка, Ключ, НайденноеЗначение = Неопределено)
	
	РеквизитыСтруктура = Новый Структура(Ключ);
	ЗаполнитьЗначенияСвойств(РеквизитыСтруктура, Строка);
	НайденноеЗначение = РеквизитыСтруктура[Ключ];
	
	Возврат (НайденноеЗначение <> Неопределено);
	
КонецФункции

#КонецОбласти