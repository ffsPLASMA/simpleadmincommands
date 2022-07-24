function Split(s, delimiter)
	local result = {}
	
	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match)
	end
	
	return result
end

function getPlayerFromNamePart(strName)
	if(strName) then
		for _, player in pairs(Player.GetPairs()) do
			if(string.find(string.lower(player:GetName()), string.lower(strName), 1, true)) then
				return player
			end
		end
	end
	
	return false
end

function CommandPrint(color, player, prefix_text, text)
	if player then
		Server.SendChatMessage(player, "<" .. color .. ">" .. prefix_text .. "</> " .. text)
	else
		Package.Log(prefix_text .. " " .. text)
	end
end

function CommandRedPrint(player, prefix_text, text)
	CommandPrint("red", player, prefix_text, text)
end

function CommandGreenPrint(player, prefix_text, text)
	CommandPrint("green", player, prefix_text, text)
end

function CommandInstigatorName(player)
	if player then
		return player:GetName()
	else
		return "Console"
	end
end