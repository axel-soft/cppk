﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностьюВидимостью();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПриСозданииНаСервереРедакцииКонфигурации();
	
	
	ЕстьПолныеПрава = Пользователи.ЭтоПолноправныйПользователь();
	Элементы.ОтправитьПоМЭДО.Доступность = Объект.ГотоваКОтправке;
	Если Не ЕстьПолныеПрава Тогда
		Элементы.ГруппаТехническиеДанные.Видимость = Ложь;
	КонецЕсли;
	// Эти поля изменяются только программно:
	Элементы.ГруппаШапка.ТолькоПросмотр = Не ЕстьПолныеПрава;
	Элементы.СообщениеПринято.ТолькоПросмотр = Не ЕстьПолныеПрава;
	
	ЭтоИсходящее = (Объект.Направление = Перечисления.НаправленияСообщенийМЭДО.Исходящее);
	Элементы.Отправлена.Видимость = ЭтоИсходящее;
	Элементы.ГотоваКОтправке.Видимость = ЭтоИсходящее;
	Элементы.ОтправитьПоМЭДО.Видимость = ЭтоИсходящее;
	Элементы.СообщениеПринято.Видимость = Не ЭтоИсходящее;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОбщегоНазначенияДокументооборот.ПоказатьНадписьПометкиУдаления(ЭтотОбъект, ТекущийОбъект.ПометкаУдаления);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Отклик = Новый Структура();
	Отклик.Вставить("ПредметСообщения", Объект.Ссылка);
	Отклик.Вставить("Документ", Объект.Предмет);
	Оповестить("Запись_КвитанцияМЭДО", Отклик, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГотоваКОтправкеПриИзменении(Элемент)
	
	Элементы.ОтправитьПоМЭДО.Доступность = Объект.ГотоваКОтправке;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеКонвертаНажатие(Элемент)
	
	ТекстовыйДокумент = ТекстовыйДокументСДаннымиКонверта(Объект.Ссылка);
	ТекстовыйДокумент.Показать("envelope.ini");
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеСообщенияНажатие(Элемент)
	
	ТекстовыйДокумент = ТекстовыйДокументСДаннымиСообщения(Объект.Ссылка);
	ТекстовыйДокумент.Показать(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщениеПринятоПриИзменении(Элемент)
	
	УправлениеДоступностьюВидимостью();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьПоМЭДО(Команда)
	
	ОчиститьСообщения();
	
	Если Не Объект.ГотоваКОтправке Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Необходимо установить флаг ""Готова к отправке""'"),
			Объект.Ссылка,
			"ГотоваКОтправке",
			"Объект");
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Или Модифицированность Тогда 
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеОтвета = МЭДОКлиент.НовыйЛегкийОтвет();
	МЭДОВызовСервера.ОтправитьИсходящиеКвитанции(
		Объект.Организация,
		ДанныеОтвета,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Ссылка));
	
	МЭДОКлиент.ПоказатьРезультатОтправки(НСтр("ru = 'Квитанция отправлена'"), ДанныеОтвета);
	Прочитать();
	Элементы.ОтправитьПоМЭДО.Доступность = Объект.ГотоваКОтправке;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ТекстовыйДокументСДаннымиСообщения(Квитанция)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	Хранилище = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Квитанция, "ДанныеСообщения");
	Если Хранилище = Неопределено Тогда
		Возврат ТекстовыйДокумент;
	КонецЕсли;
	
	ДвоичныеДанные = Хранилище.Получить();
	Если ДвоичныеДанные = Неопределено Тогда
		Возврат ТекстовыйДокумент;
	КонецЕсли;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	ТекстовыйДокумент.Прочитать(ИмяВременногоФайла, "UTF-8");
	УдалитьФайлы(ИмяВременногоФайла);
	Возврат ТекстовыйДокумент;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТекстовыйДокументСДаннымиКонверта(Квитанция)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	Хранилище = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Квитанция, "ДанныеКонверта");
	Если Хранилище = Неопределено Тогда
		Возврат ТекстовыйДокумент;
	КонецЕсли;
	
	ДвоичныеДанные = Хранилище.Получить();
	Если ДвоичныеДанные = Неопределено Тогда
		Возврат ТекстовыйДокумент;
	КонецЕсли;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("ini");
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	ТекстовыйДокумент.Прочитать(ИмяВременногоФайла, "windows-1251");
	УдалитьФайлы(ИмяВременногоФайла);
	Возврат ТекстовыйДокумент;
	
КонецФункции

&НаКлиенте
Процедура УправлениеДоступностьюВидимостью()
	
	Элементы.КодОшибки.Видимость			= Не Объект.СообщениеПринято;
	Элементы.КомментарийОшибки.Видимость	= Не Объект.СообщениеПринято;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервереРедакцииКонфигурации()
	
	Элементы.Организация.Заголовок = МЭДОПереопределяемый.Организация();
	
КонецПроцедуры

#КонецОбласти