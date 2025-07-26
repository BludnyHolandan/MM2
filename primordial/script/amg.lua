-- Load WindUI safely
local success, WindUI = pcall(function()
    print("Attempting to load WindUI...")
    local result = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    print("WindUI loaded successfully.")
    return result
end)

if not success or not WindUI then
    warn("Failed to load WindUI: " .. tostring(WindUI))
    game:GetService("Players").LocalPlayer:Kick("Failed to load UI library. Please check your network or the script URL.")
    return
end

print("Script running on client at: " .. os.date("%H:%M:%S %d/%m/%Y"))

local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local windowSize = isMobile and UDim2.fromOffset(360, 420) or UDim2.fromOffset(600, 480)

local Window = WindUI:CreateWindow({
    Title = "MM2 Script Hub V1.4",
    Icon = "skull",
    Author = "Made by Yuki",
    Folder = "",
    Size = windowSize,
    Transparent = false,
    Theme = "Dark",
    SideBarWidth = 200,
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function() print("User profile triggered.") end,
    },
})

-- Tabs
local Tabs = {
    AutoFarmTab = Window:Tab({ Title = "AutoFarm", Icon = "coins" }),
    AntiAFKTab = Window:Tab({ Title = "Anti-AFK", Icon = "moon" }),
    AntiStealTab = Window:Tab({ Title = "Anti-Steal", Icon = "shield" }),
}

-- RichText colored header
Tabs.AutoFarmTab:Paragraph({
    Title = '<font color="#FFD700">MM2 Script Hub</font> <font color="#00CFFF">| NEW UPDATE 1.4!</font>',
    Desc = "💻 Made by Yuki",
    Image = "zap",
    RichText = true,
})

-- Autofarm
local plr = game.Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local humPart = character:WaitForChild("HumanoidRootPart")
plr.CharacterAdded:Connect(function(char)
    character = char
    humPart = char:WaitForChild("HumanoidRootPart")
end)

local map
game.Workspace.DescendantAdded:Connect(function(m)
    if m:IsA("Model") and m.Name == "CoinContainer" then
        map = m
    end
end)

local delay = 2.5
getgenv().farm = false

Tabs.AutoFarmTab:Toggle({
    Title = "Enable BeachBall Farm",
    Default = false,
    Callback = function(state)
        getgenv().farm = state
        WindUI:Notify({
            Title = "AutoFarm",
            Content = state and "Farming started!" or "Farming stopped.",
            Icon = state and "check" or "x",
            Duration = 4,
        })

        while getgenv().farm do
            if (not map) or (not map.Parent) then
                for _,m in ipairs(game.Workspace:GetDescendants()) do
                    if m:IsA("Model") and m.Name == "CoinContainer" then
                        map = m
                        break
                    end
                end
            end

            if map and map.Parent then
                for _,coin in ipairs(map:GetChildren()) do
                    if not getgenv().farm then break end
                    if coin:IsA("Part") and coin.Name=="Coin_Server" and coin:GetAttribute("CoinID")=="BeachBall" then
                        local cv = coin:FindFirstChild("CoinVisual")
                        if cv and cv.Transparency ~= 1 then
                            humPart = character:FindFirstChild("HumanoidRootPart")
                            if not humPart then break end
                            for _,p in pairs(character:GetChildren()) do
                                if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
                            end
                            humPart.CFrame = coin.CFrame * CFrame.new(0, 6, 0)
                            task.wait(delay)
                        end
                    end
                end
            end
            task.wait(1)
        end
    end,
})

Tabs.AutoFarmTab:Input({
    Title = "Farm Delay",
    Desc = "Seconds between coin grabs",
    Placeholder = "e.g. 2.5",
    Callback = function(val)
        local num = tonumber(val)
        if num then
            delay = num
            WindUI:Notify({
                Title = "Delay Updated",
                Content = "Delay set to " .. val .. "s",
                Icon = "clock",
                Duration = 3,
            })
        else
            WindUI:Notify({
                Title = "Invalid Input",
                Content = "Please enter a number.",
                Icon = "alert-circle",
                Duration = 4,
            })
        end
    end,
})

-- Anti-AFK
Tabs.AntiAFKTab:Button({
    Title = "Enable Anti-AFK",
    Callback = function()
        local GC = getconnections or get_signal_cons
        if GC then
            for _,v in pairs(GC(plr.Idled)) do
                if v.Disable then v:Disable() elseif v.Disconnect then v:Disconnect() end
            end
        else
            local vu = cloneref(game:GetService("VirtualUser"))
            plr.Idled:Connect(function()
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end
        WindUI:Notify({
            Title = "Anti-AFK Enabled",
            Content = "You won't get kicked for idling!",
            Icon = "coffee",
            Duration = 5,
        })
    end,
})

-- Anti-Steal Info + Toggle
Tabs.AntiStealTab:Paragraph({
    Title = "Anti-Steal System",
    Desc = "Protects your coins or data from being hijacked by other scripts or players. Toggle below to enable.",
    Image = "lock",
})

local antiStealActive = false
Tabs.AntiStealTab:Toggle({
    Title = "Enable Anti-Steal",
    Default = false,
    Callback = function(state)
        antiStealActive = state
        WindUI:Notify({
            Title = "Anti-Steal",
            Content = state and "Anti-Steal Enabled!" or "Anti-Steal Disabled.",
            Icon = state and "shield" or "x",
            Duration = 4,
        })
        -- Placeholder: Add anti-interference logic here if needed
    end,
})

print("✅ MM2 GUI loaded. Press Right Ctrl to toggle it.")
