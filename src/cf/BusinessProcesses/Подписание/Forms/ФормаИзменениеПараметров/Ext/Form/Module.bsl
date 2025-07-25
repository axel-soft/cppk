﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Учет переносов сроков выполнения
	ПереносСроковВыполненияЗадач.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// Сроки выполнения
	УстановитьУсловноеОформлениеИстекшихСроков();
	СрокиИсполненияПроцессов.КарточкаПроцессаПриСозданииНаСервере(
		ЭтаФорма, БизнесПроцессы.Подписание.ТочкиМаршрута.ОбработатьРезультат, Истина);
	
	УстановитьДоступностьПоШаблону();
	
	Мультипредметность.ПроцессПриСозданииНаСервере(ЭтаФорма, Объект);
	
	ПроверятьОтсутствие = Отсутствия.ПредупреждатьОбОтсутствии();
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		НастроитьЭлементыФормыДляМобильногоУстройства();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	РаботаСБизнесПроцессами.ЗаполнитьДеревоУчастниковПоПроцессуПодписания(
		УчастникиПроцесса, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РаботаСБизнесПроцессамиКлиент.РазвернутьДеревоУчастниковПодписания(
		УчастникиПроцесса, Элементы.УчастникиПроцесса);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Учет переноса сроков
	ПереносСроковВыполненияЗадач.ПередатьПричинуИЗаявкуНаПереносаСрока(ТекущийОбъект, ПараметрыЗаписи);
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ЭтоВыполнениеЗадачиОбрабатывающегоРезультат", Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Мультипредметность.ПроцессПослеЗаписиНаСервере(ЭтаФорма, Объект);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("БизнесПроцессИзменен", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоличествоИтерацийПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.КоличествоИтерацийПриИзменении(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_УчастникиПроцесса

// События таблицы УчастникиПроцесса

&НаКлиенте
Процедура УчастникиПроцессаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа,
	Параметр)

	Отказ = Истина;
	РаботаСБизнесПроцессамиКлиент.ОбработатьДобавлениеВДеревоУчастниковПодписания(
		УчастникиПроцесса, Элементы.УчастникиПроцесса, Объект.СпособПодписания,
		ИспользоватьДатуИВремяВСрокахЗадач, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура УчастникиПроцессаПередНачаломИзменения(Элемент, Отказ)
	
	ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли");
	РаботаСБизнесПроцессамиКлиент.ОбработатьНачалоРедактированияВДеревеУчастниковПодписания(
		Элементы.УчастникиПроцесса, Объект.СпособПодписания, ДополнениеТипа, Отказ, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура УчастникиПроцессаПередУдалением(Элемент, Отказ)

	Отказ = Истина;
	РаботаСБизнесПроцессамиКлиент.ОбработатьУдалениеВДеревеУчастниковПодписания(
		УчастникиПроцесса, Элементы.УчастникиПроцесса, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура УчастникиПроцессаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Истина;
	РаботаСБизнесПроцессамиКлиент.ОбработатьПодборУчастниковПодписанияВДерево(
		УчастникиПроцесса, Элементы.УчастникиПроцесса, ВыбранноеЗначение,
		ИспользоватьДатуИВремяВСрокахЗадач, ЭтаФорма);
	
КонецПроцедуры

// События поля ЭтапУчастник_Представление

&НаКлиенте
Процедура ЭтапУчастник_ПредставлениеПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ОбновитьСрокиИсполненияОтложенно("УчастникиПроцесса");
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапУчастник_ПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСБизнесПроцессамиКлиент.ОбработатьОчисткуУчастникаПодписанияВДереве(
		Элементы.УчастникиПроцесса);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапУчастник_ПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСБизнесПроцессамиКлиент.ОбработатьОткрытиеУчастникаПодписанияИзДереве(
		Элементы.УчастникиПроцесса);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапУчастник_ПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ОбработатьВыборУчастникаПодписанияВДереве(
		Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	ОбновитьСрокиИсполненияОтложенно("УчастникиПроцесса");
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапУчастник_ПредставлениеАвтоПодбор(Элемент, Текст, ДанныеВыбора,
	ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли");	
	РаботаСБизнесПроцессамиКлиент.ОбработатьАвтоподборУчастникаПодписанияВДереве(
		Текст, СтандартнаяОбработка, ДанныеВыбора, ДополнениеТипа);

КонецПроцедуры

&НаКлиенте
Процедура ЭтапУчастник_ПредставлениеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора,
	ПараметрыПолученияДанных, СтандартнаяОбработка)

	ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли");	
	РаботаСБизнесПроцессамиКлиент.ОбработатьАвтоподборУчастникаПодписанияВДереве(
		Текст, СтандартнаяОбработка, ДанныеВыбора, ДополнениеТипа);

КонецПроцедуры

&НаКлиенте
Процедура ЭтапУчастник_ПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСБизнесПроцессамиКлиент.ОбработатьНачалоВыбораУчастникаПодписанияВДереве(
		Элементы.УчастникиПроцесса,
		Объект.СпособПодписания,
		Неопределено,
		Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли"));
	
КонецПроцедуры

// События поля СрокИсполненияПредставление

&НаКлиенте
Процедура СрокИсполненияПредставлениеПриИзменении(Элемент)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокПоПредставлениюВДеревеУчастников(
		ЭтаФорма, Элементы.УчастникиПроцесса);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокВДеревеУчастников(
		ЭтаФорма, Элементы.УчастникиПроцесса, Направление);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ВыбратьСрокИсполненияДляСтрокиДереваУчастников(
		ЭтаФорма, Элементы.УчастникиПроцесса, УчастникиПроцесса);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ЗначениеЗаполнено(РезультатВыполнения) Тогда
		
		СообщениеОбОшибке = НСтр("ru = 'Не заполнен комментарий'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СообщениеОбОшибке,,
			"РезультатВыполнения");
		
		Возврат;
		
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОК_ПослеПодтвержденияПереносаСрока", ЭтотОбъект);
	
	СрокиИсполненияПроцессовКлиент.ПодтвердитьПереносСрокаПроцессаПриВозвратеНаДоработку(
		ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК_ПослеПодтвержденияПереносаСрока(Результат, Параметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОК_ПослеПроверкиОтсутствия", ЭтотОбъект);
	Если Не ОтсутствияКлиент.ПроверитьОтсутствиеПоПроцессу(ЭтаФорма, ОписаниеОповещения) Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК_ПослеПроверкиОтсутствия(РезультатПроверкиОтсутствия, Параметры) Экспорт
	
	Если РезультатПроверкиОтсутствия <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	Если Модифицированность Тогда
		
		ОтметкиПрохождения = РаботаСБизнесПроцессамиКлиент.ОтметкиПрохожденияПроцессаПодписания(
			Объект);
		
		РаботаСБизнесПроцессамиКлиентСервер.ЗаполнитьПроцессПодписанияПоДеревуУчастников(
			Объект, УчастникиПроцесса);
			
		РаботаСБизнесПроцессамиКлиент.ЗаполнитьОтметкиПрохожденияВПроцессеПодписания(
			Объект, ОтметкиПрохождения);
		
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("ПричинаПереносаСрока", ПричинаПереносаСрока);
		
		Если Не ПроверитьЗаполнение() Или Не Записать(ПараметрыЗаписи) Тогда
			Возврат;
		КонецЕсли;
		
		Если ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры <> Неопределено 
			И ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Свойство(
			"ИдентификаторБлокировкиПроцесса") Тогда
			
			ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ИдентификаторБлокировкиПроцесса = 
				УникальныйИдентификатор;
		КонецЕсли;
		
		// Сроки выполнения
		СрокиИсполненияПроцессовКлиент.ОповеститьОПереносеСроков(ЭтаФорма);
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Изменение:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
	Результат = СтруктураРезультата();
	Результат.КодВозврата = КодВозвратаДиалога.ОК;
	Результат.ДанныеПроцесса = ДанныеПроцессаДляРезультата();
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть(СтруктураРезультата());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_УчастникиПроцесса

&НаКлиенте
Процедура ДобавитьЭтапПодписания(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ДобавитьСтрокуЭтапаПодписания(
		УчастникиПроцесса, Элементы.УчастникиПроцесса, Объект.СпособПодписания);

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьУчастникаПодписания(Команда)

	РаботаСБизнесПроцессамиКлиент.ДобавитьСтрокуУчастникаПодписанияДляТекущегоРодителя(
		УчастникиПроцесса, Элементы.УчастникиПроцесса, Объект.СпособПодписания,
		ИспользоватьДатуИВремяВСрокахЗадач, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли");	
	РаботаСБизнесПроцессамиКлиент.ПодборатьУчастниковПодписанияВДерево(
		УчастникиПроцесса, Элементы.УчастникиПроцесса, ДополнениеТипа);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьУчастникаВверх(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОбработатьПеремещениеСтрокиВДеревеУчастниковПодписания(
		Элементы.УчастникиПроцесса, -1, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьУчастникаВниз(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОбработатьПеремещениеСтрокиВДеревеУчастниковПодписания(
		Элементы.УчастникиПроцесса, 1, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьДоступностьПоШаблону()
	
	ДоступностьПоШаблону = Истина;
	
	Если Не ЗначениеЗаполнено(Объект.Шаблон) И Не ЗначениеЗаполнено(Объект.ВедущаяЗадача) Тогда 
		Возврат;
	КонецЕсли;
	
	ДоступностьПоШаблону = ШаблоныБизнесПроцессов.ДоступностьПоШаблону(Объект);
	
	Отбор = Новый Структура("ТочкаМаршрута");
	Отбор.ТочкаМаршрута = БизнесПроцессы.Подписание.ТочкиМаршрута.Подписать;
	КоличествоПодписывающих = Объект.Участники.НайтиСтроки(Отбор).Количество();
	Отбор.ТочкаМаршрута = БизнесПроцессы.Подписание.ТочкиМаршрута.ОбеспечитьПодписание;
	КоличествоПодписывающих = КоличествоПодписывающих
		+ Объект.Участники.НайтиСтроки(Отбор).Количество();
	
	Если КоличествоПодписывающих > 0 Тогда
		Элементы.УчастникиПроцесса.ИзменятьСоставСтрок = ДоступностьПоШаблону;
		Элементы.УчастникиПроцесса.ИзменятьПорядокСтрок = ДоступностьПоШаблону;
		Элементы.ЭтапУчастник_Представление.ТолькоПросмотр = Не ДоступностьПоШаблону;
		Элементы.СрокИсполненияПредставление.ТолькоПросмотр = Не ДоступностьПоШаблону;
				
		Элементы.Подобрать.Доступность = ДоступностьПоШаблону;
		Элементы.ДобавитьУчастникаПодписания.Доступность = ДоступностьПоШаблону;
		Элементы.ДобавитьЭтапПодписания.Доступность = ДоступностьПоШаблону;
		Элементы.ПереместитьВверх.Доступность = ДоступностьПоШаблону;
		Элементы.ПереместитьВниз.Доступность = ДоступностьПоШаблону;
		Элементы.Удалить.Доступность = ДоступностьПоШаблону;
	Иначе
		Элементы.УчастникиПроцесса.ИзменятьСоставСтрок = Истина;
		Элементы.УчастникиПроцесса.ИзменятьПорядокСтрок = Истина;
		Элементы.ЭтапУчастник_Представление.ТолькоПросмотр = Ложь;
		Элементы.СрокИсполненияПредставление.ТолькоПросмотр = Ложь;
		
		Элементы.Подобрать.Доступность = Истина;
		Элементы.ДобавитьУчастникаПодписания.Доступность = Истина;
		Элементы.ДобавитьЭтапПодписания.Доступность = Истина;
		Элементы.ПереместитьВверх.Доступность = Истина;
		Элементы.ПереместитьВниз.Доступность = Истина;
		Элементы.Удалить.Доступность = Истина;		
	КонецЕсли;
		
	ПараметрыДоступности = 
		СрокиИсполненияПроцессовКлиентСервер.ПараметрыДоступностиЭлементаУправления();
	ПараметрыДоступности.ДоступностьПоШаблону = ДоступностьПоШаблону;
		
	СрокиИсполненияПроцессовКлиентСервер.НастроитьЭлементУправленияСроком(
		ЭтаФорма,
		Элементы.КоличествоИтераций,
		Объект.КоличествоИтераций,
		ПараметрыДоступности);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыДляМобильногоУстройства()
	
	
	
КонецПроцедуры

// Возвращает структуру результата для процедур закрытия формы.
//
&НаКлиенте
Функция СтруктураРезультата()
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("КодВозврата", КодВозвратаДиалога.Отмена);
	СтруктураРезультата.Вставить("РезультатВыполнения", РезультатВыполнения);
	
	СтруктураРезультата.Вставить("ДанныеПроцесса", Неопределено);
	
	Возврат СтруктураРезультата;
	
КонецФункции

&НаСервере
Функция ДанныеПроцессаДляРезультата()
	
	ПроцессОбъект = ДанныеФормыВЗначение(Объект, Тип("БизнесПроцессОбъект.Подписание"));
	ДанныеПроцесса = ПроцессОбъект.СтруктураДанныхДляЗаполнения();
	ЗаполнитьЗначенияСвойств(ДанныеПроцесса, ПроцессОбъект,, "Этапы, Участники, Предметы");
	
	Для Каждого СтрокаЭтапа Из ПроцессОбъект.Этапы Цикл
		ЗаполнитьЗначенияСвойств(ДанныеПроцесса.Этапы.Добавить(), СтрокаЭтапа);
	КонецЦикла;
	
	Для Каждого СтрокаУчастника Из ПроцессОбъект.Участники Цикл
		ЗаполнитьЗначенияСвойств(ДанныеПроцесса.Участники.Добавить(), СтрокаУчастника);
	КонецЦикла;
	
	Возврат Новый ХранилищеЗначения(ДанныеПроцесса);
	
КонецФункции

#Область СрокиИсполненияПроцессов

// Заполняет представление сроков в карточке процесса
//
&НаСервере
Процедура ОбновитьСрокиИсполненияНаСервере() Экспорт
	
	ПараметрыДляРасчетаСроков = СрокиИсполненияПроцессов.ПараметрыДляРасчетаСроков();
	ПараметрыДляРасчетаСроков.ДатаОтсчета = ДатаОтсчетаДляРасчетаСроков;
	ПараметрыДляРасчетаСроков.РеквизитТаблицаСИзмененнымСроком = РеквизитТаблицаСИзмененнымСроком;
	ПараметрыДляРасчетаСроков.ИндексСтроки = ИндексСтрокиСИзмененнымСроком;
	ПараметрыДляРасчетаСроков.ТекущаяИтерация = Объект.НомерИтерации + 1;
	ПараметрыДляРасчетаСроков.ЗаполнятьСрокПроцессаТолькоПриПревышении = Истина;
	
	СтруктураДляРасчета = 
		СрокиИсполненияПроцессов.СтруктураДляРасчетаСрокаПодписанияПоДаннымПроцессаВКарточке(
		Объект, УчастникиПроцесса);				
				
	СрокиИсполненияПроцессов.РассчитатьСрокиПодписания(
		СтруктураДляРасчета, ПараметрыДляРасчетаСроков);
			
	СрокиИсполненияПроцессов.ЗаполнитьСрокиПодписанияВКарточкеПроцессаПоСтруктуреРасчета(
		Объект, УчастникиПроцесса, СтруктураДляРасчета);
				
	СрокиИсполненияПроцессов.ПроверитьИзменениеСроковВФормеПроцесса(ЭтаФорма);
	
	РеквизитТаблицаСИзмененнымСроком = "";
	ИндексСтрокиСИзмененнымСроком = 0;
	
	ОбновитьПризнакиИстекшихСроков();
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковИсполненияВФорме(ЭтаФорма);
	
КонецПроцедуры

// см. ОбновитьСрокиИсполненияНаСервере
&НаКлиенте
Процедура ОбновитьСрокиИсполнения()
	
	ОбновитьСрокиИсполненияНаСервере();
	
КонецПроцедуры

// см. ОбновитьСрокиИсполнения
&НаКлиенте
Процедура ОбновитьСрокиИсполненияОтложенно(РеквизитТаблица = "", ИндексСтроки = 0) Экспорт
	
	РеквизитТаблицаСИзмененнымСроком = РеквизитТаблица;
	ИндексСтрокиСИзмененнымСроком = ИндексСтроки;
	
	ПодключитьОбработчикОжидания("ОбновитьСрокиИсполнения", 0.2, Истина);
	
КонецПроцедуры

// Заполняет представление сроков исполнения в карточке процесса.
//
&НаКлиенте
Процедура ЗаполнитьПредставлениеСроковИсполнения() Экспорт
	
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковИсполненияВФорме(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеИстекшихСроков()
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок исполнения истек (Участники)'"),
		"УчастникиПроцесса.СрокИсполненияИстек",
		"СрокИсполненияПредставление");
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок исполнения процесса истек'"),
		"СрокИсполненияПроцессаИстек",
		"СрокИсполненияПроцессаПредставление");

КонецПроцедуры

// Обновляет признаки истекших сроков в карточке.
//
&НаСервере
Процедура ОбновитьПризнакиИстекшихСроков()
		
	СрокиИсполненияПроцессов.ОбновитьПризнакИстекшихСроковВДеревеУчастников(
		УчастникиПроцесса, ТекущаяДатаСеанса());
		
	СрокиИсполненияПроцессов.ОбновитьПризнакИстекшегоСрокаПроцесса(
		Объект.СрокИсполненияПроцесса, Объект.ДатаЗавершения, СрокИсполненияПроцессаИстек);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти