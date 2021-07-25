ESX = nil TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--#######################################################################
-- Fonctions [Niveaux de recherche]

function setWanted(wantedLevel)
	local playerId = PlayerId()
	SetPlayerWantedLevel(playerId, wantedLevel, false)
	SetPlayerWantedLevelNow(playerId, true)

	if wantedLevel == 1 then
		ESX.ShowAdvancedNotification("Anonyme", ("%s"):format(playerName), "Qu'est-ce que t'as foutu ?! \nLa LSPD te recherche maintenant !", "CHAR_LESTER", 1) -- ESX.ShowNotification('Les autoritées ~r~te recherche !~w~')
	elseif wantedLevel == 2 then
		ESX.ShowAdvancedNotification("Anonyme", ("%s"):format(playerName), "Qu'est-ce que t'as encore foutu ?! \nLa LSPD te recherche bordel !", "CHAR_LESTER", 1)
	elseif wantedLevel == 3 then
		-- ESX.ShowAdvancedNotification("Anonyme", ("%s"):format(playerName), "Là t'es dans la merde !\nBarre toi et trouve une planque.", "CHAR_LESTER", 1)
	elseif wantedLevel == 0 then
		ESX.ShowAdvancedNotification("Anonyme", ("%s"):format(playerName), "Ok, t'es tranquille maintenant.\nMais ne touche plus aux véhicules de flics !", "CHAR_LESTER", 1)
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
