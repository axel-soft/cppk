﻿
&НаКлиенте
&ИзменениеИКонтроль("ОК")
Процедура ЦППК_ОК(Команда)
	
#Удаление
	Если ИспользоватьШтрихкоды 
		И ПоложениеШтрихкода = ПоложениеРегНомера
		И ПоложениеРегНомера <> ПредопределенноеЗначение("Перечисление.МестаВставкиКартинки.ПроизвольноеПоложение")
		Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Укажите разное положение для регистрационного номера и штрихкода.'"));	
		Возврат;	
	КонецЕсли;	
#КонецУдаления	
	
	НастройкиШтрихкода = ШтрихкодированиеКлиентСервер.НовыеНастройкиШтрихкода();
	НастройкиШтрихкода.СмещениеПоГоризонтали = ПоГоризонтали;
	НастройкиШтрихкода.СмещениеПоВертикали = ПоВертикали;
	НастройкиШтрихкода.ПоложениеНаСтранице = ПоложениеШтрихкода;
	НастройкиШтрихкода.ПоказыватьФормуНастройки = Не НеПоказыватьФормуНастройки; 
	НастройкиШтрихкода.ВысотаШК = ВысотаШтрихкодаПриВставкеВФайл;
	НастройкиШтрихкода.ПоказыватьЦифры = ВставлятьЦифрыВШК;
	ШтрихкодированиеСервер.ЗаписатьПерсональныеНастройкиОкнаСвойствШтрихкода(НастройкиШтрихкода);
	
	
	НастройкиРегНомера = ШтрихкодированиеКлиентСервер.НовыеНастройкиРегНомера();
	НастройкиРегНомера.ПоложениеНаСтранице = ПоложениеРегНомера;
	НастройкиРегНомера.СмещениеПоГоризонтали = ПоГоризонталиРегНомер;
	НастройкиРегНомера.СмещениеПоВертикали = ПоВертикалиРегНомер;
	Если ЗначениеЗаполнено(СтраницаВставкиРегНомера) Тогда
		Если СтраницаВставкиРегНомера = ПоследняяСтраница() Тогда
			НастройкиРегНомера.СтраницаВставки = ПредопределенноеЗначение(
				"Перечисление.СтраницаВставкиКартинки.Последняя");
		ИначеЕсли СтраницаВставкиРегНомера = ПерваяСтраница() Тогда
			НастройкиРегНомера.СтраницаВставки = ПредопределенноеЗначение(
				"Перечисление.СтраницаВставкиКартинки.Первая");
		КонецЕсли;
	Иначе
		НастройкиРегНомера.СтраницаВставки = ПредопределенноеЗначение("Перечисление.СтраницаВставкиКартинки.Первая");
	КонецЕсли; 
	
	НастройкиРегНомера.ПоказыватьПриВставке = ПоказыватьПриВставке;
	ШтрихкодированиеСервер.ЗаписатьПерсональныеНастройкиПоложенияРегНомера(НастройкиРегНомера);
	
	Если СтраницаВставкиРегНомера = ПроизвольнаяСтраница() Тогда
		// НомерСтраницыРегНомера - в настройках пользователя не сохраняется, в файлах разное количество страниц.
		// Но в вызвавшую форму - нужно вернуть произвольную страницу:
		НастройкиРегНомера.СтраницаВставки = НомерСтраницыРегНомера;
	КонецЕсли;
	
	
	ДанныеВозврата = Новый Структура("НастройкиРегНомера, НастройкиШтрихкода", НастройкиРегНомера, НастройкиШтрихкода);
	
	Закрыть(ДанныеВозврата);
	
КонецПроцедуры
