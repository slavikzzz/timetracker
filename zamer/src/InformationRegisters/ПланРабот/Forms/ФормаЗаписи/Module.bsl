
&НаКлиенте
Процедура ВыполненаПриИзменении(Элемент)
	
	Если Запись.Выполнена Тогда
		Запись.ДатаЗавершения = ТекущаяДата();
	Иначе
		Запись.ДатаЗавершения = Неопределено;	
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если Не ЗначениеЗаполнено(Запись.ДатаРегистрации) Тогда
		Запись.ДатаРегистрации = ТекущаяДата();		
	КонецЕсли;
		
КонецПроцедуры
