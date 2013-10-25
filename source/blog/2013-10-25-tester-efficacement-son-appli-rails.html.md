---
title: Tester efficacement son appli Rails
date: 2013-10-25 14:41 CEST
priority: 0.7
authorName: Lucas Biguet-Mermet
authorUrl: https://plus.google.com/113254770317994911183
tags: rspec, good practices
---

J'ai du récemment écrire des tests unitaires pour un controlleur, la tâche s'est révélée plus complexe que prévue, en partie parce que le controlleur était déja codé, et en partie parce que je suis encore novice avec Rspec et la TDD en général;

J'avais commencé par écrire le squelette de mes tests de manière basique: un test par fonction dans le controlleur. L'idée (un peu trop simple) était qu'en s'assurant que chaque entité dans mon controlleur fonctionne, le controlleur devrait fonctionner correctement lui aussi. **Grave erreur:** certains test étaient très compliqué à implémenter ou nécessitaient de créer trop de ressources: Mes tests étaient lent (plusieurs dizaines de secondes à exécuter), illisibles et j'avais constamment l'impression frustrante de me battre contre le système pour qu'il fasse ce que je voulais.

Plus important encore, tester de cette manièrer garanti que le controlleur est fonctionnel sur le plan logique, mais rien ne garanti son comportement au sein de l'application.

Pour finir ce n'était pas efficace, je passais du temps sur des tests qui s'avéraient au mieux incomplets, au pire inutiles et n'apportaient pas de valeur au projet.


### Changer d'approche

Je me suis rendu compte après quelques recherches que la question à se poser en premier n'était pas "comment tester ?" mais plutot "quoi tester ?"; En d'autres termes, comment écrire un nombre minimum de tests assurant le comportement de mon controlleur de manière exhaustive, stable et efficace ?

J'ai trouvé une réponse dans cette excellente conférence de Sandi Metz ["Magic Tricks of Testing"](http://www.youtube.com/watch?v=URSWYvyc42M)

Si vous ne la connaissez pas, jetez un coup d'oeil à son [CV](http://www.poodr.com/about/), à mon avis elle connait son boulot !

Si vous n'êtes pas anglophobe je vous invite évidemment à regarder la conférence en entier pour avoir tous les détails, je voulais juste en résumer les concepts principaux:


### Les messages sont la clé

L'approche est basée sur la philosophie "orienté objet": on considère chaque entité de notre application (Modeles, Vues, Controlleurs...) comme une "boite noire" qui intéragit avec les autres au moyen de messages.

Ces messages peuvent être de deux types:

- requête: demande d'information, par exemple recuperer un ID d'utilisateur dans la base de données.
- commande: déclenche une action externe, par exemple créer un utilisateur en base de donnée, envoyer un mail...

Ils sont aussi de différentes sources:

- entrants: messages reçus par notre entité
- sortants: messages envoyés
- internes: messages entre les composants de notre entité

Maintenant qu'on a fait la liste des 6 types de messages possibles, il ne reste plus qu'à les tester !


### le strict minimum

On a déja pas mal réduit la liste des choses à tester en se concentrant uniquement sur les messages, mais est-ce utile de tous les tester ?

On peut déja éliminer d'office les **messages internes**, puisque ceux ci sont liés à l'implémentation (à l'intérieur de la boite noire): Toujours tester le comportement, et non le fonctionnement.

Pour des raisons similaires, on ne tiendra pas compte des **requêtes sortantes**: Ces requêtes n'ont aucun impact sur le reste de l'application, elle servent au fonctionnement de notre controlleur mais ne définissent pas son comportement.

Bien, on a maintenant notre réponse au "quoi tester?", on peut passer au "comment?".


### Le tableau magique

Il ne nous reste plus que trois types de messages, ça veut dire qu'on aura que trois types de tests à implémenter !

![magic tricks of testing](magic-tricks-of-testing-minimalist-table.png)

les tests sont simples, efficaces et exhaustif, ils verrouillent le comportement de notre controlleur, mais pas son implémentation, ça rend le tout stable, rapide à éxecuter et plus simple à maintenir.

Elle est pas belle la vie ?


#### Sources

* la [vidéo de la conférence](http://www.youtube.com/watch?v=URSWYvyc42M)
* ainsi que ses [slides](https://speakerdeck.com/skmetz/magic-tricks-of-testing-railsconf)