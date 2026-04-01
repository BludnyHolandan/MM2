--[[
    🐰 MM2 ULTIMATE EASTER HUB 2026 🥚
    UI: "Premium Dark Easter" - MOBILE FRIENDLY COMPACT EDITION 📱
    Logic: Remote-Based Stats, Aggressive ESP
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
local Debris = game:GetService("Debris")

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
    WalkSpeed = 16,
    JumpPower = 50,
    wsLocked = false,
    jpLocked = false
}

local Stats = { StartTime = tick(), Collected = 0, CPH = 0, Bag = 0, MaxBag = 40 }

-- 🎨 PREMIUM DARK EASTER PALETTE 🎨
local Colors = {
    Background = Color3.fromRGB(26, 26, 34),
    PanelBg = Color3.fromRGB(35, 35, 45),
    TextWhite = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 190),
    AccentPurple = Color3.fromRGB(180, 150, 255),
    AccentGreen = Color3.fromRGB(110, 230, 150),
    EggPink = Color3.fromRGB(255, 170, 200),
    EggBlue = Color3.fromRGB(150, 210, 255),
    DangerRed = Color3.fromRGB(255, 90, 90)
}

-- 3. GAME REMOTES
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Gameplay = Remotes:WaitForChild("Gameplay")
local CoinCollected = Gameplay:WaitForChild("CoinCollected")

CoinCollected.OnClientEvent:Connect(function(coinType, newAmount, oldAmount)
    Stats.Collected = Stats.Collected + 1
    Stats.Bag = newAmount
    if Settings.AutoReset and Stats.Bag >= Stats.MaxBag then
        if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
    end
end)

task.spawn(function()
    local s, has = pcall(function() return game:GetService("MarketplaceService"):UserOwnsGamePassAsync(LocalPlayer.UserId, 429957) end)
    if s and has then Stats.MaxBag = 50 else Stats.MaxBag = 40 end
end)

-- 4. UI CONSTRUCTION (MOBILE SIZED)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2EasterMobile"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -135)
MainFrame.Size = UDim2.new(0, 360, 0, 270) -- Ovela menšia výška! (Z 450 na 270)
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner"); UICorner.CornerRadius = UDim.new(0, 10); UICorner.Parent = MainFrame
local UIStroke = Instance.new("UIStroke"); UIStroke.Color = Colors.AccentPurple; UIStroke.Thickness = 2; UIStroke.Parent = MainFrame; UIStroke.Transparency = 0.5

-- 🥚 SUBTLE FALLING EGGS
local EggColors = {Colors.EggPink, Colors.AccentPurple, Colors.EggBlue, Colors.AccentGreen}
task.spawn(function()
    while true do
        if MainFrame.Visible then
            local egg = Instance.new("Frame"); egg.Parent = MainFrame; egg.ZIndex = 0; egg.BackgroundColor3 = EggColors[math.random(1, #EggColors)]; egg.BorderSizePixel = 0
            local size = math.random(5, 9); egg.Size = UDim2.new(0, size, 0, size * 1.3); egg.Position = UDim2.new(math.random(), 0, -0.1, 0); egg.BackgroundTransparency = 0.85
            egg.Rotation = math.random(-20, 20); local fCorner = Instance.new("UICorner"); fCorner.CornerRadius = UDim.new(0.5, 0); fCorner.Parent = egg
            local tween = TweenService:Create(egg, TweenInfo.new(math.random(4, 8), Enum.EasingStyle.Linear), {Position = UDim2.new(egg.Position.X.Scale + (math.random(-1,1)/10), 0, 1.1, 0), Rotation = egg.Rotation + math.random(-30, 30)})
            tween:Play(); Debris:AddItem(egg, 8)
        end
        wait(0.3)
    end
end)

-- Dragging & Titles
local Title = Instance.new("TextLabel"); Title.Parent = MainFrame; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 0, 0, 5); Title.Size = UDim2.new(1, 0, 0, 20); Title.Font = Enum.Font.GothamBlack; Title.Text = "🐰 VOFFLAN HUB 🌸"; Title.TextColor3 = Colors.TextWhite; Title.TextSize = 16
local SubTitle = Instance.new("TextLabel"); SubTitle.Parent = MainFrame; SubTitle.BackgroundTransparency = 1; SubTitle.Position = UDim2.new(0, 0, 0, 22); SubTitle.Size = UDim2.new(1, 0, 0, 12); SubTitle.Font = Enum.Font.GothamBold; SubTitle.Text = "✨ EASTER EVENT 2026 ✨"; SubTitle.TextColor3 = Colors.AccentPurple; SubTitle.TextSize = 10

local dragging, dragInput, dragStart, startPos
local function update(input) local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end
MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = MainFrame.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then if dragging then update(input) end end end)

