REM @echo off

REM ���� � �����������
set REPO="G:\Git\cppk"

REM ���� � ������������ ����� ������������� 1�
set CONFIG_EXE="C:\Program Files\1cv8\8.3.25.1286\bin\1cv8.exe"

REM ��� � ������ ������-��������� ���� 1�
set BASE="/S vs-sed-new-dev\cppk_do30_dev_03"

REM ���� � �������� � XML-������� ������������
set XML_FOLDER="G:\Git\cppk\src\cf"

set EXT_NAME="����"
REM ���� � �������� � XML-������� ����������
set XML_FOLDER_E="G:\Git\cppk\src\cfe"

set hran="Z:\hran_1c\hran_sed30\conf"
set hran_e="Z:\hran_1c\hran_sed30\ext" 

cd /d %REPO%

echo ��������� �� ��������� ...
%CONFIG_EXE% CONFIG %BASE% /ConfigurationRepositoryUpdateCfg 
REM /ConfigurationRepositoryF "Z:\hran_1c\hran_sed30\conf" /ConfigurationRepositoryN cppk_do30_dev_03

echo ��������� �� ��������� ���������� ...
%CONFIG_EXE% CONFIG %BASE% /ConfigurationRepositoryUpdateCfg -Extension %EXT_NAME% 
rem /ConfigurationRepositoryF "Z:\hran_1c\hran_sed30\ext" /ConfigurationRepositoryN cppk_do30_dev_03

echo ������������ ������� ���������, ��������� ��...
%CONFIG_EXE% CONFIG %BASE% /UpdateDBCfg

echo �������� ������������ � XML
%CONFIG_EXE% CONFIG %BASE% /DumpConfigToFiles %XML_FOLDER%

echo �������� ���������� � XML
%CONFIG_EXE% CONFIG %BASE% /DumpConfigToFiles %XML_FOLDER_E% -Extension %EXT_NAME%

set commit ="auto commit " %DATE% %TIME%
git add .
git commit -m %commit%
git push