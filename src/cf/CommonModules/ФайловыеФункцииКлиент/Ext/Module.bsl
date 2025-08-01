﻿////////////////////////////////////////////////////////////////////////////////
// Файловые функции (клиент)
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция добавляет концевой слэш к имени каталога, если это надо
// а также удаляет все запрещенные символы из имени каталога
// кроме того, "/" заменяется на "\"
Функция НормализоватьКаталог(ИмяКаталога) Экспорт
	Результат = СокрЛП(ИмяКаталога);
	
	// Запомним наличие "Диск:" в начале пути и потом вернем ":" после имени диска
	СтрДиск = "";
	Если Сред(Результат, 2, 1) = ":" Тогда
		СтрДиск = Сред(Результат, 1, 2);
		Результат = Сред(Результат, 3);
	Иначе
		
		// А здесь проверим, что у нас UNC-путь (т.е. путь начинающийся на "\\")
		Если Сред(Результат, 1, 2) = "\\" Тогда
			СтрДиск = Сред(Результат, 1, 2);
			Результат = Сред(Результат, 3);
		КонецЕсли;
	КонецЕсли;
	
	ПравильныйРазделитель = ПолучитьРазделительПутиКлиента();
	
	// Делаем слэши в нужном стиле
	Результат = СтрЗаменить(Результат, "/", ПравильныйРазделитель);
	
	// Добавляем финишный слэш
	Результат = СокрЛП(Результат);
	Если Прав(Результат,1) <> "\" Тогда
		Результат = Результат + "\";
	КонецЕсли;
	
	// Заменим все двойные слэши на одинарные и  получим полный путь
	
	Если Лев(Результат, 2) = "\\" Тогда  // UNC путь
		СтрокаБезПрефикса = Сред(Результат, 3);
		Результат = "\\" + СтрЗаменить(СтрокаБезПрефикса, "\\", "\");
	Иначе
		Результат = СтрДиск + СтрЗаменить(Результат, "\\", "\");
	КонецЕсли;	
	
	Возврат Результат;
КонецФункции

// Процедура предназначена для проверки имени файла на наличие некорректных символов
// Параметры:
//  СтрИмяФайла  - Строка
//                 проверяемое имя файла
//  ФлУдалятьНекорректные - Булево
//                 удалять или нет некорректные символы из переданной строки
Процедура КорректноеИмяФайла(ИмяФайла, ФлУдалятьНекорректные = Ложь) Экспорт
	
	СтрИсключения = ОбщегоНазначенияКлиентСервер.ПолучитьНедопустимыеСимволыВИмениФайла();
	
	ТекстОшибки =
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	  НСтр("ru = 'В имени файла не должно быть следующих символов: %1'"), СтрИсключения);
	
	Результат = Истина;
	
	МассивНайденныхНедопустимыхСимволов = ОбщегоНазначенияКлиентСервер.НайтиНедопустимыеСимволыВИмениФайла(ИмяФайла);
	Если МассивНайденныхНедопустимыхСимволов.Количество() <> 0 Тогда
		
		Результат = Ложь;
		
		Если ФлУдалятьНекорректные Тогда
			ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла, "");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Результат Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры // КорректноеИмяФайла()

// Рекурсивно обойти каталоги и посчитать количество файлов и их суммарный размер
Процедура ОбходФайловРазмер(Путь, МассивФайлов, РазмерСуммарный, КоличествоСуммарное, ВсеПутиФайлов) Экспорт
	Для Каждого ВыбранныйФайл Из МассивФайлов Цикл
		
		Если ВыбранныйФайл.ЭтоКаталог() Тогда
			НовыйПуть = Строка(Путь);
			НовыйПуть = НовыйПуть + ПолучитьРазделительПути();
			НовыйПуть = НовыйПуть + Строка(ВыбранныйФайл.Имя);
			МассивФайловВКаталоге = НайтиФайлы(НовыйПуть, "*.*");
			
			Если МассивФайловВКаталоге.Количество() <> 0 Тогда
				ОбходФайловРазмер(НовыйПуть, МассивФайловВКаталоге, РазмерСуммарный, КоличествоСуммарное,
					ВсеПутиФайлов);
			КонецЕсли;
		
			Продолжить;
		КонецЕсли;
		
		РазмерСуммарный = РазмерСуммарный + ВыбранныйФайл.Размер();
		КоличествоСуммарное = КоличествоСуммарное + 1;
		ВсеПутиФайлов.Добавить(ВыбранныйФайл.ПолноеИмя);
		
	КонецЦикла;
КонецПроцедуры

// Получает относительный путь к файлу в рабочем каталоге - если есть в регистре сведений - оттуда,
// если нет - сгенерируем - и запишем в регистр сведений
Функция ПолучитьПутьФайлаВРабочемКаталоге(ДанныеФайла) Экспорт
	ПутьДляВозврата	= "";
	ИмяФайлаСПутем = "";
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	ИмяКаталога = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;

	// Сперва пытаемся найти такую запись в регистре сведений
	ИмяФайлаСПутем = ДанныеФайла.ПолноеИмяФайлаВРабочемКаталоге;
	ВРабочемКаталогеНаЧтение = ДанныеФайла.ВРабочемКаталогеНаЧтение;
	
	Если ИмяФайлаСПутем <> "" Тогда
		// Тут надо еще на наличие на диске проверять
		ФайлНаДиске = Новый Файл(ИмяФайлаСПутем);
		Если ФайлНаДиске.Существует() Тогда
			Возврат ИмяФайлаСПутем;	
		КонецЕсли;
	КонецЕсли;
	
	// Формирование имени файла с расширением
	ИмяФайла = ДанныеФайла.ПолноеНаименованиеВерсии;
	Расширение = ДанныеФайла.Расширение;
	Если Не ПустаяСтрока(Расширение) Тогда 
		ИмяФайла = ФайловыеФункцииКлиент.ПолучитьИмяСРасширением(ИмяФайла, Расширение);
	КонецЕсли;
	
	ИмяФайлаСПутем = "";
	Если Не ПустаяСтрока(ИмяФайла) Тогда
		Если ДанныеФайла.РабочийКаталогВладельца <> "" Тогда
			ИмяФайлаСПутем = ДанныеФайла.РабочийКаталогВладельца + ДанныеФайла.ПолноеНаименованиеВерсии + "." + ДанныеФайла.Расширение;
		Иначе
			ИмяФайлаСПутем = ФайловыеФункцииКлиентСервер.ПолучитьУникальноеИмяСПутем(
				ИмяКаталога, ИмяФайла, ОбщегоНазначенияКлиент.ТипПлатформыКлиента());
		КонецЕсли;		
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяФайла) Тогда
		Возврат "";
	КонецЕсли;
	
	// Запишем в регистр имя файла
	НаЧтение = Истина;
	ВРабочемКаталогеВладельца = ДанныеФайла.РабочийКаталогВладельца <> "";
	РаботаСФайламиВызовСервера.ЗаписатьИмяФайлаСПутемВРегистр(ДанныеФайла.Версия, ИмяФайлаСПутем, НаЧтение, ВРабочемКаталогеВладельца);
	
	Если ДанныеФайла.РабочийКаталогВладельца = "" Тогда
		ПутьДляВозврата = ИмяКаталога + ИмяФайлаСПутем;
	Иначе
		ПутьДляВозврата = ИмяФайлаСПутем;
	КонецЕсли;

	Возврат ПутьДляВозврата;
