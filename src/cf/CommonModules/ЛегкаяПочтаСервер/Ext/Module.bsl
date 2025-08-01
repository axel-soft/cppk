﻿////////////////////////////////////////////////////////////////////////////////
// Легкая почта (сервер)
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает почтовые сообщения с помощью объекта ИнтернетПочта.
// Результат (Массив)
// - Элемент (Структура) - Сообщение
//
// Параметры:
// - ПараметрыЗагрузки (Структура)
//   - 
//
Функция ПолучитьИнтернетПочта(ПараметрыЗагрузки) Экспорт
	
	УчетнаяЗапись = ПараметрыЗагрузки.НастройкиПрофилейДляЗагрузки.Профиль.Профиль;
	Пароль = ПараметрыЗагрузки.НастройкиПрофилейДляЗагрузки.Профиль.Пароль;
	
	ДанныеУчетнойЗаписи = Почта.ПолучитьДанныеУчетнойЗаписи(УчетнаяЗапись);
	Если Не ДанныеУчетнойЗаписи.ИспользоватьДляПолучения Тогда
		ВызватьИсключение НСтр("ru = 'Учетная запись не предназначена для получения сообщений.'");
	КонецЕсли;
	
	СообщениеОбОшибке = "";
	Соединение = Почта.ИнтернетПочтаУстановитьСоединение(УчетнаяЗапись, Пароль, СообщениеОбОшибке);
	Если Соединение = Неопределено Тогда
		ВызватьИсключение СообщениеОбОшибке;
	КонецЕсли;
	
	ИнтернетПочтаПараметрыЗагрузки = Почта.СформироватьСтруктуруПараметровЗагрузки();
	ПолучитьЗаголовки = Ложь;
	Если ПараметрыЗагрузки.Свойство("ТолькоЗаголовки") Тогда
		ПолучитьЗаголовки = ПараметрыЗагрузки.ТолькоЗаголовки;
		ИнтернетПочтаПараметрыЗагрузки.ПолучитьЗаголовки = ПолучитьЗаголовки;
	КонецЕсли;
	Если ПараметрыЗагрузки.Свойство("ПолучитьИдентификаторы") Тогда
		ИнтернетПочтаПараметрыЗагрузки.ПолучитьИдентификаторы = ПараметрыЗагрузки.ПолучитьИдентификаторы;
	КонецЕсли;
	Если ПараметрыЗагрузки.Свойство("Идентификаторы") Тогда
		ИнтернетПочтаПараметрыЗагрузки.Идентификаторы = ПараметрыЗагрузки.Идентификаторы;
	КонецЕсли;
	
	УникальныйИдентификатор = ПараметрыЗагрузки.УникальныйИдентификатор;
	
	ИнтернетПочтаПараметрыЗагрузки.ПараметрыОтбора.Вставить("ПослеДатыОтправления", ТекущаяДата() - 7 * 86400);
	ИнтернетПочтаПараметрыЗагрузки.ПараметрыОтбора.Вставить("Удаленные", Ложь);
	
	Попытка
		ИнтернетПочтаПараметрыЗагрузки.Идентификаторы = 
			Соединение.ПолучитьИдентификаторы(ИнтернетПочтаПараметрыЗагрузки.Идентификаторы, 
				ИнтернетПочтаПараметрыЗагрузки.ПараметрыОтбора);
	Исключение
				
		ИнтернетПочтаПараметрыЗагрузки.ПараметрыОтбора.Удалить("ПослеДатыОтправления");
		
		ИнтернетПочтаПараметрыЗагрузки.Идентификаторы = 
			Соединение.ПолучитьИдентификаторы(ИнтернетПочтаПараметрыЗагрузки.Идентификаторы, 
				ИнтернетПочтаПараметрыЗагрузки.ПараметрыОтбора);
		
	КонецПопытки;	
	
	МаксимальноеЧислоПринимаемыхПисем = МаксимальноеЧислоПринимаемыхПисем();

	Если ИнтернетПочтаПараметрыЗагрузки.Идентификаторы.Количество() > МаксимальноеЧислоПринимаемыхПисем Тогда
		
		ИдентификаторыКЗагрузке = Новый Массив;
		ДобавленоИд = 0;
		
		Для Каждого UIDL Из ИнтернетПочтаПараметрыЗагрузки.Идентификаторы Цикл
			
			ИдентификаторыКЗагрузке.Добавить(UIDL);
			ДобавленоИд = ДобавленоИд + 1;
			
			Если ДобавленоИд >= МаксимальноеЧислоПринимаемыхПисем Тогда
				
				Прервать;
				
			КонецЕсли;	
			
		КонецЦикла;	
		
		ИнтернетПочтаПараметрыЗагрузки.Идентификаторы = ИдентификаторыКЗагрузке;
		
	КонецЕсли;	

	Результат = Новый Массив;     
	
	// Нечего загружать, выходим. 
	// Если этого не сделать, то Почта.ПолучитьВходящиеСообщения с пустым массивом Идентификаторы - вернет все, без отбора
	Если ИнтернетПочтаПараметрыЗагрузки.Идентификаторы.Количество() = 0 Тогда  
		Возврат Результат;
	КонецЕсли;	
	
	СообщениеОбОшибке = "";
	Сообщения = Почта.ПолучитьВходящиеСообщения(Соединение, ИнтернетПочтаПараметрыЗагрузки, 
		СообщениеОбОшибке, ДанныеУчетнойЗаписи.ПротоколВходящейПочты);
	Если Сообщения = Неопределено Тогда
		ВызватьИсключение СообщениеОбОшибке;
	КонецЕсли;
	
	Для каждого Сообщение Из Сообщения Цикл
		СтруктураСообщения = ЛегкаяПочтаКлиентСервер.СформироватьСтруктуруСообщения();
		СтруктураСообщения.УникальныйИдентификатор = УникальныйИдентификатор;
		СтруктураСообщения.Тема = Сообщение.Тема;
		
		ТекстИнфо = Почта.ПолучитьСтруктуруТекстаИзСтруктурыПочтовогоСообщения(Сообщение);
		СтруктураСообщения.ТипТекста = ТекстИнфо.ТипТекста;
		СтруктураСообщения.Текст = ТекстИнфо.Текст;
		СтруктураСообщения.ТекстHTML = ТекстИнфо.ТекстHTML;
		
		СтруктураСообщения.ДатаОтправки = Сообщение.ДатаОтправки;
		СтруктураСообщения.ДатаПолучения = Сообщение.ДатаПолучения;
		СтруктураСообщения.Отправитель = ПолучитьПредставлениеИнтернетПочтовогоАдреса(Сообщение.Отправитель);
		СтруктураСообщения.Кому = ИнтернетПочтовыеАдресаВСтроку(Сообщение.Получатели);
		СтруктураСообщения.Копия = ИнтернетПочтовыеАдресаВСтроку(Сообщение.Копии);
		СтруктураСообщения.СкрытаяКопия = ИнтернетПочтовыеАдресаВСтроку(Сообщение.СлепыеКопии);
		
		СтруктураСообщения.Важность = Сообщение.Важность;
		СтруктураСообщения.Идентификатор = Сообщение.Идентификатор[0];
		
		СтруктураСообщения.ПоляЗаголовка = Сообщение.ПоляЗаголовка;
		
		Если Не ПолучитьЗаголовки Тогда
			Для каждого Вложение Из Сообщение.Вложения Цикл
				Если ТипЗнч(Вложение.Данные) <> Тип("ДвоичныеДанные") Тогда
					Продолжить;
				КонецЕсли;
				
				ИмяФайла =
					ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(Вложение.Имя, "_");
				
				ИмяФайлаИнфо = РаботаСоСтроками.РазложитьИмяФайла(ИмяФайла);
				ДобавитьВложениеДвоичныеДанные(
					СтруктураСообщения,
					Вложение.Данные,
					ИмяФайла,
					ИмяФайла,
					СтруктураСообщения.ТекстHTML,
					Вложение.Идентификатор);
			КонецЦикла;
		КонецЕсли;
		
		Результат.Добавить(СтруктураСообщения);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Удалить из ящика email сервера уже принятые сообщения
