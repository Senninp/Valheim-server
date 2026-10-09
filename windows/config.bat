@echo off
rem ============================================================
rem  Parametres du serveur Valheim - modifiez ces valeurs
rem ============================================================
rem  Evitez les caracteres speciaux (point d'exclamation, pourcent, esperluette,
rem  chapeau, barre verticale, chevrons, guillemets) dans les valeurs.

rem Nom affiche dans la liste des serveurs
set "SERVER_NAME=Serveur des potes"

rem Nom du monde (si vous importez un monde existant, mettez son nom ici)
set "WORLD_NAME=MonMonde"

rem Mot de passe : 5 caracteres minimum, et il ne doit PAS etre contenu dans SERVER_NAME
set "SERVER_PASSWORD=changezmoi"

rem Port du jeu (le serveur utilise ce port et le suivant, en UDP)
set "SERVER_PORT=2456"

rem 1 = visible dans la liste publique des serveurs, 0 = rejoindre par IP uniquement
set "SERVER_PUBLIC=0"

rem 1 = active le crossplay (Xbox / Game Pass) ET permet de rejoindre via un
rem     "code d'invitation" sans ouvrir de port sur la box (pratique si la
rem     redirection de port est impossible chez vous)
set "CROSSPLAY=0"

rem 1 = met a jour le serveur via SteamCMD a chaque (re)demarrage
set "UPDATE_ON_START=1"
