extends RefCounted
class_name SearchTree

# DESCRIPTION :
# Script de gestion d'un arbre de recherche (SearchTree), étendant RefCounted.
# Il s'appuie sur une classe interne NodeData qui contient les propriétés d'une recherche :
# name, coût en money, coût en temps, description, état débloqué, ainsi que ses liens (parent/childs).
# Les fonctions disponibles sont :
# _init() : Constructeur de base (implicite ou hérité).
# create_root : Initialise la racine de l'arbre avec les données spécifiées.
# add_child : Ajoute un nouveau nœud enfant à un parent donné et met à jour les liens.
# depth_first_search : Parcourt l'arbre en profondeur pour trouver un nœud par son name.
# breadth_first_search : Parcourt l'arbre en largeur pour trouver un nœud par son name.

class NodeData:
	var name: String
	var money: int
	var round: int
	var description: String
	var unblocked: bool
	var children: Array = []
	var parent: NodeData
	var science_cost: int
	var building_unblocked: String

	func _init(k: String, t: int, gain_s: int, r_cost: int, desc: String, buil_unblocked: String):
		name = k
		money = gain_s
		round = t
		description = desc
		unblocked = false
		science_cost = r_cost
		building_unblocked = buil_unblocked

var root: NodeData

func create_root(k: String, t: int, gain_s: int, r_cost: int, desc: String, buil_unblocked: String) -> NodeData:
	root = NodeData.new(k, t, gain_s, r_cost, desc, buil_unblocked)
	return root

func add_child(parent: NodeData, k: String, t: int, gain_s: int, r_cost: int, desc: String, buil_unblocked: String) -> NodeData:
	var child = NodeData.new(k, t, gain_s, r_cost, desc, buil_unblocked)
	child.parent = parent
	parent.children.append(child)
	return child

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
