﻿
// Процедура установки параметра сеанса ИспользоватьОграниченияПравДоступаНаУровнеЗаписей
//
Процедура УстановитьПараметрыМеханизмаОграниченияПрав() Экспорт
	ПараметрыСеанса.ИспользоватьОграниченияПравДоступаНаУровнеЗаписей = Константы.ИспользоватьОграниченияПравДоступаНаУровнеЗаписей.Получить();
КонецПроцедуры

// Выполняется подготовка набора записей регистра, установка отборов,
// дополнение унаследованными по иерархии настройками прав доступа
//
Процедура ЗаписатьПраваДоступаПользователей(ТаблицаНабораПрав, СтруктураОтбора, Отказ = Ложь, ШапкаОшибки = "") Экспорт
	
	НаборПрав   = РегистрыСведений.НастройкиПравДоступаПользователей.СоздатьНаборЗаписей();
	
	Для Каждого ЭлементСтруктуры Из СтруктураОтбора Цикл
		Если Не ЭлементСтруктуры.Ключ = "ВладелецПравДоступа" Тогда
			НаборПрав  .Отбор[ЭлементСтруктуры.Ключ].Использование = Истина;
			НаборПрав  .Отбор[ЭлементСтруктуры.Ключ].Значение      = ЭлементСтруктуры.Значение;
		КонецЕсли;
	КонецЦикла;
	
	// Проверим набор на корректность установленных отборов
	Если НаборПрав.Отбор.ОбъектДоступа.Использование Тогда
		ОтборПоОбъектуДоступа = Истина;
		ОбъектДоступа = НаборПрав.Отбор.ОбъектДоступа.Значение;
		НаборПрав.Отбор.ВладелецПравДоступа.Установить(ОбъектДоступа);
		НаборПрав.Отбор.ОбъектДоступа.Использование = Ложь;
	ИначеЕсли НаборПрав.Отбор.Пользователь.Использование Тогда
		Если Не ЗначениеЗаполнено(НаборПрав.Отбор.Пользователь.Значение) Тогда
			Отказ = Истина;
			УправлениеПравамиДоступаПользователей.СообщитьОбОшибке(ШапкаОшибки);
			Возврат;
		КонецЕсли;
		
	Иначе
		Отказ = Истина;
		УправлениеПравамиДоступаПользователей.СообщитьОбОшибке(ШапкаОшибки);
		Возврат;
	КонецЕсли;
	
	ТаблицаРазличияСтрок   = НаборПрав.Выгрузить();
	ТаблицаРазличияЗаписей = НаборПрав.Выгрузить();
	
	НаборПрав.Прочитать();
	
	ТаблицаСтарогоНабора = НаборПрав.Выгрузить();
	
	ТаблицаНовогоНабора  = УправлениеПравамиДоступаПользователей.ПолучитьТаблицуПравДоступаБезУнаследуемыхЗаписей(ТаблицаНабораПрав);
	
	НаборПрав.Загрузить(ТаблицаНовогоНабора);
	
	Если Не РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
		Отказ = Истина;
		УправлениеПравамиДоступаПользователей.СообщитьОбОшибке("Нарушение прав доступа!", ШапкаОшибки);
		Возврат;
	КонецЕсли;
	
	УправлениеПравамиДоступаПользователей.ДополнитьНаборПравДоступаНаследуемымиЗаписями(НаборПрав);
		
	ЗаписатьНаборПрав(НаборПрав, Отказ, ШапкаОшибки);
	
КонецПроцедуры

// Записывает подготовленный набор записей регистра настроек прав доступа
// на уровне записей
//
Процедура ЗаписатьНаборПрав(НаборПрав, Отказ, ШапкаОшибки)
	
	Попытка		
		НаборПрав.Записать();
	Исключение
		УправлениеПравамиДоступаПользователей.СообщитьОбОшибке(ОписаниеОшибки(), ШапкаОшибки);
		Отказ = Истина;
	КонецПопытки;
	
КонецПроцедуры

// Обеспечитвается регистрация прав доступа для новых пользователей,
// с дополнением настроек унаследованных прав
//
Процедура ЗарегистрироватьПраваДоступаПользователяКОбъекту(СсылкаНового, Родитель, Отказ = Ложь) Экспорт

	Если НЕ Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(СсылкаНового)) Тогда
		Возврат;
	КонецЕсли;
	
	Если СсылкаНового.ПолучитьОбъект() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.НастройкиПравДоступаПользователей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОбъектДоступа.Установить(СсылкаНового);
	
	УправлениеПравамиДоступаПользователей.ДополнитьНаборПравДоступаУнаследованнымиЗаписями(НаборЗаписей, СсылкаНового, Родитель);
		
	ЗаписатьНаборПрав(НаборЗаписей, Отказ, "Не удалось записать права доступа к объекту!")
	
КонецПроцедуры

