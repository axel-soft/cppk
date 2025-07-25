﻿////////////////////////////////////////////////////////////////////////////////
//	Общие серверные процедуры для синхронизации с сервисами DAV
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	НовыеРазрешения = Новый Массив;

	Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
		"HTTPS",
		"caldav.icloud.com",
		443,
		НСтр("ru = 'iCloud CalDAV API (https://caldav.icloud.com)'"));
	НовыеРазрешения.Добавить(Разрешение);

	ЗапросыРазрешений.Добавить(РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(НовыеРазрешения));
	
КонецПроцедуры

Процедура ПолучитьСписокКалендарейВФоне(ПараметрыПроцедуры, АдресХранилища) Экспорт

	Результат = КалендариНаСервереDAV(ПараметрыПроцедуры);
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

Процедура ВыгрузитьДанныеКалендаря(ОписаниеКалендаря) Экспорт
	
	ДанныеАвторизации = РегистрыСведений.НастройкиСинхронизацииDAV.ДанныеАвторизации(ОписаниеКалендаря.Узел);
	Если Не ЗначениеЗаполнено(ДанныеАвторизации) Тогда
		Возврат;
	КонецЕсли;
	
	// ЗаписьСообщения используется только для управления нумерацией сообщений и блокировки узла.
	ЗаписьСообщения = ПланыОбмена.СоздатьЗаписьСообщения();
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	ЗаписьСообщения.НачатьЗапись(ЗаписьXML, ОписаниеКалендаря.Узел);
	
	СтруктураURI = СтруктураURIСервераCalDAV(ДанныеАвторизации.КаталогКалендарей + ОписаниеКалендаря.Идентификатор);
	СтруктураURI.Логин = ДанныеАвторизации.ИмяПользователя;
	СтруктураURI.Пароль = ДанныеАвторизации.Пароль;
	УстановитьПривилегированныйРежим(Истина);
	Соединение = HTTPСоединениеСервераCalDAV(СтруктураURI);
	ВыгруженныеСсылки = Новый Массив;
	Для Каждого Событие Из ОписаниеКалендаря.События Цикл
		КодСостояния = 0;
		Допустимо404 = Ложь;
		Если Не ЗначениеЗаполнено(Событие.Идентификатор) Тогда
			Событие.Идентификатор = Событие.Ссылка.УникальныйИдентификатор();
		КонецЕсли;
		Если ЗначениеЗаполнено(Событие.ОтпечатокОбъекта) Тогда
			Если Событие.ПометкаУдаления
				Или Событие.Состояние = Перечисления.СостоянияЗаписейРабочегоКалендаря.Отклонено Тогда
				Ответ = ВызватьМетод("DELETE", Соединение, ПутьИзИдентификаторов(СтруктураURI.ПутьНаСервере, Событие.Идентификатор));
				Допустимо404 = Истина; // Код 404 допустим - данных уже нет в iCloud.
			Иначе
				Массив = Новый Массив;
				Массив.Добавить(Событие);
				Ответ = ВызватьМетод("PUT", Соединение, ПутьИзИдентификаторов(СтруктураURI.ПутьНаСервере, Событие.Идентификатор),
						СинхронизацияКалендарей.СобытияiCalendar(Массив,,ОписаниеКалендаря.ВремяУведомленийЭкспорт),, Событие.ОтпечатокОбъекта);
				
				// Отпечаток объекта обновляем, только если уже есть данные, и отпечаток изменился.
				НовыйОтпечатокОбъекта = Ответ.Заголовки["Etag"];
				Если ЗначениеЗаполнено(НовыйОтпечатокОбъекта) Тогда
					МенеджерЗаписи = РегистрыСведений.ЗаписиСинхронизацииКалендарей.СоздатьМенеджерЗаписи();
					МенеджерЗаписи.ЗаписьРабочегоКалендаря = Событие.Ссылка;
					МенеджерЗаписи.Узел = ОписаниеКалендаря.Узел;
					МенеджерЗаписи.Прочитать();
					Если МенеджерЗаписи.Выбран() И МенеджерЗаписи.ОтпечатокОбъекта <> НовыйОтпечатокОбъекта Тогда
						МенеджерЗаписи.ОтпечатокОбъекта = НовыйОтпечатокОбъекта;
						МенеджерЗаписи.Записать();
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			КодСостояния = Ответ.КодСостояния;
		ИначеЕсли Не Событие.ПометкаУдаления
			И Не Событие.Состояние = Перечисления.СостоянияЗаписейРабочегоКалендаря.Отклонено Тогда
			Массив = Новый Массив;
			Массив.Добавить(Событие);
			Ответ = ВызватьМетод("PUT", Соединение, ПутьИзИдентификаторов(СтруктураURI.ПутьНаСервере, Событие.Идентификатор),
					СинхронизацияКалендарей.СобытияiCalendar(Массив,,ОписаниеКалендаря.ВремяУведомленийЭкспорт));
			КодСостояния = Ответ.КодСостояния;
			МенеджерЗаписи = РегистрыСведений.ЗаписиСинхронизацииКалендарей.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ЗаписьРабочегоКалендаря	= Событие.Ссылка;
			МенеджерЗаписи.Узел						= ОписаниеКалендаря.Узел;
			МенеджерЗаписи.ИдентификаторКалендаря	= ОписаниеКалендаря.Идентификатор;
			МенеджерЗаписи.Идентификатор			= Событие.Идентификатор;
			МенеджерЗаписи.ОтпечатокОбъекта			= ?(ЗначениеЗаполнено(Ответ.Заголовки["Etag"]), Ответ.Заголовки["Etag"], "");
			МенеджерЗаписи.БезОписания				= ОписаниеКалендаря.БезОписания;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		Если КодСостояния >= 300
			И (КодСостояния <> 404 Или Не Допустимо404)
			И КодСостояния <> 412 Тогда // 412 Precondition Failed - запись изменили в iCloud.
			КраткийТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось выгрузить событие %1 от %2'"),
				Событие.Описание,
				Событие.ДатаНачала);
			ПодробныйТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сервер вернул состояние: %1
							|Тело ответа: %2'"), КодСостояния, Ответ.ПолучитьТелоКакСтроку());
			ЗарегистрироватьОшибку(КраткийТекстОшибки, ПодробныйТекстОшибки);
			ВызватьИсключение КраткийТекстОшибки;
		КонецЕсли;
		ВыгруженныеСсылки.Добавить(Событие.Ссылка);
	КонецЦикла;
	
	ПланыОбмена.ВыбратьИзменения(ОписаниеКалендаря.Узел, ЗаписьСообщения.НомерСообщения, ВыгруженныеСсылки);
	НомерСообщения = ЗаписьСообщения.НомерСообщения;
	ЗаписьСообщения.ЗакончитьЗапись();
	ПланыОбмена.УдалитьРегистрациюИзменений(ОписаниеКалендаря.Узел, НомерСообщения);
	
