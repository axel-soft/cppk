﻿#Область ПрограммныйИнтерфейс

#Область МК_КарточкаЗадачи
// Выполняет адаптацию элементов формы карточки задачи к экрану мобильного устройства.
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения  - Адаптируемая форма.
//
Процедура АдаптироватьЭлементыФормыКарточкиЗадачи(Форма) Экспорт

	Элементы = Форма.Элементы;

	ЗаписатьИЗакрыть = Элементы.Найти("ЗаписатьИЗакрыть");
	Если ЗаписатьИЗакрыть <> Неопределено Тогда
		ЗаписатьИЗакрыть.Картинка = БиблиотекаКартинок.ЗаписатьИЗакрыть;
		ЗаписатьИЗакрыть.Отображение = ОтображениеКнопки.Картинка;
	КонецЕсли;

	ПредставлениеHTML = Элементы.Найти("ПредставлениеHTML");
	Если ПредставлениеHTML <> Неопределено Тогда
		ПредставлениеHTML.Высота = 3;
	КонецЕсли;

	ГруппаОписаниеЗадачи = Элементы.Найти("ГруппаОписаниеЗадачи");
	Если ГруппаОписаниеЗадачи <> Неопределено Тогда
		ГруппаОписаниеЗадачи.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	КонецЕсли;

	ДеревоПриложений = Элементы.Найти("ДеревоПриложений");
	ЗаголовокДекорации = НСтр("ru='Предметы'");
	Если ДеревоПриложений = Неопределено Тогда
		ДеревоПриложений = Элементы.Найти("Предметы");
	КонецЕсли;

	Если ДеревоПриложений <> Неопределено Тогда

#Если Сервер Тогда
		ДеревоПриложений.ВариантУправленияВысотой = ВариантУправленияВысотойТаблицы.ВСтрокахТаблицы;
#КонецЕсли

		ДеревоПриложений.Высота = 0;
		ДеревоПриложений.ВысотаВСтрокахТаблицы = 3;
		ДеревоПриложений.РастягиватьПоВертикали = Ложь;
		ДеревоПриложений.Видимость = Ложь;

		ИмяДекорацияДляСкрытияТаблицыПриложений = Новый РеквизитФормы("ИмяДекорацияДляСкрытияТаблицыПриложений",
			Новый ОписаниеТипов("Строка"));
		МассивРеквизитов = Новый Массив;
		МассивРеквизитов.Добавить(ИмяДекорацияДляСкрытияТаблицыПриложений);
		Форма.ИзменитьРеквизиты(МассивРеквизитов);

		Форма.ИмяДекорацияДляСкрытияТаблицыПриложений = ДобавитьЭлементыДляСкрытияТаблицыВФормеЗадачи(
				Форма, ДеревоПриложений, ЗаголовокДекорации, "Подключаемый_ПредметыТекстНажатие");
	КонецЕсли;

	Исполнители = Элементы.Найти("Исполнители");
	ЗаголовокДекорации = НСтр("ru='Исполнители'");
	Если Исполнители = Неопределено Тогда
		Исполнители = Элементы.Найти("ХодИсполнения");
		ЗаголовокДекорации = НСтр("ru='Ход исполнения'");
	КонецЕсли;
	Если Исполнители <> Неопределено Тогда

#Если Сервер Тогда
		Исполнители.ВариантУправленияВысотой = ВариантУправленияВысотойТаблицы.ВСтрокахТаблицы;
#КонецЕсли

		Исполнители.Высота = 0;
		Исполнители.ВысотаВСтрокахТаблицы = 3;
		Исполнители.РастягиватьПоВертикали = Ложь;
		Исполнители.Видимость = Ложь;

		ИмяДекорацияДляСкрытияТаблицыПриложений = Новый РеквизитФормы("ИмяДекорацияДляСкрытияТаблицыИсполнителей",
			Новый ОписаниеТипов("Строка"));
		МассивРеквизитов = Новый Массив;
		МассивРеквизитов.Добавить(ИмяДекорацияДляСкрытияТаблицыПриложений);
		Форма.ИзменитьРеквизиты(МассивРеквизитов);

		Форма.ИмяДекорацияДляСкрытияТаблицыИсполнителей = ДобавитьЭлементыДляСкрытияТаблицыВФормеЗадачи(
				Форма, Исполнители, ЗаголовокДекорации, "Подключаемый_ИсполнителиТекстНажатие");
	КонецЕсли;

	ГруппаИнструкции = Элементы.Найти("ГруппаИнструкции");
	Если ГруппаИнструкции <> Неопределено Тогда
		ГруппаИнструкции.Заголовок = НСтр("ru='Инструкции'");
		ГруппаИнструкции.ОтображатьЗаголовок = Истина;
		ГруппаИнструкции.Поведение = ПоведениеОбычнойГруппы.Свертываемая;
		ГруппаИнструкции.Скрыть();
	КонецЕсли;
КонецПроцедуры

