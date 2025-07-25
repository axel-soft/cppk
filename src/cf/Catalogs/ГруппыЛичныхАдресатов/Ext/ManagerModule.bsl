﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ОбновлениеАдреснойКниги

// Конструктор параметров обновления адресной книги.
//
// Возвращаемое значение:
//	Структура:
//		* ОбновитьДанныеОбъекта - Булево - Признак обновления данных по объекту.
//
Функция ПараметрыОбновленияАдреснойКниги() Экспорт
	
	ПараметрыОбновленияАдреснойКниги = Новый Структура;
	ПараметрыОбновленияАдреснойКниги.Вставить("ОбновитьДанныеОбъекта", Ложь);
	
	Возврат ПараметрыОбновленияАдреснойКниги;
	
КонецФункции

// Устанавливает значения параметров обновления адресной книги по данным объекта.
//
// Параметры:
//	Объект - СправочникОбъект.ГруппыЛичныхАдресатов - Объект, для которго необходимо определить параметры обновления.
//
// Возвращаемое значение:
//	Структура: см. ПараметрыОбновленияАдреснойКниги.
//
Функция ЗначенияПараметровОбновленияАдреснойКнигиПоОбъекту(Объект) Экспорт
	
	ПараметрыОбновленияАдреснойКниги = ПараметрыОбновленияАдреснойКниги();
			
	Если Не РаботаСАдреснойКнигой.ТребуетсяОбновлениеАдреснойКниги(Объект) Тогда
		Возврат ПараметрыОбновленияАдреснойКниги; 
	КонецЕсли;

	Если Объект.ЭтоНовый() Тогда
		ПараметрыОбновленияАдреснойКниги.ОбновитьДанныеОбъекта = Истина;
	Иначе
		ПредыдущиеЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Объект.Ссылка, "Наименование, ПометкаУдаления, Родитель");

		Если ПредыдущиеЗначенияРеквизитов.Родитель <> Объект.Родитель
			Или ПредыдущиеЗначенияРеквизитов.ПометкаУдаления <> Объект.ПометкаУдаления
			Или ПредыдущиеЗначенияРеквизитов.Наименование <> Объект.Наименование Тогда
			
			ПараметрыОбновленияАдреснойКниги.ОбновитьДанныеОбъекта = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПараметрыОбновленияАдреснойКниги;

КонецФункции

// Обновляет адресную книгу, согласно установленным параметрам.
//
// Параметры:
//	Объект - СправочникОбъект.ГруппыЛичныхАдресатов - Объект, по данным которого необходимо обновить адресной книги.
//	ПараметрыОбновления - Структура Из КлючИЗначение - см. ПараметрыОбновленияАдреснойКниги.
//
Процедура ОбновитьАдреснуюКнигу(Объект, ПараметрыОбновления) Экспорт
	
	Если ПараметрыОбновления.ОбновитьДанныеОбъекта Тогда
		Справочники.АдреснаяКнига.ОбновитьДанныеОбъекта(
			Объект.Ссылка, Объект.Родитель, Справочники.АдреснаяКнига.ЛичныеАдресаты, Объект.Сотрудник);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли