---
title: Mise à jour de Ruby dans RVM
date: 2013-03-08 12:10 +01:00
authorName: Michael Baudino
authorUrl: https://plus.google.com/106674357559734809246
tags: rvm, ruby
---

Pour mettre jour une version de Ruby avec [RVM](https://rvm.io) (par exemple passer de l 1.9.3-p374 à la 1.9.3-p392), c'est pas très compliqué.READMORE

* Récupérer la liste des dernières versions stables de Ruby :

```bash
$ rvm get stable
```

* Désinstaller l'ancienne version et installer la nouvelle :

```bash
$ rvm uninstall 1.9.3
$ rvm install 1.9.3
```

* Ou si vous êtes des chauds, directement :

```bash
$ rvm reinstall 1.9.3
```

Et allez, comme la 2.0 vient de sortir, profitons-en, installons-la :

```bash
$ rvm install 2.0.0
```

C'est tout ! Merci [RVM](https://rvm.io) :-)
