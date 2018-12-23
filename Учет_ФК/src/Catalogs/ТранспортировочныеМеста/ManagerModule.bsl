// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Данные.Ссылка.ИдентификаторТранспортировочногоМеста) Тогда 
		СтандартнаяОбработка = Ложь;
		Представление = СокрЛП(Данные.Ссылка.ИдентификаторТранспортировочногоМеста);
	Иначе
		СтандартнаяОбработка = Истина;
	КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