// Программно добавляет элементы для управления видимостью таблицей на форме.
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения  - Адаптируемая форма.
//  ТаблицаФормы  - ТаблицаФормы - Элемент формы, видимость которого учитывается.
//  ТекстДекорации  - ТаблицаФормы - Элемент формы, видимость которого учитывается.
//  ИмяСобытияНажатияДекорации  - Строка - Имя функции для события Нажатие.
// 
// Возвращаемое значение:
//	  Строка - Имя элемента декорации
//
Функция ДобавитьЭлементыДляСкрытияТаблицыВФормеЗадачи(Форма, ТаблицаФормы, ТекстДекорации, ИмяСобытияНажатияДекорации) Экспорт

	ОсноваИмениЭлементов = СтрЗаменить(ТекстДекорации, " ", "");
	ИмяЭлементаКоманднойПанели = СтрШаблон("ГруппаМКСкрытиеТаблицы%1", ОсноваИмениЭлементов);
	ИмяЭлементаДекорации = СтрШаблон("ДекорацияМКСкрытиеТаблицы%1", ОсноваИмениЭлементов);

	КоманднаяПанельМК = Форма.Элементы.Добавить(ИмяЭлементаКоманднойПанели, Тип("ГруппаФормы"), ТаблицаФормы.Родитель);
	КоманднаяПанельМК.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	КоманднаяПанельМК.ОтображатьЗаголовок = Ложь;

	Форма.Элементы.Переместить(
		КоманднаяПанельМК, ТаблицаФормы.Родитель, ТаблицаФормы);

	ДекорацияТекст = Форма.Элементы.Добавить(ИмяЭлементаДекорации, Тип("ДекорацияФормы"), КоманднаяПанельМК);
	ДекорацияТекст.Вид = ВидДекорацииФормы.Надпись;
	ДекорацияТекст.Заголовок = ТекстДекорации;
	ДекорацияТекст.ЦветТекста = WebЦвета.ЦветМорскойВолны;
	ДекорацияТекст.Подсказка = ТекстДекорации;

	Если ЗначениеЗаполнено(ИмяСобытияНажатияДекорации) Тогда
		ДекорацияТекст.Гиперссылка = Истина;
		ДекорацияТекст.УстановитьДействие("Нажатие", ИмяСобытияНажатияДекорации);
	КонецЕсли;

	Возврат ИмяЭлементаДекорации;

КонецФункции

#КонецОбласти

#Область МК_Виджеты

// Создает виджет "Показатели".
// Параметры:
//  Форма - Форма - Форма для создания виджетов
//  ДанныеВиджета - Структура - Данные виджета
//  Родитель - ГруппаФормы - Группа с виджетом
// Возвращаемое значение:
//  ГруппаФормы - созданный виджет
//
Функция СоздатьВиджетПоказатели(Форма, ДанныеВиджета, Родитель) Экспорт

	КоличествоПоказателей = ДанныеВиджета.ОсновныеПоказатели.Количество();
	Если КоличествоПоказателей > РаботаСВиджетами.ПоддерживаемоеКоличествоПоказателей() Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Виджет ""Показатели"" не поддерживает количество показателей %1.'"), КоличествоПоказателей);
	КонецЕсли;

	КонтейнерВиджета = СоздатьОсновнуюГруппу(Форма, ДанныеВиджета, Родитель);

	КонтейнерВиджета.Ширина = 10;
	КонтейнерВиджета.РастягиватьПоГоризонтали = Истина;

	ДанныеПоказателя = ДанныеВиджета.ОсновныеПоказатели[0];

	Если КоличествоПоказателей > 0 Тогда
		СоздатьГруппуСПоказателемНовые(форма, ДанныеВиджета, ДанныеПоказателя, КонтейнерВиджета);
	КонецЕсли;

	Если КоличествоПоказателей = 1 Тогда
		ДанныеВиджета.Заголовок = ДанныеПоказателя.Заголовок;
	КонецЕсли;
	
	// Заголовок.
	СоздатьВстроенныйЗаголовок(Форма, ДанныеВиджета, КонтейнерВиджета, Истина);

КонецФункции

Процедура РазместитьИконкуВиджета(Форма, ДанныеВиджета, ГруппаВиджета)

	Если ДанныеВиджета.ПоказателиЗаголовка.Количество() > 0 Тогда
		ДанныеПоказателяЗаголовка = ДанныеВиджета.ПоказателиЗаголовка[0];
	Иначе
		ДанныеПоказателяЗаголовка = ДанныеВиджета.ОсновныеПоказатели[0];
	КонецЕсли;

	СведенияОбИнтерактивнойДекорации = НовыйСведенияОбИнтерактивнойДекорации();
	СведенияОбИнтерактивнойДекорации.Действие = ДанныеПоказателяЗаголовка.Действие;
	Если Не ЗначениеЗаполнено(ДанныеВиджета.МК_Картинка) Тогда
		СведенияОбИнтерактивнойДекорации.ЭтоОтступ = Истина;
	Иначе
		СведенияОбИнтерактивнойДекорации.Картинка = ДанныеВиджета.МК_Картинка;
	КонецЕсли;

	Иконка = СоздатьИнтерактивнуюДекорацию(Форма, ДанныеВиджета, ГруппаВиджета, СведенияОбИнтерактивнойДекорации);
	Иконка.Высота = 2;
	Иконка.Ширина = 5;
	Иконка.РастягиватьПоВертикали = Истина;

