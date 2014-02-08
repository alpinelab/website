---
title: Des helpers pour vérifier la version de Rails
date: 2014-02-08 16:59 CET
priority: 0.7
authorName: Michael Baudino
authorUrl: https://plus.google.com/+MichaelBaudino
tags: rails, helper, gem development
---

En travaillant sur la gem de [Locale](http://www.localeapp.com), et comme ça arrive souvent quand on développe une gem, on a eu besoin de charger du code spécifique pour certaines versions de Rails. Les petites fonctions toutes bêtes qui suivent servent à savoir dans quelle version de Rails on se trouve au moment de l'exécution du code.READMORE

**TL;DR :** les helpers sont disponibles [dans ce Gist](https://gist.github.com/michaelbaudino/8884362)

En l'occurrence, il fallait s'adapter à un comportement de Rails que l'on observe dans Rails 3.2.16+ et Rails 4.0.2+ (suite à un patch pour une n-ième faille de sécu dans la gestion des fichiers YAML).

Déjà, il faut savoir que les numéros de version de Rails sont stockés dans le module `::Rails::VERSION` qui contient 4 constantes :
* `MAJOR`: le numéro de version majeur (pour 4.0.2, c'est 4)
* `MINOR`: le numéro de version mineur (pour 4.0.2, c'est 0)
* `TINY`: le numéro de patch (pour 4.0.2, c'est 2)
* `STRING`: le numéro de version complet sous forme de string (donc pour 4.0.2, c'est "4.0.2")

La façon bourrine de vérifier qu'on est dans un de ces deux cas est la suivante :
```ruby
if (::Rails::VERSION::MAJOR == 4 && (::Rails::VERSION::MINOR > 0 or (::Rails::VERSION::MINOR == 0 && ::Rails::VERSION::TINY >= 2))) ||
   (::Rails::VERSION::MAJOR == 3 && (::Rails::VERSION::MINOR > 2 or (::Rails::VERSION::MINOR == 2 && ::Rails::VERSION::TINY >= 16)))
  # votre code va ici
end
```

C'est moche, hein ? Non, je n'en suis pas fier.

C'est con parce qu'il suffit de savoir qu'il y a deux classes Ruby vachement utiles pour comparer les numéros de versions qui sont [Gem::Requirement](http://www.ruby-doc.org/stdlib-2.1.0/libdoc/rubygems/rdoc/Gem/Requirement.html) et [Gem::Version](http://www.ruby-doc.org/stdlib-2.1.0/libdoc/rubygems/rdoc/Gem/Version.html).

`Gem::Requirement` permet de créer des _matchers_, genre '~> 4.0.2' (ça vous dit quelque chose ?).
`Gem::Version`, comme son nom l'indique intelligemment, ça stocke un numéro de version.
Et le lien utile entre les deux, c'est la méthode `satisfied_by?` de `Gem::Requirement` qui renvoie vrai ou faux selon si l'objet `Gem::Version` qu'on lui passe en paramètre est conforme au _matcher_.

Quelques exemples :
```ruby
Gem::Requirement.new('>= 4.0.2').satisfied_by? Gem::Version.new('3.2')
# => false
Gem::Requirement.new('>= 4.0.2').satisfied_by? Gem::Version.new('4.1')
# => true
Gem::Requirement.new('~> 4.0.2').satisfied_by? Gem::Version.new('4.0.3')
# => true
Gem::Requirement.new('~> 4.0.2').satisfied_by? Gem::Version.new('4.1')
# => false
```

Voilà, à partir de là, tout est très simple, on créé une fonction qui fait la même chose - non pas par rapport à un numéro de version arbitraire - mais par rapport au numéro de version de Rails (dans lequel le code est exécuté) :
```ruby
def rails_version_matches?(requirement)
  Gem::Requirement.new(requirement).satisfied_by? Gem::Version::new(::Rails::VERSION::STRING)
end
```

Il nous suffit dans le code de faire:
```ruby
if rails_version_matches? '~> 4.0.2'
  # du code custom ici
end
```

Classe, non ?

Oui, mais nous on veut vérifier plusieurs versions de Rails (souvenez-vous : "3.2.16+ **et** 4.0.2+").

Pour ça, on va utiliser, des fonctions similaires mais qui prennent plusieurs _matchers_ en paramètre, et qui vérifie que la version courante de Rails satisfait au moins un de ces _matchers_ (pour la version `_any`) ou tous ces _matchers_ à la fois (pour la version `_all`) en utilisant les opérateurs booléens `&` et `|` entre leurs résultats :
```ruby
def rails_version_matches_any?(*requirements)
  requirements.map{ |r| rails_version_matches?(r) }.reduce(:|)
end

def rails_version_matches_all?(*requirements)
  requirements.map{ |r| rails_version_matches?(r) }.reduce(:&)
end
```

Au final, je teste que ma version courante de Rails est 3.2.16+ ou 4.0.2+ comme ça :
```ruby
if rails_version_matches_any? '~> 3.2.16', '~> 4.0.2'
  # mon code qui va bien
end
```

Bien plus propre qu'avant. Là, ça me plait.