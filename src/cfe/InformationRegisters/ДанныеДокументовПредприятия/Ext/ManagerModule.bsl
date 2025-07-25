﻿
&ИзменениеИКонтроль("ЗаписатьРеквизитыДокумента")
Процедура ЦППК_ЗаписатьРеквизитыДокумента(Документ)

	УстановитьПривилегированныйРежим(Истина);

	ДатаСортировки = Делопроизводство.ДатаУчетаДокумента(Документ);

	КонтрагентыДляСписков = "";
	Если ТипЗнч(Документ.Ссылка) = Тип("СправочникСсылка.ДокументыПредприятия") Тогда
		КонтрагентыДляСписков = Делопроизводство.ПолучитьКонтрагентовДляСписков(
		Документ.Контрагенты.Выгрузить(), "Контрагент", ДатаСортировки);
	КонецЕсли;

	РегистрационныйНомерИДата = "";
	Если ЗначениеЗаполнено(Документ.РегистрационныйНомер)
		И ЗначениеЗаполнено(Документ.ДатаРегистрации) Тогда
		РегистрационныйНомерИДата =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 от %2'"),
		СокрЛП(Документ.РегистрационныйНомер),
		Формат(Документ.ДатаРегистрации, "ДЛФ=D"));
	КонецЕсли;

	ВидКорреспонденции = Перечисления.ВидыКорреспонденции.ПустаяСсылка();
	ВидДокумента = Документ.ВидДокумента;
	РеквВида = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидДокумента, 
	"ЯвляетсяВходящейКорреспонденцией, ЯвляетсяИсходящейКорреспонденцией, ЯвляетсяКомплектомДокументов");

	Если РеквВида.ЯвляетсяВходящейКорреспонденцией = Истина Тогда

		ВидКорреспонденции = Перечисления.ВидыКорреспонденции.Входящая;

	ИначеЕсли РеквВида.ЯвляетсяИсходящейКорреспонденцией Тогда

		ВидКорреспонденции = Перечисления.ВидыКорреспонденции.Исходящая;

	КонецЕсли;	

	// Запись в регистры ДанныеДокументов	
	НаборЗаписей = РегистрыСведений.ДанныеДокументовПредприятия.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ.Ссылка);
	НаборЗаписей.Прочитать();

	Если НаборЗаписей.Количество() > 0 Тогда
		ЗаписьРегистра = НаборЗаписей[0];
	Иначе
		ЗаписьРегистра = НаборЗаписей.Добавить();
	КонецЕсли;

	ЗаполнитьЗначенияСвойств(ЗаписьРегистра, Документ);
	ЗаписьРегистра.Документ = Документ.Ссылка;
	ЗаписьРегистра.ДатаСортировки = ДатаСортировки;
	ЗаписьРегистра.РегистрационныйНомерИДата = РегистрационныйНомерИДата;
	ЗаписьРегистра.КонтрагентыДляСписков = КонтрагентыДляСписков;

	ЗаписьРегистра.ВидКорреспонденции = ВидКорреспонденции;
	ЗаписьРегистра.ЯвляетсяКомплектомДокументов = РеквВида.ЯвляетсяКомплектомДокументов;      

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
		Если Документ.Стороны.Количество() Тогда
			ЗаписьРегистра["Сторона2"] = Документ.Стороны[0].Сторона;
		КонецЕсли;
	Иначе
		Для Н = 1 По 2 Цикл
			Если Документ.Стороны.Количество() >= Н Тогда
				ЗаписьРегистра["Сторона" + Н] = Документ.Стороны[Н - 1].Сторона;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	#Вставка     
	//  Котляров 15.07.2025 QR-7984582-1 САНФ-035150
	//  Запись Способа отправки в реквизит Регистра СпособПолучения.
	Если ЗаписьРегистра.ВидКорреспонденции = Перечисления.ВидыКорреспонденции.Исходящая Тогда
		ЗаписьРегистра.СпособПолучения  = СпособОтправкиДокумента(Документ);
	КонецЕсли;
	#КонецВставки

	НаборЗаписей.Записать();

КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  Документ  - СправочникСсылка.ДокументыПредприятия - ДокОснование
// Возвращаемое значение:
//   СправочникСсылка.СпособыДоставки.СпособыДоставки - Способ доставки
//
Функция СпособОтправкиДокумента(Документ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	КорреспонденцияКорреспонденты.СпособОтправки КАК СпособОтправки
		|ИЗ
		|	Документ.Корреспонденция.Корреспонденты КАК КорреспонденцияКорреспонденты
		|ГДЕ
		|	КорреспонденцияКорреспонденты.Ссылка.Основание = &Документ";
	
	Запрос.УстановитьПараметр("Документ", Документ.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.СпособОтправки;
	КонецЦикла;
	
	Возврат Справочники.СпособыДоставки.ПустаяСсылка();

КонецФункции // СпособОтправкиДокумента()

