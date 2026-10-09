@echo off
rem Lance automatiquement le serveur a l'ouverture de votre session Windows.
rem A lancer avec clic droit > "Executer en tant qu'administrateur".
setlocal

net session >nul 2>&1
if errorlevel 1 (
    echo Ce script doit etre lance en administrateur :
    echo clic droit sur enable-autostart.bat ^> "Executer en tant qu'administrateur".
    pause
    exit /b 1
)

schtasks /create /tn "Valheim Server" /tr "\"%~dp0start-server.bat\"" /sc onlogon /f
if errorlevel 1 (
    echo ERREUR : impossible de creer la tache planifiee.
) else (
    echo Le serveur demarrera automatiquement a chaque ouverture de session.
    echo Pour annuler : disable-autostart.bat
)
pause
