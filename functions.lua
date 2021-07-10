--#######################################################################
-- Fonctions [Niveaux de recherche]

-- # Recherché par les autorités niveau 1
function wanted()
	local playerId = PlayerId()
	local wantedLevel = 1
	if GetPlayerWantedLevel(playerId) == 0 then
		SetPlayerWantedLevel(playerId, wantedLevel, false)
		SetPlayerWantedLevelNow(playerId, true)
		Wait(500)
		ESX.ShowNotification('Les autoritées ~r~te recherche !~w~')
	end
end
-- # Recherché par les autorités niveau 2
function mediumWanted()
	local playerId = PlayerId()
	local wantedLevel = 2
	if GetPlayerWantedLevel(playerId) >= 0 then
		SetPlayerWantedLevel(playerId, wantedLevel, false)
		SetPlayerWantedLevelNow(playerId, true)
		Wait(500)
		ESX.ShowNotification('Les autoritées ~r~te recherche !~w~')
	end
end
-- # Recherché par les autorités niveau 3
function maxWanted()
	local playerId = PlayerId()
	local wantedLevel = 3
	if GetPlayerWantedLevel(playerId) >= 0 then
		SetPlayerWantedLevel(playerId, wantedLevel, false)
		SetPlayerWantedLevelNow(playerId, true)
		Wait(500)
		ESX.ShowNotification('Les autoritées ~r~te recherche activement !~w~')
	end
end
-- # Fin de la recherche par les autorités
function endWanted()
	local playerId = PlayerId()
	local wantedLevel = 0
	if GetPlayerWantedLevel(playerId) ~= 0 then
		SetPlayerWantedLevel(playerId, wantedLevel, false)
		SetPlayerWantedLevelNow(playerId, true)
		Wait(500)
		ESX.ShowNotification('Les autoritées ont stoppé ta recherche !')
	end
end

--#######################################################################
-- Fonctions [Vehicules]

-- # Active l'alarme du vehicule dans lequel le joueur essai d'entrer
function alarm()
	local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
    Wait(1000)
	SetVehicleAlarmTimeLeft(veh, 8000)
end

-- # Vérrouille le vehicule dans lequel le joueur essai d'entrer
function locked()
	local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
	SetVehicleDoorsLockedForAllPlayers(veh, true)
end

-- # Déverrouille le vehicule dans lequel le joueur essai d'entrer
function unlocked()
	local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
	SetVehicleDoorsLockedForAllPlayers(veh, false)
end