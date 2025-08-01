﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ПредыдущиеЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
			"ПометкаУдаления");
	Иначе
		ПредыдущиеЗначенияРеквизитов = Новый Структура(
			"ПометкаУдаления",
			Ложь);
	КонецЕсли;
	
	// Пометка на удаление приложенных файлов.
	Если ПометкаУдаления <> ПредыдущиеЗначенияРеквизитов.ПометкаУдаления Тогда 
		РаботаСФайламиВызовСервера.ПометитьНаУдалениеПриложенныеФайлы(Ссылка, ПометкаУдаления);
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		ФоновыеЗадания.Выполнить(
			"РаботаСОбращениями.ПометитьНаУдалениеНеактуальныеВыгрузкиССТУ",
			, , НСтр("ru = 'Удаление старых выгрузок в ССТУ'"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный = Сотрудники.ОсновнойСотрудник();
	Выгружена = Ложь;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ВыгрузкаВССТУ.УстановитьСнятьПризнакГотовности(Обращения.ВыгрузитьКолонку("Обращение"), Ложь);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли