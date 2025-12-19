# 🐧 SimStation

**Jeu de gestion d'une station scientifique en Antarctique**

![Godot](https://img.shields.io/badge/Godot-4.x-blue?logo=godot-engine)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📖 Description

SimStation est un jeu de gestion où vous dirigez une station de recherche en Antarctique. Survivez 20 tours, gérez vos ressources et accomplissez votre mission scientifique dans l'un des environnements les plus hostiles de la planète.

> 📚 **[Voir la documentation complète](description.md)** pour les détails du gameplay, mécaniques et stratégies.

---

## 🎯 Objectif du jeu

**Gagner** = Survivre 20 tours + Terminer 7 recherches + Stats > 40%

**Perdre** = Une stat atteint 0% OU Tour 20 sans conditions remplies

---

## 🚀 Installation

### Prérequis

- [Godot Engine 4.x](https://godotengine.org/download)

### Lancer le projet

1. Cloner le repository :
```bash
git clone https://gitlab.music-music.music/votre-repo/simstation.git
```

2. Ouvrir Godot Engine

3. Importer le projet :
   - Cliquer sur "Import"
   - Naviguer vers le dossier du projet
   - Sélectionner `project.godot`

4. Lancer le jeu :
   - Appuyer sur **F5** ou cliquer sur ▶️

---

## 🗂️ Structure du projet

```
simstation/
├── controller/          # Logique de jeu
│   ├── game_manager.gd     # Gestionnaire principal
│   └── game_end_manager.gd # Conditions victoire/défaite
├── model/               # Données et calculs
│   ├── global/             # État global du jeu
│   ├── shop/               # Boutique de bâtiments
│   ├── search_tree/        # Arbre de recherche
│   └── hud/                # Interface utilisateur
├── view/                # Scènes et assets visuels
│   ├── *.tscn              # Scènes Godot
│   └── end_game.tscn       # Écran de fin
└── assets/              # Images, sons, polices
```

---

## 🎮 Commandes

| Action | Commande |
|--------|----------|
| Ouvrir la boutique | Clic sur icône boutique |
| Placer un bâtiment | Clic gauche sur la carte |
| Ouvrir l'arbre de recherche | Clic sur icône recherche |
| Passer au tour suivant | Clic sur bouton "Suivant" |

---

## 🔧 Configuration technique

### Constantes importantes

| Fichier | Constante | Valeur | Description |
|---------|-----------|--------|-------------|
| `game_end_manager.gd` | `FINAL_ROUND` | 20 | Tours pour victoire |
| `game_end_manager.gd` | `MIN_STATS_THRESHOLD` | 40 | Seuil stats victoire |
| `calcul_stats.gd` | `BUILDINGS_PER_BOILER` | 3 | Capacité chaufferie |
| `calcul_stats.gd` | `HEATING_POWER_PER_BUILDING` | 9 | Puissance chauffage |

---

## 📚 Documentation

| Document | Contenu |
|----------|---------|
| [description.md](description.md) | Gameplay, mécaniques, stratégies |
| [docs/](docs/) | Documentation technique générée |

---

## 👥 Équipe

Projet réalisé dans le cadre du cursus universitaire.

---

## 📄 Licence

Ce projet est sous licence MIT.