Функция УдалитьСообщенияИнтернетПочта(
	УчетнаяЗапись,
	Пароль,
	Идентификаторы) Экспорт
	
	// Установим соединение.
	СообщениеОбОшибке = "";
	ПротоколИнтернет = Неопределено;
	Соединение = Почта.ИнтернетПочтаУстановитьСоединение(УчетнаяЗапись, Пароль, СообщениеОбОшибке,,ПротоколИнтернет);
	Если Соединение = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Почта.УдалитьСообщенияВПочтовомЯщике(
		Соединение,
		Идентификаторы,,
		ПротоколИнтернет);
	Соединение.Отключиться();
	
	Возврат Истина;
	
КонецФункции

// Возвращает значение константы МаксимальноеЧислоПринимаемыхПисем.
//
// Возвращаемое значение:
//  Булево - значение константы МаксимальноеЧислоПринимаемыхПисем.
//
Функция МаксимальноеЧислоПринимаемыхПисем() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	МаксЧисло = Константы.МаксимальноеЧислоПринимаемыхПисем.Получить();
	Если МаксЧисло = 0 Тогда
		МаксЧисло = 1000;
	КонецЕсли;	
	
	Возврат МаксЧисло;
	
КонецФункции

/////////////////////////////////////////////////////////////////////////////////////////
// ОТПРАВКА СООБЩЕНИЯ

