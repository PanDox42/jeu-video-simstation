# SimStation - Description détaillée du jeu

## 📚 Objectifs pédagogiques

Ce projet SimStation vise à développer plusieurs compétences techniques et transversales :

### Compétences techniques
- **Maîtrise du moteur Godot** : Apprentissage approfondi de l'environnement de développement Godot 4.x, de son système de scènes et de son langage GDScript
- **Programmation orientée objet** : Utilisation de structures de données complexes, gestion d'états et d'événements
- **Développement de systèmes de jeu** : Implémentation de mécaniques de gameplay (construction, gestion de ressources, événements aléatoires)
- **Graphisme isométrique** : Maîtrise de l'affichage 2D isométrique et de la gestion de grilles
- **Architecture logicielle** : Séparation Modèle-Vue-Contrôleur (MVC) pour une base de code maintenable

### Compétences en gestion de projet
- **Planification** : Utilisation d'outils de gestion de projet (GANTT, PERT)
- **Travail en équipe** : Collaboration au sein d'une équipe de 4 développeurs
- **Gestion des risques** : Identification et mitigation des risques projet
- **Respect des délais** : Livraison d'un produit fonctionnel dans un délai contraint de 14 semaines

### Compétences transversales
- **Résolution de problèmes complexes** : Équilibrage du gameplay, gestion de la complexité technique
- **Créativité** : Conception de mécaniques de jeu engageantes dans un contexte contraint
- **Adaptation** : Gestion d'imprévus techniques et ajustement du périmètre fonctionnel

---

## 🎮 Description sommaire du jeu

### Genre
**SimStation** est un jeu de **simulation et gestion stratégique** en 2D isométrique.

### Type de gameplay
- **Tour par tour stratégique** : Chaque tour représente 3 mois de temps de jeu
- **Gestion de ressources** : Équilibrage entre argent, santé, efficacité et bonheur
- **Construction et développement** : Placement de bâtiments sur une grille isométrique
- **Progression par la recherche** : Déblocage de nouvelles technologies et bâtiments

### Contexte
Le joueur dirige une **station scientifique polaire en Antarctique** et doit assurer la survie et le bien-être de son équipage dans un environnement extrêmement hostile. Le jeu combine la planification à long terme, la gestion de crises et l'adaptation à des événements imprévisibles.

---

## 🕹️ Actions du joueur

Le joueur dispose de plusieurs actions pour gérer sa station :

### 1. Construction de bâtiments 🏗️
- **Placer des bâtiments** sur la grille isométrique de la station
- **Choisir l'emplacement stratégique** en fonction des besoins et de l'espace disponible
- **Gérer l'inventaire** des bâtiments disponibles

**Bâtiments disponibles** :
- **Laboratoire de recherche** : Permet de progresser dans l'arbre technologique
- **Dortoir** : Améliore le repos et le bien-être de l'équipage (+60 bonheur)
- **Chaufferie** : Chauffe tous les bâtiments de la station (+60 bonheur)
- **Hôpital** : Soigne les membres d'équipage malades (+60 bonheur)
- **Cantine** : Fournit de la nourriture chaude (+70 bonheur) [À débloquer]
- **Salle de sport** : Améliore la condition physique (+70 bonheur) [À débloquer]
- **Salle de repos** : Offre un espace de détente (+60 bonheur) [À débloquer]
- **Observatoire** : Permet des découvertes scientifiques (+50 bonheur) [À débloquer]

### 2. Gestion des achats 💰
- **Acheter de nouveaux bâtiments** via le système de boutique
- **Planifier les commandes** : Les livraisons prennent plusieurs mois (délai de livraison)
- **Gérer le budget** : Argent initial de 3 000 000 unités, dépenses importantes pour chaque bâtiment
- **Anticiper les besoins futurs** en fonction de l'évolution des statistiques

### 3. Recherche et développement 🔬
- **Débloquer des technologies** via l'arbre de recherche
- **Choisir des branches de recherche** en fonction de la stratégie adoptée :
  - **Branche Infrastructure** : Débloquer salle de sport, cantine, salle de repos
  - **Branche Science** : Débloquer observatoire et autres avancées scientifiques
- **Progresser graduellement** dans l'arbre technologique pour accéder à de nouveaux bâtiments et améliorations

### 4. Gestion du temps ⏰
- **Avancer les tours** : Chaque tour correspond à 3 mois de temps de jeu
- **Planifier à long terme** : Les décisions d'aujourd'hui ont des conséquences plusieurs tours plus tard
- **Anticiper les saisons** : Le jeu alterne entre été et hiver austral avec des défis différents

### 5. Prise de décisions stratégiques 🎯
- **Prioriser les investissements** : Choisir entre santé, bonheur ou efficacité
- **Réagir aux événements aléatoires** : Tempêtes, pannes, crises psychologiques
- **Optimiser l'utilisation de l'espace** limité sur la grille de construction
- **Équilibrer développement et survie** immédiate

### 6. Sauvegarde et gestion des parties 💾
- **Sauvegarder la progression** pour reprendre ultérieurement
- **Charger des parties existantes**
- **Gérer plusieurs profils** de joueurs

---

## 📊 Informations renvoyées au joueur

Le jeu fournit au joueur un ensemble d'indicateurs et de feedbacks pour l'aider dans ses décisions :

### Indicateurs vitaux (en temps réel)
Le joueur visualise en permanence 4 statistiques principales :

#### 1. 🏥 Santé (0-100)
- **Définition** : État physique général de l'équipage
- **Facteurs d'influence** :
  - Température extérieure (varie de -25°C à -39°C)
  - Présence et fonctionnement de la chaufferie
  - Disponibilité de l'hôpital en cas de maladie
  - Événements catastrophiques (accidents, maladies)
