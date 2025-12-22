--[[
    🎄 MM2 ULTIMATE CHRISTMAS HUB - FINAL REPAIR 🎅
    UI: "Frosty Red Gift"
    Logic: Remote-Based Stats (Fixes CPH/Reset), Aggressive ESP
]]

-- 1. SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- 2. VARIABLES
local Settings = {
    AutoFarmCoins = false,
    AutoFarmCandy = false,
    FarmSpeed = 22,
    AntiAfk = false,
    AutoReset = false,
    EspEnabled = false,
    KillAll = false,
    KillBind = Enum.KeyCode.T,
    AutoGrabGun = false,
    AttackDelay = 0.5,
    -- Misc
    WalkSpeed = 16,
    JumpPower = 50,
    wsLocked = false,
    jpLocked = false
}

local Stats = {
    StartTime = tick(),
    Collected = 0,
    CPH = 0,
    Bag = 0,
    MaxBag = 40 -- Default (upravi sa ak mas gamepass)
}

local Colors = {
    DeepRed = Color3.fromRGB(160, 0, 20),
    BrightRed = Color3.fromRGB(255, 40, 60),
    SnowWhite = Color3.fromRGB(240, 248, 255),
    Gold = Color3.fromRGB(255, 223, 0),
    Green = Color3.fromRGB(46, 204, 113)
}

-- 3. GAME REMOTES (CRITICAL FIX FOR STATS & RESET)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Gameplay = Remotes:WaitForChild("Gameplay")
local CoinCollected = Gameplay:WaitForChild("CoinCollected")

-- Listener na coiny (Toto opravuje CPH a Auto Reset)
CoinCollected.OnClientEvent:Connect(function(coinType, newAmount, oldAmount)
    Stats.Collected = Stats.Collected + 1
    Stats.Bag = newAmount
    
    -- Auto Reset Logic
    if Settings.AutoReset and Stats.Bag >= Stats.MaxBag then
        if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
    end
end)

-- Check Gamepass (Max Bag)
task.spawn(function()
    local s, has = pcall(function() return game:GetService("MarketplaceService"):UserOwnsGamePassAsync(LocalPlayer.UserId, 429957) end)
    if s and has then Stats.MaxBag = 50 else Stats.MaxBag = 40 end
end)

-- 4. UI CONSTRUCTION
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2SantaFinalFix"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Colors.DeepRed
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner"); UICorner.CornerRadius = UDim.new(0, 16); UICorner.Parent = MainFrame
local UIStroke = Instance.new("UIStroke"); UIStroke.Color = Colors.SnowWhite; UIStroke.Thickness = 3; UIStroke.Parent = MainFrame; UIStroke.Transparency = 0.2
local BgGradient = Instance.new("UIGradient"); BgGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Colors.BrightRed), ColorSequenceKeypoint.new(1, Colors.DeepRed)}; BgGradient.Rotation = 45; BgGradient.Parent = MainFrame

-- Snow
task.spawn(function()
    while true do
        if MainFrame.Visible then
            local flake = Instance.new("Frame"); flake.Parent = MainFrame; flake.BackgroundColor3 = Colors.SnowWhite; flake.BorderSizePixel = 0
            local size = math.random(2, 5); flake.Size = UDim2.new(0, size, 0, size); flake.Position = UDim2.new(math.random(), 0, -0.1, 0); flake.BackgroundTransparency = math.random(3, 7) / 10
            local fCorner = Instance.new("UICorner"); fCorner.CornerRadius = UDim.new(1,0); fCorner.Parent = flake
            local tween = TweenService:Create(flake, TweenInfo.new(math.random(2, 5), Enum.EasingStyle.Linear), {Position = UDim2.new(flake.Position.X.Scale + (math.random(-2,2)/10), 0, 1.1, 0), BackgroundTransparency = 1}); tween:Play()
            game:GetService("Debris"):AddItem(flake, 5)
        end
        wait(0.2)
    end
end)

