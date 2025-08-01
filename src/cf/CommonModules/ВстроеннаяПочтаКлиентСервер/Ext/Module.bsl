﻿////////////////////////////////////////////////////////////////////////////////
// Встроенная почта (клиент, сервер)
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверка. Значение является входящим или исходящим письмом.
//
Функция ЭтоПисьмо(Значение) Экспорт
	
	Возврат ЭтоВходящееПисьмо(Значение) Или ЭтоИсходящееПисьмо(Значение);
	
КонецФункции

// Проверка. Значение является входящим письмом.
//
Функция ЭтоВходящееПисьмо(Значение) Экспорт
	
	#Если Сервер Тогда
		Возврат ТипЗнч(Значение) = Тип("ДокументСсылка.ВходящееПисьмо")
			Или ТипЗнч(Значение) = Тип("ДокументОбъект.ВходящееПисьмо");
	#Иначе
		Возврат ТипЗнч(Значение) = Тип("ДокументСсылка.ВходящееПисьмо");
	#КонецЕсли
	
КонецФункции

// Проверка. Значение является исходящим письмом.
//
Функция ЭтоИсходящееПисьмо(Значение) Экспорт
	
	#Если Сервер Тогда
		Возврат ТипЗнч(Значение) = Тип("ДокументСсылка.ИсходящееПисьмо")
			Или ТипЗнч(Значение) = Тип("ДокументОбъект.ИсходящееПисьмо");
	#Иначе
		Возврат ТипЗнч(Значение) = Тип("ДокументСсылка.ИсходящееПисьмо");
	#КонецЕсли
	
КонецФункции

// Проверка. Значение является папкой писем.
//
Функция ЭтоПапкаПисем(Значение) Экспорт
	
	Возврат (ТипЗнч(Значение) = Тип("СправочникСсылка.ПапкиПисем"));
	
КонецФункции

// Возвращает подпись к числу писем с учетом склонений русского
// языка.
Функция ПодписьКЧислуПисемСтрокой(ЧислоПисем) Экспорт
	
	Если ЧислоПисем <= 20 Тогда
		
		Если ЧислоПисем = 1 Тогда
			Возврат НСтр("ru = 'письмо'");
		ИначеЕсли ЧислоПисем = 2 Или ЧислоПисем = 3 Или ЧислоПисем = 4 Тогда
			Возврат НСтр("ru = 'письма'");
		Иначе
			Возврат НСтр("ru = 'писем'");
		КонецЕсли;
		
	Иначе
		
		ПоследняяЦифра = ЧислоПисем % 10;
		
		Если ПоследняяЦифра = 1 Тогда
			Возврат НСтр("ru = 'письмо'");
		ИначеЕсли ПоследняяЦифра = 2 Или ПоследняяЦифра = 3 Или ПоследняяЦифра = 4 Тогда
			Возврат НСтр("ru = 'письма'");
		Иначе
			Возврат НСтр("ru = 'писем'");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НСтр("ru = 'писем'");
	
КонецФункции

// Возвращает подпись к числу задач с учетом склонений русского
// языка.
Функция ПодписьКЧислуЗадачСтрокой(ЧислоПисем) Экспорт
	
	ПоследняяЦифра = ЧислоПисем % 10;
	Если ЧислоПисем = 12 Или ЧислоПисем = 13 Или ЧислоПисем = 14 Тогда
		Возврат НСтр("ru = 'задач'");
	ИначеЕсли ПоследняяЦифра = 1 Тогда
		Возврат НСтр("ru = 'задача'");
	ИначеЕсли ПоследняяЦифра = 2 Или ПоследняяЦифра = 3 Или ПоследняяЦифра = 4 Тогда
		Возврат НСтр("ru = 'задачи'");
	КонецЕсли;
	
	Возврат НСтр("ru = 'задач'");
	
КонецФункции

// Возвращает подпись к числу предметов с учетом склонений русского языка.
// ПримерВызова: ПодписьКЧислу(Количество, НСтр("ru = 'задача'"), НСтр("ru = 'задачи'"), НСтр("ru = 'задач'"));
//
Функция ПодписьКЧислу(Число, Предмет, Предмета, Предметов) Экспорт
	
	ЧислоПоМодулю100 = Число % 100;
	ЧислоПоМодулю10 = Число % 10;
	Если ЧислоПоМодулю10 = 1 Тогда
		Если ЧислоПоМодулю100 = 11 Тогда
			Возврат Предметов;
		Иначе
			Возврат Предмет;
		КонецЕсли;
	ИначеЕсли ЧислоПоМодулю10 = 2 Или ЧислоПоМодулю10 = 3 Или ЧислоПоМодулю10 = 4 Тогда
		Если ЧислоПоМодулю100 = 12 Или ЧислоПоМодулю100 = 13 Или ЧислоПоМодулю100 = 14 Тогда
			Возврат Предметов;
		Иначе
			Возврат Предмета;
		КонецЕсли;
	Иначе
		Возврат Предметов;
	КонецЕсли;
	
