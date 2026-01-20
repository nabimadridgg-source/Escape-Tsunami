-- Host this as Category_Brainrot.lua
return function(ParentFrame)
    ParentFrame:ClearAllChildren()
    
    local LogContent = Instance.new("ScrollingFrame", ParentFrame)
    LogContent.Size = UDim2.new(1, 0, 1, 0)
    LogContent.BackgroundTransparency = 1
    LogContent.ScrollBarThickness = 0
    
    local UIList = Instance.new("UIListLayout", LogContent)
    UIList.Padding = UDim.new(0, 5)

    local function ParseMoney(str)
        local clean = str:gsub("[%(%)]", ""):gsub("/s", ""):lower()
        local num = tonumber(clean:match("[%d%.]+")) or 0
        if clean:find("k") then num = num * 1000 elseif clean:find("m") then num = num * 1000000 elseif clean:find("b") then num = num * 1000000000 end
        return num
    end

    local function UpdateList()
        if not ParentFrame or not ParentFrame.Parent then return end
        local dataList = {}
        local secretFolder = workspace:FindFirstChild("ActiveBrainrots") and workspace.ActiveBrainrots:FindFirstChild("Secret")
        if not secretFolder then return end

        for _, rb in pairs(secretFolder:GetChildren()) do
            local model = rb:FindFirstChildWhichIsA("Model")
            local frame = model and model:FindFirstChild("ModelExtents") and model.ModelExtents:FindFirstChild("StatsGui") and model.ModelExtents.StatsGui:FindFirstChild("Frame")
            if frame then
                local tL = rb:FindFirstChild("Root") and rb.Root:FindFirstChild("TimerGui") and rb.Root.TimerGui:FindFirstChild("TimeLeft") and rb.Root.TimerGui.TimeLeft:FindFirstChild("TimeLeft")
                table.insert(dataList, { Instance = rb, Name = frame.BrainrotName.Text, Rate = frame.Rate.Text, Time = tL and tL.Text or "--:--", Val = ParseMoney(frame.Rate.Text) })
            end
        end

        table.sort(dataList, function(a, b) return a.Val > b.Val end)
        
        for _, v in pairs(LogContent:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
        
        for i, d in ipairs(dataList) do
            local E = Instance.new("Frame", LogContent)
            E.Size = UDim2.new(1,-5,0,32)
            E.BackgroundColor3 = (i==1) and Color3.fromRGB(35,30,15) or Color3.fromRGB(22,22,27)
            Instance.new("UICorner", E)

            local n = Instance.new("TextLabel", E)
            n.Size = UDim2.new(0.3,0,1,0); n.Position = UDim2.new(0,8,0,0); n.BackgroundTransparency=1; n.Text=d.Name; n.TextColor3=Color3.new(1,1,1); n.Font=Enum.Font.GothamMedium; n.TextSize=8; n.TextXAlignment=Enum.TextXAlignment.Left
            
            local r = Instance.new("TextLabel", E)
            r.Size = UDim2.new(0.25,0,1,0); r.Position = UDim2.new(0.3,5,0,0); r.BackgroundTransparency=1; r.Text=d.Rate; r.TextColor3=(i==1) and Color3.new(1,0.8,0) or Color3.new(0,1,0.6); r.Font=Enum.Font.GothamBold; r.TextSize=9; r.TextXAlignment=Enum.TextXAlignment.Left
            
            local tm = Instance.new("TextLabel", E)
            tm.Size = UDim2.new(0.2,0,1,0); tm.Position = UDim2.new(0.55,5,0,0); tm.BackgroundTransparency=1; tm.Text=d.Time; tm.TextColor3=Color3.new(0,0.8,1); tm.Font=Enum.Font.Code; tm.TextSize=9
            
            local tp = Instance.new("TextButton", E)
            tp.Size = UDim2.new(0,35,0,20); tp.Position = UDim2.new(0.85,-5,0.5,-10); tp.BackgroundColor3=Color3.new(0,0.4,1); tp.Text="TP"; tp.TextColor3=Color3.new(1,1,1); tp.Font=Enum.Font.GothamBold; tp.TextSize=9; Instance.new("UICorner", tp)
            
            tp.MouseButton1Click:Connect(function() 
                local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") 
                if h then h.CFrame = d.Instance:GetPivot() * CFrame.new(0,5,0) end 
            end)
        end
        LogContent.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
    end

    task.spawn(function()
        while ParentFrame and ParentFrame.Parent do
            pcall(UpdateList)
            task.wait(1.5)
        end
    end)
end
