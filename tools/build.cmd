REM @echo off

REM ���� � �����������
set REPO="G:\cppk"

REM ���� � ������������ ����� ������������� 1�
set CONFIG_EXE="C:\Program Files\1cv8\8.3.27.1606\bin\1cv8.exe"

REM ��� � ������ ������-��������� ���� 1�
set BASE="/S vs-sed-new-dev\cppk_do30_dev_03"

REM ���� � �������� � XML-������� ������������
set XML_FOLDER="G:\cppk\src\cf"

set EXT_NAME="����"
REM ���� � �������� � XML-������� ����������
set XML_FOLDER_E="G:\cppk\src\cfe"

set hran="C:\hran_1c\hran_sed30\conf"
set hran_e="C:\hran_1c\hran_sed30\ext" 

cd /d %REPO%

echo ��������� �� ��������� ...
%CONFIG_EXE% CONFIG %BASE% /ConfigurationRepositoryUpdateCfg /ConfigurationRepositoryF "C:\hran_1c\hran_sed30\conf" /ConfigurationRepositoryN cppk_do30_dev_03 /ConfigurationRepositoryUpdateCfg -Extension %EXT_NAME% /ConfigurationRepositoryF "C:\hran_1c\hran_sed30\ext" /ConfigurationRepositoryN cppk_do30_dev_03

echo ��������� �� ��������� ���������� ...
rem %CONFIG_EXE% CONFIG %BASE% /ConfigurationRepositoryUpdateCfg -Extension %EXT_NAME% 
rem /ConfigurationRepositoryF "Z:\hran_1c\hran_sed30\ext" /ConfigurationRepositoryN cppk_do30_dev_03

echo ������������ ������� ���������, ��������� ��...
rem %CONFIG_EXE% CONFIG %BASE% /UpdateDBCfg

echo �������� ������������ � XML
rem %CONFIG_EXE% CONFIG %BASE% /DumpConfigToFiles %XML_FOLDER%

echo �������� ���������� � XML
rem %CONFIG_EXE% CONFIG %BASE% /DumpConfigToFiles %XML_FOLDER_E% -Extension %EXT_NAME%

rem set commit="auto commit " %DATE% %TIME%
rem echo %commit%
rem git add .
rem git commit -m ""%commit%""
rem git push