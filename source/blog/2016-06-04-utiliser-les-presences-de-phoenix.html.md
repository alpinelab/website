---
title: Utiliser les Presences de Phoenix
date: 2016-06-04 07:18 CEST
authorName: Michael Baudino
authorEmail: michael.baudino@alpine-lab.com
authorURL: https://twitter.com/michaelbaudino
tags: elixir, phoenix, presence
---

Chez [AlpineLab](http://www.alpine-lab.com), on essaye parfois de s'ouvrir l'esprit et de ne pas faire que du Ruby. Depuis quelques temps, on s'essaye à [Elixir](https://www.elixir-lang.org) et son framework web [Phoenix](https://www.phoenixframework.org). Un des (nombreux) points forts de Phoenix est d'offrir une communication bidirectionnelle entre le serveur et les clients avec une simplicité enfantine grâce à son implémentation des [Channels](http://www.phoenixframework.org/docs/channels).

Dans sa version 1.2 (actuellement en release candidate) son créateur [Chris McChord](https://github.com/chrismccord) a introduit la notion de [Presence](https://hexdocs.pm/phoenix/1.2.0-rc.1/Phoenix.Presence.html). Comme son nom l'indique assez bien, ça permet de tracker les clients (navigateurs) qui sont connectés au "serveur" (entre guillemets, parce que le "serveur" sous Phoenix est prévu pour être distribué et décentralisé) de manière fiable (consistente, répliquée, temps-réel et sans conflit ni collision). Il explique super bien le fonctionnement des `Presence`s dans son intervention à [ElixirConf Europe](http://www.elixirconf.eu) ci-dessous:

<div style="text-align: center"><iframe width="560" height="315" align="middle" src="https://www.youtube.com/embed/n338leKvqnA" frameborder="0" allowfullscreen></iframe></div>

Si vous vous en foutez de savoir comment ça marche (on ne juge pas), laissez tomber la vidéo : on va voir comment utiliser les `Presence`s en quelques lignes de code seulement, tellement c'est facile.

On admet que vous avez déjà une application Phoenix qui tourne et qui s'appelle intelligemment `MyApp` (mais libre à vous d'adapter à votre cas) et une implémentation basique (serveur et client) des `Channel`s. On va lui ajouter le support des `Presence`s.

## 1. Installation

Il faut tout d'abord installer Phoenix 1.2+ (au moment où j'écris ces lignes, la version la plus récente est `1.2.0-rc.1`). Mettez donc à jour vos dépendances dans `mix.exs` pour utiliser une version 1.2+:

```elixir
  defp deps do
    [
      {:phoenix, "~> 1.2.0-rc.1"},
      ... # probablement d'autres dépendences ici
    ]
  end
```

Puis lancez installer la nouvelle version (et ses nouvelles dépendances) depuis un shell:

```shell
$ mix deps.get
```

D'autre part, `npm` va télécharger ses dépendances `phoenix` et `phoenix_html` non pas sur le serveur `npm` comme d'habitude, mais directement sur votre disque dur et les copie dans `node_modules`. C'est pour ça que votre `package.json` doit probablement déjà contenir ces dépendances:

```
  "phoenix":      "file:deps/phoenix",
  "phoenix_html": "file:deps/phoenix_html",
```

Bref, ce qu'il faut donc faire, c'est dire à `npm` qu'il faut re-"télécharger" ces fichiers, puisqu'ils ont changé et sont maintenant en version 1.2. un simple:

```shell
$ npm update phoenix phoenix_html
```

## 2. Configuration

Pour utiliser les `Presence`s, il faut tout d'abord démarrer leur superviseur depuis `lib/my_app.ex`. Ajoutez les lignes suivantes au tableau `children` (vous verrez, il doit y en avoir déjà au moins un autre):

```elixir
children = [
  ...
  supervisor(MyApplication.UserPresence, [])
]
```

Ensuite, il faut créer un module de `Presence` dans notre application qu'on nommera simplement `MyPresence`. On créé donc un fichier `web/channels/my_presence.ex` dans lequel on va écrire:

```elixir
defmodule MyApp.MyPresence do
  use Phoenix.Presence, otp_app: :my_app,
                        pubsub_server: MyApp.PubSub
end
```

Voilà, c'est tout. On va enfin pouvoir passer aux choses intéressantes.

## 3. Implémentation

Le fonctionnement est simple, il se décompose en 3 actions distinctes:

1. lorsqu'un client se connecte à un channel, il fournit un identifiant et le serveur l'enregistre dans sa liste de `Presence`s (avec éventuellement des meta-données de votre choix)
2. le serveur lui envoie alors l'état actuel des `Presence`s (_i.e._ des autres clients connectés au même channel) sous forme d'un message `presence_state`
3. périodiquement, le serveur va envoyer une mise à jour de l'état des présences (_i.e._ une liste de clients s'étant connectés et une liste des clients s'étant déconnectés) sous la forme d'un message `presence_diff`

C'est tout. La synchronisation entre les différents serveur distribués est faite automatiquement, on n'a pas à s'en occuper.

### Côté serveur (Channel)

