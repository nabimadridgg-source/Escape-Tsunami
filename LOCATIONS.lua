-- File: PLACES.lua
return function(ParentFrame)
    ParentFrame:ClearAllChildren()
    
    local PlaceContent = Instance.new("ScrollingFrame", ParentFrame)
    PlaceContent.Size = UDim2.new(1, 0, 1, 0)
    PlaceContent.BackgroundTransparency = 1
    PlaceContent.ScrollBarThickness = 2
    PlaceContent.CanvasSize = UDim2.new(0, 0, 1.5, 0) -- Allows scrolling

    local UIGrid = Instance.new("UIGridLayout", PlaceContent)
    UIGrid.CellSize = UDim2.new(0.5, -5, 0, 35)
    UIGrid.CellPadding = UDim2.new(0, 10, 0, 10)

    local Locations = {
        {Name = "COMMON",    CF = CFrame.new(204, -2, -9)},
        {Name = "UNCOMMON",  CF = CFrame.new(290, -2, 8)},
        {Name = "RARE",      CF = CFrame.new(402, -2, 4)},
        {Name = "EPIC",      CF = CFrame.new(546, -2, 4)},
        {Name = "LEGENDARY", CF = CFrame.new(756, -2, -4)},
        {Name = "MYTHICAL",  CF = CFrame.new(1072, -2, 3)},
        {Name = "CELESTIAL", CF = CFrame.new(1544, -2, 14)},
        {Name = "SECRET",    CF = CFrame.new(2247, -2, -33)},
        {Name = "NEW AREA",  CF = CFrame.new(2585, -2, -13)}
    }

    local function Teleport(targetCF)
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dist = (hrp.Position - targetCF.Position).Magnitude
            -- Speed 150 studs per second
            game:GetService("TweenService"):Create(hrp, TweenInfo.new(dist/150, Enum.EasingStyle.Linear), {CFrame = targetCF}):Play()
        end
    end

    for _, data in ipairs(Locations) do
        local btn = Instance.new("TextButton", PlaceContent)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        btn.Text = data.Name
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        Instance.new("UICorner", btn)
        
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(40, 40, 45)
        
        btn.MouseButton1Click:Connect(function()
            Teleport(data.CF)
        end)
    end
end
