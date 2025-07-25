﻿
#Область ПрограммныйИнтерфейс

// Вызывается при определении сервисов, которые поддерживают миграцию.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//   Сервисы - СписокЗначений - в качестве значения адрес сервиса, в качестве представления - представление сервиса.
//
Процедура ПриОпределенииСервисов(Сервисы) Экспорт
КонецПроцедуры

// Обработчик при выгрузке данных.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//   Объект - КонстантаМенеджерЗначения, СправочникОбъект, ДокументОбъект, ПланСчетовОбъект -
//			- ПланВидовХарактеристикОбъект, ПланВидовРасчетаОбъект, РегистрСведенийНаборЗаписей -
//          - РегистрНакопленияНаборЗаписей, РегистрБухгалтерииНаборЗаписей, РегистрРасчетаНаборЗаписей -
//			- ПоследовательностьНаборЗаписей, ПерерасчетНаборЗаписей, БизнесПроцессОбъект, ЗадачаОбъект - выгружаемый объект.
//   Отказ - Булево - если данному параметру установить значение Истина, то объект не будет выгружен.
//
Процедура ПриВыгрузкеОбъекта(Объект, Отказ) Экспорт
КонецПроцедуры

// Обработчик при загрузке данных.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//   Объект - КонстантаМенеджерЗначения, СправочникОбъект, ДокументОбъект, ПланСчетовОбъект -
//			- ПланВидовХарактеристикОбъект, ПланВидовРасчетаОбъект, РегистрСведенийНаборЗаписей -
//          - РегистрНакопленияНаборЗаписей, РегистрБухгалтерииНаборЗаписей, РегистрРасчетаНаборЗаписей -
//			- ПоследовательностьНаборЗаписей, ПерерасчетНаборЗаписей, БизнесПроцессОбъект, ЗадачаОбъект - загружаемый объект.
//   Отказ - Булево - если данному параметру установить значение Истина, то объект не будет загружен.
//
Процедура ПриЗагрузкеОбъекта(Объект, Отказ) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ТипОбъекта = ТипЗнч(Объект);
		
		Если ТипОбъекта = Тип("СправочникОбъект.ВерсииФайлов") Тогда
			
		ИначеЕсли ТипОбъекта = Тип("СправочникОбъект.Файлы") Тогда
			Объект.ТекущаяВерсияПутьКФайлу = "";
			Объект.ТекущаяВерсияТом = Неопределено;
			
		ИначеЕсли ТипОбъекта = Тип("КонстантаМенеджерЗначения.ПрограммаРаспознавания") Тогда
			Объект.Значение = Перечисления.ПрограммыРаспознавания.СервисРаспознавания;
			
		ИначеЕсли ТипОбъекта = Тип("СправочникОбъект.ТомаХраненияФайлов")
			Или ТипОбъекта = Тип("КонстантаМенеджерЗначения.ХранитьФайлыВТомахНаДиске") 
			Или ТипОбъекта = Тип("КонстантаМенеджерЗначения.УдалятьНеактивныеВерсии") Тогда
			Отказ = Истина;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоЗагрузка(Объект, Контекст = Неопределено) Экспорт
	
	Если Объект.ОбменДанными.Загрузка
		И Объект.ДополнительныеСвойства.Свойство("ОтключитьМеханизмРегистрацииОбъектов") Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти
	