// Отправить письмо используя объект ИнтернетПочта
Функция ОтправитьИнтернетПочта(
	ПараметрыОтправки,
	Знач УчетнаяЗапись = Неопределено,
	Знач Пароль = Неопределено,
	СообщениеОбОшибке = Неопределено,
	Знач Соединение = Неопределено) Экспорт
	
	Если УчетнаяЗапись = Неопределено Тогда
		УчетнаяЗапись = ПредопределенноеЗначение("Справочник.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты");
	КонецЕсли;
	Если Не УчетнаяЗапись.ИспользоватьДляОтправки Тогда
		ВызватьИсключение НСтр("ru = 'Учетная запись не предназначена для отправки сообщений.'");
	КонецЕсли;
	
	ИнтернетПочтаПараметрыОтправки = Почта.СформироватьСтруктуруПараметровОтправки();
	
	Если ПараметрыОтправки.Свойство("Важность") Тогда
		ИнтернетПочтаПараметрыОтправки.Важность = ПараметрыОтправки.Важность;
	КонецЕсли;
	
	Если ПараметрыОтправки.Свойство("Вложения") Тогда
		Для каждого Вложение Из ПараметрыОтправки.Вложения Цикл
			СтруктураВложения = Новый Структура;
			СтруктураВложения.Вставить("Данные", Вложение.Адрес);
			СтруктураВложения.Вставить("Наименование", Вложение.ИмяФайла);
			ИнтернетПочтаПараметрыОтправки.Вложения.Добавить(СтруктураВложения);
		КонецЦикла;
	КонецЕсли;
	
	ДанныеУчетнойЗаписи = Почта.ПолучитьДанныеУчетнойЗаписи(УчетнаяЗапись);
	ИнтернетПочтаПараметрыОтправки.ИмяОтправителя = ДанныеУчетнойЗаписи.ПредставлениеАдресаЭлектроннойПочты;
	СтруктураПочтовогоАдреса = Новый Структура;
	СтруктураПочтовогоАдреса.Вставить("Адрес", ДанныеУчетнойЗаписи.АдресЭлектроннойПочты);
	СтруктураПочтовогоАдреса.Вставить("ОтображаемоеИмя", ДанныеУчетнойЗаписи.ОтображаемоеИмя);
	
	ИнтернетПочтаПараметрыОтправки.Отправитель = СтруктураПочтовогоАдреса;
	ИнтернетПочтаПараметрыОтправки.ОбратныйАдрес.Добавить(СтруктураПочтовогоАдреса);
	
	Если ПараметрыОтправки.Свойство("Кому")
		И ТипЗнч(ПараметрыОтправки.Кому) = Тип("Строка") Тогда
		Для каждого ПочтовыйАдресИнфо Из РаботаСоСтроками.РазложитьСтрокуПочтовыхАдресов(ПараметрыОтправки.Кому) Цикл
			СтруктураПочтовогоАдреса = Новый Структура;
			СтруктураПочтовогоАдреса.Вставить("Адрес", ПочтовыйАдресИнфо.Адрес);
			СтруктураПочтовогоАдреса.Вставить("ОтображаемоеИмя", ПочтовыйАдресИнфо.ОтображаемоеИмя);
			ИнтернетПочтаПараметрыОтправки.Получатели.Добавить(СтруктураПочтовогоАдреса);
		КонецЦикла;
	КонецЕсли;
	Если ПараметрыОтправки.Свойство("Получатели")
		И ТипЗнч(ПараметрыОтправки.Получатели) = Тип("Массив") Тогда
		Для каждого ПочтовыйАдресСтр Из ПараметрыОтправки.Получатели Цикл
			ПочтовыйАдресИнфо = РаботаСоСтроками.РазложитьПредставлениеАдресаЭлектроннойПочты(ПочтовыйАдресСтр);
			СтруктураПочтовогоАдреса = Новый Структура;
			СтруктураПочтовогоАдреса.Вставить("Адрес", ПочтовыйАдресИнфо.Адрес);
			СтруктураПочтовогоАдреса.Вставить("ОтображаемоеИмя", ПочтовыйАдресИнфо.ОтображаемоеИмя);
			ИнтернетПочтаПараметрыОтправки.Получатели.Добавить(СтруктураПочтовогоАдреса);
		КонецЦикла;
	КонецЕсли;
	
	Если ПараметрыОтправки.Свойство("Копия")
		И ТипЗнч(ПараметрыОтправки.Копия) = Тип("Строка") Тогда
		Для каждого ПочтовыйАдресИнфо Из РаботаСоСтроками.РазложитьСтрокуПочтовыхАдресов(ПараметрыОтправки.Копия) Цикл
			СтруктураПочтовогоАдреса = Новый Структура;
			СтруктураПочтовогоАдреса.Вставить("Адрес", ПочтовыйАдресИнфо.Адрес);
			СтруктураПочтовогоАдреса.Вставить("ОтображаемоеИмя", ПочтовыйАдресИнфо.ОтображаемоеИмя);
			ИнтернетПочтаПараметрыОтправки.Копии.Добавить(СтруктураПочтовогоАдреса);
		КонецЦикла;
	КонецЕсли;
	Если ПараметрыОтправки.Свойство("Копии")
		И ТипЗнч(ПараметрыОтправки.Копии) = Тип("Массив") Тогда
		Для каждого ПочтовыйАдресСтр Из ПараметрыОтправки.Копии Цикл
			ПочтовыйАдресИнфо = РаботаСоСтроками.РазложитьПредставлениеАдресаЭлектроннойПочты(ПочтовыйАдресСтр);
			СтруктураПочтовогоАдреса = Новый Структура;
			СтруктураПочтовогоАдреса.Вставить("Адрес", ПочтовыйАдресИнфо.Адрес);
			СтруктураПочтовогоАдреса.Вставить("ОтображаемоеИмя", ПочтовыйАдресИнфо.ОтображаемоеИмя);
			ИнтернетПочтаПараметрыОтправки.Копии.Добавить(СтруктураПочтовогоАдреса);
		КонецЦикла;
	КонецЕсли;
	
	Если ПараметрыОтправки.Свойство("СкрытаяКопия")
		И ТипЗнч(ПараметрыОтправки.СкрытаяКопия) = Тип("Строка") Тогда
		Для каждого ПочтовыйАдресИнфо Из РаботаСоСтроками.РазложитьСтрокуПочтовыхАдресов(ПараметрыОтправки.СкрытаяКопия) Цикл
			СтруктураПочтовогоАдреса = Новый Структура;
			СтруктураПочтовогоАдреса.Вставить("Адрес", ПочтовыйАдресИнфо.Адрес);
			СтруктураПочтовогоАдреса.Вставить("ОтображаемоеИмя", ПочтовыйАдресИнфо.ОтображаемоеИмя);
			ИнтернетПочтаПараметрыОтправки.СлепыеКопии.Добавить(СтруктураПочтовогоАдреса);
		КонецЦикла;
	КонецЕсли;
	Если ПараметрыОтправки.Свойство("СлепыеКопии")
		И ТипЗнч(ПараметрыОтправки.СлепыеКопии) = Тип("Массив") Тогда
		Для каждого ПочтовыйАдресСтр Из ПараметрыОтправки.СлепыеКопии Цикл
			ПочтовыйАдресИнфо = РаботаСоСтроками.РазложитьПредставлениеАдресаЭлектроннойПочты(ПочтовыйАдресСтр);
			СтруктураПочтовогоАдреса = Новый Структура;
			СтруктураПочтовогоАдреса.Вставить("Адрес", ПочтовыйАдресИнфо.Адрес);
			СтруктураПочтовогоАдреса.Вставить("ОтображаемоеИмя", ПочтовыйАдресИнфо.ОтображаемоеИмя);
			ИнтернетПочтаПараметрыОтправки.СлепыеКопии.Добавить(СтруктураПочтовогоАдреса);
		КонецЦикла;
	КонецЕсли;
	
	Если ПараметрыОтправки.Свойство("ПоляЗаголовка")
		И ТипЗнч(ПараметрыОтправки.ПоляЗаголовка) = Тип("Массив") Тогда
		
		ИнтернетПочтаПараметрыОтправки.ПоляЗаголовка = ПараметрыОтправки.ПоляЗаголовка;
		
	КонецЕсли;
	
	СтруктураТекста = Новый Структура;
	
	ТипТекста = Неопределено;
	ПараметрыОтправки.Свойство("ТипТекста", ТипТекста);
	Если Не (ЗначениеЗаполнено(ТипТекста)
		И ТипЗнч(ТипТекста) = Тип("ПеречислениеСсылка.ТипыТекстовПочтовыхСообщений")) Тогда
		ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст;
	КонецЕсли;
	
	СтруктураТекста.Вставить("ТипТекста", ТипТекста);
	СтруктураТекста.Вставить("Текст", ПараметрыОтправки.Текст);
	СтруктураТекста.Вставить("Кодировка", "");
	ИнтернетПочтаПараметрыОтправки.Тексты.Добавить(СтруктураТекста);
	
	Если ПараметрыОтправки.Свойство("ПроизвольныйТекст")
		И ПараметрыОтправки.Свойство("ПроизвольныйТипТекста")
		И ПараметрыОтправки.Свойство("КодировкаПроизвольногоТекста") Тогда
		
		СтруктураТекста = Новый Структура;
		СтруктураТекста.Вставить("ТипТекста", Перечисления.ТипыТекстовПочтовыхСообщений.ПроизвольныйТекст);
		СтруктураТекста.Вставить("Текст", ПараметрыОтправки.ПроизвольныйТекст);
		СтруктураТекста.Вставить("Кодировка", ПараметрыОтправки.КодировкаПроизвольногоТекста);
		СтруктураТекста.Вставить("ПроизвольныйТипТекста", ПараметрыОтправки.ПроизвольныйТипТекста);
		
		ИнтернетПочтаПараметрыОтправки.Тексты.Добавить(СтруктураТекста);
		
	КонецЕсли;
	
	ИнтернетПочтаПараметрыОтправки.Тема = ПараметрыОтправки.Тема;
	
	СообщениеОбОшибке = "";
	ИспользоватьДляПолучения = Ложь;
	ТребуетсяЗакрытьСоединение = Ложь;
	Если Соединение = Неопределено Тогда
		ТребуетсяЗакрытьСоединение = Истина;
		Соединение = Почта.ИнтернетПочтаУстановитьСоединение(
			УчетнаяЗапись, Пароль, СообщениеОбОшибке, ИспользоватьДляПолучения);
		Если Соединение = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	СообщениеОбОшибке = "";
	Результат = Почта.ОтправитьСообщение(
		Соединение,
		ИнтернетПочтаПараметрыОтправки,
		СообщениеОбОшибке,
		УчетнаяЗапись);
	
	Если ТребуетсяЗакрытьСоединение Тогда
		Соединение.Отключиться();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


