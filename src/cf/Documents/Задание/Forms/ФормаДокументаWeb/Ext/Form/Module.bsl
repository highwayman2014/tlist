﻿
&НаКлиенте
Процедура СписокИсполнителейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Исполнитель = Объект.ОтветственныйИсполнитель;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТрудозатратыИсполнителейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Исполнитель = ТекущийПользователь; 
		Элемент.ТекущиеДанные.Дата = Текущаядата();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЧасыПриИзменении(Элемент)
	ПересчитатьЗатраченноеВремя();
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьЗатраченноеВремя()
	Строка = ПолучитьТекущуюСтрокуТрудозатратыИсполнителей();
	Строка.ЗатраченноеВремя = Строка.Часы + (Строка.Минуты / 60);
КонецПроцедуры

&НаКлиенте
// Функция возвращает ссылку на текущую строку в ТрудозатратыИсполнителей 
// 
// Параметры: 
//  Нет. 
// 
// Возвращаемое значение: 
//  СправочникСсылка.Товары - Текущий товар в списке.
Функция ПолучитьТекущуюСтрокуТрудозатратыИсполнителей()
	Возврат Элементы.ТрудозатратыИсполнителей.ТекущиеДанные;
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    Если ДокументНаходитсяВГраницеЗапретаИзменений() Тогда
    	ЭтаФорма.Элементы.Статус.ТолькоПросмотр = Истина;
    	ЭтаФорма.Элементы.ДатаПриемки.ТолькоПросмотр = Истина;
    КонецЕсли; 
    Если Не РольПостановщик Тогда
		ЭтаФорма.Элементы.Дата.ТолькоПросмотр = Истина;
		ЭтаФорма.Элементы.ГруппаСписокИсполнителей.ТолькоПросмотр = Истина;
		#Если ВебКлиент Тогда
			ЭтаФорма.Элементы.ДокументОснование.ТолькоПросмотр = Истина;
			ЭтаФорма.Элементы.Тема.ТолькоПросмотр = Истина;
			ЭтаФорма.Элементы.Постановщик.ТолькоПросмотр = Истина;
			ЭтаФорма.Элементы.Конфигурация.ТолькоПросмотр = Истина;
			ЭтаФорма.Элементы.Срочность.ТолькоПросмотр = Истина;
			//ЭтаФорма.Элементы.Статус.ТолькоПросмотр = Истина;
			ЭтаФорма.Элементы.Заказчик.ТолькоПросмотр = Истина;
			ЭтаФорма.Элементы.ОтветственныйИсполнитель.ТолькоПросмотр = Истина;
		#КонецЕсли                 	
	КонецЕсли;
	
	Если Не РольАдминистратор Тогда
		ПоляДляБлокировки = Новый Структура("НачалоПлан, ОкончаниеПлан, ПлановыеТрудозатраты");
		Для Каждого Элт Из ПоляДляБлокировки Цикл 
			//ЭтаФорма.Элементы[Элт.Ключ].Доступность = Не ЗначениеЗаполнено(Объект[Элт.Ключ]);
		КонецЦикла;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция ДокументНаходитсяВГраницеЗапретаИзменений()
    мДатаЗапретаРедактированияПринятыхТлистов = Константы.ДатаЗапретаРедактированияПринятыхТлистов.Получить();
    
    Если ЗначениеЗаполнено(Объект.Ссылка.ДатаПриемки) И Объект.Ссылка.ДатаПриемки <= мДатаЗапретаРедактированияПринятыхТлистов И Объект.Ссылка.Статус = Перечисления.Статус.Принято Тогда
        Возврат Истина;
    Иначе
        Возврат Ложь;
    КонецЕсли; 
КонецФункции


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Объект.Постановщик) Тогда
	    Объект.Постановщик = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.Статус) Тогда
	    Объект.Статус = Перечисления.Статус.Новое;
	КонецЕсли;
	РольПостановщик = РольДоступна("Постановщик");
	РольАдминистратор = РольДоступна("Администратор");
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	ТекущийПользовательПустаяСсылка = Справочники.Пользователи.ПустаяСсылка();
	ПеречислениеОтвет = Перечисления.ВидОбсуждения.Ответ;
	ПеречислениеВопрос = Перечисления.ВидОбсуждения.Вопрос;
	ПеречислениеОжидает = Перечисления.Статус.Ожидает;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлВыполнить()
    
    Если ПроверитьЭтоНовоеЗадание() Тогда
        // В новое добавить нельзя
        Возврат;    	
    КонецЕсли; 
    
	Если ЕстьЛиУжеСохраненныйФайл("ИмяФайла1") Тогда
		Возврат;
	КонецЕсли; 
	
	ВыбратьФайлСДискаИСохранить("Файл1","ИмяФайла1");
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЭтоНовоеЗадание()
    Если Параметры.Ключ.Пустая() Тогда
		Ответ = Вопрос("Сначала необходимо записать эту задачу. Записать?", РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ЭтотОбъект.Записать();
			Возврат Ложь;
		Иначе
			Возврат Истина;
		КонецЕсли;  
    Иначе     
		Возврат Ложь;
    КонецЕсли;    
КонецФункции
 

&НаКлиенте
Функция ЕстьЛиУжеСохраненныйФайл(РеквизитИмяФайла)

	Если ЗначениеЗаполнено(Объект[РеквизитИмяФайла]) Тогда
		Если Вопрос("В этом документе уже есть сохраненный файл!
					|"""+Объект[РеквизитИмяФайла]+""" будет удален!
					|Вы хотите переписать его новым файлом?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат Истина;
		КонецЕсли; 
	КонецЕсли; 
	
    Возврат Ложь;
КонецФункции
 

&НаКлиенте
Процедура ВыбратьФайлСДискаИСохранить(РеквизитФайл, РеквизитИмяФайла)
	Перем ВыбранноеИмя;
	Перем АдресВременногоХранилища;
	АдресВременногоХранилища = "";
	Если ПоместитьФайл(АдресВременногоХранилища, ВыбранноеИмя, ВыбранноеИмя, Истина, УникальныйИдентификатор) Тогда
		//ФайлПутьНаДиске = Новый Файл(ВыбранноеИмя);
		Объект[РеквизитИмяФайла] = ВыбранноеИмя;
		ПоместитьФайлОбъекта(АдресВременногоХранилища, РеквизитФайл, РеквизитИмяФайла);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоместитьФайлОбъекта(АдресВременногоХранилища, РеквизитФайл, РеквизитИмяФайла)
	ЭлементДокумент = РеквизитФормыВЗначение("Объект");
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	ЭлементДокумент[РеквизитФайл] = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных());
	ФайлПутьНаДиске = Новый Файл(ЭлементДокумент[РеквизитИмяФайла]);
	ЭлементДокумент[РеквизитИмяФайла] = ФайлПутьНаДиске.Имя;
	ЭлементДокумент.Записать();
	//Модифицированность = Ложь;
	УдалитьИзВременногоХранилища(АдресВременногоХранилища);
	ЗначениеВРеквизитФормы(ЭлементДокумент, "Объект");
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФайлВыполнить()
	ПрочитатьФайлИСохранитьНаДиск("Файл1","ИмяФайла1");
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлИСохранитьНаДиск(РеквизитФайл, РеквизитИмяФайла)
	Если НЕ ЗначениеЗаполнено(Объект[РеквизитИмяФайла]) Тогда
		Возврат;
	КонецЕсли; 
	НавигационнаяСсылкаФайла = ПолучитьНавигационнуюСсылку(Объект.Ссылка, РеквизитФайл);
	// Какая то ошибка, функция возвращает неправильную  ссылку. Поэтому корректируем
	НавигационнаяСсылкаФайла = СтрЗаменить(НавигационнаяСсылкаФайла,"?e=","?ref="); 
	ПолучитьФайл(НавигационнаяСсылкаФайла, Объект[РеквизитИмяФайла], Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФайлВыполнить()
	УдалитьФайлИзХранилища("Файл1","ИмяФайла1");
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайлИзХранилища(РеквизитФайл, РеквизитИмяФайла)

	Если НЕ ЗначениеЗаполнено(Объект[РеквизитИмяФайла]) Тогда
		Возврат;
	КонецЕсли; 
	
	Если Вопрос("Вы действительно хотите удалить файл "+Объект[РеквизитИмяФайла]+" из этого документа?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет  Тогда
	    Возврат;
	КонецЕсли; 
	
	Объект[РеквизитИмяФайла] = "";
	ОчиститьФайл(РеквизитФайл, РеквизитИмяФайла);

КонецПроцедуры

&НаСервере
Процедура ОчиститьФайл(РеквизитФайл, РеквизитИмяФайла)

	ЭлементДокумент = РеквизитФормыВЗначение("Объект");
	ЭлементДокумент[РеквизитИмяФайла] = "";
	ЭлементДокумент[РеквизитФайл] = Неопределено;
	ЭлементДокумент.Записать();

КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОФайлеНажатие(Элемент, СтандартнаяОбработка)
	ПрочитатьФайлИСохранитьНаДиск("Файл1","ИмяФайла1");
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайла2Нажатие(Элемент, СтандартнаяОбработка)
	ПрочитатьФайлИСохранитьНаДиск("Файл2","ИмяФайла2");
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайла3Нажатие(Элемент, СтандартнаяОбработка)
	ПрочитатьФайлИСохранитьНаДиск("Файл3","ИмяФайла3");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл2Выполнить()
    Если ПроверитьЭтоНовоеЗадание() Тогда
        // В новое добавить нельзя
        Возврат;    	
    КонецЕсли; 
    
	Если ЕстьЛиУжеСохраненныйФайл("ИмяФайла2") Тогда
		Возврат;
	КонецЕсли; 
	ВыбратьФайлСДискаИСохранить("Файл2","ИмяФайла2");
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФайл2Выполнить()
	ПрочитатьФайлИСохранитьНаДиск("Файл2","ИмяФайла2");
КонецПроцедуры

&НаКлиенте
Процедура ОчиcтитьФайл2Выполнить()
	УдалитьФайлИзХранилища("Файл2","ИмяФайла2");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл3Выполнить()
    Если ПроверитьЭтоНовоеЗадание() Тогда
        // В новое добавить нельзя
        Возврат;    	
    КонецЕсли; 
    
	Если ЕстьЛиУжеСохраненныйФайл("ИмяФайла3") Тогда
		Возврат;
	КонецЕсли; 
	ВыбратьФайлСДискаИСохранить("Файл3","ИмяФайла3");
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФайл3Выполнить()
	ПрочитатьФайлИСохранитьНаДиск("Файл3","ИмяФайла3");
КонецПроцедуры

&НаКлиенте
Процедура ОчиcтитьФайл3Выполнить()
	УдалитьФайлИзХранилища("Файл3","ИмяФайла3");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл4Выполнить()
    Если ПроверитьЭтоНовоеЗадание() Тогда
        // В новое добавить нельзя
        Возврат;    	
    КонецЕсли; 
    
	Если ЕстьЛиУжеСохраненныйФайл("ИмяФайла4") Тогда
		Возврат;
	КонецЕсли; 
	ВыбратьФайлСДискаИСохранить("Файл4","ИмяФайла4");
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФайл4Выполнить()
	ПрочитатьФайлИСохранитьНаДиск("Файл4","ИмяФайла4");
КонецПроцедуры

&НаКлиенте
Процедура ОчиcтитьФайл4Выполнить()
	УдалитьФайлИзХранилища("Файл4","ИмяФайла4");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл5Выполнить()
    Если ПроверитьЭтоНовоеЗадание() Тогда
        // В новое добавить нельзя
        Возврат;    	
    КонецЕсли; 
    
	Если ЕстьЛиУжеСохраненныйФайл("ИмяФайла5") Тогда
		Возврат;
	КонецЕсли; 
	ВыбратьФайлСДискаИСохранить("Файл5","ИмяФайла5");
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФайл5Выполнить()
	ПрочитатьФайлИСохранитьНаДиск("Файл5","ИмяФайла5");
КонецПроцедуры

&НаКлиенте
Процедура ОчиcтитьФайл5Выполнить()
	УдалитьФайлИзХранилища("Файл5","ИмяФайла5");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл6Выполнить()
    Если ПроверитьЭтоНовоеЗадание() Тогда
        // В новое добавить нельзя
        Возврат;    	
    КонецЕсли; 
    
	Если ЕстьЛиУжеСохраненныйФайл("ИмяФайла6") Тогда
		Возврат;
	КонецЕсли; 
	ВыбратьФайлСДискаИСохранить("Файл6","ИмяФайла6");
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФайл6Выполнить()
	ПрочитатьФайлИСохранитьНаДиск("Файл6","ИмяФайла6");
КонецПроцедуры

&НаКлиенте
Процедура ОчиcтитьФайл6Выполнить()
	УдалитьФайлИзХранилища("Файл6","ИмяФайла6");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл7Выполнить()
    Если ПроверитьЭтоНовоеЗадание() Тогда
        // В новое добавить нельзя
        Возврат;    	
    КонецЕсли; 
    
	Если ЕстьЛиУжеСохраненныйФайл("ИмяФайла7") Тогда
		Возврат;
	КонецЕсли; 
	ВыбратьФайлСДискаИСохранить("Файл7","ИмяФайла7");
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФайл7Выполнить()
	ПрочитатьФайлИСохранитьНаДиск("Файл7","ИмяФайла7");
КонецПроцедуры

&НаКлиенте
Процедура ОчиcтитьФайл7Выполнить()
	УдалитьФайлИзХранилища("Файл7","ИмяФайла7");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл8Выполнить()
    Если ПроверитьЭтоНовоеЗадание() Тогда
        // В новое добавить нельзя
        Возврат;    	
    КонецЕсли; 
    
	Если ЕстьЛиУжеСохраненныйФайл("ИмяФайла8") Тогда
		Возврат;
	КонецЕсли; 
	ВыбратьФайлСДискаИСохранить("Файл8","ИмяФайла8");
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФайл8Выполнить()
	ПрочитатьФайлИСохранитьНаДиск("Файл8","ИмяФайла8");
КонецПроцедуры

&НаКлиенте
Процедура ОчиcтитьФайл8Выполнить()
	УдалитьФайлИзХранилища("Файл8","ИмяФайла8");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл9Выполнить()
    Если ПроверитьЭтоНовоеЗадание() Тогда
        // В новое добавить нельзя
        Возврат;    	
    КонецЕсли; 
    
	Если ЕстьЛиУжеСохраненныйФайл("ИмяФайла9") Тогда
		Возврат;
	КонецЕсли; 
	ВыбратьФайлСДискаИСохранить("Файл9","ИмяФайла9");
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФайл9Выполнить()
	ПрочитатьФайлИСохранитьНаДиск("Файл9","ИмяФайла9");
КонецПроцедуры

&НаКлиенте
Процедура ОчиcтитьФайл9Выполнить()
	УдалитьФайлИзХранилища("Файл9","ИмяФайла9");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл10Выполнить()
    Если ПроверитьЭтоНовоеЗадание() Тогда
        // В новое добавить нельзя
        Возврат;    	
    КонецЕсли; 
    
	Если ЕстьЛиУжеСохраненныйФайл("ИмяФайла10") Тогда
		Возврат;
	КонецЕсли; 
	ВыбратьФайлСДискаИСохранить("Файл10","ИмяФайла10");
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФайл10Выполнить()
	ПрочитатьФайлИСохранитьНаДиск("Файл10","ИмяФайла10");
КонецПроцедуры

&НаКлиенте
Процедура ОчиcтитьФайл10Выполнить()
	УдалитьФайлИзХранилища("Файл10","ИмяФайла10");
КонецПроцедуры

&НаКлиенте
Процедура МинутыПриИзменении(Элемент)
	ПересчитатьЗатраченноеВремя();
КонецПроцедуры

&НаКлиенте
Процедура ТрудозатратыИсполнителейПередУдалением(Элемент, Отказ)
	Отказ = ЭтоЧужаяСтрокаТрудозатратыИсполнителей(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ТрудозатратыИсполнителейПередНачаломИзменения(Элемент, Отказ)
	Отказ = ЭтоЧужаяСтрокаТрудозатратыИсполнителей(Элемент);
КонецПроцедуры

&НаКлиенте
Функция ЭтоЧужаяСтрокаТрудозатратыИсполнителей(Элемент)
    
	ЭтоЧужаяСтрока = НЕ (Элемент.ТекущиеДанные.Исполнитель = ТекущийПользователь
			ИЛИ Элемент.ТекущиеДанные.Исполнитель = ТекущийПользовательПустаяСсылка);

	Если ЭтоЧужаяСтрока Тогда
		Если РольАдминистратор Тогда
			Если Вопрос("Вы изменяете строку по чужому Исполнителю! Продолжить?", РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.ОК Тогда
				ЭтоЧужаяСтрока = Ложь;
			КонецЕсли; 		
		Иначе
			Предупреждение("Вы не можете редактировать строку по чужому Исполнителю!");	
		КонецЕсли; 
	КонецЕсли; 

	Возврат ЭтоЧужаяСтрока;
	
КонецФункции 

&НаКлиенте
Процедура ОтветственныйИсполнительПриИзменении(Элемент)
	Если СписокИсполнителейПуст() Тогда
		Элементы.СписокИсполнителей.ДобавитьСтроку();
		Объект.Статус = ПеречислениеОжидает;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция СписокИсполнителейПуст()
	Возврат (Объект.СписокИсполнителей.Количество()=0);	
КонецФункции 

&НаКлиенте
Процедура ОбсуждениеПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	// дубль ОбсуждениеПриНачалеРедактирования, т.к. как то странно себя ведет вызов обработки события
	//Если НоваяСтрока Тогда
	//	Элемент.ТекущиеДанные.Автор = ТекущийПользователь;
	//	Если Объект.Постановщик = ТекущийПользователь Тогда
	//		Элемент.ТекущиеДанные.Вид = ПеречислениеОтвет;
	//	Иначе
	//		Элемент.ТекущиеДанные.Вид = ПеречислениеВопрос;
	//	КонецЕсли; 
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбсуждениеТекстРедактированиеПриИзменении(Элемент)
	Элемент.Родитель.ПодчиненныеЭлементы.Обсуждение.ТекущиеДанные.УведомлениеОтправлено = Ложь;
	
	Элемент.Родитель.ПодчиненныеЭлементы.Обсуждение.ТекущиеДанные.Автор = ТекущийПользователь;
	Если Объект.Постановщик = ТекущийПользователь Тогда
		Элемент.Родитель.ПодчиненныеЭлементы.Обсуждение.ТекущиеДанные.Вид = ПеречислениеОтвет;
	Иначе
		Элемент.Родитель.ПодчиненныеЭлементы.Обсуждение.ТекущиеДанные.Вид = ПеречислениеВопрос;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ОбсуждениеПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	//// дубль ОбсуждениеПередОкончаниемРедактирования, т.к. как то странно себя ведет вызов обработки события
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Автор = ТекущийПользователь;
		Если Объект.Постановщик = ТекущийПользователь Тогда
			Элемент.ТекущиеДанные.Вид = ПеречислениеОтвет;
		Иначе
			Элемент.ТекущиеДанные.Вид = ПеречислениеВопрос;
		КонецЕсли; 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТемаПриИзменении(Элемент)
    Если НЕ ЗначениеЗаполнено(Объект.ТекстЗадания) Тогда
    	Объект.ТекстЗадания = Объект.Тема;
    КонецЕсли; 
КонецПроцедуры

//ivs d.dorin 21001 05-08-2019 start
&НаКлиенте
Процедура ОбновленныеБазыБазаДанныхПриИзменении(Элемент)
	Элементы.ОбновленныеБазы.ТекущиеДанные.Конфигурация = ПолучитьКонфигуарциюБД(Элементы.ОбновленныеБазы.ТекущиеДанные.БазаДанных);
КонецПроцедуры

&НаСервере
Функция ПолучитьКонфигуарциюБД(БазаДанных)
	Возврат БазаДанных.Конфигурация;
КонецФункции
//ivs d.dorin 21001 05-08-2019 end

 
