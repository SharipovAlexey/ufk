
#Область ОбработчикиСобытийФормы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Предопределенный Тогда
		Элементы.ГруппаНаименование.ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Справочник.СтраныМира.Изменение", Объект.Ссылка, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти
