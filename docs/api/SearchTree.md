# SearchTree

**Extends:** `RefCounted`

**Fichier:** `model\search_tree\search_tree.gd`

## Variables

### name: String

### money: int

### round: int

### description: String

### unblocked: bool

### children: Array

### parent: NodeData

### science_cost: int

### building_unblocked: String

### root: NodeData

### child

### result

### queue

### current

## Fonctions

### _init(k: String, t: int, gain_s: int, r_cost: int, desc: String, buil_unblocked: String)

### create_root(k: String, t: int, gain_s: int, r_cost: int, desc: String, buil_unblocked: String) -> NodeData

### add_child(parent: NodeData, k: String, t: int, gain_s: int, r_cost: int, desc: String, buil_unblocked: String) -> NodeData

### depth_first_search(target, node: NodeData = null) -> NodeData

### breadth_first_search(target) -> NodeData