-- Dragging
local Title = Instance.new("TextLabel"); Title.Parent = MainFrame; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 0, 0, 10); Title.Size = UDim2.new(1, 0, 0, 30); Title.Font = Enum.Font.FredokaOne; Title.Text = "🎄 VOFFLAN'S HUB 🎅"; Title.TextColor3 = Colors.SnowWhite; Title.TextSize = 24; Title.TextStrokeTransparency = 0.8
local dragging, dragInput, dragStart, startPos
local function update(input) local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end
MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = MainFrame.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then if dragging then update(input) end end end)

-- Tabs
local TabContainer = Instance.new("ScrollingFrame"); TabContainer.Parent = MainFrame; TabContainer.BackgroundTransparency = 1; TabContainer.Position = UDim2.new(0, 10, 0, 50); TabContainer.Size = UDim2.new(1, -20, 0, 35); TabContainer.CanvasSize = UDim2.new(1.5, 0, 0, 0); TabContainer.ScrollBarThickness = 2
local TabListLayout = Instance.new("UIListLayout"); TabListLayout.Parent = TabContainer; TabListLayout.FillDirection = Enum.FillDirection.Horizontal; TabListLayout.Padding = UDim.new(0, 5)
local ContentContainer = Instance.new("ScrollingFrame"); ContentContainer.Parent = MainFrame; ContentContainer.BackgroundTransparency = 1; ContentContainer.Position = UDim2.new(0, 10, 0, 95); ContentContainer.Size = UDim2.new(1, -20, 1, -165); ContentContainer.ScrollBarThickness = 2; ContentContainer.ScrollBarImageColor3 = Colors.SnowWhite
local UIListLayout = Instance.new("UIListLayout"); UIListLayout.Parent = ContentContainer; UIListLayout.Padding = UDim.new(0, 8); UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Elements = {}
local function RefreshTabs(selectedTab) for _, el in pairs(Elements) do el.Frame.Visible = (el.Tab == selectedTab) end end
local function CreateTabBtn(text)
    local Btn = Instance.new("TextButton"); Btn.Parent = TabContainer; Btn.BackgroundColor3 = Colors.SnowWhite; Btn.BackgroundTransparency = 0.8; Btn.Size = UDim2.new(0, 80, 1, 0); Btn.Font = Enum.Font.GothamBold; Btn.Text = text; Btn.TextColor3 = Colors.SnowWhite; Btn.TextSize = 12
    local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 6); Corner.Parent = Btn
    Btn.MouseButton1Click:Connect(function() for _, c in pairs(TabContainer:GetChildren()) do if c:IsA("TextButton") then c.BackgroundTransparency = 0.8 end end; Btn.BackgroundTransparency = 0.2; RefreshTabs(text) end)
    if text == "FARM" then Btn.BackgroundTransparency = 0.2 end
end
CreateTabBtn("FARM"); CreateTabBtn("COMBAT"); CreateTabBtn("FUN"); CreateTabBtn("VISUAL"); CreateTabBtn("TP/CHAR"); CreateTabBtn("MISC")

-- Component Creators
local function CreateButton(tabName, text, icon, callback)
    local Frame = Instance.new("Frame"); Frame.Parent = ContentContainer; Frame.BackgroundColor3 = Colors.SnowWhite; Frame.Size = UDim2.new(1, 0, 0, 40); Frame.Visible = (tabName == "FARM"); local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 8); Corner.Parent = Frame
    local IconLbl = Instance.new("TextLabel"); IconLbl.Parent = Frame; IconLbl.BackgroundTransparency = 1; IconLbl.Position = UDim2.new(0, 10, 0, 0); IconLbl.Size = UDim2.new(0, 30, 1, 0); IconLbl.Text = icon; IconLbl.TextSize = 18
    local TextLbl = Instance.new("TextLabel"); TextLbl.Parent = Frame; TextLbl.BackgroundTransparency = 1; TextLbl.Position = UDim2.new(0, 45, 0, 0); TextLbl.Size = UDim2.new(0.7, 0, 1, 0); TextLbl.Font = Enum.Font.GothamBold; TextLbl.Text = text; TextLbl.TextColor3 = Colors.DeepRed; TextLbl.TextSize = 13; TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    local Btn = Instance.new("TextButton"); Btn.Parent = Frame; Btn.BackgroundTransparency = 1; Btn.Size = UDim2.new(1, 0, 1, 0); Btn.Text = ""
    Btn.MouseButton1Click:Connect(function() TweenService:Create(Frame, TweenInfo.new(0.1), {Size = UDim2.new(0.95, 0, 0, 38)}):Play(); wait(0.1); TweenService:Create(Frame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40)}):Play(); callback() end)
    table.insert(Elements, {Tab = tabName, Frame = Frame})
    return Frame
