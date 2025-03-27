local WeaponOwnedRange = {
  min=1,
  max=150
}

local DataBase, PlayerData = require(game:GetService("ReplicatedStorage").Database.Sync.Item), require(game:GetService("ReplicatedStorage").Modules.ProfileData)

local newOwned = {}

for i, v in pairs(DataBase) do
    newOwned[i] = math.random(WeaponOwnedRange.min, WeaponOwnedRange.max) -- newOwned[Weapon]: ItemCount
end

local PlayerWeapons = PlayerData.Weapons

game:GetService("RunService"):BindToRenderStep("InventoryUpdate", 0, function()
  PlayerWeapons.Owned = newOwned
end)
game.Players.LocalPlayer.Character:BreakJoints()
