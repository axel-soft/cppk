﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
#Если НЕ ВебКлиент Тогда
	ЗаголовокПриложения = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ЗаголовокПриложения;
	ДанныеССервера = ПолучитьРегНомер(ПараметрКоманды);
	РегистрационныйНомер = ДанныеССервера.РегистрационныйНомер;
	ПараметрыОбработчика = Новый Структура();
	ПараметрыОбработчика.Вставить("ЗаголовокПриложения", ЗаголовокПриложения);
	ПараметрыОбработчика.Вставить("ДанныеССервера", ДанныеССервера);
	ПараметрыОбработчика.Вставить("ПараметрКоманды", ПараметрКоманды);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбработкаКомандыПродолжение",
		ЭтотОбъект);
	Если ПустаяСтрока(РегистрационныйНомер) Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Текст = НСтр("ru = 'Документ еще не зарегистрирован. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, Текст, Режим, 0);
		Возврат;
	КонецЕсли;
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
		
#Иначе
	ПоказатьПредупреждение(, НСтр("ru = 'В веб-клиенте выполнение данной операции невозможно'"));
#КонецЕсли	

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКомандыПродолжение(Ответ, Параметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
	    Возврат;
	КонецЕсли;
	
	ПараметрыНастройки = Новый Структура;
	ПараметрыНастройки.Вставить("ЗаголовокФормы", НСтр("ru = 'Положение регистрационного штампа'"));
	ПараметрыНастройки.Вставить("РежимИспользованияНастроек", 0);
	ПараметрыНастройки.Вставить("ЗапросОриентацииСтраницы", Истина);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаКомандыЗавершение", ЭтотОбъект, Параметры);
	ШтрихкодированиеКлиент.ПолучитьНастройкиШтрихкода(ПараметрыНастройки, ОписаниеОповещения);
	
КонецПроцедуры
 
&НаКлиенте
Процедура ОбработкаКомандыЗавершение(НастройкиПоложенияШК, Параметры) Экспорт
	
	Если НастройкиПоложенияШК = Неопределено Тогда                          
		Возврат;
	КонецЕсли;
	
	ТабличныйДокумент = ПолучитьПечатнуюФорму(
		Параметры.ПараметрКоманды, НастройкиПоложенияШК, Параметры.ЗаголовокПриложения);	
	
	Если ТабличныйДокумент <> Неопределено Тогда
		ТабличныйДокумент.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
		Если Параметры.ДанныеССервера.ИспользоватьШК Тогда
			Оповестить("НапечатанШтрихкод", Параметры.ПараметрКоманды); 
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПечатнуюФорму(ПараметрКоманды, НастройкиПоложенияШК, ЗаголовокПриложения)
	
	Если НастройкиПоложенияШК.Свойство("ОриентацияСтраницы") Тогда
		Если НастройкиПоложенияШК.ОриентацияСтраницы = "Портретная" Тогда
			Возврат ПолучитьТабличныйДокумент(ПараметрКоманды, Метаданные.ОбщиеМакеты.ПечатьРегистрационногоШтампаПортрет, НастройкиПоложенияШК, ЗаголовокПриложения);
		ИначеЕсли НастройкиПоложенияШК.ОриентацияСтраницы = "Альбомная" Тогда
			Возврат ПолучитьТабличныйДокумент(ПараметрКоманды, Метаданные.ОбщиеМакеты.ПечатьРегистрационногоШтампаАльбом, НастройкиПоложенияШК, ЗаголовокПриложения);
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьРегНомер(Объект)
	
	ИспользоватьШК =  ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкоды");
	ДанныеВозврата = Новый Структура("ИспользоватьШК, РегистрационныйНомер", ИспользоватьШК, Объект.РегистрационныйНомер);
	
	Возврат ДанныеВозврата;	
	
КонецФункции

//Получает заполненный печатный документ для печати штрихкода
//Параметры:
//			Объект - ссылка на Внутренний, Входящий, Исходящий документ или Файл, штрихкод которого печатается
//			Макет - макет печатного документа
//			НастройкиПоложенияШК - структура
//				ПоказыватьФормуНастройки - показывать форму настройки положения штрихкода
//				ПоложениеНаСтранице - ПеречислениеСсылка.МестаВставкиКартинки -
//				СмещениеПоГоризонтали - расстояние от левого края страницы
//				СмещениеПоВертикали - расстояние от верха страницы
//			ВысотаШКВПроцентах - высота изображения штрихкода в процентах
//Возвращает:
//			ТабличныйДокумент, если формирование прошло успешно
//			Неопределено, если формирование не произошло
&НаСервере
Функция ПолучитьТабличныйДокумент(Объект, Макет, НастройкиПоложенияШК, ЗаголовокПриложения) 
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОтображатьСетку = Ложь;
	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	
	Если НастройкиПоложенияШК.Свойство("ОриентацияСтраницы") Тогда
		Если НастройкиПоложенияШК.ОриентацияСтраницы = "Портретная" Тогда
			ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
		ИначеЕсли НастройкиПоложенияШК.ОриентацияСтраницы = "Альбомная" Тогда
			ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		КонецЕсли;
	КонецЕсли;
	
	Сформирован = Ложь;
	
	Сформирован = ЗаполнитьПечатнуюФорму(Объект, Макет, ТабличныйДокумент, НастройкиПоложенияШК, ЗаголовокПриложения);
	
	Если Сформирован Тогда
		Возврат ТабличныйДокумент;
	Иначе 	
		Возврат Неопределено;
	КонецЕсли;	
	
КонецФункции

//Выполняет вставку изображения штрихкода, настройку его положения
//Параметры:
//			Объект - ссылка на Внутренний, Входящий, Исходящий документ или Файл, штрихкод которого печатается
//			МакетПечати - макет печатного документа
//			ТабличныйДокумент - документ, в который производится вставка изображения штрихкода
//			ДанныеОПоложении - Структура:
//				ПоказыватьФормуНастройки - показывать форму настройки положения штрихкода
//				ПоложениеНаСтранице - ПеречислениеСсылка.МестаВставкиКартинки -
//				СмещениеПоГоризонтали - расстояние от левого края страницы
//				СмещениеПоВертикали - расстояние от верха страницы
//			ВысотаШКВПроцентах - высота изображения штрихкода в процентах
&НаСервере
Функция ЗаполнитьПечатнуюФорму(Объект, МакетПечати, ТабличныйДокумент, ДанныеОПоложении, ЗаголовокПриложения)

	ИспользоватьШК = ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкоды");
	
	Макет = ПолучитьОбщийМакет(МакетПечати);
	
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Шапка.Параметры.Заполнить(Объект);

	Если ИспользоватьШК Тогда
		ДанныеОШтрихкоде = ШтрихкодированиеСервер.ПолучитьДанныеДляВставкиШтрихкодаВОбъект(Объект.Ссылка, Ложь);
		Если ДанныеОШтрихкоде.Свойство("СообщениеОбОшибке") Тогда
			ВызватьИсключение(ДанныеОШтрихкоде.СообщениеОбОшибке);
		КонецЕсли;
		Если ДанныеОШтрихкоде <> Неопределено
			И ДанныеОШтрихкоде.Свойство("ДвоичныеДанныеИзображения") Тогда
			КартинкаШтрихкода = ШтрихкодированиеСервер.ПолучитьКартинкуШтрихкода(ДанныеОШтрихкоде.Штрихкод,, ДанныеОПоложении.ВысотаШК, ДанныеОПоложении.ПоказыватьЦифры);
		КонецЕсли;
	КонецЕсли;

	Если НЕ КартинкаШтрихкода = Неопределено 
		ИЛИ НЕ ИспользоватьШК Тогда

		ОриентацияПортрет = Истина;
		Если ДанныеОПоложении.Свойство("ОриентацияСтраницы") Тогда
			Если ДанныеОПоложении.ОриентацияСтраницы = "Портретная" Тогда
				ОриентацияПортрет = Истина;
			ИначеЕсли ДанныеОПоложении.ОриентацияСтраницы = "Альбомная" Тогда
				ОриентацияПортрет = Ложь;
			КонецЕсли;
		КонецЕсли;		
		
		Если ИспользоватьШК Тогда
			Рисунок = Шапка.Область("Картинка");
			Рисунок.Картинка = КартинкаШтрихкода;
			Рисунок.Высота = ДанныеОПоложении.ВысотаШК;
		Иначе
			Шапка.Рисунки.Удалить(Шапка.Рисунки["Картинка"]);
		КонецЕсли;
		
		Надпись = Шапка.Область("НадписьЗаголовок");
		РегистрационныйНомер = Шапка.Область("РегистрационныеДанные");
		
		ПоложениеНаСтранице = ДанныеОПоложении.ПоложениеНаСтранице;
		Если ПоложениеНаСтранице = Перечисления.МестаВставкиКартинки.ПравыйНижний Тогда
			СмещениеПоГоризонтали = "MAX";
			СмещениеПоВертикали = "MAX";
		ИначеЕсли ПоложениеНаСтранице = Перечисления.МестаВставкиКартинки.ПравыйВерхний Тогда
			СмещениеПоГоризонтали = "MAX";
			СмещениеПоВертикали = "MIN";
		ИначеЕсли ПоложениеНаСтранице = Перечисления.МестаВставкиКартинки.ЛевыйВерхний Тогда
			СмещениеПоГоризонтали = "MIN";
			СмещениеПоВертикали = "MIN";
		ИначеЕсли ПоложениеНаСтранице = Перечисления.МестаВставкиКартинки.ЛевыйНижний Тогда
			СмещениеПоГоризонтали = "MIN";
			СмещениеПоВертикали = "MAX";
		КонецЕсли;
		
		Если ИспользоватьШК Тогда
			//Если в штампе будет штрихкод, то позиционирование идет относительно штрихкода
			Если СмещениеПоГоризонтали = "MAX" Тогда
				Если ОриентацияПортрет Тогда
					Рисунок.Лево = Шапка.ШиринаСтраницы - Макет.ПолеСправа - Шапка.ПолеСправа - Рисунок.Ширина - 10;
				Иначе
					Рисунок.Лево = Шапка.ВысотаСтраницы - Макет.ПолеСверху - Шапка.ПолеСнизу - Рисунок.Ширина - 10;
				КонецЕсли;
			ИначеЕсли СмещениеПоГоризонтали = "MIN" Тогда
				Рисунок.Лево = Макет.ПолеСлева;
			Иначе
				Рисунок.Лево = ДанныеОПоложении.СмещениеПоГоризонтали;
			КонецЕсли;
			
			Если СмещениеПоВертикали = "MAX" Тогда
				Если ОриентацияПортрет Тогда
					Рисунок.Верх = Макет.ВысотаСтраницы - Макет.ПолеСнизу - Шапка.ПолеСнизу - Рисунок.Высота - 10;
				Иначе
					Рисунок.Верх = Макет.ШиринаСтраницы - Макет.ПолеСлева - Шапка.ПолеСправа - Рисунок.Высота - 10;
				КонецЕсли;
			ИначеЕсли СмещениеПоВертикали = "MIN" Тогда
				Рисунок.Верх = Макет.ПолеСверху;
			Иначе
				Рисунок.Верх = ДанныеОПоложении.СмещениеПоВертикали; 
			КонецЕсли;
			
		Иначе
			
			//Если штрихкода нет, то позиционирование идет относительно названия компании
			Если СмещениеПоГоризонтали = "MAX" Тогда
				Если ОриентацияПортрет Тогда
					Надпись.Лево = Шапка.ШиринаСтраницы - Макет.ПолеСправа - Шапка.ПолеСправа - Надпись.Ширина - 10;
				Иначе
					Надпись.Лево = Шапка.ВысотаСтраницы - Макет.ПолеСверху - Шапка.ПолеСнизу - Надпись.Ширина - 10;
				КонецЕсли;
			ИначеЕсли СмещениеПоГоризонтали = "MIN" Тогда
				Надпись.Лево = Макет.ПолеСлева;
			Иначе
				Надпись.Лево = ДанныеОПоложении.СмещениеПоГоризонтали;
			КонецЕсли;
			
			Если СмещениеПоВертикали = "MAX" Тогда
				Если ОриентацияПортрет Тогда
					Надпись.Верх = Макет.ВысотаСтраницы - Макет.ПолеСнизу - Шапка.ПолеСнизу - Надпись.Высота;
				Иначе
					Надпись.Верх = Макет.ШиринаСтраницы - Макет.ПолеСлева - Шапка.ПолеСправа - Надпись.Высота;
				КонецЕсли;
			ИначеЕсли СмещениеПоВертикали = "MIN" Тогда
				Надпись.Верх = Макет.ПолеСверху;
			Иначе
				Надпись.Верх = ДанныеОПоложении.СмещениеПоВертикали;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ТипЗнч(Объект) <> Тип("СправочникСсылка.ДокументыПредприятия") 
			Или ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект, "ВидДокумента.ВестиУчетПоОрганизациям") = Истина Тогда
				Если ТипЗнч(Объект) <> Тип("СправочникСсылка.Файлы") Тогда
					Надпись.Текст = Объект.Организация.Наименование;
				Иначе
					Надпись.Текст = "";
				КонецЕсли;
		Иначе
			Надпись.Текст = "";
		КонецЕсли;
		РегистрационныйНомер.Текст = "№ " + Объект.РегистрационныйНомер + " от " + Формат(Объект.ДатаРегистрации, "ДЛФ=D"); 
		//Расположение элементов штампа относительно друг друга
		Если ИспользоватьШК Тогда
			Надпись.Лево = Рисунок.Лево;
			Надпись.Верх = Рисунок.Верх - Надпись.Высота - РегистрационныйНомер.Высота;
			РегистрационныйНомер.Верх = Рисунок.Верх - РегистрационныйНомер.Высота;
		Иначе	
			РегистрационныйНомер.Верх = Надпись.Верх + РегистрационныйНомер.Высота;			
		КонецЕсли;
		
		РегистрационныйНомер.Лево =Надпись.Лево;
				
	КонецЕсли;

	ТабличныйДокумент.Вывести(Шапка);
    Возврат Истина;
	
КонецФункции


