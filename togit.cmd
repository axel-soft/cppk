REM ��������� � ����� �������
cd /d C:\Git\cppk

REM �������� ��������� �� ��������
call gitsync sync -u gitbot -e "����" C:\hran_1c\hran_sed30\ext C:\Git\cppk\src\cfe
call gitsync sync -u gitbot C:\hran_1c\hran_sed30\conf C:\Git\cppk\src\cf

REM ���������� ��������� � Git
git push
