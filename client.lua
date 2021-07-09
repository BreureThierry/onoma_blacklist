ESX = nil


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	RegisterNetEvent('esx:setJob')
	AddEventHandler('esx:setJob', function(job)
		ESX.PlayerData.job = job
	end)

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

end)

-- ###################################################################################
-- dev -> pour les tests
Citizen.CreateThread(function()
    while true do
		if IsControlPressed(1, 47) then -- G -> revive
			TriggerEvent('esx_ambulancejob:revive')
			ESX.ShowNotification('~b~Ressucité !~w~')
		end
		if IsControlPressed(1, 288) then -- F1 -> ne plus être rechercher par les autorités
			endWanted()
		end
        Citizen.Wait(0)	    							
    end
end)
-- ###################################################################################

Citizen.CreateThread(function()
    while true do
		local wantedLevel = GetPlayerWantedLevel(playerId)
		local WantedLevelThreshold = GetWantedLevelThreshold(wantedLevel)

		-- si le joueur essai de rentrer dans le véhicule
        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then
			
			-- récupère le véhicule dans lequel le joueur essaie d'entrer et son statut de verrouillage.
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
            local lock = GetVehicleDoorLockStatus(veh)

			-- check si le vehicule est blacklist
			local backlisted = false
			for k,v in pairs(Config.blacklist) do
			  	if IsVehicleModel(veh, GetHashKey(v)) then
			  	  blacklisted = true
			  	end
			end

			-- check si le vehicule est police
			local police = false
			for k,v in pairs(Config.police) do
			  	if IsVehicleModel(veh, GetHashKey(v)) then
					police = true
			  	end
			end

			-- récupere les ped dans
			for _, p in pairs(Config.PolicePeds) do
				RequestModel(GetHashKey(p))
				while not HasModelLoaded(GetHashKey(p)) do
					Wait(1)
				end
			end
			-- a suprimer pour test l'opti
			Citizen.Wait(0)
		
			-- récupere le ped au volant
			local ped = GetPedInVehicleSeat(veh, -1)
			local plate = GetVehicleNumberPlateText(veh)
			local playerId = PlayerId()
			local job_name = ESX.PlayerData.job.name
			-- si vehicule accesible ou avec un ped dedans
            if (lock == 7 or ped) then
				-- si job police-> déclenche l'alarme -> wanted par la police
				if police then
					-- si police-> vhicule de police accessible sans probleme
					if job_name == Config.policejob then
						unlocked()
						-- sinon, vehicule vérrouiller -> alarme -> joueur recherché par les autorités 1minute
					else
						local wantedLevel = GetPlayerWantedLevel(playerId)
						local WantedLevelThreshold = GetWantedLevelThreshold(wantedLevel)
						local maxWantedLevel = GetMaxWantedLevel(5)
						locked()
						Wait(1000)
						alarm()
						wanted()
					end
				end
			else
				locked()
				wanted()
				ESX.ShowNotification('~b~Pas de chance !~w~')
            end
			-- si blacklisté -> vehicule vérrouiller -> joueur recherché par les autorités
			if blacklisted then
				local wantedLevel = GetPlayerWantedLevel(playerId)
				local WantedLevelThreshold = GetWantedLevelThreshold(wantedLevel)
				local maxWantedLevel = GetMaxWantedLevel(5)
				locked()
				ESX.ShowNotification('~r~Vehicule interdit !~w~')
				Wait(3000)
				wantedLevelMax()
			end
		end
        Citizen.Wait(0)	    							
    end
end)

--#################################################################################################
-- Fonctions [Niveau de recherche minimum - Niveau de recherche maximum - Niveau de recherche zéro]

function wanted()
	local playerId = PlayerId()
	local maxWantedLevel = GetMaxWantedLevel(SetMaxWantedLevel(1))
	if GetPlayerWantedLevel(playerId) == 0 then
		SetPoliceIgnorePlayer(playerId, false)
		SetMaxWantedLevel(maxWantedLevel)
		SetPlayerWantedLevel(playerId, maxWantedLevel, false)
		SetPlayerWantedLevelNow(playerId, true)
		ReportCrime(playerId, "MDV", maxWantedLevel)
		ESX.ShowNotification('~r~Les autoritées~w~ te recherche !~w~')
		Wait(25000)
		SetPlayerWantedLevel(playerId, 0, false)
		SetPlayerWantedLevelNow(playerId, true)
		Wait(500)
		ESX.ShowNotification('~b~Les autoritées~w~ ne te recherche plus~w~')
	end
end

function wantedLevelMax()
	local playerId = PlayerId()
	local maxWantedLevel = GetMaxWantedLevel(SetMaxWantedLevel(3))
	if GetPlayerWantedLevel(playerId) == 0 then
		SetPoliceIgnorePlayer(playerId, false)
		SetMaxWantedLevel(maxWantedLevel)
		SetPlayerWantedLevel(playerId, maxWantedLevel, false)
		SetPlayerWantedLevelNow(playerId, true)
		ReportCrime(playerId, "MDV", maxWantedLevel)
		ESX.ShowNotification("T'es ~r~Wanted~w~ barre toi vite !")
		Wait(70000)
		SetPlayerWantedLevel(playerId, 0, false)
		SetPlayerWantedLevelNow(playerId, true)
		Wait(500)
		ESX.ShowNotification('~b~Tu as eu chaud au cul !~w~ ne recommence plus ça~w~')
	end
end

function endWanted()
	local playerId = PlayerId()
	local maxWantedLevel = GetMaxWantedLevel(SetMaxWantedLevel(0))
	if GetPlayerWantedLevel(playerId) ~= 0 then
		SetPoliceIgnorePlayer(playerId, true)
		SetPlayerWantedLevel(playerId, 0, false)
		SetPlayerWantedLevelNow(playerId, true)
		Wait(500)
		ESX.ShowNotification('~b~Les autoritées~w~ ne te recherche plus~w~')
	end
end

--#######################################################################
-- Fonctions [Alarme - Véhicules vérrouillées - Véhicules dévérrouillées]

function alarm()
	local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
	SetVehicleAlarmTimeLeft(veh, 8000)
end

function locked()
	local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
	SetVehicleDoorsLockedForAllPlayers(veh, true)
end

function unlocked()
	local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
	SetVehicleDoorsLockedForAllPlayers(veh, false)
end