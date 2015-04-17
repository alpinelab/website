---
title: Un nom de domaine personnalisé sur GitHub Pages
date: 2013-03-25 01:34 CET
priority: 0.7
authorName: Michael Baudino
authorUrl: https://plus.google.com/+MichaelBaudino
tags: github pages, dns
---

Comment utiliser son beau nom de domaine qu'on vient de réserver pour son site hébergé sur [GitHub Pages](http://pages.github.com) ? En fait c'est très simple et tout est expliqué dans la [documentation officielle](https://help.github.com/articles/setting-up-a-custom-domain-with-pages) (RTFM, comme on dit).READMORE

### Configuration de GitHub Pages

Il faut tout d'abord créer un fichier `CNAME` à la racine de son site qui contient le nom de domaine qu'on veut utiliser (moi, pour ce blog, c'est www.alpine-lab.com). Comme j'utilise Middleman, ça donne donc ça (la racine du site est dans le sous-répertoire `source`) :
```bash
$ echo "www.alpine-lab.com" > source/CNAME
```

Voilà, c'est tout.

Une fois cette modification déployée, GitHub Pages saura que quand un navigateur lui demande `www.alpine-lab.com`, il devra répondre avec notre site.

Comme il est malin, il va créer automatiquement certaines redirections. Là, dans notre exemple, si on pointe son navigateur sur `alpinelab.github.com` (l'adresse d'origine), il nous redirigera automatiquement sur `www.alpine-lab.com`. Même chose avec `alpine-lab.com` (sans les `www`). Pratique, non ?

### Configuration DNS

Tout ce qu'il reste à faire, c'est quand même configurer votre serveur DNS pour que `www.alpine-lab.com` et `alpine-lab.com` soient redirigés vers l'adresse IP de GitHub Pages (entrée A dans votre config DNS) `204.232.175.78` ou vers le nom de domaine (entrée CNAME) `alpinelab.github.com`.

Voilà à quoi ressemble la conf DNS, chez moi :
![Configuration DNS qui pointe vers GitHub Pages](blog/nom-de-domaine-personnalise-sur-github-pages-00-screen-eurodns.png "Configuration DNS qui pointe vers GitHub Pages")

Voilà. C'est tout bon.

#### Bonus : patience !

GitHub Pages peut mettre jusqu'à 10 minutes pour réagir et se rendre compte qu'on lui a pushé un fichier CNAME. Inutile de péter un cable parce que ça ne marche pas immédiatement, il faut parfois simplement attendre. Je dis ça parce que ça m'est arrivé.

#### Sources

* La [documentation officielle](https://help.github.com/articles/setting-up-a-custom-domain-with-pages) de GitHub Pages