КонецПроцедуры

 // Создает поле показателя виджета.
 // Параметры:
 //  Форма - Форма - Форма с виджетами
 //  ДанныеВиджета - Структура - Структура с данными виджета
 //  ДанныеПоказателя - Структура - Структура с данными показателя
 //  Родитель - ГруппаФормы - Группа - родитель для группы с виджетом
 //  ПодписьВверху - Булево - Признак, отвещающий за расположение подписи к виджету
 // 
 // Возвращаемое значение:
 //  ГруппаФормы - Группа с показателем виджета
 //
Функция СоздатьГруппуСПоказателемНовые(Форма, ДанныеВиджета, ДанныеПоказателя, Родитель) Экспорт

	Если ДанныеВиджета.ПоказателиЗаголовка.Количество() > 0 Тогда
		ДанныеПоказателяЗаголовка = ДанныеВиджета.ПоказателиЗаголовка[0];
	Иначе
		ДанныеПоказателяЗаголовка = ДанныеПоказателя;
	КонецЕсли;
	
	ЦветВиджета = ЦветВиджета(ДанныеВиджета);
	ГруппаСПоказателем = РаботаСВиджетами.СоздатьОбычнуюГруппу(Форма, ДанныеВиджета, Родитель);
	ГруппаСПоказателем.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
#Если Сервер Тогда
	ГруппаСПоказателем.ГоризонтальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Нет;
	ГруппаСПоказателем.ВертикальноеПоложениеПодчиненных = ВертикальноеПоложениеЭлемента.Центр;
#КонецЕсли
	ГруппаСПоказателем.РастягиватьПоВертикали = Ложь;
	ГруппаСПоказателем.Высота = 2;
	ГруппаСПоказателем.РастягиватьПоГоризонтали = Истина;
	ГруппаСПоказателем.ЦветФона = ЦветВиджета;

	РазместитьИконкуВиджета(Форма, ДанныеВиджета, ГруппаСПоказателем);
	
	//Вывод Индикатора
	КонтейнерИндикатора = РаботаСВиджетами.СоздатьОбычнуюГруппу(Форма, ДанныеВиджета, ГруппаСПоказателем);
	КонтейнерИндикатора.РастягиватьПоГоризонтали = Истина;
	КонтейнерИндикатора.ГоризонтальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Нет;
	КонтейнерИндикатора.ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Нет;
	КонтейнерИндикатора.ГоризонтальноеПоложениеПодчиненных = ГоризонтальноеПоложениеЭлемента.Право;
	КонтейнерИндикатора.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	КонтейнерИндикатора.ЦветФона = ЦветВиджета;

	СведенияОбИнтерактивнойДекорации = НовыйСведенияОбИнтерактивнойДекорации();
	СведенияОбИнтерактивнойДекорации.Действие = ДанныеПоказателяЗаголовка.Действие;
	СведенияОбИнтерактивнойДекорации.ВидДекорации = ВидДекорацииФормы.Картинка;
	СведенияОбИнтерактивнойДекорации.ЭтоОтступ = Истина;

	ДекорацияОтступОтИндикатора = СоздатьИнтерактивнуюДекорацию(форма,
		ДанныеВиджета,
		КонтейнерИндикатора,
		СведенияОбИнтерактивнойДекорации);
	
	ДекорацияОтступОтИндикатора.Шрифт = ШрифтыСтиля.МК_МинимальныйШрифтДляОтступа;
	ДекорацияОтступОтИндикатора.РастягиватьПоГоризонтали = Истина;
	ДекорацияОтступОтИндикатора.РастягиватьПоВертикали = Истина;
	ДекорацияОтступОтИндикатора.Гиперссылка = Истина;
	
	Индикатор = РаботаСВиджетами.СоздатьПолеПоказателя(Форма,
		ДанныеВиджета,
		ДанныеПоказателя,
		КонтейнерИндикатора);
	
	Индикатор.Фигура = ФигураКнопки.Овал;
	Если ЗначениеЗаполнено(ДанныеПоказателя.Заголовок) Тогда
		Индикатор.ЦветТекста = ЦветаСтиля.МК_ЦветТекстаАкцентнойКнопки;
	Иначе
		Индикатор.Ширина = 1;
		Индикатор.ЦветТекста = ЦветВиджета;
	КонецЕсли;

#Если Сервер Тогда
	Индикатор.ОтображениеФигуры = ОтображениеФигурыКнопки.Всегда;