КонецФункции

// Получить полный путь к файлу
Функция ПолучитьПолныйПутьКФайлуВРабочемКаталоге(ДанныеФайла) Экспорт
	Возврат ДанныеФайла.ПолноеИмяФайлаВРабочемКаталоге;
КонецФункции

// Разыменовать lnk файл
Функция РазыменоватьLnkФайл(ВыбранныйФайл) Экспорт
#Если Не МобильныйКлиент Тогда
	Если ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		
		Если НЕ СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда

			Попытка			
				ShellApp = Новый COMОбъект("shell.application");
				FolderObj = ShellApp.NameSpace(ВыбранныйФайл.Путь);										// полный (только) путь на lnk-файл
				FolderObjItem = FolderObj.items().item(ВыбранныйФайл.Имя); 	// только имя lnk-файла
				Link = FolderObjItem.GetLink();
				Возврат Новый Файл(Link.path);
			
			Исключение 
				Возврат ВыбранныйФайл; // мог быть битый файл lnk
			КонецПопытки;	
			
		КонецЕсли;
		
	КонецЕсли;
#КонецЕсли
	Возврат ВыбранныйФайл;
КонецФункции

// Обход Файлов рекурсивный - для определения размера файлов
Процедура ОбходФайловДляПроверкиПредельногоРазмера(
	Путь, 
	МассивФайлов, 
	МассивСлишкомБольшихФайлов, 
	Рекурсивно, 
	КоличествоСуммарное,
	Знач ПсевдоФайловаяСистема) Экспорт
	
	МаксРазмерФайла = ФайловыеФункцииКлиентПовтИсп.ПолучитьОбщиеНастройкиРаботыСФайлами().МаксимальныйРазмерФайла;
	
	Для Каждого ВыбранныйФайл Из МассивФайлов Цикл
		Попытка
			
			Если ВыбранныйФайл.Существует() Тогда
				
				Если ВыбранныйФайл.Расширение = ".lnk" Тогда
					ВыбранныйФайл = РазыменоватьLnkФайл(ВыбранныйФайл);
				КонецЕсли;
									
				Если ВыбранныйФайл.ЭтоКаталог() Тогда
					
					Если Рекурсивно Тогда
						НовыйПуть = Строка(ВыбранныйФайл.Путь);
						НовыйПуть = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
							НовыйПуть, ОбщегоНазначенияКлиент.ТипПлатформыКлиента());
						
						НовыйПуть = НовыйПуть + Строка(ВыбранныйФайл.Имя);
						МассивФайловВКаталоге = ФайловыеФункцииКлиентСервер.НайтиФайлыПсевдо(ПсевдоФайловаяСистема, НовыйПуть);
						
						// Рекурсия
						Если МассивФайловВКаталоге.Количество() <> 0 Тогда
							ОбходФайловДляПроверкиПредельногоРазмера(НовыйПуть, МассивФайловВКаталоге, МассивСлишкомБольшихФайлов, Рекурсивно, КоличествоСуммарное, ПсевдоФайловаяСистема);
						КонецЕсли;
					КонецЕсли;
				
					Продолжить;
				КонецЕсли;
				
				КоличествоСуммарное = КоличествоСуммарное + 1;
				
				// Размер файла слишком большой
				Если ВыбранныйФайл.Размер() > МаксРазмерФайла Тогда
					МассивСлишкомБольшихФайлов.Добавить(ВыбранныйФайл.ПолноеИмя);
					Продолжить;
				КонецЕсли;
			
			КонецЕсли;
			
		Исключение
			Инфо = ИнформацияОбОшибке();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						  НСтр("ru = 'Описание=""%1""'"), Инфо.Описание ));
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

// Функция получает путь к каталогу вида "C:\Documents and Settings\ИМЯ ПОЛЬЗОВАТЕЛЯ\Application Data\1C\ФайлыА8\"
Функция ПолучитьПутьККаталогуДанныхПользователя() Экспорт
	
	ИмяКаталога = "";
	
#Если Не ВебКлиент И Не МобильныйКлиент Тогда

	Если Не ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		ИмяКаталога = Вычислить("РабочийКаталогДанныхПользователя()");
	Иначе
	
		Если НЕ СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда
			
			Оболочка = Новый COMОбъект("WScript.Shell");
			Путь = Оболочка.ExpandEnvironmentStrings("%APPDATA%");
			Путь = Путь + "\1C\Файлы\";
			Путь = Путь + СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИмяКонфигурации + "\";
			
			ИмяКаталога = Путь + ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ТекущийПользователь
				+ " " + РаботаСФайламиВызовСервера.ПараметрыСеансаИдентификаторТекущегоПользователя() + "\";
			ИмяКаталога = СтрЗаменить(ИмяКаталога, "<", " ");
			ИмяКаталога = СтрЗаменить(ИмяКаталога, ">", " ");
			ИмяКаталога = СокрЛП(ИмяКаталога);
			
		КонецЕсли;	
		
	КонецЕсли;	
	
