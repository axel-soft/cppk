﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиВызовСервера.УстановитьФорматДаты(Элементы.ДатаИсполнения);
	
	ЗадачаСсылка = Параметры.ЗадачаСсылка;
	БизнесПроцесс = ЗадачаСсылка.БизнесПроцесс;
	
	// предметы
	ПредметыЗадачи = Мультипредметность.ПолучитьПредметыЗадачи(ЗадачаСсылка, Истина);
	Предметы.Загрузить(ПредметыЗадачи);
	
	Для Каждого СтрокаПредмета Из Предметы Цикл
		СтрокаПредмета.Картинка = МультипредметностьКлиентСервер.ИндексКартинкиРолиПредмета(
			СтрокаПредмета.РольПредмета, ?(СтрокаПредмета.Предмет = Неопределено, Ложь, СтрокаПредмета.Предмет.ПометкаУдаления));
		СтрокаПредмета.Описание = ОбщегоНазначенияДокументооборотВызовСервера.ПредметСтрокой(СтрокаПредмета.Предмет, СтрокаПредмета.ИмяПредмета);
	КонецЦикла;
	
	КоличествоПредметов = Предметы.Количество();
	
	Если Предметы.Количество() = 0 Тогда
		Элементы.Предмет.Видимость = Ложь;
		Элементы.ДекорацияЕще.Видимость = Ложь;
		Элементы.Предметы.Видимость = Ложь;
	ИначеЕсли КоличествоПредметов = 1 Тогда
		
		Элементы.Предмет.Видимость = Истина;
		Предмет = Предметы[0].Описание;
		
		Элементы.ДекорацияЕще.Видимость = Ложь;
		Элементы.Предметы.Видимость = Ложь;
		
	ИначеЕсли КоличествоПредметов > 1 Тогда
		
		Элементы.Предмет.Видимость = Истина;
		Предмет = Предметы[0].Описание;
		
		Элементы.ДекорацияЕще.Видимость = Истина;
		Элементы.Предметы.Видимость = Ложь;
		
		ПрописьЧисла          = ЧислоПрописью(Предметы.Количество() - 1, "Л = ru_RU", НСтр("ru = ',,,,,,,,0'"));
		ПрописьЧислаИПредмета =
			ЧислоПрописью(Предметы.Количество() - 1, "Л = ru_RU", НСтр("ru = 'предмет,предмета,предметов,,,,,,0'"));
		ЧислоИПредмет = СтрЗаменить(ПрописьЧислаИПредмета, ПрописьЧисла, Формат(Предметы.Количество() - 1, "ЧГ=") + " ");
		
		Элементы.ДекорацияЕще.Заголовок = СтрШаблон(Элементы.ДекорацияЕще.Заголовок,ЧислоИПредмет);
	КонецЕсли;
	
	НайденнаяСтрока = БизнесПроцесс.РезультатыПроверки.Найти(ЗадачаСсылка, "ЗадачаПроверяющего");
	Если НайденнаяСтрока = Неопределено Тогда
		НайденнаяСтрока = БизнесПроцесс.РезультатыИсполнения.Найти(ЗадачаСсылка, "ЗадачаИсполнителя");
	КонецЕсли;
	Если НайденнаяСтрока <> Неопределено Тогда 
		НомерИтерации = НайденнаяСтрока.НомерИтерации;
	КонецЕсли;
	
	ТочкиМаршрута = Новый Массив;
	ТочкиМаршрута.Добавить(БизнесПроцессы.Исполнение.ТочкиМаршрута.Исполнить);
	ТочкиМаршрута.Добавить(БизнесПроцессы.Исполнение.ТочкиМаршрута.ОтветственноеИсполнение);
	
	ИсторияИсполнения.Параметры.УстановитьЗначениеПараметра("БизнесПроцесс", БизнесПроцесс);
	ИсторияИсполнения.Параметры.УстановитьЗначениеПараметра("НомерИтерации", НомерИтерации);
	ИсторияИсполнения.Параметры.УстановитьЗначениеПараметра("ТочкиМаршрута", ТочкиМаршрута);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Предметы[0];
	
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.Предмет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Предметы.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.Предмет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполненияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЕщеНажатие(Элемент)
	
	Элементы.Предмет.Видимость = Ложь;
	Элементы.ДекорацияЕще.Видимость = Ложь;
	Элементы.Предметы.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Предметы.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.Предмет);
	КонецЕсли;
	
КонецПроцедуры
