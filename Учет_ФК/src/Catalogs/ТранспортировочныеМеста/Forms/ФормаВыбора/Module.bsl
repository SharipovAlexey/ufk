&НаКлиенте
Процедура ОтборПартияПриИзменении(Элемент)
	ОтборПартияИспользование = ЗначениеЗаполнено(ОтборПартия);
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Партия");
КонецПроцедуры

&НаКлиенте
Процедура ОтборПартияИспользованиеПриИзменении(Элемент)
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Партия");
КонецПроцедуры
