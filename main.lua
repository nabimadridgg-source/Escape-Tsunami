local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [[ CONFIG ]] --
local MAIN_COLOR = Color3.fromRGB(0, 255, 200)
local MainSize = UDim2.new(0, 360, 0, 285)
local BASE_URL = "https://raw.githubusercontent.com/nabimadridgg-source/Escape-Tsunami/main/"

local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "NabiHub_Final"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = MainSize
MainFrame.Position = UDim2.new(0, 20, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -85)
ContentFrame.Position = UDim2.new(0, 10, 0, 75)
ContentFrame.BackgroundTransparency = 1

local Underline = Instance.new("Frame", MainFrame)
Underline.Size = UDim2.new(0.33, -10, 0, 2)
Underline.Position = UDim2.new(0, 15, 0, 70)
Underline.BackgroundColor3 = MAIN_COLOR
Underline.BorderSizePixel = 0

-- [[ CACHE SYSTEM ]] --
local Modules = {}

local function SwitchTab(underlineX, modName, fileName)
    ContentFrame:ClearAllChildren()
    TweenService:Create(Underline, TweenInfo.new(0.3), {Position = UDim2.new(0, underlineX + 15, 0, 70)}):Play()
    
    local status = Instance.new("TextLabel", ContentFrame)
    status.Size = UDim2.new(1,0,1,0); status.BackgroundTransparency=1; status.TextColor3=Color3.new(1,1,1)
    status.Font = Enum.Font.Gotham; status.TextSize = 12

    if Modules[modName] then
        status:Destroy()
        Modules[modName](ContentFrame)
    else
        status.Text = "Downloading " .. fileName .. "..."
        task.spawn(function()
            local success, code = pcall(function()
                return game:HttpGet(BASE_URL .. fileName)
            end)
            
            if success and not code:find("404") then
                local func = loadstring(code)
                if func then
                    Modules[modName] = func()
                    status:Destroy()
                    Modules[modName](ContentFrame)
                else
                    status.Text = "Error: File script is broken."
                end
            else
                status.Text = "Failed to download. GitHub Link invalid or Private."
                warn("NABI HUB ERROR: Could not find " .. BASE_URL .. fileName)
            end
        end)
    end
end

-- [[ TABS ]] --
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, 0, 0, 30); TabContainer.Position = UDim2.new(0, 0, 0, 40); TabContainer.BackgroundTransparency = 1

local function CreateTab(name, x, mod, file)
    local b = Instance.new("TextButton", TabContainer)
    b.Size = UDim2.new(0.33, 0, 1, 0); b.Position = UDim2.new(x, 0, 0, 0)
    b.Text = name; b.TextColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 1; b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(function() SwitchTab(x * 330, mod, file) end)
end

CreateTab("LOGS", 0, "LOGS", "LOGS.lua")
CreateTab("PLACES", 0.33, "PLACES", "PLACES.lua")
CreateTab("RADIOACTIVE", 0.66, "RADIOACTIVE", "RADIOACTIVE.lua")

-- Auto-load first
task.wait(0.2)
SwitchTab(0, "LOGS", "LOGS.lua")
