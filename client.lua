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

-- ###################################################
-- pour le dev // -- #################################

Citizen.CreateThread(function()
    while true do
		if IsControlPressed(1, 47) then -- G -> revive (F1 -> F* désactiver lorsque mort par esx_ambulancejob donc sur G)
			TriggerEvent('esx_ambulancejob:revive')
			ESX.ShowNotification('~g~Réssucité~w~')
		end
		if IsControlPressed(1, 288) then -- F1 -> test function
			wanted()
			ESX.ShowNotification('~o~wanted()~w~')
		end
		if IsControlPressed(1, 170) then -- F3 -> test function
			endWanted()
			ESX.ShowNotification('~o~endWanted()~w~')
		end
        Citizen.Wait(0)	    							
    end
end)

-- ###################################################
-- ###################################################

Citizen.CreateThread(function()
    while true do
		-- si le joueur essai de rentrer dans le véhicule
        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then
			-- récupère le véhicule dans lequel le joueur essaie d'entrer et son statut de verrouillage.
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
            local lock = GetVehicleDoorLockStatus(veh)
			-- recupère Config.blacklist et passe les vehicules en blacklisted = true
			local backlisted = false
			for k,v in pairs(Config.blacklist) do
			  	if IsVehicleModel(veh, GetHashKey(v)) then
			  	  	blacklisted = true
					-- SetVehicleIsWanted(veh, true)
			  	end
			end
			-- -- recupère Config.police et passe les vehicules en policeveh = true
			local policeveh = false
			for k,v in pairs(Config.police) do
			  	if IsVehicleModel(veh, GetHashKey(v)) then
					policeveh = true
			  	end
			end	
			-- récupere le ped au volant
			local ped = GetPedInVehicleSeat(veh, -1)
			local plate = GetVehicleNumberPlateText(veh)
			local playerId = PlayerId()
			local job_name = ESX.PlayerData.job.name
			-- si blacklisté -> vehicule vérrouiller -> joueur recherché par les autorités -> niveau de recherche : 3
			if blacklisted then
				locked()
				Wait(500)
				ESX.ShowNotification('Vehicule ~r~interdit !~w~')
				maxWanted()
			end
			-- si vehicule accesible ou avec un ped dedans
            if (lock == 7 or ped) then
				-- si vehicule de police
				if policeveh then
					-- si le joueur a le job Config.policejob -> vhicule de police accessible
					if job_name == Config.policeJob then
						unlocked()
					-- sinon, vehicule vérrouiller -> déclenchement de l'alarme -> joueur recherché par les autorités -> niveau de recherche : 1
					else
						locked()
						alarm()
						wanted()
					end
				end
			-- sinon vehicule vérrouiller
			else
				locked()
				ESX.ShowNotification('~b~Pas de chance !~w~')
            end
		end
        Citizen.Wait(0)	    							
    end
end)