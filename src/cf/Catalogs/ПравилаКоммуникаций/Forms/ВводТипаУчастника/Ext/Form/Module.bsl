﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Имена = ОбщегоНазначенияДокументооборот.ИменаРеквизитовФормы(ЭтотОбъект);
	Для Каждого Имя Из Имена Цикл
		Параметры.Свойство(Имя, ЭтотОбъект[Имя]);
	КонецЦикла;
	КлючНазначенияИспользования = СтрСоединить(Имена, ",");
	
	Если ЗначениеЗаполнено(РольЗначение) Тогда
		Роль = Истина;
	КонецЕсли;
	
	Если Роль Тогда
		Элементы.РольЗначение.АвтоОтметкаНезаполненного = РежимРольТолькоЗначение;
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок; //@skip-check unknown-form-parameter-access
		АвтоЗаголовок = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если Не ЗавершениеРаботы И Модифицированность Тогда
		
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Найстройки были изменены. Сохранить изменения?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РольИсполнителяПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(РольЗначение) И Не Роль Тогда
		Роль = Истина;
		РольПриИзменении(Элементы.Роль);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РольПриИзменении(Элемент)
	
	Если Роль Тогда
		Если РежимРольТолькоЗначение Тогда
			Элементы.РольЗначение.АвтоОтметкаНезаполненного = Истина;
			Сотрудник = Ложь;
			Руководитель = Ложь;
		КонецЕсли;
	Иначе
		РольЗначение = Неопределено;
		Элементы.РольЗначение.АвтоОтметкаНезаполненного = Ложь;
		Элементы.РольЗначение.ОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникРуководительПриИзменении(Элемент)
	
	Если РежимРольТолькоЗначение Тогда
		Роль = Ложь;
		РольПриИзменении(Элемент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)

	Если ТребуетсяЗаполнитьРеквизитРольЗначение() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Необходимо заполнить Роль'"), 2);
		Возврат;
	КонецЕсли;
	
	СохранитьИзменения();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ТребуетсяЗаполнитьРеквизитРольЗначение()
	
	Возврат
		Роль И Элементы.РольЗначение.АвтоОтметкаНезаполненного = Истина
				И Не ЗначениеЗаполнено(РольЗначение);
	
КонецФункции

&НаКлиенте
Процедура СохранитьИзменения()
	
	Модифицированность = Ложь;
	
	Значения = Новый Структура(КлючНазначенияИспользования);
	ЗаполнитьЗначенияСвойств(Значения, ЭтотОбъект);
	ОповеститьОВыборе(Значения);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если ТребуетсяЗаполнитьРеквизитРольЗначение() Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Необходимо заполнить Роль'"), 2);
			Возврат;
		КонецЕсли;
		
		СохранитьИзменения();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
