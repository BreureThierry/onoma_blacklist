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

**Dans le client/main.lua -> ajouter ceci :**

```
if Config.EnableWantedLevel then
	Citizen.CreateThread(function()
		for i = 1, 32 do
			EnableDispatchService(i, true)
            -- Note à titre informatif // peut être supprimer
			-- EnableDispatchService(	1,		boolean		)	- valeur -> [DT_] Invalid	
			-- EnableDispatchService(	2,		boolean		) 	- valeur -> [DT_] PoliceAutomobile
			-- EnableDispatchService(	3,		boolean		) 	- valeur -> [DT_] PoliceHelicopter
			-- EnableDispatchService(	4,		boolean		) 	- valeur -> [DT_] FireDepartment
			-- EnableDispatchService(	5,		boolean		) 	- valeur -> [DT_] SwatAutomobile
			-- EnableDispatchService(	6,		boolean		) 	- valeur -> [DT_] AmbulanceDepartment
			-- EnableDispatchService(	7,		boolean		) 	- valeur -> [DT_] PoliceRiders
			-- EnableDispatchService(	8,		boolean		) 	- valeur -> [DT_] PoliceVehicleRequest
			-- EnableDispatchService(	9,		boolean		) 	- valeur -> [DT_] PoliceRoadBlock
			-- EnableDispatchService(	10,		boolean		) 	- valeur -> [DT_] PoliceAutomobileWaitPulledOver
			-- EnableDispatchService(	11,		boolean		) 	- valeur -> [DT_] PoliceAutomobileWaitCruising
			-- EnableDispatchService(	12,		boolean		) 	- valeur -> [DT_] Gangs
			-- EnableDispatchService(	13,		boolean		) 	- valeur -> [DT_] SwatHelicopter
			-- EnableDispatchService(	14,		boolean		) 	- valeur -> [DT_] PoliceBoat
			-- EnableDispatchService(	15,		boolean		) 	- valeur -> [DT_] ArmyVehicle
			-- EnableDispatchService(	16,		boolean		) 	- valeur -> [DT_] BikerBackup
		end
		while true do
			Citizen.Wait(0)
			SetPoliceIgnorePlayer(playerId, false)
			SetMaxWantedLevel(Config.WantedLevelMax)
			SetPlayerWantedLevelNoDrop(playerId, Config.WantedLevelMax, false)
		end
		local playerId = PlayerId()
		if GetPlayerWantedLevel(playerId) == 0 then
			SetPlayerWantedLevel(playerId, Config.WantedLevelMax, false)
			SetPlayerWantedLevelNow(playerId, false)
		end
	end)
end
```

**Dans le config.lua -> ajoutez ceci :**

```
-- Important !! Config.DisableWantedLevel doit être sur false pour que onoma_blacklist fonctionne pleinement !
Config.EnableWantedLevel	= true
Config.WantedLevelMax		= 3  -- niveau de recherche maximum que les autorité atteindrons / correspond au nombre d'étoile, actif seulement si Config.EnableWantedLevel = true
```


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