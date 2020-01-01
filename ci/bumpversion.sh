#!/bin/bash

[ -z "$1" ] && echo "Version Semver not supplied !!" && exit 1

git add . && git commit -m "bump version $1" && \
(git tag -d "$1" || echo -e "$1 tag not exist yet") && \
git tag -fa "$1" -m "Version $2" &&  \
git push origin master --tags