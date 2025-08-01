﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Объект.Включен = Истина;
		
		Если Не ЗначениеЗаполнено(Объект.ВыполняемыйКод) Тогда
			Объект.ВыполняемыйКод = 
		    "// Этот фрагмент кода на встроенном языке будет выполняться 
			|// автоматически регламентным заданием 
			|//  ""Обработка детекторов бизнес-событий"" раз в минуту.
			|// Если при выполнении этого кода возникнет ошибка, то информация об этом
			|// будет записана в журнал регистрации.
			|// Следите за тем, чтобы в этом коде не было бесконечных циклов,
			|// т.к. это может привести к замедлению работы сервера.
			|// Не выполняйте в этом коде длительные операции, т.к. это может
			|// привести к замедлению работы сервера.
			| 
			|//Пример обработки
			|//Если СобытиеПроизошло Тогда
			|//Результат = Истина;
			|//Иначе
			|//Результат = Ложь;
			|//КонецЕсли;";
		КонецЕсли;		
		
	КонецЕсли;	
		
	Элементы.УзелОбмена.Видимость 
		= (Объект.ВариантРаботыВУзлахКОД = 
		ПредопределенноеЗначение("Перечисление.ВариантыРаботыВУзлахКОД.ТолькоВУказанномУзле"));
		
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		Элементы.УзелОбмена.ТолькоПросмотр = Истина;
	КонецЕсли;	
		
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ДополнительныеСвойства.Вставить("УзелОбработки", ВыбранныйУзел);
КонецПроцедуры 

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	УзелОбработки = КОДПовтИсп.УзелПредставлениеПоИдентификатору(Строка(ТекущийОбъект.УзелРаботы));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УзелОбменаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура УзелОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("Справочник.УзлыКОД.ФормаВыбора");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииВыбораУзла", ЭтотОбъект);
	ПараметрыОткрытия = Новый Структура;
	
	ОткрытьФорму("Справочник.УзлыКОД.ФормаВыбора", 
		ПараметрыОткрытия, , , , , ОписаниеОповещения);
		
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, ДополнительныеДанные, СтандартнаяОбработка)
	
	СотрудникиКлиент.СотрудникОбработкаВыбора(Объект, "Ответственный", ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРаботыВУзлахКОДПриИзменении(Элемент)
	
	Элементы.УзелОбмена.Видимость 
		= (Объект.ВариантРаботыВУзлахКОД = 
		ПредопределенноеЗначение("Перечисление.ВариантыРаботыВУзлахКОД.ТолькоВУказанномУзле"));
	 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьКод(Команда)
	
	ОчиститьСообщения();
	
	ТекстУспешногоЗавершения = "";
	Если ПроверитьКодНаСервере(ТекстУспешногоЗавершения) Тогда
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.УстановитьТекст(ТекстУспешногоЗавершения);
		ТекстовыйДокумент.Показать("Результат выполнения выражения на встроенном языке");
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПроверитьКодНаСервере(ТекстУспешногоЗавершения)
	
	УстановитьПривилегированныйРежим(Истина);
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Для Каждого ИмяРазделителя Из РаботаВМоделиСервиса.РазделителиКонфигурации() Цикл
			УстановитьБезопасныйРежимРазделенияДанных(ИмяРазделителя, Истина);
		КонецЦикла;
		УстановитьБезопасныйРежим(Истина);
	КонецЕсли;
	
	Результат = Ложь; 
	ПараметрыВозврата = Новый Структура;
	
	Попытка
		
		Выполнить(Объект.ВыполняемыйКод);
		
		ТекстУспешногоЗавершения = НСтр("ru = 'Результат='") + Строка(Результат) + Символы.ПС;
		
		СтрокаПараметров = "";
		Для Каждого Пара Из ПараметрыВозврата Цикл
			
			Если Не ПустаяСтрока(СтрокаПараметров) Тогда
				СтрокаПараметров = СтрокаПараметров + Символы.ПС;
			КонецЕсли;	
			
			СтрокаПараметров = СтрокаПараметров + Строка(Пара.Ключ) + "=" + Строка(Пара.Значение);
			
		КонецЦикла;	
		
		ТекстУспешногоЗавершения = ТекстУспешногоЗавершения + 
			НСтр("ru = 'ПараметрыВозврата:'") + 
			Символы.ПС + 
			Строка(СтрокаПараметров);
		Возврат Истина;
		
	Исключение
		
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Сообщить(СообщениеОбОшибке);
		Возврат Ложь;
		
	КонецПопытки;	
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииВыбораУзла(Результат, ДополнительныеПараметры) Экспорт
	
	ВыбранныйУзел = Результат;
	УзелОбработки = Строка(Результат);
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти