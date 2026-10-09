@echo off
rem Lance le serveur dedie Valheim et le redemarre automatiquement s'il plante.
rem Pour l'arreter PROPREMENT (avec sauvegarde du monde) : Ctrl+C dans cette
rem fenetre, puis repondez O a "Terminer le programme de commandes ?".
setlocal
cd /d "%~dp0"
title Serveur Valheim

call "%~dp0config.bat"

set "SERVER_DIR=%~dp0server"
set "SAVE_DIR=%~dp0data"

rem --- Verifications du mot de passe (exigences de Valheim) ---
if "%SERVER_PASSWORD:~4,1%"=="" (
    echo ERREUR : SERVER_PASSWORD doit contenir au moins 5 caracteres. Modifiez config.bat.
    pause
    exit /b 1
)
echo "%SERVER_NAME%" | findstr /i /c:"%SERVER_PASSWORD%" >nul
if not errorlevel 1 (
    echo ERREUR : le mot de passe ne doit pas etre contenu dans le nom du serveur. Modifiez config.bat.
    pause
    exit /b 1
)

set "EXTRA_ARGS="
if "%CROSSPLAY%"=="1" set "EXTRA_ARGS=-crossplay"

rem Necessaire pour que le serveur s'initialise avec Steam
set "SteamAppId=892970"

:loop
if "%UPDATE_ON_START%"=="1" call "%~dp0install-or-update.bat" nopause

if not exist "%SERVER_DIR%\valheim_server.exe" (
    echo ERREUR : serveur non installe. Lancez d'abord install-or-update.bat.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  Demarrage de "%SERVER_NAME%" - monde "%WORLD_NAME%" - port %SERVER_PORT%
echo  Sauvegardes : %SAVE_DIR%\worlds_local
echo  Arret propre : Ctrl+C
echo ============================================================
echo.

"%SERVER_DIR%\valheim_server.exe" -nographics -batchmode -name "%SERVER_NAME%" -port %SERVER_PORT% -world "%WORLD_NAME%" -password "%SERVER_PASSWORD%" -public %SERVER_PUBLIC% -savedir "%SAVE_DIR%" %EXTRA_ARGS%

echo.
echo Le serveur s'est arrete. Redemarrage dans 15 secondes (fermez la fenetre pour annuler)...
timeout /t 15
goto loop
