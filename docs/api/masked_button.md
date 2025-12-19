# masked_button

**Extends:** `TextureButton`

MaskedButton - Bouton avec masque de clic personnalisé

Crée un masque de clic basé sur l'alpha de la texture du bouton.

Permet de rendre les zones transparentes de l'image non-cliquables,
améliorant la précision des clics sur des boutons de forme irrégulière.


**Fichier:** `model\button\masked_button.gd`

## Fonctions

### _ready()

Crée le masque de clic à partir de la texture normale
Utilise les zones opaques de l'image comme zone cliquable
