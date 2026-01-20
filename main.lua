local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [[ CONFIGURATION ]] --
local MAIN_COLOR = Color3.fromRGB(0, 255, 200) -- Bright Cyan
local MainSize = UDim2.new(0, 360, 0, 285)
local IconSize = UDim2.new(0, 60, 0, 60)
local ANIM_TIME = 0.3
local IsMinimized = false
local BASE_URL = "https://raw.githubusercontent.com/nabimadridgg-source/Escape-Tsunami/main/"

-- [[ UI ROOT ]] --
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "NabiHub_V3_Bright"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [[ MINIMIZE ICON (The Bright Toggle) ]] --
local MiniIcon = Instance.new("TextButton", ScreenGui)
MiniIcon.Name = "MiniIcon"
MiniIcon.Size = UDim2.new(0, 0, 0, 0)
MiniIcon.Position = UDim2.new(0, 20, 0.4, 0)
MiniIcon.BackgroundColor3 = Color3.fromRGB(40, 40, 50) -- Lighter Grey-Blue
MiniIcon.Text = "NABI"
MiniIcon.Font = Enum.Font.GothamBold
MiniIcon.TextColor3 = MAIN_COLOR
MiniIcon.Visible = false
MiniIcon.Draggable = true -- Now you can move the icon too!
MiniIcon.ZIndex = 10

local IconCorner = Instance.new("UICorner", MiniIcon)
IconCorner.CornerRadius = UDim.new(1, 0)

local IconStroke = Instance.new("UIStroke", MiniIcon)
IconStroke.Color = MAIN_COLOR
IconStroke.Thickness = 2 -- Thicker border for visibility
IconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- [[ MAIN FRAME ]] --
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = MainSize
MainFrame.Position = UDim2.new(0, 20, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(50, 50, 60)

-- [[ HEADER BAR ]] --
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "NABI HUB"
Title.TextColor3 = MAIN_COLOR
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -11)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0.3, 0)

-- [[ TAB SYSTEM UI ]] --
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, -20, 0, 30)
TabContainer.Position = UDim2.new(0, 10, 0, 40)
TabContainer.BackgroundTransparency = 1

local Underline = Instance.new("Frame", TabContainer)
Underline.Size = UDim2.new(0.33, -10, 0, 2)
Underline.Position = UDim2.new(0, 5, 1, -2)
Underline.BackgroundColor3 = MAIN_COLOR
Underline.BorderSizePixel = 0

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -85)
ContentFrame.Position = UDim2.new(0, 10, 0, 75)
ContentFrame.BackgroundTransparency = 1

-- [[ TOGGLE LOGIC ]] --
local function ToggleUI()
    IsMinimized = not IsMinimized
    local info = TweenInfo.new(ANIM_TIME, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if IsMinimized then
        TweenService:Create(MainFrame, info, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
        task.wait(ANIM_TIME/1.5)
        MainFrame.Visible = false
        MiniIcon.Position = MainFrame.Position
        MiniIcon.Visible = true
        TweenService:Create(MiniIcon, info, {Size = IconSize}):Play()
    else
        TweenService:Create(MiniIcon, info, {Size = UDim2.new(0,0,0,0)}):Play()
        task.wait(ANIM_TIME/1.5)
        MiniIcon.Visible = false
        MainFrame.Visible = true
        TweenService:Create(MainFrame, info, {Size = MainSize, BackgroundTransparency = 0}):Play()
    end
end

CloseBtn.MouseButton1Click:Connect(ToggleUI)
MiniIcon.MouseButton1Click:Connect(ToggleUI)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then
        ToggleUI()
    end
end)

-- [[ LOADER LOGIC ]] --
local Modules = {}
local function SwitchTab(btn, underlineX, modName, fileName)
    for _, child in pairs(TabContainer:GetChildren()) do
        if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(150, 150, 150) end
    end
    btn.TextColor3 = Color3.new(1, 1, 1)
    TweenService:Create(Underline, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Position = UDim2.new(underlineX, 5, 1, -2)}):Play()
    ContentFrame:ClearAllChildren()
    
    if Modules[modName] then
        Modules[modName](ContentFrame)
    else
        local status = Instance.new("TextLabel", ContentFrame)
        status.Size = UDim2.new(1,0,1,0); status.Text = "Loading " .. fileName .. "..."; status.TextColor3 = Color3.new(1,1,1); status.BackgroundTransparency = 1
        
        task.spawn(function()
            local success, code = pcall(function() return game:HttpGet(BASE_URL .. fileName) end)
            if success and not code:find("404") then
                local func = loadstring(code)
                if func then
                    Modules[modName] = func()
                    status:Destroy()
                    Modules[modName](ContentFrame)
                else
                    status.Text = "SCRIPT ERROR IN FILE"
                end
            else
                status.Text = "DOWNLOAD FAILED (CHECK GITHUB)"
            end
        end)
    end
end

-- [[ TABS SETUP ]] --
local function CreateTab(name, xPos, modName, fileName)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0.33, 0, 1, 0)
    btn.Position = UDim2.new(xPos, 0, 0, 0)
    btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextSize = 8; btn.TextColor3 = Color3.fromRGB(150, 150, 150); btn.BackgroundTransparency = 1
    btn.MouseButton1Click:Connect(function() SwitchTab(btn, xPos, modName, fileName) end)
    return btn
end

local b1 = CreateTab("LOGS", 0, "LOGS", "LOGS.lua")
local b2 = CreateTab("LOCATIONS", 0.33, "LOCATIONS", "LOCATIONS.lua")
local b3 = CreateTab("RADIOACTIVE", 0.66, "RADIOACTIVE", "RADIOACTIVE.lua")

task.wait(0.2)
SwitchTab(b1, 0, "LOGS", "LOGS.lua")
