# Valheim-server

Héberger un **serveur dédié Valheim** sur votre propre PC, pour que vos amis puissent continuer à jouer même quand vous quittez la partie.

## Le principe

Quand vous « hébergez » depuis le jeu (Démarrer → *Héberger le serveur*), le monde s'arrête dès que vous quittez. La solution est le **serveur dédié** (*Valheim Dedicated Server*, gratuit) : c'est un programme **séparé du jeu** qui tourne en fond.

- Vous pouvez fermer Valheim → le serveur continue, vos potes jouent.
- Vous rejoignez votre propre serveur comme n'importe quel joueur.
- ⚠️ Le **PC doit rester allumé** (et ne pas se mettre en veille). PC éteint = serveur éteint.

Configuration conseillée : 4 Go de RAM libres pour le serveur, connexion fibre/ADSL correcte (≈ 10 Mbit/s en envoi pour 4-5 joueurs).

---

## Installation sous Windows

Tous les scripts sont dans le dossier [`windows/`](windows/). Téléchargez ce dépôt (bouton **Code → Download ZIP**) et extrayez-le dans un dossier **sans accents**, par exemple `C:\Valheim-server`.

### 1. Configurer

Ouvrez `windows\config.bat` avec le Bloc-notes et modifiez :

| Paramètre | Rôle |
|---|---|
| `SERVER_NAME` | Nom du serveur |
| `WORLD_NAME` | Nom du monde (créé automatiquement s'il n'existe pas) |
| `SERVER_PASSWORD` | Mot de passe — **5 caractères minimum**, et il ne doit pas apparaître dans le nom |
| `SERVER_PUBLIC` | `1` = visible dans la liste publique, `0` = accès par IP uniquement |
| `CROSSPLAY` | `1` = crossplay Xbox/Game Pass + accès par **code d'invitation sans ouvrir de port** (voir étape 4) |
| `UPDATE_ON_START` | `1` = met à jour le serveur à chaque démarrage (recommandé : sinon, après une mise à jour du jeu, plus personne ne peut se connecter) |

### 2. Installer le serveur

Double-cliquez sur **`install-or-update.bat`**. Il télécharge SteamCMD puis le serveur dédié (≈ 1 Go). Aucun compte Steam n'est nécessaire.

### 3. Ouvrir le pare-feu Windows

Clic droit sur **`open-firewall.bat`** → *Exécuter en tant qu'administrateur*. Cela autorise les ports UDP 2456-2458.

### 4. Rendre le serveur accessible à vos amis

Deux options, choisissez-en **une** :

**Option A — Redirection de ports sur la box (classique)**

1. Trouvez l'IP locale de votre PC : tapez `ipconfig` dans un invite de commandes (ligne *Adresse IPv4*, ex. `192.168.1.20`).
2. Dans l'interface de votre box (Freebox, Livebox, SFR Box, Bbox… souvent `192.168.1.1` ou `mafreebox.freebox.fr`) :
   - attribuez une **IP fixe (bail DHCP statique)** à votre PC ;
   - créez une **redirection de ports** : **UDP 2456 à 2457** → IP locale du PC.
3. Votre IP publique est affichée sur https://www.monip.org. Vos amis se connecteront à `IP_PUBLIQUE:2456`.

> Si votre box est en « IP partagée » (CGNAT, fréquent sur certaines offres Free ou 4G/5G), la redirection ne marchera pas : demandez une IP fixe full-stack à votre FAI, ou utilisez l'option B.

**Option B — Crossplay / code d'invitation (aucun port à ouvrir)**

Mettez `CROSSPLAY=1` dans `config.bat`. Au démarrage, la console du serveur affiche une ligne du type `join code 123456`. Vos amis rejoignent avec ce code (*Rejoindre une partie → Rejoindre par code*). Le code change à chaque redémarrage du serveur. Le trafic passe par les relais de Microsoft/PlayFab, donc la latence peut être un peu plus élevée.

### 5. Lancer le serveur

Double-cliquez sur **`start-server.bat`**. Le serveur est prêt quand la console affiche `Game server connected`.

