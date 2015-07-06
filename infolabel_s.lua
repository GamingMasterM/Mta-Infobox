--//
--||  PROJECT:  MTA-Infobox
--||  AUTHOR:   MasterM
--||  DATE:     July 2015
--\\


--//
--||  outputInfo
--||  parameters:
--||    player 			= a player element, a table of player elements or getRootElement() to target a player who sees the info
--||    text 			= the text to output
--||    template 		= the used template
--||    templateArgs 	= template styling if the template is "own"
--||  returns: void
--\\

function outputInfo(player, text, template, args)
	triggerClientEvent(player, "onClientOutputInfo", resourceRoot, text, template, args)
end