end

local function CreateToggle(tabName, text, icon, callback)
    local Frame = CreateButton(tabName, text, icon, function() end); local Btn = Frame:FindFirstChild("TextButton")
    local Status = Instance.new("Frame"); Status.Parent = Frame; Status.BackgroundColor3 = Color3.fromRGB(200, 200, 200); Status.Position = UDim2.new(0.88, 0, 0.5, -6); Status.Size = UDim2.new(0, 12, 0, 12); local SCorner = Instance.new("UICorner"); SCorner.CornerRadius = UDim.new(1,0); SCorner.Parent = Status
    local enabled = false
    Btn.MouseButton1Click:Connect(function() enabled = not enabled; if enabled then TweenService:Create(Status, TweenInfo.new(0.3), {BackgroundColor3 = Colors.Green}):Play(); TweenService:Create(Frame:FindFirstChild("TextLabel", true), TweenInfo.new(0.3), {TextColor3 = Colors.Green}):Play() else TweenService:Create(Status, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play(); TweenService:Create(Frame:FindFirstChild("TextLabel", true), TweenInfo.new(0.3), {TextColor3 = Colors.DeepRed}):Play() end; callback(enabled) end)
    return Frame
end

local function CreateInput(tabName, placeholder, callback)
    local Frame = Instance.new("Frame"); Frame.Parent = ContentContainer; Frame.BackgroundColor3 = Colors.SnowWhite; Frame.Size = UDim2.new(1, 0, 0, 40); Frame.Visible = (tabName == "FARM"); local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 8); Corner.Parent = Frame
    local Box = Instance.new("TextBox"); Box.Parent = Frame; Box.BackgroundTransparency = 1; Box.Size = UDim2.new(1, -20, 1, 0); Box.Position = UDim2.new(0, 10, 0, 0); Box.Font = Enum.Font.Gotham; Box.PlaceholderText = placeholder; Box.Text = ""; Box.TextColor3 = Colors.DeepRed; Box.PlaceholderColor3 = Color3.fromRGB(150,150,150); Box.TextSize = 13
    Box.FocusLost:Connect(function() callback(Box.Text) end)
    table.insert(Elements, {Tab = tabName, Frame = Frame})
end

local function CreateSlider(tabName, text, min, max, default, callback)
    local Frame = Instance.new("Frame"); Frame.Parent = ContentContainer; Frame.BackgroundColor3 = Colors.SnowWhite; Frame.Size = UDim2.new(1, 0, 0, 50); Frame.Visible = (tabName == "FARM"); local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 8); Corner.Parent = Frame
    local TextLbl = Instance.new("TextLabel"); TextLbl.Parent = Frame; TextLbl.BackgroundTransparency = 1; TextLbl.Position = UDim2.new(0, 15, 0, 5); TextLbl.Size = UDim2.new(0.5, 0, 0, 20); TextLbl.Font = Enum.Font.GothamBold; TextLbl.Text = text; TextLbl.TextColor3 = Colors.DeepRed; TextLbl.TextSize = 13; TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    local ValLbl = Instance.new("TextLabel"); ValLbl.Parent = Frame; ValLbl.BackgroundTransparency = 1; ValLbl.Position = UDim2.new(0.8, 0, 0, 5); ValLbl.Size = UDim2.new(0.15, 0, 0, 20); ValLbl.Font = Enum.Font.GothamBold; ValLbl.Text = tostring(default); ValLbl.TextColor3 = Colors.DeepRed; ValLbl.TextSize = 13
    local SliderBar = Instance.new("Frame"); SliderBar.Parent = Frame; SliderBar.BackgroundColor3 = Color3.fromRGB(200, 200, 200); SliderBar.Position = UDim2.new(0.05, 0, 0.7, 0); SliderBar.Size = UDim2.new(0.9, 0, 0, 6); local BarCorner = Instance.new("UICorner"); BarCorner.CornerRadius = UDim.new(1,0); BarCorner.Parent = SliderBar
    local Fill = Instance.new("Frame"); Fill.Parent = SliderBar; Fill.BackgroundColor3 = Colors.Green; Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0); local FillCorner = Instance.new("UICorner"); FillCorner.CornerRadius = UDim.new(1,0); FillCorner.Parent = Fill
    local Trigger = Instance.new("TextButton"); Trigger.Parent = SliderBar; Trigger.BackgroundTransparency = 1; Trigger.Size = UDim2.new(1, 0, 1, 0); Trigger.Text = ""
    local dragging = false; Trigger.MouseButton1Down:Connect(function() dragging = true end); UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1); local val = math.floor(min + ((max - min) * pos)); Fill.Size = UDim2.new(pos, 0, 1, 0); ValLbl.Text = tostring(val); callback(val) end end)
    table.insert(Elements, {Tab = tabName, Frame = Frame})
