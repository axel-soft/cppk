﻿////////////////////////////////////////////////////////////////////////////////
// Работа с часовыми поясами (сервер).
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает данные известного часового пояса.
//
// Параметры:
//  ЧасовойПояс - Строка - Часовой пояс в формате GMT{+/-}hh:mm.
// 
// Возвращаемое значение:
//  Структура, Неопределено - Данные известного часового пояса. Если часовой пояс не известен - возвращает Неопределено.
//
Функция ДанныеЧасовогоПояса(ЧасовойПояс) Экспорт
	
	ИзвестныеЧасовыеПояса = РаботаСЧасовымиПоясамиПовтИсп.ИзвестныеЧасовыеПояса();
	
	ДанныеЧасовогоПояса = ИзвестныеЧасовыеПояса[ЧасовойПояс];
	
	Возврат ДанныеЧасовогоПояса;
	
КонецФункции

// Возвращает параметры преобразования местного времени.
// 
// Возвращаемое значение:
//  Структура - Параметры преобразования местного времени.
//   * РежимОтображенияМестногоВремени - ПеречислениеСсылка.РежимыОтображенияМестногоВремени - Действующий режим отображения местного времени.
//   * МестныйЧасовойПояс              - Строка                                              - Местный часовой пояс в формате GMT{+/-}hh:mm.
//   * ЧасовойПоясПоУмолчанию          - Строка                                              - Часовой пояс по умолчанию в формате GMT{+/-}hh:mm.
//
Функция ПараметрыПреобразованияМестногоВремени() Экспорт
	
	ПараметрыПреобразования = Новый Структура(
		"РежимОтображенияМестногоВремени, МестныйЧасовойПояс, ЧасовойПоясПоУмолчанию, ПредставлениеМестногоЧасовогоПояса");
	ПараметрыПреобразования.РежимОтображенияМестногоВремени =
		РаботаСЧасовымиПоясамиПовтИсп.РежимОтображенияМестногоВремени();
	ПараметрыПреобразования.МестныйЧасовойПояс = МестныйЧасовойПояс();
	ПараметрыПреобразования.ЧасовойПоясПоУмолчанию = ЧасовойПоясПоУмолчанию();
	ПараметрыПреобразования.ПредставлениеМестногоЧасовогоПояса = ПредставлениеМестногоЧасовогоПояса();
	
	Возврат ПараметрыПреобразования;
	
КонецФункции

// Преобразует дату в часовом поясе сеанса к местному времени.
//
// Параметры:
//  Дата                    - Дата      - Дата в часовом поясе сеанса.
//  ПараметрыПреобразования - Структура - Параметры преобразования местно времени. См. РаботаСЧасовымиПоясами.ПараметрыПреобразованияМестногоВремени().
// 
// Возвращаемое значение:
//  Дата - Местное время.
//
Функция ПривестиКМестномуВремени(ДатаСеанса) Экспорт
	
	ПараметрыПреобразованияМестногоВремени = ПараметрыПреобразованияМестногоВремени();
	
	Возврат ПривестиКМестномуВремениСПараметрами(
		ДатаСеанса,
		ПараметрыПреобразованияМестногоВремени);
	
КонецФункции

// Преобразует дату в часовом поясе сеанса к местному времени.
//
// Параметры:
//  Дата                    - Дата      - Дата в часовом поясе сеанса.
//  ПараметрыПреобразования - Структура - Параметры преобразования местно времени. См. РаботаСЧасовымиПоясами.ПараметрыПреобразованияМестногоВремени().
// 
// Возвращаемое значение:
//  Дата - Местное время.
//
Функция ПривестиКМестномуВремениСПараметрами(ДатаСеанса, ПараметрыПреобразования) Экспорт
	
	Если Не ЗначениеЗаполнено(ДатаСеанса) Тогда
		Возврат ДатаСеанса;
	КонецЕсли;
	
	Если ПараметрыПреобразования.РежимОтображенияМестногоВремени =
			ПредопределенноеЗначение("Перечисление.РежимыОтображенияМестногоВремени.ВремяСеанса") Тогда
		Возврат ДатаСеанса;
	КонецЕсли;
	
	ДанныеПоясаСеанса = ДанныеЧасовогоПояса(ПараметрыПреобразования.ЧасовойПоясПоУмолчанию);
	ДанныеМестногоПояса = ДанныеЧасовогоПояса(ПараметрыПреобразования.МестныйЧасовойПояс);
	Если ДанныеМестногоПояса = Неопределено Или ДанныеПоясаСеанса = Неопределено Тогда
		Возврат ДатаСеанса;
	КонецЕсли;
	
	УниверсальнаяДата = РаботаСЧасовымиПоясамиКлиентСервер.УниверсальноеВремяПоДаннымПояса(ДатаСеанса, ДанныеПоясаСеанса);
	
	Возврат РаботаСЧасовымиПоясамиКлиентСервер.МестноеВремяПоДаннымПояса(УниверсальнаяДата, ДанныеМестногоПояса);
	
