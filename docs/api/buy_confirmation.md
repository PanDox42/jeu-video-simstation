# buy_confirmation

**Extends:** `CanvasLayer`

BuyConfirmation - Fenêtre de confirmation d'achat

Popup de confirmation affiché avant l'achat d'un bâtiment.

Vérifie que le joueur a suffisamment d'argent et affiche un message approprié.

Gère la transaction (débit de l'argent et ajout du bâtiment à l'inventaire).


**Fichier:** `model\shop\buy_confirmation.gd`

## Variables

### building

Label affichant le message de confirmation ou d'erreur
Bouton de confirmation d'achat
Chemin du son de confirmation d'achat
Prix du bâtiment à acheter
Argent disponible du joueur
Argent requis pour l'achat
Nom d'affichage du bâtiment
Constante pour le son d'achat
Nom interne du bâtiment à acheter (défini depuis shop.gd)

## Fonctions

### _ready()

Initialise le popup avec le message approprié
Affiche soit la confirmation, soit un message d'erreur si pas assez d'argent

### _on_confirm_button_pressed() -> void

Confirme l'achat du bâtiment
Débite l'argent, ajoute le bâtiment à l'inventaire et joue le son d'achat

### _on_cancel_button_pressed() -> void

Annule l'achat et ferme le popup
