function Split(s, delimiter)
	local result = {};
	
	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match);
	end
	
	return result;
end

function getPlayerFromNamePart(strName)
	if(strName) then
		for _, player in pairs(Player.GetPairs()) do
			if(string.find(string.lower(player:GetName()), string.lower(strName), 1, true)) then
				return player;
			end
		end
	end
	
	return false;
end