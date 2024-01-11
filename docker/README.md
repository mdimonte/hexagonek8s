# Introduction

Ce document est une proposition de solution aux exercices du TP sur les rappels de `Docker`.

## Exercice n°1

Après avoir installé `Docker` sur votre laptop, Vérifiez son bon fonctionnement en démarrant un conteneur à partir de l’image `hello-world:latest`

### proposition de solution

```bash
# lancement du conteneur
# si tout se passe bien vous devez voir un message qui vous confirme que tout
# fonctionne bien
docker run --label exo-1 hello-world:latest

# suppression du conteneur
docker ps -a --format=json | jq -r '. | select(.Labels == "exo-1=") | .ID' | xargs docker rm
```

## Exercice n°2

Créez une image de conteneur à partir de l’image de base `nginx:latest` et personnalisez le fichier `index.html` servi par défaut

### proposition de solution

```bash
# construction de l'image de conteneur
docker build -t mdimonte/nginx-custom:latest .
```

## Exercice n°3

Démarrez un conteneur à partir de votre image

### proposition de solution

```bash
# lancer le conteneur
docker run --label exo-3 -d -p 8080:80 mdimonte/nginx-custom:latest

# accéder à nginx et vérifier que la page obtenue est bien celle que vous avez
# personnalisée
curl http://localhost:8080

# suppression du conteneur
docker ps -a --format=json | jq -r '. | select(.Labels == "exo-3=") | .ID' | xargs docker rm -f
```

## Exercice n°4

Publiez votre image dans votre repository sur le hub docker

### proposition de solution

```bash
# authentification auprès du docker hub
docker login

# publier l'image
docker push mdimonte/nginx-custom:latest
```

## Exercice n°5

Supprimer l’image qui existe en local puis relancez le conteneur

### proposition de solution

```bash
# supprimer l'image locale
docker image rm mdimonte/nginx-custom:latest

# relancer le conteneur pour confirmer que l'image est bien
# récupérée auprès du docker hub
docker run --label exo-5 -d -p 8080:80 mdimonte/nginx-custom

# accéder à nginx et vérifier que la page obtenue est bien celle que vous avez
# personnalisée
curl http://localhost:8080

# suppression du conteneur
docker ps -a --format=json | jq -r '. | select(.Labels == "exo-5=") | .ID' | xargs docker rm -f
```