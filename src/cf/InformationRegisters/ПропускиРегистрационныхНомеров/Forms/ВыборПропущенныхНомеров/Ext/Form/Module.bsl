﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Документ = Параметры.Документ.Ссылка;
	ЗаголовокДокумента = Параметры.Документ.Заголовок;
	
	Если Параметры.Свойство("Нумератор") И ЗначениеЗаполнено(Параметры.Нумератор) Тогда 
		Нумератор = Параметры.Нумератор;
	Иначе 
		Нумератор = Нумерация.ПолучитьНумераторДокумента(Параметры.Документ);
	КонецЕсли;
	
	Если Не Нумерация.ИспользуютсяПропущенныеНомера(Нумератор) Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("СтруктураПараметровНумерации") 
		И ЗначениеЗаполнено(Параметры.СтруктураПараметровНумерации) Тогда 
		СтруктураПараметровНумерации = Параметры.СтруктураПараметровНумерации;
	Иначе 
		СтруктураПараметровНумерации = НумерацияКлиентСервер.ПолучитьПараметрыНумерации(
			Параметры.Документ);
	КонецЕсли;

	Если Не Параметры.Свойство("ПропущенныеНомера") Тогда
		ПропущенныеНомера = РегистрыСведений.ПропускиРегистрационныхНомеров.ТаблицаПропущенныхНомеров(
			Нумератор, СтруктураПараметровНумерации);
	Иначе
		ПропущенныеНомера = Параметры.ПропущенныеНомера;
	КонецЕсли;
		
	Для Н = 1 По Мин(ПропущенныеНомера.Количество(), 5) Цикл
		НоваяСтрока = ТаблицаПропущенныхНомеров.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПропущенныеНомера[Н-1]);
		
		Элементы["КомандаНомер" + СокрЛП(Н)].Видимость = Истина;
		Элементы["КомандаНомер" + СокрЛП(Н)].Заголовок = СокрЛП(НоваяСтрока.ПропущенныйНомер);
	КонецЦикла;
	
	КлючСохраненияПоложенияОкна = Строка(ТаблицаПропущенныхНомеров.Количество())+"ПропущенныхНомеров";
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТаблицаПропущенныхНомеров.Количество() = 0 Тогда 
		ПодключитьОбработчикОжидания("ЗакрытьФормуСНовымНомером", 0.01, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НовыйНомер(Команда)
	
	ЗакрытьФормуСНовымНомером();
	
КонецПроцедуры

&НаКлиенте
Процедура Номер1(Команда)
	
	НажатиеНомера();
	
КонецПроцедуры

&НаКлиенте
Процедура Номер2(Команда)
	
	НажатиеНомера();
	
КонецПроцедуры

&НаКлиенте
Процедура Номер3(Команда)
	
	НажатиеНомера();
	
КонецПроцедуры

&НаКлиенте
Процедура Номер4(Команда)
	
	НажатиеНомера();
	
КонецПроцедуры

&НаКлиенте
Процедура Номер5(Команда)
	
	НажатиеНомера();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗакрытьФормуСНовымНомером()
	
	Структура = СтруктураРезультата();
	Структура.Документ = Документ;
	
	Закрыть(Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура НажатиеНомера()
	
	РегНомер = Число(ТекущийЭлемент.Заголовок);
	
	СтрокиПоиска = ТаблицаПропущенныхНомеров.НайтиСтроки(Новый Структура("ПропущенныйНомер", РегНомер));
	
	Если СтрокиПоиска.Количество() > 0 Тогда 
		
		Строка = СтрокиПоиска[0];
		
		Структура = СтруктураРезультата();
		ЗаполнитьЗначенияСвойств(Структура, Строка);
		Структура.Документ = Документ;
		
		Закрыть(Структура);
	Иначе 
		ПоказатьПредупреждение(, СтрШаблон(НСтр("ru = 'Не удалось найти нужный пропущенный номер: %1'"), РегНомер));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СтруктураРезультата()
	
	Возврат Новый Структура("ВидДокумента, ВопросДеятельности, Организация, Подразделение, Проект,
		| СвязанныйДокумент, Нумератор, ПериодНумерации, ПропущенныйНомер, ДатаФиксации, ГрифДоступа,
		| Автор, Тематика, Документ, УзелКОД");

КонецФункции

#КонецОбласти
