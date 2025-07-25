﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура обновляет наследование настроек прав родителей объектами с учетом иерархии
//  Вызывается при изменении родителя или флажка Наследовать у объекта
//
// Параметры:
//  СсылкаИлиОбъект - Ссылка или Объект,
//                    Неопределено - обновить для всех объектов всех типов,
//                    для которых настраиваются права
//                    Смотри функцию УправлениеДоступомСлужебныйПовтИсп.ВладельцыНастроекПрав()
//
//  ЕстьИзменения   - если производилась запись, устанавливается Истина, иначе не изменяется
//
//  ОбновитьИерархию     - только для внутреннего использования
//  ОбъектыСИзмененниями - только для внутреннего использования
//
Процедура Обновить(Знач СсылкаИлиОбъект = Неопределено, ЕстьИзменения = Неопределено, Знач ОбновитьИерархию = Ложь, Знач ОбъектыСИзмененниями = Неопределено) Экспорт
	
	Если ОбъектыСИзмененниями = Неопределено Тогда
		ОбъектыСИзмененниями = Новый Массив;
		ОбновитьПрава = Истина;
	Иначе
		ОбновитьПрава = Ложь;
	КонецЕсли;
	
	Если СсылкаИлиОбъект = Неопределено Тогда
		ВладельцыНастроекПрав = ВладельцыНастроекПрав(УправлениеДоступомПовтИспДокументооборот.ВозможныеПраваДляНастройкиПравОбъектов());
		Для каждого КлючИЗначение Из ВладельцыНастроекПрав.ПоПолнымИменам Цикл
			ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(КлючИЗначение.Ключ);
			ОбновитьДляВсехОбъектовТаблицы(КлючИЗначение.Ключ, ОбъектМетаданных.Иерархический, ЕстьИзменения, ОбъектыСИзмененниями);
		КонецЦикла;
	Иначе
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(СсылкаИлиОбъект)) Тогда
			Ссылка = СсылкаИлиОбъект;
			Объект = Неопределено;
		Иначе
			Ссылка = УправлениеДоступомДокументооборот.ПолучитьСсылкуОбъекта(СсылкаИлиОбъект);
			Объект = СсылкаИлиОбъект;
		КонецЕсли;
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(СсылкаИлиОбъект));
		ОбновитьДляОбъекта(Ссылка, ОбъектМетаданных.Иерархический, ЕстьИзменения, Истина, ОбъектыСИзмененниями, Объект, ОбновитьИерархию);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьДляВсехОбъектовТаблицы(ТаблицаОбъектов, Иерархический, ЕстьИзменения, ОбъектыСИзмененниями)
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрЗаменить(
	"ВЫБРАТЬ
	|	ТекщаяТаблица.Ссылка
	|ИЗ
	|	ТаблицаОбъектов КАК ТекщаяТаблица",
	"ТаблицаОбъектов",
	ТаблицаОбъектов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбновитьДляОбъекта(Выборка.Ссылка, Иерархический, ЕстьИзменения, Ложь, ОбъектыСИзмененниями);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьДляОбъекта(Ссылка, Иерархический, ЕстьИзменения, СИерархией, ОбъектыСИзмененниями, Объект = Неопределено, ОбновитьИерархию = Ложь)
	
	// Подготовка родителей объекта с настройкой наследования.
	НаборЗаписей = РодителиОбъекта(Ссылка, Иерархический, Объект);
	
	// Проверка изменения состава родителей.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",      Ссылка);
	Запрос.УстановитьПараметр("НовыеЗаписи", НаборЗаписей.Выгрузить());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НовыеЗаписи.Родитель,
	|	НовыеЗаписи.Наследовать
	|ПОМЕСТИТЬ НовыеЗаписи
	|ИЗ
	|	&НовыеЗаписи КАК НовыеЗаписи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтарыеЗаписи.Родитель,
	|	СтарыеЗаписи.Наследовать
	|ПОМЕСТИТЬ СтарыеЗаписи
	|ИЗ
	|	РегистрСведений.НаследованиеНастроекПравОбъектов КАК СтарыеЗаписи
	|ГДЕ
	|	СтарыеЗаписи.Объект = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	СтарыеЗаписи КАК СтарыеЗаписи
	|		ЛЕВОЕ СОЕДИНЕНИЕ НовыеЗаписи КАК НовыеЗаписи
	|		ПО (НовыеЗаписи.Родитель = СтарыеЗаписи.Родитель)
	|			И (НовыеЗаписи.Наследовать = СтарыеЗаписи.Наследовать)
	|ГДЕ
	|	НовыеЗаписи.Родитель ЕСТЬ NULL 
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА
	|ИЗ
	|	НовыеЗаписи КАК НовыеЗаписи
	|		ЛЕВОЕ СОЕДИНЕНИЕ СтарыеЗаписи КАК СтарыеЗаписи
	|		ПО НовыеЗаписи.Родитель = СтарыеЗаписи.Родитель
	|			И НовыеЗаписи.Наследовать = СтарыеЗаписи.Наследовать
	|ГДЕ
	|	СтарыеЗаписи.Родитель ЕСТЬ NULL ";
	СоставРодителейИзменился = НЕ Запрос.Выполнить().Пустой();
	
	Если СоставРодителейИзменился Тогда
		
		НаборЗаписей.Записать();
		ЕстьИзменения = Истина;
		
		Если ОбъектыСИзмененниями.Найти(Ссылка) = Неопределено Тогда
			ОбъектыСИзмененниями.Добавить(Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	Если СИерархией И (СоставРодителейИзменился ИЛИ ОбновитьИерархию)  Тогда
		
		// Обновление объектов в иерархии текущего объекта
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Запрос.Текст = СтрЗаменить(
		"ВЫБРАТЬ
		|	ТаблицаСИерархией.Ссылка
		|ИЗ
		|	ТаблицаОбъектов КАК ТаблицаСИерархией
		|ГДЕ
		|	ТаблицаСИерархией.Ссылка В ИЕРАРХИИ(&Ссылка)
		|	И ТаблицаСИерархией.Ссылка <> &Ссылка",
		"ТаблицаОбъектов",
		Ссылка.Метаданные().ПолноеИмя());
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ОбновитьДляОбъекта(Выборка.Ссылка, Иерархический, ЕстьИзменения, Ложь, ОбъектыСИзмененниями, Объект);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция РодителиОбъекта(Ссылка, Иерархический, Объект = Неопределено)
	
	Если Объект = Неопределено Тогда
		СсылкаОбъекта = Неопределено;
		
	ИначеЕсли ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СсылкаОбъекта = Объект.Ссылка;
	Иначе
		СсылкаОбъекта = Объект.ПолучитьСсылкуНового();
	КонецЕсли;
	
	// Получение флажка наследования настроек прав родителей объектом.
	Если Объект = Неопределено
	 ИЛИ ЗначениеЗаполнено(Объект.Ссылка)
	 ИЛИ Ссылка <> СсылкаОбъекта Тогда
		
		Наследовать = ПолучитьСвойствоНаследование(Ссылка);
	Иначе
		Наследовать = Истина;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.НаследованиеНастроекПравОбъектов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(Ссылка);
	
	ТекущийРодитель = Ссылка;
	ЗначениеНаследованияПредыдущегоРодителя = Неопределено;
	
	Пока ЗначениеЗаполнено(ТекущийРодитель) Цикл
		
		Запись = НаборЗаписей.Добавить();
		Запись.Объект      = Ссылка;
		Запись.Родитель    = ТекущийРодитель;
		Запись.Наследовать = Наследовать;
		
		Если НЕ Иерархический Тогда
			Прервать;
		КонецЕсли;
		
		// Настройки ближнего родителя всегда наследуются.
		// Настройки остальных родителей наследуются в зависимости
		// от наличия наследования всех предыдущих родителей.
		
		Если ТекущийРодитель = Ссылка Тогда
			// Следующий родитель ближний.
			Наследовать = Истина;
		Иначе
			// Следующий родитель не ближний.
			Наследовать = Наследовать И ЗначениеНаследованияПредыдущегоРодителя;
		КонецЕсли;
		
		Если Объект <> Неопределено И ТекущийРодитель = СсылкаОбъекта Тогда
			// Когда задан объект, тогда следующий родитель извлекается из объекта,
			// а не из базы данных.
			ТекущийРодитель = Объект.Родитель;
			
			ЗначениеНаследованияПредыдущегоРодителя
				= ПолучитьСвойствоНаследование(ТекущийРодитель);
		Иначе
			СвойстваРодителя = ПолучитьСвойстваРодителяСсылки(ТекущийРодитель);
			ТекущийРодитель                         = СвойстваРодителя.Родитель;
			ЗначениеНаследованияПредыдущегоРодителя = СвойстваРодителя.Наследовать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НаборЗаписей;
	
КонецФункции

Функция ПолучитьСвойствоНаследование(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Родители.Наследовать
	|ИЗ
	|	РегистрСведений.НаследованиеНастроекПравОбъектов КАК Родители
	|ГДЕ
	|	Родители.Объект = &Ссылка
	|	И Родители.Родитель = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат ?(Выборка.Следующий(), Выборка.Наследовать, Истина);
	
КонецФункции

Функция ПолучитьСвойстваРодителяСсылки(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = СтрЗаменить(
	"ВЫБРАТЬ
	|	ТекущаяТаблица.Родитель
	|ПОМЕСТИТЬ РодительСсылки
	|ИЗ
	|	ТаблицаОбъектов КАК ТекущаяТаблица
	|ГДЕ
	|	ТекущаяТаблица.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РодительСсылки.Родитель
	|ИЗ
	|	РодительСсылки КАК РодительСсылки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Родители.Наследовать КАК Наследовать
	|ИЗ
	|	РегистрСведений.НаследованиеНастроекПравОбъектов КАК Родители
	|ГДЕ
	|	Родители.Объект В
	|			(ВЫБРАТЬ
	|				РодительСсылки.Родитель
	|			ИЗ
	|				РодительСсылки КАК РодительСсылки)
	|	И Родители.Родитель В
	|			(ВЫБРАТЬ
	|				РодительСсылки.Родитель
	|			ИЗ
	|				РодительСсылки КАК РодительСсылки)",
	"ТаблицаОбъектов",
	Ссылка.Метаданные().ПолноеИмя());
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	Выборка = РезультатыЗапроса[1].Выбрать();
	Родитель = ?(Выборка.Следующий(), Выборка.Родитель, Неопределено);
	
	Выборка = РезультатыЗапроса[2].Выбрать();
	Наследовать = ?(Выборка.Следующий(), Выборка.Наследовать, Истина);
	
	Возврат Новый Структура("Родитель, Наследовать", Родитель, Наследовать);
	
КонецФункции

Функция ВладельцыНастроекПрав(ВозможныеПрава)
	
	ПоТипам        = Новый Соответствие;
	ПоТипамСсылок  = Новый Соответствие;
	ПоПолнымИменам = Новый Соответствие;
	
	Для каждого ВозможноеПраво Из ВозможныеПрава Цикл
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ВозможноеПраво.ВладелецПрав);
		ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
		ТипСсылки = СтандартныеПодсистемыСервер.ТипСсылкиИлиКлючаЗаписиОбъектаМетаданных(ОбъектМетаданных);
		// Добавление таблицы
		ПоПолнымИменам.Вставить(ПолноеИмя, ТипСсылки);
		// Добавление типа ссылки
		ПоТипам.Вставить(ТипСсылки, ПолноеИмя);
		ПоТипамСсылок.Вставить(ТипСсылки, ПолноеИмя);
		// Добавление типа объекта
		ПоТипам.Вставить(СтандартныеПодсистемыСервер.ТипОбъектаИлиНабораЗаписейОбъектаМетаданных(ОбъектМетаданных), ПолноеИмя);
	КонецЦикла;
	
	Возврат Новый Структура("ПоТипам, ПоПолнымИменам, ПоТипамСсылок", ПоТипам, ПоПолнымИменам, ПоТипамСсылок);
	
КонецФункции

#КонецОбласти

#КонецЕсли
