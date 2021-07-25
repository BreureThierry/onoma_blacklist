## Resource infos :

Name : Onoma_blacklist
Auteur : Tusblux
Version : 1.0.0
Note dev : Resource en developpement, certainement instable, à testé avec plusieurs joueurs.
IMPORTANT: Ne fonctionnera pas correctement si es_extended n'est pas adapter.

## Description :

Blacklistage de vehicule (terrestre, aquatique et aerien).
Blacklistage des vehicules de police avec whitelist pour les joueurs ayant le job police.
Systeme de vérouillage et d'alarme des vehicules de Police avec whitelist pour les joueurs ayant le job police.
Assez configurable dans le 'config.lua'.
Les crimes alerte les ped police comme dans GTAV classique mais sans le système de niveau de recherche.
Les autorités entre en alerte lorsque qu'on tente d'ouvrir un véhicule de police ou blacklisté.

>Si un joueur essaye d'accéder à un véhicule de police : il sera recherché - NIVEAU 1

>Si un joueur essaye d'accéder à un véhicule blacklisté : il sera recherché - NIVEAU 3

## Adaptation de es_extended :

**es_extended/config.lua :**

```
Config.DisableWantedLevel doit être sur false
```

Il va falloir adapter votre serveur afin que les ped réagissent au crimes

## Bug ou problèmes rencontrer :

#[1]    !Plus d'actualité! 
    Lorsqu'on est recherché, certains véhicule non blacklisté le deviennent. 
    le problème persiste même après la fin de poursuite, et relance une poursuite.
    *problème potentiellement situé ici -> if (lock == 7 or ped) then*
    - les vehicules blacklisté ne peuvent pas être conduis.
    - après quelque modif les vehicules blacklisté peuvent être conduis, parfois non...

#[2]    !Plus d'actualité!
    Après plusieurs redémarrage du script, les ped police ne tirent plus mais reste en alerte.
    *problème potentiellement dû à un conflis avec mon es_extended, configuré pour que les ped police réagissent aux crimes*

#[3]    !Plus d'actualité!
    Les vehicules de police démarrer sont parfois accessible.
    * probleme peut-être identique au [1] *