КонецФункции

// Преобразует местное время к дате в часовом поясе сеанса.
//
// Параметры:
//  Дата                    - Дата      - Местное время.
//  ПараметрыПреобразования - Структура - Параметры преобразования местно времени. См. РаботаСЧасовымиПоясами.ПараметрыПреобразованияМестногоВремени().
// 
// Возвращаемое значение:
//  Дата - Дата в часовом поясе сеанс.
//
Функция ПривестиКВремениСеанса(МестнаяДата) Экспорт
	
	Возврат ПривестиКВремениСеансаСПараметрами(
		МестнаяДата,
		ПараметрыПреобразованияМестногоВремени());
	
КонецФункции

// Преобразует местное время к дате в часовом поясе сеанса.
//
// Параметры:
//  МестнаяДата             - Дата      - Местное время.
//  ПараметрыПреобразования - Структура - Параметры преобразования местно времени. См. РаботаСЧасовымиПоясами.ПараметрыПреобразованияМестногоВремени().
// 
// Возвращаемое значение:
//  Дата - Дата в часовом поясе сеанс.
//
Функция ПривестиКВремениСеансаСПараметрами(МестнаяДата, ПараметрыПреобразования) Экспорт
	
	Если Не ЗначениеЗаполнено(МестнаяДата) Тогда
		Возврат МестнаяДата;
	КонецЕсли;
	
	Если ПараметрыПреобразования.РежимОтображенияМестногоВремени =
			ПредопределенноеЗначение("Перечисление.РежимыОтображенияМестногоВремени.ВремяСеанса") Тогда
		Возврат МестнаяДата;
	КонецЕсли;
	
	ДанныеПоясаСеанса = ДанныеЧасовогоПояса(ПараметрыПреобразования.ЧасовойПоясПоУмолчанию);
	ДанныеМестногоПояса = ДанныеЧасовогоПояса(ПараметрыПреобразования.МестныйЧасовойПояс);
	Если ДанныеМестногоПояса = Неопределено Или ДанныеПоясаСеанса = Неопределено Тогда
		Возврат МестнаяДата;
	КонецЕсли;
	
	УниверсальнаяДата = РаботаСЧасовымиПоясамиКлиентСервер.УниверсальноеВремяПоДаннымПояса(МестнаяДата, ДанныеМестногоПояса);
	
	Возврат РаботаСЧасовымиПоясамиКлиентСервер.МестноеВремяПоДаннымПояса(УниверсальнаяДата, ДанныеПоясаСеанса);
	
КонецФункции

// Преобразует местное время пользователя к дате в часовом поясе сеанса.
//
// Параметры:
//  МестнаяДатаПользователя - Дата.
//  Пользователь - СправочникСсылка.Пользователи.
// 
// Возвращаемое значение:
//  Дата - Дата в часовом поясе сеанса.
//
Функция ПривестиМестноеВремяПользователяКВремениСеанса(МестнаяДатаПользователя, Пользователь) Экспорт
	
	НастройкаРежимОтображенияМестногоВремени = РаботаСЧасовымиПоясамиПовтИсп.НастройкаРежимОтображенияМестногоВремени();
	Если НастройкаРежимОтображенияМестногоВремени = Перечисления.РежимыОтображенияМестногоВремени.ВремяСеанса Тогда
		Возврат МестнаяДатаПользователя;
	КонецЕсли;
	
	ПараметрыПреобразованияМестногоВремени = ПараметрыПреобразованияМестногоВремени();
	ПараметрыПреобразованияМестногоВремени.РежимОтображенияМестногоВремени =
		Перечисления.РежимыОтображенияМестногоВремени.МестноеВремяСЧасовымПоясом;
	ПараметрыПреобразованияМестногоВремени.МестныйЧасовойПояс =
		РаботаСЧасовымиПоясамиПовтИсп.ЧасовойПоясПользователя(Пользователь);
	ПараметрыПреобразованияМестногоВремени.ЧасовойПоясПоУмолчанию = ЧасовойПоясПоУмолчанию();
	
	Возврат ПривестиКВремениСеансаСПараметрами(
		МестнаяДатаПользователя,
		ПараметрыПреобразованияМестногоВремени);
	
КонецФункции

// Возвращает местный часовой пояс.
// 
// Возвращаемое значение:
//  Строка - Местный часовой пояс в формате GMT{+/-}hh:mm.
//
Функция МестныйЧасовойПояс() Экспорт
	
	Возврат РаботаСЧасовымиПоясамиПовтИсп.ЧасовойПоясПользователя(Пользователи.ТекущийПользователь());
	
