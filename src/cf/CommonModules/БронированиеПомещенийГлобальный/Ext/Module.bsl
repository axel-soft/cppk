﻿////////////////////////////////////////////////////////////////////////////////
// Бронирование помещений (глобальный)
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик ожидания, подключающий ожидания подтверждения бронирования.
//
Процедура ОперативноеПодтверждениеБронированияГлобальный() Экспорт
	
	БронированиеПомещенийХолдингКлиент.ОжидатьЗавершениеОперативногоПодтвержденияБронирования();
	
КонецПроцедуры

#КонецОбласти