-- Tabs (Compact)
local TabContainer = Instance.new("ScrollingFrame"); TabContainer.Parent = MainFrame; TabContainer.BackgroundTransparency = 1; TabContainer.Position = UDim2.new(0, 10, 0, 38); TabContainer.Size = UDim2.new(1, -20, 0, 28); TabContainer.CanvasSize = UDim2.new(1.5, 0, 0, 0); TabContainer.ScrollBarThickness = 0
local TabListLayout = Instance.new("UIListLayout"); TabListLayout.Parent = TabContainer; TabListLayout.FillDirection = Enum.FillDirection.Horizontal; TabListLayout.Padding = UDim.new(0, 5)

-- Content Area
local ContentContainer = Instance.new("ScrollingFrame"); ContentContainer.Parent = MainFrame; ContentContainer.BackgroundTransparency = 1; ContentContainer.Position = UDim2.new(0, 10, 0, 72); ContentContainer.Size = UDim2.new(1, -20, 1, -122); ContentContainer.ScrollBarThickness = 2; ContentContainer.ScrollBarImageColor3 = Colors.AccentPurple
local UIListLayout = Instance.new("UIListLayout"); UIListLayout.Parent = ContentContainer; UIListLayout.Padding = UDim.new(0, 6); UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Elements = {}
local function RefreshTabs(selectedTab) for _, el in pairs(Elements) do el.Frame.Visible = (el.Tab == selectedTab) end end
local function CreateTabBtn(text)
    local Btn = Instance.new("TextButton"); Btn.Parent = TabContainer; Btn.BackgroundColor3 = Colors.PanelBg; Btn.BorderSizePixel = 0; Btn.Size = UDim2.new(0, 75, 1, 0); Btn.Font = Enum.Font.GothamBold; Btn.Text = text; Btn.TextColor3 = Colors.SubText; Btn.TextSize = 11
    local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 5); Corner.Parent = Btn
    local BStroke = Instance.new("UIStroke"); BStroke.Color = Colors.AccentPurple; BStroke.Thickness = 1; BStroke.Parent = Btn; BStroke.Transparency = 1
    
    Btn.MouseButton1Click:Connect(function() 
        for _, c in pairs(TabContainer:GetChildren()) do if c:IsA("TextButton") then c.BackgroundColor3 = Colors.PanelBg; c.TextColor3 = Colors.SubText; c:FindFirstChild("UIStroke").Transparency = 1 end end
        Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60); Btn.TextColor3 = Colors.TextWhite; BStroke.Transparency = 0
        RefreshTabs(text) 
    end)
    if text == "EASTER" then Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60); Btn.TextColor3 = Colors.TextWhite; BStroke.Transparency = 0 end
end

CreateTabBtn("EASTER"); CreateTabBtn("PVP"); CreateTabBtn("FUN"); CreateTabBtn("VISUAL"); CreateTabBtn("TP"); CreateTabBtn("MISC")

-- Component Creators (Smaller Heights)
local function CreateButton(tabName, text, icon, callback)
    local Frame = Instance.new("Frame"); Frame.Parent = ContentContainer; Frame.BackgroundColor3 = Colors.PanelBg; Frame.Size = UDim2.new(1, 0, 0, 35); Frame.Visible = (tabName == "EASTER"); local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 6); Corner.Parent = Frame
    local IconLbl = Instance.new("TextLabel"); IconLbl.Parent = Frame; IconLbl.BackgroundTransparency = 1; IconLbl.Position = UDim2.new(0, 8, 0, 0); IconLbl.Size = UDim2.new(0, 25, 1, 0); IconLbl.Text = icon; IconLbl.TextSize = 16
    local TextLbl = Instance.new("TextLabel"); TextLbl.Parent = Frame; TextLbl.BackgroundTransparency = 1; TextLbl.Position = UDim2.new(0, 38, 0, 0); TextLbl.Size = UDim2.new(0.7, 0, 1, 0); TextLbl.Font = Enum.Font.GothamMedium; TextLbl.Text = text; TextLbl.TextColor3 = Colors.TextWhite; TextLbl.TextSize = 12; TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    local Btn = Instance.new("TextButton"); Btn.Parent = Frame; Btn.BackgroundTransparency = 1; Btn.Size = UDim2.new(1, 0, 1, 0); Btn.Text = ""
    Btn.MouseButton1Click:Connect(function() TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(55, 55, 70)}):Play(); wait(0.1); TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundColor3 = Colors.PanelBg}):Play(); callback() end)
    table.insert(Elements, {Tab = tabName, Frame = Frame}); return Frame
