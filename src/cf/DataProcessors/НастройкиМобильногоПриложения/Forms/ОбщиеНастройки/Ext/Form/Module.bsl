﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("ТекущийПользователь", ТекущийПользователь);
	
	Если Не ЗначениеЗаполнено(ТекущийПользователь) Тогда
		ТекущийПользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	ЗагрузитьНастройки();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Заголовок = СтрШаблон("%1: %2", Заголовок, ТекущийПользователь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФильтроватьПередаваемыеНаКлиентФайлыПриИзменении(Элемент)

	Элементы.ФорматыПередаваемыхФайлов.Доступность = ФильтроватьПередаваемыеНаКлиентФайлы;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)

	Если Не ЗначениеЗаполнено(ТекущийПользователь) Тогда

		Сообщение = Новый СообщениеПользователю();
		Сообщение.Поле  = "ТекущийПользователь";
		Сообщение.Текст = "Не выбран пользователь";
		Сообщение.Сообщить();

		Возврат;

	КонецЕсли;

	ЗаписатьОбщиеНастройкиСинхронизации();
	ЗаписатьНастройкиПередачиФайлов();

	Закрыть(НастройкиИзменены);

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбщиеНастройкиСинхронизации

&НаСервере
Процедура ЗагрузитьНастройки()

	ЗагрузитьОбщиеНастройкиСинхронизации();
	ЗагрузитьНастройкиПередачиФайлов();

КонецПроцедуры 

&НаСервере
Процедура ЗагрузитьОбщиеНастройкиСинхронизации()

	МаксимальныйРазмерПередаваемогоФайла = 
		РегистрыСведений.МП_НастройкиПользователей.ПолучитьНастройку(
			ТекущийПользователь,
			Перечисления.МП_ТипыНастроекПользователей.МаксимальныйРазмерФайлов);

	МаксимальныйРазмерПередаваемогоФайлаПриОткрытии = МаксимальныйРазмерПередаваемогоФайла;
	
	СрокУстареванияДанных = РегистрыСведений.МП_НастройкиПользователей.ПолучитьНастройку(
		ТекущийПользователь,
		Перечисления.МП_ТипыНастроекПользователей.СрокУстареванияДанных);

	СрокУстареванияДанныхПриОткрытии = СрокУстареванияДанных;

	ПодробныйПротоколОбменаСУстройством = РегистрыСведений.МП_НастройкиПользователей.ПолучитьНастройку(
		ТекущийПользователь,
		Перечисления.МП_ТипыНастроекПользователей.ПодробныйПротоколОбменаСМобильнымУстройством);

	ПодробныйПротоколОбменаСУстройствомПриОткрытии = ПодробныйПротоколОбменаСУстройством;

КонецПроцедуры 

