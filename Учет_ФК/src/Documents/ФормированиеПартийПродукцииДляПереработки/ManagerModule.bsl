// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область ПрограммныйИнтерфейс
// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "УчетФлотоконцентратаПоПартиям";
	КомандаПечати.Представление = НСтр("ru = 'Параметры партии переработки'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок       = 1;
			
КонецПроцедуры
#КонецОбласти

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "УчетФлотоконцентратаПоПартиям") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "УчетФлотоконцентратаПоПартиям", "Учет флотоконцентрата по партиям",
			СформироватьПечатнуюФормуУчетФлотоконцентратаПоПартиям(МассивОбъектов, ОбъектыПечати, ПараметрыПечати),,);
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьНаименованиеПоставщика(Ссылка)
	
	ТаблицаПродукции = Ссылка.Продукция.Выгрузить();
	ТаблицаПродукции.Свернуть("ПартияПродукции","");
	Если ТаблицаПродукции.Количество()=1 Тогда
		ПартияТабличнойЧасти 		= ТаблицаПродукции[0].ПартияПродукции;
		Если НЕ ПартияТабличнойЧасти = Неопределено Тогда 
			НаименованиеВладельцаПартии	= pm_ОбщегоНазначения.ОписаниеОрганизации(ПартияТабличнойЧасти.ОрганизацияВладелец,"НаименованиеСокращенное");
		Иначе 
			НаименованиеВладельцаПартии	= "";
		КонецЕсли;
		Возврат НаименованиеВладельцаПартии
	Иначе 
		Возврат "";
	КонецЕсли;
		
КонецФункции

