print("^0~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7")
print("^0[^4Author^0] ^7:^0 ^5TusbluX^7")	
print("^0[^3Version^0] ^7:^0 ^01.0.0^7")
print("^0[^2Download^0] ^7:^0 ^5https://github.com/blettos ^7")
print("^0[^1Resource name^0] ^7:^0 ^7Onoma_blacklist^7")
print("^0[^6Description^0] ^7:^0 ^7Blacklist de certains vehicules terrestre, aquatique et aerien).^7")
print("^0[^6Description^0] ^7:^0 ^7+ Systeme de vérouillage et d'alarme des vehicule de Police pour tous sauf policejob.^7")
print("^0[^6Future^0] ^7:^0 ^7Créer une relation amical entre joueur lspd et ped.^7")
print("^0~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7")

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	  Citizen.Wait(0)
	end
end)