Tout se passe dans le fichier qui déclare votre module `Channel` (genre `web/channels/my_channel.ex`). Pour plus de confort, commencez par aliaser votre module `MyPresence`:

```elixir
alias MyApp.MyPresence
```

Ça permet tout simplement d'utiliser `MyPresence` plutôt que `MyApp.MyPresence` dans le reste du module.

Quand un client se connecte, c'est la fonction [`join/3`](https://hexdocs.pm/phoenix/1.2.0-rc.1/Phoenix.Channel.html#c:join/3) qui est appelée avec comme arguments le topic (_i.e._ le nom) du `Channel` auquel il se connecte, un `Map` de paramètres ainsi que le `Socket` qui gère la connexion.

Dans notre exemple, on va attendre du client qu'il envoie dans les paramètres un `user_name` pour s'authentifier. On va donc modifier la jonction `join/3` pour stocker dans le `Socket` le `user_name` fourni (on pourra alors le récupérer de n'importe où, le `Socket` étant passé à toutes les fonctions liées au `Channel`). On fait ça grâce à la méthode [`assign/3`](https://hexdocs.pm/phoenix/1.2.0-rc.1/Phoenix.Socket.html#assign/3) qui stocke des données clef-valeur dans un `Socket`. On modifie donc la fonction `join/3` pour ne pas retourner simplement `{:ok, socket}` mais ceci:

```elixir
def join("channel:" <> _channel_id, params, socket) do
  {:ok, assign(socket, :user_name, params["user_name"])}
end
```

On va ensuite ajouter un callback `after_join` qui va ajouter le client qui vient de se connecter (authentifié par le `user_name` stocké dans son `Socket`) à la liste de `Presence` du serveur. On utilise pour ça la fonction [`track/3`](https://hexdocs.pm/phoenix/1.2.0-rc.1/Phoenix.Presence.html#c:track/3) de notre module `MyPresence` (qui le tient lui-même du module `Phoenix.Presence`) en lui passant le `user_name` précédemment assigné au `Socket`, pour obtenir ce qui suit:

```elixir
def join("channel:" <> _channel_id, params, socket) do
  send(self, :after_join)
  {:ok, assign(socket, :user_name, params["user_name"])}
end

def handle_info(:after_join, socket) do
  {:ok, _} = MyPresence.track(socket, socket.assigns.user_name, %{})
  {:noreply, socket}
end
```

Notez qu'on doit appeler explicitement `after_join` dans `join/3` et que le 3ème argument de `track/3` permet de stocker n'importe quelles données qui seront passées aux clients.

Ça constitue l'étape 1 de notre implémentation décrite ci-dessus (l'enregistrement du client dans les `Presence`s du serveur).

Pour implémenter l'étape 2 (l'envoi au client de la liste actuelle des `Presence`s du serveur), il suffit d'envoyer au client un message `presence_state` contenant le résultat de la fonction [`list/1`](https://hexdocs.pm/phoenix/1.2.0-rc.1/Phoenix.Presence.html#list/2) de `MyPresence` (qu'il tient une fois de plus de `Phoenix.Presence`):

```elixir
def join("channel:" <> _channel_id, params, socket) do
  send(self, :after_join)
  {:ok, assign(socket, :user_name, params["user_name"])}
end

def handle_info(:after_join, socket) do
  {:ok, _} = MyPresence.track(socket, socket.assigns.user_name, %{})
  push socket, "presence_state", MyPresence.list(socket)
  {:noreply, socket}
end
```

Easy !

### Côté client (JS)

Côté client, on va déjà modifier le code qui se connecte au `Channel` pour lui passer un `user_name`. Ça doit donc ressembler à ça:

```javascript
socket.channel("channel:general", {user_name: "Mike"})
```

Vous aurez pris soin dans la vraie vie de remplacer les valeurs du topic du `Channel` et du `user_name` par ce qui vous chante, souvent un truc entré par l'utilisateur... au moins pour le `user_name` ;-)

Maintenant on va faire en sorte de gérer correctement les messages `presence_state` et `presence_diff` que nous envoie le serveur.

Pour gérer les message entrants, on avait déjà la fonction `.on()` fournie par la classe `Channel` du package `phoenix`. On va aussi utiliser les fonctions `.syncState()` et `.syncDiff()` de la nouvelle classe `Presence` du même package pour mettre à jour une liste des clients connectés avec le contenu du message envoyé par le serveur (respectivement `presence_state` et `presence_diff`, donc).

Si ce n'est pas très clair, c'est parce que je m'exprime mal, mais vous allez voir que c'est super simple avec du code (ES6):

```javascript
import { Socket, Presence } from "phoenix"

... // initialisation du socket et du channel

let connectedUsers = []

channel.on("presence_state", payload => {
  Presence.syncState(connectedUsers, payload)
})

channel.on("presence_diff", payload => {
  Presence.syncDiff(connectedUsers, payload)
})
```

Et paf ! Votre tableau `connectedUsers` sera automatiquement mis à jour lorsque le serveur vous notifiera qu'il y a eu des changements dans sa liste de `Presence` (et il contient également toutes les meta-données que vous auriez passées à `MyPresence.track/3` dans le `Channel` côté serveur).
