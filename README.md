# Inception of Things

Projet K3s avec Vagrant, ArgoCD et K3D

Ce projet est divisé en trois parties principales, détaillées ci-dessous. Assurez-vous de suivre les étapes de chaque partie pour configurer et exécuter le projet correctement.

## Table des matières

- [Partie 1: Configuration de Vagrant avec K3s](#partie-1)
- [Partie 2: Déploiement des services avec Vagrant et K3s](#partie-2)
- [Partie 3: Intégration d'ArgoCD et K3D](#partie-3)

---

## Partie 1

Cette partie concerne la configuration initiale de deux machines virtuelles avec Vagrant et l'installation de K3s.

- **Prérequis** : Écrire un Vagrantfile pour deux machines.
- **Spécifications** : 
  - Nom de la machine : login de l'équipe suivi de "S" ou "SW".
  - IP dédiée sur l'interface eth1.
  - Connexion SSH sans mot de passe.
  - Installation de K3s en mode contrôleur et agent.

**Suggestion de capture d'écran** : Une capture de vos machines virtuelles en cours d'exécution, ainsi que le résultat de la commande `k get nodes -o wide`.

[Plus de détails dans le README de la Partie 1](./p1/README.md)

---

## Partie 2

Cette section traite du déploiement des services sur une machine virtuelle.

- **Prérequis** : Créer un Vagrantfile pour le serveur.
- **Fonctionnalités** :
  - Copie des fichiers vers la VM.
  - Attribution des spécifications à la VM.
  - Lancement du script pour installer k3s et appliquer les services.

**Suggestion de capture d'écran** : Une capture montrant le résultat de la commande `kubectl get all`, ainsi qu'une capture de la réponse de la commande `curl -H "Host:app1.com" 192.168.56.110`.

[Plus de détails dans le README de la Partie 2](./p2/README.md)

---

## Partie 3

Intégration d'ArgoCD et K3D pour la gestion des déploiements.

- **Configuration** : Lancer `setup.sh`.
- **Fonctionnalités** :
  - Port-forwarding manuel pour ArgoCD et l'application.
  - Clonage du dépôt Git pour la configuration.
  - Commutation entre les versions de l'application.

**Suggestion de capture d'écran** : Une capture de l'interface ArgoCD montrant vos applications déployées, ainsi qu'une capture de l'application `wil-application` en cours d'exécution.

[Plus de détails dans le README de la Partie 3](./p3/README.md)

---
## Contribution

- [jurichar](https://github.com/jurichar)
- [mpochard](https://github.com/mpochard)
- [macrespo](https://github.com/macrespo)

