# Alpine Lab website and blog

This is the source code only.

For the compiled, static, hosted on [github:pages](http://pages.github.com) site, see the [gh-pages branch](https://github.com/alpinelab/website/tree/gh-pages).

The website/blog itself is available at [www.alpine-lab.com](http://www.alpine-lab.com).

Powered by [Middleman](http://middlemanapp.com) in our [Docker image for Ruby development](https://github.com/alpinelab/docker-ruby-dev).
Precompiles [Haml](http://haml.info), [Sass](http://sass-lang.com), [CoffeeScript](http://coffeescript.org/) and [Markdown](https://daringfireball.net/projects/markdown/).

> Run `docker-sync start` once prior to any other command if you're on Macintosh 🍎

## Setup

To configure [LocaleApp](https://www.localeapp.com), type the following command:

```shell
docker-compose run app localeapp install --standalone --write-env-file <APIKEY>
```

## Run

To run the development server, run:

```shell
docker-compose up
```

Update localized content from [LocaleApp](https://www.localeapp.com) using:

```shell
docker-compose run app localeapp pull
```

## Deploy

When your changes are ready to be published, run:

```shell
docker-compose run -v ~/.ssh:/etc/skel/.ssh -v ~/.gitconfig:/etc/skel/.gitconfig app ./deploy.sh
```

## Wanna join us?

Simply create a PR here that adds you as a team member!

#### License

Written by [Michael Baudino](https://github.com/michaelbaudino) and [Sylvain Fertons](https://github.com/Spharian) for [Alpine Lab](http://www.alpine-lab.com), 2013.
Licensed under the terms of the MIT license (see `LICENSE.md` file).
