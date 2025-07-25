﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Предназначена для внесения изменений в форму Обслуживание обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ОбслуживаниеПриСозданииНаСервере(Форма) Экспорт
	
	// Отображается только оценка производительности.
	Элементы = Форма.Элементы;
	Форма.Заголовок = НСтр("ru = 'Оценка производительности'");
	Форма.АвтоЗаголовок = Ложь;
	Элементы.ГруппаОценкаПроизводительности.Поведение = ПоведениеОбычнойГруппы.Обычное;
	Элементы.ГруппаОценкаПроизводительности.ОтображатьЗаголовок = Ложь;
	Элементы.ВыполнятьЗамерыПроизводительности.Видимость = Ложь;
	Элементы.Переместить(Элементы.ОбработкаНастройкиОценкиПроизводительности,
		Элементы.ГруппаВыполнятьЗамерыПроизводительности,
		Элементы.СправочникПрофилиКлючевыхОперацийОткрытьСписок);
	
	Элементы.ОбработкаНастройкиОценкиПроизводительности.РасширеннаяПодсказка.Заголовок =
		СтрЗаменить(Элементы.ОбработкаНастройкиОценкиПроизводительности.РасширеннаяПодсказка.Заголовок, ".", "");
	Элементы.СправочникПрофилиКлючевыхОперацийОткрытьСписок.РасширеннаяПодсказка.Заголовок =
		СтрЗаменить(Элементы.СправочникПрофилиКлючевыхОперацийОткрытьСписок.РасширеннаяПодсказка.Заголовок, ".", "");
	Элементы.ОбработкаОценкаПроизводительностиИмпортЗамеровПроизводительности.РасширеннаяПодсказка.Заголовок =
		СтрЗаменить(Элементы.ОбработкаОценкаПроизводительностиИмпортЗамеровПроизводительности.РасширеннаяПодсказка.Заголовок, ".", "");
	
	Элементы.ГруппаЗаголовок.Видимость = Ложь;
	Элементы.ГруппаЧастотныйСервис.Видимость = Ложь;
	Элементы.ГруппаОтчетыИОбработки.Видимость = Ложь;
	Элементы.ГруппаРегламентныеОперации.Видимость = Ложь;
	Элементы.ГруппаРезервноеКопированиеИВосстановление.Видимость = Ложь;
	Элементы.ГруппаКорректировкаДанных.Видимость = Ложь;
	Элементы.ГруппаРезультатыОбновленияПрограммы.Видимость = Ложь;
	
КонецПроцедуры

// Предназначена для внесения изменений в форму ОбщиеНастройки обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ОбщиеНастройкиПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму Обслуживание обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура НастройкиПользователейИПравПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму ИнтернетПоддержкаИСервисы обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ИнтернетПоддержкаИСервисыПриСозданииНаСервере(Форма) Экспорт
	
	Форма.Элементы.ГруппаОткрытьОписаниеИзмененийСистемы.Видимость = Ложь;
	
КонецПроцедуры

// Предназначена для внесения изменений в форму Органайзер обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ОрганайзерПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму СинхронизацияДанных обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура СинхронизацияДанныхПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму НастройкиРаботыСФайлами обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура НастройкиРаботыСФайламиПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму ПечатныеФормыОтчетыИОбработки обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ПечатныеФормыОтчетыИОбработкиПриСозданииНаСервере(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	Элементы.ГруппаЗаголовок.Видимость = Ложь;
	Элементы.ГруппаОтчеты.Видимость = Ложь;
	Элементы.ГруппаНастройкаКолонтитулов.Видимость = Ложь;
	Элементы.ГруппаДополнительныеОтчетыИОбработкиИспользование.Видимость = Ложь;
	
	Элементы.Переместить(Элементы.ГруппаРассылкиОтчетов, Элементы.ГруппаКолонки);
	Элементы.Переместить(Элементы.ГруппаУниверсальныйОтчетРасширения, Элементы.ГруппаКолонки);
	
КонецПроцедуры

#КонецОбласти