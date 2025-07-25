﻿
Функция ЭтоПолноправныйПользователь() Экспорт

	Возврат Пользователи.ЭтоПолноправныйПользователь(Пользователи.ТекущийПользователь());

КонецФункции 

// Возвращает доступность хотя бы одной из указанных ролей или полноправность
// пользователя (текущего или указанного).
//
// Параметры:
//  ИменаРолей   - Строка - имена ролей, разделенные запятыми, доступность которых проверяется.
//
//  Пользователь - Неопределено - проверяется текущий пользователь ИБ.
//               - СправочникСсылка.Пользователи
//               - СправочникСсылка.ВнешниеПользователи - осуществляется
//                    поиск пользователя ИБ по уникальному идентификатору, заданному в реквизите.
//                    ИдентификаторПользователяИБ. Если пользователь ИБ не существует, возвращается Ложь.
//               - ПользовательИнформационнойБазы - проверяется указанный пользователь ИБ.
//
//  УчитыватьПривилегированныйРежим - Булево - если задано Истина, тогда для текущего пользователя
//                 функция возвращает Истина, когда установлен привилегированный режим.
//
// Возвращаемое значение:
//  Булево - Истина, если хотя бы одна из указанных ролей доступна
//           или функция ЭтоПолноправныйПользователь(Пользователь) возвращает Истина.
//
Функция РолиДоступны(ИменаРолей, Пользователь = Неопределено, УчитыватьПривилегированныйРежим = Истина) Экспорт
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Возврат Пользователи.РолиДоступны(ИменаРолей, Пользователь, УчитыватьПривилегированныйРежим);
	
КонецФункции 