end

local function CreateKeybind(tabName, text, defaultKey, callback)
    local Frame = CreateButton(tabName, text, "⌨️", function() end); local Btn = Frame:FindFirstChild("TextButton")
    local BindLbl = Instance.new("TextLabel"); BindLbl.Parent = Frame; BindLbl.BackgroundTransparency = 1; BindLbl.Position = UDim2.new(0.7, 0, 0, 0); BindLbl.Size = UDim2.new(0.25, 0, 1, 0); BindLbl.Font = Enum.Font.GothamBold; BindLbl.Text = "[" .. defaultKey.Name .. "]"; BindLbl.TextColor3 = Colors.DeepRed; BindLbl.TextSize = 12
    local binding = false; Btn.MouseButton1Click:Connect(function() binding = true; BindLbl.Text = "[...]"; BindLbl.TextColor3 = Colors.Green end)
    UserInputService.InputBegan:Connect(function(input) if binding and input.UserInputType == Enum.UserInputType.Keyboard then binding = false; BindLbl.Text = "[" .. input.KeyCode.Name .. "]"; BindLbl.TextColor3 = Colors.DeepRed; callback(input.KeyCode) end end)
    table.insert(Elements, {Tab = tabName, Frame = Frame})
end

-- // 5. FARM LOGIC //
local function getHRP() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getCoins()
    local targets = {}
    for _, m in pairs(Workspace:GetChildren()) do if m:FindFirstChild("CoinContainer") then for _, c in pairs(m.CoinContainer:GetChildren()) do if c:IsA("BasePart") and c:FindFirstChild("TouchInterest") then table.insert(targets, c) end end end end
    if #targets == 0 then for _, v in pairs(Workspace:GetDescendants()) do if v.Name == "Candy" and v:IsA("BasePart") then table.insert(targets, v) end end end
    return targets
end

-- == TABS POPULATION ==

-- TAB FARM
CreateToggle("FARM", "AUTO FARM COINS", "🎁", function(state)
    Settings.AutoFarmCoins = state
    if state then 
        Stats.StartTime = tick()
        task.spawn(function()
            local bg = Instance.new("BodyVelocity"); bg.Velocity = Vector3.new(0,0,0); bg.MaxForce = Vector3.new(100000, 100000, 100000)
            while Settings.AutoFarmCoins do
                local hrp = getHRP()
                if hrp then
                    if LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.PlatformStand = true end
                    if not hrp:FindFirstChild("FlingFix") then local b = bg:Clone(); b.Name = "FlingFix"; b.Parent = hrp end
                    
                    local coins = getCoins()
                    local nearest, minDst = nil, math.huge
                    for _, c in pairs(coins) do local d = (hrp.Position - c.Position).Magnitude; if d < minDst then minDst = d; nearest = c end end
                    
                    if nearest then
                        local targetPos = nearest.Position + Vector3.new(0, 3, 0)
                        local targetCFrame = CFrame.new(targetPos) * CFrame.Angles(math.rad(90), 0, 0)
                        local time = (hrp.Position - targetPos).Magnitude / Settings.FarmSpeed
                        local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = targetCFrame}); tween:Play()
                        
                        local arrived = false
                        local conn; conn = RunService.Heartbeat:Connect(function()
                            if not nearest.Parent then tween:Cancel(); conn:Disconnect(); arrived = true end
                            if (hrp.Position - nearest.Position).Magnitude < 6 then
                                firetouchinterest(hrp, nearest, 0); firetouchinterest(hrp, nearest, 1)
                                arrived = true; conn:Disconnect()
                            end
                        end)
                        repeat task.wait() until arrived or not Settings.AutoFarmCoins
                        if conn then conn:Disconnect() end
                    else
                        wait(0.5)
                    end
                end
                task.wait()
            end
            if getHRP() then getHRP().CFrame = CFrame.new(getHRP().Position + Vector3.new(0,2,0)); if getHRP():FindFirstChild("FlingFix") then getHRP().FlingFix:Destroy() end end
            if LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.PlatformStand = false end
        end)
    end
