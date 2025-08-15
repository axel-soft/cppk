REM @echo off

REM Путь к репозиторию
set REPO="G:\cppk"

REM Путь к исполняемому файлу конфигуратора 1С
set CONFIG_EXE="C:\Program Files\1cv8\8.3.27.1606\bin\1cv8.exe"

REM Имя и сервер клиент-серверной базы 1С
set BASE="/S vs-sed-new-dev\cppk_do30_dev_03"

REM Путь к каталогу с XML-файлами конфигурации
set XML_FOLDER="G:\cppk\src\cf"

set EXT_NAME="ЦППК"
REM Путь к каталогу с XML-файлами расширения
set XML_FOLDER_E="G:\cppk\src\cfe"

set hran="C:\hran_1c\hran_sed30\conf"
set hran_e="C:\hran_1c\hran_sed30\ext" 

cd /d %REPO%

echo Получение из хранилища ...
%CONFIG_EXE% CONFIG %BASE% /ConfigurationRepositoryUpdateCfg /ConfigurationRepositoryF "C:\hran_1c\hran_sed30\conf" /ConfigurationRepositoryN cppk_do30_dev_03 /ConfigurationRepositoryUpdateCfg -Extension %EXT_NAME% /ConfigurationRepositoryF "C:\hran_1c\hran_sed30\ext" /ConfigurationRepositoryN cppk_do30_dev_03

echo Получение из хранилища расширения ...
rem %CONFIG_EXE% CONFIG %BASE% /ConfigurationRepositoryUpdateCfg -Extension %EXT_NAME% 
rem /ConfigurationRepositoryF "Z:\hran_1c\hran_sed30\ext" /ConfigurationRepositoryN cppk_do30_dev_03

echo Конфигурация успешно загружена, обновляем БД...
rem %CONFIG_EXE% CONFIG %BASE% /UpdateDBCfg

echo Выгрузка конфигурации в XML
rem %CONFIG_EXE% CONFIG %BASE% /DumpConfigToFiles %XML_FOLDER%

echo Выгрузка расширения в XML
rem %CONFIG_EXE% CONFIG %BASE% /DumpConfigToFiles %XML_FOLDER_E% -Extension %EXT_NAME%

rem set commit="auto commit " %DATE% %TIME%
rem echo %commit%
rem git add .
rem git commit -m ""%commit%""
rem git push