
local CLIENT = triggerServerEvent

if CLIENT then

	setTimer(function()
		local x,y,z = getElementPosition(getLocalPlayer())
		local zone, city = getZoneName(x,y,z), getZoneName(x,y,z, true)
		outputInfo(("Du befindest dich in %s (%s)"):format(zone, city))
	end, 1000, -1)

	outputInfo("Ich kann etwas clientseitig erreichen", "error")

	addEventHandler("onClientVehicleEnter", root, function()
		outputInfo("Du bist in ein "..getVehicleName(source).." eingestiegen!", "success")
	end)

	addEventHandler("onClientVehicleStartEnter", root, function()
		local tbl = {
			backgroundColor = tocolor(200,0,200),
			sound = 3
		}
		outputInfo("Sieh mich an, ich bin anders!", "own", tbl)
	end)

	addEventHandler("onClientVehicleExit", root, function()
		outputInfo("Du bist aus einem "..getVehicleName(source).." ausgestiegen!", "success")
	end)
else
	setTimer(function()
		outputInfo(getRootElement(), "Dies ist eine Nachricht vom Server", "warning")
	end, 200, 1)
end

