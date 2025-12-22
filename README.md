# ❄️ SimStation - README

[![Status](https://camo.githubusercontent.com/43016e90af7ddd2f27160ce75c236c7c5380d0b2c4812d3153751e1053c39179/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f5374617475742d5465726d696e2543332541392d73756363657373)](https://github.com/PanDox42/jeu-video-simstation)

Ce document contient les instructions pour les joueurs, les développeurs et les détails techniques du projet.

---

## 🎮 1. SECTION UTILISATEUR (JOUER)

Si vous souhaitez simplement tester le jeu sans utiliser l'éditeur Godot :

### 🪟 Windows
1. Naviguez dans le dossier **`installer/windows/`**.
2. Lancez l'installeur **`SimStation_Installer.exe`**.
3. Suivez les instructions pour installer le jeu sur votre système.
4. Lancez SimStation depuis le menu démarrer ou via le raccourci créé.

### 🐧 Linux
1. Naviguez dans le dossier **`installer/linux/`**.
2. Assurez-vous que tous les fichiers sont présents :
   - `SimStation.x86_64` (exécutable)
   - `SimStation.pck` (ressources du jeu)
   - `SimStation.sh` (script de lancement)
3. Ouvrez un terminal dans ce dossier et autorisez l'exécution :
   ```bash
   chmod +x SimStation.sh SimStation.x86_64
   ```
4. Lancez le jeu avec :
   ```bash
   ./SimStation.sh
   ```

---

## 🛠️ 2. SECTION DÉVELOPPEUR (SOURCES)

Pour modifier le projet ou l'étudier, vous devez utiliser le moteur Godot.

### Prérequis
- Installez **Godot Engine 4.x**.

### Récupération
Clonez le dépôt git :
```bash
git clone https://github.com/PanDox42/jeu-video-simstation
```

### Importation
1. Ouvrez Godot.
2. Cliquez sur **Importer**.
3. Sélectionnez le fichier `project.godot` situé dans le dossier **`simstation/`**.

### Lancement
Appuyez sur **F5** pour démarrer le projet dans l'éditeur.

---

## 🎯 3. RÈGLES DU JEU

- **Concept** : Dirigez une station en Antarctique.
- **Victoire** : Survivre 20 tours + Terminer les 7 recherches + Statistiques > 40%.
- **Défaite** : Une statistique tombe à 0% ou les conditions ne sont pas remplies au tour 20.

---

## ⌨️ 4. COMMANDES

| Action | Commande |
|--------|----------|
| Boutique | Clic sur l'icône boutique |
| Bâtiment | Clic gauche sur la carte |
| Recherche | Clic sur le bouton recherche du laboratoire |
| Tour suivant | Clic sur le bouton passer le tour |

---

## 🗂️ 5. STRUCTURE DU PROJET

```
t3-simstation/
├── installer/            # Builds exportés pour les utilisateurs
│   ├── windows/          # Installeur Windows
│   │   └── SimStation_Installer.exe
│   └── linux/            # Fichiers Linux
│       ├── SimStation.x86_64
│       ├── SimStation.pck
│       └── SimStation.sh
├── simstation/           # Code source du projet
│   ├── project.godot     # Fichier projet principal (Godot)
│   ├── controller/       # Scripts de gestion (GameManager, etc.)
│   ├── model/            # Logique de données (Shop, HUD, Stats)
│   ├── view/             # Scènes visuelles (.tscn)
│   └── assets/           # Ressources (Images, sons, fonts)
├── docs/                 # Documentation générée (Docsify)
└── README.md             # Ce fichier
```

---

## 🖼️ Quelques images du jeu

<div align="center">

# Menu Principal
<img src="img/main_menu.jpg" alt="Main Menu" width="800">

# Nouvelle Partie
<img src="img/new_game.jpg" alt="New Game" width="800">

# Charger une Partie (Continuer)
<img src="img/load_game.jpg" alt="Load Game" width="800">

# En Jeu
<img src="img/in_game_1.jpg" alt="In Game" width="800">

# Catastrophe naturelle
<img src="img/disaster.jpg" alt="Disaster" width="800">

# Arbre de Recherche
<img src="img/search_tree.jpg" alt="Search Tree" width="800">

# Boutique
<img src="img/shop.jpg" alt="Shop" width="800">

</div>

---

## 📝 NOTES COMPLÉMENTAIRES

- **Exportation** : Pour générer de nouveaux exécutables, utilisez le menu **Projet > Exporter** dans Godot.
- **Documentation** : Consultez `WIKI.md` pour les stratégies avancées ou la [documentation SimStation](https://t4-simstation-mschnider-0c3992935ec57cbdfa0167207f3802487810b77.pages.unistra.fr/#/) pour plus d'informations concernant l'aspect technique du projet. 
- **Licence** : Ce projet est sous licence MIT.

*Projet réalisé dans le cadre d'un BUT INFORMATIQUE.*
