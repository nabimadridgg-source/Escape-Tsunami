local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [[ CONFIGURATION - BALANCED LARGE ]] --
local MAIN_COLOR = Color3.fromRGB(0, 255, 200)
local MainSize = UDim2.new(0, 200, 0, 150) -- Large but playable
local IconSize = UDim2.new(0, 70, 0, 70)   -- Easy to click, not intrusive
local IsMinimized = false
local BASE_URL = "https://raw.githubusercontent.com/nabimadridgg-source/Escape-Tsunami/main/"

-- [[ UI ROOT ]] --
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "NabiHub_V11"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [[ MINIMIZE ICON (Moveable) ]] --
local MiniIcon = Instance.new("TextButton", ScreenGui)
MiniIcon.Size = UDim2.new(0, 0, 0, 0)
MiniIcon.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
MiniIcon.Text = "N A B I"
MiniIcon.Font = Enum.Font.GothamBold
MiniIcon.TextColor3 = MAIN_COLOR
MiniIcon.TextSize = 12 
MiniIcon.Visible = false
MiniIcon.Active = true
MiniIcon.Draggable = true 
MiniIcon.ZIndex = 20
Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", MiniIcon)
IconStroke.Color = MAIN_COLOR
IconStroke.Thickness = 2.5 

-- [[ MAIN FRAME ]] --
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = MainSize
MainFrame.Position = UDim2.new(0, 30, 0, 30) -- Upper left
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(50, 50, 60)

-- [[ HEADER / TABS / CONTENT ]] --
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 45); Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -50, 1, 0); Title.Position = UDim2.new(0, 18, 0, 0); Title.BackgroundTransparency = 1
Title.Text = "NABI HUB"; Title.TextColor3 = MAIN_COLOR; Title.Font = Enum.Font.GothamBold; Title.TextSize = 18; Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 28, 0, 28); CloseBtn.Position = UDim2.new(1, -35, 0.5, -14); CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"; CloseBtn.TextColor3 = Color3.new(1, 1, 1); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 22
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0.3, 0)

local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, -30, 0, 35); TabContainer.Position = UDim2.new(0, 15, 0, 55); TabContainer.BackgroundTransparency = 1

local Underline = Instance.new("Frame", TabContainer)
Underline.Size = UDim2.new(0.33, -15, 0, 3); Underline.Position = UDim2.new(0, 7, 1, -2); Underline.BackgroundColor3 = MAIN_COLOR; Underline.BorderSizePixel = 0

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -30, 1, -110); ContentFrame.Position = UDim2.new(0, 15, 0, 100); ContentFrame.BackgroundTransparency = 1

-- [[ TOGGLE LOGIC ]] --
local function ToggleUI()
    IsMinimized = not IsMinimized
    local pop = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local hide = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    
    if IsMinimized then
        local centerX = MainFrame.Position.X.Offset + (MainFrame.Size.X.Offset / 2)
        local centerY = MainFrame.Position.Y.Offset + (MainFrame.Size.Y.Offset / 2)
        local centerPos = UDim2.new(MainFrame.Position.X.Scale, centerX - (IconSize.X.Offset/2), MainFrame.Position.Y.Scale, centerY - (IconSize.Y.Offset/2))

        TweenService:Create(MainFrame, hide, {Size = UDim2.new(0,0,0,0), Rotation = 10}):Play()
        task.wait(0.2)
        MainFrame.Visible = false
        
        MiniIcon.Position = centerPos
        MiniIcon.Visible = true
        TweenService:Create(MiniIcon, pop, {Size = IconSize}):Play()
    else
        local iconCenterX = MiniIcon.Position.X.Offset + (MiniIcon.Size.X.Offset / 2)
        local iconCenterY = MiniIcon.Position.Y.Offset + (MiniIcon.Size.Y.Offset / 2)
        local newMainPos = UDim2.new(MiniIcon.Position.X.Scale, iconCenterX - (MainSize.X.Offset/2), MiniIcon.Position.Y.Scale, iconCenterY - (MainSize.Y.Offset/2))

        TweenService:Create(MiniIcon, hide, {Size = UDim2.new(0,0,0,0)}):Play()
        task.wait(0.15)
        MiniIcon.Visible = false
        
        MainFrame.Position = newMainPos
        MainFrame.Visible = true
        MainFrame.Rotation = -10
        TweenService:Create(MainFrame, pop, {Size = MainSize, Rotation = 0}):Play()
    end
end

CloseBtn.MouseButton1Click:Connect(ToggleUI)
MiniIcon.MouseButton1Click:Connect(ToggleUI)
UserInputService.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.K then ToggleUI() end end)

-- [[ LOADER ]] --
local Modules = {}
local function SwitchTab(btn, x, mod, file)
    for _, child in pairs(TabContainer:GetChildren()) do
        if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(150, 150, 150) end
    end
    btn.TextColor3 = Color3.new(1, 1, 1)
    TweenService:Create(Underline, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(x, 7, 1, -2)}):Play()
    ContentFrame:ClearAllChildren()
    if Modules[mod] then Modules[mod](ContentFrame) else
        local s = Instance.new("TextLabel", ContentFrame)
        s.Size = UDim2.new(1,0,1,0); s.TextSize = 16; s.Text = "Fetching Nabi Hub Data..."; s.TextColor3 = Color3.new(1,1,1); s.BackgroundTransparency = 1
        task.spawn(function()
            local success, code = pcall(function() return game:HttpGet(BASE_URL .. file) end)
            if success and not code:find("404") then
                local f = loadstring(code)
                if f then Modules[mod] = f(); s:Destroy(); Modules[mod](ContentFrame) else s.Text = "Compilation Error" end
            else s.Text = "Could not reach GitHub" end
        end)
    end
end

local function CreateTab(n, x, m, f)
    local b = Instance.new("TextButton", TabContainer)
    b.Size = UDim2.new(0.33, 0, 1, 0); b.Position = UDim2.new(x, 0, 0, 0)
    b.Text = n; b.Font = Enum.Font.GothamBold; b.TextSize = 12; b.TextColor3 = Color3.fromRGB(150, 150, 150); b.BackgroundTransparency = 1
    b.MouseButton1Click:Connect(function() SwitchTab(b, x, m, f) end); return b
end

local b1 = CreateTab("LOGS", 0, "LOGS", "LOGS.lua")
local b2 = CreateTab("LOCATIONS", 0.33, "LOCATIONS", "LOCATIONS.lua")
local b3 = CreateTab("RADIOACTIVE", 0.66, "RADIOACTIVE", "RADIOACTIVE.lua")
task.wait(0.2); SwitchTab(b1, 0, "LOGS", "LOGS.lua")
