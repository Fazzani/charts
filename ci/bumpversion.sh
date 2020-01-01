#!/bin/bash

[ -z "$1" ] && echo "Version Semver not supplied !!" && exit 1

git add . && git commit -m "bump version $1" && \
git tag -a "$1" -m "Version $2" && \
git push && git push --tags