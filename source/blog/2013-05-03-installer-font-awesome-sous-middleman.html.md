---
title: Installer Font Awesome sous Middleman
date: 2013-05-03 22:25 CEST
priority: 0.7
authorName: Michael Baudino
authorUrl: https://plus.google.com/+MichaelBaudino
tags: middleman, fonts, icons
---

_**UPDATE** Article mis à jour le 30/10/2013 pour intégrer la nouvelle convention de nommage de Font Awesome 4_

Aujourd'hui, j'ai décidé d'intégrer les _font icons_ [Font-Awesome](http://fortawesome.github.com/Font-Awesome/) sur notre blog (qui est généré par [Middleman](http://middlemanapp.com/) comme expliqué dans [un precédent article]()).

### Historique

Pour ceux qui ne savent pas ce que sont les _font icons_, voilà un petit rappel.

Dans la vie, il y a ce que j'appelle les _font nerds_. Ce sont généralement des designers qui sont passionnés par un truc que, personnellement, je ne comprends pas du tout : les polices d'écriture (ou "fonts"). Je les aime beaucoup, hein, c'est pas la question, Martin, notre designer préféré en est un. C'est juste que je ne les comprend pas :-)

Bref, un de ces joyeux lurons s'est dit un jour : au lieu de faire un 'A', puis un 'B', etc... si je faisais plutôt une maison, une flêche, un téléphone, etc... Ça a donné Wingdings. C'était un peu moche.

![Wingdings](blog/font-awesome-wingdings.gif "Wingdings")

Plus tard, d'autres mecs - le W3C - ont travaillé pendant des années pour nous pondre notamment le langage CSS et ses possibilités de travailler les polices facilement (changer les couleurs, tailles, ombres, orientations, etc...).

En poussant le raisonnement, et devant la généralisation de l'utilisation de CSS (et notamment de la fameuse directive `@font-face` qui permet d'utiliser n'importe quelle police dans un navigateur, même si celle-ci n'est pas installée dans le système), un font-nerd s'est dit : "Hey, si je fais des icônes canons comme si c'était des caractères, chacun pourra les adapter à sa charte graphique !". Pof ! Les _font icons_ (ou _icon fonts_, selon...) étaient nées.

Voilà pour l'historique. Il existe maintenant pas mal de packs de _font icons_ téléchargeables et utilisables librement sur le net (voir en bas de l'article pour quelques pointeurs).

### Intégration à Middleman

Avant, il y avait une feinte, pour adapter Font Awesome à Middleman, mais maintenant il y a [Bootstrap CDN](http://www.bootstrapcdn.com) qui nous sert directement le CSS nécessaire. Il suffit donc d'ajouter à ses pages une balise stylesheet :
```html
<link href="//netdna.bootstrapcdn.com/font-awesome/4.0.1/css/font-awesome.min.css" media="screen" rel="stylesheet" type="text/css">
```

Ou, en Sass :

```sass
= stylesheet_link_tag '//netdna.bootstrapcdn.com/font-awesome/4.0.1/css/font-awesome.min.css'
```

C'est tout (je vous laisse ajuster avec le numéro de version adéquate au moment où vous lirez cet article).

### Utilisation des font-icons

OK, c'est bien beau, on a ajoutée une police bizarre à notre header HTML, maintenant quoi ?

Il suffit d'ajouter à une page la balise HTML `<i class="fa fa-github"></i>` pour faire apparaitre une petite icone GitHub. En Slim, ça donne ça :
```slim
i.fa.fa-github
```

Ça, c'est quelques exemples :

![Exemple d'icones Font Awesome](blog/font-awesome-examples.png "Exemple d'icones Font Awesome")

Et comme c'est une balise HTML contenant du texte (dont les caractères sont des dessins, certe, mais du texte quand même), on peut lui appliquer les styles qu'on veut. Par exemple, on voudrait qu'elle soit rouge et qu'elle devienne bleue quand la souris de l'utilisateur est au-dessus ? Rien de plus simple ?
```sass
i.fa.fa-github
  color: red
  &:hover
    color: blue
```

Easy, non ? Et on peut aussi ajouter d'autres classes à la balise :
* `fa-lg`, `fa-2x`, `fa-3x` ou `fa-4x` indiquent la taille de l'icône
* `fa-spin` la fait tourner sur elle-même
* `fa-rotate-*` et `fa-flip-*` l'inclinent ou la retournent
* ... et bien d'autres encore que vous pouvez retrouver dans la [documentation de Font Awesome](http://fortawesome.github.io/Font-Awesome/examples)

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
