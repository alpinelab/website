---
title: Générer ses vues Devise en Haml
date: 2013-05-07 08:46 CEST
authorName: Michael Baudino
authorUrl: https://plus.google.com/106674357559734809246
tags: rails, devise, haml
---

Depuis toujours, je génère mes vues [Devise](http://devise.plataformatec.com.br) en ERB, comme un bon élève, en suivant la [documentation](http://devise.plataformatec.com.br/#getting-started/configuring-views) :

```shell
$ rails generate devise:views
```

Mais ça, c'était avant. Je viens de découvrir que [Norman Clarke](https://github.com/norman), le créateur et mainteneur de [Haml](http://haml.info), avait sorti un un petit outil en lignes de commandes qui permet de convertir du ERB en Haml : il s'appelle intelligemment [html2haml](https://rubygems.org/gems/html2haml).

On l'installe comme ça :

```shell
$ gem install html2haml
```

Ensuite, on convertit toutes ses vues Devise d'un seul coup comme ça :

```shell
$ for file in app/views/devise/**/*.erb; do html2haml -e $file ${file%erb}haml && rm $file; done
```

Tout simplement.

#### Sources

C'est même plus une "source", c'est carrément du pompage traduit, mais je me suis inspiré de cet [article du wiki Devise](https://github.com/plataformatec/devise/wiki/How-To:-Create-Haml-and-Slim-Views), qui explique d'ailleurs aussi comment traduire ses vues en [Slim](http://slim-lang.com), si vous préférez.


