﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("КомуВыдан");
	НеРедактируемыеРеквизиты.Добавить("Фирма");
	НеРедактируемыеРеквизиты.Добавить("Фамилия");
	НеРедактируемыеРеквизиты.Добавить("Имя");
	НеРедактируемыеРеквизиты.Добавить("Отчество");
	НеРедактируемыеРеквизиты.Добавить("Должность");
	НеРедактируемыеРеквизиты.Добавить("КемВыдан");
	НеРедактируемыеРеквизиты.Добавить("ДействителенДо");
	НеРедактируемыеРеквизиты.Добавить("Подписание");
	НеРедактируемыеРеквизиты.Добавить("Шифрование");
	НеРедактируемыеРеквизиты.Добавить("Отпечаток");
	НеРедактируемыеРеквизиты.Добавить("ДанныеСертификата");
	НеРедактируемыеРеквизиты.Добавить("Программа");
	НеРедактируемыеРеквизиты.Добавить("Отозван");
	НеРедактируемыеРеквизиты.Добавить("ВводитьПарольВПрограммеЭлектроннойПодписи");
	НеРедактируемыеРеквизиты.Добавить("Организация");
	НеРедактируемыеРеквизиты.Добавить("Пользователь");
	НеРедактируемыеРеквизиты.Добавить("Добавил");
	НеРедактируемыеРеквизиты.Добавить("ОбязательныйДляШифрования");
	
	Если Метаданные.Обработки.Найти("ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата") <> Неопределено Тогда
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата =
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				"Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.РеквизитыНеРедактируемыеВГрупповойОбработке(
			НеРедактируемыеРеквизиты);
	КонецЕсли;
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ВариантыОтчетов

// Определяет список команд отчетов.
//
// Параметры:
//  КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//  Параметры - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Отчеты.СертификатыЭлектроннойПодписи) Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.ИмяФормы = "ОбщаяФорма.НастройкиЭлектроннойПодписиИШифрования" Тогда
		Команда = КомандыОтчетов.Добавить();
		Команда.КлючВарианта      = "СертификатыЭлектроннойПодписи";
		Команда.Представление     = НСтр("ru = 'Сертификаты электронной подписи'");
		Команда.Идентификатор     = "СертификатыЭлектроннойПодписи";
		Команда.Менеджер          = "Отчет.СертификатыЭлектроннойПодписи";
		Команда.Неконтекстный     = Истина;
		
		Команда = КомандыОтчетов.Добавить();
		Команда.КлючВарианта      = "ЗаканчиваетсяСрокДействия";
		Команда.Представление     = НСтр("ru = 'Сертификаты, у которых заканчивается срок действия'");
		Команда.Идентификатор     = "ЗаканчиваетсяСрокДействия";
		Команда.Менеджер          = "Отчет.СертификатыЭлектроннойПодписи";
		Команда.Неконтекстный     = Истина;
		
		Команда = КомандыОтчетов.Добавить();
		Команда.КлючВарианта      = "СертификатыСотрудников";
		Команда.Представление     = НСтр("ru = 'Сертификаты сотрудников'");
		Команда.Идентификатор     = "СертификатыСотрудников";
		Команда.Менеджер          = "Отчет.СертификатыЭлектроннойПодписи";
		Команда.Неконтекстный     = Истина;
		
		Команда = КомандыОтчетов.Добавить();
		Команда.КлючВарианта      = "ТребуетсяВыпускСертификатаФЛ";
		Команда.Представление     = НСтр("ru = 'Требуется выпуск сертификата физического лица'");
		Команда.Идентификатор     = "ТребуетсяВыпускСертификатаФЛ";
		Команда.Менеджер          = "Отчет.СертификатыЭлектроннойПодписи";
		Команда.Неконтекстный     = Истина;
		
		Команда = КомандыОтчетов.Добавить();
		Команда.КлючВарианта      = "ТребуетсяМЧД";
		Команда.Представление     = НСтр("ru = 'Сертификаты, для которых требуется МЧД'");
		Команда.Идентификатор     = "ТребуетсяМЧД";
		Команда.Менеджер          = "Отчет.СертификатыЭлектроннойПодписи";
		Команда.Неконтекстный     = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаСписка" Тогда
		СтандартнаяОбработка = Ложь;
		Параметры.Вставить("ПоказатьСтраницу", "Сертификаты");
		ВыбраннаяФорма = Метаданные.ОбщиеФормы.НастройкиЭлектроннойПодписиИШифрования;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления.

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// для которых необходимо обновить записи в регистре.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи.Ссылка,
	|	КОЛИЧЕСТВО(СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи.Пользователь) КАК Пользователь
	|ПОМЕСТИТЬ ОдинПользовательВТабличнойЧасти
	|ИЗ
	|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Пользователи КАК
	|		СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи
	|СГРУППИРОВАТЬ ПО
	|	СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи.Ссылка
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(СертификатыКлючейЭлектроннойПодписиИШифрованияПользователи.Пользователь) = 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК СертификатыКлючейЭлектроннойПодписиИШифрования
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОдинПользовательВТабличнойЧасти КАК ОдинПользовательВТабличнойЧасти
	|		ПО СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка = ОдинПользовательВТабличнойЧасти.Ссылка
	|ГДЕ
	|	СертификатыКлючейЭлектроннойПодписиИШифрования.УдалитьПользовательОповещенОСрокеДействия
	|	ИЛИ &УсловиеЗаявления
	|	ИЛИ СертификатыКлючейЭлектроннойПодписиИШифрования.ДействителенДо > &ТекущаяДата
	|	ИЛИ НЕ ОдинПользовательВТабличнойЧасти.Ссылка ЕСТЬ NULL";

	
	Если ЭлектроннаяПодпись.ОбщиеНастройки().ЗаявлениеНаВыпускСертификатаДоступно Тогда
		
		МодульЗаявлениеНаВыпускНовогоКвалифицированногоСертификата = ОбщегоНазначения.ОбщийМодуль(
			"Обработки.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеЗаявления",
			"СертификатыКлючейЭлектроннойПодписиИШифрования.УдалитьСостояниеЗаявления <> &ПустаяСсылка");
		Запрос.УстановитьПараметр("ПустаяСсылка", 
			МодульЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.СостоянияЗаявленияПустаяСсылка());
		
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИЛИ &УсловиеЗаявления", "");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());

	МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

// Добавить записи регистра.
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь,
		"Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования");
	Если Выборка.Количество() > 0 Тогда
		ОбработатьЗаявленияОповещенияИСрокДействияСертификатов(Выборка);
	КонецЕсли;

	ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь,
		"Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования");
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьЗаявленияОповещенияИСрокДействияСертификатов(Выборка)
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;

	ЗаявлениеНаВыпускСертификатаДоступно = ЭлектроннаяПодпись.ОбщиеНастройки().ЗаявлениеНаВыпускСертификатаДоступно;
	
	Если ЗаявлениеНаВыпускСертификатаДоступно Тогда
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата =
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				"Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл

		ПредставлениеСсылки = Строка(Выборка.Ссылка);

		НачатьТранзакцию();
		Попытка

			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			Блокировка.Заблокировать();
			
			ЗаписатьОбъект = Ложь;

			СертификатОбъект = Выборка.Ссылка.ПолучитьОбъект(); // СправочникОбъект.СертификатыКлючейЭлектроннойПодписиИШифрования
			
			// Перенос оповещений о необходимости замены сертификата в регистр сведений.
			Если СертификатОбъект.УдалитьПользовательОповещенОСрокеДействия Тогда
				НаборЗаписейОповещений = РегистрыСведений.ОповещенияПользователейСертификатов.СоздатьНаборЗаписей();
				НаборЗаписейОповещений.Отбор.Сертификат.Установить(Выборка.Ссылка);

				Если СертификатОбъект.Пользователи.Количество() > 0 Тогда
					
					ТаблицаПользователей = СертификатОбъект.Пользователи.Выгрузить();
					ТаблицаПользователей.Свернуть("Пользователь");
					
					Для Каждого СтрокаПользователь Из ТаблицаПользователей Цикл
						ЗаписьНабораОповещений = НаборЗаписейОповещений.Добавить();
						ЗаписьНабораОповещений.Сертификат = Выборка.Ссылка;
						ЗаписьНабораОповещений.Пользователь = СтрокаПользователь.Пользователь;
						ЗаписьНабораОповещений.Оповещен = Истина;
					КонецЦикла;
					
				ИначеЕсли ЗначениеЗаполнено(СертификатОбъект.Пользователь) Тогда
					ЗаписьНабораОповещений = НаборЗаписейОповещений.Добавить();
					ЗаписьНабораОповещений.Сертификат = Выборка.Ссылка;
					ЗаписьНабораОповещений.Пользователь = СертификатОбъект.Пользователь;
					ЗаписьНабораОповещений.Оповещен = Истина;
				КонецЕсли;
				Если НаборЗаписейОповещений.Количество() > 0 Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписейОповещений, Истина);
				КонецЕсли;
				СертификатОбъект.УдалитьПользовательОповещенОСрокеДействия = Ложь;
				ЗаписатьОбъект = Истина;
			КонецЕсли;
			
			// Перенос данных заявлений в регистр сведений.
			Если ЗаявлениеНаВыпускСертификатаДоступно
			   И ЗначениеЗаполнено(СертификатОбъект.УдалитьСостояниеЗаявления) Тогда
				
				ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ОбработатьДанныеДляПереходаНаНовуюВерсию(
					СертификатОбъект, ЗаписатьОбъект);

			КонецЕсли;
			
			Если СертификатОбъект.Пользователи.Количество() = 1 Тогда
				СертификатОбъект.Пользователь = СертификатОбъект.Пользователи[0].Пользователь;
				СертификатОбъект.Пользователи.Очистить();
				ЗаписатьОбъект = Истина;
			КонецЕсли;
			
			Если СертификатОбъект.ДействителенДо > ТекущаяДатаСеанса() Тогда
				ДвоичныеДанныеСертификата = СертификатОбъект.ДанныеСертификата.Получить();
				Если ТипЗнч(ДвоичныеДанныеСертификата) = Тип("ДвоичныеДанные") Тогда
					Попытка
						Сертификат = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
					Исключение
						Сертификат = Неопределено;
					КонецПопытки;

					Если Сертификат <> Неопределено Тогда
						СвойстваСертификата = ЭлектроннаяПодписьСлужебныйКлиентСервер.СвойстваСертификата(
							Сертификат, ЭлектроннаяПодписьСлужебный.РазницаСУниверсальнымВременем(),
							ДвоичныеДанныеСертификата);
						Если СертификатОбъект.ДействителенДо <> СвойстваСертификата.ДействителенДо Тогда
							СтрокаПоиска = Формат(СертификатОбъект.ДействителенДо, "ДФ=MM.yyyy");
							СтрокаЗамены = Формат(СвойстваСертификата.ДействителенДо, "ДФ=MM.yyyy");
							СертификатОбъект.Наименование = СтрЗаменить(СертификатОбъект.Наименование, СтрокаПоиска,
								СтрокаЗамены);
							СертификатОбъект.ДействителенДо = СвойстваСертификата.ДействителенДо;
							ЗаписатьОбъект = Истина;
						КонецЕсли;

						Если ЗначениеЗаполнено(СертификатОбъект.Программа) И ТипЗнч(СертификатОбъект.Программа) = Тип(
							"СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования") Тогда

							АлгоритмСертификата = ЭлектроннаяПодписьСлужебныйКлиентСервер.АлгоритмПодписиСертификата(
								ДвоичныеДанныеСертификата, Ложь, Истина);
							Если ЭлектроннаяПодписьСлужебныйКлиентСервер.ЭтоСертификатГОСТ(АлгоритмСертификата) Тогда

								ОписаниеПрограммы = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
									СертификатОбъект.Программа,
									"ЭтоВстроенныйКриптопровайдер, АлгоритмПодписи, АлгоритмХеширования");

								Если Не ОписаниеПрограммы.ЭтоВстроенныйКриптопровайдер Тогда

									Результат = ЭлектроннаяПодписьСлужебныйКлиентСервер.АлгоритмПодписиСоответствуетСертификату(
										"", АлгоритмСертификата, ОписаниеПрограммы.АлгоритмПодписи, ОписаниеПрограммы.АлгоритмХеширования);

									Если Результат <> Истина Тогда

										СертификатОбъект.Программа = Справочники.ПрограммыЭлектроннойПодписиИШифрования.ПустаяСсылка();
										ЗаписатьОбъект = Истина;

									КонецЕсли;
								КонецЕсли;

							КонецЕсли;
						КонецЕсли;

					КонецЕсли;
				КонецЕсли;
			КонецЕсли;

			Если ЗаписатьОбъект Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СертификатОбъект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			КонецЕсли;

			ОбъектовОбработано = ОбъектовОбработано + 1;
			ЗафиксироватьТранзакцию();

		Исключение

			ОтменитьТранзакцию();
			// Если не удалось обработать какой-либо сертификат, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ЭлектроннаяПодписьДокументооборот.ЗаписатьОшибкуВЖурналРегистрации(
				Выборка.Ссылка,
				ПредставлениеСсылки,
				ИнформацияОбОшибке());
		КонецПопытки;

	КонецЦикла;

	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать некоторые сертификаты (пропущены): %1'"),
			ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования,,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обработана очередная порция сертификатов: %1'"), ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