end

local function CreateToggle(tabName, text, icon, callback)
    local Frame = CreateButton(tabName, text, icon, function() end); local Btn = Frame:FindFirstChild("TextButton")
    local Status = Instance.new("Frame"); Status.Parent = Frame; Status.BackgroundColor3 = Color3.fromRGB(60, 60, 75); Status.Position = UDim2.new(0.88, 0, 0.5, -5); Status.Size = UDim2.new(0, 10, 0, 10); local SCorner = Instance.new("UICorner"); SCorner.CornerRadius = UDim.new(1,0); SCorner.Parent = Status
    local enabled = false
    Btn.MouseButton1Click:Connect(function() 
        enabled = not enabled
        if enabled then TweenService:Create(Status, TweenInfo.new(0.3), {BackgroundColor3 = Colors.AccentGreen}):Play(); TweenService:Create(Frame:FindFirstChild("TextLabel", true), TweenInfo.new(0.3), {TextColor3 = Colors.AccentGreen}):Play()
        else TweenService:Create(Status, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 60, 75)}):Play(); TweenService:Create(Frame:FindFirstChild("TextLabel", true), TweenInfo.new(0.3), {TextColor3 = Colors.TextWhite}):Play() end
        callback(enabled) 
    end); return Frame
end

local function CreateInput(tabName, placeholder, callback)
    local Frame = Instance.new("Frame"); Frame.Parent = ContentContainer; Frame.BackgroundColor3 = Colors.PanelBg; Frame.Size = UDim2.new(1, 0, 0, 35); Frame.Visible = (tabName == "EASTER"); local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 6); Corner.Parent = Frame
    local Box = Instance.new("TextBox"); Box.Parent = Frame; Box.BackgroundTransparency = 1; Box.Size = UDim2.new(1, -16, 1, 0); Box.Position = UDim2.new(0, 8, 0, 0); Box.Font = Enum.Font.Gotham; Box.PlaceholderText = placeholder; Box.Text = ""; Box.TextColor3 = Colors.TextWhite; Box.PlaceholderColor3 = Colors.SubText; Box.TextSize = 12
    Box.FocusLost:Connect(function() callback(Box.Text) end); table.insert(Elements, {Tab = tabName, Frame = Frame})
end

local function CreateSlider(tabName, text, min, max, default, callback)
    local Frame = Instance.new("Frame"); Frame.Parent = ContentContainer; Frame.BackgroundColor3 = Colors.PanelBg; Frame.Size = UDim2.new(1, 0, 0, 45); Frame.Visible = (tabName == "EASTER"); local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 6); Corner.Parent = Frame
    local TextLbl = Instance.new("TextLabel"); TextLbl.Parent = Frame; TextLbl.BackgroundTransparency = 1; TextLbl.Position = UDim2.new(0, 10, 0, 2); TextLbl.Size = UDim2.new(0.5, 0, 0, 18); TextLbl.Font = Enum.Font.GothamMedium; TextLbl.Text = text; TextLbl.TextColor3 = Colors.TextWhite; TextLbl.TextSize = 12; TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    local ValLbl = Instance.new("TextLabel"); ValLbl.Parent = Frame; ValLbl.BackgroundTransparency = 1; ValLbl.Position = UDim2.new(0.8, 0, 0, 2); ValLbl.Size = UDim2.new(0.15, 0, 0, 18); ValLbl.Font = Enum.Font.GothamBold; ValLbl.Text = tostring(default); ValLbl.TextColor3 = Colors.AccentPurple; ValLbl.TextSize = 12
    local SliderBar = Instance.new("Frame"); SliderBar.Parent = Frame; SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 75); SliderBar.Position = UDim2.new(0.05, 0, 0.65, 0); SliderBar.Size = UDim2.new(0.9, 0, 0, 5); local BarCorner = Instance.new("UICorner"); BarCorner.CornerRadius = UDim.new(1,0); BarCorner.Parent = SliderBar
    local Fill = Instance.new("Frame"); Fill.Parent = SliderBar; Fill.BackgroundColor3 = Colors.AccentPurple; Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0); local FillCorner = Instance.new("UICorner"); FillCorner.CornerRadius = UDim.new(1,0); FillCorner.Parent = Fill
    local Trigger = Instance.new("TextButton"); Trigger.Parent = SliderBar; Trigger.BackgroundTransparency = 1; Trigger.Size = UDim2.new(1, 0, 1, 0); Trigger.Text = ""
    local dragging = false; Trigger.MouseButton1Down:Connect(function() dragging = true end); UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1); local val = math.floor(min + ((max - min) * pos)); Fill.Size = UDim2.new(pos, 0, 1, 0); ValLbl.Text = tostring(val); callback(val) end end)
    table.insert(Elements, {Tab = tabName, Frame = Frame})
