REM Переходим в папку проекта
cd /d C:\Git\cppk

REM Получаем изменения из хранилищ
call gitsync sync -u gitbot -e "ЦППК" C:\hran_1c\hran_sed30\ext C:\Git\cppk\src\cfe
call gitsync sync -u gitbot C:\hran_1c\hran_sed30\conf C:\Git\cppk\src\cf

REM Отправляем изменения в Git
git push
