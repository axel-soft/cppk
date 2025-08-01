﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокВыбора = Элементы.ВерсияФорматаОбменаПоддерживаемая1САрхивом.СписокВыбора;
	СписокВыбора.Очистить();
	ДоступныеЗначения = ОбменСАрхивом.ВерсииФорматаДоступные();
	Для Каждого Эл Из ДоступныеЗначения Цикл
		СписокВыбора.Добавить(Эл.Значение, Эл.Представление);
	КонецЦикла;
	ТекущееЗначениеФормата = НаборКонстант.ВерсияФорматаОбменаПоддерживаемая1САрхивом;
	Если ЗначениеЗаполнено(ТекущееЗначениеФормата)
			И СписокВыбора.НайтиПоЗначению(ТекущееЗначениеФормата) = Неопределено Тогда
		ПредставлениеВерсии = ОбменСАрхивом.ПредставлениеВерсииФормата(ТекущееЗначениеФормата);
		СписокВыбора.Добавить(ТекущееЗначениеФормата, ПредставлениеВерсии);
	КонецЕсли;
	
	ВладелецХранилища = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
		Метаданные.Константы.ИмяПользователя1САрхива);
	УстановитьПривилегированныйРежим(Истина);
	ПарольПользователяВебСервиса = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ВладелецХранилища);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не НаборКонстант.ИнтеграцияС1САрхивом Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьОшибкиКаталогаОбмена = Ложь;
	КаталогИнтеграции = НаборКонстант.КаталогИнтеграцииСАрхивом;
	Если Не ЗначениеЗаполнено(КаталогИнтеграции) Тогда
		ЕстьОшибкиКаталогаОбмена = Истина;
		ТекстОшибки = НСтр("ru = 'Не указан каталог обмена'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,, "НаборКонстант.КаталогИнтеграцииСАрхивом", Отказ);
	Иначе
		СистемнаяИнформация = Новый СистемнаяИнформация;
		Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86 
				Или СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
			Если Лев(КаталогИнтеграции, 2) <> "\\" Или Найти(КаталогИнтеграции, ":") <> 0 Тогда
				ЕстьОшибкиКаталогаОбмена = Истина;
				ТекстОшибки = НСтр("ru = 'Каталог обмена должен быть указан в формате UNC (\\servername\resource)'");
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,, "НаборКонстант.КаталогИнтеграцииСАрхивом", Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЕстьОшибкиКаталогаОбмена Тогда
		КаталогИнтеграцииФайл = Новый Файл(КаталогИнтеграции);
		Если Не КаталогИнтеграцииФайл.Существует() Тогда
			ТекстОшибки = НСтр("ru = 'Каталог не обнаружен'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,, "НаборКонстант.КаталогИнтеграцииСАрхивом", Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НаборКонстант.КодДляОбменаСАрхивом) Тогда
		ТекстОшибки = НСтр("ru = 'Не указан код базы'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,, "НаборКонстант.КодДляОбменаСАрхивом", Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ВладелецХранилища = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
		Метаданные.Константы.ИмяПользователя1САрхива);
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ВладелецХранилища, ПарольПользователяВебСервиса);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("Закрыть") Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнтеграцияС1САрхивомПриИзменении(Элемент)
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогИнтеграцииСАрхивомНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогОткрытия = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытия.МножественныйВыбор = Ложь;
	ДиалогОткрытия.Заголовок = НСтр("ru = 'Выберите каталог'");
	ДиалогОткрытия.Каталог = НаборКонстант.КаталогИнтеграцииСАрхивом;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КаталогИнтеграцииСАрхивомПродолжениеВыбора", ЭтотОбъект);
	ДиалогОткрытия.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогИнтеграцииСАрхивомПродолжениеВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Или Результат.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПапки = Результат[0];
	РазделительПути = ПолучитьРазделительПути();
	ИмяПапки = ИмяПапки + ?(Прав(ИмяПапки, 1) = РазделительПути, "", РазделительПути);
	
	НаборКонстант.КаталогИнтеграцииСАрхивом = ИмяПапки;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогИнтеграцииСАрхивомОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(НаборКонстант.КаталогИнтеграцииСАрхивом) Тогда
		ЗапуститьПриложение(НаборКонстант.КаталогИнтеграцииСАрхивом);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Закрыть", Истина);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВебСервис(Команда)
	
	ЕстьНезаполненныеНастройки = Ложь;
	Если Не ЗначениеЗаполнено(НаборКонстант.АдресПубликации1САрхива) Тогда
		ЕстьНезаполненныеНастройки = Истина;
		ТекстОшибки = НСтр("ru = 'Не указан адрес публикации'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки,,, "НаборКонстант.АдресПубликации1САрхива");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НаборКонстант.ИмяПользователя1САрхива) Тогда
		ЕстьНезаполненныеНастройки = Истина;
		ТекстОшибки = НСтр("ru = 'Не указано имя пользователя'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки,,, "НаборКонстант.ИмяПользователя1САрхива");
	КонецЕсли;
	
	Если ЕстьНезаполненныеНастройки Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		ПроверитьВебСервисНаСервере();
		ПоказатьПредупреждение(, НСтр("ru = 'Подключение выполнено'"));
	Исключение
		ТекстОшибки = НСтр("ru = 'Подключение не выполнено. Проверьте адрес, имя пользователя и пароль.'")
			+ Символы.ПС + Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступность()
	
	Элементы.ГруппаСдвигВправо.Доступность = НаборКонстант.ИнтеграцияС1САрхивом;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьВебСервисНаСервере()
	
	АдресПубликации = НаборКонстант.АдресПубликации1САрхива;
	ИмяПользователя = НаборКонстант.ИмяПользователя1САрхива;
	Пароль = ПарольПользователяВебСервиса;
	
	Таймаут = 10;
	Определение = Новый WSОпределения(АдресПубликации + "/ws/ArchiveDocuments.1cws?wsdl", ИмяПользователя, Пароль, Таймаут);
	Прокси = Новый WSПрокси(Определение, "http://www.1c.ru/docmng", "ArchiveDocuments", "ArchiveDocumentsSoap");
	
КонецПроцедуры

#КонецОбласти
