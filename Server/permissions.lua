

tblGroups = {
	User = { -- default group
		level = 1,
	},
	Moderator = {
		level = 2,
	},
	SuperModerator = {
		level = 3,
	},
	Admin = {
		level = 4,
	},
}

-- permission check
function checkPermissionToExecute(player, strAction)
	if(not player:IsValid()) then return false end
	if(not strAction or #strAction == 0) then return false end

	if(tblCommands[strAction]) then
		local strPlayerSteamID = player:GetSteamID()

		local currentPlayerGroupLevel = tblGroups["User"].level

		if tblPlayersGroup[strPlayerSteamID] then
			currentPlayerGroupLevel = tblGroups[tblPlayersGroup[strPlayerSteamID]].level
		end

		if(tblGroups[tblCommands[strAction].permission].level <= currentPlayerGroupLevel) then
			return true
		end
	end
end