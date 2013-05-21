---
title: Un alias git, c'est toujours pratique
date: 2013-04-10 01:38 CEST
priority: 0.7
authorName: Michael Baudino
authorUrl: https://plus.google.com/106674357559734809246
tags: git, alias, middleman
---

Pour ce blog j'utilise [Middleman](http://middlemanapp.com), j'ai donc un repository pour les sources. Mais dès qu'il s'agit de déployer (i.e. compiler puis pusher les fichiers compilés sur un autre repository, que [github:pages](http://pages.github.com) reconnait comme devant les mettre en ligne), voilà la séquence de commandes que je dois executer :
```shell
$ git push
$ middleman build --clean
$ middleman deploy --clean
```

Épuisant.

J'ai donc besoin d'un moyen d'éxécuter toutes ces commandes d'un coup. Comme un alias ou un scriptshell seraient trop faciles, j'ai regardé du côté des _alias git_.

En gros, je veux pouvoir tout simplement entrer :
```shell
$ git dpush # 'dpush' commme 'deploy & push'
```

Il suffit donc de déclarer un alias git comme ça :
```shell
$ git config alias.dpush '!git push origin master && middleman build --clean && middleman deploy --clean'
```

Cette commande va ajouter les lignes suivantes au fichier `.git/config` :
```
[alias]
  dpush = !git push origin master && middleman build --clean && middleman deploy --clean
```

Voilà, plus qu'à executer `git dpush` pour pusher son code, compiler, puis déployer un nouvel article.

#### Notes
1. Le point d'exclamation (!) en première position de l'alias sert à indiquer que c'est une commande à part entière. Sans ce point d'exclamation, les alias portent par défaut sur d'autres commandes git. Genre, pour pouvoir écrire `git st` au lieu de `git status`, comme [piouPiouM](http://pioupioum.fr/developpement/git-alias-productivite.html) :
```
[alias]
  st = status
```
2. Comme on le déclare ici, l'alias est local : il ne s'applique qu'au repository courant (d'ailleurs il est stocké dans `.git/config` qui est la config du repository courant uniquement). Pour créer un alias qui fonctionne partout, il faut utiliser le switch `--global` : l'alias sera alors déclaré non pas dans `.git/config` mais dans `~/.gitconfig` et sera donc accessible dans tous vos repository git.

#### Sources

Tout est parti d'[une réponse sur StackOverflow](http://stackoverflow.com/a/3466589)
