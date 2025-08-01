﻿#Область ПрограммныйИнтерфейс

// Возвращает Истина, если параметр является ссылкой на настройку действия.
// 
// Параметры:
// 	Ссылка - ЛюбаяСсылка - проверяемая ссылка.
// Возвращаемое значение:
// 	Булево - Истина, если параметр является ссылкой на настройку действия
//
Функция ЭтоНастройкаДействия(Ссылка) Экспорт
	
	Возврат ТипЗнч(Ссылка) = Тип("СправочникСсылка.НастройкиДействийИсполнения")
		Или ТипЗнч(Ссылка) = Тип("СправочникСсылка.НастройкиДействийОзнакомления")
		Или ТипЗнч(Ссылка) = Тип("СправочникСсылка.НастройкиДействийПодписания")
		Или ТипЗнч(Ссылка) = Тип("СправочникСсылка.НастройкиДействийРегистрации")
		Или ТипЗнч(Ссылка) = Тип("СправочникСсылка.НастройкиДействийСогласования")
		Или ТипЗнч(Ссылка) = Тип("СправочникСсылка.НастройкиДействийУтверждения");
	
КонецФункции

#КонецОбласти
