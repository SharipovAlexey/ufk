
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = Справочники.Организации.ОрганизацияПоУмолчанию(ПараметрыСеанса.ТекущийПользователь.Наименование);	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Ответственный = Пользователи.ТекущийПользователь();
КонецПроцедуры
