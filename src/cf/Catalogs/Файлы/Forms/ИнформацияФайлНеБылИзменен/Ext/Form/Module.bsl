﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БольшеНеПоказывать = Не Параметры.ПоказыватьИнформациюЧтоФайлНеБылИзменен;
	КомментарийКВерсии = Параметры.КомментарийКВерсии;
	
	ТекстНапоминания = 
	НСтр("ru = 'Версия не была создана, т.к. файл не был изменен на вашем компьютере. Комментарий не сохранен:'");
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)

	Если БольшеНеПоказывать = Истина Тогда
		ПоказыватьИнформациюЧтоФайлНеБылИзменен = Не БольшеНеПоказывать;
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
			"НастройкиПрограммы", "ПоказыватьИнформациюЧтоФайлНеБылИзменен", ПоказыватьИнформациюЧтоФайлНеБылИзменен,,, Истина);
	КонецЕсли;
	
	Закрыть(БольшеНеПоказывать);
	
КонецПроцедуры
