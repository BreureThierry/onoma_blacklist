ESX = nil
playerName = nil

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

	while not playerName do
		ESX.TriggerServerCallback("onm_blacklist:getPlayerName", function(obj)
			playerName = obj
		end)

		Citizen.Wait(0)
	end

	ESX.PlayerData = ESX.GetPlayerData()


end)

-- ###################################################
-- pour le dev // -- #################################

Citizen.CreateThread(function()
    while true do
		if IsControlPressed(1, 47) then -- G -> revive (F1 -> F* désactiver lorsque mort par esx_ambulancejob donc sur G)
			TriggerEvent('esx_ambulancejob:revive')
		end
		-- if IsControlPressed(1, 288) then -- F1 -> test function
		-- 	setWanted(1)
		-- end
		if IsControlPressed(1, 170) then -- F3 -> test function
			setWanted(0)
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
			local blacklisted = false
			for k,v in pairs(Config.blacklist) do
			  	if IsVehicleModel(veh, GetHashKey(v)) then
			  	  	blacklisted = true
			  	end	
			end
			-- -- recupère Config.police et passe les vehicules en policeveh = true
			local policeveh = false
			for k,v in pairs(Config.police) do
			  	if IsVehicleModel(veh, GetHashKey(v)) then
					policeveh = true
			  	end
			end	
			-- -- recupère Config.bateau et passe les vehicules en bateau = true
			local bateau = false
			for k,v in pairs(Config.bateau) do
			  	if IsVehicleModel(veh, GetHashKey(v)) then
					bateau = true
			  	end
			end
			-- -- recupère Config.avion et passe les vehicules en avion = true
			local avion = false
			for k,v in pairs(Config.avion) do
			  	if IsVehicleModel(veh, GetHashKey(v)) then
					avion = true
			  	end
			end	

			-- récupere le ped au volant
			local ped = GetPedInVehicleSeat(veh, -1)
			local plate = GetVehicleNumberPlateText(veh)
			local job_name = ESX.PlayerData.job.name or ESX.PlayerData.job2.name
			-- print(("Véhicule = %s | Ped = %s | Lock status = %s | Blacklisted = %s | PoliceVeh = %s"):format(veh, ped, lock, blacklisted, policeveh))
			-- si blacklisté -> vehicule vérrouiller -> joueur recherché par les autorités -> niveau de recherche : 3
			if blacklisted then
				locked()
				Wait(500)
				ESX.ShowAdvancedNotification("~r~Onoma~s~", "~r~Restriction~s~", ("Ce véhicule est ~r~interdit~s~ !\n%s ne recommencez plus."):format(playerName), "CHAR_BLOCKED", 1)
				setWanted(3)
			else
				unlocked()
			end
			if bateau then
				locked()
				Wait(500)
				ESX.ShowAdvancedNotification("~y~Onoma~s~", "~r~Restriction~s~", ("Ce bateau n'est pas ~r~autorisé~s~ !\n%s pensez à vous rendre à l'agence de location de bateau pour en louer un."):format(playerName), "CHAR_BOATSITE", 1)
			else
				unlocked()
			end
			if avion then
				locked()
				Wait(500)
				ESX.ShowAdvancedNotification("~y~Onoma~s~", "~y~Aviation~s~", "Ce vehicule n'est pas autorisé aux civils.", "CHAR_BOATSITE2", 1)
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
						setWanted(1)
						Wait(math.random(10000, 25000)) 
						setWanted(0)
					end
				end
			-- sinon vehicule vérrouiller
			else
				locked()
				ESX.ShowAdvancedNotification("~r~Blacklist~s~", "Restriction", "Pas de chance ce véhicule est ~r~vérrouiller~s~ !", "CHAR_BLOCKED", 1)
            end
		end
        Citizen.Wait(0)	    							
    end
end)


