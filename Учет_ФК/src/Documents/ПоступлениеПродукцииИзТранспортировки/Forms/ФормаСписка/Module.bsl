
&НаКлиенте
Процедура ОтборСкладПолучательИспользованиеПриИзменении(Элемент)
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "СкладПолучатель");
КонецПроцедуры

&НаКлиенте
Процедура ОтборСкладПолучательПриИзменении(Элемент)
	ОтборСкладПолучательИспользование = ЗначениеЗаполнено(ОтборСкладПолучатель);
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "СкладПолучатель");
КонецПроцедуры
