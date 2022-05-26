-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local userList = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local tempList = {}
		for k,v in pairs(userList) do
			local ped = GetPlayerPed(k)
			if DoesEntityExist(ped) then
				tempList[k] = { GetEntityCoords(ped),v[1],v[2] }
			end
		end

		for k,v in pairs(userList) do
			async(function()
				if v[1] ~= "Prisioneiro" and v[1] ~= "Corredor" then
					TriggerClientEvent("blipsystem:updateBlips",k,tempList)
				end
			end)
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:SERVICEENTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("blipsystem:serviceEnter")
AddEventHandler("blipsystem:serviceEnter",function(source,service,color)
	if userList[source] == nil then
		userList[source] = { service,color }
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:SERVICEEXIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("blipsystem:serviceExit")
AddEventHandler("blipsystem:serviceExit",function(source)
	TriggerClientEvent("blipsystem:cleanBlips",source)
	serviceExit(source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDisconnect",function(user_id,source)
	serviceExit(source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICEEXIT
-----------------------------------------------------------------------------------------------------------------------------------------
function serviceExit(source)
	if userList[source] then
		userList[source] = nil

		for k,v in pairs(userList) do
			async(function()
				TriggerClientEvent("blipsystem:removeBlips",k,source)
			end)
		end
	end
end