
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Если Не ДополнительныеСвойства.Свойство("ПропуститьОбновлениеВерсииДатЗапретаИзменения") Тогда
			ОбновитьВерсиюДатЗапретаИзмененияПриЗагрузкеДанных();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьВерсиюДатЗапретаИзмененияПриЗагрузкеДанных()
	
	// Изменения в обычном режиме записи регистрируются в общем модуле ПользователиСлужебный
	// в процедуре ПослеОбновленияСоставовГруппПользователейПереопределяемый.
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		МодульДатыЗапретаИзмененияСлужебный = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзмененияСлужебный");
		МодульДатыЗапретаИзмененияСлужебный.ОбновитьВерсиюДатЗапретаИзмененияПриЗагрузкеДанных(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

