---
title: Installer git-flow dans une box Nitrous.IO
date: 2013-08-01 21:35 CEST
priority: 0.7
authorName: Michael Baudino
authorUrl: https://plus.google.com/106674357559734809246
tags: git, git-flow, nitrous
---

La première chose qu'on fait quand on crée une box sur [Nitrous.IO](https://www.nitrous.io/join/AkeaRDCF-N8), c'est un `git clone`. La seconde, quand on utilise [git-flow](http://nvie.com/posts/a-successful-git-branching-model) (comme nous), c'est de créer une nouvelle branche pour commencer à travailler. Mais là, c'est l'accident : Nitrous n'embarque pas git-flow par défaut !READMORE

Pas de panique ! En fait, c'est assez simple d'y remédier : il faut juste l'installer manuellement, et pour un seul utilisateur (parce que, évidemment, on n'est pas sudoer sur une telle box, donc pas d'accès à `apt-get`).

On commence donc par récupérer le code de git-flow :

```shell
$ git clone --recursive git://github.com/nvie/gitflow.git
```

Puis, dans le répertoire ainsi créé, on execute, à l'ancienne :

```shell
$ make install prefix=$HOME
```

Git-flow va alors être installé dans `~/bin`. Il ne reste plus qu'à s'assurer que ce répertoire est dans le `$PATH` en ajoutant la ligne suivante au fichier `~/.bashrc` :

```bash
PATH=$PATH:$HOME/bin
```

Il faut simplement penser à relancer son terminal, ou à executer la ligne suivante pour que les modifications soient prises en compte immédiatement :

```shell
$ . ~/.bashrc
```

Et voilà, à vous le workflow comme à la maison !

#### Sources

* En fait, j'ai juste suivi la [doc d'installation manuelle de git-flow](https://github.com/nvie/gitflow/wiki/Manual-installation)