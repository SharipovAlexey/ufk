
&НаКлиенте
Процедура СведенияОПользователе(Команда)
	ПоказатьЗначение(, АвторизованныйПользователь);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
		
	ВыполнитьПроверкуПравДоступа("СохранениеДанныхПользователя", Метаданные);
		
	// СтандартныеПодсистемы.Пользователи
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	// Конец СтандартныеПодсистемы.Пользователи
	
	ОсновнаяОрганизация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиФК",
	"ОсновнаяОрганизация",
	Справочники.Организации.ПустаяСсылка());
	
	ОсновнойСклад = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиФК",
	"ОсновнойСклад",
	Справочники.Склады.ПустаяСсылка());
			
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемПодтверждениеПолучено", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(ОписаниеОповещения, Отказ, ЗавершениеРаботы,, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПодтверждениеПолучено(РезультатВопроса, ДополнительныеПараметры) Экспорт
	ЗаписатьИЗакрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Настройки = Новый Массив;
				
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиФК",
	"ОсновнойСклад",
	ОсновнойСклад));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиФК",
	"ОсновнаяОрганизация",
	ОсновнаяОрганизация));
			
	Модифицированность = Ложь;
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассивИОбновитьПовторноИспользуемыеЗначения(Настройки);
	Закрыть();
	
КонецПроцедуры

Функция ОписаниеНастройки(Объект, Настойка, Значение)
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", Объект);
	Элемент.Вставить("Настройка", Настойка);
	Элемент.Вставить("Значение", Значение);
	
	Возврат Элемент;
	
КонецФункции
