﻿
&НаКлиенте
Процедура КаталогНаДискеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	РасширениеПодключено = ФайловыеФункцииСлужебныйКлиент.РасширениеРаботыСФайламиПодключено();
	Если РасширениеПодключено Тогда
		
		Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.Каталог = КаталогНаДиске;
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите путь каталога для загрузки файлов'");
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			КаталогНаДиске = ДиалогОткрытияФайла.Каталог;
		КонецЕсли;
	
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если ВебКлиент Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru = 'В Веб-клиенте загрузка файлов не поддерживается.'"));
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузку(Команда)
	
	ОчиститьСообщения();
	
	Если ПустаяСтрока(КаталогНаДиске) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбран каталог для загрузки!'"), , "КаталогНаДиске");
		Возврат;
		
	КонецЕсли;
	
	Если Папка.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Укажите папку!'"), , "Папка");
		Возврат;
	КонецЕсли;
	
	ВыбранныеФайлы = Новый СписокЗначений;
	
	НайденныеФайлы = НайтиФайлы(КаталогНаДиске, "*.*");
	Для Каждого ФайлВложенный Из НайденныеФайлы Цикл
		ВыбранныеФайлы.Добавить(ФайлВложенный.ПолноеИмя);
	КонецЦикла;
	
	ПсевдоФайловаяСистема = Новый Соответствие; // соответствие путь к директории - файлы и папки в ней 
	ДобавленныеФайлы = Новый Массив;
	
	Описание = "";
	ХранитьВерсии = Истина;
	УдалятьФайлыПослеДобавления = Истина;
	ПараметрыРаспознавания = Новый Структура("СтратегияРаспознавания, ЯзыкРаспознавания", 
		СтратегияРаспознавания, ЯзыкРаспознавания);
		
	Обработчик = Новый ОписаниеОповещения("ИмпортЗавершение", ЭтотОбъект);		
	
	ПараметрыВыполнения = РаботаСФайламиКлиент.ПараметрыИмпортаФайлов();
	ПараметрыВыполнения.ОбработчикРезультата = Обработчик;
	ПараметрыВыполнения.Владелец = Папка;
	ПараметрыВыполнения.ВыбранныеФайлы = ВыбранныеФайлы; 
	ПараметрыВыполнения.Комментарий = Описание;
	ПараметрыВыполнения.ХранитьВерсии = ХранитьВерсии;
	ПараметрыВыполнения.УдалятьФайлыПослеДобавления = УдалятьФайлыПослеДобавления;
	ПараметрыВыполнения.Рекурсивно = Истина;
	ПараметрыВыполнения.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыВыполнения.ДобавленныеФайлы = ДобавленныеФайлы;
	ПараметрыВыполнения.ПараметрыРаспознавания = ПараметрыРаспознавания;
	
	РаботаСФайламиКлиент.ВыполнитьИмпортФайлов(ПараметрыВыполнения);
		
КонецПроцедуры

&НаКлиенте
Процедура ИмпортЗавершение(Результат, ПараметрыВыполнения) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьНастройки();	
	Закрыть();
	Оповестить("ИмпортКаталоговЗавершен", Новый Структура, Результат.Владелец);
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		    НСтр("ru = 'Загрузка файлов из каталога ""%1"" в папку ""%2"" успешно завершена.'"), 
			КаталогНаДиске,
			Папка);
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивКаталоги = ХранилищеОбщихНастроек.Загрузить("ЗагрузкаФайлов", "Каталоги");
	Если МассивКаталоги <> Неопределено Тогда
		Элементы.КаталогНаДиске.СписокВыбора.ЗагрузитьЗначения(МассивКаталоги);
	КонецЕсли;	
	
	МассивПапка = ХранилищеОбщихНастроек.Загрузить("ЗагрузкаФайлов", "Папки");
	Если МассивПапка <> Неопределено Тогда
		Элементы.Папка.СписокВыбора.ЗагрузитьЗначения(МассивПапка);
	КонецЕсли;	
	
	ИспользоватьРаспознавание = РаботаСФайламиВызовСервера.ПолучитьИспользоватьРаспознавание();
	ДоступноРаспознаваниеПоЗапросу = РаботаСФайламиВызовСервера.ДоступноРаспознаваниеПоЗапросу();
	Элементы.ГруппаРаспознавание.Видимость = ИспользоватьРаспознавание И ДоступноРаспознаваниеПоЗапросу;
	Если ИспользоватьРаспознавание = Ложь Тогда
		СтратегияРаспознавания = Перечисления.СтратегииРаспознаванияТекста.НеРаспознавать;
	Иначе
		ПрограммаРаспознавания = РаботаСФайламиВызовСервера.ПрограммаРаспознавания();
		
		ЯзыкРаспознавания = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"Распознавание", "ЯзыкРаспознавания");
		
		Если Не ЗначениеЗаполнено(ЯзыкРаспознавания) Тогда
			ЯзыкРаспознавания = РаботаСФайламиВызовСервера.ПолучитьЯзыкРаспознавания();
		КонецЕсли;
		
		ЯзыкиРаспознавания = РаботаСФайламиВызовСервера.ЯзыкиРаспознаванияПрограммы(ПрограммаРаспознавания);
		Если ЯзыкиРаспознавания.Найти(ЯзыкРаспознавания, "Language") = Неопределено Тогда
			ЯзыкРаспознавания = РаботаСФайламиВызовСервера.ЯзыкРаспознаванияПрограммыПоУмолчанию(ПрограммаРаспознавания);
		КонецЕсли;
		
		СтратегияРаспознавания = РаботаСФайламиВызовСервера.СтратегияРаспознаванияФайловВладельца(
			ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип("СправочникСсылка.ПапкиФайлов")));
		
		ПредставлениеНастроекРаспознавания = РаботаСФайламиВызовСервера.ПолучитьПредставлениеНастроекРаспознавания(СтратегияРаспознавания, ЯзыкРаспознавания);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	СохраненнаяСтрока = Элементы.КаталогНаДиске.СписокВыбора.НайтиПоЗначению(КаталогНаДиске);
	Если СохраненнаяСтрока <> Неопределено Тогда
		Элементы.КаталогНаДиске.СписокВыбора.Удалить(СохраненнаяСтрока);
	КонецЕсли;
		
	Элементы.КаталогНаДиске.СписокВыбора.Вставить(0, КаталогНаДиске);
	КоличествоСтрок = Элементы.КаталогНаДиске.СписокВыбора.Количество();
	Если КоличествоСтрок > 20 Тогда
		Элементы.КаталогНаДиске.СписокВыбора.Удалить(КоличествоСтрок - 1);
	КонецЕсли;	
	МассивКаталоги = Элементы.КаталогНаДиске.СписокВыбора.ВыгрузитьЗначения();
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ЗагрузкаФайлов", "Каталоги", МассивКаталоги);
	
	
	СохраненнаяСтрока = Элементы.Папка.СписокВыбора.НайтиПоЗначению(Папка);
	Если СохраненнаяСтрока <> Неопределено Тогда
		Элементы.Папка.СписокВыбора.Удалить(СохраненнаяСтрока);
	КонецЕсли;
		
	Элементы.Папка.СписокВыбора.Вставить(0, Папка);
	КоличествоСтрок = Элементы.Папка.СписокВыбора.Количество();
	Если КоличествоСтрок > 20 Тогда
		Элементы.Папка.СписокВыбора.Удалить(КоличествоСтрок - 1);
	КонецЕсли;	
	МассивПапка = Элементы.Папка.СписокВыбора.ВыгрузитьЗначения();
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ЗагрузкаФайлов", "Папки", МассивПапка);
	
КонецПроцедуры	

&НаКлиенте
Процедура НастройкиРаспознавания(Команда)
	
	РаботаСФайламиКлиент.ВыбратьНастройкиРаспознавания(
		Новый Структура("СтратегияРаспознавания, ЯзыкРаспознавания", СтратегияРаспознавания, ЯзыкРаспознавания),
		ЭтаФорма,
		Новый ОписаниеОповещения("НастройкиРаспознаванияПродолжение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиРаспознаванияПродолжение(РезультатОткрытия, Параметры) Экспорт
	
	Если ТипЗнч(РезультатОткрытия) = Тип("Структура") Тогда
		СтратегияРаспознавания = РезультатОткрытия.СтратегияРаспознавания;
		ЯзыкРаспознавания = РезультатОткрытия.ЯзыкРаспознавания;
		ПредставлениеНастроекРаспознавания = РаботаСФайламиВызовСервера.ПолучитьПредставлениеНастроекРаспознавания(СтратегияРаспознавания, ЯзыкРаспознавания);
	КонецЕсли;
	
КонецПроцедуры
