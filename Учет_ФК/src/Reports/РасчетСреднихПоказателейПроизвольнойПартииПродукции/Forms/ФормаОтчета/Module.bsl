
&НаКлиенте
Процедура ТранспортировочныеМестаТранспортировочноеМестоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ТранспортировочныеМеста.ТекущиеДанные;
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ТранспортировочноеМесто"	,СтрокаТабличнойЧасти.ТранспортировочноеМесто);
	СтруктураДанных.Вставить("Партия"					,ПредопределенноеЗначение("Справочник.ПартииПродукции.ПустаяСсылка"));
	СтруктураДанных.Вставить("ВесБруттоВлажный"			,0);
	СтруктураДанных.Вставить("ВесНеттоВлажный"			,0);
	СтруктураДанных.Вставить("ВесНеттоСухой"			,0);
	СтруктураДанных.Вставить("НомерПломбы"				,"");
	СтруктураДанных.Вставить("Au"						,0);
	СтруктураДанных.Вставить("Ag"						,0);
	СтруктураДанных.Вставить("Sобщ"						,0);
	СтруктураДанных.Вставить("Сорг"						,0);
	СтруктураДанных.Вставить("As"						,0);
	СтруктураДанных.Вставить("Fe"						,0);
	
	ЗаполнитьСтруктуруДанныхВыпуска(СтруктураДанных);
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти,СтруктураДанных,,);
	ПроизвестиРасчетНаКлиенте();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруДанныхВыпуска(СтруктураДанных)
	Если СтруктураДанных.ТранспортировочноеМесто.Пустая() Тогда 
		Возврат
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеЗатаркиТранспортировочныхМест.Партия КАК Партия,
		|	ДанныеЗатаркиТранспортировочныхМест.ВесБруттоВлажный КАК ВесБруттоВлажный,
		|	ДанныеЗатаркиТранспортировочныхМест.ВесНеттоВлажный КАК ВесНеттоВлажный,
		|	ДанныеЗатаркиТранспортировочныхМест.НомерПломбы КАК НомерПломбы,
		|	ДанныеЗатаркиТранспортировочныхМест.НомерМеста КАК НомерМеста,
		|	ВЫРАЗИТЬ(ЕСТЬNULL(ДанныеЗатаркиТранспортировочныхМест.ВесНеттоВлажный, 0) * (100 - ЕСТЬNULL(ДанныеЗатаркиТранспортировочныхМест.Влажность, 0)) * 0.01 КАК ЧИСЛО(10, 3)) КАК ВесНеттоСухой
		|ПОМЕСТИТЬ ДанныеЗатарки
		|ИЗ
		|	РегистрСведений.ДанныеЗатаркиТранспортировочныхМест КАК ДанныеЗатаркиТранспортировочныхМест
		|ГДЕ
		|	ДанныеЗатаркиТранспортировочныхМест.ТранспортировочноеМесто = &ТранспортировочноеМесто
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеЗатарки.Партия КАК Партия,
		|	ДанныеЗатарки.ВесБруттоВлажный КАК ВесБруттоВлажный,
		|	ДанныеЗатарки.ВесНеттоВлажный КАК ВесНеттоВлажный,
		|	ДанныеЗатарки.ВесНеттоСухой КАК ВесНеттоСухой,
		|	ДанныеЗатарки.НомерПломбы КАК НомерПломбы,
		|	ДанныеЗатарки.НомерМеста КАК НомерМеста,
		|	ВЫРАЗИТЬ(ДанныеЗатарки.ВесНеттоСухой * 0.001 * ДанныеЛабораторныхИсследований.СодержаниеAu * 0.001 КАК ЧИСЛО(10, 5)) КАК Au,
		|	ВЫРАЗИТЬ(ДанныеЗатарки.ВесНеттоСухой * 0.001 * ДанныеЛабораторныхИсследований.СодержаниеAg * 0.001 КАК ЧИСЛО(10, 5)) КАК Ag,
		|	ВЫРАЗИТЬ(ДанныеЗатарки.ВесНеттоСухой * 0.001 * ДанныеЛабораторныхИсследований.ПримесиSобщ * 0.01 КАК ЧИСЛО(10, 3)) КАК Sобщ,
		|	ВЫРАЗИТЬ(ДанныеЗатарки.ВесНеттоСухой * 0.001 * ДанныеЛабораторныхИсследований.ПримесиCорг * 0.01 КАК ЧИСЛО(10, 3)) КАК Cорг,
		|	ВЫРАЗИТЬ(ДанныеЗатарки.ВесНеттоСухой * 0.001 * ДанныеЛабораторныхИсследований.ПримесиAs * 0.01 КАК ЧИСЛО(10, 3)) КАК ПрAs,
		|	ВЫРАЗИТЬ(ДанныеЗатарки.ВесНеттоСухой * 0.001 * ДанныеЛабораторныхИсследований.ПримесиFe * 0.01 КАК ЧИСЛО(10, 3)) КАК Fe
		|ИЗ
		|	ДанныеЗатарки КАК ДанныеЗатарки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеЛабораторныхИсследований КАК ДанныеЛабораторныхИсследований
		|		ПО ДанныеЗатарки.Партия = ДанныеЛабораторныхИсследований.Партия";
	
	Запрос.УстановитьПараметр("ТранспортировочноеМесто", СтруктураДанных.ТранспортировочноеМесто);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		СтруктураДанных.ВесБруттоВлажный 	= ВыборкаДетальныеЗаписи.ВесБруттоВлажный;
		СтруктураДанных.ВесНеттоВлажный 	= ВыборкаДетальныеЗаписи.ВесНеттоВлажный;
		СтруктураДанных.ВесНеттоСухой	 	= Окр(ВыборкаДетальныеЗаписи.ВесНеттоСухой,0,РежимОкругления.Окр15как20);
		СтруктураДанных.НомерПломбы 		= ВыборкаДетальныеЗаписи.НомерПломбы;
		СтруктураДанных.Партия 				= ВыборкаДетальныеЗаписи.Партия;
		СтруктураДанных.Au					= ВыборкаДетальныеЗаписи.Au;
		СтруктураДанных.Ag					= ВыборкаДетальныеЗаписи.Ag;
		СтруктураДанных.Sобщ				= ВыборкаДетальныеЗаписи.Sобщ;
		СтруктураДанных.Сорг				= ВыборкаДетальныеЗаписи.Cорг;
		СтруктураДанных.As					= ВыборкаДетальныеЗаписи.ПрAs;
		СтруктураДанных.Fe					= ВыборкаДетальныеЗаписи.Fe;
		
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	параметрыФормы = Новый Структура;
	параметрыФормы.Вставить("РежимВыбора"		,Истина);
	параметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца"		,Истина);
	параметрыФормы.Вставить("ЗакрыватьПриВыборе"		,Ложь);
	ФормаВыбора = ПолучитьФорму("Справочник.ТранспортировочныеМеста.ФормаВыбора",параметрыФормы,ЭтаФорма,,,);
	ФормаВыбора.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы = "Справочник.ТранспортировочныеМеста.Форма.ФормаВыбора" Тогда 
		СтруктураДанных  = Новый Структура();
		СтруктураДанных.Вставить("ВыбранноеЗначение",ВыбранноеЗначение);
		ДобавитьСтрокуНаСервере(СтруктураДанных);
		ПроизвестиРасчетНаКлиенте();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуНаСервере(СтруктураДанных)
	ВыбранноеЗначение = СтруктураДанных.ВыбранноеЗначение;
	
	СтруктураПоиска = Новый Структура();
	СтруктураПоиска.Вставить("ТранспортировочноеМесто",ВыбранноеЗначение);
	НайденныеСтроки = Отчет.ТранспортировочныеМеста.НайтиСтроки(СтруктураПоиска);
	Если НайденныеСтроки.количество() = 0 Тогда 
		НоваяСтр = Отчет.ТранспортировочныеМеста.Добавить();
		
		СтруктураДанных = Новый Структура;
		СтруктураДанных.Вставить("ТранспортировочноеМесто"	,ВыбранноеЗначение);
		СтруктураДанных.Вставить("Партия"					,ПредопределенноеЗначение("Справочник.ПартииПродукции.ПустаяСсылка"));
		СтруктураДанных.Вставить("ВесБруттоВлажный"			,0);
		СтруктураДанных.Вставить("ВесНеттоВлажный"			,0);
		СтруктураДанных.Вставить("ВесНеттоСухой"			,0);
		СтруктураДанных.Вставить("НомерПломбы"				,"");
		СтруктураДанных.Вставить("Au"						,0);
		СтруктураДанных.Вставить("Ag"						,0);
		СтруктураДанных.Вставить("Sобщ"						,0);
		СтруктураДанных.Вставить("Сорг"						,0);
		СтруктураДанных.Вставить("As"						,0);
		СтруктураДанных.Вставить("Fe"						,0);
		ЗаполнитьСтруктуруДанныхВыпуска(СтруктураДанных);
		ЗаполнитьЗначенияСвойств(НоваяСтр,СтруктураДанных,,);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроизвестиРасчетНаКлиенте()
	Если Отчет.ТранспортировочныеМеста.Количество() <> 0 Тогда 
		Отчет.Влажность 		= Окр(((Отчет.ТранспортировочныеМеста.Итог("ВесНеттоВлажный") - Отчет.ТранспортировочныеМеста.Итог("ВесНеттоСухой"))/Отчет.ТранспортировочныеМеста.Итог("ВесНеттоВлажный")) *100,2,РежимОкругления.Окр15как20);
		Отчет.СодержаниеAu 		= Окр(Отчет.ТранспортировочныеМеста.Итог("Au")*1000000/Отчет.ТранспортировочныеМеста.Итог("ВесНеттоСухой") ,2,РежимОкругления.Окр15как20);
		Отчет.СодержаниеAg 		= Окр(Отчет.ТранспортировочныеМеста.Итог("Ag")*1000000/Отчет.ТранспортировочныеМеста.Итог("ВесНеттоСухой") ,2,РежимОкругления.Окр15как20);
		
		Отчет.ПримесиAs 		= Окр(100*Отчет.ТранспортировочныеМеста.Итог("As") / (Отчет.ТранспортировочныеМеста.Итог("ВесНеттоСухой")*0.001) ,2,РежимОкругления.Окр15как20);
		Отчет.ПримесиCорг 		= Окр(100*Отчет.ТранспортировочныеМеста.Итог("Сорг") / (Отчет.ТранспортировочныеМеста.Итог("ВесНеттоСухой")*0.001) ,2,РежимОкругления.Окр15как20);
		Отчет.ПримесиFe 		= Окр(100*Отчет.ТранспортировочныеМеста.Итог("Fe") / (Отчет.ТранспортировочныеМеста.Итог("ВесНеттоСухой")*0.001) ,2,РежимОкругления.Окр15как20);
		Отчет.ПримесиSобщ		= Окр(100*Отчет.ТранспортировочныеМеста.Итог("Sобщ") / (Отчет.ТранспортировочныеМеста.Итог("ВесНеттоСухой")*0.001) ,2,РежимОкругления.Окр15как20);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПаспортЛота(Команда)
	Если ПроверитьЗаполнение() Тогда 
		ТабличныйДокумент =  ПечатьПаспорта();
		ТабличныйДокумент.Показать("Паспорт лота продукции");
	КонецЕсли;	
