﻿
///////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ДекорацияВопрос.Заголовок = Параметры.Вопрос;
	
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Отправить(Команда)
	
	СтруктураВозврата = Новый Структура("Отправить, БольшеНеЗадаватьЭтотВопрос", 
		Истина, БольшеНеЗадаватьЭтотВопрос); 
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура НеОтправлять(Команда)
	
	СтруктураВозврата = Новый Структура("Отправить, БольшеНеЗадаватьЭтотВопрос", 
		Ложь, БольшеНеЗадаватьЭтотВопрос);
	Закрыть(СтруктураВозврата);    
	
КонецПроцедуры

&НаКлиенте
Процедура БольшеНеЗадаватьЭтотВопросПриИзменении(Элемент)
	
	Если БольшеНеЗадаватьЭтотВопрос Тогда 
		Элементы.НеОтправлять.Доступность = Ложь;
	Иначе 
		Элементы.НеОтправлять.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры
