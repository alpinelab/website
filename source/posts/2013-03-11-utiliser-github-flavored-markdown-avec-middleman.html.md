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

Avec un peu de CSS, on obtient donc ça :
![RedCarpet avec Middleman](middleman-redcarpet.png "RedCarpet avec Middleman")

Dans un prochain article, on ajouterai de la coloration syntaxique (avec Middleman-syntax, donc Pygments, ou avec Rouge).


#### Sources
http://www.alexpeattie.com/blog/github-style-syntax-highlighting-with-pygments/