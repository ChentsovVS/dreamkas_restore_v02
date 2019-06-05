UTF-8 >nul
rem как всегда - создание и настройка переменных 
rem в этом файле много переменных ручного ввода, поскольку много файлов будут от них зависеть
rem пока не работает. не грузит и не загружает. останавливает свое действиве на echo y (23 линия) 
rem будем выводить данные о загрузке в cmd и на всякий сохраним переменную в текст
rem task = номер задачи, db_name = имя базы данных с расширением. в каталоге их несколько.
set plinkdir="c:\program files\putty"

mkdir d:\kopeechki

set 7zip="C:\Program Files\7-Zip"
set recovery=D:\kopeechki\distrib\recovery\NuWriter\NuWriter\bin
set restore=D:\kopeechki\distrib\recovery\restore1_3
set edit_bd=D:\kopeechki\distrib\edit_db
set ssh=root@10.192.1.132:
set /p task="" && echo "%task%" > %kopeechki%\%task%\task_number.txt
set client_dir=d:\kopeechki
	
	mkdir d:\kopeechki\%task%
	mkdir d:\kopeechki\%task%\base 
	echo "%date%" > %client_dir%\%task%\log_err.txt && echo "%time%" >> %client_dir%\%task%\log_err.txt
	echo "%date%" > %client_dir%\%task%\tmp.txt && echo "%time%" >> %client_dir%\%task%\tmp.txt
	
set log=%client_dir%\%task%\log_err.txt
set tmp=d:\kopeechki\%task%\tmp.txt 
set db_name=configDb.db

forfiles /p /s %client_dir%\%task%\ /m  /d 0 /c "cmd /c echo @file" > %tmp% 
set /p buffer="" < %tmp%
	if "%buffer%"=="" (
	echo "в заданном каталоге файлы не найдены. начинаю записывать" >> %log%
	scp -r %ssh%/FisGo/ %client_dir%\%task%\base\ 
	rem pscp.exe -unsafe -q -P 22 -scp -pw "root" %ssh% "%client_dir%\%task%\base\" 2>> %client_dir%\%task%\log_err.txt 
	%7zip%\7z.exe a -tzip .7z %client_dir%\%task%\FisGo.7z %client_dir%\%task%\base\ 2>> %client_dir%\%task%\log_err.txt && del /q d:\kopeechki\%task%\base\ 
	pause
	start /w %recovery%\NuWriter.exe 2>> %client_dir%\%task%\log_err.txt
	start /w java -jar %restore%\restore-1.3.jar 2>> %client_dir%\%task%\log_err.txt
	pscp.exe "%client_dir%\%task%\base\FisGo\%db_name%" %ssh%:/FisGo/configDb.db 2>> %client_dir%\%task%\log_err.txt
	pscp.exe "%client_dir%\%task%\base\FisGo\changeMacToCustom.sh" %ssh%:/FisGo/changeMacToCustom.sh 2>> %log% 
	ssh %ssh% 'chmod +x /FisGo/changeMacToCustom.sh; chmod 777 /userScripts/*.*' 2>> %log%
	start /w java -jar %edit_bd%\FiscatInstallator.jar 2>> %client_dir%\%task%\log_err.txt
	break
	) else ( 
	echo "в данном каталоге присутствуют файлы или каталоги, перезапись пропускаю" >> %log%
	start /w %recovery%\NuWriter.exe 2>> %client_dir%\%task%\log_err.txt
	start /w java -jar %restore%\restore-1.3.jar 2>> %client_dir%\%task%\log_err.txt
	pscp.exe "%client_dir%\%task%\base\FisGo\%db_name%" %ssh%:/FisGo/configDb.db 2>> %client_dir%\%task%\log_err.txt
	pscp.exe "%client_dir%\%task%\base\FisGo\changeMacToCustom.sh" %ssh%:/FisGo/changeMacToCustom.sh 2>> %log% 
	ssh %ssh% 'chmod +x /FisGo/changeMacToCustom.sh; chmod 777 /userScripts/*.*' 2>> %log%
	start /w java -jar %edit_bd%\FiscatInstallator.jar 2>> %client_dir%\%task%\log_err.txt
	break
)
rem на будущее - сделать логи, создать проверку данных. оптимизировать переменные 
rem client_dir - переменная для директории клиентов, db_name - переменная для названия базы 
rem plinkdir - директория для pscp.exe, ssh - забитый адрес для подключения
rem restore - директория утилиты restore-1, recovery - адрес утилиты прошивки 
rem task - переменная вводимая вручную, для адреса каталога с бэкапом.
rem был вынужден изменить pscp.exe (из за ошибок) на scp, у scp нет автоввода пароля. не очень удобно. 
rem forfiles - ищет файлы и записывает в текстовый (tmp) файл, а потом передает в буффер (buffer)для  проверки заполненности папки 
rem log - ведет лог ошибок при исполнении батника 
rem добавил передачу файла changeMacToCustom и отправку комманд на chmod через pscp (результат) -не работает
	
	

	
	
	
	
	

