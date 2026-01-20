-- [[ NABI HUB LOADER ]] --
local function LoadNabi()
    local github_url = "https://raw.githubusercontent.com/nabimadridgg-source/Escape-Tsunami/main/Nabi-Hub.lua"
    
    local success, result = pcall(function()
        return game:HttpGet(github_url)
    end)

    if success then
        local func, err = loadstring(result)
        if func then
            print("Nabi Hub: Authentication Success. Loading...")
            func()
        else
            warn("Nabi Hub: Compilation Error: " .. tostring(err))
        end
    else
        warn("Nabi Hub: Failed to connect to GitHub.")
    end
end

LoadNabi()
