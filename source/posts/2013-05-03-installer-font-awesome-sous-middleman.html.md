---
title: Installer Font Awesome sous Middleman
date: 2013-05-03 22:25 CEST
tags:
---

Aujourd'hui, j'ai décidé d'intégrer les _font icons_ [Font-Awesome](http://fortawesome.github.com/Font-Awesome/) sur notre blog (qui est généré par [Middleman](http://middlemanapp.com/) comme expliqué dans [un precédent article]()).

### Historique

Pour ceux qui ne savent pas ce que sont les _font icons_, voilà un petit rappel.

Dans la vie, il y a ce que j'appelle les "font nerds". Ce sont généralement des designers qui sont passionnés par un truc que, personnellement, je ne comprends pas du tout : les polices d'écriture (ou "fonts").

Bref, un de ces joyeux lurons s'est dit un jour : au lieu de faire un 'A', puis un 'B', etc... si je faisais plutôt une maison, une flêche, un téléphone, etc... Ça a donné Wingdings. C'était un peu moche.

![Wingdings](font-awesome-wingdings.gif "Wingdings")

Plus tard, d'autres mecs - le W3C - ont travaillé pendant des années pour nous pondre notamment le langage CSS et ses possibilités de travailler les polices facilement (changer les couleurs, tailles, ombres, orientations, etc...).

En poussant le raisonnement, et devant la généralisation de l'utilisation de CSS (et notamment de la fameuse directive `@font-face` qui permet d'utiliser n'importe quelle police dans un navigateur, même si celle-ci n'est pas installée dans le système), un font-nerd s'est dit : "Hey, si je fais des icônes canons comme si c'était des caractères, chacun pourra les adapter à sa charte graphique !". Pof ! Les _font icons_ (ou _icon fonts_, selon...) étaient nées.

Voilà pour l'historique. Il existe maintenant pas mal de packs de _font icons_ téléchargeables et utilisables librement sur le net (voir en bas de l'article pour quelques pointeurs).

### Intégration à Middleman

Dans un premier temps, il faut télécharger les fonts. C'est pas trop compliqué, il y a un gros bouton jaune sur la [homepage](http://fortawesome.github.com/Font-Awesome). Je vous colle même le lien direct ici : http://fortawesome.github.com/Font-Awesome.

Ce lien pointe vers un fichier ZIP, qui contient :
* les fonts dans le sous-dossier `font`, à coller dans notre projet Middleman dans `source/fonts/` (répertoire à créer si nécessaire)
* des docs dans le sous-dossier dossier `docs` (vous commencez à voir la logique ? attention, ça se complique après)
* le code CSS nécessaire à charger ces fonts, en plein de versions :
  * CSS
  * CSS minifié
  * CSS compatible IE7
  * LESS
  * LESS compatible IE7
  * Sass
  * Scss

Sympa, non ? L'idéal, me direz-vous, serait d'utilisez directement la version minifiée, les plus radins d'entre-nous y verraient un bon moyen d'économiser des cycles de (pré-)processeur.
C'est sans compter un léger détail de conventions : Bootstrap (avec lequel l'intégration de Font Awesome est optimisée) stocke les fichiers des polices dans `/font` alors que Middleman les stocke par défaut dans `/fonts`. Vous avez vu la différence ? Pas de `s` final chez Bootstrap. Donc la version minifiée ne réussira jamais à charger la police (et qui, honnêtement, à envie de mettre son nez dans du CSS minifié pour le modifier ?).

Rénial. Mais qu'à celà ne tienne : on va utiliser la version Sass (parce que j'utilise déjà du Sass partout). On va donc extraire `sass/font-awesome.sass` du fichier ZIP pour aller le mettre dans `source/fonts/`.

En ouvrant ce fichier, on voit que sa première vraie instruction (qui ne soit pas un commentaire) est la suivante :
```sass
$fontAwesomePath:   "../font" !default
```

Vous avez deviné ? Exactement : il faut ajouter un `s` pour faire `../fonts` :
```sass
$fontAwesomePath:   "../fonts" !default
```

Maintenant, plus qu'à utiliser ce fichier. Pour ça, il suffit d'ajouter la ligne suivante à votre `default.css.sass` (ou autre fichier Sass) :
```sass
@import "font-awesome"
```

### Utilisation des font-icons

OK, c'est bien beau, on a ajoutée une police bizarre à notre asset pipeline, maintenant quoi ?

Il suffit d'ajouter à une page la balise HTML `<i class="icon-github"></i>` pour faire apparaitre une petite icone GitHub. En Slim, ça donne ça :
```slim
i.icon-github
```

Ça, c'est quelques exemples :

![Exemple d'icones Font Awesome](font-awesome-examples.png "Exemple d'icones Font Awesome")

Et comme c'est une balise HTML contenant du texte (dont les caractères sont des dessins, certe, mais du texte quand même), on peut lui appliquer les styles qu'on veut. Par exemple, on voudrait qu'elle soit rouge et qu'elle devienne bleue quand la souris de l'utilisateur est au-dessus ? Rien de plus simple ?
```sass
i.icon-github
  color: red
  &:hover
    color: blue
```

Easy, non ? Et on peut aussi ajouter d'autres classes à la balise :
* `icon-large`, `icon-2x`, `icon-3x` ou `icon-4x` indiquent la taille de l'icône
* `icon-spin` la fait tourner sur elle-même
* `icon-border` l'affiche dans un cadre gris

Et voilà, vous savez tout ! Essayez, jouez avec, c'est super facile.

### Autres packs d'icons chouettes et libres (sous licence CC ou SIL)

* [Font-Awesome](http://fortawesome.github.com/Font-Awesome) : celui que j'utilise dans ce tutorial (et sur ce blog), il a été conçu pour être utilisé avec [Bootstrap](http://twitter.github.com/bootstrap)
* [Foundation Icon Fonts 2](http://www.zurb.com/playground/foundation-icons) : le pack d'icônes du projet [Foundation](http://foundation.zurb.com)
* [Modern Pictograms](http://modernpictograms.com) : un des premiers gros projets de _font icons_
* [Raphaël Icon Set](http://icons.marekventur.de) : un pack d'icon fait à l'origine pour être utilisé avec [Raphaël](http://raphaeljs.com), mais qui fonctinone très bien tout seul
* [IcoMoon](http://icomoon.io/#preview-free) : ce pack a une version gratuite pas mal du tout et 2 versions payantes au-dessus
* Et pour vous faire un pack de _font icons_ custom, vous pouvez utiliser [Fontello](http://fontello.com) ou [IcoMoon App](http://icomoon.io/app) qui permet de choisir parmis plein de gros packs les icônes qu'on veut, et d'en faire une police (on peut même choisir à quel caractère on assigne chaque icône)

#### Liens

* Le ["making of" de Octicons](https://github.com/blog/1135-the-making-of-octicons), les _font icons_ de GitHub, intéressant pour comprendre comment on fait ces trucs