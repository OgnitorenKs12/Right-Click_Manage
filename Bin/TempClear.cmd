echo off
chcp 65001
setlocal enabledelayedexpansion
title Temp Clear │ OgnitorenKs
cls

REM Renklendirm için gerekli
FOR /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E#&for %%b in (1) do rem"') do (set R=%%b)

Call :DEL_Search "%Temp%\*"
Call :RD_Search "%Temp%\*"
Call :DEL_Search "%Windir%\Temp\*"
Call :RD_Search "%Windir%\Temp\*"
Call :DEL_Search "%LocalAppData%\Temp\*"
Call :RD_Search "%LocalAppData%\Temp\*"

exit

:DEL_Search
REM Dosya silmek için (dizin aramalı)
FOR /F "tokens=*" %%v in ('Dir /A-D /B "%~1" 2^>NUL') do (
    echo %R%[90m [DEL_Search]-%R%[33m [%~dp1%%v]%R%[0m
    DEL /F /Q /A "%~dp1%%v" > NUL 2>&1
)
goto :eof

:RD_Search
REM Klasör silmek için (dizin aramalı)
FOR /F "tokens=*" %%v in ('Dir /AD /B "%~1" 2^>NUL') do (
    echo %R%[90m [RD_Search]-%R%[33m [%~dp1%%v]%R%[0m
    RD /S /Q "%~dp1%%v" > NUL 2>&1
)
goto :eof