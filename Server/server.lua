Server.Subscribe("Console", function(text)
	local strCommand 			= string.lower(text);
	local iFirstSpaceSeperator 	= string.find(strCommand, " ");
	
	if(iFirstSpaceSeperator) then
		strCommand = string.sub(strCommand, 0, iFirstSpaceSeperator - 1);
	end
	
	if(strCommand == "adminhelp") then
		Package.Log("\nslap [name] [reason]\nmute [name] [reason]\nunmute [name/SteamID]\nkick [name] [reason]\nban [name] [reason]");
	elseif(strCommand == "slap") then
		serverExecuteSlap(text);
	elseif(strCommand == "mute") then
		serverExecuteMute(text);
	elseif(strCommand == "unmute") then
		serverExecuteUnmute(text);
	elseif(strCommand == "kick") then
		serverExecuteKick(text);
	elseif(strCommand == "ban") then
		serverExecuteBan(text);
	end
end)

function serverExecuteSlap(strInputText)
	local tblSplitInput = Split(strInputText, " ");
		
	if(not tblSplitInput[2] or not tblSplitInput[3]) then return Package.Log("[ERROR] Syntax: slap [name] [reason]") end;
	
	local victim = getPlayerFromNamePart(tblSplitInput[2]);
	
	if(not victim) then return Package.Log("[ERROR] Player "..tblSplitInput[2].." not found!") end;
	
	local iReasonSpaceSeperator = string.find(strInputText, " ", (#tblSplitInput[1] + #tblSplitInput[2]));
	local strReason 			= string.sub(strInputText, iReasonSpaceSeperator + 1);
	local victimCharacter 		= victim:GetControlledCharacter();
	
	if(victimCharacter) then
		Server.BroadcastChatMessage("<red>[Admin] "..victim:GetName().." has been slapped by Console! ("..strReason..")</>");
		Package.Log("[Admin] "..victim:GetName().." has been slapped!");
		victimCharacter:SetHealth(0);
	else
		Server.SendChatMessage("[ERROR] Player "..tblSplitInput[2].." has no valid character to slap!");
	end
end

function serverExecuteMute(strInputText)
	local tblSplitInput = Split(strInputText, " ");
		
	if(not tblSplitInput[2] or not tblSplitInput[3]) then return Package.Log("[ERROR] Syntax: mute [name] [reason]") end;
	
	local victim = getPlayerFromNamePart(tblSplitInput[2]);
	
	if(not victim) then return Package.Log("[ERROR] Player "..tblSplitInput[2].." not found!") end;
	
	local iReasonSpaceSeperator = string.find(strInputText, " ", (#tblSplitInput[1] + #tblSplitInput[2]));
	local strReason 			= string.sub(strInputText, iReasonSpaceSeperator + 1);
	local strVictimSteamID 		= victim:GetSteamID();
	
	Server.BroadcastChatMessage("<red>[Admin] "..victim:GetName().." has been muted by Console! ("..strReason..")</>");
	Package.Log("[Admin] "..victim:GetName().." has been muted!");
	tblMutedPlayers[strVictimSteamID] = true;
end

function serverExecuteUnmute(strInputText)
	local tblSplitInput = Split(strInputText, " ");
	
	if(not tblSplitInput[2]) then return Package.Log("[ERROR] Syntax: unmute [name/steamID]") end;
	
	local victim = getPlayerFromNamePart(tblSplitInput[2]);
	
	if(victim) then
		local strVictimSteamID = victim:GetSteamID();
		
		if(tblMutedPlayers[strVictimSteamID]) then
			tblMutedPlayers[strVictimSteamID] = nil;
			Server.BroadcastChatMessage("<green>[Admin] "..victim:GetName().." has been unmuted by Console!</>");
			Package.Log("[Admin] "..victim:GetName().." has been unmuted!");
		else
			Package.Log("[ERROR] Player "..victim:GetName().." is not muted!");
		end
	else
		if(tblMutedPlayers[tblSplitInput[2]]) then
			tblMutedPlayers[tblSplitInput[2]] = nil;
			Package.Log("[Admin] Steam ID "..tblSplitInput[2].." has been unmuted!");
		else
			Package.Log("[ERROR] No mutes found for "..tblSplitInput[2].."!");
		end
	end
end

function serverExecuteKick(strInputText)
	local tblSplitInput = Split(strInputText, " ");
		
	if(not tblSplitInput[2] or not tblSplitInput[3]) then return Package.Log("[ERROR] Syntax: kick [name] [reason]") end;
	
	local victim = getPlayerFromNamePart(tblSplitInput[2]);
	
	if(not victim) then return Package.Log("[ERROR] Player "..tblSplitInput[2].." not found!") end;
	
	local iReasonSpaceSeperator = string.find(strInputText, " ", (#tblSplitInput[1] + #tblSplitInput[2]));
	local strReason 			= string.sub(strInputText, iReasonSpaceSeperator + 1);
	
	Server.BroadcastChatMessage("<red>[Admin] "..victim:GetName().." has been kicked by Console! ("..strReason..")</>");
	Package.Log("[Admin] "..victim:GetName().." has been kicked!");
	victim:Kick("You have been kicked by Console - Reason: "..strReason);
end

function serverExecuteBan(strInputText)
	local tblSplitInput = Split(strInputText, " ");
		
	if(not tblSplitInput[2] or not tblSplitInput[3]) then return Package.Log("[ERROR] Syntax: ban [name] [reason]") end;
	
	local victim = getPlayerFromNamePart(tblSplitInput[2]);
	
	if(not victim) then return Package.Log("[ERROR] Player "..tblSplitInput[2].." not found!") end;
	
	local iReasonSpaceSeperator = string.find(strInputText, " ", (#tblSplitInput[1] + #tblSplitInput[2]));
	local strReason 			= string.sub(strInputText, iReasonSpaceSeperator + 1);
	
	Server.BroadcastChatMessage("<red>[Admin] "..victim:GetName().." has been banned by Console! ("..strReason..")</>");
	Package.Log("[Admin] "..victim:GetName().." has been banned!");
	victim:Ban("You have been banned by Console - Reason: "..strReason);
end