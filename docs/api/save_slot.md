# save_slot

**Extends:** `TextureButton`

**Fichier:** `model\main_menu\save_slot.gd`

## Variables

### slot_file_name

Nom du fichier de sauvegarde (sans extension .json)

## Fonctions

### setup(file_name, money, date)

Signal émis lors de la sélection d'un slot de sauvegarde
Configure les informations affichées sur le slot de sauvegarde

**Paramètres:**

`file_name` : Nom du fichier de sauvegarde

`money` : Argent disponible (non utilisé)

`date` : Dictionnaire contenant la date de sauvegarde

### _on_pressed()

Appelé lors du clic sur le slot
Émet le signal slot_selected avec le nom du fichier