/////////////////////////////////////////////////////////////////////////////////////////
// НАСТРОЙКИ ОТПРАВКИ СООБЩЕНИЙ

// Возвращает структуру настроек профилей для отправки почтовых сообщений
// Результат (Структура)
// - ВсеПрофили (Массив)
//   - Элемент (Структура)
//     - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//     - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//     - Использовать (Булево)
//     - Данные (Неопределено, Структура)
// - ДоступныеПрофили (Массив)
//   - Элемент (Структура)
//     - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//     - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//     - Использовать (Булево)
//     - Данные (Неопределено, Структура)
// - ОсновнойПрофиль (Неопределено, Структура)
//   - Элемент (Структура)
//     - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//     - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//     - Использовать (Булево)
//     - Данные (Структура)
// - Профиль (Неопределено, Структура)
//   - Элемент (Структура)
//     - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//     - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//     - Использовать (Булево)
//     - Данные (Структура)
//
Функция ПолучитьНастройкиПрофилейДляОтправки() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("ВсеПрофили", Новый Массив);
	Результат.Вставить("ДоступныеПрофили", Новый Массив);
	Результат.Вставить("ОсновнойПрофиль", Неопределено);
	Результат.Вставить("Профиль", Неопределено);
	
	ПриложениеЯвляетсяВебКлиентом = ОбщегоНазначенияДокументооборот.ПриложениеЯвляетсяВебКлиентом();
	
	ПараметрыОтбора = Новый Структура("ВариантИспользования", Перечисления.ВариантыИспользованияПочты.Легкая);
	УчетныеЗаписи = Почта.ПолучитьУчетныеЗаписиЭлектроннойПочты(ПараметрыОтбора);
	Для каждого УчетнаяЗапись Из УчетныеЗаписи Цикл
		СтруктураПрофиля = Новый Структура;
		СтруктураПрофиля.Вставить("Профиль", УчетнаяЗапись);
		СтруктураПрофиля.Вставить("ВидПочтовогоКлиента", Перечисления.ВидыПочтовыхКлиентов.ИнтернетПочта);
		СтруктураПрофиля.Вставить("Использовать", УчетнаяЗапись.ИспользоватьДляОтправки);
		
		ПрежнееЗначениеРежима = ПривилегированныйРежим();
		УстановитьПривилегированныйРежим(Истина);
		Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(УчетнаяЗапись, "ПарольSMTP");
		УстановитьПривилегированныйРежим(ПрежнееЗначениеРежима);
		
		СтруктураПрофиля.Вставить("Пароль", Пароль);
		
		СтруктураПрофиля.Вставить("Данные", Неопределено);
		
		Результат.ВсеПрофили.Добавить(СтруктураПрофиля);
		Если СтруктураПрофиля.Использовать Тогда
			Результат.ДоступныеПрофили.Добавить(СтруктураПрофиля);
		КонецЕсли;
	КонецЦикла;
	
	ПрофилиДляОтправкиНастройка = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РаботаСПочтой",
		"ПрофилиДляОтправки");
	
	Если ТипЗнч(ПрофилиДляОтправкиНастройка) = Тип("СписокЗначений") Тогда
		
		Для каждого ПрофильДляОтправки Из ПрофилиДляОтправкиНастройка.ВыгрузитьЗначения() Цикл
			
			СтруктураПрофиля = Новый Структура;
			СтруктураПрофиля.Вставить("Профиль", ПрофильДляОтправки.Наименование);
			СтруктураПрофиля.Вставить("ВидПочтовогоКлиента", ПрофильДляОтправки.ВидПочтовогоКлиента);
			СтруктураПрофиля.Вставить("Использовать", ПрофильДляОтправки.Использовать);
			СтруктураПрофиля.Вставить("Данные", ПрофильДляОтправки.Данные);
			
			Результат.ВсеПрофили.Добавить(СтруктураПрофиля);
			
			Если СтруктураПрофиля.Использовать Тогда
				
				Если (СтруктураПрофиля.ВидПочтовогоКлиента = Перечисления.ВидыПочтовыхКлиентов.MSOutlook
					Или СтруктураПрофиля.ВидПочтовогоКлиента = Перечисления.ВидыПочтовыхКлиентов.TheBat
					Или СтруктураПрофиля.ВидПочтовогоКлиента = Перечисления.ВидыПочтовыхКлиентов.MozillaThunderbird)
					И ПриложениеЯвляетсяВебКлиентом Тогда
					Продолжить;
				КонецЕсли;
				
				Результат.ДоступныеПрофили.Добавить(СтруктураПрофиля);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ПрофильДляОтправкиНастройка = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РаботаСПочтой",
		"ПрофильДляОтправки");
	
	Если ЗначениеЗаполнено(ПрофильДляОтправкиНастройка) Тогда
		
		Если ТипЗнч(ПрофильДляОтправкиНастройка) = Тип("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты") Тогда
			СтруктураПрофиля = Новый Структура;
			СтруктураПрофиля.Вставить("Профиль", ПрофильДляОтправкиНастройка);
			СтруктураПрофиля.Вставить("ВидПочтовогоКлиента", Перечисления.ВидыПочтовыхКлиентов.ИнтернетПочта);
			СтруктураПрофиля.Вставить("Использовать", ПрофильДляОтправкиНастройка.ИспользоватьДляОтправки);
			
			ПрежнееЗначениеРежима = ПривилегированныйРежим();
			УстановитьПривилегированныйРежим(Истина);
			Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ПрофильДляОтправкиНастройка, "ПарольSMTP");
			УстановитьПривилегированныйРежим(ПрежнееЗначениеРежима);
			
			СтруктураПрофиля.Вставить("Пароль", Пароль);
			
			СтруктураПрофиля.Вставить("Данные", Неопределено);
			
			Результат.ОсновнойПрофиль = СтруктураПрофиля;
			
		Иначе
			
			Для каждого ПрофильДляОтправки Из ПрофилиДляОтправкиНастройка.ВыгрузитьЗначения() Цикл
				
				Если ПрофильДляОтправки.Наименование = ПрофильДляОтправкиНастройка Тогда
					
					СтруктураПрофиля = Новый Структура;
					СтруктураПрофиля.Вставить("Профиль", ПрофильДляОтправки.Наименование);
					СтруктураПрофиля.Вставить("ВидПочтовогоКлиента", ПрофильДляОтправки.ВидПочтовогоКлиента);
					СтруктураПрофиля.Вставить("Использовать", ПрофильДляОтправки.Использовать);
					СтруктураПрофиля.Вставить("Данные", ПрофильДляОтправки.Данные);
					
					Если (СтруктураПрофиля.ВидПочтовогоКлиента = Перечисления.ВидыПочтовыхКлиентов.MSOutlook
						Или СтруктураПрофиля.ВидПочтовогоКлиента = Перечисления.ВидыПочтовыхКлиентов.TheBat
						Или СтруктураПрофиля.ВидПочтовогоКлиента = Перечисления.ВидыПочтовыхКлиентов.MozillaThunderbird)
						И ПриложениеЯвляетсяВебКлиентом Тогда
						Прервать;
					КонецЕсли;
					
					Результат.ОсновнойПрофиль = СтруктураПрофиля;
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат.ОсновнойПрофиль) Тогда
		Результат.Профиль = Результат.ОсновнойПрофиль;
	ИначеЕсли Результат.ДоступныеПрофили.Количество() = 1 Тогда
		Результат.Профиль = Результат.ДоступныеПрофили[0];
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


