--//
--||  PROJECT:  MTA-Infobox
--||  AUTHOR:   MasterM
--||  DATE:     July 2015
--\\


-- variables
local lp = getLocalPlayer()
local scx,scy = guiGetScreenSize()
local textdiff = scx/1280

local infoTable = {} -- to store all our infos in

local timePerLetter = 50
local baseTime = 500 -- visible time for an empty message
local alpha = 255 -- alpha of the labels
local infoHeight = 0.02 -- relative height of one label
local infoFade = 0.002 -- relative fade to animate the infos


-- templates
local templateTable = {
	["error"] = {
		backgroundColor = tocolor(200,0,0,alpha),
		textColor = tocolor(255,255,255,255),
		sound = 5
	},
	["info"] = {
		backgroundColor = tocolor(0,0,0,alpha),
		textColor = tocolor(255,255,255,255),
		sound = 37
	},
	["warning"] = {
		backgroundColor = tocolor(200,150,0,alpha),
		textColor = tocolor(0,0,0,255),
		sound = 4
	},
	["success"] = {
		backgroundColor = tocolor(0,200,0,alpha),
		textColor = tocolor(0,0,0,255),
		sound = 41
	}
}


--//
--||  outputInfo
--||  parameters:
--||    text 			= the text to output
--||    template 		= the used template
--||    templateArgs 	= template styling if the template is "own"
--||  returns: void
--\\

function outputInfo(text, template, templateArgs)
if not template then template  = "info" end
local data = {
	text = text,
	startTime = getTickCount(),
	endTime = utfLen(text)*timePerLetter+baseTime,
	height = 0,
	state = "open"
}
	if template == "own" and type(templateArgs) == "table" then
		if templateArgs.sound then
			playSoundFrontEnd(templateArgs.sound)
		end
		data.backgroundColor = (templateArgs.backgroundColor or templateTable["info"].backgroundColor)
		data.textColor = templateArgs.textColor or templateTable["info"].textColor
	else
		if templateTable[template].sound then
			playSoundFrontEnd(templateTable[template].sound)
		end
		data.backgroundColor = (templateTable[template].backgroundColor or templateTable["info"].backgroundColor)
		data.textColor = templateTable[template].textColor or templateTable["info"].textColor
	end
	outputConsole("["..template.."] "..text)
	table.insert(infoTable, data)
end
addEvent("onClientOutputInfo", true)
addEventHandler("onClientOutputInfo", resourceRoot, outputInfo)


--//
--||  updateInfo
--||  parameters:
--||    index = the info's index in the infoTable
--||  returns: void
--\\

local function updateInfo(index)
	info = infoTable[index]
	local endTime = (info.startTime+info.endTime)*#infoTable
	if index == 1 then
		endTime = (info.startTime+info.endTime)
	end
	if getTickCount() > endTime then
		info.state = "close"
	end
	
	if info.state == "open" then
		if info.height < infoHeight then
			info.height = info.height+infoFade
		else
			info.height = infoHeight
			info.state = "ready"
		end
	elseif info.state == "close" then
		if info.height > infoFade then
			info.height = info.height-infoFade
		else
			info.height = infoHeight
			table.remove(infoTable, index)
		end
	end
end


--//
--||  renderInfo
--||  parameters:
--||    void
--||  returns: void
--\\

local function renderInfo()
	local absHeight  = 0 
	for index, info in ipairs(infoTable) do
		local boxStartX, boxStartY = scx/2-0.2*scx, absHeight*scy
		local boxWidth, boxHeight = 0.4*scx, info.height*scy -- relativ
		local boxEndX, boxEndY = boxStartX+boxWidth, boxStartY+boxHeight -- absolut
	
		dxDrawRectangle(boxStartX, boxStartY, boxWidth, boxHeight, info.backgroundColor)
		dxDrawText(info.text,boxStartX, boxStartY, boxEndX, boxEndY, info.textColor, (1/infoHeight*info.height)*textdiff, "default-bold", "center", "center")
		dxDrawLine(boxStartX, boxStartY-1, boxEndX, boxStartY-1, tocolor(255,255,255,255), 1)
		updateInfo(index)
		
		absHeight =  absHeight + info.height

	end
end
addEventHandler("onClientRender", root, renderInfo)
