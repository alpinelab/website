---
title: Interdire uniquement l'enregistrement de nouveaux utilisateurs sous Devise
date: 2013-05-07 08:11 CEST
authorName: Michael Baudino
authorUrl: https://plus.google.com/106674357559734809246
tags: rails, devise
---

Sur un site [Rails](http://rubyonrails.org) dont le contrôle d'accès est géré par [Devise](http://devise.plataformatec.com.br), on a parfois besoin d'interdire l'enregistrement de nouveaux utilisateurs (si les utilisateurs sont les administrateurs, dans le cadre d'un _back office_, par exemple).READMORE

À première vue, on pourrait se dire qu'il suffit de supprimer le rôle `:registerable` dans le modèle, mais cette solution a un inconvénient majeur : elle supprime purement et simplement l'accès au contrôleur `RegistrationsController`, l'utilisateur ne peut donc plus modifier les information de son compte (son nom, son adresse email, son mot de passe, etc...).

Il y a donc une autre solution, très simple, et qui permet de garder le rôle `:registerable` : on va supprimer toutes les routes menant au contrôleur, puis recréer seulement celles donc on a besoin.

Par défaut, on a un `config/routes.rb` qui ressemble à ça :

```ruby
devise_for :users
```

Il faut donc le modifier pour qu'il ressemble à ça :

```ruby
devise_for :users, :skip => [:registrations]
as :user do
  get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
  put 'users' => 'devise/registrations#update', :as => 'user_registration'
end
```

On voit que l'on supprime donc toutes les routes vers le contrôleur `RegistrationsController` (avec l'option `:skip => [:registrations]`) puis que l'on recrée les routes `edit` (qui affiche le formulaire de modification du compte utilisateur) et `update` (qui effectue véritablement les modifications en base de données).

La seule erreur que cette modification va engendrer, c'est que le _helper_ `new_registration_path` n'existe plus (puisque la route vers `devise/registrations#new` n'existe plus). Il faut donc aller modifier la vue partielle `app/views/devise/shared/_links.html.erb` et **supprimer la partie suivante** (qui génère normalement un lien 'Sign up') :

```erb
<%- if devise_mapping.registerable? && controller_name != 'registrations' %>
  <%= link_to "Sign up", new_registration_path(resource_name) %>
<% end -%>
```

### Bonus : ménage

Si vous aviez généré les vues Devise dans votre propre application pour les personnaliser, vous pouvez en supprimer une qui ne vous servira jamais (celle avec le formulaire d'inscription d'un nouvel utilisateur) :

```shell
$ rm -f app/views/devise/registrations/new.html.erb
```

Perso, je ne me sers pas non plus des vues des contrôleurs `ConfirmationsController` et `UnlocksController`, donc généralement, je les vire aussi (mais après, c'est à vous de voir...) :

```shell
$ rm -rf app/views/devise/confirmations/
$ rm -rf app/views/devise/unlocks/
```

#### Sources
* cette [question sur StackOverflow](http://stackoverflow.com/questions/6734323/how-do-i-remove-the-devise-route-to-sign-up)
* cet [article de Robotex](http://blog.robotex.de/read/devise-disabling-sign-up)
* et bien sûr, la [doc](http://devise.plataformatec.com.br) et le [wiki](https://github.com/plataformatec/devise/wiki) de Devise