#ИначеЕсли ВебКлиент Тогда
	
	РасширениеПодключено = ФайловыеФункцииСлужебныйКлиент.РасширениеРаботыСФайламиПодключено();
	
	Если РасширениеПодключено Тогда
		
		ИмяКаталога = РабочийКаталогДанныхПользователя();
		
	КонецЕсли;
	
#ИначеЕсли МобильныйКлиент Тогда
	
	Возврат РабочийКаталогДанныхПользователя();
	
#КонецЕсли

	Возврат ИмяКаталога;
	
КонецФункции

// Возвращает имя с расширением- если расширение пусто - только имя
Функция ПолучитьИмяСРасширением(ПолноеНаименование, Расширение) Экспорт
	ИмяСРасширением = ПолноеНаименование;
	
	Если Расширение <> "" Тогда
		ИмяСРасширением = ИмяСРасширением + "." + Расширение;
	КонецЕсли;
	
	Возврат ИмяСРасширением;
КонецФункции

// Извлекает текст из файла на диске на клиенте и помещает результат на сервер
Процедура ИзвлечьТекстВерсии(ВерсияСсылка, АдресФайла, Расширение, УникальныйИдентификатор,
	Кодировка = Неопределено) Экспорт
	
#Если НЕ ВебКлиент Тогда
	
	ИмяФайлаСПутем = ПолучитьИмяВременногоФайла(Расширение);
	
	Если Не ПолучитьФайл(АдресФайла, ИмяФайлаСПутем, Ложь) Тогда
		Возврат;
	КонецЕсли;	
		
	// Для варианта с хранением файлов на диске (на сервере) удаляем Файл из временного хранилища после получения
	Если ЭтоАдресВременногоХранилища(АдресФайла) Тогда
		УдалитьИзВременногоХранилища(АдресФайла);
	КонецЕсли;
	
	РезультатИзвлечения = "НеИзвлечен";
	АдресВременногоХранилищаТекста = "";
	ИмяВременногоФайла = "";
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ИмяФайлаСПутем", ИмяФайлаСПутем);
	ПараметрыОповещения.Вставить("ВерсияСсылка", ВерсияСсылка);
	ПараметрыОповещения.Вставить("РезультатИзвлечения", "НеИзвлечен"); 
	ПараметрыОповещения.Вставить("Расширение", Расширение); 
	
	Текст = "";
	Если ИмяФайлаСПутем <> "" Тогда
		
		Отказ = Ложь;
		Текст = ФайловыеФункцииСлужебныйКлиентСервер.ИзвлечьТекст(ИмяФайлаСПутем, Отказ, Кодировка);
		
		Если Отказ = Ложь Тогда
			ПараметрыОповещения.РезультатИзвлечения = "Извлечен";
			
			Если Не ПустаяСтрока(Текст) Тогда
				ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
				ТекстовыйФайл = Новый ЗаписьТекста(ИмяВременногоФайла, КодировкаТекста.UTF8);
				ТекстовыйФайл.Записать(Текст);
				ТекстовыйФайл.Закрыть();
				
				ОписаниеОповещения = Новый ОписаниеОповещения(
					"ИзвлечьТекстВерсииПродолжение", ЭтотОбъект, ПараметрыОповещения);
				
				НачатьПомещениеФайла(ОписаниеОповещения, АдресВременногоХранилищаТекста,
					ИмяВременногоФайла, Ложь, УникальныйИдентификатор);
					
				Возврат;
				
			КонецЕсли;
		Иначе	
			// Ничего не пишем - это нормальная ситуация - когда Текст некому извлечь
			ПараметрыОповещения.РезультатИзвлечения = "ИзвлечьНеУдалось";
		КонецЕсли;
		
	КонецЕсли;
	
	ИзвлечьТекстВерсииПродолжение(Истина, АдресВременногоХранилищаТекста, ИмяВременногоФайла, ПараметрыОповещения);
	
#КонецЕсли	
КонецПроцедуры

Процедура ИзвлечьТекстВерсииПродолжение(
	Результат, АдресВременногоХранилищаТекста, ИмяВременногоФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		Если ЗначениеЗаполнено(ИмяВременногоФайла) Тогда
			УдалитьФайлы(ИмяВременногоФайла);
		КонецЕсли;	
	КонецЕсли;
	
	ИмяФайлаСПутем = ДополнительныеПараметры.ИмяФайлаСПутем;
	РезультатИзвлечения = ДополнительныеПараметры.РезультатИзвлечения;
	ВерсияСсылка = ДополнительныеПараметры.ВерсияСсылка;
	Расширение = ДополнительныеПараметры.Расширение;
	
	УдалитьФайлы(ИмяФайлаСПутем);

	РаботаСФайламиВызовСервера.ЗаписатьРезультатИзвлеченияТекста(ВерсияСсылка, 
		РезультатИзвлечения, АдресВременногоХранилищаТекста, Расширение);
		
	Если Не ПустаяСтрока(АдресВременногоХранилищаТекста) Тогда
		УдалитьИзВременногоХранилища(АдресВременногоХранилищаТекста);
	КонецЕсли;
	
КонецПроцедуры

// Сохраняет на диск подписи - все или выбранные
//
// Параметры
//  ФайлСсылка  - СправочникСсылка - объект, в табличной части которого содержатся подписи
//  ПолноеИмяФайла - Строка - полное имя с путем, под которым сохранен файл
//  УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор формы
//  МассивСтруктурПодписей - Массив  - массив структур подписей. Если Неопределено - сохраняем все подписи
//
Процедура СохранитьПодписи(ФайлСсылка, ПолноеИмяФайла, УникальныйИдентификатор, МассивСтруктурПодписей) Экспорт
	
	ОсновнойФайл = Новый Файл(ПолноеИмяФайла);
	Путь = ОсновнойФайл.Путь;
	
	МассивИмен = Новый Массив;
	МассивИмен.Добавить(ОсновнойФайл.Имя);
	
	РасширениеДляФайловПодписи = ЭлектроннаяПодписьКлиент.ПерсональныеНастройки().РасширениеДляФайловПодписи;
	
	Для Каждого СтруктураПодписи Из МассивСтруктурПодписей Цикл
		ИмяФайлаПодписи = СтруктураПодписи.ИмяФайлаПодписи;
		
		Если ПустаяСтрока(ИмяФайлаПодписи) Тогда 
			ИмяФайлаПодписи = Строка(ФайлСсылка) + "-" + Строка(СтруктураПодписи.КомуВыданСертификат) + "." + РасширениеДляФайловПодписи;
		КонецЕсли;
		
		СкорректироватьИмяФайла(ИмяФайлаПодписи);
		
		ПолныйПутьПодписи = Путь;
		ПолныйПутьПодписи = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
			ПолныйПутьПодписи, ОбщегоНазначенияКлиент.ТипПлатформыКлиента());
		ПолныйПутьПодписи = ПолныйПутьПодписи + ИмяФайлаПодписи;
		
		ФайлПоИмени = Новый Файл(ПолныйПутьПодписи);
		ФайлСуществует = ФайлПоИмени.Существует();
		
		Счетчик = 0;
		ИмяФайлаПодписиБезПостфикса = ФайлПоИмени.ИмяБезРасширения;
		Пока ФайлСуществует Цикл
			Счетчик = Счетчик + 1;
			ИмяФайлаПодписи = ИмяФайлаПодписиБезПостфикса + " (" + Строка(Счетчик) + ")" + "." + РасширениеДляФайловПодписи;
			СкорректироватьИмяФайла(ИмяФайлаПодписи);
			
			ПолныйПутьПодписи = Путь;
			ПолныйПутьПодписи = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
				ПолныйПутьПодписи, ОбщегоНазначенияКлиент.ТипПлатформыКлиента());
			ПолныйПутьПодписи = ПолныйПутьПодписи + ИмяФайлаПодписи;
			
			ФайлДляПроверки = Новый Файл(ПолныйПутьПодписи);
			ФайлСуществует = ФайлДляПроверки.Существует();
		КонецЦикла;	
		
		Файл = Новый Файл(ПолныйПутьПодписи);
		МассивИмен.Добавить(Файл.Имя);
		ПередаваемыеФайлы = Новый Массив;
		Описание = Новый ОписаниеПередаваемогоФайла(ПолныйПутьПодписи, СтруктураПодписи.АдресПодписи);
		ПередаваемыеФайлы.Добавить(Описание);
		
		ПутьКФайлу = Файл.Путь;
		ПутьКФайлу = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
			ПутьКФайлу, ОбщегоНазначенияКлиент.ТипПлатформыКлиента());
		
		// Сохраним Файл из БД на диск
		ПолучитьФайлы(ПередаваемыеФайлы,, ПутьКФайлу, Ложь);
		
		УдалитьИзВременногоХранилища(СтруктураПодписи.АдресПодписи);
	КонецЦикла;
	
	Если МассивСтруктурПодписей.Количество() <> 0 Тогда
		Текст = НСтр("ru = 'Каталог:'") + Символы.ПС;
		Текст = Текст + Путь;
		Текст = Текст + Символы.ПС + Символы.ПС;
		Текст = Текст + НСтр("ru = 'Файлы:'") + Символы.ПС;
		
		Для Каждого ИмяФайла Из МассивИмен Цикл
			Текст = Текст + ИмяФайла + Символы.ПС;
		КонецЦикла;
		
		ПараметрыФормы = Новый Структура("Текст", Текст);
		ОткрытьФорму("ОбщаяФорма.ОтчетОСохраненииФайловЭлектронныхПодписей", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

// Сохраняет подпись на диск
Процедура СохранитьПодпись(АдресПодписи) Экспорт
	
	Если НЕ ФайловыеФункцииСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда
		Возврат;
	КонецЕсли;
	
	РасширениеДляФайловПодписи = ЭлектроннаяПодписьКлиент.ПерсональныеНастройки().РасширениеДляФайловПодписи;
		
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	
	Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Все файлы (*.%1)|*.%1'"), РасширениеДляФайловПодписи);
	
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файл для сохранения подписи'");
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		
		ПолныйПутьПодписи = ДиалогОткрытияФайла.ПолноеИмяФайла;
		
		Файл = Новый Файл(ПолныйПутьПодписи);
		ПередаваемыеФайлы = Новый Массив;
		Описание = Новый ОписаниеПередаваемогоФайла(ПолныйПутьПодписи, АдресПодписи);
		ПередаваемыеФайлы.Добавить(Описание);
		
		ПутьКФайлу = Файл.Путь;
		ПутьКФайлу = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
			ПутьКФайлу, ОбщегоНазначенияКлиент.ТипПлатформыКлиента());
		
		// Сохраним Файл из БД на диск
		ПолучитьФайлы(ПередаваемыеФайлы,, ПутьКФайлу, Ложь);
			
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Подпись сохранена в файл ""%1""'"),
			ДиалогОткрытияФайла.ПолноеИмяФайла);
		Состояние(Текст);
		
	КонецЕсли;
	
КонецПроцедуры

// Проинициализировать параметр сеанса ПутьКРабочемуКаталогуПользователя, проверив корректность пути, и откорректировав если нужно
// 
Процедура ПроинициализироватьПутьКРабочемуКаталогу() Экспорт
	
	ИмяКаталога = ФайловыеФункцииКлиентПовтИсп.ПолучитьРабочийКаталогПользователя();
	
	// уже проинициализировано
	Если ИмяКаталога <> Неопределено И НЕ ПустаяСтрока(ИмяКаталога) 
		И ПараметрыПриложения["СтандартныеПодсистемы.ПроверкаДоступаКРабочемуКаталогуВыполнена"] = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяКаталога = Неопределено Тогда
		ИмяКаталога = ПолучитьПутьККаталогуДанныхПользователя();
		Если Не ПустаяСтрока(ИмяКаталога) Тогда
			СохранитьПутьККаталогуВНастройках(ИмяКаталога);
		Иначе
			ПараметрыПриложения["СтандартныеПодсистемы.ПроверкаДоступаКРабочемуКаталогуВыполнена"] = Истина;
			Возврат; //  веб клиент без расширения работы с файлами
		КонецЕсли;
	КонецЕсли;
	
