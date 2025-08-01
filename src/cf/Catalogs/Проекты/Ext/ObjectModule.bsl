﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#Область ОбновлениеКэширующихДанных

// Обрабатывает изменение влияющих данных, формирует очередь обновления кэширующих данных.
//
Процедура ОбработатьИзменениеВлияющихДанных() Экспорт
	
	ВлияющийОбъектМетаданных = "Справочник.Проекты";
	КлючВлияющихДанных = Ссылка;
	
	ЗависимыйОбъектМетаданных = "Справочник.ГруппировкиЗадач";
	ВлияющиеРеквизиты = "Наименование";
	ОбновлениеКэширующихДанных.ОбработатьИзменениеВлияющихДанных(
		ЭтотОбъект,
		ЗависимыйОбъектМетаданных,
		ВлияющийОбъектМетаданных,
		КлючВлияющихДанных,
		ВлияющиеРеквизиты);
	
	ЗависимыйОбъектМетаданных = "Справочник.РеестрыЗадач";
	ВлияющиеРеквизиты = "Наименование";
	ОбновлениеКэширующихДанных.ОбработатьИзменениеВлияющихДанных(
		ЭтотОбъект,
		ЗависимыйОбъектМетаданных,
		ВлияющийОбъектМетаданных,
		КлючВлияющихДанных,
		ВлияющиеРеквизиты);
	
	ЗависимыйОбъектМетаданных = "Документ.Задача";
	ВлияющиеРеквизиты = "ПометкаУдаления, Состояние, Руководитель";
	ОбновлениеКэширующихДанных.ОбработатьИзменениеВлияющихДанных(
		ЭтотОбъект,
		ЗависимыйОбъектМетаданных,
		ВлияющийОбъектМетаданных,
		КлючВлияющихДанных,
		ВлияющиеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда 
		Руководитель = Сотрудники.ОсновнойСотрудникПользователя(
			Пользователи.ТекущийПользователь());
		Состояние = Перечисления.СостоянияПроектов.Инициирован;
		ЕдиницаТрудозатратЗадач = Константы.ОсновнаяЕдиницаТрудозатрат.Получить();
		ЕдиницаДлительностиЗадач = Константы.ОсновнаяЕдиницаДлительности.Получить();
		СписыватьЗатратыНаПроект = Истина;
		СпособПланирования = Перечисления.СпособыПланированияПроекта.ОтДатыНачалаПроекта;
		АвтоматическиРассчитыватьПланПроекта = Истина;
		АвтоматическиОтправлятьПроектныеЗадачиНаИсполнение = Истина;
		
		Если Константы.ИспользоватьГрафикиРаботы.Получить() Тогда 
			ГрафикРаботы = Константы.ОсновнойГрафикРаботы.Получить();
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ВидПроекта) Тогда 
			ВидПроекта = РаботаСПроектами.ПолучитьВидПроектаПоУмолчанию();
		КонецЕсли;	
		
		Если Не ЗначениеЗаполнено(Организация) Тогда
			Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьГрифыДоступа") Тогда
			ГрифДоступа = Константы.ГрифДоступаПоУмолчанию.Получить();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Руководитель) Тогда
			Подразделение = СотрудникиВызовСервера.ПодразделениеСотрудника(Руководитель);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(ДанныеЗаполнения) Тогда
		Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "Тема");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	КОДСобытия.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияДокументооборот.УстановитьДополнительноеСвойствоПредыдущиеЗначенияРеквизитов(ЭтотОбъект);
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если Не Ссылка.Пустая() Тогда
		ПредыдущаяПометкаУдаления = ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ПометкаУдаления;
	КонецЕсли;
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда 
		Если ПометкаУдаления Тогда
			ДополнительныеСвойства.Вставить("НужноПометитьНаУдалениеБизнесСобытия", Истина);
		КонецЕсли;
	КонецЕсли;
	
	ПредыдущийТекущийПланНачало = ТекущийПланНачало;
	ПредыдущийТекущийПланОкончание = ТекущийПланОкончание;
	ПредыдущийСпособПланирования = СпособПланирования;
	ПредыдущийАвтоматическиРассчитыватьПланПроекта = АвтоматическиРассчитыватьПланПроекта;
	
	Если Не Ссылка.Пустая() Тогда
		ПредыдущийТекущийПланНачало = ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ТекущийПланНачало;
		ПредыдущийТекущийПланОкончание = ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.ТекущийПланОкончание;
		ПредыдущийСпособПланирования = ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.СпособПланирования;
		ПредыдущийАвтоматическиРассчитыватьПланПроекта =
			ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.АвтоматическиРассчитыватьПланПроекта;
	КонецЕсли;
	
	Если (ПредыдущийТекущийПланНачало <> ТекущийПланНачало Или ПредыдущийСпособПланирования <> СпособПланирования) 
		И СпособПланирования = Перечисления.СпособыПланированияПроекта.ОтДатыНачалаПроекта Тогда
		ДополнительныеСвойства.Вставить("НужноОбновитьНачалоПроектныхЗадач", Истина);
	КонецЕсли;
	
	Если (ПредыдущийТекущийПланОкончание <> ТекущийПланОкончание Или ПредыдущийСпособПланирования <> СпособПланирования)
		И СпособПланирования = Перечисления.СпособыПланированияПроекта.ОтДатыОкончанияПроекта Тогда
		ДополнительныеСвойства.Вставить("НужноОбновитьОкончаниеПроектныхЗадач", Истина);
	КонецЕсли;
	
	Если ПредыдущийАвтоматическиРассчитыватьПланПроекта = Ложь И АвтоматическиРассчитыватьПланПроекта = Истина Тогда 
		ДополнительныеСвойства.Вставить("НужноОбновитьПланПроекта", Истина);
	КонецЕсли;
	
	Если Не Ссылка.Пустая() Тогда 
		Если Руководитель <> ДополнительныеСвойства.ПредыдущиеЗначенияРеквизитов.Руководитель Тогда 
			ДополнительныеСвойства.Вставить("ЗначениеИзменено", Истина);
		КонецЕсли;
	КонецЕсли;
	
	// Обработка рабочей группы
	СсылкаОбъекта = Ссылка;
	// Установка ссылки нового
	Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
		СсылкаОбъекта = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
			СсылкаНового = Справочники.Проекты.ПолучитьСсылку();
			УстановитьСсылкуНового(СсылкаНового);
			СсылкаОбъекта = СсылкаНового;
		КонецЕсли;
	КонецЕсли;
	
	// Определение дескрипторов для проверки прав при записи рабочей группы.
	Если ДокументооборотПраваДоступаПовтИсп.ВключеноИспользованиеПравДоступа() Тогда
		ДокументооборотПраваДоступа.ОпределитьДескрипторыОбъекта(ЭтотОбъект);
	КонецЕсли;
	
	// Подготовка рабочей группы
	РабочаяГруппа = РегистрыСведений.РабочиеГруппы.ПолучитьУчастниковПоОбъекту(СсылкаОбъекта);
	
	// Добавление автоматических участников из самого объекта
	Если РаботаСРабочимиГруппами.ПоОбъектуВедетсяАвтоматическоеЗаполнениеРабочейГруппы(ЭтотОбъект) Тогда
		
		ДобавитьУчастниковРабочейГруппыВНабор(РабочаяГруппа);
		
	КонецЕсли;
	
	// Добавление участников, переданных "снаружи", например из формы объекта
	Если ДополнительныеСвойства.Свойство("РабочаяГруппаДобавить") Тогда
		
		Для Каждого Эл Из ДополнительныеСвойства.РабочаяГруппаДобавить Цикл
			
			// Добавление участника в итоговую рабочую группу
			Строка = РабочаяГруппа.Добавить();
			Строка.Участник = Эл.Участник;
			Строка.Изменение = Эл.Изменение;
			
		КонецЦикла;
		
		ДополнительныеСвойства.Вставить("ЗначениеИзменено", Истина);
		ДополнительныеСвойства.Вставить("ПроектнаяКомандаИзменена", Истина);
			
	КонецЕсли;		
	
	// Удаление участников, переданных "снаружи", например из формы объекта
	Если ДополнительныеСвойства.Свойство("РабочаяГруппаУдалить") Тогда
		Для Каждого Эл Из ДополнительныеСвойства.РабочаяГруппаУдалить Цикл
			// Поиск удаляемого участника в итоговой рабочей группе
			Для Каждого Эл2 Из РабочаяГруппа Цикл
				Если Эл2.Участник = Эл.Участник И Эл2.Изменение = Эл.Изменение Тогда
					// Удаление участника из итоговой рабочей группы
					РабочаяГруппа.Удалить(Эл2);
					ДополнительныеСвойства.Вставить("ЗначениеИзменено", Истина);
					ДополнительныеСвойства.Вставить("ПроектнаяКомандаИзменена", Истина);
					Прервать;
				КонецЕсли;
			КонецЦикла;	
		КонецЦикла;	
	КонецЕсли;		
	
	// Обработка обязательного заполнения рабочих групп 
	Если РабочаяГруппа.Количество() = 0 Тогда
	
		Если РаботаСРабочимиГруппами.ОбязательноеЗаполнениеРабочихГруппДокументов(ВидПроекта) Тогда
			Строка = РабочаяГруппа.Добавить();
			Строка.Участник = Пользователи.ТекущийПользователь();
		КонецЕсли;
		
	КонецЕсли;	
	
	// Запись итоговой рабочей группы
	РаботаСРабочимиГруппами.ПерезаписатьРабочуюГруппуОбъекта(
		СсылкаОбъекта,
		РабочаяГруппа,
		Ложь, // ОбновитьПрава
		Истина,
		?(ЭтоНовый(), Неопределено, Пользователи.ТекущийПользователь()));
	
	// Установка необходимости обновления прав доступа
	ДополнительныеСвойства.Вставить("ДополнительныеПравообразующиеЗначенияИзменены");
	
	ДополнительныеСвойства.Вставить(
		"ПараметрыОбновленияДанныхКэширующихОбъектов",
		Справочники.Проекты.ЗначенияПараметровОбновленияДанныхКэширующихОбъектов(ЭтотОбъект));
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	// Возможно, выполнена явная регистрация событий при загрузке объекта.
	Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
		Если ДополнительныеСвойства.Свойство("ЭтоНовый") И ДополнительныеСвойства.ЭтоНовый Тогда
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.СозданиеПроекта);			
		Иначе
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ИзменениеПроекта);
		КонецЕсли;	
	КонецЕсли;	
	
	Если ДополнительныеСвойства.Свойство("НужноПометитьНаУдалениеБизнесСобытия") Тогда
		БизнесСобытияВызовСервера.ПометитьНаУдалениеСобытияПоИсточнику(Ссылка);
	КонецЕсли;	
	
	Если ДополнительныеСвойства.Свойство("НужноОбновитьНачалоПроектныхЗадач") Тогда
		ОбновитьНачалоПроектныхЗадач();
	КонецЕсли;

	Если ДополнительныеСвойства.Свойство("НужноОбновитьОкончаниеПроектныхЗадач") Тогда
		ОбновитьОкончаниеПроектныхЗадач();
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("НужноОбновитьПланПроекта") Тогда
		РаботаСПроектами.РассчитатьПланВсегоПроекта(Ссылка);
	КонецЕсли;
	
	Справочники.Проекты.ОбновитьДанныеКэширующихОбъектов(
		ЭтотОбъект, ДополнительныеСвойства.ПараметрыОбновленияДанныхКэширующихОбъектов);
	
	ОбработатьИзменениеВлияющихДанных();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьУчастниковРабочейГруппыВНабор(ТаблицаНабора)
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		ИсходныеРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, 
			"ВидПроекта, Руководитель, Заказчик, Подразделение, ПроектнаяКоманда");
		Если ИсходныеРеквизиты.ВидПроекта = ВидПроекта Тогда
			ДобавитьТолькоНовыхУчастниковРабочейГруппыВНабор(ТаблицаНабора, ИсходныеРеквизиты);	
		Иначе
			ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора);		
		КонецЕсли;
		
	Иначе	
		
		ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьТолькоНовыхУчастниковРабочейГруппыВНабор(ТаблицаНабора, ИсходныеРеквизиты)
	
	// Добавление реквизита Руководитель.
	Если ИсходныеРеквизиты.Руководитель <> Руководитель Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора,
			Руководитель, Истина);
	КонецЕсли;				
		
	// Добавление реквизита Заказчик.
	Если ИсходныеРеквизиты.Заказчик <> Заказчик Тогда
		ЗаказчикКонтейнер = Заказчик;
		Если ТипЗнч(Заказчик) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
			ЗаказчикКонтейнер = Справочники.ПодразделенияКонтейнеры.НайтиСоздатьПодразделениеКонтейнер(
				Заказчик, Перечисления.СпособВключенияСотрудниковПодразделения.ТолькоРуководитель);
		КонецЕсли;
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, ЗаказчикКонтейнер);
	КонецЕсли;				
		
	// Добавление реквизита Подразделение.
	Если ЗначениеЗаполнено(Подразделение) И Подразделение <> ИсходныеРеквизиты.Подразделение Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, 
			Справочники.ПодразделенияКонтейнеры.НайтиСоздатьПодразделениеКонтейнер(
				Подразделение, Перечисления.СпособВключенияСотрудниковПодразделения.ТолькоРуководитель),
			Истина);
	КонецЕсли;				
	
	// Обработка табличной части ПроектнаяКоманда.
	ИсходнаяПроектнаяКоманда = ИсходныеРеквизиты.ПроектнаяКоманда.Выгрузить();
	Для каждого Эл Из ПроектнаяКоманда Цикл
		
		// Поиск в исходной табличной части.
		Найден = Ложь;
		Для каждого Эл2 Из ИсходнаяПроектнаяКоманда Цикл
			Если Эл.Исполнитель = Эл2.Исполнитель Тогда
				Найден = Истина;
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
		
		// Добавление нового участника рабочей группы.
		Если Не Найден Тогда  
			РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Эл.Исполнитель);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры	
	
Процедура ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора)
	
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Руководитель, Истина);
		
	ЗаказчикКонтейнер = Заказчик;
	Если ТипЗнч(Заказчик) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		ЗаказчикКонтейнер = Справочники.ПодразделенияКонтейнеры.НайтиСоздатьПодразделениеКонтейнер(
			Заказчик, Перечисления.СпособВключенияСотрудниковПодразделения.ТолькоРуководитель);
	КонецЕсли;
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, ЗаказчикКонтейнер, Ложь);
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора,
			Справочники.ПодразделенияКонтейнеры.НайтиСоздатьПодразделениеКонтейнер(Подразделение,
				Перечисления.СпособВключенияСотрудниковПодразделения.ТолькоРуководитель),
			Истина);
	КонецЕсли;
	
	// Добавление табличной части ПроектнаяКоманда.
	Для каждого Строка Из ПроектнаяКоманда Цикл
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Строка.Исполнитель, Ложь);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьНачалоПроектныхЗадач()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПроектныеЗадачи.Ссылка
	|ИЗ
	|	Справочник.ПроектныеЗадачи КАК ПроектныеЗадачи
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПроектныеЗадачи.Предшественники КАК ПроектныеЗадачиПредшественники
	|		ПО ПроектныеЗадачи.Ссылка = ПроектныеЗадачиПредшественники.Ссылка
	|ГДЕ
	|	ПроектныеЗадачи.Владелец = &Владелец
	|	И НЕ ПроектныеЗадачи.СуммарнаяЗадача
	|	И ПроектныеЗадачиПредшественники.Ссылка ЕСТЬ NULL 
	|	И НЕ ПроектныеЗадачи.ПометкаУдаления";
	Запрос.УстановитьПараметр("Владелец", Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;	
		
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Предшественники = РаботаСПроектами.ПолучитьВсехПредшественников(Выборка.Ссылка, Ложь);
		Если Предшественники.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;	
		
		ДанныеПроектнойЗадачи = РаботаСПроектами.ПолучитьДанныеПроектнойЗадачи(Выборка.Ссылка);
		
		СтруктураДанных = Новый Структура;
		СтруктураДанных.Вставить("ТекущийПланНачало", ТекущийПланНачало);
		СтруктураДанных.Вставить("ТекущийПланОкончание", 
			РаботаСПроектами.РассчитатьОкончаниеПериода(ДанныеПроектнойЗадачи, 
			ТекущийПланНачало, 
			ДанныеПроектнойЗадачи.ТекущийПланДлительность, 
			ДанныеПроектнойЗадачи.ТекущийПланЕдиницаДлительности));
		РаботаСПроектами.ЗаписатьСрокиПроектнойЗадачи(ДанныеПроектнойЗадачи.Ссылка, СтруктураДанных);
		
	КонецЦикла;
	РаботаСПроектами.РассчитатьПланВсегоПроекта(Ссылка);
	
КонецПроцедуры

Процедура ОбновитьОкончаниеПроектныхЗадач()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПроектныеЗадачи.Ссылка
	|ИЗ
	|	Справочник.ПроектныеЗадачи КАК ПроектныеЗадачи
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПроектныеЗадачи.Предшественники КАК ПроектныеЗадачиПредшественники
	|		ПО ПроектныеЗадачи.Ссылка = ПроектныеЗадачиПредшественники.Предшественник
	|ГДЕ
	|	ПроектныеЗадачи.Владелец = &Владелец
	|	И НЕ ПроектныеЗадачи.СуммарнаяЗадача
	|	И ПроектныеЗадачиПредшественники.Ссылка ЕСТЬ NULL 
	|	И НЕ ПроектныеЗадачи.ПометкаУдаления";
	Запрос.УстановитьПараметр("Владелец", Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Последователи = РаботаСПроектами.ПолучитьВсехПоследователей(Выборка.Ссылка, Ложь);
		Если Последователи.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;
		
		ДанныеПроектнойЗадачи = РаботаСПроектами.ПолучитьДанныеПроектнойЗадачи(Выборка.Ссылка);
		
		СтруктураДанных = Новый Структура;
		СтруктураДанных.Вставить("ТекущийПланОкончание", ТекущийПланОкончание);
		СтруктураДанных.Вставить("ТекущийПланНачало", 
			РаботаСПроектами.РассчитатьНачалоПериода(ДанныеПроектнойЗадачи, 
			ТекущийПланОкончание, 
			ДанныеПроектнойЗадачи.ТекущийПланДлительность, 
			ДанныеПроектнойЗадачи.ТекущийПланЕдиницаДлительности));
		РаботаСПроектами.ЗаписатьСрокиПроектнойЗадачи(ДанныеПроектнойЗадачи.Ссылка, СтруктураДанных);
		
	КонецЦикла;
	РаботаСПроектами.РассчитатьПланВсегоПроекта(Ссылка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ТекущийПланНачало) И ЗначениеЗаполнено(ТекущийПланОкончание) И ТекущийПланНачало > ТекущийПланОкончание Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Дата окончания проекта меньше, чем дата начала.'"),
			ЭтотОбъект,
			"ТекущийПланОкончание",, 
			Отказ);
	КонецЕсли;
	
	КоличествоИсполнителей = ПроектнаяКоманда.Количество();
	Для Инд1 = 0 По КоличествоИсполнителей - 2 Цикл
		Строка1 = ПроектнаяКоманда[Инд1];
		
		Для Инд2 = Инд1+1 По КоличествоИсполнителей - 1 Цикл
			Строка2 = ПроектнаяКоманда[Инд2];
			
			ТекстСообщения = "";
			Если Строка1.Исполнитель = Строка2.Исполнитель Тогда 
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Исполнитель ""%1"" указан дважды в списке проектной команды!'"),
					Строка(Строка1.Исполнитель));
				
			КонецЕсли;
			
			Если ТекстСообщения <> "" Тогда 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"ПроектнаяКоманда[" + Формат(Строка2.НомерСтроки-1, "ЧГ=0") + "].Исполнитель",, 
					Отказ);
			КонецЕсли;	
			
		КонецЦикла;	
	КонецЦикла;	
	
КонецПроцедуры

Процедура ПриЧтенииПредставленийНаСервере() Экспорт
	МультиязычностьСервер.ПриЧтенииПредставленийНаСервере(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли