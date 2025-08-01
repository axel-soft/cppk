﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписок()
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	НомерСтроки = -1;
	Если ТекущаяСтрока <> Неопределено Тогда
		 Строка = Список.НайтиПоИдентификатору(ТекущаяСтрока);
		 НомерСтроки = Список.Индекс(Строка);
	КонецЕсли;	
	
	Список.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РегистрСведенийОбращенияКОбъектам.Объект,
		|	ТИПЗНАЧЕНИЯ(РегистрСведенийОбращенияКОбъектам.Объект) КАК ТипОбъекта,
		|	РегистрСведенийОбращенияКОбъектам.Пользователь,
		|	РегистрСведенийОбращенияКОбъектам.ДатаПоследнегоОбращения КАК ДатаПоследнегоОбращения,
		|	ВЫБОР
		|		КОГДА РегистрСведенийОбращенияКОбъектам.Объект.ПометкаУдаления = ИСТИНА
		|			ТОГДА РегистрСведенийОбращенияКОбъектам.ИндексКартинки + 1
		|		ИНАЧЕ РегистрСведенийОбращенияКОбъектам.ИндексКартинки
		|	КОНЕЦ КАК ИндексКартинки,
		|	Файлы.Редактирует,
		|	ВЫБОР
		|		КОГДА Файлы.Редактирует = &ТекущийПользователь
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК РедактируетТекущийПользователь
		|ИЗ
		|	РегистрСведений.ОбращенияКОбъектам КАК РегистрСведенийОбращенияКОбъектам
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Файлы КАК Файлы
		|		ПО РегистрСведенийОбращенияКОбъектам.Объект = Файлы.Ссылка
		|ГДЕ
		|	РегистрСведенийОбращенияКОбъектам.Пользователь = &ТекущийПользователь
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаПоследнегоОбращения УБЫВ";

	Запрос.УстановитьПараметр("ТекущийПользователь", ПользователиКлиентСервер.ТекущийПользователь());

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	ТекущаяДатаНачалоДня = НачалоДня(ТекущаяДата());

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Строка = Список.Добавить();
		
		Попытка
			
			ЗаполнитьЗначенияСвойств(Строка, ВыборкаДетальныеЗаписи);
			Строка.Представление = Строка(Строка.Объект);
			
		Исключение
			
			// Ошибка из-за того, что больше нет прав на этот объект - просто не показываем объект
			Список.Удалить(Строка);
			Продолжить;
			
		КонецПопытки;
		
		Строка.ДатаСегодня = (НачалоДня(Строка.ДатаПоследнегоОбращения) = ТекущаяДатаНачалоДня);
		
	КонецЦикла;

	Если НомерСтроки <> -1 И НомерСтроки < Список.Количество() Тогда
		СтрокаДляВыделения = Список.Получить(НомерСтроки);
		ИдСтроки = СтрокаДляВыделения.ПолучитьИдентификатор();
		Элементы.Список.ТекущаяСтрока = ИдСтроки;
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокПоследних" Тогда
		
		Если ОткрытиеИзСписка Тогда
			ОткрытиеИзСписка = Ложь;
			Возврат;
		КонецЕсли;	
		
		ЗаполнитьСписок();
		
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		ЗаполнитьСписок();
	КонецЕсли;
	
	Если ИмяСобытия = "ФайлОткрыт" Тогда
		ЗаполнитьСписок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	ВыбраннаяСтрока = Элементы.Список.ТекущиеДанные.Объект;
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СправочникСсылка.Файлы") Тогда
	
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(ВыбраннаяСтрока, 
			Неопределено, УникальныйИдентификатор, Неопределено, ПредыдущийАдресФайла);
		КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ОткрытьЗначениеСписка(Элемент.ТекущиеДанные.Объект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗначениеСписка(Ссылка)
	
	Если ТипЗнч(Ссылка) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		Если БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Ссылка) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПоказатьЗначение(, Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьСтрокуВНачало(ТекущаяСтрока)
	
	Если ТекущаяСтрока <> Неопределено Тогда
		
		Строка = Список.НайтиПоИдентификатору(ТекущаяСтрока);
		НомерСтроки = Список.Индекс(Строка);
		Строка.ДатаПоследнегоОбращения = ТекущаяДата();
		Строка.ДатаСегодня = Истина;
		 
		Список.Сдвинуть(НомерСтроки, -НомерСтроки); // сдвинем в позицию 0
		
		СтрокаДляВыделения = Список.Получить(НомерСтроки);
		ИдСтроки = СтрокаДляВыделения.ПолучитьИдентификатор();
		Элементы.Список.ТекущаяСтрока = ИдСтроки;
		
		УстановитьДоступностьКоманд();
		
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда	
		Возврат;
	КонецЕсли;
	
	ОткрытиеИзСписка = Истина;
	
	Если ТипЗнч(Элемент.ТекущиеДанные.Объект) = Тип("СправочникСсылка.Файлы") Тогда
		
		ВыбраннаяСтрока = Элемент.ТекущиеДанные.Объект;
		
		КакОткрывать = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ДействиеПоДвойномуЩелчкуМыши;
		
		Если КакОткрывать = "ОткрыватьКарточку" Тогда
			ПоказатьЗначение(, ВыбраннаяСтрока);
			ПереместитьСтрокуВНачало(Элементы.Список.ТекущаяСтрока);
			Возврат;
		КонецЕсли;
		
		ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
		
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(ВыбраннаяСтрока, 
			Неопределено, УникальныйИдентификатор, Неопределено, ПредыдущийАдресФайла);
		
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
		Обработчик = Новый ОписаниеОповещения("СписокВыборПослеВыбораРежимаРедактирования", ЭтотОбъект, ПараметрыОбработчика);
		
		РаботаСФайламиКлиент.ВыбратьРежимИРедактироватьФайл(Обработчик, ДанныеФайла, Истина);
		
	Иначе
		ОткрытьЗначениеСписка(Элемент.ТекущиеДанные.Объект);
		ПереместитьСтрокуВНачало(Элементы.Список.ТекущаяСтрока);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборПослеВыбораРежимаРедактирования(Результат, ПараметрыВыполнения) Экспорт
	
	РезультатОткрыть = "Открыть";
	РезультатРедактировать = "Редактировать";
	РезультатОткрытьКарточку = "ОткрытьКарточку";
	
	Обработчик = Новый ОписаниеОповещения("СписокВыборПослеРедактированияФайла", ЭтотОбъект, ПараметрыВыполнения);
	
	Если Результат = РезультатРедактировать Тогда
		РаботаСФайламиКлиент.РедактироватьФайл(Обработчик, ПараметрыВыполнения.ДанныеФайла);
	ИначеЕсли Результат = РезультатОткрыть Тогда
		РаботаСФайламиКлиент.ОткрытьФайлСОповещением(Неопределено, ПараметрыВыполнения.ДанныеФайла, УникальныйИдентификатор); 
	ИначеЕсли Результат = РезультатОткрытьКарточку Тогда
		ПоказатьЗначение(, ПараметрыВыполнения.ДанныеФайла.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборПослеРедактированияФайла(Результат, ПараметрыВыполнения) Экспорт
	
	ПереместитьСтрокуВНачало(Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд()
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		Если ТипЗнч(Элементы.Список.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			
			ВыбраннаяСтрока = Элементы.Список.ТекущиеДанные.Объект;
			
			Если ТипЗнч(ВыбраннаяСтрока) = Тип("СправочникСсылка.Файлы") Тогда
				
				УстановитьДоступностьКомандФайлов(Элементы.Список.ТекущиеДанные.РедактируетТекущийПользователь,
					Элементы.Список.ТекущиеДанные.Редактирует);
					
				Возврат;	
				
			КонецЕсли;	
			
			СделатьКомандыНедоступными();
			
			Если Элементы.Список.ВыделенныеСтроки.Количество() = 1 Тогда
				Для Каждого ВыделеннаяСтрока ИЗ Элементы.Список.ВыделенныеСтроки Цикл
					Если ВозможнаОтправкаОбъекта(ВыбраннаяСтрока) Тогда
						Элементы.СписокКонтекстноеМенюОтправитьОбъекты.Доступность = Истина;
					КонецЕсли;
				КонецЦикла;
			Иначе
				Элементы.СписокКонтекстноеМенюОтправитьОбъекты.Доступность = Истина;
			КонецЕсли;
			
			Возврат;
			
		КонецЕсли;	
			
	КонецЕсли;	
	
	СделатьКомандыНедоступными();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандФайлов(РедактируетТекущийПользователь, Редактирует)
	
	РедактируетДругой = ЗначениеЗаполнено(Редактирует) И НЕ РедактируетТекущийПользователь;
	
	Элементы.СписокОткрытьФайл.Доступность = Истина;
	Элементы.СписокКонтекстноеМенюОткрытьФайл.Доступность = Истина;
	Элементы.СписокКонтекстноеМенюЗакончитьРедактирование.Доступность = РедактируетТекущийПользователь;
	Элементы.СписокКонтекстноеМенюРедактировать.Доступность = НЕ РедактируетДругой;
	Элементы.СписокКонтекстноеМенюСохранитьКак.Доступность = Истина;
	
	Элементы.СписокКонтекстноеМенюОтправитьОбъекты.Доступность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьКомандыНедоступными()
	
	Элементы.СписокКонтекстноеМенюОтправитьОбъекты.Доступность = Ложь;
	
	Элементы.СписокОткрытьФайл.Доступность = Ложь;
	Элементы.СписокКонтекстноеМенюОткрытьФайл.Доступность = Ложь;
	Элементы.СписокКонтекстноеМенюЗакончитьРедактирование.Доступность = Ложь;
	Элементы.СписокКонтекстноеМенюРедактировать.Доступность = Ложь;
	Элементы.СписокКонтекстноеМенюСохранитьКак.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Обработчик = Новый ОписаниеОповещения("ПослеЗакончитьРедактирование", ЭтотОбъект);
	
	ПараметрыОбновленияФайла = РаботаСФайламиКлиент.ПараметрыОбновленияФайла(Обработчик, Элементы.Список.ТекущиеДанные.Объект, 
		УникальныйИдентификатор);
	РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакончитьРедактирование(Результат, ПараметрыВыполнения) Экспорт
	
	ЗаполнитьСписок();
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	Обработчик = Новый ОписаниеОповещения("ПослеЗакончитьРедактирование", ЭтотОбъект);
	
	РаботаСФайламиКлиент.РедактироватьСОповещением(
		Обработчик,
		Элементы.Список.ТекущиеДанные.Объект,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляСохранения(Элементы.Список.ТекущиеДанные.Объект, 
		Неопределено, УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.Значение.Очистить();
	ПараметрыПеретаскивания.Значение.Добавить(Элементы.Список.ТекущиеДанные.Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьОбъекты(Команда)
	
	ВсегоОбъектовКОтправке = 0;
	ОбъектыКОтправке = Новый Массив;
	ПользователиКомуОтправить = Новый Массив;
	ЗадачаДляСозданияПодзадачи = Неопределено;
	ПроектыИПроектныеЗадачи = Новый Массив;
	
	Для Каждого ИДПредмета Из Элементы.Список.ВыделенныеСтроки Цикл
		
		Объект = Список.НайтиПоИдентификатору(ИДПредмета).Объект;
		
		Если Не ВозможнаОтправкаОбъекта(Объект) Тогда
			Продолжить;
		КонецЕсли;
		
		ВсегоОбъектовКОтправке = ВсегоОбъектовКОтправке + 1;
		
		ТипОбъекта = ТипЗнч(Объект);
		
		Если ТипОбъекта = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
			Если Не ЗначениеЗаполнено(ЗадачаДляСозданияПодзадачи) Тогда
				ЗадачаДляСозданияПодзадачи = Объект;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		Если ТипОбъекта = Тип("СправочникСсылка.Проекты")
			Или ТипОбъекта = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
			
			ПользователиКомуОтправить.Добавить(Объект);
			Продолжить;
		КонецЕсли;
		
		Если ТипОбъекта = Тип("СправочникСсылка.Пользователи") Тогда
			ПользователиКомуОтправить.Добавить(Объект);
			Продолжить;
		КонецЕсли;
		
		ОбъектыКОтправке.Добавить(Объект);
		
	КонецЦикла;
	
	Если ВсегоОбъектовКОтправке = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не выделено ни одного объекта, подходящего для отправки.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Список");
		Возврат;
	КонецЕсли;
	
	Если ВсегоОбъектовКОтправке = 1 И ЗначениеЗаполнено(ЗадачаДляСозданияПодзадачи) Тогда
		ПомощникОтправитьКлиент.ОтправитьПодзадачу(ЗадачаДляСозданияПодзадачи, ЭтаФорма);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПользователиКомуОтправить) И Не ЗначениеЗаполнено(ОбъектыКОтправке) Тогда
		ПомощникОтправитьКлиент.ОтправитьПользователям(ПользователиКомуОтправить, ЭтаФорма);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПроектыИПроектныеЗадачи) И Не ЗначениеЗаполнено(ОбъектыКОтправке) Тогда
		ПомощникОтправитьКлиентКОРП.ОтправитьПроектыИлиПроектныеЗадачи(ПроектыИПроектныеЗадачи, ЭтаФорма);
		Возврат;
	КонецЕсли;
	
	ПомощникОтправитьКлиент.ОтправитьОбъекты(ОбъектыКОтправке, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Функция ВозможнаОтправкаОбъекта(СсылкаНаОбъект)
	
	ТипВыбраннойСтроки = ТипЗнч(СсылкаНаОбъект);
					
	Возврат ТипВыбраннойСтроки = Тип("СправочникСсылка.УведомленияПрограммы")
		ИЛИ ТипВыбраннойСтроки = Тип("СправочникСсылка.Контрагенты")
		ИЛИ ТипВыбраннойСтроки = Тип("СправочникСсылка.Файлы") 
		ИЛИ ТипВыбраннойСтроки = Тип("СправочникСсылка.ДокументыПредприятия")
		ИЛИ ТипВыбраннойСтроки = Тип("СправочникСсылка.Пользователи")
		ИЛИ ТипВыбраннойСтроки = Тип("ЗадачаСсылка.ЗадачаИсполнителя")
		ИЛИ ТипВыбраннойСтроки = Тип("СправочникСсылка.ТемыОбсуждений")
		ИЛИ ТипВыбраннойСтроки = Тип("ДокументСсылка.ВходящееПисьмо")
		ИЛИ ТипВыбраннойСтроки = Тип("ДокументСсылка.ИсходящееПисьмо")
		ИЛИ ТипВыбраннойСтроки = Тип("ДокументСсылка.ИсходящееПисьмо")
		ИЛИ ТипВыбраннойСтроки = Тип("СправочникСсылка.СообщенияОбсуждений")
		ИЛИ ТипВыбраннойСтроки = Тип("СправочникСсылка.Мероприятия");
	
КонецФункции

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СписокПередУдалениемПродолжение",
		ЭтотОбъект);
	ПоказатьВопрос(
		ОписаниеОповещения,
		НСтр("ru = 'Удалить выделенные записи?'"), РежимДиалогаВопрос.ДаНет);	
		
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалениемПродолжение(Ответ, Параметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	УдалитьЗаписи();
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЗаписи()
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	УстановитьПривилегированныйРежим(Истина);
	НаборЗаписей = РегистрыСведений.ОбращенияКОбъектам.СоздатьНаборЗаписей();
	
	Для Каждого ИдСтроки Из Элементы.Список.ВыделенныеСтроки Цикл
		
		Строка = Список.НайтиПоИдентификатору(ИдСтроки);
		 
		НаборЗаписей.Отбор.Объект.Установить(Строка.Объект);
		НаборЗаписей.Отбор.Пользователь.Установить(ТекущийПользователь);
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры	

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры
