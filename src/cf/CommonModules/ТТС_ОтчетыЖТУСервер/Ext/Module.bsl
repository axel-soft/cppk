﻿Функция ПолучитьГрафыОтчетовПоКодуНарушения(КодНарушения, ЯвляетсяНарушением) Экспорт
	МакетСоответствий = Справочники.ТТС_ГрафыОтчетов.ПолучитьМакет("ГрафыПоКодамНарушений");
	
	МассивГраф = Новый Массив;
	СоответствиеГраф = Новый Соответствие;	
	
	Для Каждого ЗначенияПеречисленияОтчетыПоЖурналамТУ Из Метаданные.Перечисления.ТТС_ОтчетыПоЖурналамТУ.ЗначенияПеречисления Цикл
		
		ОбластьЖурнала = МакетСоответствий.ПолучитьОбласть(ЗначенияПеречисленияОтчетыПоЖурналамТУ.Имя);
		ОтчетПоЖурналам = Перечисления.ТТС_ОтчетыПоЖурналамТУ[ЗначенияПеречисленияОтчетыПоЖурналамТУ.Имя];
		
		Если ОтчетПоЖурналам = Перечисления.ТТС_ОтчетыПоЖурналамТУ.ОтчетПоНарушениям И НЕ ЯвляетсяНарушением Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьНачало = ОбластьЖурнала.Область("R1C1");
		ПродолжитьПоиск = Истина;
		Пока ПродолжитьПоиск Цикл
			ОбластьЗначение = ОбластьЖурнала.НайтиТекст(КодНарушения.Код,ОбластьНачало,,,Истина,Истина);
			Если ОбластьЗначение = Неопределено Тогда
				ПродолжитьПоиск =Ложь;
			Иначе
				НомерСтроки = ОбластьЗначение.Верх;
				Графа = ОбластьЖурнала.Область(НомерСтроки,2).Текст;
				ГрафаСсылка = Справочники.ТТС_ГрафыОтчетов[Графа];
				Если СоответствиеГраф.Получить(ОтчетПоЖурналам) = Неопределено Тогда
					СоответствиеГраф.Вставить(ОтчетПоЖурналам, Новый Массив);
				КонецЕсли;
				СоответствиеГраф[ОтчетПоЖурналам].Добавить(ГрафаСсылка);
				//МассивГраф.Добавить(Графа);
				ОбластьНачало = ОбластьЖурнала.Область(НомерСтроки+1,1);
				
				ПродолжитьПоиск = НомерСтроки < ОбластьЖурнала.ВысотаТаблицы;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;		
	
	//Возврат ПолучитьСоответствиеГраф(МассивГраф);
	Возврат СоответствиеГраф;
КонецФункции

Функция ПолучитьСоответствиеГраф(МассивГраф) 
	СоответствиеГраф = Новый Соответствие;
	Для Каждого Графа Из МассивГраф Цикл
		ГрафаСсылка = Справочники.ТТС_ГрафыОтчетов[Графа];
		Отчет = ГрафаСсылка.Отчет;
		Если СоответствиеГраф.Получить(Отчет) = Неопределено Тогда
			СоответствиеГраф.Вставить(Отчет, Новый Массив);
		КонецЕсли;
		СоответствиеГраф[Отчет].Добавить(ГрафаСсылка);
	КонецЦикла;
	Возврат СоответствиеГраф;
КонецФункции	

//Функция ПолучитьСоответствиеГрафРекурсивно(Графа, СоответствиеГраф) 	
//	Если Не Графа.Родитель.Пустая() Тогда
//		Отчет = ПолучитьСоответствиеГрафРекурсивно(Графа.Родитель, СоответствиеГраф);
//		Если СоответствиеГраф[Отчет].Найти(Графа) = Неопределено Тогда
//			СоответствиеГраф[Отчет].Добавить(Графа);
//		КонецЕсли;
//		Возврат Отчет;
//	Иначе
//		Если СоответствиеГраф.Получить(Графа) = Неопределено Тогда
//			СоответствиеГраф.Вставить(Графа, Новый Массив);
//		КонецЕсли;	
//		Возврат Графа;
//	КонецЕсли;
//КонецФункции