end

local function CreateKeybind(tabName, text, defaultKey, callback)
    local Frame = CreateButton(tabName, text, "⌨️", function() end); local Btn = Frame:FindFirstChild("TextButton")
    local BindLbl = Instance.new("TextLabel"); BindLbl.Parent = Frame; BindLbl.BackgroundTransparency = 1; BindLbl.Position = UDim2.new(0.7, 0, 0, 0); BindLbl.Size = UDim2.new(0.25, 0, 1, 0); BindLbl.Font = Enum.Font.GothamBold; BindLbl.Text = "[" .. defaultKey.Name .. "]"; BindLbl.TextColor3 = Colors.SubText; BindLbl.TextSize = 11
    local binding = false; Btn.MouseButton1Click:Connect(function() binding = true; BindLbl.Text = "[...]"; BindLbl.TextColor3 = Colors.AccentGreen end)
    UserInputService.InputBegan:Connect(function(input) if binding and input.UserInputType == Enum.UserInputType.Keyboard then binding = false; BindLbl.Text = "[" .. input.KeyCode.Name .. "]"; BindLbl.TextColor3 = Colors.AccentPurple; callback(input.KeyCode) end end)
    table.insert(Elements, {Tab = tabName, Frame = Frame})
end

-- // 5. FARM LOGIC //
local function getHRP() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getCoins()
    local targets = {}
    for _, m in pairs(Workspace:GetChildren()) do if m:FindFirstChild("CoinContainer") then for _, c in pairs(m.CoinContainer:GetChildren()) do if c:IsA("BasePart") and c:FindFirstChild("TouchInterest") then table.insert(targets, c) end end end end
    if #targets == 0 then for _, v in pairs(Workspace:GetDescendants()) do if (v.Name == "Candy" or v.Name == "Egg" or v.Name == "EasterEgg") and v:IsA("BasePart") then table.insert(targets, v) end end end
    return targets
end

-- == TABS POPULATION ==
CreateToggle("EASTER", "AUTO FARM COINS/EGGS", "🥚", function(state)
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
                    
                    local coins = getCoins(); local nearest, minDst = nil, math.huge
                    for _, c in pairs(coins) do local d = (hrp.Position - c.Position).Magnitude; if d < minDst then minDst = d; nearest = c end end
                    
                    if nearest then
                        local targetPos = nearest.Position + Vector3.new(0, 3, 0); local targetCFrame = CFrame.new(targetPos) * CFrame.Angles(math.rad(90), 0, 0)
                        local tween = TweenService:Create(hrp, TweenInfo.new((hrp.Position - targetPos).Magnitude / Settings.FarmSpeed, Enum.EasingStyle.Linear), {CFrame = targetCFrame}); tween:Play()
                        local arrived = false; local conn; conn = RunService.Heartbeat:Connect(function()
                            if not nearest.Parent then tween:Cancel(); conn:Disconnect(); arrived = true end
                            if (hrp.Position - nearest.Position).Magnitude < 6 then firetouchinterest(hrp, nearest, 0); firetouchinterest(hrp, nearest, 1); arrived = true; conn:Disconnect() end
                        end)
                        repeat task.wait() until arrived or not Settings.AutoFarmCoins
                        if conn then conn:Disconnect() end
                    else wait(0.5) end
                end
                task.wait()
            end
            if getHRP() then getHRP().CFrame = CFrame.new(getHRP().Position + Vector3.new(0,2,0)); if getHRP():FindFirstChild("FlingFix") then getHRP().FlingFix:Destroy() end end
            if LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.PlatformStand = false end
        end)
    end
