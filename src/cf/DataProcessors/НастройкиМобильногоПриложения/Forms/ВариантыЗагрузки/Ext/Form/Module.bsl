﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ИспользуемаяОС = "Apple";
	
	// формируем ссылки на магазины и данные
	СсылкаApple = "https://apps.apple.com/us/app/1с-документооборот-2-2/id1491885028";
	
	СсылкаGoogle = "https://play.google.com/store/apps/details?id=com.e1c.DocMan22";
	
	СсылкаWindows = "https://www.microsoft.com/ru-ru/store/p/1%D0%A1-%D0%94%D0%BE%D0%BA%D1%83%D0%BC%D0%B5%D0%BD%D1%82%D0%B
		|E%D0%BE%D0%B1%D0%BE%D1%80%D0%BE%D1%82-21/9nblggh4wrkz";

	// формируем QR-коды
	КодApple = СформироватьQRКод(СсылкаApple);
	КодGoogle = СформироватьQRКод(СсылкаGoogle);
	КодWindows = СформироватьQRКод(СсылкаWindows);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИспользуемаяОСПриИзменении(Элемент)

	Если ИспользуемаяОС = "Apple" Тогда
		Элементы.ВариантыQRКодовДляРазныхМагазинов.ТекущаяСтраница = Элементы.СтраницаApple;

	ИначеЕсли ИспользуемаяОС = "Google" Тогда
		Элементы.ВариантыQRКодовДляРазныхМагазинов.ТекущаяСтраница = Элементы.СтраницаGoogle;

	ИначеЕсли ИспользуемаяОС = "Microsoft" Тогда
		Элементы.ВариантыQRКодовДляРазныхМагазинов.ТекущаяСтраница = Элементы.СтраницаMicrosoft;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура QRКодAppleНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПерейтиПоНавигационнойСсылке(СсылкаApple);

КонецПроцедуры

&НаКлиенте
Процедура QRКодGoogleНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	ПерейтиПоНавигационнойСсылке(СсылкаGoogle);

КонецПроцедуры

&НаКлиенте
Процедура QRКодWindowsНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	ПерейтиПоНавигационнойСсылке(СсылкаWindows);

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНажатие(Элемент)
	
	Если НЕ ЗначениеЗаполнено(АдресЭлектроннойПочты) Тогда
		ЗаголовоПредупреждения = НСтр("ru = 'Мобильное приложение'");
		ТекстПредупреждения = НСтр("ru = 'Необходимо указать e-mail'");
		ПоказатьПредупреждение(, ТекстПредупреждения,, ЗаголовоПредупреждения);
		Возврат;
	КонецЕсли;

	// Получаем содержимое письма
	ТемаПисьма = 
		НСтр("ru = 'Установите мобильный 1С:Документооборот на смартфон или планшет'");

	ТекстСсылкиНаЭпл = СтрШаблон(НСтр("ru = '<a href=""%1"">Apple AppStore</a>'"), СсылкаApple);
	ТекстСсылкиНаГугл = СтрШаблон(НСтр("ru = '<a href=""%1"">Google Play</a>'"), СсылкаGoogle);
	ТекстСсылкиНаМикрософт = СтрШаблон(НСтр("ru = '<a href=""%1"">Microsoft Windows Phone Store</a>'"), СсылкаWindows);
	
	Описание = СтрШаблон(
		Нстр("ru = '<p>Перейдите в %1, если у Вас устройство под управлением iOS<p>
				   |<p>Перейдите в %2, если у Вас устройство под управлением Android<p>
				   |<p>Перейдите в %3, если у Вас устройство под управлением Windows<p>'"),
		ТекстСсылкиНаЭпл, ТекстСсылкиНаГугл, ТекстСсылкиНаМикрософт);

	// Настраиваем параметры отправки
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Тема", ТемаПисьма);
	ПараметрыПисьма.Вставить("Текст", Описание);
	ПараметрыПисьма.Вставить("Кому", АдресЭлектроннойПочты);
	ПараметрыПисьма.Вставить("ТипТекста", ПредопределенноеЗначение("Перечисление.ТипыТекстовПочтовыхСообщений.HTML"));

	// Выполняем отправку
	СообщениеОбОшибке = "";
	
	УведомлениеОтправлено = УведомлениеОтправлено(ПараметрыПисьма, СообщениеОбОшибке);

	// Сообщаем о результатах
	Если УведомлениеОтправлено Тогда
		 Состояние(НСтр("ru = 'Письмо с инструкциями по установке отправлено'"));
	Иначе
		ВызватьИсключение СообщениеОбОшибке;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция УведомлениеОтправлено(ПараметрыПисьма, СообщениеОбОшибке)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ЛегкаяПочтаСервер.ОтправитьИнтернетПочта(ПараметрыПисьма, , , СообщениеОбОшибке);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьQRКод(ДанныеКода)

	ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(ДанныеКода, 0, 250);

	Возврат ПоместитьВоВременноеХранилище(ДанныеQRКода, УникальныйИдентификатор);

КонецФункции

#КонецОбласти
