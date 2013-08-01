---
title: Git en couleurs
date: 2013-08-01 19:09 CEST
priority: 0.7
authorName: Michael Baudino
authorUrl: https://plus.google.com/106674357559734809246
tags: git, terminal
---

Parfois - avec des années de retard - on découvre un truc tout bête mais génial. C'est ce qui vient de m'arriver.READMORE

En créant une box sur [Nitrous.IO](https://www.nitrous.io) (on vous en reparlera dans un autre article, c'est génial), je me loggue dans la console, je git clone un projet, et là, le choc : git est coloré !

![git pull sur Nitrous.IO](git-colored-01-pull.png "git pull sur Nitrous.IO")

En fait, c'est super simple à configurer. Tout ce qu'il suffit de faire, c'est entrer cette ligne dans une console :

```shell
$ git config --global --add color.ui true
```

Voilà. Vous pouvez maintenant kiffer vos `git pull` en couleurs, ou encore vos `git diff`, vos `git status` ou vos `git log`, comme sur les screenshots ci-dessous.

![git diff, status et log sur Nitrous.IO](git-colored-02-diff-status-log.png "git diff, status et log sur Nitrous.IO")

On se sent idiot, des fois...

PS : si vous voulez aller sur Nitrous.IO de ma part, voilà mon [lien partenaire](https://www.nitrous.io/join/AkeaRDCF-N8)

#### Sources

* la [doc officielle de Git](http://git-scm.com/book/fr/Personnalisation-de-Git-Configuration-de-Git#Couleurs-dans-Git) détaille évidemment cette option
* j'ai pour ma part trouvé l'astuce sur le [blog de Mark Hensen](http://www.markhansen.co.nz/color-git)