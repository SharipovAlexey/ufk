
Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ДанныеПаспортовКачества.Записывать = Истина;
	Движение = Движения.ДанныеПаспортовКачества.Добавить();
	Движение.ПартияПродукции 	= ПартияПродукции;
	Движение.ПаспортКачества 	= Ссылка;
	Движение.Контрагент 		= Контрагент;
КонецПроцедуры


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = Справочники.Организации.ОрганизацияПоУмолчанию(ПараметрыСеанса.ТекущийПользователь.Наименование);
КонецПроцедуры


Процедура ПриКопировании(ОбъектКопирования)
	Ответственный = Пользователи.ТекущийПользователь();
КонецПроцедуры

