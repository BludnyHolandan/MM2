-- WoozieX Weapon Spawner GUI with Slower Loading + Styled Input Font + Event Reward Animation + Character Reset

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

-- MAIN GUI FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.42, 0)
frame.Position = UDim2.new(0.35, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local frameUICorner = Instance.new("UICorner")
frameUICorner.CornerRadius = UDim.new(0, 12)
frameUICorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 4
frameStroke.Parent = frame

local function animateNeonGradient()
    while true do
        for t = 0, 1, 0.02 do
            local hue = 0.9 - (0.15 * t)
            frameStroke.Color = Color3.fromHSV(hue, 0.8, 1)
            task.wait(0.05)
        end
        for t = 1, 0, -0.02 do
            local hue = 0.9 - (0.15 * t)
            frameStroke.Color = Color3.fromHSV(hue, 0.8, 1)
            task.wait(0.05)
        end
    end
end
spawn(animateNeonGradient)

-- Header
local header1 = Instance.new("TextLabel")
header1.Size = UDim2.new(1, 0, 0.18, 0)
header1.Position = UDim2.new(0, 0, 0.02, 0)
header1.BackgroundTransparency = 1
header1.Text = "By DaveScripts"
header1.TextColor3 = Color3.fromRGB(255, 255, 255)
header1.Font = Enum.Font.FredokaOne
header1.TextScaled = true
header1.Parent = frame

local header2 = Instance.new("TextLabel")
header2.Size = UDim2.new(1, 0, 0.12, 0)
header2.Position = UDim2.new(0, 0, 0.15, 0)
header2.BackgroundTransparency = 1
header2.Text = "Weapon Spawner"
header2.TextColor3 = Color3.fromRGB(255, 255, 255)
header2.Font = Enum.Font.FredokaOne
header2.TextScaled = true
header2.Parent = frame

-- Input Box
local itemTextBox = Instance.new("TextBox")
itemTextBox.Size = UDim2.new(0.8, 0, 0.15, 0)
itemTextBox.Position = UDim2.new(0.1, 0, 0.32, 0)
itemTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
itemTextBox.PlaceholderText = "Enter Weapon Name..."
itemTextBox.Text = ""
itemTextBox.Font = Enum.Font.FredokaOne
itemTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
itemTextBox.TextSize = 16
itemTextBox.ClearTextOnFocus = false
itemTextBox.Parent = frame

local itemUICorner = Instance.new("UICorner")
itemUICorner.CornerRadius = UDim.new(0, 8)
itemUICorner.Parent = itemTextBox

local itemStroke = Instance.new("UIStroke")
itemStroke.Thickness = 2
itemStroke.Color = Color3.fromRGB(100, 100, 100)
itemStroke.Transparency = 0.5
itemStroke.Parent = itemTextBox

-- Spawn Button
local spawnButton = Instance.new("TextButton")
spawnButton.Size = UDim2.new(0.8, 0, 0.15, 0)
spawnButton.Position = UDim2.new(0.1, 0, 0.52, 0)
spawnButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
spawnButton.Text = "Click To Spawn Weapon"
spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnButton.Font = Enum.Font.FredokaOne
spawnButton.TextSize = 16
spawnButton.Parent = frame

local spawnCorner = Instance.new("UICorner")
spawnCorner.CornerRadius = UDim.new(0, 10)
spawnCorner.Parent = spawnButton

local spawnStroke = Instance.new("UIStroke")
spawnStroke.Thickness = 2
spawnStroke.Color = Color3.fromRGB(100, 150, 255)
spawnStroke.Transparency = 0.8
spawnStroke.Parent = spawnButton

spawnButton.MouseEnter:Connect(function()
    spawnStroke.Transparency = 0.2
end)
spawnButton.MouseLeave:Connect(function()
    spawnStroke.Transparency = 0.8
end)

-- Feedback + Loading Label
local feedbackLabel = Instance.new("TextLabel")
feedbackLabel.Size = UDim2.new(1, 0, 0.08, 0)
feedbackLabel.Position = UDim2.new(0, 0, 0.72, 0)
feedbackLabel.BackgroundTransparency = 1
feedbackLabel.Text = ""
feedbackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
feedbackLabel.Font = Enum.Font.Gotham
feedbackLabel.TextSize = 14
feedbackLabel.Parent = frame

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0.08, 0)
loadingText.Position = UDim2.new(0, 0, 0.80, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = ""
loadingText.TextColor3 = Color3.fromRGB(150, 150, 255)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 14
loadingText.Parent = frame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.5, 0, 0.1, 0)
closeButton.Position = UDim2.new(0.25, 0, 0.88, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeButton.Text = "Close"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
closeButton.Parent = frame

local closeUICorner = Instance.new("UICorner")
closeUICorner.CornerRadius = UDim.new(0.15, 0)
closeUICorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Weapon Spawning Logic
local itemList = {
    Bloom = "Bloom", -- Bloom Knife from Easter 2025
    Flora = "Flora", -- Floral Gun from Easter 2025
    Harvester = "Harvester",
    Gingerscope = "Gingerscope",
    Icepiercer = "Icepiercer",
    VampireGun = "VampireGun",
    VampireAxe = "VampireAxe",
    TravelerAxe = "TravelerAxe",
    Spirit = "WraithKnife",
    ChromaWatergun = "WatergunChroma"
}

local PlayerData = require(game:GetService("ReplicatedStorage").Modules.ProfileData)
local PlayerWeapons = PlayerData.Weapons
local inventory = {}

-- Function to refresh event GUI to trigger reward animation
local function refreshEventGui()
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui", 10)
    if not playerGui then
        print("PlayerGui not found within 10 seconds")
        feedbackLabel.Text = "❌ PlayerGui not found"
        feedbackLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end

    -- Debug: Print all GUIs in PlayerGui to find the event GUI
    print("All GUIs in PlayerGui:")
    for _, gui in pairs(playerGui:GetChildren()) do
        print(gui.Name)
        for _, child in pairs(gui:GetChildren()) do
            print("  " .. child.Name)
        end
    end

    -- Look for Easter event GUI (likely named "EventGui", "EasterGui", or similar)
    local eventGui = playerGui:FindFirstChild("EventGui") or playerGui:FindFirstChild("EasterGui")
    if eventGui then
        -- Look for the frame handling rewards (e.g., "RewardFrame", "EventFrame")
        local rewardFrame = eventGui:FindFirstChild("RewardFrame", true) or eventGui:FindFirstChild("EventFrame", true)
        if rewardFrame then
            rewardFrame.Visible = false
            wait(0.1)
            rewardFrame.Visible = true
            print("Refreshed event GUI to trigger reward animation")
        else
            print("RewardFrame or EventFrame not found in EventGui")
        end
    else
        print("EventGui or EasterGui not found in PlayerGui")
    end
end

local function addItemToInventory(itemId)
    if not inventory[itemId] then
        inventory[itemId] = 0
    end
    inventory[itemId] = inventory[itemId] + 1

    game:GetService("RunService"):BindToRenderStep("InventoryUpdate_" .. itemId, 0, function()
        PlayerWeapons.Owned[itemId] = inventory[itemId]
    end)

    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui", 10)
    if playerGui then
        local inventoryGui = playerGui:FindFirstChild("Inventory") or playerGui:FindFirstChild("MainGui")
        if inventoryGui then
            local inventoryFrame = inventoryGui:FindFirstChild("InventoryFrame", true)
            if inventoryFrame then
                inventoryFrame.Visible = false
                wait(0.1)
                inventoryFrame.Visible = true
            end
        end
    end
end

spawnButton.MouseButton1Click:Connect(function()
    local itemName = itemTextBox.Text
    local item = itemList[itemName]

    if item then
        feedbackLabel.Text = "⚙️ Weapon Spawner: " .. item
        feedbackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        loadingText.Text = "Loading: 0%"

        spawn(function()
            for i = 1, 100 do
                loadingText.Text = "Loading: " .. i .. "%"
                task.wait(math.random(35, 60) / 1000)
            end
            loadingText.Text = "🎁 Claiming Reward..."
            task.wait(1)

            -- Add item to inventory and refresh event GUI
            addItemToInventory(item)
            refreshEventGui()
            task.wait(0.5) -- Allow animation to play

            -- Reset character to apply inventory changes
            loadingText.Text = "🔄 Resetting Character..."
            local player = game.Players.LocalPlayer
            if player.Character then
                player.Character:BreakJoints() -- Reset character to force inventory sync
            end
            task.wait(1) -- Brief delay to ensure reset completes

            feedbackLabel.Text = "✅ Weapon Spawned: " .. item
            loadingText.Text = ""
        end)
    else
        feedbackLabel.Text = "❌ Weapon Not Found"
        feedbackLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        loadingText.Text = ""
    end
end)

-- Draggable GUI
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
