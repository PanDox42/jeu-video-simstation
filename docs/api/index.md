# Documentation API - SimStation

*Générée le 2025-12-18 à 23:49*

Cette documentation couvre **24** fichiers GDScript du projet SimStation.

## Controller

- [game_manager](game_manager.md) - `controller\game_manager.gd`

## Model

- [InventaireUI](InventaireUI.md) - `model\hud\inventory\InventaireUI.gd`
- [SearchTree](SearchTree.md) - `model\search_tree\search_tree.gd`
- [button_action](button_action.md) - `model\button\button_action.gd`
- [buy_confirmation](buy_confirmation.md) - `model\shop\buy_confirmation.gd`
- [calcul_stats](calcul_stats.md) - `model\global\calcul_stats.gd`
- [camera_2d](camera_2d.md) - `model\hud\camera\camera_2d.gd`
- [chart_search_tree](chart_search_tree.md) - `model\search_tree\chart_search_tree.gd`
- [chart_stats](chart_stats.md) - `model\hud\statistics\chart_stats.gd`
- [credits](credits.md) - `model\main_menu\credits.gd`
- [crop_bar](crop_bar.md) - `model\hud\crop_bar.gd`
- [disaster](disaster.md) - `model\global\disaster.gd`
- [drag_building](drag_building.md) - `model\hud\inventory\drag_building.gd`
- [global](global.md) - `model\global\global.gd`
- [global_script](global_script.md) - `model\global\global_script.gd`
- [hud](hud.md) - `model\hud\hud.gd`
- [info_panel](info_panel.md) - `model\hud\info_panel.gd`
- [main_menu](main_menu.md) - `model\main_menu\main_menu.gd`
- [map](map.md) - `model\map\map.gd`
- [masked_button](masked_button.md) - `model\button\masked_button.gd`
- [pause](pause.md) - `model\pause\pause.gd`
- [settings](settings.md) - `model\pause\settings.gd`
- [shop](shop.md) - `model\shop\shop.gd`
- [tuto](tuto.md) - `model\main_menu\tuto.gd`

---

## Format des commentaires

```gdscript
## Description de la classe
extends Node

## Description de la variable
var ma_variable: int

## Description de la fonction
## @param param1: Description du paramètre
## @return: Description de la valeur de retour
func ma_fonction(param1: String) -> bool:
    return true
```