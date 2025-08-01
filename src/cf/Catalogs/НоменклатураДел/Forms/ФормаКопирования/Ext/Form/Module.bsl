﻿
//////////////////////////////////////////////////////////////////////////////// 
// ПРОЦЕДУРЫ И ФУНКЦИИ 
// 

&НаКлиенте
Процедура ПометитьПодчиненные(ЭлементДерева, Пометка)
	
	Если ЭлементДерева = Неопределено Тогда 
		Для Каждого ПодчиненныйЭлемент Из Дерево.ПолучитьЭлементы() Цикл
			ПометитьПодчиненные(ПодчиненныйЭлемент, Пометка);
		КонецЦикла;	
	Иначе
		ЭлементДерева.Пометка = Пометка;
		Для Каждого ПодчиненныйЭлемент Из ЭлементДерева.ПолучитьЭлементы() Цикл
			ПометитьПодчиненные(ПодчиненныйЭлемент, Пометка);
		КонецЦикла;	
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура КопироватьПодчиненные(СтрокаДерева, ТаблНоменклатуры, ТаблРазделы)

	Если Не СтрокаДерева.Пометка Тогда
		Возврат;
	КонецЕсли;	
	
	Если ТипЗнч(СтрокаДерева.Ссылка) = Тип("СправочникСсылка.РазделыНоменклатурыДел") Тогда // раздел
		
		Если СтрокаДерева.Родитель = Неопределено Тогда 
			НовыйРаздел = Справочники.РазделыНоменклатурыДел.ПустаяСсылка();
		Иначе	
			НовыйРаздел = СтрокаДерева.Родитель.НоваяСсылка;
		КонецЕсли;	
			
		ИсходныйЭлемент = СтрокаДерева.Ссылка.ПолучитьОбъект();
			
		НайденнаяСтрока = ТаблРазделы.Найти(ИсходныйЭлемент.Индекс, "Индекс");
		Если НайденнаяСтрока = Неопределено Тогда 
			НовыйЭлемент = Справочники.РазделыНоменклатурыДел.СоздатьЭлемент();
		Иначе
			НовыйЭлемент = НайденнаяСтрока.Ссылка.ПолучитьОбъект();
		КонецЕсли;	
		
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, ИсходныйЭлемент, , "Код, Год, Владелец, Родитель");
		НовыйЭлемент.Родитель = НовыйРаздел;
		НовыйЭлемент.Год = КопироватьВГод;
		НовыйЭлемент.Организация = ВОрганизацию;
		НовыйЭлемент.Записать();
		
		СтрокаДерева.НоваяСсылка = НовыйЭлемент.Ссылка;
		
		Для Каждого ПодчиненнаяСтрока Из СтрокаДерева.Строки Цикл
			КопироватьПодчиненные(ПодчиненнаяСтрока, ТаблНоменклатуры, ТаблРазделы);
		КонецЦикла;	
		
	Иначе // элемент
		
		Если СтрокаДерева.Родитель = Неопределено Тогда 
			НовыйРаздел = Справочники.РазделыНоменклатурыДел.ПустаяСсылка();
		Иначе	
			НовыйРаздел = СтрокаДерева.Родитель.НоваяСсылка;
		КонецЕсли;
		
		ИсходныйЭлемент = СтрокаДерева.Ссылка.ПолучитьОбъект();
			
		НайденнаяСтрока = ТаблНоменклатуры.Найти(ИсходныйЭлемент.Индекс, "Индекс");
		Если НайденнаяСтрока = Неопределено Тогда 
			НовыйЭлемент = Справочники.НоменклатураДел.СоздатьЭлемент();
		Иначе
			НовыйЭлемент = НайденнаяСтрока.Ссылка.ПолучитьОбъект();
		КонецЕсли;	
		
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, ИсходныйЭлемент, , "Код, Наименование, Год, Владелец, Раздел");
		НовыйЭлемент.Раздел = НовыйРаздел;
		НовыйЭлемент.Год = КопироватьВГод;
		НовыйЭлемент.Организация = ВОрганизацию;
		НовыйЭлемент.ВидыДокументов.Загрузить(ИсходныйЭлемент.ВидыДокументов.Выгрузить());
		НовыйЭлемент.Контрагенты.Загрузить(ИсходныйЭлемент.Контрагенты.Выгрузить());
		НовыйЭлемент.ВопросыДеятельности.Загрузить(ИсходныйЭлемент.ВопросыДеятельности.Выгрузить());
		НовыйЭлемент.Записать();
		
		Если Не НовыйЭлемент.ЭтоГруппа Тогда 
			УстановитьПривилегированныйРежим(Истина);
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	Дела.Ссылка
				|ИЗ
				|	Справочник.ДелаХраненияДокументов КАК Дела
				|ГДЕ
				|	НЕ Дела.ПометкаУдаления
				|	И НЕ Дела.ДелоЗакрыто
				|	И Дела.НоменклатураДел.Индекс = &Индекс
				|	И Дела.Организация = &Организация
				|	И (Дела.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
				|			ИЛИ Дела.ДатаОкончания <> ДАТАВРЕМЯ(1, 1, 1)
				|				И ГОД(Дела.ДатаОкончания) >= &Год)";
			
			Запрос.УстановитьПараметр("Индекс", ИсходныйЭлемент.Индекс);
			Запрос.УстановитьПараметр("Организация", ВОрганизацию);
			Запрос.УстановитьПараметр("Год", КопироватьВГод);
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
				ДелоОбъект = Выборка.Ссылка.ПолучитьОбъект();
				
				НоваяСтрока = ДелоОбъект.ОтноситсяКНоменклатуреДел.Добавить();
				НоваяСтрока.НоменклатураДел = НовыйЭлемент.Ссылка;
				
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДелоОбъект);
				РазблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура СкопироватьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НоменклатураДел.Ссылка,
	|	НоменклатураДел.Индекс
	|ИЗ
	|	Справочник.НоменклатураДел КАК НоменклатураДел
	|ГДЕ
	|	НоменклатураДел.Год = &Год
	|	И (НоменклатураДел.Организация = &Организация
	|			ИЛИ &ИспользоватьУчетПоОрганизациям = ЛОЖЬ)";
	Запрос.УстановитьПараметр("Год", КопироватьВГод);
	Запрос.УстановитьПараметр("Организация", ВОрганизацию);
	Запрос.УстановитьПараметр("ИспользоватьУчетПоОрганизациям", ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям"));
	ТаблНоменклатуры = Запрос.Выполнить().Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РазделыНоменклатурыДел.Ссылка,
	|	РазделыНоменклатурыДел.Индекс
	|ИЗ
	|	Справочник.РазделыНоменклатурыДел КАК РазделыНоменклатурыДел
	|ГДЕ
	|	РазделыНоменклатурыДел.Год = &Год
	|	И (РазделыНоменклатурыДел.Организация = &Организация
	|			ИЛИ &ИспользоватьУчетПоОрганизациям = ЛОЖЬ)";
	Запрос.УстановитьПараметр("Год", КопироватьВГод);
	Запрос.УстановитьПараметр("Организация", ВОрганизацию);
	Запрос.УстановитьПараметр("ИспользоватьУчетПоОрганизациям", ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям"));
	ТаблРазделы = Запрос.Выполнить().Выгрузить();
	
	ДеревоЗнч = РеквизитФормыВЗначение("Дерево");
	ДеревоЗнч.Колонки.Добавить("НоваяСсылка");
	
	НачатьТранзакцию();
	Попытка
	
		Для Каждого ПодчиненнаяСтрока Из ДеревоЗнч.Строки Цикл
			КопироватьПодчиненные(ПодчиненнаяСтрока, ТаблНоменклатуры, ТаблРазделы);
		КонецЦикла;	
	
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры	

&НаСервере
Процедура СкопироватьВместеСПодчиненными(КудаКопируем, ОткудаКопируем)
    
    Для Каждого Строка Из ОткудаКопируем.Строки Цикл
        НоваяСтрока = КудаКопируем.Строки.Добавить();
        ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		
		СкопироватьВместеСПодчиненными(НоваяСтрока, Строка);
    КонецЦикла;
    
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДерево()
	
	ДеревоЗнч = РеквизитФормыВЗначение("Дерево");
	ДеревоЗнч.Строки.Очистить();
	
	Отбор = Новый Структура("Год", КопироватьИзГод);
	Выборка = Справочники.РазделыНоменклатурыДел.ВыбратьИерархически(,, Отбор, "Индекс Возр");
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(ИзОрганизации) И Выборка.Организация <> ИзОрганизации Тогда
			Продолжить;
		КонецЕсли;
		
		Родитель = Выборка.Родитель;
		Если Родитель.Пустая() Тогда
			СтрокаРодитель = ДеревоЗнч;
		Иначе
			СтрокаРодитель = ДеревоЗнч.Строки.Найти(Родитель, "Ссылка", Истина);
		КонецЕсли;	
		
		НоваяСтрока = СтрокаРодитель.Строки.Добавить();
		НоваяСтрока.Ссылка = Выборка.Ссылка;
		НоваяСтрока.Наименование = Выборка.Наименование;
		НоваяСтрока.Индекс = Выборка.Индекс;
		НоваяСтрока.Пометка = Истина;
	КонецЦикла;
	
	Отбор = Новый Структура("Год", КопироватьИзГод);
	Выборка = Справочники.НоменклатураДел.Выбрать(,, Отбор, "Индекс Возр");
	Пока Выборка.Следующий() Цикл
		Если Выборка.ПометкаУдаления Тогда 
			Продолжить;
		КонецЕсли;	
		Если ЗначениеЗаполнено(ИзОрганизации) И Выборка.Организация <> ИзОрганизации Тогда
			Продолжить;
		КонецЕсли;
		
		Если Выборка.Раздел.Пустая() Тогда
			СтрокаРодитель = ДеревоЗнч;
		Иначе
			СтрокаРодитель = ДеревоЗнч.Строки.Найти(Выборка.Раздел, "Ссылка", Истина);
		КонецЕсли;	
		
		Если СтрокаРодитель <> Неопределено Тогда 
			НоваяСтрока = СтрокаРодитель.Строки.Добавить();
			НоваяСтрока.Ссылка = Выборка.Ссылка;
			НоваяСтрока.Наименование = Выборка.Наименование;
			НоваяСтрока.Индекс = Выборка.Индекс;
			НоваяСтрока.Пометка = Истина;
		КонецЕсли;	
	КонецЦикла;	
	
	ЗначениеВРеквизитФормы(ДеревоЗнч, "Дерево");
	
КонецПроцедуры	


//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
// 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПриСозданииНаСервереРедакцииКонфигурации();	
	
	Если ЗначениеЗаполнено(Параметры.Год) Тогда 
		КопироватьИзГод = Параметры.Год;
	Иначе
		КопироватьИзГод = Год(ТекущаяДата());
	КонецЕсли;	
	КопироватьВГод = КопироватьИзГод + 1;
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда 
		ИзОрганизации = Параметры.Организация;
		ВОрганизацию = Параметры.Организация;
	Иначе	
		ИзОрганизации = Справочники.Организации.ОрганизацияПоУмолчанию();
		ВОрганизацию = ИзОрганизации;
	КонецЕсли;
	
	ЗаполнитьДерево();
	
КонецПроцедуры


//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
// 

&НаКлиенте
Процедура ПометкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Дерево.ТекущаяСтрока;
	ЭлементДерева = Дерево.НайтиПоИдентификатору(ТекущаяСтрока);
	ПометитьПодчиненные(ЭлементДерева, ЭлементДерева.Пометка);
	
КонецПроцедуры

&НаКлиенте
Процедура Отметить(Команда)
	
	ПометитьПодчиненные(Неопределено, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметку(Команда)
	
	ПометитьПодчиненные(Неопределено, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Скопировать(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли;	
	
	СкопироватьНаСервере();
	Оповестить("СкопированаНоменклатураДел", КопироватьВГод, ЭтаФорма);
	
	ОписаниеОповещение = Новый ОписаниеОповещения("СкопироватьПродолжение", ЭтотОбъект);
	ПоказатьПредупреждение(ОписаниеОповещение, НСтр("ru = 'Выделенные элементы номенклатуры дел скопированы.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьПродолжение(ДополнительныеПараметры) Экспорт 
	
	Закрыть();
	
КонецПроцедуры	

&НаКлиенте
Процедура КопироватьИзГодПриИзменении(Элемент)
	
	ЗаполнитьДерево();
	
	Для Каждого ЭлементДерева Из Дерево.ПолучитьЭлементы() Цикл
		Элементы.Дерево.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИзОрганизацииПриИзменении(Элемент)
	
	ЗаполнитьДерево();
	
	Для Каждого ЭлементДерева Из Дерево.ПолучитьЭлементы() Цикл
		Элементы.Дерево.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если (КопироватьИзГод > КопироватьВГод) И (КопироватьВГод > 0) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Год, из которого копируется номенклатура дел, больше года, в который копируется номенклатура дел!'"),,,
			"КопироватьВГод", 
			Отказ);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда 
		ПроверяемыеРеквизиты.Добавить("ИзОрганизации");
		ПроверяемыеРеквизиты.Добавить("ВОрганизацию");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервереРедакцииКонфигурации()	
	
	Элементы.ИзОрганизации.Заголовок = РедакцииКонфигурацииКлиентСервер.ИзОрганизации();
	Элементы.ВОрганизацию.Заголовок = РедакцииКонфигурацииКлиентСервер.ВОрганизацию();
		
КонецПроцедуры