КонецПроцедуры

Процедура ЗагрузитьДанныеКалендаря(ОписаниеКалендаря, ДатаНачала, ДатаОкончания) Экспорт

	ДанныеАвторизации = РегистрыСведений.НастройкиСинхронизацииDAV.ДанныеАвторизации(ОписаниеКалендаря.Узел);
	Если Не ЗначениеЗаполнено(ДанныеАвторизации) Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьСобытияКалендаря(ДанныеАвторизации, ОписаниеКалендаря, ДатаНачала, ДатаОкончания);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КалендариНаСервереDAV(ПараметрыПроцедуры)

	СтруктураURI = СтруктураURIСервераCalDAV(ПараметрыПроцедуры.Сервер);
	СтруктураURI.Логин = ПараметрыПроцедуры.Логин;
	СтруктураURI.Пароль = ПараметрыПроцедуры.Пароль;
	Соединение = HTTPСоединениеСервераCalDAV(СтруктураURI);
	КорневойКаталогПользователяНаСервереDAV(Соединение, СтруктураURI);
	КаталогКалендарей = КаталогКалендарейНаСервереDAV(Соединение, СтруктураURI, ПараметрыПроцедуры);
	Соединение = HTTPСоединениеСервераCalDAV(СтруктураURI);
	СписокКалендарей = СписокКалендарейНаСервереDAV(Соединение, СтруктураURI);
	Результат = Новый Структура;
	Результат.Вставить("КаталогКалендарей",	КаталогКалендарей);
	Результат.Вставить("СписокКалендарей",	СписокКалендарей);
	Возврат Результат;