КонецФункции

// Возвращает представление местного часового пояса.
// 
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//
// Возвращаемое значение:
//  Строка - Представление местного часового пояса.
//
Функция ПредставлениеМестногоЧасовогоПояса() Экспорт
	
	РежимОтображенияМестногоВремени = РаботаСЧасовымиПоясамиПовтИсп.РежимОтображенияМестногоВремени();
	Если РежимОтображенияМестногоВремени <> Перечисления.РежимыОтображенияМестногоВремени.МестноеВремяСЧасовымПоясом Тогда
		Возврат "";
	КонецЕсли;
	
	МестныйЧасовойПояс = МестныйЧасовойПояс();
	Если МестныйЧасовойПояс = ЧасовойПоясПоУмолчанию() Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат ПредставлениеЧасовогоПоясаДО(МестныйЧасовойПояс);
	
КонецФункции

// Возвращает часовой пояс пользователя.
// 
// Параметры:
//  ПользовательИлиСотрудник - СправочникСсылка.Пользователи, СправочникСсылка.Сотрудники.
//
// Возвращаемое значение:
//  Строка - Часовой пояс пользователя в формате GMT{+/-}hh:mm.
//
Функция ЧасовойПоясПользователя(ПользовательИлиСотрудник) Экспорт
	
	Пользователь = Сотрудники.ПользовательСотрудника(ПользовательИлиСотрудник);
	
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		Возврат ЧасовойПоясПоУмолчанию();
	КонецЕсли;
	
	Возврат ЧасовыеПоясаПользователей(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Пользователь))[Пользователь];
	
КонецФункции

// Возвращает часовые пояса пользователей.
//
// Параметры:
//  МассивПользователей - Массив из СправочникСсылка.Пользователи - Пользователи.
// 
// Возвращаемое значение:
//  Соответствие - Часовые пояса пользователей.
//   * Ключ     - СправочникСсылка.Пользователи - Пользователь.
//   * Значение - Строка                        - Часовой пояс пользователя в формате GMT{+/-}hh:mm.
//
Функция ЧасовыеПоясаПользователей(МассивПользователей) Экспорт
	
	ЧасовыеПоясаПользователей = РегистрыСведений.ЧасовыеПоясаПользователей.ЧасовыеПоясаПользователей(МассивПользователей);
	Для Каждого Пользователь Из МассивПользователей Цикл
		
		Если ЧасовыеПоясаПользователей[Пользователь] <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЧасовыеПоясаПользователей[Пользователь] = ЧасовойПоясПоУмолчанию();
		
	КонецЦикла;
	
	Возврат ЧасовыеПоясаПользователей;
	
КонецФункции

// Возвращает представление часового пояса пользователя.
// 
// Параметры:
//  ПользовательИлиСотрудник - СправочникСсылка.Пользователи, СправочникСсылка.Сотрудники.
//
// Возвращаемое значение:
//  Строка - Представление часового пояса пользователя.
//
Функция ПредставлениеЧасовогоПоясаПользователя(ПользовательИлиСотрудник) Экспорт
	
	Возврат ПредставлениеЧасовогоПоясаДО(ЧасовойПоясПользователя(ПользовательИлиСотрудник));
	
КонецФункции

// Актуализирует часовой пояс пользователя.
//
// Параметры:
//  АктуальныйЧасовойПояс - Строка                        - Актуальный часовой пояс пользователя в формате GMT{+/-}hh:mm.
//  Пользователь          - СправочникСсылка.Пользователи - Пользователь.
//
Процедура АктуализироватьЧасовойПояс(АктуальныйЧасовойПояс, Пользователь) Экспорт
	
	РегистрыСведений.ЧасовыеПоясаПользователей.УстановитьЧасовойПоясПользователя(
		Пользователь,
		АктуальныйЧасовойПояс);
	
КонецПроцедуры

// Возвращает действующий режим отображения местного времени.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.РежимыОтображенияМестногоВремени - Действующий режим отображения местного времени.
//
Функция РежимОтображенияМестногоВремени() Экспорт
	
	// Персональная настройка.
	РежимОтображенияМестногоВремени = РежимОтображенияМестногоВремениПерсональный();
	Если ЗначениеЗаполнено(РежимОтображенияМестногоВремени) Тогда
		Возврат РежимОтображенияМестногоВремени;
	КонецЕсли;
	
	// Общая настройка.
	РежимОтображенияМестногоВремени = РаботаСЧасовымиПоясамиПовтИсп.НастройкаРежимОтображенияМестногоВремени();
	Если ЗначениеЗаполнено(РежимОтображенияМестногоВремени) Тогда
		Возврат РежимОтображенияМестногоВремени;
	КонецЕсли;
	
	// Поведение по умолчанию.
	РежимОтображенияМестногоВремени = Перечисления.РежимыОтображенияМестногоВремени.МестноеВремяСЧасовымПоясом;
	
	Возврат РежимОтображенияМестногоВремени;
	
