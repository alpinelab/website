---
title: Utiliser Coveralls.io pour vérifier la couverture de vos tests
date: 2013-03-17 14:38 CET
authorName: Michael Baudino
authorEmail: michael.baudino@alpine-lab.com
authorURL: https://twitter.com/michaelbaudino
tags: coveralls, tests, travis
---

Quand vous développez (en Ruby, entre autres), vous écrivez des tests, n'est-ce pas ? Carrément en [TDD](http://fr.wikipedia.org/wiki/Test_Driven_Development) ou au moins pour assurer la [non-régression](http://fr.wikipedia.org/wiki/Non-r%C3%A9gression), j'espère. Le problème est : comment être sûr que tout votre code est bien testé ? Que vous n'avez pas un peu zappé d'écrire de tests pour telle méthode ou telle classe ?READMORE

La réponse s'appelle la [couverture de code](http://fr.wikipedia.org/wiki/Couverture_de_code) ("code coverage", en anglais). Ça consiste à calculer le pourcentage de votre code qui est couvert par des tests. La chance, c'est qu'en Ruby, si votre code est hébergé sur [GitHub](http://github.com), il existe une solution en SaaS qui fait ça toute seule : [Coveralls](https://coveralls.io) \!

### Inscription

Il faut en premier lieu s'inscrire sur [Coveralls.io](https://coveralls.io), mais grâce à l'authentification GitHub, c'est fait en 2 clics.

Coveralls vous demandera ensuite sur quels repositories vous voulez l'activer avec des petits boutons on/off très intuitifs (comme souvent, c'est gratuit pour les projets open-source, payant pour les projets privés) :

![Liste de vos projets qui utilisent Coveralls](blog/coveralls-repositories.png "Liste de vos projets qui utilisent Coveralls")

### Installation

Comme d'habitude, c'est super simple, il y a une gem à ajouter à votre fichier `Gemfile` :
```ruby
gem 'coveralls', require: false
```

Puis, il suffit de faire un `bundle install` pour l'installer.

Enfin, il faut dire à notre suite de tests d'utiliser la gem, en ajoutant les lignes suivantes au fichier de config de votre suite de tests (moi j'utilise [RSpec](http://rspec.info) donc c'est `spec/spec_helper.rb`, mais je vous laisse adapter à votre suite de test : Coveralls est compatible entre-autres avec [RSpec](http://rspec.info), [Cucumber](http://cukes.info), [Test::Unit](http://ruby-doc.org/stdlib-1.9.3/libdoc/test/unit/rdoc/Test/Unit.html), ...) :
```ruby
require 'coveralls'
Coveralls.wear!
```

Ou, pour une application Rails :
```ruby
require 'coveralls'
Coveralls.wear!('rails')
```

### Configuration

Si vous utilisez [Travis](https://travis-ci.org), c'est très simple : il n'y a rien de plus à faire \! Dès votre prochain push, Travis devrait donc tester votre build, et envoyer le rapport à Coveralls, qui calculera en détail la couverture de votre code.

Si vous utilisez [Semaphore](https://semaphoreapp.com) ou [CircleCI](https://circleci.com), ça marche aussi, mais je n'ai pas testé : je vous laisse vous reporter à la [documentation](https://coveralls.io/docs/ruby).

Si vous n'utilisez pas de service d'intégration continue, je vous conseille de vous y mettre rapidement, c'est de la tuerie. Moi j'adore [Travis](https://travis-ci.org), et en plus, il est gratuit pour les projets open-source. Sinon, pour Coveralls, vous pouvez le configurer (en ajoutant une variable `repo_token` à un fichier `.coveralls.yml`) pour pouvoir faire des analyse de couverture à la main, avec un simple `bundle exec coveralls push`.

### Résultat

Sur le site de Coveralls, vous pouvez donc voir un résumé de votre projet, build par build :

![Un projet sur Coveralls](blog/coveralls-project.png "Un projet sur Coveralls")

Pour chaque build, un résumé fichier par fichier :

![Un build sur Coveralls](blog/coveralls-build.png "Un build sur Coveralls")

Et enfin, le truc le plus utile et productif : pour chaque fichier, le détail de couverture ligne par ligne :

![Un fichier sur Coveralls](blog/coveralls-file.png "Un fichier sur Coveralls")

Là, par exemple, on voit que je n'ai pas écris de test pour la méthode `download_best_subtitle`, ce que je peux donc m'empresser d'aller faire.

### Bonus : le badge GitHub

On peut même récupérer le code pour insérer un badge dans notre README, pour avoir la classe américaine sur GitHub :

![Badge Coveralls sur GitHub](blog/coveralls-badge.png "Badge Coveralls sur GitHub")

#### Sources

* Le site de [Coveralls](https://coveralls.io)
* La [doc Coveralls](https://coveralls.io/docs/ruby) pour Ruby
