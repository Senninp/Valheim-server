@echo off
rem Installe (ou met a jour) le serveur dedie Valheim via SteamCMD.
rem Usage : double-clic. Le parametre "nopause" est utilise par start-server.bat.
setlocal
cd /d "%~dp0"

set "STEAMCMD_DIR=%~dp0steamcmd"
set "SERVER_DIR=%~dp0server"

if not exist "%STEAMCMD_DIR%\steamcmd.exe" (
    echo Telechargement de SteamCMD...
    if not exist "%STEAMCMD_DIR%" mkdir "%STEAMCMD_DIR%"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip' -OutFile '%STEAMCMD_DIR%\steamcmd.zip'; Expand-Archive -Path '%STEAMCMD_DIR%\steamcmd.zip' -DestinationPath '%STEAMCMD_DIR%' -Force; Remove-Item '%STEAMCMD_DIR%\steamcmd.zip'"
    if not exist "%STEAMCMD_DIR%\steamcmd.exe" (
        echo ERREUR : impossible de telecharger SteamCMD. Verifiez votre connexion Internet.
        if /i not "%~1"=="nopause" pause
        exit /b 1
    )
)

echo Installation / mise a jour du serveur Valheim (app 896660)...
"%STEAMCMD_DIR%\steamcmd.exe" +force_install_dir "%SERVER_DIR%" +login anonymous +app_update 896660 validate +quit

rem SteamCMD renvoie parfois un code d'erreur meme en cas de succes :
rem on verifie plutot la presence de l'executable.
if not exist "%SERVER_DIR%\valheim_server.exe" (
    echo ERREUR : l'installation a echoue. Relancez ce script.
    if /i not "%~1"=="nopause" pause
    exit /b 1
)

echo.
echo Serveur installe dans : %SERVER_DIR%
if /i not "%~1"=="nopause" pause
exit /b 0