end)

CreateSlider("EASTER", "Farm Speed", 10, 100, 22, function(val) Settings.FarmSpeed = val end)
CreateToggle("EASTER", "ANTI-AFK", "🐇", function(state) Settings.AntiAfk = state end)
CreateToggle("EASTER", "AUTO RESET (FULL BAG)", "🌸", function(state) Settings.AutoReset = state end)

CreateButton("PVP", "FLING MURDERER", "🌪️", function()
    local murderer = nil; for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then murderer = p; break end end
    if murderer and murderer.Character then
        local bam = Instance.new("BodyAngularVelocity"); bam.Parent = LocalPlayer.Character.HumanoidRootPart; bam.AngularVelocity = Vector3.new(0,99999,0); bam.MaxTorque = Vector3.new(0,math.huge,0)
        local bv = Instance.new("BodyVelocity"); bv.Parent = LocalPlayer.Character.HumanoidRootPart; bv.Velocity = Vector3.new(0,0,0); bv.MaxForce = Vector3.new(0,0,0)
        local s = tick(); while tick() - s < 2 and murderer.Character do if LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = murderer.Character.HumanoidRootPart.CFrame end; RunService.RenderStepped:Wait() end
        bam:Destroy(); bv:Destroy()
    end
end)
CreateToggle("PVP", "KILL ALL (Murderer)", "🔪", function(state) Settings.KillAll = state; if state then task.spawn(function() while Settings.KillAll do local hasKnife = LocalPlayer.Character:FindFirstChild("Knife"); if hasKnife then for _, target in pairs(Players:GetPlayers()) do if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then local hrp = getHRP(); if hrp then hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2); hasKnife:Activate(); wait(Settings.AttackDelay) end end end end; wait(0.1) end end) end end)
CreateToggle("PVP", "AUTO GRAB GUN", "🔫", function(state) Settings.AutoGrabGun = state; task.spawn(function() while Settings.AutoGrabGun do local g = Workspace:FindFirstChild("GunDrop"); if g and getHRP() then getHRP().CFrame = g.CFrame end; wait(0.5) end end) end)
CreateKeybind("PVP", "KILL BIND [T]", Settings.KillBind, function(newKey) Settings.KillBind = newKey end)
UserInputService.InputBegan:Connect(function(input, processed) if not processed and input.KeyCode == Settings.KillBind then local murderer = nil; for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then murderer = p; break end end; if murderer and murderer.Character then local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun"); if gun then gun.Parent = LocalPlayer.Character; local args = {[1] = 1, [2] = murderer.Character.HumanoidRootPart.Position, [3] = "AH2"}; if gun:FindFirstChild("KnifeLocal") then gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args)) end end end end end)

local SpawnWeaponName = ""
CreateInput("FUN", "Weapon Name (e.g. Easter Bunny)", function(text) SpawnWeaponName = text end)
CreateButton("FUN", "SPAWN WEAPON", "✨", function() local box = require(ReplicatedStorage.Modules.BoxModule); box.OpenBox("MysteryBox", SpawnWeaponName) end)

CreateToggle("VISUAL", "ESP ENABLED", "👁️", function(state) Settings.EspEnabled = state end)
RunService.RenderStepped:Connect(function()
    if Settings.EspEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hl = plr.Character:FindFirstChild("EasterESP"); if not hl then hl = Instance.new("Highlight", plr.Character); hl.Name = "EasterESP"; hl.FillTransparency = 0.5 end
                local col = Colors.EggBlue; if plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife") then col = Colors.DangerRed elseif plr.Backpack:FindFirstChild("Gun") or plr.Character:FindFirstChild("Gun") then col = Colors.AccentGreen end
                hl.FillColor = col; hl.OutlineColor = col
            end
        end
    else
        for _, plr in pairs(Players:GetPlayers()) do if plr.Character and plr.Character:FindFirstChild("EasterESP") then plr.Character.EasterESP:Destroy() end end
    end
end)

CreateButton("TP", "TP TO LOBBY", "🏠", function() if getHRP() then getHRP().CFrame = CFrame.new(0, 10, 0) end end)
CreateButton("TP", "TP TO MURDERER", "😈", function() for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then getHRP().CFrame = p.Character.HumanoidRootPart.CFrame end end end)
CreateSlider("TP", "WalkSpeed", 16, 200, 16, function(val) Settings.WalkSpeed = val end)
CreateToggle("TP", "LOCK SPEED", "🔒", function(state) Settings.wsLocked = state end)
task.spawn(function() while true do wait(); if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then if Settings.wsLocked then LocalPlayer.Character.Humanoid.WalkSpeed = Settings.WalkSpeed end end end end)

-- Stats Footer (COMPACT)
local StatsPanel = Instance.new("Frame"); StatsPanel.Parent = MainFrame; StatsPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20); StatsPanel.BorderSizePixel = 0; StatsPanel.Position = UDim2.new(0, 10, 1, -48); StatsPanel.Size = UDim2.new(1, -20, 0, 40)
local SP_Corner = Instance.new("UICorner"); SP_Corner.CornerRadius = UDim.new(0, 8); SP_Corner.Parent = StatsPanel
local CPH_Display = Instance.new("TextLabel"); CPH_Display.Parent = StatsPanel; CPH_Display.BackgroundTransparency = 1; CPH_Display.Position = UDim2.new(0.05, 0, 0.1, 0); CPH_Display.Size = UDim2.new(0.9, 0, 0.4, 0); CPH_Display.Font = Enum.Font.GothamBold; CPH_Display.TextColor3 = Colors.AccentPurple; CPH_Display.TextSize = 11; CPH_Display.TextXAlignment = Enum.TextXAlignment.Left; CPH_Display.Text = "💰 CPH: 0   |   ⏱️ 00:00"
local Coll_Display = Instance.new("TextLabel"); Coll_Display.Parent = StatsPanel; Coll_Display.BackgroundTransparency = 1; Coll_Display.Position = UDim2.new(0.05, 0, 0.5, 0); Coll_Display.Size = UDim2.new(0.9, 0, 0.4, 0); Coll_Display.Font = Enum.Font.GothamMedium; Coll_Display.TextColor3 = Colors.TextWhite; Coll_Display.TextSize = 11; Coll_Display.TextXAlignment = Enum.TextXAlignment.Left; Coll_Display.Text = "🧺 Collected: 0   |   Bag: 0/40"

