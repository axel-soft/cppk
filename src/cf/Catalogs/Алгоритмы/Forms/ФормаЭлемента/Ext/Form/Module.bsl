﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоПросмотр = Объект.Предопределенный;
	Элементы.ПояснениеПредопределенного.Видимость = Объект.Предопределенный;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.КлючДляВызова.ОтображениеПредупрежденияПриРедактировании =
			ОтображениеПредупрежденияПриРедактировании.НеОтображать;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ОбщегоНазначенияДокументооборот.ПоказатьНадписьПометкиУдаления(
		ЭтотОбъект, ТекущийОбъект.ПометкаУдаления);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенятьКлючАвтоматически = Не ЗначениеЗаполнено(Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если МенятьКлючАвтоматически Тогда
		Объект.КлючДляВызова = АвтоКлючПоНаименованию(Объект.Наименование);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КлючДляВызоваПриИзменении(Элемент)
	
	МенятьКлючАвтоматически = Объект.КлючДляВызова = АвтоКлючПоНаименованию(Объект.Наименование);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция АвтоКлючПоНаименованию(Наименование)
	
	АвтоКлюч = "";
	
	Подстроки = СтрРазделить(Наименование, " ");
	Для Каждого Подстрока Из Подстроки Цикл
		АвтоКлюч = АвтоКлюч + ВРег(Лев(Подстрока, 1)) + Сред(Подстрока, 2);
	КонецЦикла;
	
	Возврат АвтоКлюч;
	
КонецФункции

#КонецОбласти
