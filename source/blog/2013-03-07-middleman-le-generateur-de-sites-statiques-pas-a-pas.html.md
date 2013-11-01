---
title: Middleman, le générateur de sites statiques pas à pas
date: 2013-03-07 17:38 CET
priority: 0.7
authorName: Michael Baudino
authorUrl: https://plus.google.com/+MichaelBaudino
tags: middleman, slim, sass, coffeescript, markdown, github pages
---


Le but de cet article est de monter un blog, pour raconter ma vie, basé sur la stack de technologies suivantes :
* [Middleman](http://middlemanapp.com/) : génération de sites statiques
* [Slim](http://slim-lang.com/) (templating HTML)
* [Sass](http://sass-lang.com/) (feuilles de style)
* [CoffeeScript](http://coffeescript.org/) (javascript)
* [Markdown](http://daringfireball.net/projects/markdown/) pour le contenu des articlesREADMORE

Ce site sera hébergé par GitHub, parce que payer un dyno [Heroku](http://www.heroku.com) 30$ par mois pour raconter ma vie, non merci. On va donc utiliser la fonction GitHub Pages.

Cet article traite de la mise en place du site et de la stack technologique.
Dans un prochain article, on verra comment transformer tout ça en un blog avec toutes les fonctionnalités qui vont bien (tags, organisation en articles, pretty URLs, etc...).

### Préambule

Cet article est un peu long parce que c'est un "pas à pas". Si vous voulez juste le résumé, rendez-vous [en fin d'article](#resume).

Pour lire cet article, mieux vaut déjà maitriser git, GitHub et les langages utilisés (Slim, Markdown, Sass, CoffeeScript, ...).


## Installation de Middleman

On commence par la base, installer Middleman :
```shell
$ gem install middleman
```

On crée ensuite le squelette avec le template HTML5 boilerplate :
```shell
$ middleman init blog-alpinelab --template=html5
```

On initialise Git :
```shell
$ cd blog-alpinelab
$ git init
```

On commite nos supers nouveaux fichiers en local :
```shell
$ git add .
$ git commit -a -m 'Initial commit: empty Middleman skeleton'
```

On ajoute alors le code généré au repository GitHub qui va abriter les sources du blog (attention, il y aura un autre repository pour les fichiers compilés, celui-ci c'est vraiment juste pour les sources) :
```shell
$ git remote add origin git@github.com:alpinelab/blog-alpinelab.git
$ git push -u origin master
```

On peut tester en lançant le serveur Middleman :
```shell
$ bundle exec middleman server
```

Et en pointant son navigateur vers [http://localhost:4567](http://localhost:4567), on doit avoir ça :

![Middleman Hello World](middleman-01-hello-world.png "Hello World Middleman")



## Installation de jQuery

La version de [jQuery](http://jquery.com) installée par défaut est un peu vieille, j'ai préféré la mettre à jour, mais cette étape n'est vraiment pas obligatoire.

On commence par supprimer l'ancienne version :
```shell
$ git rm source/js/vendor/jquery-1.8.1.min.js
```

On télécharge ensuite la nouvelle version :
```shell
$ curl -o source/js/vendor/jquery-1.9.1.min.js http://code.jquery.com/jquery-1.9.1.min.js
```

Plus qu'à committer :
```shell
$ git add source/js/vendor/jquery-1.9.1.min.js
$ git commit -a -m 'Mise a jour de jQuery'
$ git push
```



## Installation de Slim

Pour commencer, on ajoute [Slim](http://slim-lang.com) au fichier `Gemfile` :
```ruby
gem 'slim'
```

On met ensuite le bundle à jour :
```shell
$ bundle install
```

Dans un premier temps, on va transformer le fichier qui correspond à la page d'accueil (qui est par défaut en ERb) en un fichier Slim. Il faut pour ça renommer `index.html.erb` en `index.html.slim` :
```shell
$ git mv source/index.html.erb source/index.html.slim
```

On modifie ensuite le contenu de `source/index.html.slim` pour qu'il ressemble à ça :
```slim
---
title: HTML5 Boilerplate Middleman
---

p
  | Hello world! This is HTML5 Boilerplate powered by SLIM.

```

Note:
  les 3 premières lignes forment ce qu'on appelle le [FrontMatter](http://middlemanapp.com/frontmatter). Il permet de definir des variables relatives à la page HTML qui va être générée (layout, titre, etc...). Ici, on définit uniquement le titre de la page.

On va faire pareil avec le fichier de layout `layout.erb` qu'on renomme en en `layout.slim` :
```shell
$ git mv source/layouts/layout.erb source/layouts/layout.slim
```

On traduit alors son contenu en Slim. Ça doit ressembler à peu près à ça (désolé, en Slim, j'ai pas la coloration syntaxique, sur le blog) :
```slim
doctype html
/[if lt IE 7]
  html class="no-js lt-ie9 lt-ie8 lt-ie7"
/[if IE 7]
  html class="no-js lt-ie9 lt-ie8"
/[if IE 8]
  html class="no-js lt-ie9"
/[if gt IE 8]
  <!--> <html class="no-js"> <!--
head
  meta charset="utf-8"
  meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"
  / Use title if it's in the page YAML frontmatter
  title= data.page.title || "HTML5 Boilerplate"
  meta name="description" content=""
  meta name="viewport" content="width=device-width"

  / Place favicon.ico and apple-touch-icon.png in the root directory

  link rel="stylesheet" href="css/normalize.css"
  link rel="stylesheet" href="css/main.css"
  script src="js/vendor/modernizr-2.6.1.min.js"
body
  /[if lt IE 7]
    p.chromeframe
      | You are using an outdated browser.
      a href="http://browsehappy.com/" | Upgrade your browser today or
      a href="http://www.google.com/chromeframe/?redirect=true" | install Google Chrome Frame to better experience this site.

  == yield

  script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"
  javascript:
    window.jQuery || document.write('<script src="js/vendor/jquery-1.9.1.min.js"><\/script>')
  script src="js/plugins.js"
  script src="js/main.js"

  / Google Analytics: change UA-XXXXX-X to be your site's ID.
  javascript:
    var _gaq=[['_setAccount','UA-XXXXX-X'],['_trackPageview']];
    (function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
    g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
    s.parentNode.insertBefore(g,s)}(document,'script'));
```

On teste que tout fonctionne en relançant le serveur :
```shell
$ bundle exec middleman server
```

Et en rechargeant sa page de navigateur, on doit obtenir :

![Middleman Hello World avec Slim](middleman-02-hello-world-slim.png "Hello World Middleman avec Slim")

Hop, on committe :
```shell
$ git commit -a -m 'Ajout du language de templating Slim'
```


## Installation de Sass

La gem [Sass](http://sass-lang.com) s'est installée automatiquement avec Middleman, donc il suffit d'ajouter un fichier `source/css/default.css.sass` avec une règle simple à l'intérieur :
```sass
p
  color: red
```

Puis de l'inclure depuis le layout (`source/layouts/layout.slim`) en ajoutant une balise `<link>`. Ça doit donner ça :
```slim
link rel="stylesheet" href="css/normalize.css"
link rel="stylesheet" href="css/main.css"
link rel="stylesheet" href="css/default.css"
```

En rechargeant la page du navigateur, on doit bien obtenir un texte en rouge :

![Middleman Hello World avec Slim et Sass](middleman-03-hello-world-slim-sass.png "Hello World Middleman avec Slim et Sass")

Committer (toujours committer !) :
```shell
$ git add source/css/default.css.sass
$ git commit -a -m 'Ajout du fichier Sass par défaut'
$ git push
```



## Installation de CoffeeScript

Là encore, la gem CoffeeScript est déjà installée automatiquement avec Middleman, donc pas besoin de faire quoi que ce soit... juste à l'utiliser.

Ajouter les lignes suivantes au fichier `source/index.html.slim` :
```slim
p
  a#jquery-test href="#"
    | Click Me
```

Créer un fichier `source/js/helpers.js.coffee` avec le contenu suivant :
```coffeescript
$('#jquery-test').on 'click', ->
  alert 'Yeah !'
```

Inclure ce fichier depuis `source/js/main.js` en ajoutant la ligne suivante :
```javascript
//= require helpers
```

En rechargeant la page et en cliquant sur le lien "Click Me", vous devriez voir apparaitre une popup qui dit "Yeah !" :

![Middleman Hello World avec Slim, Sass et CoffeeScript](middleman-04-hello-world-slim-sass-coffee.png "Hello World Middleman avec Slim, Sass et CoffeeScript")

Committer, encore committer :

```shell
$ git add source/js/helpers.js.coffee
$ git commit -a -m "Ajout d'un ficher CoffeeScript"
$ git push
```



## Ajout d'une page en Markdown

J'aime bien Markdown, c'est simple à écrire, je m'en sers pour les README sur GitHub, donc j'en ai bien l'habitude - surtout avec leur amélioration [GitHub Flavored Markup](https://help.github.com/articles/github-flavored-markdown) - et ça se lit bien, même quand on est un misérable humain.

Bref, j'aimerais bien écrire mes articles en Markdown. On a qu'à tester.

Ma mégalomanie me dicte de commencer avec une page "À propos de moi". Qui parle de moi donc.

Créer un fichier `source/a-propos.html.md` avec à l'intérieur :

```markdown
## À propos

![Moi : Michael Baudino](http://www.gravatar.com/avatar/db878dfa87aec08092efcb7cc12ab343?size=128 "Moi : Michael Baudino")

Moi, c'est Michael Baudino, je suis le co-fondateur de [Alpine Lab](https://alpine-lab.com), une société qui, pour l'instant, est principalement occupée à développer un portail de vente de forfaits de ski multi-stations : [SkiWallet](https://www.skiwallet.com) !

Vous pouvez me contacter sur [GitHub](https://github.com/michaelbaudino), par [email](mailto:michael.baudino@alpine-lab.com) ou encore par [le compte Twitter d'Alpine Lab](https://twitter.com/AlpineLab) (c'est moi derrière).
```

Vous pouvez mettre votre propre contenu, ne vous sentez pas obligé(e) de ré-écrire ma bio ;-)

Note: pour le nom du fichier, on retrouve le schema classique (du moins si vous êtes un fidèle utilisateur de Sprockets, mais c'est probablement le cas) : on veut générer un fichier HTML (extension `.html`), mais on veut l'écrire en Markdown (extension `.md`), le fichier s'appelle donc `a-propos.html.md`.

Testons, en pointant un navigateur sur [http://localhost:4567/a-propos.html](http://localhost:4567/a-propos.html). Vous devriez voir ça :

![Page "À propos" écrite en Markdown](middleman-05-about.png "Page 'À propos' écrite en Markdown")

Committer, committer, committer :

```shell
$ git add source/a-propos.html.md
$ git commit -a -m 'Ajout de la page "A propos"'
$ git push
```



## Liens entre les pages (et autres helpers)

OK, on a maintenant deux pages (`index` et `a-propos`), on va pouvoir les lier. On va la jouer classique : on va créer un lien depuis la page d'accueil vers la page "À propos".

On va utiliser pour ça les [Template Helpers](http://middlemanapp.com/helpers/) : des fonctions mises à notre disposition dans les pages par Middleman.

Dans le fichier `source/index.html.slim`, ajouter les lignes suivantes :
```slim
p
  == link_to 'À propos', '/a-propos.html'
```

Si vous utilisez Rails, vous ne serez pas dépaysé(e), c'est la même chose.
Vous retrouverez, aussi d'autres helpers familiers comme :
* `stylesheet_link_tag`
* `javascript_include_tag`
* `image_tag`
* `form_tag` (et toute la famille qui va avec)
* le couple `content_for`/`yield_content`

Il y en a même d'autres spécifiques à Middleman et vous pouvez en déclarer des customs. Je vous laisse vous reporter à [la doc](http://middlemanapp.com/helpers/) pour aller plus loin.

Recharger votre page d'accueil pour tester, ça doit marcher (je ne vous remet pas un screenshot, vous avez compris !).

Et n'oubliez pas de... committer :
```shell
$ git commit -a -m 'Ajout du lien vers la page "A Propos"'
$ git push
```

## Mise en ligne sur GitHub Pages

OK, on a maintenant un site riche en contenu avec 2 pages. Mettons-le en ligne !

Compilons tout ça :
```shell
$ middleman build
```

Ça nous remplit donc le dossier `build/` de fichiers compilés, il faut maintenant les pusher sur un repository qui suit les recommandations [GitHub:Pages](https://help.github.com/articles/user-organization-and-project-pages).

Par exemple, ma page est la page de mon organisation `alpinelab`, mon repository doit donc s'appeler `alpinelab.github.com`.

On va donc ajouter un remote pour ce nouveau repository, on l'appelera intelligemment `gh-pages` (notez qu'il pointe vers un repository différent de celui qui héberge les sources, c'est important !) :
``` shell
$ git remote add gh-pages git@github.com:alpinelab/alpinelab.github.com.git
```

Ensuite on installe la gem qui va bien (`middleman-deploy`), en ajoutant au `Gemfile` la ligne suivante :
```ruby
gem 'middleman-deploy'
```

Suivi d'un superbe :
```shell
$ bundle install
```

On configure ladite gem en ajoutant au fichier `config.rb` :
```ruby
activate :deploy do |deploy|
  deploy.method = :git
  deploy.remote = 'gh-pages'
  deploy.branch = 'master'
end
```

Et enfin, on déploie :
```shell
$ middleman deploy
```

Et là, c'est le drame : il faut attendre (jusqu'à 10 minutes) pour que le site soit effectivement publié sur [http://alpinelab.github.com](http://alpinelab.github.com).

Mais normalement ça finit par arriver et ça marche :-)

On committe :
```shell
$ git commit -a -m 'Ajout de middleman-deploy'
```

Pour ne pas avoir à attendre 10 minutes la prochaine fois, on va dire à GitHub de ne pas essayer de compiler avec Jekyll les fichiers que l'on publie (puisque les fichiers qu'on lui balance sont déjà compilés, avec Middleman) :
```shell
$ cd build
$ touch .nojekyll
$ git add .nojekyll
$ git commit .nojekyll -m 'Ajout du nojekyll'
$ git push
```

Vous verrez que les prochains déploiements se feront beaucoup plus vite.



## Quelques douceurs en bonus

Dans le fichier de config (intelligemment nommé `config.rb`), il y a de quoi se faire plaisir.

### LiveReload

Je suis un peu fainéant, j'aime pas appuyer sur F5, alors j'utilise LiveReload en ajoutant ça à mon Gemfile :
```ruby
gem 'middleman-livereload'
gem 'rb-inotify'
```

Et ça à mon `config.rb` :
```ruby
activate :livereload
```

Puis après un petit :
```shell
$ bundle install
```

Et voilà, dès qu'on modifiera un fichier, le navigateur se rechargera tout seul. Elle est pas belle, la vie ?

### Minify

Il y a des pré-processeurs de minification en tous genre dans Middleman (vous savez, ça produit du code tout condensé, optimisé pour être plus léger).

Perso, j'utilise les directives suivantes dans mon `config.rb` :
```ruby
activate :minify_html
activate :minify_css
activate :minify_javascript
```

Pour que tout marche, j'ai aussi besoin de ça dans mon `Gemfile` :
```ruby
gem 'middleman-minify-html'
```

### Caching

Pour "fingerprinter" les assets (en langage un peu plus humain : pour mettre un hash à la fin des noms de fichiers des javascripts, css et autres images) afin d'éviter qu'un navigateur n'utilise une version obsolète d'un fichier qu'il aurait gardé en cache, il suffit d'ajouter cette ligne à `config.rb` (dans le block `configure :build`) :
```ruby
activate :asset_hash
```

### Autres

J'utilise aussi cette directive, pour générer les tailles des images tout seul à partir du helper `image_tag` :
```ruby
activate :automatic_image_sizes
```


## Conclusion

Voilà, on a donc une stack Middleman capable de compiler du Sass, du CoffeeScript, du Slim, du Haml (on ne l'a pas vu dans ce tutorial mais ça marche par défaut) et du Markdown.

Et l'ajout d'une page est extrêmement facile :

1. créer un fichier avec du contenu dedans (en Slim, Haml ou Markdown, au choix)
2. publier d'un simple `middleman build && middleman deploy`

Classe ! Enfin... si vous y mettez vos propres règles CSS ! Parce que là, le texte en rouge, c'est moyen la classe, en vérité.

Dans le prochain article, on verra comment transformer tout ça en un vrai blog (avec un nom de domaine custom, des tags, une recherche, des pretty URLs, un sitemap, et même une syntax highlighting pour pouvoir poster des bouts de code).



<h2 id="resume">Résumé</h2>

Pour ceux d'entre-vous qui veulent une version brève, la voici :

```shell
$ gem install middleman
$ middleman init mon projet --template=html5
```

```ruby
# Gemfile

gem 'middleman'
gem 'slim'
gem 'middleman-deploy'
gem 'middleman-livereload'
gem 'rb-inotify'
gem 'middleman-minify-html'
```

```ruby
# config.rb
set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'img'
configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :minify_html
  activate :asset_hash
end

activate :deploy do |deploy|
  deploy.method = :git
  deploy.remote = 'gh-pages'
  deploy.branch = 'master'
end

activate :livereload
```

Quelques commandes utiles :
```shell
$ middleman server # lance le serveur de développement (avec LiveReload)
$ middleman build  # lance la compilation du site statique
$ middleman deploy # déploie le site statique
```

Voilà, vous pouvez maintenant utiliser le surlanguage que vous voulez en suffixant le nom du fichier par l'extension du language utilisé (`index.html.haml`, par exemple), Sprockets s'occupe de tout.

Enjoy :-)

### Sources

* la [doc de Middleman](http://middlemanapp.com/getting-started), qui est tellement bien foutue !
