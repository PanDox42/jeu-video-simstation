# 🐧 SimStation - README Complet

Ce document contient les instructions pour les joueurs, les développeurs et les détails techniques du projet.

---

## 🎮 1. SECTION UTILISATEUR (JOUER)

Si vous souhaitez simplement tester le jeu sans utiliser l'éditeur Godot :

### 🪟 Windows
1. Téléchargez le dossier Windows.
2. Assurez-vous que le fichier **`SimStation.exe`** et le fichier **`.pck`** sont dans le même répertoire.
3. Double-cliquez sur `SimStation.exe`.

### 🐧 Linux
1. Téléchargez les fichiers **`SimStation.sh`** et **`SimStation.x86_64`**.
2. Ouvrez un terminal dans le dossier et autorisez l'exécution :
   ```bash
   chmod +x SimStation.sh
   ```
3. Lancez le jeu avec :
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
git clone https://gitlab.example.com/votre-repo/simstation.git
```

### Importation
1. Ouvrez Godot.
2. Cliquez sur **Importer**.
3. Sélectionnez le fichier `project.godot` à la racine du projet.

### Lancement
Appuyez sur **F5** pour démarrer le projet dans l'éditeur.

---

## 🎯 3. RÈGLES DU JEU

- **Concept** : Dirigez une station en Antarctique.
- **Victoire** : Survivre 20 tours + Terminer 7 recherches + Statistiques > 40%.
- **Défaite** : Une statistique tombe à 0% ou les conditions ne sont pas remplies au tour 20.

---

## ⌨️ 4. COMMANDES

| Action | Commande |
|--------|----------|
| Boutique | Clic sur l'icône boutique |
| Bâtiment | Clic gauche sur la carte |
| Recherche | Clic sur l'icône recherche |
| Tour suivant | Clic sur bouton "Suivant" |

---

## 🗂️ 5. STRUCTURE DU PROJET

```
simstation/
├── project.godot         # Fichier projet principal (Godot)
├── controller/           # Scripts de gestion (GameManager, etc.)
├── model/                # Logique de données (Shop, HUD, Stats)
├── view/                 # Scènes visuelles (.tscn)
└── assets/               # Ressources (Images, sons, fonts)
```

---

## 🔧 6. CONFIGURATION TECHNIQUE (EQUILIBRAGE)

Les réglages se font via les constantes dans les scripts `.gd` :

| Fichier | Constante | Valeur |
|---------|-----------|--------|
| `game_end_manager.gd` | `FINAL_ROUND` | 20 |
| `game_end_manager.gd` | `MIN_STATS_THRESHOLD` | 40 |
| `calcul_stats.gd` | `BUILDINGS_PER_BOILER` | 3 |

---

## 📝 NOTES COMPLÉMENTAIRES

- **Exportation** : Pour générer de nouveaux exécutables, utilisez le menu **Projet > Exporter** dans Godot.
- **Documentation** : Consultez `WIKI.md` pour les stratégies avancées.
- **Licence** : Ce projet est sous licence MIT.

*Projet réalisé dans le cadre d'un cursus universitaire.*
