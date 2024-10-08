
Lien vers l'application : [https://gautierfr.shinyapps.io/Projet_visualisation_R/](https://gautierfr.shinyapps.io/Projet_visualisation_R/)

# Introduction

## Pourquoi ce projet ?

L'alpinisme est une activité qui comporte des risques inhérents, et les accidents peuvent avoir des conséquences graves, voire tragiques. Ce projet vise à étudier et analyser les accidents d'alpinisme afin de mieux comprendre les facteurs qui y contribuent et d'identifier des moyens de prévention. L'alpinisme étant un sujet qui nous intéresse, nous avons été motivé à entreprendre cette analyse afin de mieux comprendre les causes de décès en montagne et les risques associés à cette activité.


## Présentation des objectifs

Lors de la réalisation de ce projet, nous avons identifié quelques axes d'analyse et idées de tâches intéressantes à réaliser :

- Analyser les tendances et les patterns des décès sur les différents sommets de huit mille mètres.
- Enquêter sur les causes de décès en relation avec des montagnes ou des nationalités spécifiques.
- Comparer la mortalité des différents alpinistes en fonction de leur nationalité ou des montagnes choisies.
- Pouvoir rechercher un alpiniste ou une nationalité spécifique pour connaître les causes de décès les plus fréquentes.
- Concevoir un modèle pour prédire la cause de décès en fonction du mois/saison et de la montagne choisie

## Présentation des données utilisées

Pour réaliser notre projet, nous avons utilisé deux bases de données issues de kaggle :

- Une base de données sur les accidents d'alpinisme, qui contient des informations sur les accidents mortels survenus dans les montagnes de plus de 8000m d'altitude. Cette base de données contient des informations sur la date, le lieu, la cause de l'accident, la nationalité de la victime, etc.
- Une base de données sur les montagnes, qui contient des informations sur les montagnes du monde entier, telles que leur nom, leur altitude, leur localisation, la première ascension, etc. Nous avons utilisé cette base de données pour obtenir les informations des montagnes de plus de 8000m d'altitude.

Nous avons fusionné ces deux bases de données pour obtenir une base de données unique, qui contient des informations sur les accidents mortels survenus dans les montagnes de plus de 8000m d'altitude, ainsi que des informations sur ces montagnes. Cette base de données sera utilisée pour réaliser notre analyse et notre application.

# Présentation de l'application

Nous avons conçu notre application en différentes fenêtres, permettant à l'utilisateur de visualiser et d'analyser les données de différentes manières selon la thématique de la page. Voici les différentes fenêtres de l'application :

- Page d'accueil : cette page contient une brève présentation de l'application et des objectifs du projet.
- Page sur les montagnes
- Page sur les accidents
- Page de recherche
- Page sur les bases de données
- Page à propos : cette page contient des informations sur les auteurs de l'application et les sources des données utilisées.

## Page sur les montagnes

La page sur les montagnes permet à l'utilisateur de visualiser grâce à une carte interactive les montagnes de plus de 8000m d'altitude. En cliquant sur un marqueur, l'utilisateur peut obtenir des informations sur la montagne telles que son nom, son altitude, son pays et la date de la première ascension. L'utilisateur peut également visualiser la montagnes grâce à une image, ainsi qu'en savoir plus sur l'histoire et les défis de l'ascension de cette montagne.

De plus l'utilisateur peut visualiser les liens de parenté entre les montagnes grâce à un graphe dirigé. 

## Page sur les accidents

Sur cette page, l'utilisateur peut visualiser les accidents mortels survenus dans les montagnes de plus de 8000m d'altitude. Il peut visualiser les accidents selon 2 critères différents : selon la montagne et selon la nationalité. Les graphiques sont similaires sur les deux pages, c'est le critère d'étude qui les différencie.

