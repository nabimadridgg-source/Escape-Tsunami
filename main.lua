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

-- Change this to your actual GitHub main branch raw link
local BASE_URL = "https://raw.githubusercontent.com/nabimadridgg-source/Escape-Tsunami/main/"

-- [[ MODULE CACHING ]] --
local Modules = {}
local function PreloadModule(name, fileName)
    local success, result = pcall(function()
        return game:HttpGet(BASE_URL .. fileName)
    end)
    
    if success then
        local func, err = loadstring(result)
        if func then
            Modules[name] = func()
            print("[NABI HUB] Loaded: " .. name)
        else
            warn("[NABI HUB] Syntax Error in " .. name .. ": " .. tostring(err))
        end
    else
        warn("[NABI HUB] Failed to download: " .. name)
    end
end

-- Preload all categories immediately
task.spawn(function()
    PreloadModule("LOGS", "LOGS.lua")
    PreloadModule("PLACES", "PLACES.lua")
    PreloadModule("RADIOACTIVE", "RADIOACTIVE.lua")
end)

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "NabiHub_Main"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = MainSize
MainFrame.Position = UDim2.new(0, 20, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame)

-- Minimize Icon
local MiniIcon = Instance.new("TextButton", ScreenGui)
MiniIcon.Size = UDim2.new(0, 0, 0, 0)
MiniIcon.Position = MainFrame.Position
MiniIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniIcon.Text = "Nabi Hub"
MiniIcon.Font = Enum.Font.GothamBold
MiniIcon.TextColor3 = MAIN_COLOR
MiniIcon.Visible = false
MiniIcon.Draggable = true
Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(1, 0)

-- Header
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0, 100, 0, 30); Title.Position = UDim2.new(0, 12, 0, 5); Title.BackgroundTransparency = 1
Title.Text = "NABI HUB"; Title.TextColor3 = MAIN_COLOR; Title.Font = Enum.Font.GothamBold; Title.TextSize = 14

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 18, 0, 18); CloseBtn.Position = UDim2.new(1, -24, 0, 8); CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"; CloseBtn.TextColor3 = Color3.new(1, 1, 1); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- Tab System
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, -20, 0, 30); TabContainer.Position = UDim2.new(0, 10, 0, 40); TabContainer.BackgroundTransparency = 1

local Underline = Instance.new("Frame", TabContainer)
Underline.Size = UDim2.new(0.33, -10, 0, 2); Underline.Position = UDim2.new(0, 5, 1, -2); Underline.BackgroundColor3 = MAIN_COLOR; Underline.BorderSizePixel = 0

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -85); ContentFrame.Position = UDim2.new(0, 10, 0, 75); ContentFrame.BackgroundTransparency = 1

-- [[ UI ANIMATIONS ]] --
local function ToggleUI()
    IsMinimized = not IsMinimized
    local info = TweenInfo.new(ANIM_TIME, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    if IsMinimized then
        TweenService:Create(MainFrame, info, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
        task.wait(ANIM_TIME/2)
        MainFrame.Visible = false
        MiniIcon.Position = MainFrame.Position
        MiniIcon.Visible = true
        TweenService:Create(MiniIcon, info, {Size = IconSize, TextSize = 10}):Play()
    else
        TweenService:Create(MiniIcon, info, {Size = UDim2.new(0,0,0,0), TextSize = 0}):Play()
        task.wait(ANIM_TIME/2)
        MiniIcon.Visible = false
        MainFrame.Visible = true
        TweenService:Create(MainFrame, info, {Size = MainSize, BackgroundTransparency = 0}):Play()
    end
end

CloseBtn.MouseButton1Click:Connect(ToggleUI)
MiniIcon.MouseButton1Click:Connect(ToggleUI)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then ToggleUI() end
end)

-- [[ TAB LOGIC ]] --
local Tabs = {}
local function SwitchTab(btn, underlineX, moduleName)
    -- UI Feedback
    for _, tab in ipairs(Tabs) do
        TweenService:Create(tab, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
    end
    TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.new(1, 1, 1)}):Play()
    TweenService:Create(Underline, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Position = UDim2.new(underlineX, 5, 1, -2)}):Play()
    
    -- Load Content from Cache
    ContentFrame:ClearAllChildren()
    if Modules[moduleName] then
        Modules[moduleName](ContentFrame)
    else
        local loadingLabel = Instance.new("TextLabel", ContentFrame)
        loadingLabel.Size = UDim2.new(1,0,1,0); loadingLabel.Text = "Loading " .. moduleName .. "..."; loadingLabel.TextColor3 = Color3.new(1,1,1); loadingLabel.BackgroundTransparency = 1
    end
end

local function CreateTabButton(name, pos, xMult, modName)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0.33, 0, 1, 0); btn.Position = pos; btn.Text = name
    btn.BackgroundTransparency = 1; btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 8
    table.insert(Tabs, btn)
    btn.MouseButton1Click:Connect(function() SwitchTab(btn, xMult, modName) end)
    return btn
end

local b1 = CreateTabButton("BRAINROT", UDim2.new(0, 0, 0, 0), 0, "LOGS")
local b2 = CreateTabButton("PLACES", UDim2.new(0.33, 0, 0, 0), 0.33, "PLACES")
local b3 = CreateTabButton("RADIOACTIVE", UDim2.new(0.66, 0, 0, 0), 0.66, "RADIOACTIVE")

-- Default Tab
task.delay(1, function() SwitchTab(b1, 0, "LOGS") end)
