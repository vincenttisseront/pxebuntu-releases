# PXEBuntu – versions publiées

Versions de l'appliance PXEBuntu (serveur de déploiement réseau PXE sur
Ubuntu Server 24.04 LTS durcie, administré par une console web HTTPS).

Chaque version publie :

| Fichier | Rôle |
| --- | --- |
| `pxebuntu-X.Y.Z-update.tar` | Paquet de mise à jour en place (charge utile et paquets Debian nécessaires) |
| `pxebuntu-X.Y.Z-update.tar.sig` | Signature Ed25519 du paquet, vérifiée par l'appliance avant toute installation |
| `pxebuntu-X.Y.Z-update.tar.sha256` | Empreinte SHA-256 du paquet |
| `pxebuntu-update` | Outil de mise à jour (déjà présent sur l'appliance à partir de 0.2.0) |
| `pxebuntu-X.Y.Z-packages.lock` | Liste figée des paquets Debian embarqués |

L'ISO d'installation complète n'est pas publiée à chaque version (elle dépasse
la taille autorisée pour un fichier de version GitHub).

## Mettre à jour une appliance

À partir de 0.2.0 : console web, **Système > Général > Mise à jour de
l'appliance**, puis « Installer la dernière version ». En ligne de commande :

```
sudo pxebuntu-update check
sudo pxebuntu-update apply latest
```

Depuis 0.1.0 (qui n'a pas encore l'outil), une seule fois, en SSH sur l'appliance :

```
curl -fsSL -o /tmp/pxebuntu-update https://github.com/vincenttisseront/pxebuntu-releases/releases/latest/download/pxebuntu-update
sudo python3 -I /tmp/pxebuntu-update apply latest
```

La mise à jour vérifie la signature, les empreintes et la version, sauvegarde
la version en place dans `/var/lib/pxebuntu-update/`, et conserve la
configuration locale (`/etc/pxebuntu/appliance.conf`, comptes, certificat).

Clé publique de signature (Ed25519) :

```
-----BEGIN PUBLIC KEY-----
MCowBQYDK2VwAyEAZuIxpcQeGreXprGqNVMfgehMcBO/ep0B5YeIIykISD4=
-----END PUBLIC KEY-----
```

## Publication d'une version

Le workflow `.github/workflows/publier.yml` publie les versions. Pour publier
`X.Y.Z`, pousser une branche `publication/vX.Y.Z` contenant
`publication/vX.Y.Z/` : `notes.md`, le paquet découpé en
`pxebuntu-X.Y.Z-update.tar.partNN`, sa signature, son empreinte,
`pxebuntu-update` et la liste des paquets. Le script `outils/publier.sh`
le fait :

```
outils/publier.sh X.Y.Z DOSSIER_DU_PAQUET NOTES.md
```

Le workflow reconstitue le paquet, vérifie l'empreinte et la signature avec la
clé publique ci-dessus, crée la version (ou remplace ses fichiers si elle
existe), puis supprime la branche.