Dans la partie **"montagne"** l'utilisateur pourra visualiser les accidents grâce à des diagrammes en bar (évloution du nombre d'accident et top5 des nationalités), un diagramme radar (répartition des causes d'accident) et des KPI. Tous ces graphiques sont réactif et changent en fonction de la montagne sélectionnée. Il est possible de réinitialiser la recherche grâce à un bouton.

Dans la partie **"nationalité"** l'utilisateur pourra visualiser les accidents grâce à une carte, un diagramme en bar, un diagramme radar et des KPI. Tous ces graphiques sont aussi réactif (sauf la carte) et changent en fonction de la nationalité sélectionnée. En passant la souris sur un pays de la carte, l'utilisateur pourra avoir le nombre d'accident dans le pays. Il est possible de réinitialiser la recherche grâce à un bouton. Nous avons rencontré plusieurs problèmes avec la carte (cf 3.2).

## Page de recherche

Sur cette page, l'utilisateur pourra effectuer des recherches sur une carte et selon deux critères principaux : par alpiniste ou par nationalité. En utilisant la liste déroulante située à droite, il pourra sélectionner et obtenir des informations sur un alpiniste spécifique ou sur une nationalité particulière. 

Si il recherche des informations sur un alpiniste spécifique, il obtiendra les détails suivants : son nom, la cause de l'accident, sa nationalité, la date de l'accident et la montagne concernée. Si il préfère explorer les données par nationalité, il obtiendra le nombre total d'accidents impliquant des alpinistes de cette nationalité ainsi que la répartition sur les montagnes.

## Page sur les bases de données

Cette page présente les 2 bases de données que nous avons utilisées pour réaliser notre projet ainsi que la base de données fusionnée. Elle contient des informations sur les colonnes de chaque base de données, ainsi que des informations sur les sources des données.

# Déroulement du projet

## Notre organisation

Nous avons commencé par énoncer toutes nos idées et ce que nous aimerions faire dans l'application. Nous avons ensuite dessiné un croquis sur papier, présentant chaque page et la disposition de chaque graphique dans cette page. Nous nous sommes ensuite répartis les tâches en fonction des préférences de chacun. Par exemple, Gautier ayant déjà déployé une application Shiny, s'est occupé de cette partie. Il a également réalisé les parties *A propos* et *Les montagnes*. De son côté, Léo s'est occupé de la partie sur *Les accidents*, de disposer les graphiques sur l'application et travailler les bases de données pour les rendre facile à exploiter. Pour finir Gabin s'est occupé de mettre en reactive les graphiques et la page *Recherche*. Nous avons également réalisé des points réguliers. De manière générale, les tâches n'étaient pas fixes et chacun a pu aider l'autre si besoin.

## Problèmes rencontrés

Nous avons rencontré plusieurs problèmes lors de la réalisation de ce projet. Voici les principaux problèmes que nous avons rencontrés :

Notre objectif initial était de développer un modèle capable de prédire la cause des accidents en fonction de la montagne et du mois où un alpiniste prévoyait de se rendre. Malheureusement, nous n'avons pas réussi à réaliser ce modèle, car nous n'avons pas pu trouver une approche appropriée. Nous avons tenté de construire un modèle de régression logistique, mais les résultats obtenus n'étaient pas satisfaisants en raison d'une précision trop faible (accuracy de 0.43 au mieux). De même, nos essais avec un modèle de forêt aléatoire, arbre de décision n'ont pas abouti à des résultats satisfaisants. Par conséquent, nous avons pris la décision de ne pas intégrer ce modèle dans notre application finale. Vous pourrez retrouver le modèle  de regression logistique ainsi que des tests dans le fichier *modele.R* du dossier *scripts*.

Ainsi, nous avons décidé de nous concentrer sur la visualisation des données et de réaliser une application qui permet à l'utilisateur de visualiser et d'analyser les données de différentes manières.

Nous avons également réalisé d'autres graphiques : 

- barplot pour visualiser le nombre d'accidents par saison *barplot_saison.R*
- barplot pour visualiser le nombre d'accidents par montagne *barplot_montagne.R*

Nous n'avons pas trouvé d'endroit adéquat pour les intégrer dans l'application. Nous avons donc décidé de ne pas les intégrer.

Avec la carte qui représente les accidents par nationalité, nous avons rencontré 2 problèmes :

- Nous voulions faire un zoom ou afficher un marqueur sur la nationalité sélectionnée mais nous n'avons pas réussi à le faire car nous ne disposions pas des latitudes et longitudes pour les pays. Nous avons essayé de récupérer ces longitudes et latitudes grâce à différentes librairies mais nous n'avons pas réussi à obtenir des résultats satisfaisants.
- Nous avons rencontré un problème lors du déploiement de l'application. En effet, nous avons utilisé le packages *rnaturalearth* pour obtenir les contours des pays. Mais lors du déploiement, le packages ne se chargeait pas. Pour palier à ce problème, nous avons décidé d'enregistrer le fichier en local.

```{r, eval = FALSE}
# Charger les données
world <- ne_countries(scale = "medium", returnclass = "sf")

# Enregistrer les données au format shapefile
st_write(world, "data/world.shp")

# Recharger les données 
world <- st_read("data/world.shp")
```

# Conclusion

Nous avons réalisé une application qui permet à l'utilisateur de visualiser et d'analyser les accidents mortels survenus dans les montagnes de plus de 8000m d'altitude. Cette application permet à l'utilisateur de visualiser les montagnes de plus de 8000m d'altitude, les accidents mortels survenus dans ces montagnes, ainsi que les alpinistes impliqués dans ces accidents. L'application permet également à l'utilisateur de réaliser des recherches sur les alpinistes et les nationalités, ainsi que de visualiser les bases de données utilisées pour réaliser ce projet.

Ce projet nous a permis de mettre en pratique les connaissances acquises lors du cours de visualisation des données. Nous avons trouvé ce projet intéressant à faire, nous permettant de mettre en pratique plusieurs compétences apprises dans différentes matières. Nous avons également appris à travailler en équipe et à réaliser un projet de A à Z.





