REM @echo off

REM Путь к репозиторию
set REPO="G:\Git\cppk"

REM Путь к исполняемому файлу конфигуратора 1С
set CONFIG_EXE="C:\Program Files\1cv8\8.3.25.1286\bin\1cv8.exe"

REM Имя и сервер клиент-серверной базы 1С
set BASE="/S vs-sed-new-dev\cppk_do30_dev_03"

REM Путь к каталогу с XML-файлами конфигурации
set XML_FOLDER="G:\Git\cppk\src\cf"

set EXT_NAME="ЦППК"
REM Путь к каталогу с XML-файлами расширения
set XML_FOLDER_E="G:\Git\cppk\src\cfe"

set hran="Z:\hran_1c\hran_sed30\conf"
set hran_e="Z:\hran_1c\hran_sed30\ext" 

cd /d %REPO%

echo Получение из хранилища ...
%CONFIG_EXE% CONFIG %BASE% /ConfigurationRepositoryUpdateCfg 
REM /ConfigurationRepositoryF "Z:\hran_1c\hran_sed30\conf" /ConfigurationRepositoryN cppk_do30_dev_03

echo Получение из хранилища расширения ...
%CONFIG_EXE% CONFIG %BASE% /ConfigurationRepositoryUpdateCfg -Extension %EXT_NAME% 
rem /ConfigurationRepositoryF "Z:\hran_1c\hran_sed30\ext" /ConfigurationRepositoryN cppk_do30_dev_03

echo Конфигурация успешно загружена, обновляем БД...
%CONFIG_EXE% CONFIG %BASE% /UpdateDBCfg

echo Выгрузка конфигурации в XML
%CONFIG_EXE% CONFIG %BASE% /DumpConfigToFiles %XML_FOLDER%

echo Выгрузка расширения в XML
%CONFIG_EXE% CONFIG %BASE% /DumpConfigToFiles %XML_FOLDER_E% -Extension %EXT_NAME%

set commit ="auto commit " %DATE% %TIME%
git add .
git commit -m %commit%
git push