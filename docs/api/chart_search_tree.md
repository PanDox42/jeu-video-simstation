# chart_search_tree

**Extends:** `CanvasLayer`

**Fichier:** `model\search_tree\chart_search_tree.gd`

## Variables

### tree: SearchTree

### node_positions

### current_menu

### roots

### dernier_round_connu

### tree_canvas

### root_infra

### infra_2a

### infra_3a

### infra_2b

### infra_3b

### infra_final

### root_science

### sci_2

### sci_3a

### sci_4a

### sci_3b

### sci_4b

### sci_final

### root_comms

### com_2

### com_3a

### com_4a

### com_3b

### start_x

### current_turn

### changes_made

### recherches_names

### round_fin

### node

### res

### position

### btn

### texte

### margin_container

### texture_path_normal

### texture_img_normal

### texture_path_hover

### texture_img_hover

### texture_path_clic

### texture_img_clic

### font_path_normal

### font_normal

### button_size

### menu

### name

### search_buttonerche

### texte_desc

### current_y

### bat_label

### building_name

### current_round

### round_fin

### x_offset

### child_x

### min_x

### padding

### shift_vector

### width

### position

### child_pos

### play_scene

### hud

## Fonctions

### _ready()

### _on_round_changed()

### _check_research_completion()

### _complete_research(name_recherche: String)

### _find_node_by_name(node, name_to_find)

### _update_tree_state_recursive(node)

### _create_buttons_recursive(node: SearchTree.NodeData)

### ajouter_retirer_menu_node(position: Vector2, node: SearchTree.NodeData)

### lancer_recherche(node)

### _refresh_ui()

### _calculate_positions(node, position, depth)

### _setup_scroll_area()

### _get_subtree_width(node) -> int

### _on_tree_canvas_draw()

### _draw_lines_recursive(node)

### _on_exit_button_pressed() -> void
