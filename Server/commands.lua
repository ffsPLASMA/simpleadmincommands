
tblCommands = {
	slap = {
		permission = "Moderator",
		args = {
			"player",
			"reason",
		},
		func = function(player, args)
			local victimCharacter = args[1]:GetControlledCharacter()

			if victimCharacter then
				CommandRedPrint(player, "[Admin]", args[1]:GetName() .. " has been slapped by " .. CommandInstigatorName(player) .. "! (".. args[2] ..")")
				victimCharacter:SetHealth(0)
			else
				CommandRedPrint(player, "[ERROR]", "Player " .. args[1]:GetName() .. " has no valid character to slap!")
			end
		end
	},

	mute = {
		permission = "Moderator",
		args = {
			"player",
			"reason",
		},
		func = function(player, args)
			local strVictimSteamID = args[1]:GetSteamID()

			CommandRedPrint(player, "[Admin]", args[1]:GetName() .. " has been muted by " .. CommandInstigatorName(player) .. "! (" .. args[2] .. ")")
			tblMutedPlayers[strVictimSteamID] = true
		end
	},

	unmute = {
		permission = "Moderator",
		args = {
			"steamid/player",
		},
		func = function(player, args)
			local victim = getPlayerFromNamePart(args[1])

			if victim then
				local strVictimSteamID = victim:GetSteamID()

				if(tblMutedPlayers[strVictimSteamID]) then
					tblMutedPlayers[strVictimSteamID] = nil
					CommandGreenPrint(player, "[Admin]", victim:GetName() .. " has been unmuted by " .. CommandInstigatorName(player) .. "!")
				else
					CommandRedPrint(player, "[ERROR]", victim:GetName() .. " is not muted!")
				end
			else
				if(tblMutedPlayers[args[1]]) then
					tblMutedPlayers[args[1]] = nil
					CommandGreenPrint(player, "[Admin]", "Steam ID "..args[1].." has been unmuted!")
				else
					CommandRedPrint(player, "[ERROR]", "No mutes found for " .. args[1] .. "!")
				end
			end
		end
	},

	["goto"] = {
		permission = "SuperModerator",
		args = {
			"player",
		},
		func = function(player, args)
			if not player then
				CommandRedPrint(player, "[ERROR]", "You must be a player to use this command!")
				return false
			end

			if player == args[1] then
				CommandRedPrint(player, "[ERROR]", "You can't goto yourself!")
				return false
			end

			local victimCharacter = args[1]:GetControlledCharacter()

			if victimCharacter then
				local playerCharacter = player:GetControlledCharacter()
				if playerCharacter then
					playerCharacter:SetLocation(victimCharacter:GetLocation())

					CommandRedPrint(player, "[Admin]", "Goto player " .. args[1]:GetName() .. " successful!")
				else
					CommandRedPrint(player, "[ERROR]", "Your character is not valid!")
				end
			else
				CommandRedPrint(player, "[ERROR]", "Player " .. args[1]:GetName() .. " has no valid character to goto!")
			end
		end
	},

	["bring"] = {
		permission = "SuperModerator",
		args = {
			"player",
		},
		func = function(player, args)
			if not player then
				CommandRedPrint(player, "[ERROR]", "You must be a player to use this command!")
				return false
			end

			if player == args[1] then
				CommandRedPrint(player, "[ERROR]", "You can't bring yourself!")
				return false
			end

			local victimCharacter = args[1]:GetControlledCharacter()

			if victimCharacter then
				local playerCharacter = player:GetControlledCharacter()
				if playerCharacter then
					playerCharacter:SetLocation(victimCharacter:GetLocation())

					CommandRedPrint(player, "[Admin]", "Brought player " .. args[1]:GetName() .. " to you!")
				else
					CommandRedPrint(player, "[ERROR]", "Your character is not valid!")
				end
			else
				CommandRedPrint(player, "[ERROR]", "Player " .. args[1]:GetName() .. " has no valid character to bring!")
			end
		end
	},

	["tp"] = {
		permission = "SuperModerator",
		args = {
			"player",
			"player",
		},
		func = function(player, args)
			local victimCharacter = args[1]:GetControlledCharacter()

			if victimCharacter then
				local victimCharacter2 = args[2]:GetControlledCharacter()
				if victimCharacter2 then
					victimCharacter:SetLocation(victimCharacter2:GetLocation())

					CommandRedPrint(player, "[Admin]", "Brought player " .. args[1]:GetName() .. " to " .. args[2]:GetName() .. "!")
				else
					CommandRedPrint(player, "[ERROR]", "Player " .. args[2]:GetName() .. " has no valid character!")
				end
			else
				CommandRedPrint(player, "[ERROR]", "Player " .. args[1]:GetName() .. " has no valid character to teleport!")
			end
		end
	},

	["kick"] = {
		permission = "SuperModerator",
		args = {
			"player",
			"reason",
		},
		func = function(player, args)
			CommandRedPrint(player, "[Admin]", args[1]:GetName() .. " has been kicked by " .. CommandInstigatorName(player) .. "! (" .. args[2] .. ")")
			args[1]:Kick("You have been kicked by " .. CommandInstigatorName(player) .. " - Reason: " .. args[2])
		end
	},

	["ban"] = {
		permission = "Admin",
		args = {
			"player",
			"reason",
		},
		func = function(player, args)
			if (player == args[1]) then
				CommandRedPrint(player, "[ERROR]", "You can't ban yourself!")
				return false
			end

			CommandRedPrint(player, "[Admin]", args[1]:GetName() .. " has been banned by " .. CommandInstigatorName(player) .. "! (" .. args[2] .. ")")
			args[1]:Ban("You have been banned by " .. CommandInstigatorName(player) .. " - Reason: " .. args[2])
		end
	},

	["adminhelp"] = {
		permission = "Moderator",
		args = {
		},
		func = function(player, args)
			local help_str = ""
			for k, v in pairs(tblCommands) do
				help_str = help_str .. " " .. k
				for i2, v2 in ipairs(v.args) do
					help_str = help_str .. " [" .. v2 .. "]"
				end
				help_str = help_str .. "\n"
			end

			CommandRedPrint(player, "[Admin Help]", help_str)
		end
	}
}



