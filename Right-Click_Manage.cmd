echo off
chcp 65001
setlocal enabledelayedexpansion
cls
REM -------------------------------------------------------------
REM Renklendirme için gerekli
FOR /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E#&for %%b in (1) do rem"') do (set R=%%b)
REM -------------------------------------------------------------
REM Konum
cd /d "%~dp0"
FOR /F "tokens=*" %%a in ('cd') do (set Konum=%%a)
set Program=%~f0
REM -------------------------------------------------------------
REM Yönetici yetkisi
reg query "HKU\S-1-5-19" > NUL 2>&1
    if !errorlevel! NEQ 0 (Call :Powershell "Start-Process '!Program!' -Verb Runas"&exit
)
REM -------------------------------------------------------------
REM Sistem dil kontrolü
set Dil=EN
FOR /F "tokens=6" %%a in ('Dism /Online /Get-intl ^| Find /I "Default system UI language"') do (
	if "%%a" EQU "tr-TR" (set Dil=TR)
)
REM -------------------------------------------------------------
REM Klasör yolunda Türkçe karakter kontrolü yapar
FOR %%a in (Ö ö Ü ü Ğ ğ Ş ş Ç ç ı İ) do (
    echo !Program! | Find "%%a" > NUL 2>&1
        if !errorlevel! EQU 0 (cls&Call :Dil A 2 Language_Error_!Dil!_1_&echo.&echo %R%[31m !LA2! %R%[0m&Call :Bekle 7&exit)
)
REM Klasör yolunda boşluk olup olmadığını kontrol eder
if "!Program!" NEQ "!Program: =!" (cls&Call :Dil A 2 Language_Error_!Dil!_2_&echo.&echo %R%[31m !LA2! %R%[0m&Call :Bekle 7&exit)
REM -------------------------------------------------------------
:Menu
mode con cols=80 lines=22
set Setup=0
title Sağ-Tık Yönet │ Right-Click Manage │ OgnitorenKs
echo.
Call :Dil A 2 Language_Menu_!Dil!_1_&echo %R%[36m  ▼ !LA2! ▼%R%[0m
FOR %%a in (Icon MUIVerb Position SubCommands) do (Call :Sorgula %%a)
	if "!Setup!" EQU "0" (Call :Dil A 2 Language_!Dil!_5_&set Text=%R%[92m!LA2!%R%[0m)
	if "!Setup!" EQU "1" (Call :Dil A 2 Language_!Dil!_6_&set Text=%R%[90m!LA2!%R%[0m)
Call :Dil A 2 Language_!Dil!_4_&echo %R%[90m  • !LA2!= !Text!
Call :Dil A 2 Language_Menu_!Dil!_2_&echo  %R%[32m 1%R%[90m-%R%[33m !LA2!%R%[0m
Call :Dil A 2 Language_Menu_!Dil!_3_&echo  %R%[32m 2%R%[90m-%R%[33m !LA2!%R%[0m
Call :Dil A 2 Language_Menu_!Dil!_4_&set /p Value=%R%[32m  ► !LA2!%R%[90m= %R%[0m
	if "!Value!" EQU "1" (Call :Setup)
	if "!Value!" EQU "2" (Call :Dil A 2 Language_!Dil!_3_&echo.&echo %R%[32m► !LA2!%R%[0m
						  Reg delete "HKLM\SOFTWARE\Classes\Directory\background\shell\Yonet" /f > NUL 2>&1
						  Call :Dil A 2 Language_!Dil!_2_&echo %R%[32m► !LA2!%R%[0m&timeout /t 2 /nobreak > NUL
                         )
goto Menu
REM -------------------------------------------------------------
:Setup
Call :Dil A 2 Language_!Dil!_1_&echo.&echo %R%[32m► !LA2!%R%[0m
REM Sağ-tık
Call :Dil A 2 Language_Right_!Dil!_00_
Call :Reg "Yonet" "Icon" REG_EXPAND_SZ "!Konum!\Icon\Yonet.ico"
Call :Reg "Yonet" "MUIVerb" REG_SZ "!LA2!"
Call :Reg "Yonet" "Position" REG_SZ "Top"
Call :Reg "Yonet" "SubCommands" REG_SZ ""
REM Denetim Masası
Call :Dil A 2 Language_Right_!Dil!_0_
Call :Reg "Yonet\shell\0Control" "Icon" REG_EXPAND_SZ "%%%%SystemRoot%%%%\system32\shell32.dll,21"
Call :Reg "Yonet\shell\0Control" "MUIVerb" REG_SZ "!LA2!"
Call :RegVE "Yonet\shell\0Control\command" REG_EXPAND_SZ "%%%%SystemRoot%%%%\system32\control.exe"
REM Ayarlar
Call :Dil A 2 Language_Right_!Dil!_1_
Call :Reg "Yonet\shell\1Ayarlar" "Icon" REG_EXPAND_SZ "!Konum!\Icon\1.ico"
Call :Reg "Yonet\shell\1Ayarlar" "MUIVerb" REG_SZ "!LA2!"
Call :RegVE "Yonet\shell\1Ayarlar\command" REG_EXPAND_SZ "!Konum!\Bin\NSudo.exe -U:E -P:E -ShowWindowMode:hide cmd /c start ms-settings:"
REM Güç Yönetimi
Call :Dil A 2 Language_Right_!Dil!_2_
Call :Reg "Yonet\shell\2powercfg" "Icon" REG_EXPAND_SZ "!Konum!\Icon\2.ico"
Call :Reg "Yonet\shell\2powercfg" "MUIVerb" REG_SZ "!LA2!"
Call :RegVE "Yonet\shell\2powercfg\command" REG_EXPAND_SZ "%%%%SystemRoot%%%%\system32\control.exe powercfg.cpl"
REM MSConfig
Call :Dil A 2 Language_Right_!Dil!_3_
Call :Reg "Yonet\shell\3msconfig" "Icon" REG_EXPAND_SZ "!Konum!\Icon\3.ico"
Call :Reg "Yonet\shell\3msconfig" "MUIVerb" REG_SZ "!LA2!"
Call :RegVE "Yonet\shell\3msconfig\command" REG_EXPAND_SZ "%%%%SystemRoot%%%%\system32\msconfig.exe"
REM Görev Yöneticisi
Call :Dil A 2 Language_Right_!Dil!_4_
Call :Reg "Yonet\shell\4Taskmgr" "Icon" REG_EXPAND_SZ "%%%%SystemRoot%%%%\system32\taskmgr.exe"
Call :Reg "Yonet\shell\4Taskmgr" "MUIVerb" REG_SZ "!LA2!"
Call :RegVE "Yonet\shell\4Taskmgr\command" REG_EXPAND_SZ "%%%%SystemRoot%%%%\system32\taskmgr.exe"
REM CMD
Call :Dil A 2 Language_Right_!Dil!_5_
Call :Reg "Yonet\shell\5CMD" "Icon" REG_EXPAND_SZ "%%%%SystemRoot%%%%\system32\cmd.exe"
Call :Reg "Yonet\shell\5CMD" "MUIVerb" REG_SZ "!LA2!"
Call :RegVE "Yonet\shell\5CMD\command" REG_EXPAND_SZ "!Konum!\Bin\NSudo.exe -U:T -P:E cmd.exe /k cd %%%%SystemRoot%%%%&title Trusted Installer / OgnitorenKs"
REM Regedit
Call :Dil A 2 Language_Right_!Dil!_6_
Call :Reg "Yonet\shell\6Regedit" "Icon" REG_EXPAND_SZ "!Konum!\Icon\6.ico"
Call :Reg "Yonet\shell\6Regedit" "MUIVerb" REG_SZ "!LA2!"
Call :RegVE "Yonet\shell\6Regedit\command" REG_EXPAND_SZ "!Konum!\Bin\NSudo.exe -U:T -P:E regedit.exe"
REM Dosya Gezginini yeniden başlat
Call :Dil A 2 Language_Right_!Dil!_7_
Call :Reg "Yonet\shell\7ExplorerRestart" "Icon" REG_EXPAND_SZ "!Konum!\Icon\7.ico"
Call :Reg "Yonet\shell\7ExplorerRestart" "MUIVerb" REG_SZ "!LA2!"
Call :RegVE "Yonet\shell\7ExplorerRestart\command" REG_EXPAND_SZ "!Konum!\Bin\NSudo.exe -U:E -P:E -ShowWindowMode:hide cmd /c taskkill /f /im explorer.exe&&start explorer"
REM Temp Temizle
Call :Dil A 2 Language_Right_!Dil!_8_
Call :Reg "Yonet\shell\8TempClear" "Icon" REG_EXPAND_SZ "!Konum!\Icon\8.ico"
Call :Reg "Yonet\shell\8TempClear" "MUIVerb" REG_SZ "!LA2!"
Call :RegVE "Yonet\shell\8TempClear\command" REG_EXPAND_SZ "!Konum!\Bin\NSudo.exe -U:E -P:E !Konum!\Bin\TempClear.cmd"
REM Simge Önbelliğini Temizle
Call :Dil A 2 Language_Right_!Dil!_9_
Call :Reg "Yonet\shell\9IconClear" "Icon" REG_EXPAND_SZ "!Konum!\Icon\9.ico"
Call :Reg "Yonet\shell\9IconClear" "MUIVerb" REG_SZ "!LA2!"
Call :RegVE "Yonet\shell\9IconClear\command" REG_EXPAND_SZ "!Konum!\Bin\NSudo.exe -U:E -P:E !Konum!\Bin\IconReset.cmd"
Call :Dil A 2 Language_!Dil!_2_&echo %R%[32m► !LA2!%R%[0m
timeout /t 2 /nobreak > NUL
goto :eof
REM -------------------------------------------------------------
:Powershell
REM chcp 65001 kullanıldığında Powershell komutları ekranı kompakt görünüme sokuyor. Bunu önlemek için bu bölümde uygun geçişi sağlıyorum.
chcp 437 > NUL 2>&1
Powershell -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -C %*
chcp 65001 > NUL 2>&1
goto :eof
REM -------------------------------------------------------------
:Sorgula
reg query "HKLM\SOFTWARE\Classes\Directory\background\shell\Yonet" /v "%~1" > NUL 2>&1
	if !errorlevel! NEQ 0 (set Setup=1)
goto :eof
REM -------------------------------------------------------------
:Dil
REM Dil verilerini buradan alıyorum. Call komutu ile buraya uygun değerleri gönderiyorum.
REM %~1= Harf │ %~2= tokens değeri │ %~3= Find değeri
set L%~1%~2=
FOR /F "delims=> tokens=%~2" %%g in ('Findstr /i "%~3" !Program! 2^>NUL') do (set L%~1%~2=%%g)
goto :eof
REM -------------------------------------------------------------
:Reg
reg add "HKLM\SOFTWARE\Classes\Directory\background\shell\%~1" /f /v "%~2" /t %~3 /d "%~4" > NUL 2>&1
goto :eof
REM -------------------------------------------------------------
:RegVE
reg add "HKLM\SOFTWARE\Classes\Directory\background\shell\%~1" /f /ve /t %~2 /d "%~3" > NUL 2>&1
goto :eof
REM -------------------------------------------------------------
:Language
:Turkish
Language_Menu_TR_1_>Sağ-Tık Yönet İşlem Menüsü>
Language_Menu_TR_2_>Yükle>
Language_Menu_TR_3_>Kaldır>
Language_Menu_TR_4_>İşlem>
Language_TR_1_>Sağ-Tık menüsü kuruluyor. Lütfen bekleyin...>
Language_TR_2_>İşlem tamamlandı>
Language_TR_3_>Yönet menüsü kaldırılıyor...>
Language_TR_4_>Sağ-Tık Yönet menüsü yüklü mü?>
Language_TR_5_>YÜKLÜ>
Language_TR_6_>YÜKLÜ DEĞİL>
Language_Error_TR_1_>Klasör yolunda Türkçe karakter bulunuyor>
Language_Error_TR_2_>Klasör yolunda boşluk bulunuyor>
Language_Right_TR_00_>Yönet>
Language_Right_TR_0_>Denetim Masası>
Language_Right_TR_1_>Ayarlar>
Language_Right_TR_2_>Güç Yönetimi>
Language_Right_TR_3_>MSConfig>
Language_Right_TR_4_>Görev Yöneticisi>
Language_Right_TR_5_>CMD [Trusted Installer]>
Language_Right_TR_6_>Regedit [Trusted Installer]>
Language_Right_TR_7_>Dosya gezginini yeniden başlat>
Language_Right_TR_8_>Temp Temizle>
Language_Right_TR_9_>Simge Önbelliğini Temizle>

:English
REM Translated by Yandex and DeepL.
Language_Menu_EN_1_>Right-Click Manage Operation Menu>
Language_Menu_EN_2_>Install>
Language_Menu_EN_3_>Remove>
Language_Menu_EN_4_>Process>
Language_EN_1_>Right-Click menu is being installed. Please wait...>
Language_EN_2_>Process completed>
Language_EN_3_>Removing the Manage menu...>
Language_EN_4_>Is the Right-Click Manage menu installed?>
Language_EN_5_>INSTALLED>
Language_EN_6_>NOT INSTALLED>
Language_Error_EN_1_>Turkish characters in folder path>
Language_Error_EN_2_>There is a gap in the folder path>
Language_Right_EN_00_>Manage>
Language_Right_EN_0_>Control Panel>
Language_Right_EN_1_>Settings>
Language_Right_EN_2_>Power Management>
Language_Right_EN_3_>MSConfig>
Language_Right_EN_4_>Task Manager>
Language_Right_EN_5_>CMD [Trusted Installer]>
Language_Right_EN_6_>Regedit [Trusted Installer]>
Language_Right_EN_7_>Explorer Reset>
Language_Right_EN_8_>Temp Clear>
Language_Right_EN_9_>Icon Cache Clear>