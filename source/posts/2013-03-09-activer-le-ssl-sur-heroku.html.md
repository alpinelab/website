---
title: Activer le SSL sur Heroku
date: 2013-03-09 17:22 +01:00
priority: 0.7
authorName: Michael Baudino
authorUrl: https://plus.google.com/106674357559734809246
tags: ssl, heroku
---

Le but de cet article est de montrer comment héberger un site HTTPS sur [Heroku](http://www.heroku.com).

Il suffit de 3 étapes : générer son certificat, installer l'addon Heroku qui va bien, configurer ses DNS.READMORE

### Générer son certificat

Pour le certificat, on a fait le choix d'en acheter un avec validation étendue (EV, pour Extended Validation) chez Thawte.

Il faut tout d'abord **créer une clé privée** avec password (dans un répertoire qui n'est pas public : cette clef est hautement confidentielle) :

```shell
$ openssl genrsa -des3 -out server.orig.key 2048
```

Cette commande demandera quelques renseignements relatives à l'émetteur de la clef (vous !). Attention, pour l'EV toutes les infos doivent être exactes.

Il faut ensuite **virer le password de cette clef** (sinon Heroku ne pourra pas l'utiliser puisque le password sera demandé à chaque démarrage du serveur) :

```shell
$ openssl rsa -in server.orig.key -out server.key
```

Ensuite on va **créer le CSR** correspondant (Certificate Signing Request, qui permet de demander à Thawte de nous générer un certificat) :

```shell
$ openssl req -new -key server.key -out server.csr
```

Il suffit ensuite d'**envoyer le CSR** à Thawte (en précisant "Autre" comme plate-forme pour le serveur), puis d'**attendre son certificat** qu'on reçoit par mail (ça peut prendre plusieurs jours : pour l'EV, Thawte va vérifier qu'on est une société déposée et qu'on a un numéro de téléphone dans les Pages Jaunes ou Kompass ou 118712) qu'on colle alors dans un fichier `thawte_SkiWallet.pem` (dans le même répertoire que les clefs et certificats créés précédemment).

### Installer le plugin Heroku SSL-Endpoint (et le configurer)

Pour ça rien, de plus simple, si vous êtes déja familier avec la [Toolbelt Heroku](https://toolbelt.heroku.com). Éxecutez simplement à la racine de votre projet hébergé :

```shell
$ heroku addons:add ssl
```

Depuis le répertoire dans lequel vous avez mis toutes les clefs et autres certificats générés précédemment, vérifier que la chaîne de confiance des certificats d'autorité intermédiaires est complète (la commande doit vous afficher une succession de certificats SSL si tout s'est bien passé, sinon, un message d'erreur) :

```shell
$ heroku certs:chain thawte_SkiWallet.pem
```

Vérifier ensuite que la clef privée correspond au certificat Thawte (la commande vous affichera la clef SSL en cas de succès, un message d'erreur sinon) :

```shell
$ heroku certs:key thawte_SkiWallet.pem server.key
```

Ajouter finalement tout ce tintouin à votre appli Heroku (suffixez avec `--app nom-de-votre-app-heroku` si votre toolbelt est configurée pour gérer plusieurs applications Heroku) :

```shell
$ heroku certs:add *
```

### Configurer son serveur DNS

OK, on a donc installé notre certificat (ouf !), il faut maintenant configurer son serveur DNS. On va commencer par récupérer l'adresse du endpoint SSL qui nous a été assigné par Heroku. Elle s'affiche dans la colonne "Endpoint" de la commande suivant) :

```shell
$ heroku certs
```

Chez moi, c'est `toyama-1696.herokussl.com`, dans ce qui suit, je vous laisse donc remplacer intelligemment par ce que vous aura répondu la commande ci-dessus.

On va juste faire une ou deux petites vérifications :
* tester que le endpoint route bien vers le HTTPS : en pointant son navigateur vers http://toyama-1696.herokussl.com ça doit afficher "No such app"
* tester que le endpoint sert bien le certificat en SSl : en pointant son navigateur vers https://toyama-1696.herokussl.com ça doit dire que le certificat est prévu pour votre nom de domaine (chez moi, www.skiwallet.com).

OK, on a donc l'URL du endpoint et ça semble fonctionner. Récupérons maintenant son adresse IP :

```shell
$ host toyama-1696.herokussl.com
```

L'adresse IP de mon endpoint, c'est "54.243.198.116", je vous laisse remplacer par la votre dans les exemple ci-dessous.

Avant de configurer son serveur DNS, testez déjà en surchargeant ladite adresse IP pour pointer vers votre domaine (moi : www.skiwallet.com) sur votre machine (ça évite de casser votre config DNS existante). Ajoutez donc la ligne suivante à votre fichier `/etc/hosts` (il faut avoir les droits root donc utilisez `su` ou `sudo`, selon votre distrib) :

```
54.243.198.116  www.skiwallet.com
```

Testez en visitant https://www.skiwallet.com avec votre navigateur (éventuellement, videz le cache avant). Votre site doit s'afficher et la fameuse "barre verte" doit s'afficher :-)

Pensez à enlever la ligne de votre fichier hosts, ça serait bête de se galérer pour ça.

On va donc pouvoir faire la vraie config, sur le vrai serveur DNS : changez vos DNS pour faire pointer www.skiwallet.com vers `toyama-1696.herokussl.com` avec un CNAME et le tour est joué.

### Bonus : Forcer Rails à utiliser HTTPS

Si votre site est fait en Rails (comme le mien), il est super simple de lui dire de rediriger toutes les requêtes vers HTTPS, afin de forcer les utilisateurs en HTTPS.

Il suffit donc de décommenter (ou ajouter) la ligne suivante dans le fichier `config/environments/production.rb` de votre projet :

```ruby
config.force_ssl = true
```

#### Sources

* Article [Creating an SSL Certificate Signing Request](https://devcenter.heroku.com/articles/csr) sur le DevCenter Heroku
* Article [SSL Endpoint](https://devcenter.heroku.com/articles/ssl-endpoint) sur le DevCenter Heroku
