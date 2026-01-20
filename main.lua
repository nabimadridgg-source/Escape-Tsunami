local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [[ CONFIGURATION ]] --
local MAIN_COLOR = Color3.fromRGB(0, 255, 200)
local MainSize = UDim2.new(0, 360, 0, 285)
local IconSize = UDim2.new(0, 65, 0, 65)
local IsMinimized = false
local BASE_URL = "https://raw.githubusercontent.com/nabimadridgg-source/Escape-Tsunami/main/"

-- [[ UI ROOT ]] --
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "NabiHub_V7"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [[ MAIN FRAME ]] --
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = MainSize
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -142)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Visible = true -- Load UI first
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(50, 50, 60)

-- [[ MINIMIZE ICON (Hidden at start) ]] --
local MiniIcon = Instance.new("TextButton", ScreenGui)
MiniIcon.Size = UDim2.new(0, 0, 0, 0)
MiniIcon.Position = MainFrame.Position -- Center of UI
MiniIcon.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
MiniIcon.Text = "N A B I"
MiniIcon.Font = Enum.Font.GothamBold
MiniIcon.TextColor3 = MAIN_COLOR
MiniIcon.TextSize = 10
MiniIcon.Visible = false
MiniIcon.Active = true
MiniIcon.Draggable = true 
MiniIcon.ZIndex = 20
Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", MiniIcon)
IconStroke.Color = MAIN_COLOR
IconStroke.Thickness = 2 

-- [[ HEADER BAR ]] --
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 35); Header.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -40, 1, 0); Title.Position = UDim2.new(0, 12, 0, 0); Title.BackgroundTransparency = 1
Title.Text = "NABI HUB"; Title.TextColor3 = MAIN_COLOR; Title.Font = Enum.Font.GothamBold; Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 22, 0, 22); CloseBtn.Position = UDim2.new(1, -28, 0.5, -11); CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"; CloseBtn.TextColor3 = Color3.new(1, 1, 1); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 18
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0.3, 0)

-- [[ CONTENT & TABS ]] --
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, -20, 0, 30); TabContainer.Position = UDim2.new(0, 10, 0, 40); TabContainer.BackgroundTransparency = 1
local Underline = Instance.new("Frame", TabContainer)
Underline.Size = UDim2.new(0.33, -10, 0, 2); Underline.Position = UDim2.new(0, 5, 1, -2); Underline.BackgroundColor3 = MAIN_COLOR; Underline.BorderSizePixel = 0
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -85); ContentFrame.Position = UDim2.new(0, 10, 0, 75); ContentFrame.BackgroundTransparency = 1

-- [[ REFINED TOGGLE LOGIC ]] --
local function ToggleUI()
    IsMinimized = not IsMinimized
    
    local popInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local shrinkInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    
    if IsMinimized then
        -- 1. Calculate the center of the current MainFrame location
        local currentCenter = UDim2.new(0, MainFrame.AbsolutePosition.X + (MainFrame.AbsoluteSize.X/2) - (IconSize.X.Offset/2), 0, MainFrame.AbsolutePosition.Y + (MainFrame.AbsoluteSize.Y/2) - (IconSize.Y.Offset/2))
        
        -- 2. Shrink Main UI
        TweenService:Create(MainFrame, shrinkInfo, {Size = UDim2.new(0,0,0,0), Rotation = 10}):Play()
        task.wait(0.25)
        MainFrame.Visible = false
        
        -- 3. Pop Icon out from that center
        MiniIcon.Position = currentCenter
        MiniIcon.Visible = true
        MiniIcon.Size = UDim2.new(0,0,0,0)
        TweenService:Create(MiniIcon, popInfo, {Size = IconSize}):Play()
    else
        -- 1. Shrink Icon
        TweenService:Create(MiniIcon, shrinkInfo, {Size = UDim2.new(0,0,0,0)}):Play()
        task.wait(0.2)
        MiniIcon.Visible = false
        
        -- 2. Main UI grows back from Icon's current position
        MainFrame.Position = UDim2.new(0, MiniIcon.AbsolutePosition.X - (MainSize.X.Offset/2) + (IconSize.X.Offset/2), 0, MiniIcon.AbsolutePosition.Y - (MainSize.Y.Offset/2) + (IconSize.Y.Offset/2))
        MainFrame.Visible = true
        MainFrame.Rotation = -10
        TweenService:Create(MainFrame, popInfo, {Size = MainSize, Rotation = 0}):Play()
    end
end

CloseBtn.MouseButton1Click:Connect(ToggleUI)
MiniIcon.MouseButton1Click:Connect(ToggleUI)
UserInputService.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.K then ToggleUI() end end)

-- [[ LOADER LOGIC ]] --
local Modules = {}
local function SwitchTab(btn, underlineX, modName, fileName)
    for _, child in pairs(TabContainer:GetChildren()) do
        if child:IsA("TextButton") then TweenService:Create(child, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play() end
    end
    TweenService:Create(btn, TweenInfo.new(0.3), {TextColor3 = Color3.new(1, 1, 1)}):Play()
    TweenService:Create(Underline, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(underlineX, 5, 1, -2)}):Play()
    ContentFrame:ClearAllChildren()
    
    if Modules[modName] then
        Modules[modName](ContentFrame)
    else
        local status = Instance.new("TextLabel", ContentFrame)
        status.Size = UDim2.new(1,0,1,0); status.Text = "Fetching " .. fileName .. "..."; status.TextColor3 = Color3.new(1,1,1); status.BackgroundTransparency = 1
        task.spawn(function()
            local success, code = pcall(function() return game:HttpGet(BASE_URL .. fileName) end)
            if success and not code:find("404") then
                local func = loadstring(code)
                if func then
                    Modules[modName] = func()
                    status:Destroy()
                    Modules[modName](ContentFrame)
                else
                    status.Text = "ERROR: SCRIPT BUG"
                end
            else
                status.Text = "DOWNLOAD FAILED"
            end
        end)
    end
end

-- [[ TABS SETUP ]] --
local function CreateTab(name, xPos, modName, fileName)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0.33, 0, 1, 0); btn.Position = UDim2.new(xPos, 0, 0, 0)
    btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextSize = 8; btn.TextColor3 = Color3.fromRGB(150, 150, 150); btn.BackgroundTransparency = 1
    btn.MouseButton1Click:Connect(function() SwitchTab(btn, xPos, modName, fileName) end)
    return btn
end

local b1 = CreateTab("LOGS", 0, "LOGS", "LOGS.lua")
local b2 = CreateTab("LOCATIONS", 0.33, "LOCATIONS", "LOCATIONS.lua")
local b3 = CreateTab("RADIOACTIVE", 0.66, "RADIOACTIVE", "RADIOACTIVE.lua")

task.wait(0.2)
SwitchTab(b1, 0, "LOGS", "LOGS.lua")
