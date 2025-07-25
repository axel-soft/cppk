﻿
&ИзменениеИКонтроль("ПрименитьПравилоЭскалацииЗадачПроцессов")
Функция ЦППК_ПрименитьПравилоЭскалацииЗадачПроцессов(Задача, ПравилоЭскалации)
	
	// Если правило эскалации было применено к задаче последним - не применяем его снова.
	Если Задача.ОбработанноеПравилоЭскалации = ПравилоЭскалации.Ссылка Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		ИнформацияОбЭскалации = ИнформацияОбЭскалации();
		Если Не ЭскалацияЗадачПереопределяемый.ПрименитьПравилоЭскалации(Задача, ПравилоЭскалации, ИнформацияОбЭскалации) Тогда
			
			Если ПравилоЭскалации.Действие = Перечисления.ДействияПравилЭскалацииЗадач.Перенаправление Тогда
				
				НаправлениеЭскалации = ПравилоЭскалации.НаправлениеЭскалации;
				
				ТипНаправленияЭскалации = ТипЗнч(НаправлениеЭскалации);
				Если ТипНаправленияЭскалации = Тип("СправочникСсылка.АвтоподстановкиДляОбъектов")
					Или ТипНаправленияЭскалации = Тип("СправочникСсылка.АвтоподстановкиДляПроцессов") Тогда
					ЗначениеАвтоподстановки = ПолучитьЗначениеАвтоподстановки(
						НаправлениеЭскалации,
						Задача.БизнесПроцесс,
						Задача.ОсновнойПредмет,
						Задача.Ссылка,
						Задача);
					ТипЗначенияАвтоподстановки = ТипЗнч(ЗначениеАвтоподстановки);
					Если ТипЗначенияАвтоподстановки = Тип("СправочникСсылка.Пользователи") Тогда
						НаправлениеЭскалации = ЗначениеАвтоподстановки;
					ИначеЕсли ТипЗначенияАвтоподстановки = Тип("СправочникСсылка.Сотрудники") Тогда
						НаправлениеЭскалации = ЗначениеАвтоподстановки;
					ИначеЕсли ТипЗначенияАвтоподстановки = Тип("СправочникСсылка.ПолныеРоли") Тогда
						НаправлениеЭскалации = ЗначениеАвтоподстановки;
					ИначеЕсли ТипЗначенияАвтоподстановки = Тип("Структура") Тогда
						НаправлениеЭскалации = ЗначениеАвтоподстановки.Исполнитель;
					КонецЕсли;
					ТипНаправленияЭскалации = ТипЗнч(НаправлениеЭскалации);
				КонецЕсли;
				
				ИнфоОПеренаправлении = Новый Структура("Автоперенаправление, Исполнитель,
					|РольИсполнителя, Комментарий");
				Если ТипНаправленияЭскалации = Тип("СправочникСсылка.Пользователи") Тогда
					ИнфоОПеренаправлении.Исполнитель = НаправлениеЭскалации;
				ИначеЕсли ТипНаправленияЭскалации = Тип("СправочникСсылка.Сотрудники") Тогда
					ИнфоОПеренаправлении.Исполнитель = НаправлениеЭскалации;
				ИначеЕсли ТипНаправленияЭскалации = Тип("СправочникСсылка.ПолныеРоли") Тогда
					ИнфоОПеренаправлении.РольИсполнителя = НаправлениеЭскалации;
				Иначе
					ВызватьИсключение СтрШаблон(
						НСтр("ru = 'Неизвестное направление эскалации %1 (%2).'"),
						НаправлениеЭскалации,
						ТипНаправленияЭскалации);
				КонецЕсли;
				ИнфоОПеренаправлении.Комментарий = СтрШаблон(
					НСтр("ru = 'Перенаправлено автоматически от %1'"),
					Задача.Исполнитель);
				ИнфоОПеренаправлении.Автоперенаправление = Истина;
				
				ПроверятьФункциональнуюОпцию = Ложь;
				ОтключитьОбновлениеЗадач = Ложь;
				ПроверятьПраваВПривилегированномРежиме = Ложь; // Для эскалации не нужно наличие прав
				ЗадачаПеренаправлена = БизнесПроцессыИЗадачиСервер.ПеренаправитьЗадачу(
					Задача.Ссылка,
					ИнфоОПеренаправлении,
					ПроверятьФункциональнуюОпцию,
					ОтключитьОбновлениеЗадач,
					ПроверятьПраваВПривилегированномРежиме);
				Если Не ЗадачаПеренаправлена Тогда
					ТекстОшибки = НСтр("ru = 'Не удалось перенаправить задачу.'");
					ВызватьИсключение ТекстОшибки;
				КонецЕсли;
				
				ИнформацияОбЭскалации.Исполнитель = Задача.Исполнитель;
				ИнформацияОбЭскалации.НовыйИсполнитель = НаправлениеЭскалации;
				
			ИначеЕсли ПравилоЭскалации.Действие = Перечисления.ДействияПравилЭскалацииЗадач.АвтоматическоеВыполнение Тогда
				
				Если ЭтоПроцессСКЭП(Задача.БизнесПроцесс) Тогда
					ТекстОшибки = НСтр("ru = 'Задачу с КЭП нельзя выполнить автоматически.'");
					ВызватьИсключение ТекстОшибки;
				КонецЕсли;
				
				Комментарий = КомментарийВыполненаАвтоматически(Задача, ПравилоЭскалации.ВариантВыполнения);
				#Вставка
				Комментарий = ЦППК_СформироватьКомментарийДействия(ПравилоЭскалации, Комментарий, Задача);
				#КонецВставки
				ВыполнениеЗадачСервер.ВыполнитьЗадачуПоПравилуЭскалации(
					Задача.Ссылка, ПравилоЭскалации.ВариантВыполнения, Комментарий);
				
				ИнформацияОбЭскалации.Исполнитель = Задача.Исполнитель;
				
			Иначе
				ТекстОшибки = НСтр("ru = 'Некорректное действие правила эскалации.'");
				ВызватьИсключение ТекстОшибки;
			КонецЕсли;
			
			ИнформацияОбЭскалации.Действие = ПравилоЭскалации.Действие;
			
		КонецЕсли;
		
		РегистрыСведений.ЭскалированныеЗадачи.Добавить(Задача.Ссылка, ПравилоЭскалации.Ссылка, ИнформацияОбЭскалации);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ЦППК_СформироватьКомментарийДействия(ПравилоЭскалации, Комментарий, Задача)
	
	КомментарийДействия = ПравилоЭскалации.КомментарийДействия;
	
	Если ПустаяСтрока(КомментарийДействия) Тогда
		Возврат Комментарий;
	КонецЕсли;
	
	Исполнитель = Задача.Исполнитель;

	ДатаПроверкиОтсутствий = ТекущаяДатаСеанса();
	Исполнители = Новый Массив;	
	ДанныеИсполнителя = ОтсутствияКлиентСервер.ПолучитьДанныеИсполнителя(Исполнитель);
	Исполнители.Добавить(ДанныеИсполнителя);
	НастройкиПроверкиОтсутствий = ОтсутствияКлиентСервер.НастройкиПроверкиОтсутствий();
	НастройкиПроверкиОтсутствий.УчитыватьФлагБудуРазбиратьЗадачи = Истина;
	ТаблицаОтсутствий = Отсутствия.ПолучитьТаблицуОтсутствийИсполнителей(
		ДатаПроверкиОтсутствий,
		ДатаПроверкиОтсутствий,
		Исполнители,
		НастройкиПроверкиОтсутствий);
		
	ТаблицаОтсутствий = Новый ТаблицаЗначений;
	ДатаНачалаОтсутствия = Дата(1,1,1);
	ДатаОкончанияОтсутствия = Дата(1,1,1);
		
	Если ТаблицаОтсутствий.Количество() Тогда
		
		ПоследняяСтрока = ТаблицаОтсутствий[ТаблицаОтсутствий.Количество()-1];
		ДатаНачалаОтсутствия  = ПоследняяСтрока.ДатаНачала;
		ДатаОкончанияОтсутствия  = ПоследняяСтрока.ДатаОкончания;

		
	КонецЕсли;
	
	КомментарийДействия = СтрЗаменить(КомментарийДействия, "%Исполнитель%", Исполнитель); 
	КомментарийДействия = СтрЗаменить(КомментарийДействия, "%ДатаНачалаОтсутствия%", Формат(ДатаНачалаОтсутствия, "ДФ=dd.MM.yyyy; ДП='<Не определено>'")); 	
	КомментарийДействия = СтрЗаменить(КомментарийДействия, "%ДатаОкончанияОтсутствия%", Формат(ДатаОкончанияОтсутствия, "ДФ=dd.MM.yyyy; ДП='<Не определено>'")); 	
	
КонецФункции // СформироватьКомментарийДействия()

&ИзменениеИКонтроль("ПравилаЭскалацииЗадач")
Функция ЦППК_ПравилаЭскалацииЗадач()

	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПравилаЭскалацииЗадач.Ссылка КАК Ссылка,
	|	ПравилаЭскалацииЗадач.Представление КАК Представление,
	|	ПравилаЭскалацииЗадач.Код КАК Код,
	|	ПравилаЭскалацииЗадач.Действие КАК Действие,
	|	ПравилаЭскалацииЗадач.НаправлениеЭскалации КАК НаправлениеЭскалации,
	|	ПравилаЭскалацииЗадач.ВариантВыполнения КАК ВариантВыполнения,
	|	ПравилаЭскалацииЗадач.Приоритет КАК Приоритет,
	|	ПравилаЭскалацииЗадач.ВариантСрока КАК ВариантСрока,
	|	ПравилаЭскалацииЗадач.Срок КАК Срок,
	#Вставка
	|	ПравилаЭскалацииЗадач.ЦППК_КомментарийДействия КАК КомментарийДействия,	
	#КонецВставки
	|	ПравилаЭскалацииЗадач.ДополнительныеУсловия.(
	|		Условие,
	|		ЗначениеУсловия) КАК ДополнительныеУсловия,
	|	ПравилаЭскалацииЗадач.Процессы.(
	|		ТипПроцесса,
	|		Шаблон,
	|		ТочкаМаршрута,
	|		ШаблонКомплексногоПроцесса)
	|ИЗ
	|	Справочник.ПравилаЭскалации КАК ПравилаЭскалацииЗадач
	|ГДЕ
	|	ПравилаЭскалацииЗадач.ПометкаУдаления = ЛОЖЬ
	|	И ПравилаЭскалацииЗадач.ТипПредметаЭскалации = ЗНАЧЕНИЕ(Перечисление.ТипыПредметовЭскалации.Процессы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет УБЫВ";
	Результат = Запрос.Выполнить();
	ПравилаЭскалации = Результат.Выгрузить();

	Возврат ПравилаЭскалации;

КонецФункции