#Если Не ВебКлиент Тогда
	// Создать каталог для файлов
	Попытка
		СоздатьКаталог(ИмяКаталога);
		ИмяКаталогаТестовое = ИмяКаталога + "ПроверкаДоступа\";
		СоздатьКаталог(ИмяКаталогаТестовое);
		УдалитьФайлы(ИмяКаталогаТестовое);
	Исключение
		// Нет прав на создание каталога, или такой путь отсутствует - сбрасываем в настройки по умолчанию
		ИмяКаталога = ПолучитьПутьККаталогуДанныхПользователя();
		СохранитьПутьККаталогуВНастройках(ИмяКаталога);
	КонецПопытки;
#КонецЕсли
	
	ПараметрыПриложения["СтандартныеПодсистемы.ПроверкаДоступаКРабочемуКаталогуВыполнена"] = Истина;
	
КонецПроцедуры

// открыть Windows проводник, выбрав в нем указанный файл
Функция ОткрытьПроводникСФайлом(Знач ПолноеИмяФайла) Экспорт
	#Если НЕ ВебКлиент Тогда
		Если ПолноеИмяФайла <> "" Тогда
			ФайлНаДиске = Новый Файл(ПолноеИмяФайла);
			Если ФайлНаДиске.Существует() Тогда
				
				ПолноеИмяФайла = СтрЗаменить(ПолноеИмяФайла, "/", "\"); 
				Если Лев(ПолноеИмяФайла, 0) <> """" Тогда
					ПолноеИмяФайла = """" + ПолноеИмяФайла + """";
				КонецЕсли;
				
				Парам = "explorer.exe /select, " + ПолноеИмяФайла;
				ЗапуститьПриложение(Парам);
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
	#КонецЕсли	
	
	Возврат Ложь;
КонецФункции

// Показывает пользователю диалог выбора файлов и возвращает
// массив - выбранные для импорта файлы
//
Функция ПолучитьСписокИмпортируемыхФайлов() Экспорт
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Истина;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файлы'");
	
	МассивИменФайлов = Новый Массив;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		
		МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
		
		Для Каждого ИмяФайла Из МассивФайлов Цикл
			МассивИменФайлов.Добавить(ИмяФайла);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат МассивИменФайлов;
	
КонецФункции

// Функция возвращает каталог "Мои Документы" + имя текущего пользователя или ранее использованную папку для выгрузки
//
Функция КаталогВыгрузки() Экспорт
	
	Путь = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("ИмяПапкиВыгрузки", "ИмяПапкиВыгрузки");
	
	Если Путь = Неопределено Тогда
		
		РасширениеПодключено = ФайловыеФункцииСлужебныйКлиент.РасширениеРаботыСФайламиПодключено();
		Если РасширениеПодключено Тогда
			Путь = КаталогДокументов();
			ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("ИмяПапкиВыгрузки", "ИмяПапкиВыгрузки", Путь);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Путь;
	
КонецФункции

// Очищает основной рабочий каталог при завершении работы
Процедура ОчиститьОсновнойРабочийКаталогПриЗавершенииРаботы() Экспорт
	
	ПроинициализироватьПутьКРабочемуКаталогу();
	ИмяКаталога = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;
	
	Состояние(НСтр("ru = 'Выполняется очистка основного рабочего каталога... 
					|Пожалуйста, подождите.'"));
	
	МассивФайлов = НайтиФайлы(ИмяКаталога, "*.*");
	
	РазмерФайловВРабочемКаталоге = 0;
	КоличествоСуммарное = 0;
	ВсеПутиФайлов = Новый Массив;
	ОбходФайловРазмер(ИмяКаталога, МассивФайлов, РазмерФайловВРабочемКаталоге, КоличествоСуммарное, ВсеПутиФайлов);
	
	// ОчищатьВсе = Истина.
	НеВыдаватьСообщений = Истина;
	РаботаСФайламиКлиент.ОчиститьРабочийКаталог(
		Неопределено, РазмерФайловВРабочемКаталоге, 0, Истина, НеВыдаватьСообщений, ВсеПутиФайлов);
	
КонецПроцедуры	

// Проверяет свойства файла в рабочем каталоге и в хранилище файлов,
// если требуется уточняет у пользователя и возвращает действие.
//
// Параметры:
//  ОбработчикРезультата - ОписаниеОповещения, Неопределено - Описание процедуры, принимающей результат работы метода.
//  ИмяФайлаСПутем - Строка - полное имя файла с путем в рабочем каталоге.
// 
//  ДанныеФайла    - Структура со свойствами:
//                   Размер                       - Число.
//                   ДатаМодификацииУниверсальная - Дата.
//                   ВРабочемКаталогеНаЧтение     - Булево.
//
// Возвращаемое значение:
//  Строка - возможные строки:
//  "ОткрытьСуществующий", "ВзятьИзХранилищаИОткрыть", "Отменить".
// 
Процедура ДействиеПриОткрытииФайлаВРабочемКаталоге(ОбработчикРезультата, ИмяФайлаСПутем, ДанныеФайла) Экспорт
	
	Если ДанныеФайла.Свойство("ПутьОбновленияИзФайлаНаДиске") Тогда
		ВернутьРезультат(ОбработчикРезультата, "ВзятьИзХранилищаИОткрыть");
		Возврат;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("ДействиеНадФайлом", "ОткрытиеВРабочемКаталоге");
	Параметры.Вставить("ПолноеИмяФайлаВРабочемКаталоге", ИмяФайлаСПутем);
	
	Файл = Новый Файл(Параметры.ПолноеИмяФайлаВРабочемКаталоге);
	
	Параметры.Вставить("ДатаИзмененияУниверсальнаяВХранилищеФайлов",
		ДанныеФайла.ДатаМодификацииУниверсальная);
	
	Параметры.Вставить("ДатаИзмененияУниверсальнаяВРабочемКаталоге",
		Файл.ПолучитьУниверсальноеВремяИзменения());
	
	Параметры.Вставить("ДатаИзмененияВРабочемКаталоге",
		МестноеВремя(Параметры.ДатаИзмененияУниверсальнаяВРабочемКаталоге));
	
	Параметры.Вставить("ДатаИзмененияВХранилищеФайлов",
		МестноеВремя(Параметры.ДатаИзмененияУниверсальнаяВХранилищеФайлов));
	
	Параметры.Вставить("РазмерВРабочемКаталоге", Файл.Размер());
	Параметры.Вставить("РазмерВХранилищеФайлов", ДанныеФайла.Размер);
	
	РазницаДат = Параметры.ДатаИзмененияУниверсальнаяВРабочемКаталоге
	           - Параметры.ДатаИзмененияУниверсальнаяВХранилищеФайлов;
	
	Если РазницаДат < 0 Тогда
		РазницаДат = -РазницаДат;
	КонецЕсли;
	
	Если РазницаДат <= 1 Тогда // 1 секунда - допустимая разница (на Win95 может быть такое)
		
		Если Параметры.РазмерВХранилищеФайлов <> 0
		   И Параметры.РазмерВХранилищеФайлов <> Параметры.РазмерВРабочемКаталоге Тогда
			// Дата одинаковая, но размер отличается - редкий, но возможный случай.
			
			Параметры.Вставить("Заголовок",
				НСтр("ru = 'Размер файла отличается'"));
			
			Параметры.Вставить("Сообщение",
				НСтр("ru = 'Размер файла в рабочем каталоге и в хранилище файлов отличается.
				           |
				           |Взять файл из хранилища файлов и заменить им существующий или
				           |открыть существующий без обновления?'"));
		Иначе
			// Все совпадает - и дата, и размер.
			ВернутьРезультат(ОбработчикРезультата, "ОткрытьСуществующий");
			Возврат;
		КонецЕсли;
		
	ИначеЕсли Параметры.ДатаИзмененияУниверсальнаяВРабочемКаталоге
	        < Параметры.ДатаИзмененияУниверсальнаяВХранилищеФайлов Тогда
		// В хранилище файлов более новый файл.
		
		Если ДанныеФайла.ВРабочемКаталогеНаЧтение = Ложь Тогда
			// Файл в рабочем каталоге для редактирования.
			
			// Обновление из хранилища файлов без вопросов.
			ВернутьРезультат(ОбработчикРезультата, "ВзятьИзХранилищаИОткрыть");
			Возврат;
			
		Иначе
			// Файл в рабочем каталоге для чтения.
			
			// Обновление из хранилища файлов без вопросов.
			ВернутьРезультат(ОбработчикРезультата, "ВзятьИзХранилищаИОткрыть");
			Возврат;
		КонецЕсли;
	
	ИначеЕсли Параметры.ДатаИзмененияУниверсальнаяВРабочемКаталоге
	        > Параметры.ДатаИзмененияУниверсальнаяВХранилищеФайлов Тогда
		// В рабочем каталоге более новый файл.
		
		Если ДанныеФайла.ВРабочемКаталогеНаЧтение = Ложь
		   И ДанныеФайла.РедактируетТекущийПользователь Тогда
			
			// Файл в рабочем каталоге для редактирования и занят текущим пользователем.
			ВернутьРезультат(ОбработчикРезультата, "ОткрытьСуществующий");
			Возврат;
		Иначе
			// Файл в рабочем каталоге для чтения.
		
			Параметры.Вставить("Заголовок", НСтр("ru = 'В рабочем каталоге новый файл'"));
			
			Параметры.Вставить(
				"Сообщение",
				НСтр("ru = 'Файл в рабочем каталоге имеет более позднюю дату изменения (новее),
				           |чем в хранилище файлов. Возможно, он был изменен.
				           |
				           |Открыть существующий файл или заменить его на файл
				           |из хранилища файлов c потерей изменений и открыть?'"));
		КонецЕсли;
	КонецЕсли;
	
	//ВыборДействияПриОбнаруженииОтличийФайла
	ОткрытьФорму("ОбщаяФорма.ВыборДействияПриОбнаруженииОтличийФайла", Параметры, , , , , ОбработчикРезультата, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

// Возвращает результат прямого вызова, когда не потребовалось открывать диалог.
Процедура ВернутьРезультат(ОбработчикРезультата, Результат) Экспорт
	Если ТипЗнч(ОбработчикРезультата) = Тип("ОписаниеОповещения") Тогда
		ВыполнитьОбработкуОповещения(ОбработчикРезультата, Результат);
	КонецЕсли;
КонецПроцедуры

// Возвращает текст предупреждения о том, что файл занят с другого компьютера.
//
// Параметры:
//  ПолноеНаименование - Строка, имя файла ("Приказ")
//  Расширение
//  ИмяДругогоКомпьютера
//
Функция ПолучитьТекстПредупрежденияЧтоФайлЗанятСДругогоКомпьютера(
		ПолноеНаименование, Расширение, ИмяДругогоКомпьютера) Экспорт
	
	Если ЗначениеЗаполнено(ИмяДругогоКомпьютера) Тогда
	
		Возврат СтрШаблон(
			НСтр("ru = 'Файл ""%1.%2"" занят вами с другого компьютера (%3).
			|Выполните ""Закончить редактирование"" с компьютера %4
			|или отмените редактирование (сделанные вами изменения будут потеряны).'"), 
			ПолноеНаименование, Расширение, ИмяДругогоКомпьютера, ИмяДругогоКомпьютера);
		
	Иначе
		
		Возврат СтрШаблон(
			НСтр("ru = 'Файл ""%1.%2"" занят вами с другого компьютера.
			|Выполните ""Закончить редактирование"" с того же компьютера, где файл был занят
			|или отмените редактирование (сделанные вами изменения будут потеряны).'"), 
			ПолноеНаименование, Расширение);
		
	КонецЕсли;	
	
КонецФункции	

// Выбирает из файла на диске картинку и помещает во временное хранилище. Вернет Ложь, если пользователь нажал Отмена
Процедура ВыбратьКартинкуИПоместитьВХранилище(ОбработчикРезультата, УникальныйИдентификатор, ПоказатьПредупреждение = Истина, БольшойРазмер = Ложь) Экспорт
	
	Параметры = Новый Структура(
		"ОбработчикРезультата, УникальныйИдентификатор, АдресВременногоХранилищаФайла", 
		ОбработчикРезультата, УникальныйИдентификатор, "");
		
	Если ПоказатьПредупреждение Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ВыбратьКартинкуИПоместитьВХранилищеПослеПредупреждения",
			ЭтотОбъект,
			Параметры);
			
		Если БольшойРазмер Тогда 
			ТекстПредупреждения = НСтр("ru='Выберите файл фотографии. 
				|Для быстрой работы программы размер фотографии должен быть приблизительно 110 на 130 пикселей,
				|размером не более 200 Кб.'")
		Иначе 
			ТекстПредупреждения = НСтр("ru='Выберите файл фотографии. 
				|Для быстрой работы программы размер фотографии должен быть приблизительно 60 на 80 пикселей,
				|размером не более 200 Кб.'")
		КонецЕсли;
		ПоказатьПредупреждение(ОписаниеОповещения, ТекстПредупреждения);
	Иначе 
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ВыбратьКартинкуИПоместитьВХранилищеПродолжение",
			ЭтотОбъект,
			Параметры);
		ВыполнитьОбработкуОповещения(ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

// продолжение
Процедура ВыбратьКартинкуИПоместитьВХранилищеПослеПредупреждения(Параметры) Экспорт  
	
	Фильтр = НСтр("ru = 'Все картинки (*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf)|*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf'")
		+ НСтр("ru = '|Все файлы(*.*)|*.*'")
		+ НСтр("ru = '|Формат bmp(*.bmp*;*.dib;*.rle)|*.bmp;*.dib;*.rle'")
		+ НСтр("ru = '|Формат GIF(*.gif*)|*.gif'")
		+ НСтр("ru = '|Формат JPEG(*.jpeg;*.jpg)|*.jpeg;*.jpg'")
		+ НСтр("ru = '|Формат PNG(*.png*)|*.png'")
		+ НСтр("ru = '|Формат TIFF(*.tif)|*.tif'")
		+ НСтр("ru = '|Формат icon(*.ico)|*.ico'")
		+ НСтр("ru = '|Формат метафайл(*.wmf;*.emf)|*.wmf;*.emf'");
								
	АдресВременногоХранилищаФайла = "";
								
	РасширениеПодключено = ФайловыеФункцииСлужебныйКлиент.РасширениеРаботыСФайламиПодключено();
	Если РасширениеПодключено Тогда
		
		ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ВыборФайла.МножественныйВыбор = Ложь;
		ВыборФайла.Заголовок = НСтр("ru = 'Выбор файла изображения'");
		ВыборФайла.Фильтр = Фильтр;
		
		Результат = ВыборФайла.Выбрать();
		
		Если Не Результат Тогда
			ВыполнитьОбработкуОповещения(Параметры.ОбработчикРезультата, Ложь);
			Возврат;
		КонецЕсли;
		
		ПутьФайла = ВыборФайла.ПолноеИмяФайла;
		
		// Поместим Файл в ВременноеХранилище
		
		ПомещаемыеФайлы = Новый Массив;
		Описание = Новый ОписаниеПередаваемогоФайла(ПутьФайла, "");
		ПомещаемыеФайлы.Добавить(Описание);
		
		ПомещенныеФайлы = Новый Массив;
		
		Если Не ПоместитьФайлы(ПомещаемыеФайлы, ПомещенныеФайлы, , Ложь, Параметры.УникальныйИдентификатор) Тогда
			ВызватьИсключение
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при помещении файла в хранилище: %1'"), ПутьФайла);
		КонецЕсли;
		
		Если ПомещенныеФайлы.Количество() = 1 Тогда
			АдресВременногоХранилищаФайла = ПомещенныеФайлы[0].Хранение;
			Параметры.АдресВременногоХранилищаФайла = АдресВременногоХранилищаФайла;
		КонецЕсли;
		
	Иначе
		
		// Поместим Файл в ВременноеХранилище
		ИмяФайла = "";
		Обработчик = Новый ОписаниеОповещения("ОбработатьРезультатПомещенияФайла", ЭтотОбъект, Параметры);
		НачатьПомещениеФайла(Обработчик, , ИмяФайла, Истина, Параметры.УникальныйИдентификатор);
		Возврат;
		
	КонецЕсли;	
	
	Параметры.ОбработчикРезультата.ДополнительныеПараметры.АдресВременногоХранилищаФайла
		= АдресВременногоХранилищаФайла; 
	ВыполнитьОбработкуОповещения(Параметры.ОбработчикРезультата, Истина);
	
КонецПроцедуры

Процедура ВыбратьКартинкуИПоместитьВХранилищеПродолжение(Результат, Параметры) Экспорт  
	
	Фильтр = НСтр("ru = 'Все картинки (*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf)|*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf'")
		+ НСтр("ru = '|Все файлы(*.*)|*.*'")
		+ НСтр("ru = '|Формат bmp(*.bmp*;*.dib;*.rle)|*.bmp;*.dib;*.rle'")
		+ НСтр("ru = '|Формат GIF(*.gif*)|*.gif'")
		+ НСтр("ru = '|Формат JPEG(*.jpeg;*.jpg)|*.jpeg;*.jpg'")
		+ НСтр("ru = '|Формат PNG(*.png*)|*.png'")
		+ НСтр("ru = '|Формат TIFF(*.tif)|*.tif'")
		+ НСтр("ru = '|Формат icon(*.ico)|*.ico'")
		+ НСтр("ru = '|Формат метафайл(*.wmf;*.emf)|*.wmf;*.emf'");
								
	АдресВременногоХранилищаФайла = "";
								
	РасширениеПодключено = ФайловыеФункцииСлужебныйКлиент.РасширениеРаботыСФайламиПодключено();
	Если РасширениеПодключено Тогда
		
		ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ВыборФайла.МножественныйВыбор = Ложь;
		ВыборФайла.Заголовок = НСтр("ru = 'Выбор файла изображения'");
		ВыборФайла.Фильтр = Фильтр;
		
		Результат = ВыборФайла.Выбрать();
		
		Если Не Результат Тогда
			ВыполнитьОбработкуОповещения(Параметры.ОбработчикРезультата, Ложь);
			Возврат;
		КонецЕсли;
		
		ПутьФайла = ВыборФайла.ПолноеИмяФайла;
		
		// Поместим Файл в ВременноеХранилище
		
		ПомещаемыеФайлы = Новый Массив;
		Описание = Новый ОписаниеПередаваемогоФайла(ПутьФайла, "");
		ПомещаемыеФайлы.Добавить(Описание);
		
		ПомещенныеФайлы = Новый Массив;
		
		Если Не ПоместитьФайлы(ПомещаемыеФайлы, ПомещенныеФайлы, , Ложь, Параметры.УникальныйИдентификатор) Тогда
			ВызватьИсключение
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при помещении файла в хранилище: %1'"), ПутьФайла);
		КонецЕсли;
		
		Если ПомещенныеФайлы.Количество() = 1 Тогда
			АдресВременногоХранилищаФайла = ПомещенныеФайлы[0].Хранение;
			Параметры.АдресВременногоХранилищаФайла = АдресВременногоХранилищаФайла;
		КонецЕсли;
		
	Иначе
		
		// Поместим Файл в ВременноеХранилище
		ИмяФайла = "";
		Обработчик = Новый ОписаниеОповещения("ОбработатьРезультатПомещенияФайла", ЭтотОбъект, Параметры);
		НачатьПомещениеФайла(Обработчик, , ИмяФайла, Истина, Параметры.УникальныйИдентификатор);
		
	КонецЕсли;	
	
	Параметры.ОбработчикРезультата.ДополнительныеПараметры.АдресВременногоХранилищаФайла
		= АдресВременногоХранилищаФайла; 
	ВыполнитьОбработкуОповещения(Параметры.ОбработчикРезультата, Истина);
	
КонецПроцедуры

// Обработчик результата работы процедуры ПоказатьПомещениеФайла.
Процедура ОбработатьРезультатПомещенияФайла(ВыборВыполнен, Адрес, ВыбранноеИмяФайла, 
	ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ДополнительныеПараметры.ОбработчикРезультата) = Тип("ОписаниеОповещения") Тогда
		
		Если ВыборВыполнен = Истина Тогда
			ДополнительныеПараметры.АдресВременногоХранилищаФайла = Адрес;
			ДополнительныеПараметры.ОбработчикРезультата.ДополнительныеПараметры.АдресВременногоХранилищаФайла
				= Адрес;
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОбработчикРезультата, Истина);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОбработчикРезультата, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Рекурсивный обход файлов в рабочем каталоге и сбор информации о них
Процедура ОбходФайловТаблица(Путь, МассивФайлов, ТаблицаФайлов)
	#Если Не ВебКлиент Тогда
		Перем Версия;
		Перем ДатаПомещения;	
		
		ИмяКаталога = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;
				
		Для Каждого ВыбранныйФайл Из МассивФайлов Цикл
			
			Если ВыбранныйФайл.ЭтоКаталог() Тогда
				НовыйПуть = Строка(Путь);
				НовыйПуть = НовыйПуть + ПолучитьРазделительПути();
				НовыйПуть = НовыйПуть + Строка(ВыбранныйФайл.Имя);
				МассивФайловВКаталоге = НайтиФайлы(НовыйПуть, "*.*");
				
				Если МассивФайловВКаталоге.Количество() <> 0 Тогда
					ОбходФайловТаблица(НовыйПуть, МассивФайловВКаталоге, ТаблицаФайлов);
				КонецЕсли;
			
				Продолжить;
			КонецЕсли;
			
			// временные файлы Word не удаляем из рабочего каталога
			Если Лев(ВыбранныйФайл.Имя, 1) = "~" И ВыбранныйФайл.ПолучитьНевидимость() = Истина Тогда
				Продолжить;
			КонецЕсли;
			
			ДатаПомещения = Дата('00010101');
			Версия = Неопределено;
			ОтносительныйПуть = Сред(ВыбранныйФайл.ПолноеИмя, СтрДлина(ИмяКаталога) + 1);
			
			Запись = Новый Структура;
			Запись.Вставить("Путь", ОтносительныйПуть);
			Запись.Вставить("Размер", ВыбранныйФайл.Размер());
			Запись.Вставить("ТолькоЧтениеФайлаНаДиске", ВыбранныйФайл.ПолучитьТолькоЧтение());
			Запись.Вставить("ОтносительныйПуть", ОтносительныйПуть);
			
			// эти 2 вещи заполним потом на сервере
			Запись.Вставить("Версия", Версия);
			Запись.Вставить("ДатаПомещенияВРабочийКаталог", ДатаПомещения);
			
			ТаблицаФайлов.Добавить(Запись);
				
		КонецЦикла;
	#КонецЕсли
	
КонецПроцедуры

// Процедура предназначена для коррекции имени файла  - замена некорректных символов на пробел
//
// Параметры
//  СтрИмяФайла  - Строка - Имя файла
Процедура СкорректироватьИмяФайла(СтрИмяФайла)
	
	// Перечень запрещенных символов взят отсюда: http://support.microsoft.com/kb/100108/ru.
	// При этом были объединены запрещенные символы для файловых систем FAT и NTFS.
	СтрИсключения = """ / \ [ ] : ; | = , ? * < >";
	СтрИсключения = СтрЗаменить(СтрИсключения, " ", "");
	
	Для Сч=1 по СтрДлина(СтрИсключения) Цикл
		Символ = Сред(СтрИсключения, Сч, 1);
		Если Найти(СтрИмяФайла, Символ) <> 0 Тогда
			СтрИмяФайла = СтрЗаменить(СтрИмяФайла, Символ, " ");
		КонецЕсли;
	КонецЦикла;
	
	СтрИмяФайла = СокрЛП(СтрИмяФайла);
	
КонецПроцедуры // СкорректироватьИмяФайла()

// Сохраняет путь к рабочему каталогу в настройках
//
Процедура СохранитьПутьККаталогуВНастройках(ИмяКаталога)
	
	ФайловыеФункции.УстановитьПутьКРабочемуКаталогуПользователяИОбновитьПовторноИспользуемыеЗначения(ИмяКаталога);
	
КонецПроцедуры

#КонецОбласти