КонецФункции

Процедура КорневойКаталогПользователяНаСервереDAV(Соединение, СтруктураURI)

	ТелоКакСтрока =
	"<propfind xmlns=""DAV:"">
	|	<prop>
	|		<current-user-principal/>
	|	</prop>
	|</propfind>";
	Ответ = ВызватьМетод("PROPFIND", Соединение, СтруктураURI.ПутьНаСервере, ТелоКакСтрока, 0);
		СтрокаXML = Ответ.ПолучитьТелоКакСтроку();
	Если Не Ответ.КодСостояния = 207 Тогда
		КраткийТекстОшибки = НСтр("ru = 'Получение каталога пользователя завершилось ошибкой.'");
		Если Ответ.КодСостояния = 401 ИЛИ Ответ.КодСостояния = 403 Тогда
			КраткийТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 Неправильная комбинация логина и пароля.'"), КраткийТекстОшибки);
		КонецЕсли;
		ПодробныйТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сервер вернул состояние: %1
						|Тело ответа: %2'"), Ответ.КодСостояния, СтрокаXML);
		ЗарегистрироватьОшибку(КраткийТекстОшибки, ПодробныйТекстОшибки);
		ВызватьИсключение КраткийТекстОшибки;
	КонецЕсли;
	Попытка
		ОтветXDTO = СтрокаXMLвXDTO(СтрокаXML);
		СтруктураURI.ПутьНаСервере = ОтветXDTO.response.propstat.prop.current_user_principal.href;
	Исключение
		ЗарегистрироватьОшибку(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

Функция КаталогКалендарейНаСервереDAV(Соединение, СтруктураURI, ПараметрыПроцедуры)

	ТелоКакСтрока =
	"<propfind xmlns=""DAV:""
	|			xmlns:C=""urn:ietf:params:xml:ns:caldav"">
	|	<prop>
	|		<C:calendar-home-set/>
	|	</prop>
	|</propfind>";
	Ответ = ВызватьМетод("PROPFIND", Соединение, СтруктураURI.ПутьНаСервере, ТелоКакСтрока, 0);
		СтрокаXML = Ответ.ПолучитьТелоКакСтроку();
	Если Не Ответ.КодСостояния = 207 Тогда
		КраткийТекстОшибки = НСтр("ru = 'Получение каталога календарей ошибкой.'");
		ПодробныйТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сервер вернул состояние: %1
						|Тело ответа: %2'"), Ответ.КодСостояния, СтрокаXML);
		ЗарегистрироватьОшибку(КраткийТекстОшибки, ПодробныйТекстОшибки);
		ВызватьИсключение КраткийТекстОшибки;
	КонецЕсли;
	Попытка
		ОтветXDTO = СтрокаXMLвXDTO(СтрокаXML);
		КаталогКалендарей = ОтветXDTO.response.propstat.prop.calendar_home_set.href;
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(КаталогКалендарей);
		СтруктураURI.Логин = ПараметрыПроцедуры.Логин;
		СтруктураURI.Пароль = ПараметрыПроцедуры.Пароль;
		Если Не ЗначениеЗаполнено(СтруктураURI.ИмяСервера) Тогда
			СтруктураURI = СтруктураURIСервераCalDAV(ПараметрыПроцедуры.Сервер);
			СтруктураURI.ПутьНаСервере = КаталогКалендарей;
		КонецЕсли;
	Исключение
		ЗарегистрироватьОшибку(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;

	Возврат КаталогКалендарей;

КонецФункции

Функция СписокКалендарейНаСервереDAV(Соединение, СтруктураURI)

	ТелоКакСтрока =
	"<propfind xmlns=""DAV:"">
	|	<prop>
	|		<displayname/>
	|		<resourcetype/>
	|	</prop>
	|</propfind>";
	Ответ = ВызватьМетод("PROPFIND", Соединение, СтруктураURI.ПутьНаСервере, ТелоКакСтрока, 1);
	СтрокаXML = Ответ.ПолучитьТелоКакСтроку();
	Если Не Ответ.КодСостояния = 207 Тогда
		КраткийТекстОшибки = НСтр("ru = 'Получение списка календарей завершилось ошибкой.'");
		ПодробныйТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сервер вернул состояние: %1
						|Тело ответа: %2'"), Ответ.КодСостояния, СтрокаXML);
		ЗарегистрироватьОшибку(КраткийТекстОшибки, ПодробныйТекстОшибки);
		ВызватьИсключение КраткийТекстОшибки;
	КонецЕсли;
	Попытка
		ОтветXDTO = СтрокаXMLвXDTO(СтрокаXML);
		СписокКалендарей = Новый Массив;
		Для каждого Элемент Из ОтветXDTO.response Цикл
			Если ТипЗнч(Элемент.propstat) = Тип("ОбъектXDTO") Тогда
				Если СтрНайти(Элемент.propstat.status, "200") > 0 Тогда
					Если Не Элемент.propstat.prop.resourcetype.Свойства().Получить("calendar") = Неопределено Тогда
						Календарь = Новый Структура;
						Календарь.Вставить("Наименование", Элемент.propstat.prop.displayname);
						Календарь.Вставить("Идентификатор", ВыделитьИдентификатор(Элемент.href));
						СписокКалендарей.Добавить(Календарь);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	Исключение
		ЗарегистрироватьОшибку(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	Возврат СписокКалендарей;

КонецФункции

Функция ВызватьМетод(Метод, Соединение, ПутьНаСервере, ТелоКакСтрока = "", Глубина = 0, ETag = "")

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("User-Agent", ОбщегоНазначенияДокументооборот.ИмяКлиентскогоПриложения());
	Если Метод = "PUT" Тогда
		Если ЗначениеЗаполнено(ETag) Тогда
			Заголовки.Вставить("If-Match", ETag);
		Иначе
			Заголовки.Вставить("If-None-Match", "*");
		КонецЕсли;
		Заголовки.Вставить("Content-Type", "text/calendar; charset=""utf-8""");
	ИначеЕсли Метод = "REPORT" ИЛИ Метод = "PROPFIND" Тогда
		Заголовки.Вставить("Depth", Глубина);
		Заголовки.Вставить("Content-Type", "application/xml; charset=""utf-8""");
	КонецЕсли;
	Запрос = Новый HTTPЗапрос(ПутьНаСервере, Заголовки);
	Если ЗначениеЗаполнено(ТелоКакСтрока) Тогда
		Запрос.УстановитьТелоИзСтроки(ТелоКакСтрока, "utf-8");
	КонецЕсли;
	Попытка
		Ответ = Соединение.ВызватьHTTPМетод(Метод, Запрос);
	Исключение
		ЗарегистрироватьОшибку(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	Возврат Ответ;

КонецФункции

Функция СтрокаXMLвXDTO(СтрокаXML)

	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	Возврат ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);

КонецФункции

Функция СтруктураURIСервераCalDAV(Сервер)

	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(Сервер);
	Если Не ЗначениеЗаполнено(СтруктураURI.Схема) Тогда
		СтруктураURI.Схема = "https";
		Если Не ЗначениеЗаполнено(СтруктураURI.Порт) Тогда
			СтруктураURI.Порт = 443;
			СтруктураURI.ИмяСервера = СтруктураURI.ИмяСервера + ":443";
		КонецЕсли;
	КонецЕсли;
	Возврат СтруктураURI;

КонецФункции

Процедура ЗаполнитьСобытияКалендаря(ДанныеАвторизации, ОписаниеКалендаря, ДатаНачала, ДатаОкончания)

	СтруктураURI = СтруктураURIСервераCalDAV(ДанныеАвторизации.КаталогКалендарей + ОписаниеКалендаря.Идентификатор);
	СтруктураURI.Логин = ДанныеАвторизации.ИмяПользователя;
	СтруктураURI.Пароль = ДанныеАвторизации.Пароль;
	УстановитьПривилегированныйРежим(Истина);
	Соединение = HTTPСоединениеСервераCalDAV(СтруктураURI);
	ДействительныйТокенСинхронизации = ДействительныйТокенСинхронизации(Соединение, СтруктураURI, ОписаниеКалендаря.ТокенСинхронизации);
	Если Не ЗначениеЗаполнено(ОписаниеКалендаря.ТокенСинхронизации) Тогда
		ЗаполнитьВсемиСобытиями(ОписаниеКалендаря, Соединение, СтруктураURI, ДатаНачала, ДатаОкончания);
	ИначеЕсли Не ОписаниеКалендаря.ТокенСинхронизации = ДействительныйТокенСинхронизации Тогда
		ЗаполнитьИзмененными(ОписаниеКалендаря, Соединение, СтруктураURI, ДатаНачала, ДатаОкончания);
	КонецЕсли;
	ОписаниеКалендаря.ТокенСинхронизации = ДействительныйТокенСинхронизации(Соединение, СтруктураURI,  ОписаниеКалендаря.ТокенСинхронизации);

КонецПроцедуры

Функция HTTPСоединениеСервераCalDAV(СтруктураURI)

	ИнтернетПрокси = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		МодульПолучениеФайловИзИнтернетаКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернетаКлиентСервер");
		ИнтернетПрокси = МодульПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси(СтруктураURI.Схема);
	КонецЕсли;
	Таймаут = 20;
	ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	Возврат Новый HTTPСоединение(
		СтруктураURI.Хост,
		СтруктураURI.Порт,
		СтруктураURI.Логин,
		СтруктураURI.Пароль,
		ИнтернетПрокси, Таймаут,
		ЗащищенноеСоединение);

КонецФункции

Функция ДействительныйТокенСинхронизации(Соединение, СтруктураURI, Знач ТокенСинхронизации)

	ТелоКакСтрока =
	"<D:propfind xmlns:D=""DAV:"" xmlns:C=""http://calendarserver.org/ns/"">
	|	<D:prop>
	|		<C:getctag/>
	|	</D:prop>
	|</D:propfind>";
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Depth", 0);
	Заголовки.Вставить("Content-Type", "application/xml; charset=""utf-8""");
	Запрос = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере, Заголовки);
	Запрос.УстановитьТелоИзСтроки(ТелоКакСтрока, "utf-8");
	Попытка
		Ответ = Соединение.ВызватьHTTPМетод("PROPFIND", Запрос);
	Исключение
		ЗарегистрироватьОшибку(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	Если Ответ.КодСостояния = 207 Тогда
		ТаблицаОтвета = Новый ТаблицаЗначений;
		ТаблицаОтвета.Колонки.Добавить("getctag", Новый ОписаниеТипов("Строка"));
		ОбработатьMultiStatusОтвет(Ответ, ТаблицаОтвета);
		Если ЗначениеЗаполнено(ТаблицаОтвета) Тогда
			ТокенСинхронизации = ТаблицаОтвета[0].getctag;
		КонецЕсли;
	КонецЕсли;
	Возврат ТокенСинхронизации;

КонецФункции

Функция ОбработатьMultiStatusОтвет(
			Ответ, ТаблицаОтвета, СоответствиеИменСвойств = Неопределено, ПолучатьДанныеКалендаря = Ложь)

	Попытка
		Если Не ЗначениеЗаполнено(СоответствиеИменСвойств) Тогда
			СоответствиеИменСвойств = Новый Соответствие;
		КонецЕсли;
		СтрокаXML  = Ответ.ПолучитьТелоКакСтроку();
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(СтрокаXML);
		ОтветXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		ЧтениеXML.Закрыть();
		Если ОтветXDTO.Свойства().Получить("response") = Неопределено Тогда
			Возврат ТаблицаОтвета;
		КонецЕсли;
		Если ТаблицаОтвета.Колонки.Найти("href") = Неопределено Тогда
			ТаблицаОтвета.Колонки.Добавить("href", Новый ОписаниеТипов("Строка"));
		КонецЕсли;
		Если Не ТипЗнч(ОтветXDTO.response) = Тип("СписокXDTO") Тогда
			СписокResponse = Новый Массив;
			СписокResponse.Добавить(ОтветXDTO.response);
		Иначе
			СписокResponse = ОтветXDTO.response;
		КонецЕсли;
		Для Каждого response Из СписокResponse Цикл
			НоваяСтрока = ТаблицаОтвета.Добавить();
			НоваяСтрока.href = response.href;
			Если ПолучатьДанныеКалендаря И Не response.Свойства().Получить("status") = Неопределено Тогда
				Если СтрНайти(response.status, "404") > 0 Тогда
					НоваяСтрока.Идентификатор = ВыделитьИдентификатор(НоваяСтрока.href);
					НоваяСтрока.ПометкаУдаления = Истина;
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			Если Не ТипЗнч(response.propstat) = Тип("СписокXDTO") Тогда
				СписокPropstat = Новый Массив;
				СписокPropstat.Добавить(response.propstat);
			ИначеЕсли ТипЗнч(response.propstat) = Тип("СписокXDTO") Тогда
				СписокPropstat = response.propstat;
			КонецЕсли;
			Для Каждого propstat Из СписокPropstat Цикл
				Если СтрНайти(propstat.status, "200") > 0 Тогда
					Свойства = propstat.prop.Свойства();
					Для Каждого Свойство Из Свойства Цикл
						Если ПолучатьДанныеКалендаря И Свойство.Имя = "calendar_data" Тогда
							Структура = СинхронизацияКалендарей.СтруктураiCalendar(propstat.prop[Свойство.Имя]);
							ЗаполнитьЗначенияСвойств(НоваяСтрока, Структура);
						ИначеЕсли Не СоответствиеИменСвойств.Получить(Свойство.Имя) = Неопределено Тогда
							НоваяСтрока[СоответствиеИменСвойств.Получить(Свойство.Имя)] = propstat.prop[Свойство.Имя];
						ИначеЕсли Не ТаблицаОтвета.Колонки.Найти(Свойство.Имя) = Неопределено Тогда
							НоваяСтрока[Свойство.Имя] = propstat.prop[Свойство.Имя];
						КонецЕсли;
					КонецЦикла;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	Исключение
		ЗарегистрироватьОшибку(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;

КонецФункции

Процедура ЗаполнитьИзмененными(ОписаниеКалендаря, Соединение, СтруктураURI, ДатаНачала , ДатаОкончания)

	События = ОписаниеКалендаря.События;
	ТелоКакСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	"<C:calendar-query xmlns:D=""DAV:""
	|				xmlns:C=""urn:ietf:params:xml:ns:caldav"">
	|	<D:prop>
	|		<D:getetag/>
	|	</D:prop>
	|	<C:filter>
	|		<C:comp-filter name=""VCALENDAR"">
	|			<C:comp-filter name=""VEVENT"">
	|				<C:time-range start=""%1""
	|								end=""%2""/>
	|			</C:comp-filter>
	|		</C:comp-filter>
	|	</C:filter>
	|</C:calendar-query>",
	РаботаСICalendar.ДатаФорматаICalendar(ДатаНачала),
	РаботаСICalendar.ДатаФорматаICalendar(ДатаОкончания));
	Ответ = ВызватьМетод("REPORT", Соединение, СтруктураURI.ПутьНаСервере, ТелоКакСтрока, 1);
	Если Не Ответ.КодСостояния = 207 Тогда
		Возврат;
	КонецЕсли;
	ТаблицаОтвета = Новый ТаблицаЗначений;
	ТаблицаОтвета.Колонки.Добавить("getetag", Новый ОписаниеТипов("Строка"));
	ОбработатьMultiStatusОтвет(Ответ, ТаблицаОтвета);
	ТелоКакСтрока = ТелоЗапросаИзменений(СтруктураURI.ПутьНаСервере, ОписаниеКалендаря, ТаблицаОтвета);
	Если Не ЗначениеЗаполнено(ТелоКакСтрока) Тогда
		Возврат;
	КонецЕсли;
	Ответ = ВызватьМетод("REPORT", Соединение, СтруктураURI.ПутьНаСервере, ТелоКакСтрока, 1);
	Если Не Ответ.КодСостояния = 207 Тогда
		Возврат;
	КонецЕсли;
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("getetag", "ОтпечатокОбъекта");
	ОбработатьMultiStatusОтвет(Ответ, События, Соответствие, Истина);

КонецПроцедуры

Процедура ЗаполнитьВсемиСобытиями(ОписаниеКалендаря, Соединение, СтруктураURI, ДатаНачала, ДатаОкончания)

	События = ОписаниеКалендаря.События;
	ТелоКакСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	"<C:calendar-query xmlns:D=""DAV:""
	|				xmlns:C=""urn:ietf:params:xml:ns:caldav"">
	|	<D:prop>
	|		<D:getetag/>
	|		<C:calendar-data>
	|			<C:comp name=""VCALENDAR"">
	|				<C:comp name=""VEVENT"">
	|					<C:prop name=""SUMMARY""/>
	|					<C:prop name=""UID""/>
	|					<C:prop name=""DTSTART""/>
	|					<C:prop name=""DTEND""/>
	|					<C:prop name=""RRULE""/>
	|					<C:prop name=""EXDATE""/>
	|				</C:comp>
	|			</C:comp>
	|		</C:calendar-data>
	|	</D:prop>
	|	<C:filter>
	|		<C:comp-filter name=""VCALENDAR"">
	|			<C:comp-filter name=""VEVENT"">
	|				<C:time-range start=""%1""
	|								end=""%2""/>
	|			</C:comp-filter>
	|		</C:comp-filter>
	|	</C:filter>
	|</C:calendar-query>",
	РаботаСICalendar.ДатаФорматаICalendar(ДатаНачала),
	РаботаСICalendar.ДатаФорматаICalendar(ДатаОкончания));
	Ответ = ВызватьМетод("REPORT", Соединение, СтруктураURI.ПутьНаСервере, ТелоКакСтрока, 1);
	Если Не Ответ.КодСостояния = 207 Тогда
		Возврат;
	КонецЕсли;
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("getetag", "ОтпечатокОбъекта");
	ОбработатьMultiStatusОтвет(Ответ, События, Соответствие, Истина);

КонецПроцедуры

Функция ВыделитьИдентификатор(Знач Путь)

	Путь = ?(Прав(Путь, 1) = "/", Лев(Путь, СтрДлина(Путь) - 1), Путь);
	Позиция = СтрНайти(Путь, "/");
	Пока Позиция > 0 Цикл
		Путь = Прав(Путь, СтрДлина(Путь) - Позиция);
		Позиция = СтрНайти(Путь, "/");
	КонецЦикла;
	Возврат СокрЛП(СтрЗаменить(Путь, ".ics", ""));

КонецФункции

Функция ПутьИзИдентификаторов(Знач ПутьНаСервере, Знач Идентификатор)

	ПутьНаСервере = ?(Прав(ПутьНаСервере, 1) = "/", Лев(ПутьНаСервере, СтрДлина(ПутьНаСервере) - 1), ПутьНаСервере);
	ПутьНаСервере = ?(Лев(ПутьНаСервере, 1) = "/", Прав(ПутьНаСервере, СтрДлина(ПутьНаСервере) - 1), ПутьНаСервере);
	Возврат "/" + ПутьНаСервере + "/" + Идентификатор + ".ics";

КонецФункции

Функция ТелоЗапросаИзменений(ПутьНаСервере, ОписаниеКалендаря, ТаблицаEtag)

	МаксДлинаИдентификатор = 1;
	МаксДлинаEtag = 1;
	ТаблицаEtag.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Для Каждого СтрокаEtag Из ТаблицаEtag Цикл
		СтрокаEtag.Идентификатор = ВыделитьИдентификатор(СтрокаEtag.href);
		МаксДлинаИдентификатор = ?(СтрДлина(СтрокаEtag.Идентификатор) > МаксДлинаИдентификатор,
			СтрДлина(СтрокаEtag.Идентификатор), МаксДлинаИдентификатор);
		МаксДлинаEtag = ?(СтрДлина(СтрокаEtag.getetag) > МаксДлинаEtag, СтрДлина(СтрокаEtag.getetag), МаксДлинаEtag);
	КонецЦикла;
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаEtag.Идентификатор КАК Идентификатор,
	|	ТаблицаEtag.getetag КАК getetag
	|ПОМЕСТИТЬ ТаблицаEtag
	|ИЗ
	|	&ТаблицаEtag КАК ТаблицаEtag
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаEtag.Идентификатор, ЗаписиСинхронизацииКалендарей.Идентификатор) КАК Идентификатор
	|ИЗ
	|	ТаблицаEtag КАК ТаблицаEtag
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗаписиСинхронизацииКалендарей КАК ЗаписиСинхронизацииКалендарей
	|		ПО (ПОДСТРОКА(ЕСТЬNULL(ТаблицаEtag.Идентификатор, """"), 0, &МаксДлинаИдентификатор) = ПОДСТРОКА(ЕСТЬNULL(ЗаписиСинхронизацииКалендарей.Идентификатор, """"), 0, &МаксДлинаИдентификатор))
	|ГДЕ
	|	ВЫБОР
	|			КОГДА ЗаписиСинхронизацииКалендарей.ОтпечатокОбъекта ЕСТЬ NULL
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ НЕ ПОДСТРОКА(ЕСТЬNULL(ТаблицаEtag.getetag, """"), 0, &МаксДлинаEtag) = ПОДСТРОКА(ЕСТЬNULL(ЗаписиСинхронизацииКалендарей.ОтпечатокОбъекта, """"), 0, &МаксДлинаEtag)
	|					И ПОДСТРОКА(ЗаписиСинхронизацииКалендарей.ИдентификаторКалендаря, 0, &ДлинаИдентификатораКалендаря) = &ИдентификаторКалендаря
	|					И ЗаписиСинхронизацииКалендарей.Узел = &Узел
	|		КОНЕЦ");
	Запрос.УстановитьПараметр("Узел", ОписаниеКалендаря.Узел);
	Запрос.УстановитьПараметр("ТаблицаEtag", ТаблицаEtag);
	Запрос.УстановитьПараметр("ИдентификаторКалендаря", ОписаниеКалендаря.Идентификатор);
	Запрос.УстановитьПараметр("ДлинаИдентификатораКалендаря", СтрДлина(ОписаниеКалендаря.Идентификатор));
	Запрос.УстановитьПараметр("МаксДлинаИдентификатор", МаксДлинаИдентификатор);
	Запрос.УстановитьПараметр("МаксДлинаEtag", МаксДлинаEtag);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат "";
	КонецЕсли;
	СтрокаСсылок = "";
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Путь = ПутьИзИдентификаторов(ПутьНаСервере, Выборка.Идентификатор);
		СтрокаСсылок = СтрокаСсылок + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"	<D:href>%1</D:href>", Путь);
	КонецЦикла;
	ТелоКакСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	"<C:calendar-multiget xmlns:D=""DAV:""
	|					xmlns:C=""urn:ietf:params:xml:ns:caldav"">
	|	<D:prop>
	|		<D:getetag/>
	|		<C:calendar-data/>
	|	</D:prop>%1
	|</C:calendar-multiget>", СтрокаСсылок);
	Возврат ТелоКакСтрока;

КонецФункции

Процедура ЗарегистрироватьОшибку(КраткийТекстОшибки, ПодробныйТекстОшибки, ПоказыватьСообщения = Ложь)

	ИмяСобытия = НСтр("ru = 'Синхронизация календарей.DAV'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ПодробныйТекстОшибки);
	Если Не ПоказыватьСообщения Тогда
		Возврат;
	КонецЕсли;
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'При синхронизации возникла ошибка. Обратитесь к администратору.
					|Текст ошибки:
					|%1'"),
		КраткийТекстОшибки);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);

КонецПроцедуры

#КонецОбласти