/////////////////////////////////////////////////////////////////////////////////////////
// НАСТРОЙКИ ЗАГРУЗКИ СООБЩЕНИЙ

// Возвращает структуру параметров загрузки сообщения
// Результат (Структура)
// - ИспользоватьЭП (Булево)
// - РасширениеДляФайловПодписи (Строка)
// - НастройкиПрофилейДляЗагрузки (Структура)
//   - ВсеПрофили (Массив)
//     - Элемент (Структура)
//       - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//       - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//       - Использовать (Булево)
//       - Данные (Неопределено, Структура)
//   - ДоступныеПрофили (Массив)
//     - Элемент (Структура)
//       - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//       - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//       - Использовать (Булево)
//       - Данные (Неопределено, Структура)
//   - ОсновнойПрофиль (Неопределено, Структура)
//     - Элемент (Структура)
//       - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//       - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//       - Использовать (Булево)
//       - Данные (Структура)
//   - Профиль (Неопределено, Структура)
//     - Элемент (Структура)
//       - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//       - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//       - Использовать (Булево)
//       - Данные (Структура)
//
Функция ПолучитьПараметрыЗагрузкиПочтовыхСообщений() Экспорт
	
	Результат = Новый Структура;
	
	ИспользоватьЭП = ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныеПодписи");
	
	РасширениеДляФайловПодписи = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ЭП",
		"РасширениеДляФайловПодписи",
		"p7s");
	
	ИзвлекатьТекстыФайловНаКлиенте = Не Константы.ИзвлекатьТекстыФайловНаСервере.Получить();	
	ИспользоватьГрифыДоступа = ПолучитьФункциональнуюОпцию("ИспользоватьГрифыДоступа");
	ИспользоватьУчетПоОрганизациям = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям");
	ИспользоватьВопросыДеятельности = ПолучитьФункциональнуюОпцию("ИспользоватьВопросыДеятельности");
	
	НастройкиПрофилейДляЗагрузки = ПолучитьНастройкиПрофилейДляЗагрузки();
	
	Результат.Вставить("ИспользоватьЭП", ИспользоватьЭП);
	Результат.Вставить("РасширениеДляФайловПодписи", РасширениеДляФайловПодписи);
	Результат.Вставить("ИзвлекатьТекстыФайловНаКлиенте", ИзвлекатьТекстыФайловНаКлиенте);
	Результат.Вставить("ИспользоватьГрифыДоступа", ИспользоватьГрифыДоступа);
	Результат.Вставить("ИспользоватьВидыДокументов", Истина);
	Результат.Вставить("ИспользоватьУчетПоОрганизациям", ИспользоватьУчетПоОрганизациям);
	Результат.Вставить("ИспользоватьВопросыДеятельности", ИспользоватьВопросыДеятельности);
	
	Результат.Вставить("НастройкиПрофилейДляЗагрузки", НастройкиПрофилейДляЗагрузки);
	
	Результат.Вставить("ПарольНеТребуется", Ложь);
	
	Если НастройкиПрофилейДляЗагрузки.Профиль <> Неопределено Тогда
		
		ВидПочтовогоКлиента = НастройкиПрофилейДляЗагрузки.Профиль.ВидПочтовогоКлиента;
		Если ВидПочтовогоКлиента = ПредопределенноеЗначение("Перечисление.ВидыПочтовыхКлиентов.ИнтернетПочта") Тогда
	
			УчетнаяЗапись = НастройкиПрофилейДляЗагрузки.Профиль.Профиль;
			ИспользоватьOAuth = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗапись, "ИспользоватьOAuth");
			Если ИспользоватьOAuth Тогда
				Результат.ПарольНеТребуется = Истина;
			КонецЕсли;	
			
		КонецЕсли;
			
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Возвращает структуру настроек профилей для загрузки почтовых сообщений
// Результат (Структура)
// - ВсеПрофили (Массив)
//   - Элемент (Структура)
//     - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//     - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//     - Использовать (Булево)
//     - Данные (Неопределено, Структура)
// - ДоступныеПрофили (Массив)
//   - Элемент (Структура)
//     - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//     - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//     - Использовать (Булево)
//     - Данные (Неопределено, Структура)
// - ОсновнойПрофиль (Неопределено, Структура)
//   - Элемент (Структура)
//     - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//     - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//     - Использовать (Булево)
//     - Данные (Структура)
// - Профиль (Неопределено, Структура)
//   - Элемент (Структура)
//     - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//     - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//     - Использовать (Булево)
//     - Данные (Структура)
//
Функция ПолучитьНастройкиПрофилейДляЗагрузки() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("ВсеПрофили", Новый Массив);
	Результат.Вставить("ДоступныеПрофили", Новый Массив);
	Результат.Вставить("ОсновнойПрофиль", Неопределено);
	Результат.Вставить("Профиль", Неопределено);
	
	ПараметрыОтбора = Новый Структура("ВариантИспользования", Перечисления.ВариантыИспользованияПочты.Легкая);
	УчетныеЗаписи = Почта.ПолучитьУчетныеЗаписиЭлектроннойПочты(ПараметрыОтбора);
	Для каждого УчетнаяЗапись Из УчетныеЗаписи Цикл
		СтруктураПрофиля = Новый Структура;
		СтруктураПрофиля.Вставить("Профиль", УчетнаяЗапись);
		СтруктураПрофиля.Вставить("ВидПочтовогоКлиента", Перечисления.ВидыПочтовыхКлиентов.ИнтернетПочта);
		СтруктураПрофиля.Вставить("Использовать", УчетнаяЗапись.ИспользоватьДляПолучения);
		
		ПрежнееЗначениеРежима = ПривилегированныйРежим();
		УстановитьПривилегированныйРежим(Истина);
		Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(УчетнаяЗапись, "Пароль");
		УстановитьПривилегированныйРежим(ПрежнееЗначениеРежима);
		
		СтруктураПрофиля.Вставить("Пароль", Пароль);
		
		СтруктураПрофиля.Вставить("Данные", Неопределено);
		
		Результат.ВсеПрофили.Добавить(СтруктураПрофиля);
		Если СтруктураПрофиля.Использовать Тогда
			Результат.ДоступныеПрофили.Добавить(СтруктураПрофиля);
		КонецЕсли;
	КонецЦикла;
	
	ПрофилиДляЗагрузкиНастройка = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РаботаСПочтой",
		"ПрофилиДляЗагрузки");
	Если ТипЗнч(ПрофилиДляЗагрузкиНастройка) = Тип("СписокЗначений") Тогда
		Для каждого ПрофильДляЗагрузки Из ПрофилиДляЗагрузкиНастройка.ВыгрузитьЗначения() Цикл
			СтруктураПрофиля = Новый Структура;
			СтруктураПрофиля.Вставить("Профиль", ПрофильДляЗагрузки.Наименование);
			СтруктураПрофиля.Вставить("ВидПочтовогоКлиента", ПрофильДляЗагрузки.ВидПочтовогоКлиента);
			СтруктураПрофиля.Вставить("Использовать", ПрофильДляЗагрузки.Использовать);
			СтруктураПрофиля.Вставить("Данные", ПрофильДляЗагрузки.Данные);
			
			Результат.ВсеПрофили.Добавить(СтруктураПрофиля);
			Если СтруктураПрофиля.Использовать Тогда
				Результат.ДоступныеПрофили.Добавить(СтруктураПрофиля);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ПрофильДляЗагрузкиНастройка = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РаботаСПочтой",
		"ПрофильДляЗагрузки");
	Если ЗначениеЗаполнено(ПрофильДляЗагрузкиНастройка) Тогда
		Если ТипЗнч(ПрофильДляЗагрузкиНастройка) = Тип("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты") Тогда
			СтруктураПрофиля = Новый Структура;
			СтруктураПрофиля.Вставить("Профиль", ПрофильДляЗагрузкиНастройка);
			СтруктураПрофиля.Вставить("ВидПочтовогоКлиента", Перечисления.ВидыПочтовыхКлиентов.ИнтернетПочта);
			СтруктураПрофиля.Вставить("Использовать", ПрофильДляЗагрузкиНастройка.ИспользоватьДляПолучения);
			
			ПрежнееЗначениеРежима = ПривилегированныйРежим();
			УстановитьПривилегированныйРежим(Истина);
			Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ПрофильДляЗагрузкиНастройка, "Пароль");
			УстановитьПривилегированныйРежим(ПрежнееЗначениеРежима);
			
			СтруктураПрофиля.Вставить("Пароль", Пароль);
			
			СтруктураПрофиля.Вставить("Данные", Неопределено);
			
			Результат.ОсновнойПрофиль = СтруктураПрофиля;
		Иначе
			Для каждого ПрофильДляЗагрузки Из ПрофилиДляЗагрузкиНастройка.ВыгрузитьЗначения() Цикл
				Если ПрофильДляЗагрузки.Наименование = ПрофильДляЗагрузкиНастройка Тогда
					СтруктураПрофиля = Новый Структура;
					СтруктураПрофиля.Вставить("Профиль", ПрофильДляЗагрузки.Наименование);
					СтруктураПрофиля.Вставить("ВидПочтовогоКлиента", ПрофильДляЗагрузки.ВидПочтовогоКлиента);
					СтруктураПрофиля.Вставить("Использовать", ПрофильДляЗагрузки.Использовать);
					СтруктураПрофиля.Вставить("Данные", ПрофильДляЗагрузки.Данные);
					
					Результат.ОсновнойПрофиль = СтруктураПрофиля;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат.ОсновнойПрофиль) Тогда
		Результат.Профиль = Результат.ОсновнойПрофиль;
	ИначеЕсли Результат.ДоступныеПрофили.Количество() = 1 Тогда
		Результат.Профиль = Результат.ДоступныеПрофили[0];
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


