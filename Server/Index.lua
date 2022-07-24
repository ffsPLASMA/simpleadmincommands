local tblRequiredFiles = {
	"utils.lua",
	"commands.lua",
	"permissions.lua",
	"server.lua",
};

Package.Subscribe("Load", function()
	for _, strFileName in ipairs(tblRequiredFiles) do
		Package.Require(strFileName);
	end

	Package.Log("admin loaded.");
end)

Package.Subscribe("Unload", function()
	Package.Log("admin unloaded.");
end)