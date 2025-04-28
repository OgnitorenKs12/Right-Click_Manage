echo off
chcp 65001
setlocal enabledelayedexpansion
title Icon Cache Clear │ OgnitorenKs
cls

REM Renklendirm için gerekli
FOR /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E#&for %%b in (1) do rem"') do (set R=%%b)

ie4uinit.exe -show
ie4uinit.exe -ClearIconCache
taskkill /f /im explorer.exe > NUL 2>&1
Call :DEL_Direct "%LocalAppData%\IconCache.db"
Call :DEL_Search "%LocalAppData%\Microsoft\Windows\Explorer\*"
Call :DEL_Search "%LocalAppData%\Microsoft\Windows\Explorer\IconCacheToDelete\*"
Call :DEL_Search "%LocalAppData%\Microsoft\Windows\Explorer\NotifyIcon\*"
Call :DEL_Search "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db"
Call :RD_Direct "%LocalAppData%\Packages\Microsoft.Windows.Search_cw5n1h2txyewy\LocalState\AppIconCache"
Call :DEL_Search "%LocalAppData%\Packages\Microsoft.Windows.Search_cw5n1h2txyewy\TempState\*"
Call :RegDel "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" "IconStreams"
Call :RegDel "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" "PastIconsStream"
Call :Powershell "Start-Process '%Windir%\explorer.exe'"

exit

:Powershell
REM chcp 65001 kullanıldığında Powershell komutları ekranı kompakt görünüme sokuyor. Bunu önlemek için bu bölümde uygun geçişi sağlıyorum.
chcp 437 > NUL 2>&1
Powershell -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -C %*
chcp 65001 > NUL 2>&1
goto :eof


:DEL_Direct
REM Dosya silmek için
echo %R%[90m [DEL_Direct]-%R%[33m [%~1]%R%[0m
DEL /F /Q /A "%~1" > NUL 2>&1
goto :eof

:DEL_Search
REM Dosya silmek için (dizin aramalı)
FOR /F "tokens=*" %%v in ('Dir /A-D /B "%~1" 2^>NUL') do (
    echo %R%[90m [DEL_Search]-%R%[33m [%~dp1%%v]%R%[0m
    DEL /F /Q /A "%~dp1%%v" > NUL 2>&1
)
goto :eof

:RD_Direct
REM Klasör silmek için
echo %R%[90m [RD_Direct]-%R%[33m[%~1]%R%[0m
RD /S /Q "%~1" > NUL 2>&1
goto :eof

:RegDel
echo %R%[90mReg delete%R%[33m "%~1" /v "%~2" %R%[90m/f%R%[0m
Reg delete "%~1" /v "%~2" /f > NUL 2>&1
goto :eof