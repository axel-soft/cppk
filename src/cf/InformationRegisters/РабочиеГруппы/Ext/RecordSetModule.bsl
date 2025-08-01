﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

//@skip-warning
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если (ОбменДанными.Загрузка
				Или ПараметрыСеанса.ЗагрузкаОбработанныхДанныхИзДругойСистемы)
			И ДокументооборотПраваДоступаПовтИсп.ВключеноИспользованиеПравДоступа() Тогда
		
		РегистрыСведений.РабочиеГруппы.ОпределитьДескрипторыПриЗаписиРабочейГруппы(ЭтотОбъект, Отказ, Замещение);
		
		Возврат;
	КонецЕсли;
	
	ОбъектОтбора = Отбор.Объект.Значение;
	Если ЗначениеЗаполнено(ОбъектОтбора) И ОбщегоНазначения.ЭтоБизнесПроцесс(ОбъектОтбора.Метаданные()) Тогда
		
		// Запись в РС УчастникиПроцессов
		НаборИзменен = Ложь;
		ТаблицаНабора = РегистрыСведений.УчастникиПроцессов.ПолучитьУчастников(ОбъектОтбора);
		СтруктураПоиска = Новый Структура("Участник");
		
		Для Каждого СтрокаРГ Из ЭтотОбъект Цикл
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаРГ);
			НайденныеСтроки = ТаблицаНабора.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() = 0 Тогда
				НаборИзменен = Истина;
				НоваяСтрока = ТаблицаНабора.Добавить();
				НоваяСтрока.Участник = СтрокаРГ.Участник;
				НоваяСтрока.Процесс = СтрокаРГ.Объект;
			КонецЕсли;
		КонецЦикла;
		
		Если НаборИзменен Тогда
			РегистрыСведений.УчастникиПроцессов.ЗаписатьНаборПоПроцессу(ОбъектОтбора, ТаблицаНабора);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли