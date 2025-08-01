﻿////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции для работы с этапами
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает массив наименований этапов.
// 
// Параметры:
//  Участники - ТабличнаяЧасть - Участники действия
// 
// Возвращаемое значение:
//  Массив - Массив этапов
Функция МассивЭтапов(Участники) Экспорт
	
	МассивЭтапов = Новый Массив;
	ЭлементыЭтапы = Участники.ПолучитьЭлементы();
	
	Для Каждого ЭлементЭтап Из ЭлементыЭтапы Цикл
		
		Этап = ЭлементЭтап.НаименованиеЭтапа;
		МассивЭтапов.Добавить(Этап);
		
	КонецЦикла;
	
	Возврат МассивЭтапов;
	
КонецФункции

#КонецОбласти
