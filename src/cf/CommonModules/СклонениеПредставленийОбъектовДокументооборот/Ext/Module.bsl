﻿#Область ПрограммныйИнтерфейс

// Возвращает представление объекта в нужном падеже.
//
// Параметры:
// 	Объект - ОпределяемыйТип.ОбъектСклонения, СправочникСсылка.Сотрудники, Строка - объект.
// 	Падеж - Число - падеж, в который необходимо просклонять представление объекта.
//  	    1 - Именительный.
//          2 - Родительный.
//          3 - Дательный.
//          4 - Винительный.
//          5 - Творительный.
//          6 - Предложный.
//
// Возвращаемое значение:
//  Строка - представление в нужном падеже.
//
Функция ПросклонятьПредставление(Объект, Падеж) Экспорт
	
	Если Метаданные.ОпределяемыеТипы.ОбъектСклонения.Тип.СодержитТип(ТипЗнч(Объект)) Тогда
		ПредставлениеВПадеже = СклонениеПредставленийОбъектов.ПросклонятьПредставление(
			Строка(Объект), Падеж, Объект);
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Сотрудники") Тогда
		ПредставлениеВПадеже = Сотрудники.ПросклонятьПредставлениеСотрудника(Объект, Падеж);
	Иначе
		ПредставлениеВПадеже = СклонениеПредставленийОбъектов.ПросклонятьПредставление(
			Строка(Объект), Падеж);
	КонецЕсли;
	
	Возврат ПредставлениеВПадеже;
	
КонецФункции

#КонецОбласти
