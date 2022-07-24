-- admin -> permissions.lua file
-- used to define players with privileges and execution levels for commands

-- tier 3 group
local tblAdmins = {
	["76561198029211743"] = true,	--PLASMA
};

-- tier 2 group
local tblSuperModerators = {

};

-- tier 1 group
local tblModerators = {

};

-- define commands and permission level to execute
local tblCommandPermissions = {
	["slap"] 	= "Moderator",
	["mute"] 	= "Moderator",
	["unmute"] 	= "Moderator",
	["goto"] 	= "SuperModerator",
	["bring"] 	= "SuperModerator",
	["tp"] 		= "SuperModerator",
	["kick"] 	= "SuperModerator",
	["ban"] 	= "Admin",
};

-- permission check
function checkPermissionToExecute(player, strAction)
	if(not player:IsValid()) then return false end;
	if(not strAction or #strAction == 0) then return false end;
	
	if(tblCommandPermissions[strAction]) then
		local strPlayerSteamID = player:GetSteamID();
		
		if(tblCommandPermissions[strAction] == "Moderator") then
			if(tblAdmins[strPlayerSteamID] or tblSuperModerators[strPlayerSteamID] or tblModerators[strPlayerSteamID]) then
				return true;
			else
				return false;
			end
		elseif(tblCommandPermissions[strAction] == "SuperModerator") then
			if(tblAdmins[strPlayerSteamID] or tblSuperModerators[strPlayerSteamID]) then
				return true;
			else
				return false;
			end
		elseif(tblCommandPermissions[strAction] == "Admin") then
			if(tblAdmins[strPlayerSteamID]) then
				return true;
			else
				return false;
			end
		end
	else
		Package.Log("[Admin] Action "..strAction.." not found in tblCommandPermissions table!");
		return false;
	end
end