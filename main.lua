local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [[ CONFIG ]] --
local MAIN_COLOR = Color3.fromRGB(0, 255, 200)
local MainSize = UDim2.new(0, 360, 0, 285)
local IconSize = UDim2.new(0, 60, 0, 60)
local ANIM_TIME = 0.3
local IsMinimized = false

-- PERMANENT BASE URL (No tokens needed if the Repo is Public)
local BASE_URL = "https://raw.githubusercontent.com/nabimadridgg-source/Escape-Tsunami/main/"

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

-- [[ MINIMIZE ICON ]] --
local MiniIcon = Instance.new("TextButton", ScreenGui)
MiniIcon.Size = UDim2.new(0, 0, 0, 0); MiniIcon.Position = MainFrame.Position; MiniIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniIcon.Text = "Nabi Hub"; MiniIcon.Font = Enum.Font.GothamBold; MiniIcon.TextColor3 = MAIN_COLOR; MiniIcon.Visible = false
Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(1, 0)

-- [[ HEADER ]] --
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0, 100, 0, 30); Title.Position = UDim2.new(0, 12, 0, 5); Title.BackgroundTransparency = 1
Title.Text = "NABI HUB"; Title.TextColor3 = MAIN_COLOR; Title.Font = Enum.Font.GothamBold; Title.TextSize = 14

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 18, 0, 18); CloseBtn.Position = UDim2.new(1, -24, 0, 8); CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"; CloseBtn.TextColor3 = Color3.new(1, 1, 1); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- [[ TAB SYSTEM UI ]] --
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, -20, 0, 30); TabContainer.Position = UDim2.new(0, 10, 0, 40); TabContainer.BackgroundTransparency = 1

local Underline = Instance.new("Frame", TabContainer)
Underline.Size = UDim2.new(0.33, -10, 0, 2); Underline.Position = UDim2.new(0, 5, 1, -2); Underline.BackgroundColor3 = MAIN_COLOR; Underline.BorderSizePixel = 0

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -85); ContentFrame.Position = UDim2.new(0, 10, 0, 75); ContentFrame.BackgroundTransparency = 1

-- [[ TOGGLE LOGIC ]] --
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
UserInputService.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.K then ToggleUI() end end)

-- [[ MODULE LOADING ]] --
local function SwitchTab(btn, underlineX, fileName)
    -- Reset UI
    for _, tab in ipairs(TabContainer:GetChildren()) do
        if tab:IsA("TextButton") then tab.TextColor3 = Color3.fromRGB(150, 150, 150) end
    end
    btn.TextColor3 = Color3.new(1, 1, 1)
    TweenService:Create(Underline, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Position = UDim2.new(underlineX, 5, 1, -2)}):Play()
    
    -- Load Content
    ContentFrame:ClearAllChildren()
    local success, err = pcall(function()
        local code = game:HttpGet(BASE_URL .. fileName)
        loadstring(code)()(ContentFrame)
    end)
    
    if not success then
        local errLabel = Instance.new("TextLabel", ContentFrame)
        errLabel.Size = UDim2.new(1,0,0,20); errLabel.Text = "Error Loading: " .. fileName; errLabel.TextColor3 = Color3.new(1,0,0)
        warn("Load Error: " .. tostring(err))
    end
end

-- [[ BUTTON SETUP ]] --
local b1 = Instance.new("TextButton", TabContainer)
b1.Size = UDim2.new(0.33, 0, 1, 0); b1.Text = "BRAINROT"; b1.Font = Enum.Font.GothamBold; b1.TextSize = 8; b1.BackgroundTransparency = 1
b1.MouseButton1Click:Connect(function() SwitchTab(b1, 0, "LOGS.lua") end)

local b2 = Instance.new("TextButton", TabContainer)
b2.Size = UDim2.new(0.33, 0, 1, 0); b2.Position = UDim2.new(0.33, 0, 0, 0); b2.Text = "PLACES"; b2.Font = Enum.Font.GothamBold; b2.TextSize = 8; b2.BackgroundTransparency = 1
b2.MouseButton1Click:Connect(function() SwitchTab(b2, 0.33, "PLACES.lua") end)

local b3 = Instance.new("TextButton", TabContainer)
b3.Size = UDim2.new(0.33, 0, 1, 0); b3.Position = UDim2.new(0.66, 0, 0, 0); b3.Text = "RADIOACTIVE"; b3.Font = Enum.Font.GothamBold; b3.TextSize = 8; b3.BackgroundTransparency = 1
b3.MouseButton1Click:Connect(function() SwitchTab(b3, 0.66, "RADIOACTIVE.lua") end)

-- Default Tab
SwitchTab(b1, 0, "LOGS.lua")
