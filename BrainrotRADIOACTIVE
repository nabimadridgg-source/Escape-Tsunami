-- Host this as Category_Radioactive.lua
return function(ParentFrame)
    ParentFrame:ClearAllChildren()
    
    local Enabled = false
    local COIN_COLLECT_SPEED = 120 
    local MAX_RADIUS = 200 -- Only coins within 200 studs
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = game.Players.LocalPlayer

    -- [[ UI ELEMENT ]] --
    local ToggleBtn = Instance.new("TextButton", ParentFrame)
    ToggleBtn.Size = UDim2.new(0, 220, 0, 45)
    ToggleBtn.Position = UDim2.new(0.5,-110,0.4,-22)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,25)
    ToggleBtn.Text = "AUTO-COLLECT: OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255,50,50)
    ToggleBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", ToggleBtn)
    
    local st = Instance.new("UIStroke", ToggleBtn)
    st.Color = Color3.fromRGB(40,40,45)

    ToggleBtn.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        ToggleBtn.Text = "AUTO-COLLECT: " .. (Enabled and "ON" or "OFF")
        ToggleBtn.TextColor3 = Enabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    end)

    -- [[ HELPER: FIND NEAREST COIN ]] --
    local function GetNearestCoin()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local eventParts = workspace:FindFirstChild("EventParts")
        if not hrp or not eventParts then return nil end

        local nearestCoin = nil
        local shortestDistance = MAX_RADIUS -- Start at the max radius

        for _, coin in ipairs(eventParts:GetChildren()) do
            if coin:IsA("Model") then
                local pivot = coin:GetPivot()
                local distance = (hrp.Position - pivot.Position).Magnitude
                
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestCoin = coin
                end
            end
        end
        return nearestCoin
    end

    -- [[ COLLECTION LOGIC ]] --
    task.spawn(function()
        while ParentFrame and ParentFrame.Parent do
            if Enabled then
                local targetCoin = GetNearestCoin()
                
                if targetCoin then
                    pcall(function()
                        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local targetPivot = targetCoin:GetPivot()
                        local dist = (hrp.Position - targetPivot.Position).Magnitude
                        
                        local tween = TweenService:Create(hrp, TweenInfo.new(dist/COIN_COLLECT_SPEED, Enum.EasingStyle.Linear), {CFrame = targetPivot})
                        tween:Play()
                        tween.Completed:Wait()
                        task.wait(0.1) -- Wait for server to register collection
                    end)
                else
                    -- If no coin found in radius, wait a bit before checking again
                    task.wait(0.5)
                end
            end
            task.wait(0.1)
        end
    end)
end
