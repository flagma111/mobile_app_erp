
&НаСервере
Процедура ПолучитьСписокДокументовОтВебСервиса()//Ден  2017 10 03 ---
	СписокДокументов.Очистить();
	Логин = Константы.Логин.Получить();
	Пароль = Константы.Пароль.Получить();	
	Попытка
		ОпределениеWS = Новый WSОпределения("http://localhost/TestBase/ws/mobile_erp?wsdl",Логин,Пароль);
		Прокси = Новый WSПрокси(ОпределениеWS, "http://www.galamart.org/mobile_erp", "mobile_erp", "mobile_erpSoap");
		Прокси.Пользователь = Логин;
		Прокси.Пароль = Пароль;
	Исключение
		Сообщить("Ошибка соединения с сервером!");
		Возврат;
	КонецПопытки;
	
	Если НЕ Прокси = Неопределено Тогда
		Попытка
			СписокДокументовXML = Прокси.GetReconciliationList();
		Исключение
			Сообщить(ОписаниеОшибки());	
		КонецПопытки;		
	КонецЕсли;
	
	Если ТипЗнч(СписокДокументовXML) <> тип("Строка") или СписокДокументовXML = "" Тогда
		Сообщить("Не удалось получить данные списка документов от сервера!");
		Возврат;
	КонецЕсли;
	
	ЧтениеХМЛ = Новый ЧтениеXML;
	ЧтениеХМЛ.УстановитьСтроку(СписокДокументовXML);
	СписокДокументовОтСервера = СериализаторXDTO.ПрочитатьXML(ЧтениеХМЛ);
	ЧтениеХМЛ.Закрыть();
	
	Для Каждого СтрокаДокументов из СписокДокументовОтСервера Цикл
		ЗаполнитьЗначенияСвойств(СписокДокументов.Добавить(),СтрокаДокументов);
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)//Ден  2017 10 03 ---
	ПолучитьСписокДокументовОтВебСервиса();
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)//Ден  2017 10 04 ---
	ДанныеТекущейСтроки = элементы.СписокДокументов.ТекущиеДанные;
	Если ДанныеТекущейСтроки <> Неопределено и ДанныеТекущейСтроки.ДокументUID <> "" Тогда
		ОткрытьФорму("ОбщаяФорма.ФормаДокументаДляВизирования",новый Структура("ДокументUID",ДанныеТекущейСтроки.ДокументUID),,,,,новый ОписаниеОповещения("ПриЗакрытииФормыДокумента",ЭтотОбъект));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытииФормыДокумента(Результат,ДополнительныеПараметры) Экспорт//Ден  2017 10 04 ---
	Если ЗначениеЗаполнено(Результат) Тогда
		МассивУдаляемойСтроки = СписокДокументов.НайтиСтроки(новый Структура("ДокументUID",Результат));
		Если МассивУдаляемойСтроки.количество() Тогда
			СписокДокументов.Удалить(МассивУдаляемойСтроки[0]);	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокумент(Команда)//Ден  2017 10 05 ---
	ДанныеТекущейСтроки = элементы.СписокДокументов.ТекущиеДанные;
	Если ДанныеТекущейСтроки <> Неопределено и ДанныеТекущейСтроки.ДокументUID <> "" Тогда
		ОткрытьФорму("ОбщаяФорма.ФормаДокументаДляВизирования",новый Структура("ДокументUID",ДанныеТекущейСтроки.ДокументUID),,,,,новый ОписаниеОповещения("ПриЗакрытииФормыДокумента",ЭтотОбъект));
	КонецЕсли;	
КонецПроцедуры