#КонецЕсли

	Индикатор.Шрифт = ШрифтыСтиля.МК_ШрифтПоказателя;
	Индикатор.ВертикальноеПоложениеВГруппе = ВертикальноеПоложениеЭлемента.Верх;
	Индикатор.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Центр;
	
	СведенияОбИнтерактивнойДекорации = НовыйСведенияОбИнтерактивнойДекорации();
	СведенияОбИнтерактивнойДекорации.Действие = ДанныеПоказателяЗаголовка.Действие;
	СведенияОбИнтерактивнойДекорации.ЭтоОтступ = Истина;
	СведенияОбИнтерактивнойДекорации.ВидДекорации = ВидДекорацииФормы.Картинка;

	ДекорацияПустышкаСправаВерх = СоздатьИнтерактивнуюДекорацию(форма,
		ДанныеВиджета,
		ГруппаСПоказателем,
		СведенияОбИнтерактивнойДекорации);

	ДекорацияПустышкаСправаВерх.Ширина = 1;
	ДекорацияПустышкаСправаВерх.РастягиватьПоГоризонтали = Ложь;
	ДекорацияПустышкаСправаВерх.РастягиватьПоВертикали = Истина;
	ДекорацияПустышкаСправаВерх.Гиперссылка= Истина;

	Возврат ГруппаСПоказателем;

КонецФункции

// Адаптирует виджет "Список"
// Параметры:
//  Форма - Форма - Форма с виджетами
//  ДанныеВиджета - Структура - Структура с данными виджета
//  Родитель - ГруппаФормы - Группа с виджетом
// Возвращаемое значение:
//  ГруппаФормы -Созданная группа с виджетом 
//
Функция АдаптироватьВиджетСписок(Форма, ДанныеВиджета, Родитель) Экспорт

	ГруппаВиджета = СоздатьОсновнуюГруппу(Форма, ДанныеВиджета, Родитель);

	ДанныеПоказателя = ДанныеВиджета.ПоказателиЗаголовка[0];

	ГруппаСПоказателем = СоздатьГруппуСПоказателемНовые(Форма, ДанныеВиджета, ДанныеПоказателя, ГруппаВиджета);

	РаботаСВиджетами.УстановитьПараметрВиджета(Форма,
		ДанныеВиджета.Имя,
		ДанныеВиджета.Имя,
		"ГруппаСПоказателем",
		ГруппаСПоказателем.Имя);
		
	// Заголовок
	СоздатьВстроенныйЗаголовок(Форма, ДанныеВиджета, ГруппаВиджета, Ложь);

	Возврат ГруппаВиджета;

КонецФункции

// Адаптирует виджет-диаграмму.
// Параметры:
//  Форма - Форма - Форма для создания виджетов
//  ДанныеВиджета - Структура - Данные виджета
//  Родитель - ГруппаФормы - Группа с виджетом
// Возвращаемое значение:
//  ГруппаФормы - созданный виджет
//
Функция АдаптироватьВиджетДиаграмма(Форма, ДанныеВиджета, Родитель) Экспорт

	Действие = Неопределено;
	Если ДанныеВиджета.ПоказателиЗаголовка.Количество() = 0 Тогда
		Если ДанныеВиджета.Команды.Количество() > 0 Тогда
			ДанныеВиджета.ПоказателиЗаголовка.Добавить(ДанныеВиджета.Команды[0]);
			Действие = ДанныеВиджета.Команды[0].Действие;
		КонецЕсли;
	КонецЕсли;
	
	ГруппаВиджета = СоздатьОсновнуюГруппу(Форма, ДанныеВиджета, Родитель);
	
	ДанныеПоказателя = Справочники.ПоказателиВиджетов.СтруктураДанныеПоказателя();
	ДанныеПоказателя.Действие = Действие;
	ДанныеПоказателя.Заголовок = "";
	
	СоздатьГруппуСПоказателемНовые(Форма, ДанныеВиджета, ДанныеПоказателя, ГруппаВиджета);

	//Заголовок.
	СоздатьВстроенныйЗаголовок(Форма, ДанныеВиджета, ГруппаВиджета, Ложь);
	
	Возврат ГруппаВиджета;

КонецФункции

// Создает виджет-диаграмму
// Параметры:
//  Форма - Форма - Форма для создания виджетов
//  ДанныеВиджета - Структура - Данные виджета
//  Родитель - ГруппаФормы - Группа с виджетом
// Возвращаемое значение:
//  ГруппаФормы - созданный виджет
//
Функция СоздатьВиджетДиаграммаСЛегендой(Форма, ДанныеВиджета, Родитель) Экспорт

	ГруппаВиджета = СоздатьОсновнуюГруппу(Форма, ДанныеВиджета, Родитель);
	ГруппаВиджета.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	ГруппаВиджета.Высота = 10;
	ЦветФонаВиджета = ЦветВиджета(ДанныеВиджета);

	//Диаграмма
	ЭлементДиаграмма = СоздатьДиаграмму(Форма, ДанныеВиджета, ГруппаВиджета);
	ЭлементДиаграмма.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Лево;
	ЭлементДиаграмма.РастягиватьПоГоризонтали = Истина;
	
	// Список показателей.
	ГруппаСписокПоказателей = РаботаСВиджетами.СоздатьОбычнуюГруппу(Форма, ДанныеВиджета, ГруппаВиджета);
	ГруппаСписокПоказателей.ЦветФона = ЦветФонаВиджета;
	ГруппаСписокПоказателей.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаСписокПоказателей.ГоризонтальноеПоложениеПодчиненных = ГоризонтальноеПоложениеЭлемента.Центр;