// Обновление наследуемых настроек прав доступа объектов, выполняемое
// при изменении родителя объекта
//
Процедура ОбновитьПраваДоступаКПрошлымРодителям(Ссылка, ПрошлыйИзмененныйРодительОбъектаДоступа, Отказ) Экспорт
	
	ОбновляемыеОбъекты = Новый Массив;
	ОбновляемыеОбъекты.Добавить(ПрошлыйИзмененныйРодительОбъектаДоступа);
	УправлениеПравамиДоступаПользователей.ПолучитьМассивРодительскихЭлементов(ПрошлыйИзмененныйРодительОбъектаДоступа, ОбновляемыеОбъекты);
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкиПравДоступаПользователей.ОбъектДоступа КАК Ссылка
	|ИЗ
	|	РегистрСведений.НастройкиПравДоступаПользователей КАК НастройкиПравДоступаПользователей
	|ГДЕ
	|	НастройкиПравДоступаПользователей.ОбъектДоступа = НастройкиПравДоступаПользователей.ВладелецПравДоступа И 
	|	НастройкиПравДоступаПользователей.ОбъектДоступа В (&ОбновляемыеОбъекты)";
	
	Запрос.УстановитьПараметр("ОбновляемыеОбъекты", ОбновляемыеОбъекты);	
	
	ОбновляемыеОбъекты = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Для каждого ОбновляемыйОбъект Из ОбновляемыеОбъекты Цикл
		
		МассивЭлементов = УправлениеПравамиДоступаПользователей.ПолучитьМассивДочернихЭлементов(Ссылка);
		МассивЭлементов.Добавить(Ссылка);
		
		Для Каждого ПодчиненныйЭлемент ИЗ МассивЭлементов Цикл
		
			ПраваДоступаПользователей = РегистрыСведений.НастройкиПравДоступаПользователей.СоздатьНаборЗаписей();
		
			ПраваДоступаПользователей.Отбор.ОбъектДоступа      .Установить(ПодчиненныйЭлемент);
			ПраваДоступаПользователей.Отбор.ВладелецПравДоступа.Установить(ОбновляемыйОбъект);
			
			Попытка
				ПраваДоступаПользователей.Записать();		
			Исключение
				Отказ = Истина;
				УправлениеПравамиДоступаПользователей.СообщитьОбОшибке(ОписаниеОшибки() + Символы.ПС+ " .Не записаны права доступа к объекту: " + Ссылка);
				Возврат;
			КонецПопытки;
		
		КонецЦикла;
			
	КонецЦикла;	
	
КонецПроцедуры

// Возвращает список объектов, настройки прав доступа к которым необходимо изменить, в случае
// изменения родителя
//
Функция ПолучитьСписокОбновляемыхОбъектовПриПереносеВГруппу(Ссылка, ОбновляемыеОбъекты) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкиПравДоступаПользователей.ОбъектДоступа КАК Ссылка
	|ИЗ
	|	РегистрСведений.НастройкиПравДоступаПользователей КАК НастройкиПравДоступаПользователей
	|ГДЕ
	|	НастройкиПравДоступаПользователей.ОбъектДоступа = НастройкиПравДоступаПользователей.ВладелецПравДоступа и 
	|	(НастройкиПравДоступаПользователей.ОбъектДоступа В (&ОбновляемыеОбъекты)
	|	 	ИЛИ НастройкиПравДоступаПользователей.ОбъектДоступа В ИЕРАРХИИ (&Ссылка))";
	
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ОбновляемыеОбъекты", ОбновляемыеОбъекты);		
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Обновление настроек прав доступа к объекту, в случае изменения наследуемых прав
//
Функция ОбновитьПраваДоступаПользователейПоВладельцуДоступа(Ссылка, ОбновляемыйОбъект = Неопределено) Экспорт
	
	ПраваДоступаПользователей = РегистрыСведений.НастройкиПравДоступаПользователей.СоздатьНаборЗаписей();
	
	ПраваДоступаПользователей.Отбор.ОбъектДоступа      .Установить(Ссылка);
	ПраваДоступаПользователей.Отбор.ВладелецПравДоступа.Установить(Ссылка);
	
	ПраваДоступаПользователей.Прочитать();
	
	ПраваДоступаПользователей.Отбор.ОбъектДоступа.Использование = Ложь;
	
	УправлениеПравамиДоступаПользователей.ДополнитьНаборПравДоступаНаследуемымиЗаписями(ПраваДоступаПользователей);
		
	Попытка
		ПраваДоступаПользователей.Записать(Истина);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// Возвращает данные пользователя информационной базы в виде структуры
// В случае отсутствия административных прав, допускается получение данных только по текущему пользователю
// 	Параметры
//		- ИдентификаторПользователя - уникальный идентификатор пользователя информационной базы
//
//	Возвращаемое значение:
//		- Структура, с данными о пользователе
//
Функция ПолучитьДанныеПользователяИБ(ИдентификаторПользователя) Экспорт
	
	Если НЕ ПравоДоступа("Администрирование", Метаданные)
		 И ИдентификаторПользователя <> ПараметрыСеанса.ТекущийПользователь.ИдентификаторПользователяИБ Тогда
		ВызватьИсключение "Нарушение прав доступа";
	КонецЕсли;

	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ИдентификаторПользователя));
	Если ПользовательИБ = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	ДанныеПользователяИБ = Новый Структура;
	ДанныеПользователяИБ.Вставить("АутентификацияСтандартная", ПользовательИБ.АутентификацияСтандартная);
	ДанныеПользователяИБ.Вставить("ПоказыватьВСпискеВыбора", ПользовательИБ.ПоказыватьВСпискеВыбора);
	ДанныеПользователяИБ.Вставить("АутентификацияОС", ПользовательИБ.АутентификацияОС);
	ДанныеПользователяИБ.Вставить("ОсновнойИнтерфейс", ПользовательИБ.ОсновнойИнтерфейс);
	ДанныеПользователяИБ.Вставить("Язык", ПользовательИБ.Язык);
	ДанныеПользователяИБ.Вставить("ПользовательОС", ПользовательИБ.ПользовательОС);
	ДанныеПользователяИБ.Вставить("ПарольУстановлен", ПользовательИБ.ПарольУстановлен);
	ДанныеПользователяИБ.Вставить("Роли", ПользовательИБ.Роли);
	
	Возврат ДанныеПользователяИБ;


КонецФункции

Функция ЕстьДоступныеРолиДляЗапускаКонфигурации() Экспорт
	
	Возврат Истина;
	
КонецФункции