КонецПроцедуры


Функция ПечатьПаспорта()
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПаспортЛота";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Отчет.РасчетСреднихПоказателейПроизвольнойПартииПродукции.MXL_ПаспортЛотаПродукции");
	
	ОбластьШапка 	= Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока 	= Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал 	= Макет.ПолучитьОбласть("Подвал");
	
	СсылкаНаОбъект = Отчет;
	
    СтруктураДанныхДляПечати = новый Структура;
	
	СтруктураДанныхДляПечати.Вставить("ПредставлениеОрганизации"	,	СокрЛП(СсылкаНаОбъект.Организация.НаименованиеПолное));
	СтруктураДанныхДляПечати.Вставить("ДатаПаспорта"				, 	ТекущаяДата());
	СтруктураДанныхДляПечати.Вставить("ПредставлениеПроизводителя"	, 	pm_ОбщегоНазначения.ПредставлениеЮрЛица(СсылкаНаОбъект.Организация));
	
	СтруктураДанныхДляПечати.Вставить("Номенклатура"				, 	Константы.ОсновнаяНоменклатура.Получить());
	СтруктураДанныхДляПечати.Вставить("КоличествоМест"				, 	СсылкаНаОбъект.ТранспортировочныеМеста.Количество());
	СтруктураДанныхДляПечати.Вставить("ВесПартииБруттоВл"			, 	СсылкаНаОбъект.ТранспортировочныеМеста.Итог("ВесБруттоВлажный"));
	СтруктураДанныхДляПечати.Вставить("ВесПартииНеттоВл"			, 	СсылкаНаОбъект.ТранспортировочныеМеста.Итог("ВесНеттоВлажный"));
	СтруктураДанныхДляПечати.Вставить("Влажность"					, 	СсылкаНаОбъект.Влажность);
	СтруктураДанныхДляПечати.Вставить("ВесПартииСух"				, 	СсылкаНаОбъект.ТранспортировочныеМеста.Итог("ВесНеттоСухой"));
	СтруктураДанныхДляПечати.Вставить("СодAu"						, 	СсылкаНаОбъект.СодержаниеAu);
	СтруктураДанныхДляПечати.Вставить("СодAg"						, 	СсылкаНаОбъект.СодержаниеAg);
	СтруктураДанныхДляПечати.Вставить("Sобщ"						, 	СсылкаНаОбъект.ПримесиSобщ);
	СтруктураДанныхДляПечати.Вставить("Cорг"						, 	СсылкаНаОбъект.ПримесиCорг);
	СтруктураДанныхДляПечати.Вставить("СодAs"						, 	СсылкаНаОбъект.ПримесиAs);
	СтруктураДанныхДляПечати.Вставить("СодFe"						, 	СсылкаНаОбъект.ПримесиFe);
	СтруктураДанныхДляПечати.Вставить("ВсегоAu"						, 	СсылкаНаОбъект.ТранспортировочныеМеста.Итог("Au")*1000);
	СтруктураДанныхДляПечати.Вставить("ВсегоAg"						, 	СсылкаНаОбъект.ТранспортировочныеМеста.Итог("Ag")*1000);
	СтруктураДанныхДляПечати.Вставить("ДатаОтгрузки"				, 	"");
	
	
	ОбластьШапка.Параметры.Заполнить(СтруктураДанныхДляПечати);
	ТабДокумент.Вывести(ОбластьШапка);
	НПП = 1;
	Для каждого СтрокаДанных из СсылкаНаОбъект.ТранспортировочныеМеста Цикл 
		
		СтруктураДанныхСтрокиДляПечати = новый Структура;
		
		СтруктураДанныхСтрокиДляПечати.Вставить("НПП"				, 	НПП);
		СтруктураДанныхСтрокиДляПечати.Вставить("брутто"			, 	СтрокаДанных.ВесБруттоВлажный);
		СтруктураДанныхСтрокиДляПечати.Вставить("нетто"				, 	СтрокаДанных.ВесНеттоВлажный);
		СтруктураДанныхСтрокиДляПечати.Вставить("НомерПломбы"		, 	СтрокаДанных.НомерПломбы);
		
		ОбластьСтрока.Параметры.Заполнить(СтруктураДанныхСтрокиДляПечати);
		НПП = НПП + 1;
		ТабДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;
		
		СтруктураДанныхПодвалаДляПечати = новый Структура;
		СтруктураДанныхПодвалаДляПечати.Вставить("ВесПартииБруттоВл"				,СсылкаНаОбъект.ТранспортировочныеМеста.Итог("ВесБруттоВлажный"));
		СтруктураДанныхПодвалаДляПечати.Вставить("ВесПартииНеттоВл"					,СсылкаНаОбъект.ТранспортировочныеМеста.Итог("ВесНеттоВлажный"));
				
		ОбластьПодвал.Параметры.Заполнить(СтруктураДанныхПодвалаДляПечати);
		ТабДокумент.Вывести(ОбластьПодвал);
		ТабДокумент.ОтображатьСетку = Ложь;
		ТабДокумент.ТолькоПросмотр = Истина;
		ТабДокумент.ОтображатьЗаголовки = Ложь;
	Возврат ТабДокумент;
КонецФункции

