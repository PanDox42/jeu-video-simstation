# SearchTree

**Extends:** `RefCounted`

SearchTree - Structure de données pour l'arbre de recherche

Classe qui gère la structure arborescente des recherches scientifiques.

Chaque nœud représente une recherche avec ses propriétés (coût, durée, description).

Permet de naviguer dans l'arbre via des algorithmes de parcours (DFS/BFS).


**Fichier:** `model\search_tree\search_tree.gd`

## Variables

### name: String

Classe interne représentant un nœud de recherche dans l'arbre
Contient toutes les données d'une recherche et ses liens parent/enfants
Nom de la recherche

### money: int

Gain d'argent apporté par cette recherche

### round: int

Nombre de rounds nécessaires pour compléter la recherche

### description: String

Description de la recherche

### unblocked: bool

Indique si la recherche est débloquée

### children: Array

Liste des nœuds enfants (recherches dépendantes)

### parent: NodeData

Nœud parent (recherche prérequise)

### science_cost: int

Coût en points de science

### building_unblocked: String

Nom du bâtiment débloqué par cette recherche (vide si aucun)

## Fonctions

### _init(k: String, t: int, gain_s: int, r_cost: int, desc: String, buil_unblocked: String)

Constructeur du nœud de recherche

**Paramètres:**

`k` : Nom de la recherche

`t` : Nombre de rounds requis

`gain_s` : Gain d'argent

`r_cost` : Coût en science

`desc` : Description

`buil_unblocked` : Bâtiment débloqué (optionnel)

### create_root(k: String, t: int, gain_s: int, r_cost: int, desc: String, buil_unblocked: String) -> NodeData

Racine de l'arbre de recherche
Crée la racine de l'arbre de recherche

**Paramètres:**

`k` : Nom de la recherche racine

`t` : Nombre de rounds requis

`gain_s` : Gain d'argent

`r_cost` : Coût en science

`desc` : Description

`buil_unblocked` : Bâtiment débloqué (optionnel)

**Retourne:** Le nœud racine créé

### add_child(parent: NodeData, k: String, t: int, gain_s: int, r_cost: int, desc: String, buil_unblocked: String) -> NodeData

Ajoute un nœud enfant à un nœud parent
Met automatiquement à jour les liens parent-enfant

**Paramètres:**

`parent` : Nœud parent

`k` : Nom de la nouvelle recherche

`t` : Nombre de rounds requis

`gain_s` : Gain d'argent

`r_cost` : Coût en science

`desc` : Description

`buil_unblocked` : Bâtiment débloqué (optionnel)

**Retourne:** Le nouveau nœud enfant créé

### depth_first_search(target, node: NodeData = null) -> NodeData

Recherche un nœud par son nom en parcourant l'arbre en profondeur (DFS)
Explore récursivement tous les enfants avant de passer à un autre parent

**Paramètres:**

`target` : Nom de la recherche à trouver

`node` : Nœud de départ (racine par défaut)

**Retourne:** Le nœud trouvé ou null

### breadth_first_search(target) -> NodeData

Recherche un nœud par son nom en parcourant l'arbre en largeur (BFS)
Explore tous les nœuds de même niveau avant de descendre

**Paramètres:**

`target` : Nom de la recherche à trouver

**Retourne:** Le nœud trouvé ou null