end)

CreateSlider("FARM", "Farm Speed", 10, 100, 22, function(val) Settings.FarmSpeed = val end)
CreateToggle("FARM", "ANTI-AFK", "❄️", function(state) Settings.AntiAfk = state end)
CreateToggle("FARM", "AUTO RESET CHAR (FULL BAG)", "💀", function(state) Settings.AutoReset = state end)

-- TAB COMBAT
CreateButton("COMBAT", "FLING MURDERER", "🌪️", function()
    local murderer = nil
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then murderer = p; break end end
    if murderer and murderer.Character then
        local bam = Instance.new("BodyAngularVelocity"); bam.Parent = LocalPlayer.Character.HumanoidRootPart; bam.AngularVelocity = Vector3.new(0,99999,0); bam.MaxTorque = Vector3.new(0,math.huge,0)
        local bv = Instance.new("BodyVelocity"); bv.Parent = LocalPlayer.Character.HumanoidRootPart; bv.Velocity = Vector3.new(0,0,0); bv.MaxForce = Vector3.new(0,0,0)
        local s = tick()
        while tick() - s < 2 and murderer.Character do if LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = murderer.Character.HumanoidRootPart.CFrame end; RunService.RenderStepped:Wait() end
        bam:Destroy(); bv:Destroy()
    end
end)

CreateToggle("COMBAT", "AUTO GRAB GUN", "🔫", function(state)
    Settings.AutoGrabGun = state
    task.spawn(function() while Settings.AutoGrabGun do local g = Workspace:FindFirstChild("GunDrop"); if g and getHRP() then getHRP().CFrame = g.CFrame end; wait(0.5) end end)
end)

CreateKeybind("COMBAT", "KILL BIND [T]", Settings.KillBind, function(newKey) Settings.KillBind = newKey end)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Settings.KillBind then
         local murderer = nil; for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then murderer = p; break end end
         if murderer and murderer.Character then
             local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
             if gun then gun.Parent = LocalPlayer.Character; local args = {[1] = 1, [2] = murderer.Character.HumanoidRootPart.Position, [3] = "AH2"}; if gun:FindFirstChild("KnifeLocal") then gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args)) end end
         end
    end
end)

-- TAB FUN
local SpawnWeaponName = ""
CreateInput("FUN", "Weapon Name (e.g. IceWing)", function(text) SpawnWeaponName = text end)
CreateButton("FUN", "SPAWN WEAPON", "✨", function() 
    local box = require(ReplicatedStorage.Modules.BoxModule)
    box.OpenBox("MysteryBox", SpawnWeaponName) 
end)

-- TAB VISUAL (ESP FIXED LOGIC)
CreateToggle("VISUAL", "ESP ENABLED", "👁️", function(state) Settings.EspEnabled = state end)
RunService.RenderStepped:Connect(function()
    if Settings.EspEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hl = plr.Character:FindFirstChild("XmasESP")
                if not hl then hl = Instance.new("Highlight", plr.Character); hl.Name = "XmasESP"; hl.FillTransparency = 0.5 end
                local col = Colors.Gold
                if plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife") then col = Color3.fromRGB(255,0,0)
                elseif plr.Backpack:FindFirstChild("Gun") or plr.Character:FindFirstChild("Gun") then col = Color3.fromRGB(0,255,0) end
                hl.FillColor = col; hl.OutlineColor = col
            end
        end
    else
        for _, plr in pairs(Players:GetPlayers()) do if plr.Character and plr.Character:FindFirstChild("XmasESP") then plr.Character.XmasESP:Destroy() end end
    end
end)

