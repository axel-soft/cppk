﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщиеКартинки = РаботаСВиджетами.ОбщиеКартинки();
	Для Каждого ОбщаяКартинка Из ОбщиеКартинки Цикл
		
		Элементы.Картинка.СписокВыбора.Добавить(ОбщаяКартинка);
		
	КонецЦикла;
	Элементы.Картинка.СписокВыбора.СортироватьПоЗначению();
	
	ВсеИсточникиСтрокой = РаботаСВиджетами.ВсеИсточникиСтрокой();
	Для Каждого ИсточникСтрокой Из ВсеИсточникиСтрокой Цикл
		
		Элементы.ИсточникСтрока.СписокВыбора.Добавить(ИсточникСтрокой);
		
	КонецЦикла;
	Элементы.ИсточникСтрока.СписокВыбора.СортироватьПоЗначению();
	
	ОбновитьДоступностьДействия();
	
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТолькоПросмотр = Объект.Предопределенный;
	
	ОбщегоНазначенияДокументооборот.ПоказатьНадписьПометкиУдаления(
		ЭтотОбъект,
		ТекущийОбъект.ПометкаУдаления,
		Элементы.ГруппаПометкаУдаления.Имя);
	
	Элементы.ГруппаПредопределенный.Видимость = Объект.Предопределенный;
	
	КлючСохраненияПоложенияОкна =
		Строка(Элементы.ГруппаПредопределенный.Видимость)
		+ Строка(Элементы.ГруппаПометкаУдаления.Видимость);
	
	ОбновитьДоступностьДействия();
	
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);	
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	МультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъекта(Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
    МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДействиеПриИзменении(Элемент)
	
	
	Объект.ПараметрДействия1 = "";
	Объект.ПараметрДействия2 = "";
	Объект.ИсточникСтрока = "";
	Объект.Источник = Неопределено;
	
	ОбновитьДоступностьДействия();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДоступностьДействия()
	
	ОписаниеДействия = Перечисления.ДействияВиджетов.ОписаниеДействия(Объект.Действие);
	
	Элементы.ПараметрДействия1.Доступность = ОписаниеДействия.КоличествоПараметров >= 1;
	Элементы.ПараметрДействия1.ПодсказкаВвода = ОписаниеДействия.ПодсказкаПараметра1;
	
	Элементы.ПараметрДействия2.Доступность = ОписаниеДействия.КоличествоПараметров >= 2;
	Элементы.ПараметрДействия2.ПодсказкаВвода = ОписаниеДействия.ПодсказкаПараметра2;
	
	Элементы.Источник.Доступность = ОписаниеДействия.ТребуетсяИсточник;
	
	Элементы.ИсточникСтрока.Доступность = ОписаниеДействия.ТребуетсяИсточник;
	Элементы.ИсточникСтрока.ПодсказкаВвода = ОписаниеДействия.ПодсказкаИсточника;
	
КонецПроцедуры

#КонецОбласти