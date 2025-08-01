﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ВидФормы = "SPARK:WhatIsCompositeIndex" Тогда
		Элементы.ДекорацияИнформация.Заголовок = ОписаниеЧтоТакоеСводныйИндикаторРиска();
		ЭтотОбъект.Заголовок = НСтр("ru = 'Что такое сводный индикатор риска?'");
	ИначеЕсли Параметры.ВидФормы = "SPARK:WhatIsPaymentIndex" Тогда
		Элементы.ДекорацияИнформация.Заголовок = ОписаниеЧтоТакоеИндексПлатежнойДисциплины();
		ЭтотОбъект.Заголовок = НСтр("ru = 'Что такое Индекс платежной дисциплины?'");
	ИначеЕсли Параметры.ВидФормы = "SPARK:WhatIsFailureScore" Тогда
		Элементы.ДекорацияИнформация.Заголовок = ОписаниеЧтоТакоеИндексФинансовогоРиска();
		ЭтотОбъект.Заголовок = НСтр("ru = 'Что такое индекс финансового риска?'");
	ИначеЕсли Параметры.ВидФормы = "SPARK:WhatIsIndexOfDueDiligence" Тогда
		Элементы.ДекорацияИнформация.Заголовок = ОписаниеЧтоТакоеИндексДолжнойОсмотрительности();
		ЭтотОбъект.Заголовок = НСтр("ru = 'Что такое Индекс должной осмотрительности?'");
	ИначеЕсли Параметры.ВидФормы = "SPARK:StatusDescription" Тогда
		Элементы.ДекорацияИнформация.Заголовок = ОписаниеРасшифровкаСтатуса(Параметры.Статус);
		ЭтотОбъект.Заголовок = НСтр("ru = 'Текущий статус контрагента'");
	ИначеЕсли Параметры.ВидФормы = "SPARK:NoInfo" Тогда
		Элементы.ДекорацияИнформация.Заголовок = ОписаниеНетИнформации();
		ЭтотОбъект.Заголовок = НСтр("ru = 'Почему нет информации о контрагенте?'");
	ИначеЕсли Параметры.ВидФормы = "SPARK:WhatIsAccountingStatements" Тогда
		Элементы.ДекорацияИнформация.Заголовок = ОписаниеБухгалтерскаяОтчетность();
		ЭтотОбъект.Заголовок = НСтр("ru = 'Что означает Передана бух. отчетность в СПАРК?'");
	Иначе
		ВызватьИсключение НСтр("ru = 'Некорректные параметры формы.'");
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = Параметры.ВидФормы;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ОписаниеЧтоТакоеСводныйИндикаторРиска()
	
	ОписаниеИндекса = НСтр("ru = 'Индикатор представляет собой оценку на основе трех аналитических показателей СПАРК: Индекса платежной дисциплины, Индекса должной осмотрительности, Индекса финансового риска. Особенность методологии сводного индикатора заключается в учете Статуса компании (ликвидация, банкротство и т.д.), что позволяет правильно оценить риск по предприятию даже при наличии положительных значений остальных индексов.
		|
		|Для оценки риска используется следующая шкала значений:'");
	
	Возврат СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<b>Сводный индикатор</b> - является совокупной оценкой аналитических показателей СПАРК.
			|
			|%1
			|  <span style=""color: ЦветГрадацияСПАРКНизкийРиск"">Низкий риск;</span>
			|  <span style=""color: ЦветГрадацияСПАРКСреднийРиск"">Средний риск;</span>
			|  <span style=""color: ЦветГрадацияСПАРКВысокийРиск"">Высокий риск.</span>'"),
		ОписаниеИндекса);
	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеЧтоТакоеИндексПлатежнойДисциплины()
	
	ОписаниеИндекса = НСтр("ru = 'Данные о счетах, предполагаемых сроках оплаты и о фактах оплаты поступают в систему от компаний-участников проекта ""Мониторинг платежей"". На основе собранных данных система рассчитывает индекс по компаниям-плательщикам.
		|
		|Риск задержки оплаты счетов в зависимости от значения индекса:'");
	
	Возврат СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<b>Индекс платежной дисциплины</b> - это оценка своевременности оплаты компанией счетов.
			|
			|%1
			|  <span style=""color: ЦветГрадацияСПАРКВысокийРиск"">0 - 49 -  высокий риск просрочки платежа;</span>
			|  <span style=""color: ЦветГрадацияСПАРКСреднийРиск"">50 - 79 - есть вероятность возникновения задержки оплаты;</span>
			|  <span style=""color: ЦветГрадацияСПАРКНизкийРиск"">80 - 100 - счета оплачиваются вовремя.</span>'"),
		ОписаниеИндекса);
	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеЧтоТакоеИндексФинансовогоРиска()
	
	ОписаниеИндекса = НСтр("ru = 'Для расчета индекса используются финансовые показатели из годовой бухгалтерской отчетности компаний, а также комбинированные финансовые коэффициенты компании, такие как коэффициент ликвидности, достаточности. оборотных средств,  автономии и другие.
		|
		|Риск несостоятельности в зависимости от значения индекса:'");
	
	Возврат СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<b>Индекс финансового риска</b> - это вероятностная оценка несостоятельности компании.
			|
			|%1
			|  <span style=""color: ЦветГрадацияСПАРКНизкийРиск"">0 - 30 - низкий риск;</span>
			|  <span style=""color: ЦветГрадацияСПАРКСреднийРиск"">31 - 70 - средний риск;</span>
			|  <span style=""color: ЦветГрадацияСПАРКВысокийРиск"">71 - 99 - высокий риск.</span>'"),
		ОписаниеИндекса);
	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеЧтоТакоеИндексДолжнойОсмотрительности()
	
	ОписаниеИндекса = НСтр("ru = 'Аналитическая модель для расчета индекса использует совокупность алгоритмов нейронной сети, и логистической  регрессии и учитывает более 40 различных факторов , включая массовость адреса, директора, наличие исполнительных производств, арбитражных дел и многие другие.
		|
		|Для оценки риска используется следующая шкала значений:'");
	
	Возврат СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<b>Индекс должной осмотрительности</b> - это вероятностная оценка, показывающая, что компания может являться однодневкой.
			|
			|%1
			|  <span style=""color: ЦветГрадацияСПАРКНизкийРиск"">0 - 40 - низкий риск;</span>
			|  <span style=""color: ЦветГрадацияСПАРКСреднийРиск"">41 - 71 - средний риск;</span>
			|  <span style=""color: ЦветГрадацияСПАРКВысокийРиск"">72 - 100 - высокий риск.</span>'"),
			ОписаниеИндекса);
	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеРасшифровкаСтатуса(Статус)
	
	ЗначениеРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Статус,
			"Название, Описание");
	
	Возврат СтроковыеФункции.ФорматированнаяСтрока(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '<b>%1</b> - %2.
				|
				|<a href = ""%3"">Подробнее о сервисе</a>'"),
			ЗначениеРеквизитов.Название,
			ЗначениеРеквизитов.Описание,
			СПАРКРискиКлиентСервер.АдресСтраницыОписанияСервисаСПАРКРиски()));
	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеНетИнформации()
	
	Возврат СтроковыеФункции.ФорматированнаяСтрока(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Получение справок, индексов и событий мониторинга возможно не по всем типам организаций. 
					|
					|1. Индекс должной осмотрительности (ИДО)  не рассчитывается для следующих типов организаций:
					|     ● Бюджетные учреждения
					|     ● Общественные и религиозные организации: приходы храмов, СОРОО, МОНОО
					|     ● Автономные некоммерческие организации
					|     ● Товарищества собственников жилья
					|     ● Садоводческие, огороднические или дачные некоммерческие товарищества
					|     ● Некоммерческие партнерства: НП, ДНП, СРО
					|     ● Прочие некоммерческие организации: казачьи общества, коллегии адвокатов
					|     ● Экстерриториальные организации
					|     ● Органы общественной самодеятельности
					|     ● Общественные движения
					|     ● Ассоциации и союзы
					|     ● Унитарные предприятия
					|2. Индекс финансового риска (ИФР) и Индекс платежной дисциплины (ИПД) рассчитываются для любых юр. лиц, если есть необходимые исходные данные. Т.к. у банков и страховых компаний свой формат отчетности, Индекс финансового риска (ИФР)  по ним не считается. Также Индекс финансового риска (ИФР) отсутствует для НКО.
					|3. Введен некорректный ИНН.
					|
					|<a href = ""%1"">Подробнее о сервисе</a>'"),
				СПАРКРискиКлиентСервер.АдресСтраницыОписанияСервисаСПАРКРиски()));
	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеБухгалтерскаяОтчетность()
	
	Возврат СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<b>Бухгалтерская отчетность</b> компании в СПАРК увеличивает точность оценки компании в системе, повышает шанс на одобрение кредита банком и снижение процентной ставки.
			|
			|
			|Компания публикует свою бухгалтерскую отчетность в крупнейшей информационной системе СПАРК, источнике информации для сервиса 1СПАРК Риски. Компании, которые делятся своими данными из 1С, получают отметку об этом в признаках хозяйственной деятельности в системе СПАРК и бизнес-справке 1СПАРК Риски. По оценке Deloitte, 74,5% крупных и средних российских компаний используют СПАРК для проверки партнеров и заемщиков.'"));
	
КонецФункции

#КонецОбласти