﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокФайлов.Параметры.УстановитьЗначениеПараметра("Редактирует", 
		Пользователи.ТекущийПользователь());
	
	Идентификатор = ФайловыеФункции.ПолучитьСоставнойИдентификаторПользователя();
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СписокФайлов, "Идентификатор", Идентификатор);
	
	ПоказыватьКолонкуРазмер = РаботаСФайламиВызовСервера.ПолучитьПоказыватьКолонкуРазмер();
	Если ПоказыватьКолонкуРазмер = Ложь Тогда
		Элементы.ТекущаяВерсияРазмер.Видимость = Ложь;
		Элементы.Список.Шапка = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначенияДокументооборот.ПриложениеЯвляетсяВебКлиентом() Тогда
		Элементы.СписокКонтекстноеМенюАвтообновление.Видимость = Ложь;
	Иначе
		Автообновление.ЗагрузитьНастройкиАвтообновленияСписка(ЭтаФорма, "Список");
		Элементы.СписокКонтекстноеМенюАвтообновление.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработка события Выбор у списка 
//
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда  
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Список.ТекущиеДанные.Файл, Неопределено, УникальныйИдентификатор);	
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.Файл);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда  
		Возврат;
	КонецЕсли;
	
	ПараметрыОбновленияФайла = РаботаСФайламиКлиент.ПараметрыОбновленияФайла(Неопределено, 
		Элементы.Список.ТекущиеДанные.Файл, УникальныйИдентификатор);
		
	ПараметрыОбновленияФайла.ХранитьВерсии = Элементы.Список.ТекущиеДанные.ХранитьВерсии;
	ПараметрыОбновленияФайла.РедактируетТекущийПользователь = Истина;
	ПараметрыОбновленияФайла.Редактирует = Элементы.Список.ТекущиеДанные.Редактирует;
	РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда  
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Список.ТекущиеДанные.Файл, 
		Неопределено, УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда  
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	ПараметрыОсвобожденияФайла = РаботаСФайламиКлиент.ПараметрыОсвобожденияФайла(Неопределено, 
		Элементы.Список.ТекущиеДанные.Файл);
	ПараметрыОсвобожденияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;	
	ПараметрыОсвобожденияФайла.РедактируетТекущийПользователь = Истина;	
	ПараметрыОсвобожденияФайла.Редактирует = ТекущиеДанные.Редактирует;	
	РаботаСФайламиКлиент.ОсвободитьФайлСОповещением(ПараметрыОсвобожденияФайла);
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда  
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиКлиент.СохранитьИзмененияФайлаСОповещением(
		Неопределено,
		Элементы.Список.ТекущиеДанные.Файл,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда  
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(
		Элементы.Список.ТекущиеДанные.Файл, Неопределено, УникальныйИдентификатор);
	
	КомандыРаботыСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда  
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляСохранения(
		Элементы.Список.ТекущиеДанные.Файл, 
		Неопределено, 
		УникальныйИдентификатор);
	
	КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)

	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда  
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаИРабочийКаталог(Элементы.Список.ТекущиеДанные.Файл);
	
	РаботаСФайламиКлиент.ОбновитьИзФайлаНаДискеСОповещением(
		Неопределено,
		ДанныеФайла,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКоманд();
	                                       	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьВсе(Команда)
	
	ЗанятыеФайлы = ПолучитьСписокЗанятыхФайлов();
		
	Если ЗанятыеФайлы.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Вами не занято ни одного файла.'"));
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьСписокФайлов", ЭтотОбъект);
	
	РаботаСФайламиКлиент.ЗакончитьРедактированиеПоСсылкам(
		Обработчик,
		ЗанятыеФайлы,
		УникальныйИдентификатор,
		Истина, // СоздатьНовуюВерсию
		"", // КомментарийКВерсии
		Ложь, // ПоказыватьОповещение
		Истина); //ОсвобождатьБезВопросаФайлыКоторыхНетВРабочемКаталоге
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// АВТООБНОВЛЕНИЕ

&НаКлиенте
Процедура Автообновление(Команда)
	
	АвтообновлениеКлиент.УстановитьПараметрыАвтообновленияСписка(ЭтаФорма, "Список");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьСписокЗанятыхФайлов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Файлы.Файл КАК Ссылка
		|ИЗ
		|	РегистрСведений.ЗанятыеФайлы КАК Файлы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ФайлыВРабочемКаталогеКомпьютера КАК ФайлыВРабочемКаталогеКомпьютера
		|		ПО Файлы.ТекущаяВерсия = ФайлыВРабочемКаталогеКомпьютера.Версия
		|			И (ФайлыВРабочемКаталогеКомпьютера.Идентификатор = &Идентификатор)
		|			И (ФайлыВРабочемКаталогеКомпьютера.НаЧтение = ЛОЖЬ)
		|ГДЕ
		|	Файлы.Редактирует = &Редактирует";
		
	Запрос.УстановитьПараметр("Редактирует", 
		Пользователи.ТекущийПользователь());
		
	Идентификатор = ФайловыеФункции.ПолучитьСоставнойИдентификаторПользователя();
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	МассивФайлов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат МассивФайлов;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСписокФайлов(Результат = Неопределено, ПараметрыВыполнения = Неопределено) Экспорт
	
	Элементы.Список.Обновить();
	
	КоличествоЗанятыхФайлов = РаботаСФайламиВызовСервера.ПолучитьКоличествоЗанятыхФайлов(,,Истина);
	
	СтандартныеПодсистемыКлиент.УстановитьПараметрКлиента(
		"КоличествоЗанятыхФайлов", КоличествоЗанятыхФайлов);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд()
	
	ДоступностьКоманд = Элементы.Список.ТекущиеДанные <> Неопределено;
	
	Элементы.ЗакончитьРедактирование.Доступность = ДоступностьКоманд;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокЗакончитьРедактирование.Доступность = ДоступностьКоманд;
	
	Элементы.ОткрытьФайл.Доступность = ДоступностьКоманд;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОткрытьФайл.Доступность = ДоступностьКоманд;
	
	Элементы.Изменить.Доступность = ДоступностьКоманд;
	
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокСохранитьИзменения.Доступность = ДоступностьКоманд;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОткрытьКаталогФайла.Доступность = ДоступностьКоманд;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокСохранитьКак.Доступность = ДоступностьКоманд;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОсвободить.Доступность = ДоступностьКоманд;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОбновитьИзФайлаНаДиске.Доступность = ДоступностьКоманд;
	
	Элементы.ЗакончитьВсе.Доступность = ДоступностьКоманд;
	
КонецПроцедуры

#КонецОбласти