#Если Сервер Тогда
	ГруппаСписокПоказателей.ВертикальноеПоложениеПодчиненных = ВертикальноеПоложениеЭлемента.Центр;
	ГруппаСписокПоказателей.ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Нет;
	ГруппаСписокПоказателей.ГоризонтальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Нет;
#КонецЕсли

	ГруппаСписокПоказателей.РастягиватьПоГоризонтали = Истина;
	ГруппаСписокПоказателей.РастягиватьПоВертикали = Истина;

	ГруппаСписокПоказателей.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Право;

	ГруппаСпискаВиджета = РаботаСВиджетами.СоздатьОбычнуюГруппу(Форма, ДанныеВиджета, ГруппаСписокПоказателей);
	ГруппаСпискаВиджета.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;

#Если Сервер Тогда
	ГруппаСпискаВиджета.ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Нет;
#КонецЕсли
	ГруппаСпискаВиджета.ЦветФона = ЦветФонаВиджета;
	Для Каждого ДанныеПоказателя Из ДанныеВиджета.ОсновныеПоказатели Цикл

		ГруппаПоказателя = РаботаСВиджетами.СоздатьОбычнуюГруппу(Форма, ДанныеВиджета, ГруппаСпискаВиджета);
#Если Сервер Тогда
		ГруппаПоказателя.ГоризонтальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Нет;
#КонецЕсли
		ГруппаПоказателя.РастягиватьПоГоризонтали = Истина;

		СведенияОбИнтерактивнойДекорации = НовыйСведенияОбИнтерактивнойДекорации();
		СведенияОбИнтерактивнойДекорации.Картинка = ДанныеПоказателя.Картинка;
		СведенияОбИнтерактивнойДекорации.Действие =  ДанныеПоказателя.Действие;

		ДекорацияКартинка = СоздатьИнтерактивнуюДекорацию(Форма, ДанныеВиджета, ГруппаПоказателя,
			СведенияОбИнтерактивнойДекорации);
		ДекорацияКартинка.РазмерКартинки = РазмерКартинки.Пропорционально;

		СведенияОбИнтерактивнойДекорации = НовыйСведенияОбИнтерактивнойДекорации();
		СведенияОбИнтерактивнойДекорации.Действие =  ДанныеПоказателя.Действие;
		СведенияОбИнтерактивнойДекорации.ДанныеПоказателя = ДанныеПоказателя;
		СведенияОбИнтерактивнойДекорации.ТекстоваяОснова = ДанныеПоказателя.Заголовок;
		СведенияОбИнтерактивнойДекорации.СвязатьСРеквизитомНаФорме = Истина;
		СведенияОбИнтерактивнойДекорации.Высота = 2;

		НадписьЗаголовок = СоздатьИнтерактивнуюДекорацию(Форма, ДанныеВиджета, ГруппаПоказателя,
			СведенияОбИнтерактивнойДекорации);
		НадписьЗаголовок.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Лево;
		НадписьЗаголовок.Шрифт = ШрифтыСтиля.МК_ШрифтСпискаВиджета;
		НадписьЗаголовок.ЦветТекста = ЦветаСтиля.МК_ЦветФонаГруппы;
		НадписьЗаголовок.РастягиватьПоГоризонтали = Истина;
#Если Сервер Тогда
		НадписьЗаголовок.ВертикальноеПоложениеВГруппе = ВертикальноеПоложениеЭлемента.Центр;
#КонецЕсли
	КонецЦикла;

	Возврат ГруппаВиджета;

КонецФункции

// Создает виджет-заголовок.
//  Параметры:
//   Форма - Форма - форма с виджетами
//   ДанныеВиджета - Структура - Структура с данными виджета
//   Родитель - ГруппаФормы - Группа для помещения виджета
// Возвращаемое значение:
//  ГруппаФормы - Группа с созданным виджетом
//
Функция СоздатьВиджетЗаголовок(Форма, ДанныеВиджета, Родитель) Экспорт

	КонтейнерВиджета = СоздатьОсновнуюГруппу(Форма, ДанныеВиджета, Родитель, Ложь);
	КонтейнерВиджета.Высота = 2;
	КонтейнерВиджета.РастягиватьПоВертикали = Ложь;
	ЗначимыеДанныеВиджета = РаботаСВиджетами.СоздатьОбычнуюГруппу(Форма, ДанныеВиджета, КонтейнерВиджета);
	ЗначимыеДанныеВиджета.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;

#Если Сервер Тогда
	ЗначимыеДанныеВиджета.ГоризонтальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Нет;
