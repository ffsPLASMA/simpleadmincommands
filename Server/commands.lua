-- Not persistent, store muted players here!
tblMutedPlayers = {};

-- chat to command function translation
local tblCommandsToFunctionsTranslation = {
	["slap"] 	= "commandSlap",
	["mute"] 	= "commandMute",
	["unmute"] 	= "commandUnmute",
	["goto"] 	= "commandGoto",
	["bring"] 	= "commandBring",
	["tp"] 		= "commandTeleport",
	["kick"] 	= "commandKick",
	["ban"] 	= "commandBan",
};

-- Intercept chat messages and filter out commands
Server.Subscribe("Chat", function(text, sender)
	if(not sender:IsValid()) then return false end;
	if(#text == 0) then return false end;
	
	if(string.find(text, "/") == 1) then
		text = string.lower(text);
	
		local strCommand 			= string.sub(text, 2);
		local iFirstSpaceSeperator 	= string.find(strCommand, " ");
		
		if(iFirstSpaceSeperator) then
			strCommand = string.sub(strCommand, 0, iFirstSpaceSeperator - 1);
		end
		
		if(tblCommandsToFunctionsTranslation[strCommand]) then
			_G[tblCommandsToFunctionsTranslation[strCommand]](sender, strCommand, text);
		else
			Server.SendChatMessage(sender, "<red>[ERROR]</> Command "..strCommand.." not found!");
		end
		
		return false;
	end
	
	local senderSteamID = sender:GetSteamID();
	
	if(tblMutedPlayers[senderSteamID]) then
		Server.SendChatMessage(sender, "<red>[ERROR]</> You are muted!");
		return false;
	end
end)

function commandSlap(player, strCommand, strInput)
	if(checkPermissionToExecute(player, strCommand)) then
		local tblSplitInput = Split(strInput, " ");
		
		if(not tblSplitInput[2] or not tblSplitInput[3]) then return Server.SendChatMessage(player, "<red>[ERROR]</> Syntax: /slap [name] [reason]") end;
		
		local victim = getPlayerFromNamePart(tblSplitInput[2]);
		
		if(not victim) then return Server.SendChatMessage(player, "<red>[ERROR]</> Player "..tblSplitInput[2].." not found!") end;
		
		local iReasonSpaceSeperator = string.find(strInput, " ", (#tblSplitInput[1] + #tblSplitInput[2]));
		local strReason 			= string.sub(strInput, iReasonSpaceSeperator + 1);
		local victimCharacter 		= victim:GetControlledCharacter();
		
		if(victimCharacter) then
			Server.BroadcastChatMessage("<red>[Admin] "..victim:GetName().." has been slapped by "..player:GetName().."! ("..strReason..")</>");
			victimCharacter:SetHealth(0);
		else
			Server.SendChatMessage(player, "<red>[ERROR]</> Player "..tblSplitInput[2].." has no valid character to slap!");
		end
	else
		Server.SendChatMessage(player, "<red>[ERROR] You don't have permission to do so!</>");
	end
end

function commandMute(player, strCommand, strInput)
	if(checkPermissionToExecute(player, strCommand)) then
		local tblSplitInput = Split(strInput, " ");
		
		if(not tblSplitInput[2] or not tblSplitInput[3]) then return Server.SendChatMessage(player, "<red>[ERROR]</> Syntax: /mute [name] [reason]") end;
		
		local victim = getPlayerFromNamePart(tblSplitInput[2]);
		
		if(not victim) then return Server.SendChatMessage(player, "<red>[ERROR]</> Player "..tblSplitInput[2].." not found!") end;
		
		local iReasonSpaceSeperator = string.find(strInput, " ", (#tblSplitInput[1] + #tblSplitInput[2]));
		local strReason 			= string.sub(strInput, iReasonSpaceSeperator + 1);
		local strVictimSteamID 		= victim:GetSteamID();
		
		Server.BroadcastChatMessage("<red>[Admin] "..victim:GetName().." has been muted by "..player:GetName().."! ("..strReason..")</>");
		tblMutedPlayers[strVictimSteamID] = true;
	else
		Server.SendChatMessage(player, "<red>[ERROR] You don't have permission to do so!</>");
	end
end

function commandUnmute(player, strCommand, strInput)
	if(checkPermissionToExecute(player, strCommand)) then
		local tblSplitInput = Split(strInput, " ");
		
		if(not tblSplitInput[2]) then return Server.SendChatMessage(player, "<red>[ERROR]</> Syntax: /unmute [name/steamID]") end;
		
		local victim = getPlayerFromNamePart(tblSplitInput[2]);
		
		if(victim) then
			local strVictimSteamID = victim:GetSteamID();
			
			if(tblMutedPlayers[strVictimSteamID]) then
				tblMutedPlayers[strVictimSteamID] = nil;
				Server.BroadcastChatMessage("<green>[Admin] "..victim:GetName().." has been unmuted by "..player:GetName().."!</>");
			else
				Server.SendChatMessage(player, "<red>[ERROR]</> Player "..victim:GetName().." is not muted!");
			end
		else
			if(tblMutedPlayers[tblSplitInput[2]]) then
				tblMutedPlayers[tblSplitInput[2]] = nil;
				Server.SendChatMessage(player, "<green>[Admin]</> Steam ID "..tblSplitInput[2].." has been unmuted!");
			else
				Server.SendChatMessage(player, "<red>[ERROR]</> No mutes found for "..tblSplitInput[2].."!");
			end
		end
	else
		Server.SendChatMessage(player, "<red>[ERROR] You don't have permission to do so!</>");
	end
end

function commandGoto(player, strCommand, strInput)
	if(checkPermissionToExecute(player, strCommand)) then
		local tblSplitInput = Split(strInput, " ");
		
		if(not tblSplitInput[2] or not tblSplitInput[3]) then return Server.SendChatMessage(player, "<red>[ERROR]</> Syntax: /goto [name]") end;
		
		local victim = getPlayerFromNamePart(tblSplitInput[2]);
		
		if(not victim) then return Server.SendChatMessage(player, "<red>[ERROR]</> Player "..tblSplitInput[2].." not found!") end;
		
		player:SetLocation(victim:GetLocation());
		Server.SendChatMessage(player, "<red>[Admin]</> Goto player "..tblSplitInput[2].." successful!");
	else
		Server.SendChatMessage(player, "<red>[ERROR] You don't have permission to do so!</>");
	end
end

function commandBring(player, strCommand, strInput)
	if(checkPermissionToExecute(player, strCommand)) then
		local tblSplitInput = Split(strInput, " ");
		
		if(not tblSplitInput[2] or not tblSplitInput[3]) then return Server.SendChatMessage(player, "<red>[ERROR]</> Syntax: /bring [name]") end;
		
		local victim = getPlayerFromNamePart(tblSplitInput[2]);
		
		if(not victim) then return Server.SendChatMessage(player, "<red>[ERROR]</> Player "..tblSplitInput[2].." not found!") end;
		
		victim:SetLocation(player:GetLocation());
		Server.SendChatMessage(player, "<red>[Admin]</> Brought player "..tblSplitInput[2].." to you!");
	else
		Server.SendChatMessage(player, "<red>[ERROR] You don't have permission to do so!</>");
	end
end

function commandTeleport(player, strCommand, strInput)
	if(checkPermissionToExecute(player, strCommand)) then
		local tblSplitInput = Split(strInput, " ");
		
		if(not tblSplitInput[2] or not tblSplitInput[3]) then return Server.SendChatMessage(player, "<red>[ERROR]</> Syntax: /tp [sourceName] [destinationName]") end;
		
		local source = getPlayerFromNamePart(tblSplitInput[2]);
		
		if(not source) then return Server.SendChatMessage(player, "<red>[ERROR]</> Source player "..tblSplitInput[2].." not found!") end;
		
		local iReasonSpaceSeperator = string.find(strInput, " ", (#tblSplitInput[1] + #tblSplitInput[2]));
		local strDestinationPlayer 	= string.sub(strInput, iReasonSpaceSeperator + 1);
		local destination 			= getPlayerFromNamePart(strDestinationPlayer);
		
		if(not destination) then return Server.SendChatMessage(player, "<red>[ERROR]</> Destination player "..strDestinationPlayer.." not found!") end;
		
		source:SetLocation(destination:GetLocation());
		Server.SendChatMessage(player, "<red>[Admin]</> Teleported "..tblSplitInput[2].." to "..strDestinationPlayer.."!");
	else
		Server.SendChatMessage(player, "<red>[ERROR] You don't have permission to do so!</>");
	end
end

function commandKick(player, strCommand, strInput)
	if(checkPermissionToExecute(player, strCommand)) then
		local tblSplitInput = Split(strInput, " ");
		
		if(not tblSplitInput[2] or not tblSplitInput[3]) then return Server.SendChatMessage(player, "<red>[ERROR]</> Syntax: /kick [name] [reason]") end;
		
		local victim = getPlayerFromNamePart(tblSplitInput[2]);
		
		if(not victim) then return Server.SendChatMessage(player, "<red>[ERROR]</> Player "..tblSplitInput[2].." not found!") end;
		
		local iReasonSpaceSeperator = string.find(strInput, " ", (#tblSplitInput[1] + #tblSplitInput[2]));
		local strReason 			= string.sub(strInput, iReasonSpaceSeperator + 1);
		
		Server.BroadcastChatMessage("<red>[Admin] "..victim:GetName().." has been kicked by "..player:GetName().."! ("..strReason..")</>");
		victim:Kick("You have been kicked by "..player:GetName().." - Reason: "..strReason);
	else
		Server.SendChatMessage(player, "<red>[ERROR] You don't have permission to do so!</>");
	end
end

function commandBan(player, strCommand, strInput)
	if(checkPermissionToExecute(player, strCommand)) then
		local tblSplitInput = Split(strInput, " ");
		
		if(not tblSplitInput[2] or not tblSplitInput[3]) then return Server.SendChatMessage(player, "<red>[ERROR]</> Syntax: /ban [name] [reason]") end;
		
		local victim = getPlayerFromNamePart(tblSplitInput[2]);
		
		if(not victim) then return Server.SendChatMessage(player, "<red>[ERROR]</> Player "..tblSplitInput[2].." not found!") end;
		
		local iReasonSpaceSeperator = string.find(strInput, " ", (#tblSplitInput[1] + #tblSplitInput[2]));
		local strReason 			= string.sub(strInput, iReasonSpaceSeperator + 1);
		
		Server.BroadcastChatMessage("<red>[Admin] "..victim:GetName().." has been banned by "..player:GetName().."! ("..strReason..")</>");
		victim:Ban("You have been banned by "..player:GetName().." - Reason: "..strReason);
	else
		Server.SendChatMessage(player, "<red>[ERROR] You don't have permission to do so!</>");
	end
end