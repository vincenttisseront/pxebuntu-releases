#!/bin/bash
# Prépare et pousse une branche publication/vX.Y.Z ; le workflow « publier »
# reconstitue le paquet, vérifie empreinte et signature, crée (ou met à jour)
# la version GitHub puis supprime la branche.
# Usage : outils/publier.sh X.Y.Z DOSSIER_DU_PAQUET NOTES.md
set -eu
VERSION=$1; SRC=$2; NOTES=$3
case $VERSION in [0-9]*.[0-9]*.[0-9]*) ;; *) echo "version invalide" >&2; exit 2;; esac
TOP=$(cd "$(dirname "$0")/.." && pwd)
cd "$TOP"
git fetch -q origin main
git checkout -q -B "publication/v$VERSION" origin/main
D="publication/v$VERSION"
mkdir -p "$D"
cp "$NOTES" "$D/notes.md"
for f in "pxebuntu-$VERSION-update.tar.sha256" "pxebuntu-$VERSION-update.tar.sig" \
         pxebuntu-update "pxebuntu-$VERSION-packages.lock"; do
  cp "$SRC/$f" "$D/"
done
split -b 45M -d "$SRC/pxebuntu-$VERSION-update.tar" "$D/pxebuntu-$VERSION-update.tar.part"
git add "$D"
git commit -q -m "Publication $VERSION"
git push -q -f origin "publication/v$VERSION"
git checkout -q main
git branch -q -D "publication/v$VERSION"
echo "Branche publication/v$VERSION poussée : le workflow publie la version."
