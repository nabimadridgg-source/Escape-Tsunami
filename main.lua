local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [[ CONFIG ]] --
local MAIN_COLOR = Color3.fromRGB(0, 255, 200)
local MainSize = UDim2.new(0, 360, 0, 285)
-- PERMANENT RAW URL
local BASE_URL = "https://raw.githubusercontent.com/nabimadridgg-source/Escape-Tsunami/main/"

-- [[ MODULE CACHE ]] --
local Modules = {}

local function FetchModule(name, fileName)
    local success, code = pcall(function()
        return game:HttpGet(BASE_URL .. fileName)
    end)
    
    if success and code then
        local loadedFunc, err = loadstring(code)
        if loadedFunc then
            -- We run the code once to get the returned function
            local moduleScript = loadedFunc() 
            Modules[name] = moduleScript
            print("[NABI] Successfully cached: " .. name)
            return true
        else
            warn("[NABI] Loadstring Error for " .. name .. ": " .. tostring(err))
        end
    else
        warn("[NABI] Http Error for " .. name)
    end
    return false
end

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "NabiHub_Main"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = MainSize
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -142)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -85)
ContentFrame.Position = UDim2.new(0, 10, 0, 75)
ContentFrame.BackgroundTransparency = 1

local Underline = Instance.new("Frame", MainFrame)
Underline.Size = UDim2.new(0.3, -10, 0, 2)
Underline.Position = UDim2.new(0, 15, 0, 70)
Underline.BackgroundColor3 = MAIN_COLOR
Underline.BorderSizePixel = 0

-- [[ LOADING LOGIC ]] --
local function SwitchTab(btn, underlineX, modName, fileName)
    ContentFrame:ClearAllChildren()
    
    -- Smooth Underline Move
    TweenService:Create(Underline, TweenInfo.new(0.3), {Position = UDim2.new(underlineX, 5, 0, 70)}):Play()
    
    -- Check if already loaded, if not, try to fetch
    if not Modules[modName] then
        local loading = Instance.new("TextLabel", ContentFrame)
        loading.Size = UDim2.new(1,0,1,0); loading.Text = "DOWNLOADING " .. modName .. "..."; loading.TextColor3 = Color3.new(1,1,1); loading.BackgroundTransparency = 1
        
        local loaded = FetchModule(modName, fileName)
        if not loaded then 
            loading.Text = "FAILED TO DOWNLOAD. CHECK GITHUB LINK."; return 
        end
    end
    
    -- Run the Module
    ContentFrame:ClearAllChildren()
    local success, err = pcall(function()
        Modules[modName](ContentFrame)
    end)
    
    if not success then
        warn("[NABI] Runtime Error in " .. modName .. ": " .. tostring(err))
    end
end

-- [[ BUTTON SETUP ]] --
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, 0, 0, 30); TabContainer.Position = UDim2.new(0, 0, 0, 40); TabContainer.BackgroundTransparency = 1

local function CreateTab(name, xPos, modName, fileName)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0.33, 0, 1, 0); btn.Position = UDim2.new(xPos, 0, 0, 0)
    btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundTransparency = 1
    
    btn.MouseButton1Click:Connect(function()
        SwitchTab(btn, xPos, modName, fileName)
    end)
    return btn
end

local b1 = CreateTab("LOGS", 0, "LOGS", "LOGS.lua")
local b2 = CreateTab("PLACES", 0.33, "PLACES", "PLACES.lua")
local b3 = CreateTab("RADIOACTIVE", 0.66, "RADIOACTIVE", "RADIOACTIVE.lua")

-- Initial Load
task.spawn(function()
    SwitchTab(b1, 0, "LOGS", "LOGS.lua")
end)
