﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ОбработкаОбновления

Процедура ЗаполнитьДокументыЭДОКСозданиюВДОПриОбновлении() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаДокументовЭДОКДобавлениюПриОбновлении();
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	КолвоРезультатов = РезультатыЗапроса.Количество();
	
	ВыборкаКАвтоматическомуОтражению = РезультатыЗапроса[КолвоРезультатов - 2].Выбрать();
	ВыборкаПоОшибкам = РезультатыЗапроса[КолвоРезультатов - 1].Выбрать();
	
	ДобавитьДокументыЭДОПриОбновлении(ВыборкаКАвтоматическомуОтражению, Истина);
	ДобавитьДокументыЭДОПриОбновлении(ВыборкаПоОшибкам, Ложь);
	
КонецПроцедуры

#КонецОбласти

// Добавляет входящий документ ЭДО к отражению в список к отражению в документах ДО
// 
// Параметры:
//  ДокументЭДО - ДокументСсылка.ЭлектронныйДокументВходящийЭДО - Документ ЭДО, который необходимо отразить
//                                                                в документах ДО
//  АвтоматическоеСоздание - Булево, Неопределено - Указывает, необходимо ли создавать документ автоматически.
//                                       Если заполнено, то устанавливает, значение автоматического создания
//                                       Если не заполнено, то значение берется из настроек отражения в учете
Процедура ДобавитьДокументКОтражениюВДО(ДокументЭДО, АвтоматическоеСоздание = Неопределено) Экспорт
	
	Если ТипЗнч(АвтоматическоеСоздание) = Тип("Булево") Тогда
		СоздаватьАвтоматически = АвтоматическоеСоздание;
	Иначе
		РеквизитыДокументаЭДО = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументЭДО,
			"Организация, Контрагент, ВидДокумента");
		
		КлючПравилУчета = РегистрыСведений.ПравилаУчетаВидовЭДДО.КлючПравилОтраженияВДО(
			РеквизитыДокументаЭДО.ВидДокумента,
			РеквизитыДокументаЭДО.Организация,
			РеквизитыДокументаЭДО.Контрагент);
		
		ПравилаУчета = РегистрыСведений.ПравилаУчетаВидовЭДДО.ПараметрыДокументаПоВидуЭДО(КлючПравилУчета);
		
		Если ПравилаУчета.СоздаватьАвтоматически = Истина Тогда
			СоздаватьАвтоматически = Истина;
		Иначе
			СоздаватьАвтоматически = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Запись = РегистрыСведений.ДокументыЭДОКСозданиюВДО.СоздатьМенеджерЗаписи();
	Запись.ДокументЭДО = ДокументЭДО;
	Запись.АвтоматическоеСоздание = СоздаватьАвтоматически;
	Запись.КоличествоПопытокОбработки = 0;
	Запись.Записать();
	
КонецПроцедуры

Функция ДобавитьПопыткуАвтоматическогоСоздания(ДокументЭДО) Экспорт
	
	Запись = РегистрыСведений.ДокументыЭДОКСозданиюВДО.СоздатьМенеджерЗаписи();
	Запись.ДокументЭДО = ДокументЭДО;
	Запись.Прочитать();
	
	Запись.КоличествоПопытокОбработки = Запись.КоличествоПопытокОбработки + 1;
	Запись.Записать();
	
	Возврат Запись.КоличествоПопытокОбработки;
	
КонецФункции

Процедура СнятьДокументСАвтоматическогоСоздания(ДокументЭДО) Экспорт
	
	Запись = РегистрыСведений.ДокументыЭДОКСозданиюВДО.СоздатьМенеджерЗаписи();
	Запись.ДокументЭДО = ДокументЭДО;
	Запись.Прочитать();
	
	Если Запись.Выбран() Тогда
		
		Запись.АвтоматическоеСоздание = Ложь;
		Запись.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

// Удаляет входящий документ ЭДО из списка к отражению в документах ДО
// 
// Параметры:
//  ДокументЭДО - ДокументСсылка.ЭлектронныйДокументВходящийЭДО - Документ ЭДО, который необходимо убрать из списка
Процедура УдалитьДокументИзСпискаКОтражению(ДокументЭДО) Экспорт
	
	Запись = РегистрыСведений.ДокументыЭДОКСозданиюВДО.СоздатьМенеджерЗаписи();
	Запись.ДокументЭДО = ДокументЭДО;
	
	Запись.Удалить();
	
КонецПроцедуры

Функция ДокументЭДОТребуетОтраженияВДО(ДокументЭДО) Экспорт
	
	Запись = РегистрыСведений.ДокументыЭДОКСозданиюВДО.СоздатьМенеджерЗаписи();
	Запись.ДокументЭДО = ДокументЭДО;
	Запись.Прочитать();
	
	Если Запись.Выбран() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФукции

#Область ОбработкаОбновления

Функция ТекстЗапросаДокументовЭДОКДобавлениюПриОбновлении()
	
	Возврат
		"ВЫБРАТЬ
		|	ЭлектронныйДокументВходящийЭДО.Ссылка КАК ДокументЭДО,
		|	УдалитьОчередьПриемаСообщенийЭДО.КоличествоПопытокОбработки КАК ПопытокОбработки
		|ИЗ
		|	РегистрСведений.УдалитьОчередьПриемаСообщенийЭДО КАК УдалитьОчередьПриемаСообщенийЭДО
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭлектронныйДокументВходящийЭДО КАК ЭлектронныйДокументВходящийЭДО
		|		ПО УдалитьОчередьПриемаСообщенийЭДО.СообщениеЭДО.ЭлектронныйДокумент = ЭлектронныйДокументВходящийЭДО.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОшибкиЭДОКИсправлению.ПредметОшибки КАК ДокументЭДО,
		|	0 КАК ПопытокОбработки
		|ИЗ
		|	РегистрСведений.ОшибкиЭДОКИсправлению КАК ОшибкиЭДОКИсправлению
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭлектронныйДокументВходящийЭДО КАК ЭлектронныйДокументВходящийЭДО
		|		ПО ОшибкиЭДОКИсправлению.ПредметОшибки = ЭлектронныйДокументВходящийЭДО.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УдалитьОчередьПриемаСообщенийЭДО КАК УдалитьОчередьПриемаСообщенийЭДО
		|		ПО ОшибкиЭДОКИсправлению.ПредметОшибки = УдалитьОчередьПриемаСообщенийЭДО.СообщениеЭДО.ЭлектронныйДокумент
		|ГДЕ
		|	УдалитьОчередьПриемаСообщенийЭДО.СообщениеЭДО ЕСТЬ NULL";
	
КонецФункции

Процедура ДобавитьДокументыЭДОПриОбновлении(Выборка, АвтоматическоеСоздание)
	
	Пока Выборка.Следующий() Цикл
		
		ДокументЭДО = Выборка.ДокументЭДО;
		
		ЗаписьНовая = РегистрыСведений.ДокументыЭДОКСозданиюВДО.СоздатьМенеджерЗаписи();
		ЗаписьНовая.ДокументЭДО = ДокументЭДО;
		
		Если АвтоматическоеСоздание = Истина Тогда
			ЗаписьНовая.АвтоматическоеСоздание = Истина;
			ЗаписьНовая.КоличествоПопытокОбработки = Выборка.ПопытокОбработки;
		КонецЕсли;
		
		ЗаписьНовая.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