-- TAB TP
CreateButton("TP/CHAR", "TP TO LOBBY", "🏠", function() if getHRP() then getHRP().CFrame = CFrame.new(0, 10, 0) end end)
CreateButton("TP/CHAR", "TP TO MURDERER", "😈", function() for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then getHRP().CFrame = p.Character.HumanoidRootPart.CFrame end end end)

CreateSlider("TP/CHAR", "WalkSpeed", 16, 200, 16, function(val) Settings.WalkSpeed = val end)
CreateToggle("TP/CHAR", "LOCK SPEED", "🔒", function(state) Settings.wsLocked = state end)

task.spawn(function()
    while true do
        wait()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if Settings.wsLocked then LocalPlayer.Character.Humanoid.WalkSpeed = Settings.WalkSpeed end
        end
    end
end)

-- Stats Footer
local StatsPanel = Instance.new("Frame"); StatsPanel.Parent = MainFrame; StatsPanel.BackgroundColor3 = Color3.new(0,0,0); StatsPanel.BackgroundTransparency = 0.6; StatsPanel.Position = UDim2.new(0, 10, 1, -70); StatsPanel.Size = UDim2.new(1, -20, 0, 60); 
local SP_Corner = Instance.new("UICorner"); SP_Corner.CornerRadius = UDim.new(0, 10); SP_Corner.Parent = StatsPanel
local CPH_Display = Instance.new("TextLabel"); CPH_Display.Parent = StatsPanel; CPH_Display.BackgroundTransparency = 1; CPH_Display.Position = UDim2.new(0.05, 0, 0.1, 0); CPH_Display.Size = UDim2.new(0.9, 0, 0.4, 0); CPH_Display.Font = Enum.Font.GothamBold; CPH_Display.TextColor3 = Colors.Gold; CPH_Display.TextSize = 12; CPH_Display.TextXAlignment = Enum.TextXAlignment.Left; CPH_Display.Text = "💰 CPH: 0"
local Coll_Display = Instance.new("TextLabel"); Coll_Display.Parent = StatsPanel; Coll_Display.BackgroundTransparency = 1; Coll_Display.Position = UDim2.new(0.05, 0, 0.5, 0); Coll_Display.Size = UDim2.new(0.9, 0, 0.4, 0); Coll_Display.Font = Enum.Font.GothamBold; Coll_Display.TextColor3 = Colors.SnowWhite; Coll_Display.TextSize = 12; Coll_Display.TextXAlignment = Enum.TextXAlignment.Left; Coll_Display.Text = "🎒 Collected: 0"

task.spawn(function()
    while true do
        wait(1)
        if Settings.AutoFarmCoins then
            local elapsed = math.floor(tick() - Stats.StartTime)
            if elapsed > 0 then Stats.CPH = math.floor((Stats.Collected / elapsed) * 3600) end
            CPH_Display.Text = "💰 CPH: " .. Stats.CPH .. " | ⏱️ " .. string.format("%02d:%02d", math.floor(elapsed/60), elapsed%60)
            Coll_Display.Text = "🎒 Collected: " .. Stats.Collected .. " | Bag: " .. Stats.Bag .. "/" .. Stats.MaxBag
        end
    end
end)

-- Minimize
local MinBtn = Instance.new("ImageButton"); MinBtn.Parent = ScreenGui; MinBtn.Name = "OpenGift"; MinBtn.BackgroundColor3 = Colors.BrightRed; MinBtn.Position = UDim2.new(0, 20, 0.9, -20); MinBtn.Size = UDim2.new(0, 50, 0, 50)
local MCorner = Instance.new("UICorner"); MCorner.CornerRadius = UDim.new(1,0); MCorner.Parent = MinBtn
local OpenLbl = Instance.new("TextLabel"); OpenLbl.Parent = MinBtn; OpenLbl.BackgroundTransparency = 1; OpenLbl.Size = UDim2.new(1,0,1,0); OpenLbl.Text = "🎁"; OpenLbl.TextSize = 30
local visible = true
MinBtn.MouseButton1Click:Connect(function() visible = not visible; MainFrame.Visible = visible end)

print("🎅 Santa's Hub - STATS FIXED!")