#КонецЕсли

	ЗначимыеДанныеВиджета.РастягиватьПоГоризонтали = Истина;
	ЗначимыеДанныеВиджета.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Лево;
	ЗначимыеДанныеВиджета.ГоризонтальноеПоложениеПодчиненных = ГоризонтальноеПоложениеЭлемента.Лево;

	Если ДанныеВиджета.ПоказателиЗаголовка.Количество() > 0 Тогда
		ДанныеПоказателя = ДанныеВиджета.ПоказателиЗаголовка[0];
		СведенияОбИнтерактивнойДекорации = НовыйСведенияОбИнтерактивнойДекорации();
		СведенияОбИнтерактивнойДекорации.ДанныеПоказателя = ДанныеПоказателя;
		СведенияОбИнтерактивнойДекорации.Действие =  ДанныеПоказателя.Действие;
		СведенияОбИнтерактивнойДекорации.ТекстоваяОснова = ДанныеПоказателя.Заголовок;
		СведенияОбИнтерактивнойДекорации.ВидДекорации = ВидДекорацииФормы.Надпись;
		СведенияОбИнтерактивнойДекорации.СвязатьСРеквизитомНаФорме = Истина;
		
		ДекорацияЗаголовок = СоздатьИнтерактивнуюДекорацию(Форма, ДанныеВиджета, ЗначимыеДанныеВиджета,
			СведенияОбИнтерактивнойДекорации);
		ДекорацияЗаголовок.Шрифт = ШрифтыСтиля.МК_ВстроенныйЗаголовокВиджетаШрифт;
		ДекорацияЗаголовок.ЦветТекста = ЦветаСтиля.ЦветТекстаПоля;
	КонецЕсли;

	ГруппаДополнительныхКоманд = РаботаСВиджетами.СоздатьОбычнуюГруппу(Форма, ДанныеВиджета, ЗначимыеДанныеВиджета);
	ГруппаДополнительныхКоманд.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Право;
	ГруппаДополнительныхКоманд.РастягиватьПоГоризонтали = Ложь;
	Для Каждого ДанныеКоманды Из ДанныеВиджета.ДополнительныеКоманды Цикл
		СведенияОбИнтерактивнойДекорации = НовыйСведенияОбИнтерактивнойДекорации();
		СведенияОбИнтерактивнойДекорации.Картинка = ДанныеКоманды.Картинка;
		СведенияОбИнтерактивнойДекорации.Действие =  ДанныеКоманды.Действие;
		СоздатьИнтерактивнуюДекорацию(Форма, ДанныеВиджета, ГруппаДополнительныхКоманд,
			СведенияОбИнтерактивнойДекорации);
	КонецЦикла;

	Возврат КонтейнерВиджета;

КонецФункции

Процедура СоздатьВстроенныйЗаголовок(Форма,
	ДанныеВиджета,
	Родитель,
	СвязатьСРеквизитомНаФорме = Истина) Экспорт

	ЕстьПоказателиЗаголовка = ДанныеВиджета.ПоказателиЗаголовка.Количество() > 0;

	ДанныеПоказателя = Неопределено;
	Действие = Неопределено;
	Если ЕстьПоказателиЗаголовка Тогда
		ДанныеПоказателя = ДанныеВиджета.ПоказателиЗаголовка[0];
		Действие = ДанныеПоказателя.Действие;
	Иначе
		ЕстьОсновныеПоказатели = ДанныеВиджета.ОсновныеПоказатели.Количество() > 0;
		Если ЕстьОсновныеПоказатели Тогда
			ДанныеПоказателя = ДанныеВиджета.ОсновныеПоказатели[0];
			Действие = ДанныеПоказателя.Действие;
		КонецЕсли;
	КонецЕсли;

	ТекстоваяОснова = ДанныеВиджета.Заголовок;
	СведенияОбИнтерактивнойДекорации = НовыйСведенияОбИнтерактивнойДекорации();
	СведенияОбИнтерактивнойДекорации.ВидДекорации = ВидДекорацииФормы.Картинка;
	СведенияОбИнтерактивнойДекорации.ДанныеПоказателя = ДанныеПоказателя;
	СведенияОбИнтерактивнойДекорации.Действие = Действие;
	СведенияОбИнтерактивнойДекорации.ТекстоваяОснова = ТекстоваяОснова;
	СведенияОбИнтерактивнойДекорации.СвязатьСРеквизитомНаФорме = СвязатьСРеквизитомНаФорме;

	ДекорацияЗаголовок = СоздатьИнтерактивнуюДекорацию(Форма,
		ДанныеВиджета,
		Родитель,
		СведенияОбИнтерактивнойДекорации);
	
	ДекорацияЗаголовок.Шрифт = ШрифтыСтиля.МК_ВстроенныйЗаголовокВиджетаШрифт;
	ДекорацияЗаголовок.Высота = 2;
	ДекорацияЗаголовок.РастягиватьПоГоризонтали = Истина;
	ДекорацияЗаголовок.ЦветТекста = ЦветаСтиля.МК_ЦветФонаГруппы;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Создаёт диаграмму виджета.
