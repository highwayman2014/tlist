Функция ПолучитьСсылкуНаХранилищеФайлов(ПолноеИмяФайла,ИмяФайла,Расширение) Экспорт

	Строка = СокрЛП(ИмяФайла);
	мРасширение = "";
	i1 = СтрДлина(Строка);
	Пока i1 > 0 Цикл
		Если Сред(Строка,i1,1) = "." Тогда
			Прервать;
		КонецЕсли;
		мРасширение = Сред(Строка,i1,1) + мРасширение;
		i1 = i1 - 1;
	КонецЦикла;	
	if i1 = 0 Тогда
		мРасширение = "";
	КонецЕсли;
	
	Файл = Новый ДвоичныеДанные(ПолноеИмяФайла);
	НоваяЗапись = Справочники.Файлы.СоздатьЭлемент();
	НоваяЗапись.Наименование = ИмяФайла;
	НоваяЗапись.Расширение = мРасширение;
	НоваяЗапись.Расширение = Расширение;
	НоваяЗапись.ХранилищеФайла = Новый  ХранилищеЗначения(Файл);
	НоваяЗапись.Записать();
	Возврат НоваяЗапись.Ссылка;
КонецФункции

Функция ПолучитьЗначениеИзХранилища(мСсылка,АдресФайла) Экспорт
	
	//Строка = СокрЛП(АдресФайла);
	//мРасширение = "";
	//i1 = СтрДлина(Строка);
	//Пока i1 > 0 Цикл
	//	Если Сред(Строка,i1,1) = "." Тогда
	//		Прервать;
	//	КонецЕсли;
	//	мРасширение = Сред(Строка,i1,1) + мРасширение;
	//	i1 = i1 - 1;
	//КонецЦикла;	
	//
	//мАдресФайла = Сред(АдресФайла,1,i1) + мРасширение;
	//
	
	Файл = Новый ДвоичныеДанные(АдресФайла);
	Файл = мСсылка.ХранилищеФайла.Получить();
	Файл.Записать(АдресФайла);
	
	Возврат СокрЛП(мСсылка.Наименование);
КонецФункции

