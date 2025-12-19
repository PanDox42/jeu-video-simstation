## SearchTree - Structure de données pour l'arbre de recherche
##
## Classe qui gère la structure arborescente des recherches scientifiques.
## Chaque nœud représente une recherche avec ses propriétés (coût, durée, description).
## Permet de naviguer dans l'arbre via des algorithmes de parcours (DFS/BFS).
extends RefCounted
class_name SearchTree

## Classe interne représentant un nœud de recherche dans l'arbre
## Contient toutes les données d'une recherche et ses liens parent/enfants
class NodeData:
	## Nom de la recherche
	var name: String
	
	## Gain d'argent apporté par cette recherche
	var money: int
	
	## Nombre de rounds nécessaires pour compléter la recherche
	var round: int
	
	## Description de la recherche
	var description: String
	
	## Indique si la recherche est débloquée
	var unblocked: bool
	
	## Liste des nœuds enfants (recherches dépendantes)
	var children: Array = []
	
	## Nœud parent (recherche prérequise)
	var parent: NodeData
	
	## Coût en points de science
	var science_cost: int
	
	## Nom du bâtiment débloqué par cette recherche (vide si aucun)
	var building_unblocked: String

	## Constructeur du nœud de recherche
	## @param k: Nom de la recherche
	## @param t: Nombre de rounds requis
	## @param gain_s: Gain d'argent
	## @param r_cost: Coût en science
	## @param desc: Description
	## @param buil_unblocked: Bâtiment débloqué (optionnel)
	func _init(k: String, t: int, gain_s: int, r_cost: int, desc: String, buil_unblocked: String):
		name = k
		money = gain_s
		round = t
		description = desc
		unblocked = false
		science_cost = r_cost
		building_unblocked = buil_unblocked

## Racine de l'arbre de recherche
var root: NodeData

## Crée la racine de l'arbre de recherche
## @param k: Nom de la recherche racine
## @param t: Nombre de rounds requis
## @param gain_s: Gain d'argent
## @param r_cost: Coût en science
## @param desc: Description
## @param buil_unblocked: Bâtiment débloqué (optionnel)
## @return: Le nœud racine créé
func create_root(k: String, t: int, gain_s: int, r_cost: int, desc: String, buil_unblocked: String) -> NodeData:
	root = NodeData.new(k, t, gain_s, r_cost, desc, buil_unblocked)
	return root

## Ajoute un nœud enfant à un nœud parent
## Met automatiquement à jour les liens parent-enfant
## @param parent: Nœud parent
## @param k: Nom de la nouvelle recherche
## @param t: Nombre de rounds requis
## @param gain_s: Gain d'argent
## @param r_cost: Coût en science
## @param desc: Description
## @param buil_unblocked: Bâtiment débloqué (optionnel)
## @return: Le nouveau nœud enfant créé
func add_child(parent: NodeData, k: String, t: int, gain_s: int, r_cost: int, desc: String, buil_unblocked: String) -> NodeData:
	var child = NodeData.new(k, t, gain_s, r_cost, desc, buil_unblocked)
	child.parent = parent
	parent.children.append(child)
	return child

## Recherche un nœud par son nom en parcourant l'arbre en profondeur (DFS)
## Explore récursivement tous les enfants avant de passer à un autre parent
## @param target: Nom de la recherche à trouver
## @param node: Nœud de départ (racine par défaut)
## @return: Le nœud trouvé ou null
func depth_first_search(target, node: NodeData = null) -> NodeData:
	if node == null:
		node = root

	if node.name == target:
		return node

	for child in node.children:
		var result = depth_first_search(target, child)
		if result != null:
			return result

	return null

## Recherche un nœud par son nom en parcourant l'arbre en largeur (BFS)
## Explore tous les nœuds de même niveau avant de descendre
## @param target: Nom de la recherche à trouver
## @return: Le nœud trouvé ou null
func breadth_first_search(target) -> NodeData:
	if root == null:
		return null

	var queue = [root]

	while queue.size() > 0:
		var current = queue.pop_front()
		if current.name == target:
			return current
		for child in current.children:
			queue.append(child)

	return null