// Параметры:
//  Форма - Форма - Форма для создания виджетов
//  ДанныеВиджета - Структура - Данные виджета
//  Родитель - ГруппаФормы - Группа с виджетом
// Возвращаемое значение:
//  ГруппаФормы - созданный виджет
//
Функция СоздатьДиаграмму(Форма, ДанныеВиджета, Родитель)

	ИмяРеквизитаДиаграммы = РаботаСВиджетами.СоздатьРеквизитДиаграммы(Форма, ДанныеВиджета, "Диаграмма");

	РеквизитДиаграммы = Форма[ИмяРеквизитаДиаграммы];
	РеквизитДиаграммы.ОбластьПостроения.Шрифт = ШрифтыСтиля.МК_ПодписьВиджетаШрифт;
	РеквизитДиаграммы.ОбластьПостроения.ЦветФона = ЦветВиджета(ДанныеВиджета);

	ЭлементДиаграммы = РаботаСФормами.ДобавитьДиаграмму(
		Форма, РаботаСВиджетами.ИмяЭлемента(ДанныеВиджета, "Диаграмма"), Родитель, ИмяРеквизитаДиаграммы);

	ЭлементДиаграммы.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;

	ЭлементДиаграммы.РастягиватьПоГоризонтали = Истина;
	ЭлементДиаграммы.РастягиватьПоВертикали = Истина;

	РаботаСВиджетами.УстановитьДействиеЭлемента(
		Форма, ДанныеВиджета, ЭлементДиаграммы, "ОбработкаРасшифровки");

	Возврат ЭлементДиаграммы;

КонецФункции

// Создает декорацию - пустую картинку с текстом невыбранной картинки для визуализации нажатия на все поле виджет.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма.
//  ДанныеВиджета - Структура - Данные текущего виджета
//  Родитель - ГруппаФормы, ТаблицаФормы, ФормаКлиентскогоПриложения - Родитель для добавляемого элемента.
//  СведенияОбИнтерактивнойДекорации - Структура - Структура сведений о декорации с ключами:
//  	Действие, ТекстНевыбраннойКартинки, Картинка
// Возвращаемое значение:
//  ДекорацияФормы - Картинка формы.
//
Функция СоздатьИнтерактивнуюДекорацию(Форма, ДанныеВиджета, Родитель, СведенияОбИнтерактивнойДекорации) Экспорт

	ИмяЭлемента = РаботаСВиджетами.ИмяЭлемента(ДанныеВиджета, "Картинка");
	Декорация = Форма.Элементы.Добавить(ИмяЭлемента, Тип("ДекорацияФормы"), Родитель);

	ЭтоКартинка = СведенияОбИнтерактивнойДекорации.ВидДекорации <> ВидДекорацииФормы.Надпись;

	Если ЭтоКартинка Тогда
		Декорация.Вид = ВидДекорацииФормы.Картинка;
		КартинкаДекорации = СведенияОбИнтерактивнойДекорации.Картинка;
		Если КартинкаДекорации <> Неопределено Тогда
			Декорация.Картинка = КартинкаДекорации;
			Декорация.РазмерКартинки = РазмерКартинки.АвтоРазмер;
		КонецЕсли;
	Иначе
		Декорация.АвтоМаксимальнаяШирина = Ложь;
		Декорация.РастягиватьПоВертикали = Ложь;
		Декорация.РастягиватьПоГоризонтали = Истина;
	КонецЕсли;

	Если СведенияОбИнтерактивнойДекорации.Высота <> Неопределено Тогда
		Декорация.Высота = СведенияОбИнтерактивнойДекорации.Высота;
	Иначе
		Декорация.Высота = 1;
	КонецЕсли;

#Если Сервер Тогда
	Декорация.ВертикальноеПоложениеВГруппе = ВертикальноеПоложениеЭлемента.Центр;
#КонецЕсли

	Если СведенияОбИнтерактивнойДекорации.Действие <> Неопределено Тогда
		Декорация.Гиперссылка = Истина;
		РаботаСВиджетами.УстановитьДействиеЭлемента(Форма, ДанныеВиджета, Декорация, "Нажатие");
		РаботаСВиджетами.УстановитьДействиеВиджета(
			Форма, ДанныеВиджета, Декорация.Имя, "Нажатие", СведенияОбИнтерактивнойДекорации.Действие);
	КонецЕсли;

	ЭтоОтступ = (СведенияОбИнтерактивнойДекорации.ЭтоОтступ = Истина);
	Если Не ЭтоОтступ Тогда

		ЕстьТекстоваяОснова = ЗначениеЗаполнено(СведенияОбИнтерактивнойДекорации.ТекстоваяОснова);

		ТекстоваяОснова = ?(ЕстьТекстоваяОснова, СведенияОбИнтерактивнойДекорации.ТекстоваяОснова,
			ДанныеВиджета.Наименование);

		Если ЭтоКартинка Тогда
			Декорация.ТекстНевыбраннойКартинки = ТекстоваяОснова;
		Иначе
			Декорация.Заголовок = ТекстоваяОснова;
		КонецЕсли;

		ДанныеПоказателя = СведенияОбИнтерактивнойДекорации.ДанныеПоказателя;

		Если ДанныеПоказателя <> Неопределено И СведенияОбИнтерактивнойДекорации.СвязатьСРеквизитомНаФорме = Истина Тогда
			
				//Создадим реквизит на форме для хранения значений показателя 
			РаботаСВиджетами.СоздатьРеквизит(
					Форма, ДанныеВиджета, ДанныеПоказателя.Заголовок + "Показатель",
				ОбщегоНазначения.ОписаниеТипаСтрока(5), ДанныеПоказателя.Выражение, ДанныеПоказателя.События,
				ДанныеПоказателя.Показатель, Декорация.Имя, ТекстоваяОснова);
		КонецЕсли;
	Иначе
		Декорация.Ширина = 1;
	КонецЕсли;

	Возврат Декорация;

