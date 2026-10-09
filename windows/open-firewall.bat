@echo off
rem Autorise les ports UDP du serveur Valheim dans le pare-feu Windows.
rem A lancer avec clic droit > "Executer en tant qu'administrateur".
setlocal
cd /d "%~dp0"

net session >nul 2>&1
if errorlevel 1 (
    echo Ce script doit etre lance en administrateur :
    echo clic droit sur open-firewall.bat ^> "Executer en tant qu'administrateur".
    pause
    exit /b 1
)

call "%~dp0config.bat"
set /a PORT_END=%SERVER_PORT%+2

netsh advfirewall firewall delete rule name="Valheim Server" >nul 2>&1
netsh advfirewall firewall add rule name="Valheim Server" dir=in action=allow protocol=UDP localport=%SERVER_PORT%-%PORT_END%

echo.
echo Ports UDP %SERVER_PORT%-%PORT_END% ouverts dans le pare-feu Windows.
pause
