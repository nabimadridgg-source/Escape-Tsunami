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
local BASE_URL = "https://raw.githubusercontent.com/nabimadridgg-source/Escape-Tsunami/main/"

-- [[ UI ROOT ]] --
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "NabiHub_Final_Revised"
ScreenGui.ResetOnSpawn = false

-- [[ MINIMIZE ICON ]] --
local MiniIcon = Instance.new("TextButton", ScreenGui)
MiniIcon.Size = UDim2.new(0, 0, 0, 0)
MiniIcon.Position = UDim2.new(0, 20, 0.4, 0)
MiniIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniIcon.Text = "Nabi Hub"
MiniIcon.Font = Enum.Font.GothamBold
MiniIcon.TextColor3 = MAIN_COLOR
MiniIcon.Visible = false
MiniIcon.ClipsDescendants = true
Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(1, 0)

-- [[ MAIN FRAME ]] --
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = MainSize
MainFrame.Position = UDim2.new(0, 20, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame)

-- [[ HEADER & CLOSE ]] --
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0, 100, 0, 30); Title.Position = UDim2.new(0, 12, 0, 5); Title.BackgroundTransparency = 1
Title.Text = "NABI HUB"; Title.TextColor3 = MAIN_COLOR; Title.Font = Enum.Font.GothamBold; Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 18, 0, 18); CloseBtn.Position = UDim2.new(1, -24, 0, 8); CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"; CloseBtn.TextColor3 = Color3.new(1, 1, 1); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- [[ TAB UNDERLINE ]] --
local Underline = Instance.new("Frame", MainFrame)
Underline.Size = UDim2.new(0.33, -10, 0, 2)
Underline.Position = UDim2.new(0, 15, 0, 70)
Underline.BackgroundColor3 = MAIN_COLOR
Underline.BorderSizePixel = 0

-- [[ CONTENT AREA ]] --
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -85)
ContentFrame.Position = UDim2.new(0, 10, 0, 75)
ContentFrame.BackgroundTransparency = 1

-- [[ TOGGLE / HIDE LOGIC ]] --
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

-- [[ LOADING LOGIC ]] --
local Modules = {}

local function SwitchTab(underlineX, modName, fileName)
    ContentFrame:ClearAllChildren()
    TweenService:Create(Underline, TweenInfo.new(0.3), {Position = UDim2.new(0, underlineX + 15, 0, 70)}):Play()
    
    local status = Instance.new("TextLabel", ContentFrame)
    status.Size = UDim2.new(1,0,1,0); status.BackgroundTransparency=1; status.TextColor3=Color3.new(1,1,1); status.TextSize = 10; status.TextWrapped = true

    if Modules[modName] then
        status:Destroy()
        Modules[modName](ContentFrame)
    else
        status.Text = "Fetching " .. fileName .. "..."
        task.spawn(function()
            local success, code = pcall(function() return game:HttpGet(BASE_URL .. fileName) end)
            if success then
                if code:find("404: Not Found") or code:len() < 10 then
                    status.Text = "ERROR 404: File '" .. fileName .. "' not found. Check if the name matches exactly on GitHub (All Caps)!"
                    status.TextColor3 = Color3.new(1, 0.4, 0.4)
                else
                    local func, err = loadstring(code)
                    if func then
                        Modules[modName] = func()
                        status:Destroy()
                        Modules[modName](ContentFrame)
                    else
                        status.Text = "SYNTAX ERROR in " .. fileName .. ": " .. tostring(err)
                        status.TextColor3 = Color3.new(1, 1, 0)
                    end
                end
            else
                status.Text = "HTTP FAILED: Repo might be Private or URL is wrong."
                status.TextColor3 = Color3.new(1, 0, 0)
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
    b.Text = name; b.TextColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 1; b.Font = Enum.Font.GothamBold; b.TextSize = 8
    b.MouseButton1Click:Connect(function() SwitchTab(x * 330, mod, file) end)
end

CreateTab("LOGS", 0, "LOGS", "LOGS.lua")
CreateTab("LOCATIONS", 0.33, "LOCATIONS", "LOCATIONS.lua")
CreateTab("RADIOACTIVE", 0.66, "RADIOACTIVE", "RADIOACTIVE.lua")

-- Initial Load
task.wait(0.2)
SwitchTab(0, "LOGS", "LOGS.lua")
