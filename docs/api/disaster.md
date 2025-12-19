# disaster

**Extends:** `Node`

Catastrophes - Système d'événements aléatoires pour SimStation

Gère les catastrophes et événements aléatoires qui peuvent affecter la station.

Chaque tour, le système vérifie si une catastrophe se déclenche selon
des probabilités définies. Une seule catastrophe peut se produire par round.


Les catastrophes affectent Santé, Bonheur et Efficacité avec des intensités variées.


**Fichier:** `model\global\disaster.gd`

## Variables

### disasters_available

Catalogue de toutes les catastrophes disponibles
Format par catastrophe: [Santé_Delta, Bonheur_Delta, Efficacité_Delta, Probabilité_%, Nom, Description]

**Types de catastrophes:**
- blizzard: Tempête fréquente (8% de chance), impact léger (-3/-2/-2)
- electrical_breakdown: Panne électrique (5%), impact moyen sur efficacité (-2/-3/-8)
- winter_flu: Grippe hivernale (4%), impact santé modéré (-7/-4/-2)
- seasonal_depression: Dépression saisonnière (3%), impact moral fort (-2/-10/-5)
- avalanche: Événement rare (1%), impact critique partout (-12/-12/-12)

### disaster_activated

Stocke la catastrophe actuellement active (null si aucune)

## Fonctions

### verify_disaster() -> Dictionary

Vérifie aléatoirement si une catastrophe se déclenche ce tour
Utilise un système de mélange pour éviter que le blizzard bloque toujours les autres

**Retourne:** Dictionnaire {"id": nom_catastrophe, "info": [données]} ou {} si aucune

### get_active_disaster()

Récupère la catastrophe actuellement active

**Retourne:** Dictionnaire de la catastrophe ou null
