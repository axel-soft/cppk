﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Записывает или удаляет запись регистра
//
// Параметры
// ФайлОбъект  - СправочникОбъект.Файлы - файл, для которого надо обновить запись в регистре ЗанятыеФайлы
// ПредыдущееЗначениеРедактирует  - СправочникСсылка.Пользователи
//
Процедура ОбновитьЗапись(ФайлОбъект, ПредыдущееЗначениеРедактирует = Ложь, ОбновлениеДанных = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(ФайлОбъект.Редактирует)
		И ЗначениеЗаполнено(ПредыдущееЗначениеРедактирует) Тогда
		
		НаборЗаписей = РегистрыСведений.ЗанятыеФайлы.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Файл.Установить(ФайлОбъект.Ссылка);
		
		Если ОбновлениеДанных Тогда
			ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(НаборЗаписей);
		Иначе	
			НаборЗаписей.Записать(); // записываем, стирая старые записи с отбором по Файл
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ФайлОбъект.Редактирует) Тогда	
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗанятыеФайлы");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Файл", ФайлОбъект.Ссылка);
			Блокировка.Заблокировать();   		
				
			НаборЗаписей = РегистрыСведений.ЗанятыеФайлы.СоздатьНаборЗаписей();
			// ставим отбор только по файлу, чтобы стереть старые записи с отбором по Файл
			НаборЗаписей.Отбор.Файл.Установить(ФайлОбъект.Ссылка);
			
			НоваяЗапись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, ФайлОбъект);
			НоваяЗапись.Файл = ФайлОбъект.Ссылка;
			
			Если ТипЗнч(ФайлОбъект.Редактирует) = Тип("СправочникСсылка.Сотрудники") Тогда
				НоваяЗапись.Редактирует = Сотрудники.ПользовательСотрудника(ФайлОбъект.Редактирует);
			КонецЕсли;	
			
			Если ОбновлениеДанных Тогда
				ОбновлениеИнформационнойБазыХолдинг.ЗаписатьДанные(НаборЗаписей);
			Иначе	
				НаборЗаписей.Записать(); // записываем, стирая старые записи с отбором по Файл
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
			
	КонецЕсли;	
	
КонецПроцедуры	

#КонецОбласти

#КонецЕсли