- **Indication visuelle** : Barre de progression

#### 2. ⚙️ Efficacité (0-100)
- **Définition** : Capacité de la station à fonctionner et à produire
- **Facteurs d'influence** :
  - Nombre et type de bâtiments fonctionnels
  - État de santé et de bonheur de l'équipe
  - Recherches débloquées
- **Indication visuelle** : Barre de progression

#### 3. 😊 Bonheur (0-100)
- **Définition** : État psychologique et moral de l'équipage
- **Facteurs d'influence** :
  - Qualité des infrastructures (dortoirs, salle de repos, etc.)
  - Accès aux loisirs et au confort (salle de sport, cantine)
  - Isolement et conditions climatiques
  - Événements aléatoires (crises psychologiques)
- **Indication visuelle** : Barre de progression

#### 4. 🔬 Science (0-100)
- **Définition** : Niveau de progression scientifique de la station
- **Facteurs d'influence** :
  - Présence de laboratoires de recherche
  - Recherches en cours et complétées
  - Efficacité globale de la station
- **Indication visuelle** : Barre de progression

### Informations sur l'environnement 🌡️
- **Température actuelle** : Affichage en degrés Celsius (varie aléatoirement entre -25°C et -39°C)
- **Saison** : Indication de la saison actuelle (Été austral / Hiver austral)
- **Cycle jour/nuit** : Visualisation graphique du moment de la journée
- **Conditions météorologiques** : Alertes en cas de tempête ou conditions extrêmes

### Informations sur la gestion 💼
- **Argent disponible** : Montant actuel du budget (initialement 3 000 000)
- **Inventaire des bâtiments** : Liste des bâtiments possédés mais non encore placés
- **Bâtiments placés** : Affichage visuel sur la carte avec état (température, santé du bâtiment)
- **Numéro du tour actuel** : Progression temporelle de la partie

### Informations sur la recherche 🌲
- **Arbre de recherche** : Visualisation graphique des technologies disponibles et débloquées
- **Recherches en cours** : Indication de la progression des recherches actives
- **Recherches débloquées** : Liste des technologies déjà acquises

### Interface de boutique 🏪
- **Bâtiments disponibles à l'achat** avec :
  - Nom et description du bâtiment
  - Prix d'achat
  - Effet sur le bonheur
  - Délai de livraison estimé
  - Statut (débloqué ou verrouillé selon la recherche)

### Événements et notifications 📢
- **Messages d'événements aléatoires** : Description textuelle des catastrophes ou événements
- **Conséquences** : Impact chiffré sur les statistiques (ex: -20 santé, -15 bonheur)
- **Alertes critiques** : Notification quand un indicateur atteint un seuil dangereux

### Graphiques et historique 📈
- **Évolution des statistiques** : Graphiques montrant l'évolution des 4 indicateurs au fil des tours
- **Analyse de performance** : Comparaison entre différentes phases de la partie

### Conditions de victoire/défaite 🏆
- **Objectif à atteindre** : Survivre un certain nombre de tours
- **Conditions de défaite** :
  - Santé de l'équipage tombant à 0
  - Bonheur atteignant un niveau critique prolongé
  - Faillite économique (argent insuffisant et station non viable)

### Aide contextuelle ℹ️
- **Descriptions des bâtiments** : Tooltip avec informations détaillées au survol
- **Tutoriel intégré** : Guides pour les premières actions
- **Panneau d'information** : Détails sur les mécaniques de jeu

---

## 🎯 Objectif de victoire

Le joueur doit **maintenir la station opérationnelle et l'équipage en bonne santé pendant un nombre défini de tours** (période à déterminer selon le niveau de difficulté).

### Conditions de victoire
- Tous les indicateurs restent au-dessus de seuils critiques
- La station atteint un certain niveau de développement
- L'équipage survit à la période complète sans abandon

### Conditions de défaite
- Un indicateur vital (Santé, Efficacité ou Bonheur) tombe à 0
- Impossibilité financière de poursuivre les opérations
- Série d'événements catastrophiques rendant la station inhabitable

---

## 🌟 Spécificités du jeu

### Système de catastrophes aléatoires
Le jeu intègre des événements imprévisibles qui diversifient chaque partie :
- **Tempêtes de neige** : Dommages aux bâtiments, impossibilité de construire
- **Pannes techniques** : Perte temporaire d'efficacité
- **Crises psychologiques** : Baisse importante du bonheur
- **Accidents** : Blessures nécessitant des soins médicaux

### Cycle jour/nuit
- Alternance visuelle entre jour et nuit
- Impact potentiel sur certaines activités et le moral

### Progression non linéaire
- Plusieurs stratégies viables (focus sur science, sur confort, équilibré)
- Rejouabilité grâce à l'aléatoire et aux choix de recherche

---

## 🎨 Style graphique

- **Vue isométrique 2D** : Permet une vision claire de l'organisation spatiale
- **Environnement polaire** : Tilesets de neige, glace, rochers
- **Interface épurée** : Focus sur la lisibilité des informations critiques
- **Ambiance immersive** : Musiques adaptées (Ori, Dark Souls OST)

---

## 🎵 Audio

- **Musiques d' ambiance** : Créent une atmosphère immersive et contemplative
- **Effets sonores** : Renforcent le feedback des actions du joueur

---

**SimStation** offre une expérience de gestion stratégique exigeante où chaque décision compte. Le joueur doit faire preuve d'anticipation, de flexibilité et de capacité d'adaptation pour maintenir sa station en vie dans l'un des environnements les plus hostiles de la planète.