Функция СформироватьПечатнуюФормуУчетФлотоконцентратаПоПартиям(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ТабличныйДокумент 							= Новый ТабличныйДокумент;
	ТабличныйДокумент.РазмерКолонтитулаСверху 	= 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу 	= 0;
	ТабличныйДокумент.ПолеСлева					= 25;
	ТабличныйДокумент.АвтоМасштаб 				= Истина;
	ТабличныйДокумент.ОриентацияСтраницы 		= ОриентацияСтраницы.Ландшафт;
	
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УчетФлотоконцентратаПоПартиям";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ФормированиеПартийПродукцииДляПереработки.ПФ_MXL_УчетФлотоконцентратаПоПартиям");

	ОбластьШапка	= Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока	= Макет.ПолучитьОбласть("Строка");
	ОбластьИтог		= Макет.ПолучитьОбласть("Итог");
	
	Для Каждого СсылкаНаОбъект Из МассивОбъектов Цикл 
		
		НаименованиеОрганизации 										= pm_ОбщегоНазначения.ОписаниеОрганизации(СсылкаНаОбъект.Организация,"НаименованиеСокращенное");
		НаименованиеОрганизацииПоставщика								= ПолучитьНаименованиеПоставщика(СсылкаНаОбъект);
		ОбластьШапка.Параметры.ЗаголовокОтчета 							= "Параметры партии флотоконцентрата для переработки № "+СокрЛП(СсылкаНаОбъект.НомерПартииПереработки)+", Производитель продукции: " + НаименованиеОрганизации;
		ОбластьШапка.Параметры.НаименованиеОрганизацииПартии 			= "№ партии переработки";
		ОбластьШапка.Параметры.НаименованиеОрганизацииПоставщикаПартии	= "№ партии производителя";
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ДанныеПодготовкиКПереработке.ТранспортировочноеМесто КАК ТранспортировочноеМесто
			|ПОМЕСТИТЬ вт_ДанныеПодготовкиКПереработки
			|ИЗ
			|	РегистрСведений.ДанныеПодготовкиКПереработке КАК ДанныеПодготовкиКПереработке
			|ГДЕ
			|	ДанныеПодготовкиКПереработке.Регистратор.Ссылка = &Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	вт_ДанныеПодготовкиКПереработки.ТранспортировочноеМесто.Код КАК ТранспортировочноеМесто,
			|	ДанныеЗатаркиТранспортировочныхМест.Партия.Код КАК НомПартииПоставщик,
			|	ДанныеЗатаркиТранспортировочныхМест.ВесБруттоВлажный КАК ВесБруттоСырой,
			|	ДанныеЗатаркиТранспортировочныхМест.ВесНеттоВлажный КАК ВесНеттоСырой,
			|	ДанныеЗатаркиТранспортировочныхМест.Влажность КАК Влажность,
			|	ДанныеЗатаркиТранспортировочныхМест.НомерМеста КАК НомерМеста,
			|	ВЫРАЗИТЬ(ДанныеЗатаркиТранспортировочныхМест.ВесНеттоВлажный - ДанныеЗатаркиТранспортировочныхМест.ВесНеттоВлажный * ДанныеЗатаркиТранспортировочныхМест.Влажность / 100 КАК ЧИСЛО(15, 0)) КАК ВесНеттоСухой,
			|	ЕСТЬNULL(ДанныеЛабораторныхИсследований.СодержаниеAu, 0) КАК СодержаниеЗолота,
			|	ЕСТЬNULL(ДанныеЛабораторныхИсследований.СодержаниеAg, 0) КАК СодержаниеСеребра,
			|	ЕСТЬNULL(ДанныеЛабораторныхИсследований.ПримесиSобщ, 0) КАК СодержаниеСеры,
			|	ЕСТЬNULL(ДанныеЛабораторныхИсследований.ПримесиCорг, 0) КАК СодержаниеУглеродов,
			|	ЕСТЬNULL(ДанныеЛабораторныхИсследований.ПримесиAs, 0) КАК СодержаниеМышьяка,
			|	ЕСТЬNULL(ДанныеЛабораторныхИсследований.ПримесиFe, 0) КАК СодержаниеЖелеза
			|ИЗ
			|	вт_ДанныеПодготовкиКПереработки КАК вт_ДанныеПодготовкиКПереработки
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеЗатаркиТранспортировочныхМест КАК ДанныеЗатаркиТранспортировочныхМест
			|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеЛабораторныхИсследований КАК ДанныеЛабораторныхИсследований
			|			ПО (ДанныеЛабораторныхИсследований.Партия = ДанныеЗатаркиТранспортировочныхМест.Партия)
			|		ПО вт_ДанныеПодготовкиКПереработки.ТранспортировочноеМесто = ДанныеЗатаркиТранспортировочныхМест.ТранспортировочноеМесто";
		
		Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		ИтогоВесБруттоСырой 		= 0;
		ИтогоВесНеттоСырой 			= 0;
		ИтогоВлажность 				= 0;
		ИтогоВесНеттоСухой 			= 0;
		ИтогоСодержаниеЗолота 		= 0;
		ИтогоСодержаниеСеребра 		= 0;
		ИтогоСодержаниеСеры 		= 0;
		ИтогоСодержаниеУглеродов 	= 0;
		ИтогоСодержаниеМышьяка 		= 0;
		ИтогоСодержаниеЖелеза 		= 0;
		ИтогоКоличествоЗолота 		= 0;
		ИтогоКоличествоСеребра 		= 0;
		ИтогоКоличествоСеры 		= 0;
		ИтогоКоличествоУглеродов	= 0;
		ИтогоКоличествоМышьека 		= 0;
		ИтогоКоличествоЖелеза 		= 0;
		
		
		Ном = 0;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(ОбластьСтрока.Параметры,ВыборкаДетальныеЗаписи);
			Ном = Ном+1;
			
			ОбластьСтрока.Параметры.НомПартии = СсылкаНаОбъект.НомерПартииПереработки;
			КолЗолота 		= Окр(ВыборкаДетальныеЗаписи.ВесНеттоСухой*ВыборкаДетальныеЗаписи.СодержаниеЗолота/1000,2);
			КолСеребра 		= Окр(ВыборкаДетальныеЗаписи.ВесНеттоСухой*ВыборкаДетальныеЗаписи.СодержаниеСеребра/1000,2);
			КолСеры 		= Окр(ВыборкаДетальныеЗаписи.ВесНеттоСухой*ВыборкаДетальныеЗаписи.СодержаниеСеры/1000,2);
			КолУглеродов	= Окр(ВыборкаДетальныеЗаписи.ВесНеттоСухой*ВыборкаДетальныеЗаписи.СодержаниеУглеродов/1000,2);
			КолМышьека 		= Окр(ВыборкаДетальныеЗаписи.ВесНеттоСухой*ВыборкаДетальныеЗаписи.СодержаниеМышьяка/1000,2);
			КолЖелеза 		= Окр(ВыборкаДетальныеЗаписи.ВесНеттоСухой*ВыборкаДетальныеЗаписи.СодержаниеЖелеза/1000,2);
									
			ОбластьСтрока.Параметры.Ном = Ном;
			ОбластьСтрока.Параметры.КоличествоЗолота 	= КолЗолота;
			ОбластьСтрока.Параметры.КоличествоСеребра 	= КолСеребра;
			ОбластьСтрока.Параметры.КоличествоСеры 		= КолСеры;
			ОбластьСтрока.Параметры.КоличествоУглеродов	= КолУглеродов;
			ОбластьСтрока.Параметры.КоличествоМышьека 	= КолМышьека;
			ОбластьСтрока.Параметры.КоличествоЖелеза 	= КолЖелеза;
			
			ИтогоВесБруттоСырой 		= ИтогоВесБруттоСырой+ВыборкаДетальныеЗаписи.ВесБруттоСырой;
			ИтогоВесНеттоСырой 			= ИтогоВесНеттоСырой+ВыборкаДетальныеЗаписи.ВесНеттоСырой;
			ИтогоВесНеттоСухой 			= ИтогоВесНеттоСухой+ВыборкаДетальныеЗаписи.ВесНеттоСухой;
			ИтогоКоличествоЗолота 		= ИтогоКоличествоЗолота+КолЗолота;
			ИтогоКоличествоСеребра 		= ИтогоКоличествоСеребра+КолСеребра;
			ИтогоКоличествоСеры 		= ИтогоКоличествоСеры+КолСеры;
			ИтогоКоличествоУглеродов	= ИтогоКоличествоУглеродов+КолУглеродов;
			ИтогоКоличествоМышьека 		= ИтогоКоличествоМышьека+КолМышьека;
			ИтогоКоличествоЖелеза 		= ИтогоКоличествоЖелеза+КолЖелеза;
			
			ТабличныйДокумент.Вывести(ОбластьСтрока);
		КонецЦикла;
		ОбластьИтог.Параметры.ИтогоВесБруттоСырой 		= ИтогоВесБруттоСырой;
		ОбластьИтог.Параметры.ИтогоВесНеттоСырой 		= ИтогоВесНеттоСырой;
		ОбластьИтог.Параметры.ИтогоВлажность 			= Окр(100-(ИтогоВесНеттоСухой*100)/ИтогоВесНеттоСырой,2);
		ОбластьИтог.Параметры.ИтогоВесНеттоСухой 		= ИтогоВесНеттоСухой;
		ОбластьИтог.Параметры.ИтогоСодержаниеЗолота 	= Окр((ИтогоКоличествоЗолота/ИтогоВесНеттоСухой)*1000,2);
		ОбластьИтог.Параметры.ИтогоСодержаниеСеребра 	= Окр((ИтогоКоличествоСеребра/ИтогоВесНеттоСухой)*1000,2);
		ОбластьИтог.Параметры.ИтогоСодержаниеСеры 		= Окр((ИтогоКоличествоСеры/ИтогоВесНеттоСухой)*1000,2);
		ОбластьИтог.Параметры.ИтогоСодержаниеУглеродов 	= Окр((ИтогоКоличествоУглеродов/ИтогоВесНеттоСухой)*1000,2);
		ОбластьИтог.Параметры.ИтогоСодержаниеМышьяка 	= Окр((ИтогоКоличествоМышьека/ИтогоВесНеттоСухой)*1000,2);
		ОбластьИтог.Параметры.ИтогоСодержаниеЖелеза 	= Окр((ИтогоКоличествоЖелеза/ИтогоВесНеттоСухой)*1000,2);
		ОбластьИтог.Параметры.ИтогоКоличествоЗолота 	= ИтогоКоличествоЗолота;
		ОбластьИтог.Параметры.ИтогоКоличествоСеребра 	= ИтогоКоличествоСеребра;
		ОбластьИтог.Параметры.ИтогоКоличествоСеры 		= ИтогоКоличествоСеры;
		ОбластьИтог.Параметры.ИтогоКоличествоУглеродов	= ИтогоКоличествоУглеродов;
		ОбластьИтог.Параметры.ИтогоКоличествоМышьека 	= ИтогоКоличествоМышьека;
		ОбластьИтог.Параметры.ИтогоКоличествоЖелеза 	= ИтогоКоличествоЖелеза;
		ТабличныйДокумент.Вывести(ОбластьИтог);

	КонецЦикла;
	
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	
	Возврат ТабличныйДокумент;

КонецФункции

