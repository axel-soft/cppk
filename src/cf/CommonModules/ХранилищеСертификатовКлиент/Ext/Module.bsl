﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Хранилище сертификатов".
//  
////////////////////////////////////////////////////////////////////////////////


#Область ПрограммныйИнтерфейс

// Добавляет сертификат в хранилище сертификатов.
// 
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - Структура - результат выполнения процедуры.
//       * Выполнено - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//       * ОписаниеОшибки - Строка - описание ошибки выполнения.
//
//   Сертификат - ДвоичныеДанные - файл сертификата.
//                Строка - адрес файла сертификата во временном хранилище.
//   ТипХранилища - Строка, ПеречислениеСсылка.ТипХранилищаСертификатов - тип хранилища, в которое необходимо добавить сертификат.
//
Процедура Добавить(ОповещениеОЗавершении, Сертификат, ТипХранилища) Экспорт
	
	ХранилищеСертификатовСлужебныйКлиент.Добавить(ОповещениеОЗавершении, Сертификат, ТипХранилища);
	
КонецПроцедуры

// Получает сертификаты из хранилища.
// 
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - Структура - результат выполнения процедуры.
//       * Выполнено - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//       * ОписаниеОшибки - Строка - описание ошибки выполнения.
//       * Сертификаты - Массив - массив объектов ФиксированнаяСтруктура со свойствами сертификатов.
//           ** Версия - Строка - версия сертификата.
//           ** ДатаНачала - Дата - дата начала действия сертификата.
//           ** ДатаОкончания - Дата - дата окончания действия сертификата.
//           ** Издатель - ФиксированнаяСтруктура - информация об издателе сертификата:
//                *** CN - commonName; 
//                *** O - organizationName; 
//                *** OU - organizationUnitName; 
//                *** C - countryName; 
//                *** ST - stateOrProvinceName; 
//                *** L - localityName; 
//                *** E - emailAddress; 
//                *** SN - surname; 
//                *** GN - givenName; 
//                *** T - title;
//                *** STREET - streetAddress;
//                *** OGRN - ОГРН;
//                *** OGRNIP - ОГРНИП;
//                *** INN - ИНН (не обязательный);
//                *** INNLE - Строка - ИНН ЮЛ (не обязательный);
//                *** SNILS - СНИЛС;
//                   ...
//           ** ИспользоватьДляПодписи - Булево - указывает, можно ли использовать данный сертификат для подписи.
//           ** ИспользоватьДляШифрования - Булево - указывает, можно ли использовать данный сертификат для шифрования.
//           ** Отпечаток - ДвоичныеДанные - содержит данные отпечатка. Вычисляется динамически, по алгоритму SHA-1.
//           ** РасширенныеСвойства - ФиксированнаяСтруктура -  расширенные свойства сертификата:
//                *** EKU - ФиксированныйМассив из Строка - Enhanced Key Usage.
//           ** СерийныйНомер - ДвоичныеДанные - серийный номер сертификата.
//           ** Субъект - ФиксированнаяСтруктура - информацию о субъекте сертификата. Состав см. Издатель.
//           ** Сертификат - ДвоичныеДанные - файл сертификата в кодировке DER.
//           ** Идентификатор - Строка - вычисляется по ключевым свойствам Издателя и серийному номеру по алгоритму SHA1.
//                                  Используется для идентификации сертификата в сервисе криптографии.
//
//   ТипХранилища - Строка, ПеречислениеСсылка.ТипХранилищаСертификатов - тип хранилища, из которого необходимо получить
//                                                                сертификаты.
//                                                                Если не заполнено, то будут получены все сертификаты.
//
Процедура Получить(ОповещениеОЗавершении, ТипХранилища = Неопределено) Экспорт
	
	ХранилищеСертификатовСлужебныйКлиент.Получить(ОповещениеОЗавершении, ТипХранилища);
	
КонецПроцедуры

// Выполняет поиска сертификата в хранилище.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - Структура - результат выполнения процедуры.
//       * Выполнено - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//       * ОписаниеОшибки - Строка - описание ошибки выполнения.
//       * Сертификат - ФиксированнаяСтруктура, Неопределено - свойства найденного сертификата.
// 
//   Сертификат - Структура - ключевые параметры сертификата, используемые для поиска.
//                            Отпечаток или пара СерийныйНомер и Издатель.
//     * Отпечаток - ДвоичныеДанные - отпечаток сертификат.
//                   Строка - строковое представление отпечатка.
//     * СерийныйНомер - ДвоичныеДанные - серийный номер сертификата.
//                       Строка - строковое представление серийного номера.
//     * Издатель - Структура - свойства издателя
//                  Строка - строковое представление издателя.
//
Процедура НайтиСертификат(ОповещениеОЗавершении, Сертификат) Экспорт
	
	ХранилищеСертификатовСлужебныйКлиент.НайтиСертификат(ОповещениеОЗавершении, Сертификат);
	
КонецПроцедуры

#КонецОбласти