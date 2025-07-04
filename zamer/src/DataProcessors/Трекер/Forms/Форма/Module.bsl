
&НаСервереБезКонтекста
Процедура СтартЗадачиНаСервере(Проект, ДатаНачала, Задача)
	
	НаборЗаписей = РегистрыСведений.ЗатраченноеВремя.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(ДатаНачала);
	НаборЗаписей.Отбор.Задача.Установить(Задача);
	НаборЗаписей.Отбор.Проект.Установить(Проект);
	
	Запись = НаборЗаписей.Добавить();
	Запись.Период = ДатаНачала;
	Запись.Задача = Задача;
	Запись.Проект = Проект;
	
	НаборЗаписей.Записать();
		
КонецПроцедуры

&НаКлиенте
Асинх Процедура СтартЗадачи(Команда)
	
	//ОписаниеОповещения = Новый ОписаниеОповещения("СтартЗадачиЗавершение", ЭтотОбъект);
	
	ВведеннаяСтрока = "";
	
	Обещание = ВвестиСтрокуАсинх(ВведеннаяСтрока, "Введите наименование задачи", 500);
	
	Результат = Ждать Обещание;
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Начало = ТекущаяДата();
		ТекущаяЗадача = ВведеннаяСтрока;
		СтартЗадачиНаСервере(Проект, Начало, ТекущаяЗадача);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтартЗадачиЗавершение(Результат, ДопПараметры) Экспорт

	Если ЗначениеЗаполнено(Результат) Тогда
		Начало = ТекущаяДата();
		ТекущаяЗадача = Результат;
		СтартЗадачиНаСервере(Проект, Начало, ТекущаяЗадача);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗафиксироватьДатуОкончания(Проект, ДатаНачала, Задача, ДатаПриостановления)

	НаборЗаписей = РегистрыСведений.ЗатраченноеВремя.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(ДатаНачала);
	НаборЗаписей.Отбор.Задача.Установить(Задача);
	НаборЗаписей.Отбор.Проект.Установить(Проект);
	
	НаборЗаписей.Прочитать();
	
	НаборЗаписей[0].Окончание = ДатаПриостановления;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриостановкаЗадачиНаСервере(Проект, ДатаНачала, Задача, ДатаПриостановления)

	ЗафиксироватьДатуОкончания(Проект, ДатаНачала, Задача, ДатаПриостановления);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриостановкаЗадачи(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриостановкаЗадачиЗавершение", ЭтотОбъект);
	
	ПоказатьВводДаты(ОписаниеОповещения, ТекущаяДата()); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриостановкаЗадачиЗавершение(Результат, ДопПараметры) Экспорт

	Если ЗначениеЗаполнено(Результат) Тогда
		Приостановлена = Результат;
		ПриостановкаЗадачиНаСервере(Проект, Начало, ТекущаяЗадача, Приостановлена);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВозобновитьЗадачу(Команда)
	
	Начало = ТекущаяДата();
	Приостановлена = Неопределено;
	СтартЗадачиНаСервере(Проект, Начало, ТекущаяЗадача);
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьЗадачуНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьЗадачу(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершитьЗадачуЗавершение", ЭтотОбъект);
	
	ПоказатьВводДаты(ОписаниеОповещения, ТекущаяДата());
			
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьЗадачуЗавершение(Результат, ДопПараметры) Экспорт

	Если ЗначениеЗаполнено(Результат) Тогда
		ДатаЗавершения = Результат;
		ЗафиксироватьДатуОкончания(Проект, Начало, ТекущаяЗадача, ДатаЗавершения);
		
		Начало = Неопределено;
		Приостановлена = Неопределено;
		ПрошлоВремени = Неопределено;
		ТекущаяЗадача = Неопределено;
		Проект = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПрошлоВремени()

	Если Не ЗначениеЗаполнено(Начало) Тогда
		Возврат;
	КонецЕсли;
		
	Текущая = ?(ЗначениеЗаполнено(Приостановлена), Приостановлена, ТекущаяДата());
	ПрошлоВремени = (Текущая - Начало) / (60 * 60);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Начало) И Не ЗначениеЗаполнено(Приостановлена) Тогда
		Отказ = Истина;
		ТекстПредупреждения = "Завершите текущую задачу!";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбновитьПрошлоВремени", 120);
	
КонецПроцедуры



