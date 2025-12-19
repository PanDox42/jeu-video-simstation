# chart_search_tree

**Extends:** `CanvasLayer`

**Fichier:** `model\search_tree\chart_search_tree.gd`

## Variables

### tree: SearchTree

Signal émis quand l'argent change (non utilisé actuellement)
Instance de l'arbre de recherche (structure de données)

### node_positions

Dictionnaire des positions des nœuds {NodeData: Vector2}

### current_menu

Menu contextuel actuellement affiché (null si aucun)

### roots

Espacement horizontal entre les nœuds
Espacement vertical entre les niveaux
Rayon d'un nœud (pour le dessin des lignes)
Espacement entre les différents arbres (colonnes)
Liste des 3 racines d'arbres [Infrastructure, Science, Communications]

### dernier_round_connu

Dernier round connu pour éviter les rafraîchissements inutiles

### tree_canvas

Conteneur de scroll pour naviguer dans l'arbre
Canvas interne pour dessiner les boutons et les lignes

### root

Racine principale de l'arbre de recherche

## Fonctions

### _ready()

Initialise l'interface et construit les 3 arbres de recherche

### _on_round_changed()

Appelé quand le round change
Vérifie si des recherches sont terminées

### _check_research_completion()

Vérifie si des recherches en cours sont finies
Met à jour l'UI si nécessaire

### _complete_research(name_recherche: String)

Termine une recherche : applique les gains et débloque les bâtiments

**Paramètres:**

`name_recherche` : Nom de la recherche à compléter

### _find_node_by_name(node, name_to_find)

Recherche un nœud par son nom dans l'arbre (récursif)

**Paramètres:**

`node` : Nœud de départ

`name_to_find` : Nom à trouver

**Retourne:** Le nœud trouvé ou null

### _update_tree_state_recursive(node)

Met à jour l'état local (unblocked/pas unblocked) en fonction du Global au démarrage

**Paramètres:**

`node` : Nœud à mettre à jour (récursif)

### _create_buttons_recursive(node: SearchTree.NodeData)

Crée les boutons pour tous les nœuds de l'arbre (récursif)
Applique les couleurs selon l'état : gris (bloqué), jaune (en cours), vert (terminé), blanc (disponible)

**Paramètres:**

`node` : Nœud pour lequel créer le bouton

### ajouter_retirer_menu_node(position: Vector2, node: SearchTree.NodeData)

Affiche ou met à jour le menu contextuel d'un nœud de recherche

**Paramètres:**

`position` : Position où afficher le menu

`node` : Nœud de recherche sélectionné

### lancer_recherche(node)

Lance une nouvelle recherche

**Paramètres:**

`node` : Nœud de recherche à lancer

### _refresh_ui()

Rafraîchit toute l'interface en supprimant et recréant tous les boutons

### _calculate_positions(node, position, depth)

Calcule récursivement les positions de tous les nœuds dans l'arbre

**Paramètres:**

`node` : Nœud à positionner

`position` : Position de départ

`depth` : Profondeur dans l'arbre

### _setup_scroll_area()

Configure la taille du canvas en fonction des positions calculées

### _get_subtree_width(node) -> int

Calcule la largeur d'un sous-arbre (nombre de feuilles)

**Paramètres:**

`node` : Racine du sous-arbre

**Retourne:** Largeur du sous-arbre

### _on_tree_canvas_draw()

Callback de dessin pour tracer les lignes entre les nœuds

### _draw_lines_recursive(node)

Dessine récursivement les lignes reliant les nœuds parents aux enfants

**Paramètres:**

`node` : Nœud de départ

### _on_exit_button_pressed() -> void

Ferme l'interface de l'arbre de recherche
