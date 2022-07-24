# Simple Admin Commands

Nanos World: https://store.steampowered.com/app/1841660/nanos_world/

Store: https://store.nanos.world/packages/simpleadmincommands/


Simple Admin Commands adds the possibility to administrate your server either via console or ingame chat.


Available commands:

/adminhelp - Show all commands available

/slap - Slap a player

/mute - Mute a player

/unmute - Unmute a player

/goto - Go to another player (ingame only)

/bring - Bring another player to you (ingame only)

/tp - Teleport one player to another

/kick - Kick a player

/ban - Ban a player


=== Installation ===

The system is split into 3 different groups. Admins, Supermoderators and Moderators.

To add a player to one of these groups, open config.lua file, add the player steam ID and set his group

To change a permission level of a command, edit the tblCommands table and change it to the corresponding group.