КонецФункции

// Возвращает персональный режим отображения местного времени.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.РежимыОтображенияМестногоВремени - Персональный режим отображения местного времени.
//
Функция РежимОтображенияМестногоВремениПерсональный() Экспорт
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		КлючОбъектаНастроек(),
		КлючНастройкиРежимОтображенияМестногоВремени(),
		Перечисления.РежимыОтображенияМестногоВремени.ПустаяСсылка());
	
КонецФункции

// Устанавливает персональный режим отображения местного времени.
//
// Параметры:
//  РежимОтображенияМестногоВремени - ПеречислениеСсылка.РежимыОтображенияМестногоВремени - Персональный режим отображения местного времени.
//
Процедура УстановитьРежимОтображенияМестногоВремениПерсональный(РежимОтображенияМестногоВремени) Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		КлючОбъектаНастроек(),
		КлючНастройкиРежимОтображенияМестногоВремени(),
		РежимОтображенияМестногоВремени);
	
КонецПроцедуры

// Возвращает представление часового пояса.
// 
// Параметры:
//  ЧасовойПояс - Строка - Часовой пояс в формате GMT{+/-}hh:mm.
//
// Возвращаемое значение:
//  Строка - Представление часового пояса.
//
Функция ПредставлениеЧасовогоПоясаДО(ЧасовойПояс) Экспорт
	
	ДанныеЧасовогоПояса = РаботаСЧасовымиПоясамиКлиентСервер.ДанныеЧасовогоПояса(ЧасовойПояс);
	
	Возврат ?(ДанныеЧасовогоПояса <> Неопределено, ДанныеЧасовогоПояса.Представление, Строка(ЧасовойПояс));
	
КонецФункции

// Возвращает часовой пояс по умолчанию.
//
// Возвращаемое значение:
//  Строка - Часовой пояс по умолчанию в формате GMT{+/-}hh:mm.
//
Функция ЧасовойПоясПоУмолчанию() Экспорт
	
	Возврат РаботаСЧасовымиПоясамиПовтИсп.ЧасовойПоясПоУмолчанию();
	
КонецФункции

// Возвращает часовой пояс, заданный смещением.
//
// Возвращаемое значение:
//  Строка, Неопределено - Часовой пояс,заданный смещением, в формате GMT{+/-}hh:mm. Если среди допустимых часовых поясов нет допустимого - возвращает Неопределено.
//
Функция ЧасовойПоясСмещением(СмещениеСтандартногоВремени) Экспорт
	
	ЧасовыеПоясаПоСмещению = Новый Соответствие;
	ИзвестныеЧасовыеПояса = РаботаСЧасовымиПоясамиПовтИсп.ИзвестныеЧасовыеПояса();
	Для Каждого КлючИЗначение Из ИзвестныеЧасовыеПояса Цикл
		
		ДанныеЧасовогоПояса = КлючИЗначение.Значение;
		
		ЧасовыеПоясаПоСмещению.Вставить(
			ДанныеЧасовогоПояса.НаправлениеСмещения + Строка(ДанныеЧасовогоПояса.СмещениеЧасов),
			ДанныеЧасовогоПояса);
		
	КонецЦикла;
	
	ДанныеСмещения = РаботаСЧасовымиПоясамиКлиентСервер.ДанныеСмещения(СмещениеСтандартногоВремени);
	Если ДанныеСмещения.СмещениеМинут > 30 Тогда
		ДанныеСмещения.СмещениеЧасов = ДанныеСмещения.СмещениеЧасов + 1;
		ДанныеСмещения.СмещениеМинут = 0;
	Иначе
		ДанныеСмещения.СмещениеМинут = 0;
	КонецЕсли;
	
	ДанныеЧасовогоПояса = ЧасовыеПоясаПоСмещению.Получить(
		ДанныеСмещения.НаправлениеСмещения + Строка(ДанныеСмещения.СмещениеЧасов));
	Если ДанныеЧасовогоПояса = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ДанныеЧасовогоПояса.ЧасовойПояс;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает ключ объекта настроек часовых поясов.
// 
// Возвращаемое значение:
//  Строка - Ключ объекта настроек.
//
Функция КлючОбъектаНастроек()
	
	Возврат "ЧасовыеПояса";
	
КонецФункции

// Возвращает ключ настройки "Режим отображения местного времени".
// 
// Возвращаемое значение:
//  Строка - Ключ настройки "Режим отображения местного времени".
//
Функция КлючНастройкиРежимОтображенияМестногоВремени()
	
	Возврат "РежимОтображенияМестногоВремени";
	
КонецФункции

#КонецОбласти