КонецФункции

// Выделить представление (вида "Адресат") из строки вида "Адресат <adress@mail.ru>"
Функция ВыделитьПредставление(ПредставлениеИАдрес) Экспорт
	
	Представление = "";
	
	Поз = Найти(ПредставлениеИАдрес, "<");
	Если Поз <> 0 Тогда
		Представление = Лев(ПредставлениеИАдрес, Поз - 1);
	Иначе	
		Представление = ПредставлениеИАдрес;
	КонецЕсли;
	
	Представление = СокрЛП(Представление);
	
	Возврат Представление;
	
КонецФункции	

// Выделить домен из email адреса
Функция ПолучитьДомен(АдресЭП) Экспорт
	
	Домен = "";

	Поз = Найти(АдресЭП, "@");
	Если Поз <> 0 Тогда
		Домен = Сред(АдресЭП, Поз);
	КонецЕсли;
	
	Возврат Домен;

КонецФункции		

// Функция возвращает массив символов, которые используются в качестве разделителей слов адреса.
Функция ПолучитьРазделителиСловПочтовогоАдреса() Экспорт
	
	РазделителиСлов = Новый Массив;
	РазделителиСлов.Добавить(" ");
	РазделителиСлов.Добавить(",");
	РазделителиСлов.Добавить(":");
	РазделителиСлов.Добавить(";");
	РазделителиСлов.Добавить("~");
	РазделителиСлов.Добавить("!");
	РазделителиСлов.Добавить("#");
	РазделителиСлов.Добавить("%");
	РазделителиСлов.Добавить("^");
	РазделителиСлов.Добавить("&");
	РазделителиСлов.Добавить("*");
	РазделителиСлов.Добавить("(");
	РазделителиСлов.Добавить(")");
	РазделителиСлов.Добавить("+");
	РазделителиСлов.Добавить("=");
	РазделителиСлов.Добавить("/");
	РазделителиСлов.Добавить("\");
	РазделителиСлов.Добавить("|");
	РазделителиСлов.Добавить("[");
	РазделителиСлов.Добавить("]");
	РазделителиСлов.Добавить("{");
	РазделителиСлов.Добавить("}");
	РазделителиСлов.Добавить("?");
	РазделителиСлов.Добавить("'");
	РазделителиСлов.Добавить("""");
	РазделителиСлов.Добавить("«");
	РазделителиСлов.Добавить("»");
	РазделителиСлов.Добавить("<");
	РазделителиСлов.Добавить(">");
	РазделителиСлов.Добавить("№");
	РазделителиСлов.Добавить(Символы.ВК);
	РазделителиСлов.Добавить(Символы.Таб);
	РазделителиСлов.Добавить(Символы.ПС);

	Возврат РазделителиСлов;
	
КонецФункции

// Функция разбивает переданную строку на отдельные слова
Функция СтрокуПочтовогоАдресаВСлова(Знач СтрокаАдреса,РазделителиСлов = Неопределено) Экспорт 
	
	Если ТипЗнч(РазделителиСлов) <> Тип("Массив") Тогда
		РазделителиСлов = ПолучитьРазделителиСловПочтовогоАдреса();
	КонецЕсли;
	
	СтрокаАдреса = СтрЗаменить(СтрокаАдреса, "ё", "е");
	СтрокаАдреса = СтрЗаменить(СтрокаАдреса, "Ё", "Е");
	
	СловаАдреса = Новый Массив;
	
	ДлинаСтр = СтрДлина(СтрокаАдреса);
	НачалоСлова = 0;
	ДлинаСлова = 0;
	Для Счетчик = 1 По ДлинаСтр Цикл
		
		ТекущийСимвол = Сред(СтрокаАдреса,Счетчик,1);
		
		Если РазделителиСлов.Найти(ТекущийСимвол) <> Неопределено Тогда
			
			Если НачалоСлова > 0 и ДлинаСлова > 0 Тогда
				
				Слово = Сред(СтрокаАдреса,НачалоСлова,ДлинаСлова);
				СловаАдреса.Добавить(Слово);
				
			КонецЕсли;
			
			ДлинаСлова = 0;
			НачалоСлова = 0;
			
		Иначе
			
			Если НачалоСлова = 0 Тогда
				НачалоСлова = Счетчик;
			КонецЕсли;
			
			ДлинаСлова = ДлинаСлова + 1;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если НачалоСлова > 0 и ДлинаСлова > 0 Тогда
		
		Слово = Сред(СтрокаАдреса,НачалоСлова,Счетчик-1);
		СловаАдреса.Добавить(Слово);
		
	КонецЕсли;
	
	Возврат СловаАдреса;
	
КонецФункции

// Функция разбивает переданную строку на структуры (слово и его позиция)
Функция СтрокуПочтовогоАдресаВСтруктурыСлов(Знач СтрокаАдреса,РазделителиСлов = Неопределено) Экспорт 
	
	Если ТипЗнч(РазделителиСлов) <> Тип("Массив") Тогда
		РазделителиСлов = ПолучитьРазделителиСловПочтовогоАдреса();
	КонецЕсли;
	
	СтрокаАдреса = СтрЗаменить(СтрокаАдреса, "ё", "е");
	СтрокаАдреса = СтрЗаменить(СтрокаАдреса, "Ё", "Е");
	
	СловаАдреса = Новый Массив;
	
	ДлинаСтр = СтрДлина(СтрокаАдреса);
	НачалоСлова = 0;
	ДлинаСлова = 0;
	Для Счетчик = 1 По ДлинаСтр Цикл
		
		ТекущийСимвол = Сред(СтрокаАдреса,Счетчик,1);
		
		Если РазделителиСлов.Найти(ТекущийСимвол) <> Неопределено Тогда
			
			Если НачалоСлова > 0 и ДлинаСлова > 0 Тогда
				
				Слово = Сред(СтрокаАдреса,НачалоСлова,ДлинаСлова);
				СловаАдреса.Добавить(Новый Структура("Слово, Позиция", Слово, НачалоСлова));
				
			КонецЕсли;
			
			ДлинаСлова = 0;
			НачалоСлова = 0;
			
		Иначе
			
			Если НачалоСлова = 0 Тогда
				НачалоСлова = Счетчик;
			КонецЕсли;
			
			ДлинаСлова = ДлинаСлова + 1;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если НачалоСлова > 0 и ДлинаСлова > 0 Тогда
		
		Слово = Сред(СтрокаАдреса,НачалоСлова,Счетчик-1);
		СловаАдреса.Добавить(Новый Структура("Слово, Позиция", Слово, НачалоСлова));
		
	КонецЕсли;
	
	Возврат СловаАдреса;
	
КонецФункции

// Возвращает стандартный шрифт программы для почты
//
// Параметры:
//  Имя параметра - Список типов - Текстовое описание параметра
//
// Возвращаемое значение:
//  Шрифт - Шрифт Microsoft Sans Serif, размер 10
Функция ПолучитьШрифтПочтыПоУмолчанию() Экспорт
	
	Возврат Новый Шрифт("Arial", 10);
	
КонецФункции

// Возвращает Истина, если адресатов много
Функция ЭтоРассылка(ЧислоАдресатов) Экспорт
	
	Если ЧислоАдресатов > 50 Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Возврат Ложь;
	
КонецФункции

// Определяет схему навигационной ссылки.
//
// Параметры:
//  НавигационнаяСсылка - Строка - Навигационная ссылка.
//
// Возвращаемое значение:
//  Строка - Схема навигационной ссылки.
//
Функция СхемаСсылки(НавигационнаяСсылка) Экспорт
	
	НРегНавигационнаяСсылка = НРег(НавигационнаяСсылка);
	Если СтрНачинаетсяС(НРегНавигационнаяСсылка, "v8doc:") Тогда
		
		СхемаСсылки = "v8doc:";
		
	ИначеЕсли СтрНачинаетсяС(НРегНавигационнаяСсылка, "http://") Тогда
		
		СхемаСсылки = "http://";
		
	ИначеЕсли СтрНачинаетсяС(НРегНавигационнаяСсылка, "https://") Тогда
		
		СхемаСсылки = "https://";
		
	ИначеЕсли СтрНачинаетсяС(НРегНавигационнаяСсылка, "ftp://") Тогда
		
		СхемаСсылки = "ftp://";
		
	ИначеЕсли СтрНачинаетсяС(НРегНавигационнаяСсылка, "e1c://") Тогда
		
		СхемаСсылки = "e1c://";
		
	ИначеЕсли СтрНачинаетсяС(НРегНавигационнаяСсылка, "file://") Тогда
		
		СхемаСсылки = "file://";
		
	ИначеЕсли СтрНачинаетсяС(НРегНавигационнаяСсылка, "mailto:") Тогда
		
		СхемаСсылки = "mailto:";
		
	Иначе
		
		СхемаСсылки = "";
		
	КонецЕсли;
	
	Возврат СхемаСсылки;
	
КонецФункции

// Вернет Истина если это приглашение
// 
// Параметры:
//  Представление - Строка - вида "файл.ics"
//  РасширенияICS - Строка - вида "ICS IFB"
//  
//  Возвращаемое значение:
//  Булево
//
Функция ЭтоФайлПриглашение(Представление, РасширенияICS) Экспорт
	
	МассивСтрок = СтрРазделить(Представление, ".", Ложь);
	Если МассивСтрок.Количество() < 2 Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	МассивРасширения = СтрРазделить(РасширенияICS, " ", Ложь);
	Если МассивРасширения.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Расширение = МассивСтрок[МассивСтрок.Количество()-1];
	Расширение = ВРег(Расширение);
	Если МассивРасширения.Найти(Расширение) <> Неопределено Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти