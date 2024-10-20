﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)     
	
	ОбновитьНаСервере();   
	УстановитьВидимостьДоступность(); 
	
КонецПроцедуры 

&НаСервере
Процедура УстановитьВидимостьДоступность()   
	
	Элементы.МикросервисыУИДМикросервиса.Видимость = Объект.РежимОтладки;   
	Элементы.МикросервисыГиперссылка.Видимость = Объект.РежимОтладки;    
	Элементы.МикросервисыИмяПродукта.Видимость = Объект.РежимОтладки; 
	
	Если Объект.Бесплатные И Объект.ДоступныеКУстановке Тогда 
		Элементы.Микросервисы.ОтборСтрок = Новый ФиксированнаяСтруктура("Цена, ДоступнаУстановка", 0,Истина);
	ИначеЕсли Объект.Бесплатные И НЕ Объект.ДоступныеКУстановке Тогда  
		Элементы.Микросервисы.ОтборСтрок = Новый ФиксированнаяСтруктура("Цена", 0);
	ИначеЕсли НЕ Объект.Бесплатные И Объект.ДоступныеКУстановке Тогда  
		Элементы.Микросервисы.ОтборСтрок = Новый ФиксированнаяСтруктура("ДоступнаУстановка", Истина);  
	Иначе 
		Элементы.Микросервисы.ОтборСтрок = Неопределено;
	КонецЕсли;


КонецПроцедуры


&НаСервере
Процедура ОбновитьНаСервере()   
	
	ОбрОбъект = РеквизитФормыВЗначение("Объект"); 
	ОбрОбъект.Инициализация();
	ОбрОбъект.ЗаполнитьМикросервисы();
	ЗначениеВРеквизитФормы(ОбрОбъект,"Объект");

КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДляЭтойКонфигурацииПриИзменении(Элемент)   
	
	Если НЕ Объект.ДляЭтойКонфигурации Тогда 
		Объект.ДляЭтойВерсии = Ложь;
	КонецЕсли;

	ОбновитьНаСервере(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ДляЭтойВерсииПриИзменении(Элемент)
	
	Если Объект.ДляЭтойВерсии Тогда 
		Объект.ДляЭтойКонфигурации = Истина;
	КонецЕсли;
	
	ОбновитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура БесплатныеПриИзменении(Элемент)  
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеКУстановкеПриИзменении(Элемент)
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоВозрастанию(Команда)     
	
	ИмяПоля=Элементы.Микросервисы.ТекущийЭлемент.имя; 
	имяКолонки=СтрЗаменить(ИмяПоля,"Микросервисы","");  
	
	СортироватьНасервере("Микросервисы",имяКолонки,"Возр");

КонецПроцедуры 

&НаСервере
Процедура СортироватьНасервере(имяОбъекта,имяКолонки,ВидСортировки) 
	
    ЭФ= РеквизитФормыВЗначение("Объект");
    ТЗ_объекта=ЭФ[имяОбъекта];
    тз= ТЗ_объекта.Выгрузить();
    колонкасортировки=тз.Колонки.Найти(имяКолонки);
    если колонкасортировки<>Неопределено тогда
        ТЗ_объекта.Сортировать(имяКолонки+" "+ВидСортировки);
    иначе
        //запомним текущую строку
        ткэлемент=элементы[имяОбъекта];
        позиция_стр=Тз_объекта.НайтиПоИдентификатору(ткэлемент.ТекущаяСтрока);
        Идекс_позиции=Тз_объекта.индекс(позиция_стр);
         строкаВтаблице=тз.Получить(Идекс_позиции);


        пдТ= ТекущийЭлемент.ПутьКДанным;
        ПД= ТекущийЭлемент.ТекущийЭлемент.ПутьКДанным;
        пд= СтрЗаменить(ПД,пдТ+".","");
        // получим основную и дополнительную колонку
         основннаяКолонка=лев(пд,найти(пд,".")-1);
         допколонка=СтрЗаменить(пд,основннаяКолонка+".","");
         тз.Колонки.Добавить( имяКолонки);
        //заполним поля для сортировки
        для каждого элементаТЗ из тз цикл
            тзобъекта= элементаТз[основннаяКолонка] ;
            элементаТз[имяКолонки]=вычислить("тзобъекта."+допколонка);
         конеццикла;
         тз.Сортировать(имяКолонки+" "+ВидСортировки);
         индексТЗпослеСортировки=ТЗ.Индекс(строкаВтаблице);
         ТЗ_объекта.Загрузить(тз);
          //восстановим курсор на нужную строку
          позиция_стр= ТЗ_объекта.Получить( индексТЗпослеСортировки);
          ткэлемент.ТекущаяСтрока=позиция_стр.ПолучитьИдентификатор();
     конецесли;

     ЗначениеВРеквизитФормы(Эф,"Объект"); 
	 
конецпроцедуры

&НаКлиенте
Процедура СортироватьПоУбыванию(Команда) 
	
	ИмяТЧ=ТекущийЭлемент.Имя;
	ИмяПоля=ТекущийЭлемент.ТекущийЭлемент.имя; 
	имяКолонки=СтрЗаменить(ИмяПоля,ИмяТЧ,"");  
	
	СортироватьНасервере(ИмяТЧ,имяКолонки,"Убыв");

КонецПроцедуры

&НаКлиенте
Процедура МикросервисыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)  
	
	ТекущиеДанные = Элементы.Микросервисы.ТекущиеДанные;
	Если ТекущиеДанные=Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("УИДМикросервиса",ТекущиеДанные.УИДМикросервиса);
	ОткрытьФорму("ВнешняяОбработка.АгрегаторМикросервисов.Форма.ФормаМикросервиса", ПараметрыОткрытия,,ТекущиеДанные.УИДМикросервиса);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ДоступноОбновлениеТекущегоМикросервиса() Тогда 
		ОткрытьФорму("ВнешняяОбработка.АгрегаторМикросервисов.Форма.ОбновлениеМикросервиса",,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДоступноОбновлениеТекущегоМикросервиса()
	ОбрОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ОбрОбъект.ДоступноОбновлениеМикросервиса(Объект.УИДТекущегоМикросервиса);
КонецФункции