-- Not persistent, store muted players here!
tblMutedPlayers = {}

function WrongFunctionUsage(player, strCommand, command)
	local usage_args_str = ""
	for i, v in ipairs(command.args) do
		usage_args_str = usage_args_str .. " [" .. v .. "]"
	end

	CommandRedPrint(player, "[ERROR]", "Syntax: /" .. strCommand .. usage_args_str)
end

function executeCommand(strCommand, player, text)
	if(not player or checkPermissionToExecute(player, strCommand)) then
		local args = Split(text, " ")

		table.remove(args, 1)

		local command = tblCommands[strCommand]

		if #command.args ~= #args then
			WrongFunctionUsage(player, strCommand, command)
		else
			-- Check if arguments are valid and replace the arg with the correct value if needed
			for i, v in ipairs(command.args) do
				if v == "player" then
					local ply_found = getPlayerFromNamePart(args[i])
					if not ply_found then
						CommandRedPrint(player, "Player " .. args[i] .. " not found!")
						return false
					else
						args[i] = ply_found
					end
				end
			end

			local func = command.func
			if func then
				func(player, args)
			end
		end

	else
		CommandRedPrint(player, "[ERROR]", "You don't have permission to do so!")
	end
end

-- Intercept chat messages and filter out commands
Server.Subscribe("Chat", function(text, sender)
	if (not sender:IsValid()) then return false end
	if (#text == 0) then return false end

	if (string.find(text, "/") == 1) then
		local strCommand = string.sub(text, 2)
		local iFirstSpaceSeperator = string.find(strCommand, " ")

		if(iFirstSpaceSeperator) then
			strCommand = string.sub(strCommand, 0, iFirstSpaceSeperator - 1)
		end

		if(tblCommands[strCommand]) then
			executeCommand(strCommand, sender, text)
		else
			Server.SendChatMessage(sender, "<red>[ERROR]</> Command "..strCommand.." not found!")
		end

		return false
	end

	local senderSteamID = sender:GetSteamID();

	if (tblMutedPlayers[senderSteamID]) then
		Server.SendChatMessage(sender, "<red>[ERROR]</> You are muted!")
		return false
	end
end)

Server.Subscribe("Console", function(text)
	if (string.find(text, "/") == 1) then
		local strCommand = string.sub(text, 2)
		local iFirstSpaceSeperator = string.find(strCommand, " ")

		if(iFirstSpaceSeperator) then
			strCommand = string.sub(strCommand, 0, iFirstSpaceSeperator - 1)
		end

		if(tblCommands[strCommand]) then
			executeCommand(strCommand, sender, text)
		else
			Package.Log("[ERROR] Command " .. strCommand .. " not found!")
		end
	end
end)