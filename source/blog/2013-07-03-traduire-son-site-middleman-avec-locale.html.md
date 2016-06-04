---
title: Traduire son site Middleman avec Locale
date: 2013-07-03 01:53 CEST
authorName: Michael Baudino
authorEmail: michael.baudino@alpine-lab.com
authorURL: https://twitter.com/michaelbaudino
tags: middleman, locale, i18n
---

Pour traduire nos sites en Rails, on utilise pratiquement tout le temps le SaaS de localisation [Locale](http://www.localeapp.com). On va voir comment s'en servir dans un projet Middleman, pour une fois.READMORE

Pour ceux qui ne connaissent pas, on en profite pour faire un peu de pub, parce que c'est [notre pote Chris](https://github.com/tigrish) qui le développe et que, nous même, on bosse de temps en temps sur ce projet. Sachez donc que c'est un service qui permet de ne plus se galérer avec les fichiers de traduction Yaml de Rails, mais plutôt d'utiliser cette superbe interface de traduction, directement depuis votre navigateur :

![Locale](blog/locale-01-interface.png "Locale")

Il y a plein d'autres fonctionnalités (commande de traductions, workflows, synchronisation, ...) que je vous laisse découvrir [en essayant par vous même](http://www.localeapp.com/users/sign_up).

Bref, c'est bien beau tout ça, mais comment on s'en sert avec Middleman ?


## Installation de la gem

Locale s'installe par une gem. Comme Middleman fonctionne à base de fichier `Gemfile`, il suffit d'y ajouter :

```ruby
gem 'localeapp'
```

Puis d'éxecuter le classique :

```shell
$ bundle install
```

Splendide.


## Création d'un projet Locale et liaison avec le projet Middleman

Une fois loggé(e) sur le site de Locale, cliquez sur le bouton "+" pour créer un projet.

![Locale - Add project](blog/locale-02-add-project.png "Locale - Add project")

Après avoir renseigné quelques menues informations (nom du projet, langue par défaut, ...), le projet est créé et vous êtes redirigé(e) vers une modale qui vous explique quoi faire maintenant, c'est à dire l'ajout de la gem au `Gemfile` et le `bundle install` qu'on vient de faire juste avant, mais surtout, ça nous propose d'executer l'instruction suivante qui sert à lier notre projet Locale à notre projet Middleman :

```shell
$ bundle exec localeapp install --standalone <YOUR_API_KEY>
```

Je vous laisse évidemment renseigner votre propre clef d'API.

Vous remarquez le switch `--standalone` ? Oui, c'est parce qu'on n'utilise pas Rails, on n'a donc pas besoin de tout un tas de trucs qui nous seraient inutiles des toutes façons. Donc économisons.


## Configuration de Middleman

Voilà, donc la gem est maintenant configurée pour fonctionner avec notre projet Locale. En fait, ce qu'il s'est passé, c'est que ça a créé un fichier `.localeapp/config.rb` à la racine de notre projet Middleman, avec dedans :

```ruby
Localeapp.configure do |config|
  config.api_key                    = '<YOUR_API_KEY>'
  config.translation_data_directory = 'locales'
  config.synchronization_data_file  = '.localeapp/log.yml'
  config.daemon_pid_file            = '.localeapp/localeapp.pid'
end
```

Il reste donc à dire 2 choses à Middleman : activer son module `i18n` et configurer la gem `localeapp` au démarrage. Il suffit pour ça d'ajouter les lignes suivantes au fichier `config.rb` :

```ruby
activate :i18n, mount_at_root: :fr
require '.localeapp/config'
```

Ceux d'entre vous qui sont déjà allé jeter un coup d'oeil à la [doc i18n de Middleman](http://middlemanapp.com/advanced/localization/), auront remarqué que `mount_as_root: :fr` sert à définir le français comme langue par défaut. Vous faites comme vous voulez, ici, ça n'a absolument pas besoin d'être la même langue que celle définie comme langue par défaut dans Locale.

La version française du site sera donc disponible, comme d'habitude sur [http://localhost:4567](http://localhost:4567/en) et la version anglaise sera, elle, disponible sur [http://localhost:4567/en](http://localhost:4567/en) (notez le `/en` à la fin).

## Organisation des templates Middleman et utilisation de I18n

Middleman sait quand générer des versions localisées des pages quand elles sont placées dans le dossier `source/localizable`, il suffit donc de déplacer, par exemple, votre `source/index.html.haml` dans `source/localized/index.html.haml`.

Bien, maintenant, on peut utiliser, dans ce fichier, la classe Ruby I18n et notamment sa fonction `t` (ou `translate`), comme on le fait sous Rails (ici, en Haml) :

```haml
%h1= I18n.t('index.title')
```

Ce qui devrait afficher "Missing translation". Qu'à celà ne tienne, on va aller la créer.

## Création d'une traduction dans Locale

Sur la page de son projet, il suffit de cliquer sur une des langues, pour tomber sur la liste (vide, au début) des traductions.

Cliquez donc sur le bouton "+" en haut pour en créer une nouvelle :

![Locale - Create translation](blog/locale-03-create-translation.png "Locale - Create translation")

Une modale vous permettra alors de renseigner le chemin de la traduction :

![Locale - Name new translation](blog/locale-04-create-translation-modal.png "Locale - Name new translation")

Les chemins utilisent les points comme séparateurs, on crée donc, dans cet exemple, une traduction qui s'appelle `title` dans le le noeud `index`, ce qui correspond à la clef que l'on a précédemment passée à la fonction `t` du module Ruby `I18n` (faut suivre, hein...).

Voilà, on peut maintenant remplir très intuitivement le contenu de cette traduction dans toutes les langues :

![Locale - Fill in a translation](blog/locale-05-fill-translation.png "Locale - Fill in a translation")

Il ne reste alors plus qu'à ordonner à la gem de rappatrier les fichiers Yaml qui vont bien, et que Middleman saura lire en tapant dans la console :

```shell
$ localeapp pull
```

Dans notre exemple, les fichiers `locales/fr.yml` et `locales/en.yml` seront alors créés et prêts à être utilisés par Middleman (c'est en fait eux qui sont appelés par la fonction Ruby `I18n.t()`).

### Bonus: pusher des traductions

Vous vous doutez bien, si il y a un `localeapp pull`, c'est qu'il y a aussi un `localeapp push`. C'est utile quand on a fait une modification directement dans un fichier Yaml (genre, lors d'une résolution de conflit Git, et ça arrive souvent sur les fichiers Yaml) et que l'on veut envoyer cette modification à Locale. On fait alors :

```shell
$ localeapp push locales/fr.yml
```

Oui, il faut spécifier quel fichier on pushe, c'est pas la fête du slip, non plus.

### Bonus 2 : I18n.locale

Pour savoir quelle est la langue courante dynamiquement, tout comme sous Rails, on peut utiliser la variable Ruby `I18n.locale`, ce qui permet, par exemple de changer son Haml qui ressemblait à ça :

```haml
%html{lang: 'fr'}
```

En ça, qui sera donc différent selon que la requête est pour la version française ou anglaise :

```haml
%html{lang: I18n.locale}
```

#### Sources

* la [doc du module I18n](http://middlemanapp.com/advanced/localization/) de Middleman
* les [wikis](https://github.com/Locale/localeapp/wiki) de Locale sur GitHub
