# Simple Admin Commands

Nanos World: https://store.steampowered.com/app/1841660/nanos_world/

Store: https://store.nanos.world/packages/simpleadmincommands/


Simple Admin Commands adds the possibility to administrate your server either via console or ingame chat.


Available commands:

/slap - Slap a player

/mute - Mute a player

/unmute - Unmute a player

/goto - Go to another player (ingame only)

/bring - Bring another player to you (ingame only)

/tp - Teleport one player to another (ingame only)

/kick - Kick a player

/ban - Ban a player


To view a detailed explanation of the commands, either write "adminhelp" in server console or the corresponding command in ingame chat.


=== Installation ===

The system is split into 3 different groups. Admins, Supermoderators and Moderators.

To add a player to one of these groups, open permissions.lua file and add steam ID to one of the groups.

To change a permission level of a command, edit the tblCommandPermissions table and change it to the corresponding group.
