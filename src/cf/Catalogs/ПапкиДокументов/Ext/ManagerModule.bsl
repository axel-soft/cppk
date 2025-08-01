﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей папки
//
// Возвращаемое значение:
//   Структура
//     Родитель
//     Наименование
//     Описание
//     Ответственный
//     ДатаСоздания
//
Функция ПолучитьСтруктуруПапки() Экспорт
	
	ПараметрыПапки = Новый Структура;
	ПараметрыПапки.Вставить("Родитель");
	ПараметрыПапки.Вставить("Наименование");
	ПараметрыПапки.Вставить("Описание");
	ПараметрыПапки.Вставить("Ответственный");
	ПараметрыПапки.Вставить("ДатаСоздания");
	
	Возврат ПараметрыПапки;
	
КонецФункции

// Создает и записывает в БД папку документов предприятия
//
// Параметры:
//   СтруктураПапки - Структура - структура полей папки.
// Возвращаемое значение - ссылка на созданную папку
//
Функция СоздатьПапку(СтруктураПапки) Экспорт
	
	НоваяПапка = СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НоваяПапка, СтруктураПапки);
	НоваяПапка.Записать();
	
	Возврат НоваяПапка.Ссылка;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка";
	
КонецФункции

// Заполняет переданный дескриптор доступа
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДокументооборотПраваДоступа.ЗаполнитьНастройкиДескриптора(ДескрипторДоступа, ОбъектДоступа);
	
КонецПроцедуры	

// Возвращает признак того, что менеджер содержит метод ЗапросДляРасчетаПрав()
// 
Функция ЕстьМетодЗапросДляРасчетаПрав() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает запрос для расчета прав доступа по дескрипторам объекта
// 
// Параметры:
//  
//  Дескрипторы - Массив - массив дескрипторов, чьи права нужно рассчитать
//  ИдОбъекта - Ссылка - идентификатор объекта метаданных, назначенный переданным дескрипторам
//  МенеджерОбъектаДоступа - СправочникМенеджер, ДокументМенеджер - менеджер объекта доступа
// 
// Возвращаемое значение - Запрос - запрос, который выберет права доступа для переданного массива дескрипторов
// 
Функция ЗапросДляРасчетаПрав(Дескрипторы, ИдОбъекта, МенеджерОбъектаДоступа) Экспорт
	
	Запрос = Справочники.ДескрипторыДоступаОбъектов.ЗапросДляСтандартногоРасчетаПрав(
		Дескрипторы, ИдОбъекта, МенеджерОбъектаДоступа, Истина, Ложь);
	Запрос.Текст = ДокументооборотПраваДоступаПовтИсп.ТекстЗапросаДляРасчетаПравПапок();
	
	Возврат Запрос;
	
КонецФункции

// Заполняет протокол расчета прав дескрипторов
// 
// Параметры:
//  
//  ПротоколРасчетаПрав - Массив - протокол для заполнения
//  ЗапросПоПравам - Запрос - запрос, который использовался для расчета прав дескрипторов
//  Дескрипторы - Массив - массив дескрипторов, чьи права были рассчитаны
//  
Процедура ЗаполнитьПротоколРасчетаПрав(ПротоколРасчетаПрав, ЗапросПоПравам) Экспорт
	
	Справочники.ДескрипторыДоступаОбъектов.ЗаполнитьПротоколРасчетаПравСтандартно(
		ПротоколРасчетаПрав, ЗапросПоПравам);
	
КонецПроцедуры

Функция ЕстьМетодПолучитьПравилаОбработкиНастроекПравПапки() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает таблицу значений с правилами обработки настроек прав папки,
// которые следует применять для расчета прав объекта
// 
Функция ПолучитьПравилаОбработкиНастроекПравПапки() Экспорт
	
	ТаблицаПравил = ДокументооборотПраваДоступа.ТаблицаПравилОбработкиНастроекПапки();
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ЧтениеПапокИДокументовПредприятия";
	Стр.Чтение = Истина;
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ИзменениеПапокДокументовПредприятия";
	Стр.Добавление = Истина;
	Стр.Изменение = Истина;
	Стр.Удаление = Истина;
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "УправлениеПравами";
	Стр.УправлениеПравами = Истина;
	
	Возврат ТаблицаПравил;
	
КонецФункции

#КонецОбласти

#КонецЕсли
