
DiscreteUI = DiscreteUI or {}

local AutorunTable = {}
AutorunTable[1] = {
	Location = "discreteui/",
	Type = "Shared",
	Enabled = true
}
AutorunTable[2] = {
	Location = "discreteui/server/",
	Type = "Server",
	Enabled = true
}
AutorunTable[3] = {
	Location = "discreteui/client/",
	Type = "Client",
	Enabled = true
}
AutorunTable[4] = {
	Location = "discreteui/client/vgui/",
	Type = "Client",
	Enabled = true
}

for key, val in pairs( AutorunTable ) do
	if( val.Type == "Shared" and val.Enabled == true ) then
		for k, v in pairs( file.Find( val.Location .. "*.lua", "LUA" ) ) do
			AddCSLuaFile( val.Location .. v )
			include( val.Location .. v )
		end
	end
end
if( SERVER ) then
	for key, val in pairs( AutorunTable ) do
		if( val.Type == "Client" and val.Enabled == true ) then
			for k, v in pairs( file.Find( val.Location .. "*.lua", "LUA" ) ) do
				AddCSLuaFile( val.Location .. v )
			end
		elseif( val.Type == "Server" and val.Enabled == true ) then
			for k, v in pairs( file.Find( val.Location .. "*.lua", "LUA" ) ) do
				include( val.Location .. v )
			end
		end
	end
elseif( CLIENT ) then
	for key, val in pairs( AutorunTable ) do
		if( val.Type == "Client" and val.Enabled == true ) then
			for k, v in pairs( file.Find( val.Location .. "*.lua", "LUA" ) ) do
				include( val.Location .. v )
			end
		end
	end
end
