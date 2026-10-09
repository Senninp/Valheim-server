@echo off
rem Supprime le demarrage automatique du serveur.
schtasks /delete /tn "Valheim Server" /f
pause