КонецФункции

// Создаёт основную группу виджета.
Функция СоздатьОсновнуюГруппу(Форма, ДанныеВиджета, Родитель, ИспользоватьЦветВиджета = Истина)

	Если ДанныеВиджета.ОсновнаяГруппа <> Неопределено Тогда
		ТекстОшибки = НСтр("ru = 'Основная группа виджета уже создана.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;

	ГруппаСРазделителемСлева = РаботаСФормами.ДобавитьОбычнуюГруппу(
		Форма, ДанныеВиджета.ПространствоИмен + "ГруппаСРазделителемСлева", Родитель);
	ГруппаСРазделителемСлева.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	ГруппаСРазделителемСлева.ГоризонтальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Нет;
	ГруппаСРазделителемСлева.ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Нет;

	ВспомогательныйРазделительСлева= РаботаСФормами.ДобавитьНадпись(Форма, ДанныеВиджета.ПространствоИмен
		+ "РазделительСлева", ГруппаСРазделителемСлева, "");
	ВспомогательныйРазделительСлева.Шрифт = Новый Шрифт(, 1);
	ВспомогательныйРазделительСлева.ЦветФона = ЦветаСтиля.ЦветФонаФормы;

	НомерВиджета = 1;
	ОригинальноеИмяВиджета = ДанныеВиджета.Имя;
	Пока Форма.Элементы.Найти(ДанныеВиджета.ПространствоИмен) <> Неопределено Цикл
		ДанныеВиджета.Имя = ОригинальноеИмяВиджета + Формат(НомерВиджета, "ЧГ=0");
		Справочники.Виджеты.ИнициализироватьВиджет(ДанныеВиджета);
		НомерВиджета = НомерВиджета + 1;
	КонецЦикла;

	КонтейнерВиджета = РаботаСФормами.ДобавитьОбычнуюГруппу(
		Форма, ДанныеВиджета.ПространствоИмен + "Контейнер", ГруппаСРазделителемСлева);
	КонтейнерВиджета.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	КонтейнерВиджета.Ширина = 14;
	КонтейнерВиджета.Высота = 8;
	КонтейнерВиджета.РастягиватьПоВертикали = Ложь;

#Если Сервер Тогда
	КонтейнерВиджета.ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Нет;
	КонтейнерВиджета.ГоризонтальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Нет;
#КонецЕсли

	Если ИспользоватьЦветВиджета Тогда
		КонтейнерВиджета.ЦветФона = ЦветВиджета(ДанныеВиджета);
	КонецЕсли;

#Если Сервер Тогда
	КонтейнерВиджета.ВертикальноеПоложениеПодчиненных = ВертикальноеПоложениеЭлемента.Центр;
#КонецЕсли

	ВспомогательныйРазделительСверху = РаботаСФормами.ДобавитьНадпись(Форма, ДанныеВиджета.ПространствоИмен
		+ "РазделительСверху", КонтейнерВиджета, "");
	ВспомогательныйРазделительСверху.Шрифт = Новый Шрифт(, 2);
	ВспомогательныйРазделительСверху.Высота = 2;
	Если ИспользоватьЦветВиджета Тогда
		ВспомогательныйРазделительСверху.ЦветФона = ЦветВиджета(ДанныеВиджета);
	КонецЕсли;
	ДанныеВиджета.ОсновнаяГруппа = КонтейнерВиджета;

	РаботаСВиджетами.УстановитьОсновнуюГруппуВиджета(Форма, ДанныеВиджета.Имя, КонтейнерВиджета.Имя);

	Возврат КонтейнерВиджета;

КонецФункции

//Формирует пустую структуру сведений об интерактивной декорации
// Возвращаемое значение:
// Структура - Структура для последующего заполнения сведений об интеракитвной декорации
Функция НовыйСведенияОбИнтерактивнойДекорации()

	Возврат Новый Структура("
							|Действие,
							|Картинка,
							|Высота,
							|ДанныеПоказателя,
							|СвязатьСРеквизитомНаФорме,
							|ТекстоваяОснова,
							|ЭтоОтступ,
							|ВидДекорации");

КонецФункции

Функция ЦветВиджета(ДанныеВиджета)

	ИндексЦветаФона = МК.ИндексЦветаВиджетов();
	Если ИндексЦветаФона = 0 Тогда
		ЦветФонаВиджета = ЦветаСтиля.МК_ЦветВиджета;
	Иначе
		ЦветФонаВиджета = Перечисления.ЦветаВиджетов.ЦветФона(ДанныеВиджета.Цвет);
	КонецЕсли;

	Возврат ЦветФонаВиджета;

КонецФункции

#КонецОбласти