---
title: Create a blog using Jekyll and Docker
description: This post briefly describes how to set up Jekyll in Docker to create your own blog.
slug: 2021-create-blog-using-jekyll-and-docker
date: 2021-04-24 20:00:00+0000
categories:
    - Tech
tags:
    - Blog
    - Jekyll
    - Docker
weight: 1
---

## Foreword

~~This blog is created using [Jekyll](https://jekyllrb.com/).~~

The striked through sentence above used to be true for the old version of this blog, hosted on [misterderpie.com].
However, the version at [revontulet.dev] uses GitHub pages and Hugo.

## Original Post

I really like Jekyll, as I don't like frontend development.
One problem is though, that I currently only have Jekyll installed on one single machine.
So when I'm not at home but want to add a blog post, I would have to install Jekyll on the machine I'm travelling with.
Luckily there is Docker and the [envygeeks/jekyll-docker](https://github.com/envygeeks/jekyll-docker) Jekyll Image.
As I'm adding blogposts very rarely, I do not need to have a full build and delivery pipeline for it (despite the fact that at the time of writing I wouldn't even be able to create such).
A simple container to build the latest version of the site suits my needs.

The reason I made a small script for that is the following.
1. Obviously I'm lazy, and want to have an out-of-the-box command for every machine.
2. Creating the container with `docker run --rm` will always create a new container installing all dependencies.
This process can take a while.
3. Persisting the container after first creation enables to rerun it after adding a new post.
No need to install dependencies again.

The script is nothing special, but I thought it's been a while since I added a post.
Maybe you can find some use in it.


Simply create an executable script in your GitHub Repo and put the following content in it (I named it `build.sh`):
```bash
#!/bin/bash
BUILDER_NAME=jekyll_builder
JEKYLL_VERSION=3.8
if [ ! "$(docker ps -a -q -f name=$BUILDER_NAME)" ]; then
    docker container run \
        --name $BUILDER_NAME \
        --env JEKYLL_ENV=production \
        --volume="$(pwd)":/srv/jekyll \
        --entrypoint "/bin/bash" \
        jekyll/jekyll:$JEKYLL_VERSION \
        jekyll build
else
    docker container start -i $BUILDER_NAME
fi
```

When then running `./build.sh` on first startup it will create a container `jekyll_builder`.
Whenever you run this again after adding a blog post (or removing one), this will build the latest version of your site.
The output is in `_site/` directory (relative to your repositories root), so the same as without using Docker at all.

One downside to this approach is that as soon as you move the repository on your machine, this would not work as expected anymore.
To make it work again you could simply remove the container `docker container rm jekyll_builder`.