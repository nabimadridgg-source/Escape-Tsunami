-- Host this as Category_Places.lua
return function(ParentFrame)
    ParentFrame:ClearAllChildren()
    
    local PlaceContent = Instance.new("ScrollingFrame", ParentFrame)
    PlaceContent.Size = UDim2.new(1, 0, 1, 0)
    PlaceContent.BackgroundTransparency = 1
    PlaceContent.ScrollBarThickness = 0

    local UIGridPlace = Instance.new("UIGridLayout", PlaceContent)
    UIGridPlace.CellSize = UDim2.new(0.5, -5, 0, 35)
    UIGridPlace.CellPadding = UDim2.new(0, 10, 0, 10)

    local CFRAMES = {
        {Name = "COMMON",    CFrame = CFrame.new(204.014389, -2.81910014, -9.21708488)},
        {Name = "UNCOMMON",  CFrame = CFrame.new(289.720459, -2.81910038, 8.36070633)},
        {Name = "RARE",      CFrame = CFrame.new(401.519135, -2.8190999, 4.04100323)},
        {Name = "EPIC",      CFrame = CFrame.new(545.758545, -2.8190999, 3.98888278)},
        {Name = "LEGENDARY", CFrame = CFrame.new(756.261536, -2.81909966, -4.54531384)},
        {Name = "MYTHICAL",  CFrame = CFrame.new(1072.44043, -2.81910014, 3.19335699)},
        {Name = "CELESTIAL", CFrame = CFrame.new(1543.58447, -2.81909919, 13.7872305)},
        {Name = "SECRET",    CFrame = CFrame.new(2247.1665, -2.81909966, -33.8198471)},
        {Name = "NEW",       CFrame = CFrame.new(2585.66602, -2.8190999, -13.4220934)}
    }

    for _, data in ipairs(CFRAMES) do
        local btn = Instance.new("TextButton", PlaceContent)
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.Text = data.Name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        Instance.new("UICorner", btn)
        
        local s = Instance.new("UIStroke", btn)
        s.Color = Color3.fromRGB(30, 30, 35)
        
        btn.MouseButton1Click:Connect(function() 
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - data.CFrame.Position).Magnitude
                game:GetService("TweenService"):Create(hrp, TweenInfo.new(dist/150, Enum.EasingStyle.Linear), {CFrame = data.CFrame}):Play()
            end
        end)
    end
end
