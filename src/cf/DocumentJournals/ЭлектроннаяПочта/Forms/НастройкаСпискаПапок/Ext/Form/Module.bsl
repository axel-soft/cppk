﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОтображатьУдаленные") Тогда
		ПараметрОтображатьУдаленные = Параметры.ОтображатьУдаленные;
	Иначе
		ПараметрОтображатьУдаленные =
			ВстроеннаяПочтаСервер.ПолучитьПерсональнуюНастройку("ОтображатьУдаленныеПисьмаИПапки");
	КонецЕсли;
	
	Если Параметры.Свойство("РежимМоиПапки") Тогда
		ПараметрРежимМоиПапки = Параметры.РежимМоиПапки;
	Иначе
		ПараметрРежимМоиПапки = ВстроеннаяПочтаСервер.ПолучитьПерсональнуюНастройку("РежимМоиПапки");
	КонецЕсли;
		
	УстановитьРежимМоиПапки(ПараметрРежимМоиПапки);
	
	ТаблицаПапок = РегистрыСведений.ПапкиПисемЧастоИспользуемые.ПолучитьПапкиДляТекущегоПользователя();
	МассивПапок = ТаблицаПапок.ВыгрузитьКолонку("Папка");
	Для Каждого Папка Из МассивПапок Цикл
		Строка = ПапкиЧастые.Добавить();
		Строка.Ссылка = Папка;
		Строка.Представление = ПолучитьПредставлениеПапки(Папка);
	КонецЦикла;	
	
	ЗаполнитьДеревоПапок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РежимМоиПапки(Команда)
	
	УстановитьРежимМоиПапки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимВсеПапки(Команда)
	
	УстановитьРежимМоиПапки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВЧастыеПапки(Команда)
	
	ДобавитьВЧастыеПапкиВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзЧастыхПапок(Команда)
	
	Строка = ПапкиЧастые.НайтиПоИдентификатору(Элементы.ПапкиЧастые.ТекущаяСтрока);
	Если Строка <> Неопределено Тогда
		ПапкиЧастые.Удалить(Строка);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ЗаписатьЧастыеПапки();
	Закрыть();
	Оповестить("ВыполненаНастройкаСпискаПапок");
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкиЧастыеПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкиЧастыеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкиЧастыеПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкиЧастыеПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	ПеретаскиваемоеЗначение = ПараметрыПеретаскивания.Значение;
	
	Папка = ПеретаскиваемоеЗначение.Ссылка;
		
	Если ПапкиЧастые.Количество() >= 6 Тогда
		ПоказатьПредупреждение(, 
			НСтр("ru = 'У вас уже выбрано 6 папок. 
			|Нужно удалить какую то из выбранных папок чтобы можно было добавить еще.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("Ссылка", Папка);
	МассивНайденного = ПапкиЧастые.НайтиСтроки(ПараметрыОтбора);
	Если МассивНайденного.Количество() = 0 Тогда
	
		Строка = ПапкиЧастые.Добавить();
		Строка.Ссылка = Папка;
		Строка.Представление = ПолучитьПредставлениеПапки(Строка.Ссылка);
		
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура ПапкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкиПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПапкиПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьВЧастыеПапкиВыполнить();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьПредставлениеПапки(Папка)
	
	Представление = "";
	
	Если ЗначениеЗаполнено(Папка.Родитель) Тогда
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"%1 (%2)", Строка(Папка), Строка(Папка.Родитель));
	Иначе
		Представление = Строка(Папка);
	КонецЕсли;	
	
	Возврат Представление;
	
КонецФункции	

&НаСервере
Процедура ЗаполнитьДеревоПапок()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПапкиПисем.Ссылка КАК Папка,
		|	ПапкиПисем.ПометкаУдаления КАК ПапкаПометкаУдаления,
		|	ПапкиПисем.Представление КАК ПредставлениеПапки,
		|	ПапкиПисем.ВидПапки КАК ВидПапки,
		|	ВЫБОР
		|		КОГДА ПапкиПисем.ПометкаУдаления
		|			ТОГДА 1
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Черновики)
		|			ТОГДА 2
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Корзина)
		|			ТОГДА 4
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК НомерКартинки,
		|	ВЫБОР
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Входящие)
		|			ТОГДА 1
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Исходящие)
		|			ТОГДА 2
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Отправленные)
		|			ТОГДА 3
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Корзина)
		|			ТОГДА 5
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Черновики)
		|			ТОГДА 6
		|		ИНАЧЕ 7
		|	КОНЕЦ КАК Порядок,
		|	ПапкиПисем.ВариантОтображенияКоличестваПисем,");
		
	Если РежимМоиПапки Тогда
		Запрос.Текст = Запрос.Текст +
			"
			|	ЛОЖЬ КАК ПапкаБыстрогоДоступа";
	Иначе
		Запрос.Текст = Запрос.Текст +
			"
			|ВЫБОР
			|	КОГДА ПапкиПисемБыстрогоДоступа.Папка ЕСТЬ NULL 
			|		ТОГДА ЛОЖЬ
			|	ИНАЧЕ ИСТИНА
			|КОНЕЦ КАК ПапкаБыстрогоДоступа"
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст +
		"
		|ИЗ
		|	Справочник.ПапкиПисем КАК ПапкиПисем
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПапкиПисемБыстрогоДоступа КАК ПапкиПисемБыстрогоДоступа
		|	ПО (ПапкиПисемБыстрогоДоступа.Папка = ПапкиПисем.Ссылка И ПапкиПисемБыстрогоДоступа.Пользователь = &ТекущийПользователь)
		|ГДЕ
		|	((НЕ ПапкиПисем.ПометкаУдаления)
		|			ИЛИ &ОтображатьУдаленные)";
		
	Если РежимМоиПапки Тогда
		Запрос.Текст = Запрос.Текст +
			"
			|	И ПапкиПисем.Ссылка В ИЕРАРХИИ
			|		(ВЫБРАТЬ
			|			ПапкиПисемБыстрогоДоступа.Папка
			|		ИЗ
			|			РегистрСведений.ПапкиПисемБыстрогоДоступа КАК ПапкиПисемБыстрогоДоступа
			|		ГДЕ
			|			ПапкиПисемБыстрогоДоступа.Пользователь = &ТекущийПользователь)";
	КонецЕсли;
		
	Запрос.Текст = Запрос.Текст +
		"
		|УПОРЯДОЧИТЬ ПО
		|	Папка ИЕРАРХИЯ";
		
	Запрос.УстановитьПараметр("ОтображатьУдаленные", ОтображатьУдаленные); 
	Запрос.УстановитьПараметр("ТекущийПользователь", ПользователиКлиентСервер.ТекущийПользователь());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	ТекУчетнаяЗапись = Неопределено;
	СтрокаУчетнаяЗапись = Неопределено;
	
	ДеревоПапок = РеквизитФормыВЗначение("Папки");
	ДеревоПапок.Строки.Очистить();
	ДобавитьПапкиВДерево(ДеревоПапок.Строки, Дерево.Строки);
	СортироватьИерархически(ДеревоПапок.Строки, "Порядок, Представление");
	ЗначениеВДанныеФормы(ДеревоПапок, Папки);
		
КонецПроцедуры

&НаСервере
Процедура ДобавитьПапкиВДерево(ДеревоСтроки, ИсточникСтроки)
	
	Для каждого ПапкаИнфо Из ИсточникСтроки Цикл
		Представление = ПапкаИнфо.ПредставлениеПапки;
		СтрокаПапка = ДеревоСтроки.Добавить();
		СтрокаПапка.Ссылка = ПапкаИнфо.Папка;
		СтрокаПапка.НомерКартинки = ПапкаИнфо.НомерКартинки;
		СтрокаПапка.Наименование = Представление;
		СтрокаПапка.Представление = Представление;
		СтрокаПапка.ВидПапки = ПапкаИнфо.ВидПапки;
		СтрокаПапка.Порядок = ПапкаИнфо.Порядок;
		СтрокаПапка.ВариантОтображенияКоличестваПисем = ПапкаИнфо.ВариантОтображенияКоличестваПисем;
		СтрокаПапка.ПапкаБыстрогоДоступа = ПапкаИнфо.ПапкаБыстрогоДоступа;
		ДобавитьПапкиВДерево(СтрокаПапка.Строки, ПапкаИнфо.Строки);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СортироватьИерархически(СтрокиДерева, Знач Колонки)
	
	СтрокиДерева.Сортировать(Колонки);
	Для каждого СтрокаДерева Из СтрокиДерева Цикл
		Если СтрокаДерева.Строки.Количество() > 0 Тогда
			СортироватьИерархически(СтрокаДерева.Строки, Колонки);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьЧастыеПапки()
	
	МассивПапок = Новый Массив;
	Для Каждого Строка Из ПапкиЧастые Цикл
		МассивПапок.Добавить(Строка.Ссылка);
	КонецЦикла;	
	
	РегистрыСведений.ПапкиПисемЧастоИспользуемые.ЗаписатьПапкиДляТекущегоПользователя(МассивПапок);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВЧастыеПапкиВыполнить()
	
	Если Элементы.Папки.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПапкиЧастые.Количество() >= 6 Тогда
		ПоказатьПредупреждение(, 
			НСтр("ru = 'У вас уже выбрано 6 папок. 
			|Нужно удалить какую то из выбранных папок чтобы можно было добавить еще.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("Ссылка", Элементы.Папки.ТекущиеДанные.Ссылка);
	МассивНайденного = ПапкиЧастые.НайтиСтроки(ПараметрыОтбора);
	Если МассивНайденного.Количество() = 0 Тогда
		Строка = ПапкиЧастые.Добавить();
		Строка.Ссылка = Элементы.Папки.ТекущиеДанные.Ссылка;
		Строка.Представление = ПолучитьПредставлениеПапки(Строка.Ссылка);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРежимМоиПапки(НовыйРежимМоиПапки)
	
	РежимМоиПапки = НовыйРежимМоиПапки; 
	
	Элементы.ПапкиКонтекстноеМенюРежимМоиПапки.Пометка = НовыйРежимМоиПапки;
	Элементы.ПапкиКонтекстноеМенюРежимВсеПапки.Пометка = Не НовыйРежимМоиПапки;
	
	ЗаполнитьДеревоПапок();
	
КонецПроцедуры

#КонецОбласти