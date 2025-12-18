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