&НаСервере
Процедура ЗаписатьОбщиеНастройкиСинхронизации()
	
	НастройкиИзменены = Ложь;
	
	РегистрыСведений.МП_НастройкиПользователей.ЗаписатьНастройку(
		ТекущийПользователь,
		Перечисления.МП_ТипыНастроекПользователей.МаксимальныйРазмерФайлов,
		МаксимальныйРазмерПередаваемогоФайла);

	Если МаксимальныйРазмерПередаваемогоФайлаПриОткрытии <> МаксимальныйРазмерПередаваемогоФайла Тогда
		РегистрыСведений.МП_ИзмененныеНастройкиСинхронизации.ДобавитьЗапись(
			ТекущийПользователь,
			Перечисления.ВидыНастроекОбменаСМобильнымКлиентом.МаксимальныйРазмерФайла);
		НастройкиИзменены = Истина;
	КонецЕсли;

	РегистрыСведений.МП_НастройкиПользователей.ЗаписатьНастройку(
		ТекущийПользователь,
		Перечисления.МП_ТипыНастроекПользователей.СрокУстареванияДанных,
		СрокУстареванияДанных);

	Если СрокУстареванияДанных <> СрокУстареванияДанныхПриОткрытии Тогда
		// добавление записи об изменившейся настройке срока устаревания данных
		РегистрыСведений.МП_ИзмененныеНастройкиСинхронизации.ДобавитьЗапись(
			ТекущийПользователь,
			Перечисления.ВидыНастроекОбменаСМобильнымКлиентом.СрокУстареванияДанных);
		НастройкиИзменены = Истина;
		
	КонецЕсли;

	Если ФильтроватьПередаваемыеНаКлиентФайлы <> ФильтроватьПередаваемыеНаКлиентФайлыПриОткрытии Тогда
		// добавление записи об изменившейся настройке срока устаревания данных
		РегистрыСведений.МП_ИзмененныеНастройкиСинхронизации.ДобавитьЗапись(
			ТекущийПользователь,
			Перечисления.ВидыНастроекОбменаСМобильнымКлиентом.СрокУстареванияДанных);
		НастройкиИзменены = Истина;
	КонецЕсли;
	
	РегистрыСведений.МП_НастройкиПользователей.ЗаписатьНастройку(
		ТекущийПользователь,
		Перечисления.МП_ТипыНастроекПользователей.ПодробныйПротоколОбменаСМобильнымУстройством,
		ПодробныйПротоколОбменаСУстройством);

КонецПроцедуры

#КонецОбласти

#Область НастройкиСинхронизацииФайлов

&НаСервере
Процедура ЗагрузитьНастройкиПередачиФайлов()

	ФильтроватьПередаваемыеНаКлиентФайлы = РегистрыСведений.МП_НастройкиПользователей.ПолучитьНастройку(
			ТекущийПользователь,
			Перечисления.МП_ТипыНастроекПользователей.ОграничениеФорматовПередаваемыхФайлов);
	ФильтроватьПередаваемыеНаКлиентФайлыПриОткрытии = ФильтроватьПередаваемыеНаКлиентФайлы;
	
	ФорматыПередаваемыхФайлов = ВРег(РегистрыСведений.МП_НастройкиПользователей.ПолучитьНастройку(
			ТекущийПользователь,
			Перечисления.МП_ТипыНастроекПользователей.ФорматыПередаваемыхФайлов));
			
	ФорматыПередаваемыхФайловПриОткрытии = ФорматыПередаваемыхФайлов;
	
	Элементы.ФорматыПередаваемыхФайлов.Доступность = ФильтроватьПередаваемыеНаКлиентФайлы;

КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиПередачиФайлов()

	Если ФильтроватьПередаваемыеНаКлиентФайлы <> ФильтроватьПередаваемыеНаКлиентФайлыПриОткрытии Тогда
		
		РегистрыСведений.МП_НастройкиПользователей.ЗаписатьНастройку(
			ТекущийПользователь,
			Перечисления.МП_ТипыНастроекПользователей.ОграничениеФорматовПередаваемыхФайлов,
			ФильтроватьПередаваемыеНаКлиентФайлы);
			
		РегистрыСведений.МП_ИзмененныеНастройкиСинхронизации.ДобавитьЗапись(
			ТекущийПользователь,
			Перечисления.МП_ТипыНастроекПользователей.ОграничениеФорматовПередаваемыхФайлов);
			
	КонецЕсли;

	Если ФорматыПередаваемыхФайлов <> ФорматыПередаваемыхФайловПриОткрытии Тогда
		
		РегистрыСведений.МП_НастройкиПользователей.ЗаписатьНастройку(
			ТекущийПользователь,
			Перечисления.МП_ТипыНастроекПользователей.ФорматыПередаваемыхФайлов,
			ФорматыПередаваемыхФайлов);
			
		РегистрыСведений.МП_ИзмененныеНастройкиСинхронизации.ДобавитьЗапись(
			ТекущийПользователь,
			Перечисления.МП_ТипыНастроекПользователей.ФорматыПередаваемыхФайлов);
			
	КонецЕсли;

КонецПроцедуры 

#КонецОбласти

#КонецОбласти

