---
title: Utiliser GitHub Flavored Markdown avec Middleman
date: 2013-03-11 00:47 +01:00
tags: GFM, Markdown, Middleman, RedCarpet
---

Pour pouvoir poster du code, comme dans un README sur GitHub, je voulais pouvoir utiliser le [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown) ("Markdown à la sauce GitHub", en bon français). Au moins la partie concernant le code.
READMORE

### RedCarpet

C'est assez simple, en fait : il faut générer son HTML à partir de fichiers Markdown en utilisant [RedCarpet](https://github.com/vmg/redcarpet).

On l'ajoute donc simplement au fichier `Gemfile` :
```ruby
gem 'redcarpet'
```

Puis de dire à Middleman de l'utiliser (avec quelques options pour reconnaitre automatiquement les blocs de code ou les liens HTTP, par exemple) :
```ruby
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, autolink: true, smartypants: true, gh_blockcode: true, lax_spacing: true
```

C'est tout, RedCarpet va maintenant transformer tous les blocs de codes (entourés de simples ou triple backquotes) en balises `<code>` (elles-mêmes imbriquées dans des balises `<pre>` si la version triple-backquotes est utilisée).

Avec un peu de CSS, histoire que ça ait un peu de gueule : fond gris, bordure grise, angles arrondis et du padding plus ou moins grand selon qu'on est dans un bloc inline (simple backquote) ou pleine-ligne (triple backquote).
```sass
code
  margin: 0 0.1em
  padding: 0.1em 0.2em
  border: 1px solid lighten($sw_lighter_gray, 5%)
  background-color: lighten($sw_lightest_gray, 5%)
  border-radius: 0.2em

pre
  margin: 0 0.2em
  padding: 0.5em 1em
  border: 1px solid lighten($sw_lighter_gray, 5%)
  background-color: lighten($sw_lightest_gray, 5%)
  border-radius: 0.4em
  code
    margin: 0
    padding: 0
    border: none
    background: none
```

On doit donc obtenir un truc comme ça :

![RedCarpet avec Middleman](middleman-redcarpet.png "RedCarpet avec Middleman")

Dans un prochain article, on ajoutera de la coloration syntaxique (avec [Middleman-syntax](https://github.com/middleman/middleman-syntax), donc [Pygments](http://pygments.org), ou avec [Rouge](https://github.com/jayferd/rouge)).


#### Sources
* [Cette issue](https://github.com/middleman/middleman/issues/577) de Middleman
* le [README](https://github.com/middleman/middleman-syntax) de Middleman-syntax