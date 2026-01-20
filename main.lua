local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [[ CONFIGURATION ]] --
local MAIN_COLOR = Color3.fromRGB(0, 255, 200)
local MainSize = UDim2.new(0, 360, 0, 285)
local IconSize = UDim2.new(0, 60, 0, 60)
local ANIM_TIME = 0.3
local IsMinimized = false

-- PERMANENT GITHUB PATH (Requires Public Repo)
local BASE_URL = "https://raw.githubusercontent.com/nabimadridgg-source/Escape-Tsunami/main/"

-- [[ MODULE CACHE ]] --
local Modules = {}

local function LoadModuleFromGitHub(name, fileName)
    local success, code = pcall(function()
        return game:HttpGet(BASE_URL .. fileName)
    end)
    
    if success and code then
        local loadedFunc, err = loadstring(code)
        if loadedFunc then
            local moduleScript = loadedFunc()
            if type(moduleScript) == "function" then
                Modules[name] = moduleScript
                return true
            else
                warn("[NABI] Error: " .. fileName .. " did not return a function.")
            end
        else
            warn("[NABI] Loadstring Error for " .. name .. ": " .. tostring(err))
        end
    else
        warn("[NABI] Failed to download " .. name .. " from GitHub.")
    end
    return false
end

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "NabiHub_Revised"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = MainSize
MainFrame.Position = UDim2.new(0, 20, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame)

-- Minimize Icon (Hidden by default)
local MiniIcon = Instance.new("TextButton", ScreenGui)
MiniIcon.Size = UDim2.new(0, 0, 0, 0); MiniIcon.Position = MainFrame.Position; MiniIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniIcon.Text = "Nabi Hub"; MiniIcon.Font = Enum.Font.GothamBold; MiniIcon.TextColor3 = MAIN_COLOR; MiniIcon.Visible = false
Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(1, 0)

-- Header
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0, 100, 0, 30); Title.Position = UDim2.new(0, 12, 0, 5); Title.BackgroundTransparency = 1
Title.Text = "NABI HUB"; Title.TextColor3 = MAIN_COLOR; Title.Font = Enum.Font.GothamBold; Title.TextSize = 14

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 18, 0, 18); CloseBtn.Position = UDim2.new(1, -24, 0, 8); CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"; CloseBtn.TextColor3 = Color3.new(1, 1, 1); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- Tab Container
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, -20, 0, 30); TabContainer.Position = UDim2.new(0, 10, 0, 40); TabContainer.BackgroundTransparency = 1

local Underline = Instance.new("Frame", TabContainer)
Underline.Size = UDim2.new(0.33, -10, 0, 2); Underline.Position = UDim2.new(0, 5, 1, -2); Underline.BackgroundColor3 = MAIN_COLOR; Underline.BorderSizePixel = 0

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -85); ContentFrame.Position = UDim2.new(0, 10, 0, 75); ContentFrame.BackgroundTransparency = 1

-- [[ ANIMATIONS ]] --
local function ToggleUI()
    IsMinimized = not IsMinimized
    local info = TweenInfo.new(ANIM_TIME, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    if IsMinimized then
        TweenService:Create(MainFrame, info, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
        task.wait(ANIM_TIME/2); MainFrame.Visible = false; MiniIcon.Position = MainFrame.Position; MiniIcon.Visible = true
        TweenService:Create(MiniIcon, info, {Size = IconSize, TextSize = 10}):Play()
    else
        TweenService:Create(MiniIcon, info, {Size = UDim2.new(0,0,0,0), TextSize = 0}):Play()
        task.wait(ANIM_TIME/2); MiniIcon.Visible = false; MainFrame.Visible = true
        TweenService:Create(MainFrame, info, {Size = MainSize, BackgroundTransparency = 0}):Play()
    end
end

CloseBtn.MouseButton1Click:Connect(ToggleUI)
MiniIcon.MouseButton1Click:Connect(ToggleUI)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then ToggleUI() end
end)

-- [[ TAB LOGIC ]] --
local function SwitchTab(btn, underlineX, modName, fileName)
    -- Reset Tab Colors
    for _, child in pairs(TabContainer:GetChildren()) do
        if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(150, 150, 150) end
    end
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    -- Smooth Underline
    TweenService:Create(Underline, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Position = UDim2.new(underlineX, 5, 1, -2)}):Play()
    
    -- Load/Display Content
    ContentFrame:ClearAllChildren()
    
    if not Modules[modName] then
        local loading = Instance.new("TextLabel", ContentFrame)
        loading.Size = UDim2.new(1,0,1,0); loading.Text = "DOWNLOADING " .. modName .. "..."; loading.TextColor3 = Color3.new(1,1,1); loading.BackgroundTransparency = 1; loading.Font = Enum.Font.Gotham
        
        task.spawn(function()
            if LoadModuleFromGitHub(modName, fileName) then
                ContentFrame:ClearAllChildren()
                Modules[modName](ContentFrame)
            else
                loading.Text = "FAILED TO LOAD " .. modName .. ". CHECK CONSOLE (F9)."
                loading.TextColor3 = Color3.new(1, 0, 0)
            end
        end)
    else
        Modules[modName](ContentFrame)
    end
end

-- [[ BUTTON SETUP ]] --
local function CreateTab(name, xPos, modName, fileName)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0.33, 0, 1, 0); btn.Position = UDim2.new(xPos, 0, 0, 0)
    btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextSize = 8; btn.TextColor3 = Color3.fromRGB(150, 150, 150); btn.BackgroundTransparency = 1
    
    btn.MouseButton1Click:Connect(function()
        SwitchTab(btn, xPos, modName, fileName)
    end)
    return btn
end

local b1 = CreateTab("LOGS", 0, "LOGS", "LOGS.lua")
local b2 = CreateTab("PLACES", 0.33, "PLACES", "PLACES.lua")
local b3 = CreateTab("RADIOACTIVE", 0.66, "RADIOACTIVE", "RADIOACTIVE.lua")

-- Initial Load
SwitchTab(b1, 0, "LOGS", "LOGS.lua")