- Laissez cette fenêtre ouverte (vous pouvez la réduire).
- Si le serveur plante, il redémarre tout seul au bout de 15 secondes.
- **Arrêt propre** (le monde est sauvegardé) : cliquez dans la fenêtre, faites **Ctrl+C**, puis répondez **O** à « Terminer le programme de commandes ? ». Évitez de fermer la fenêtre avec la croix : vous pourriez perdre la progression depuis la dernière sauvegarde automatique (toutes les 30 min).

### 6. Se connecter

Dans Valheim : **Commencer → Rejoindre une partie → Ajouter un serveur** :

- **Vous** (même PC) : `127.0.0.1:2456`
- **Amis sur le même réseau** : `IP_LOCALE_DU_PC:2456`
- **Amis via Internet** : `IP_PUBLIQUE:2456` (option A) ou le code d'invitation (option B)

Le jeu et le serveur peuvent tourner en même temps sur le même PC.

### 7. (Optionnel) Démarrage automatique

Clic droit sur **`enable-autostart.bat`** → *Exécuter en tant qu'administrateur* : le serveur se lancera tout seul à chaque ouverture de votre session Windows. `disable-autostart.bat` annule.

### Empêcher la mise en veille

Le serveur ne fonctionne pas si le PC dort. Dans *Paramètres → Système → Alimentation*, mettez la mise en veille sur **Jamais** (secteur), ou en invite de commandes : `powercfg /change standby-timeout-ac 0`. Vous pouvez éteindre l'écran sans problème.

---

## Reprendre un monde existant

Vos mondes « solo / hébergés » sont dans :

```
%USERPROFILE%\AppData\LocalLow\IronGate\Valheim\worlds_local
```

1. Arrêtez le serveur.
2. Copiez `NomDuMonde.db` et `NomDuMonde.fwl` dans `windows\data\worlds_local\` (créez le dossier si besoin).
3. Mettez `WORLD_NAME=NomDuMonde` dans `config.bat`, puis relancez.

## Sauvegardes

Le monde du serveur est dans `windows\data\worlds_local\`. Valheim crée aussi des sauvegardes automatiques tournantes. Pour être tranquille, copiez régulièrement le dossier `windows\data\` ailleurs (clé USB, OneDrive…).

## Administrateurs

Pour pouvoir utiliser les commandes admin (kick, ban…) depuis le jeu, ajoutez votre **SteamID64** (trouvable sur https://steamid.io) sur une ligne du fichier `windows\data\adminlist.txt` (créé au premier lancement), puis redémarrez le serveur.

---

## Alternative : Linux / NAS / mini-PC (Docker)

Si vous avez une machine Linux allumée en permanence (plus économe qu'un PC de jeu), le dossier [`linux/`](linux/) contient un `docker-compose.yml` basé sur l'image [lloesche/valheim-server](https://github.com/lloesche/valheim-server-docker) (mises à jour et sauvegardes automatiques) :

```bash
cd linux
cp .env.example .env
nano .env               # nom, monde, mot de passe
docker compose up -d
docker compose logs -f  # suivre le démarrage
```

Les mondes sont dans `linux/config/worlds_local`. La redirection de ports (UDP 2456-2457) se fait de la même façon, vers l'IP de cette machine.

## Dépannage

| Problème | Piste |
|---|---|
| Vos amis ne voient pas / n'arrivent pas à rejoindre | Vérifiez la redirection UDP 2456-2457 sur la box et le pare-feu (étape 3). Testez d'abord en local avec `127.0.0.1:2456`. Sinon, passez à l'option B (crossplay). |
| « Version incompatible » | Le serveur n'est pas à jour : relancez-le (avec `UPDATE_ON_START=1`) ou lancez `install-or-update.bat`. |
| Le serveur se ferme aussitôt | Mot de passe trop court ou contenu dans le nom du serveur. Lisez les messages de la console. |
| Lag | Le serveur et le jeu partagent le même PC : fermez les applications lourdes, ou utilisez une autre machine (section Docker). |