task.spawn(function()
    while true do
        wait(1)
        if Settings.AutoFarmCoins then
            local elapsed = math.floor(tick() - Stats.StartTime)
            if elapsed > 0 then Stats.CPH = math.floor((Stats.Collected / elapsed) * 3600) end
            CPH_Display.Text = "💰 CPH: " .. Stats.CPH .. "   |   ⏱️ " .. string.format("%02d:%02d", math.floor(elapsed/60), elapsed%60)
            Coll_Display.Text = "🧺 Collected: " .. Stats.Collected .. "   |   Bag: " .. Stats.Bag .. "/" .. Stats.MaxBag
        end
    end
end)

-- Anti-AFK
task.spawn(function() while true do wait(60); if Settings.AntiAfk then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end end)

-- Minimize Button
local MinBtn = Instance.new("ImageButton"); MinBtn.Parent = ScreenGui; MinBtn.Name = "OpenGift"; MinBtn.BackgroundColor3 = Colors.Background; MinBtn.Position = UDim2.new(0, 20, 0.9, -20); MinBtn.Size = UDim2.new(0, 40, 0, 40)
local MCorner = Instance.new("UICorner"); MCorner.CornerRadius = UDim.new(1,0); MCorner.Parent = MinBtn
local MStroke = Instance.new("UIStroke"); MStroke.Color = Colors.AccentPurple; MStroke.Thickness = 2; MStroke.Parent = MinBtn
local OpenLbl = Instance.new("TextLabel"); OpenLbl.Parent = MinBtn; OpenLbl.BackgroundTransparency = 1; OpenLbl.Size = UDim2.new(1,0,1,0); OpenLbl.Text = "🐰"; OpenLbl.TextSize = 20
local visible = true
MinBtn.MouseButton1Click:Connect(function() visible = not visible; MainFrame.Visible = visible end)

print("🐰 Premium Mobile Easter Hub Loaded! 📱")
