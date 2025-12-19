# crop_bar

**Extends:** `Sprite2D`

CropBar - Barre de progression visuelle pour les statistiques

Affiche une barre de remplissage qui représente visuellement un pourcentage.

Utilisé pour montrer la santé, l'efficacité et le bonheur de la population.

Se met à jour automatiquement chaque frame selon son nom de nœud.


**Fichier:** `model\hud\statistics\crop_bar.gd`

## Fonctions

### _update_bar(value: int)

Met à jour la région visible de la barre selon une valeur (0-100)

**Paramètres:**

`value` : Pourcentage à afficher (0-100)

### _process(_delta)

Met automatiquement à jour la barre selon son nom de nœud
Supporte: SpriteFilledBarHealth, SpriteFilledBarEfficiency, SpriteFilledBarHappiness

**Paramètres:**

`_delta` : Delta time
