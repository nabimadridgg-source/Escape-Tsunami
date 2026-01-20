-- [[ NABI HUB OFFICIAL LOADER ]] --
local repo = "https://raw.githubusercontent.com/nabimadridgg-source/Escape-Tsunami/main/"
local file = "Nabi-Hub.lua"

local success, result = pcall(function()
    return game:HttpGet(repo .. file)
end)

if success then
    local compiled, err = loadstring(result)
    if compiled then
        -- This executes the obfuscated code in Nabi-Hub.lua
        compiled() 
    else
        warn("Nabi Hub: [Error in Compilation] " .. tostring(err))
    end
else
    warn("Nabi Hub: [Connection Failed] Could not reach GitHub.")
end