/////////////////////////////////////////////////////////////////////////////////////////
// РАБОТА СО СТРУКТУРОЙ ПОЧТОВОГО СООБЩЕНИЯ

// Сохраняет двоичные данные во временном хранилище
// и добавляет адрес сохраненных данных в структуру Сообщения
//
// Параметры:
// - Сообщение (Структура)
// - ДвоичныеДанные (ДвоичныеДанные)
// - Наименование (Строка)
// - ИмяФайла (Строка)
//
Процедура ДобавитьВложениеДвоичныеДанные(
	СтруктураСообщения,
	ДвоичныеДанные,
	Наименование,
	ИмяФайла,
	ТекстHTML = "",
	Идентификатор = "") Экспорт
	
	Размер = ДвоичныеДанные.Размер();
	АдресФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанные, СтруктураСообщения.УникальныйИдентификатор);
	ВложенияСтрока = ЛегкаяПочтаКлиентСервер.ВложенияДобавитьСтроку(
		СтруктураСообщения,
		Наименование,
		ИмяФайла,
		"", // ПолноеИмяФайла
		АдресФайла,
		Размер,
		ТекстHTML,
		Идентификатор);
	
КонецПроцедуры


/////////////////////////////////////////////////////////////////////////////////////////
// ОТПРАВКА УВЕДОМЛЕНИЯ

// Шлет письмо по легкой почте
//
// Параметры
//  Наименование - Строка - наименование (для Темы письма)
//  Описание - Строка - подробное описание
Процедура УведомитьОтветственныхПоЛегкойПочте(Наименование, Описание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивСотрудников = РаботаСУведомлениями.СписокПолучателейУведомленийОПроблемах(
			Перечисления.РазделыУведомленийОПроблемах.Почта);
	Если МассивСотрудников.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;	
	
	АдресаОповещения = "";
	
	Для Каждого Сотрудник Из МассивСотрудников Цикл
		
		Адрес = ВстроеннаяПочтаСервер.ПолучитьОсновнойАдрес(Сотрудник);
		
		Если ЗначениеЗаполнено(Адрес) Тогда          
			
			Если ЗначениеЗаполнено(АдресаОповещения) Тогда
				АдресаОповещения = АдресаОповещения + ";";
			КонецЕсли;	
			
			АдресаОповещения = АдресаОповещения + Адрес;
			
		КонецЕсли;	
		
	КонецЦикла;
	
	СообщениеОбОшибке = "";
	
	Попытка
		
		ПараметрыПисьма = Новый Структура;
		ПараметрыПисьма.Вставить("Тема", Наименование);
		ПараметрыПисьма.Вставить("Текст", Описание);
		ПараметрыПисьма.Вставить("Кому", АдресаОповещения);
		ПараметрыПисьма.Вставить("ТипТекста", Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст);
		
		КодВозврата = ЛегкаяПочтаСервер.ОтправитьИнтернетПочта(ПараметрыПисьма,,,СообщениеОбОшибке);
		
		Если КодВозврата = Ложь Тогда
			
			ЗаписьЖурналаРегистрации(
				"УведомитьОтветственныхПоЛегкойПочте",
				УровеньЖурналаРегистрации.Ошибка, , ,
				СообщениеОбОшибке);
			
		КонецЕсли;	
		
	Исключение
		
		ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1: %2.'"),
			"УведомитьОтветственныхПоЛегкойПочте", ОписаниеОшибки);
			
		ЗаписьЖурналаРегистрации(
			"УведомитьОтветственныхПоЛегкойПочте",
			УровеньЖурналаРегистрации.Ошибка, , ,
			ТекстСообщения);
			
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПредставлениеИнтернетПочтовогоАдреса(ИнтернетПочтовыйАдрес)
	
	ОтображаемоеИмя = РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(
		ИнтернетПочтовыйАдрес.ОтображаемоеИмя);
	Адрес = РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(
		ИнтернетПочтовыйАдрес.Адрес);
	Возврат РаботаСоСтроками.ПолучитьПредставлениеАдресаЭлектроннойПочты(
		ОтображаемоеИмя,
		Адрес);
	
КонецФункции

Функция ИнтернетПочтовыеАдресаВСтроку(ИнтернетПочтовыеАдреса)
	
	Результат = "";
	Для каждого ИнтернетПочтовыйАдрес Из ИнтернетПочтовыеАдреса Цикл
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
			Результат,
			"; ",
			ПолучитьПредставлениеИнтернетПочтовогоАдреса(
				ИнтернетПочтовыйАдрес))
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

#КонецОбласти
