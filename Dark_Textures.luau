 local Players = game:GetService("Players")

-- Check if a part is part of the static map
local function isMapPart(part)
    if not part:IsA("BasePart") then return false end

    -- Skip anything under a Tool (weapons)
    if part:FindFirstAncestorOfClass("Tool") then
        return false
    end

    -- Skip anything part of a player character
    local parentModel = part:FindFirstAncestorOfClass("Model")
    if parentModel and parentModel:FindFirstChildOfClass("Humanoid") then
        return false
    end

    -- Skip anything with special meshes/textures (weapon wraps use meshes)
    if part:FindFirstChildWhichIsA("SpecialMesh") or part:FindFirstChildWhichIsA("MeshPart") then
        return false
    end

    -- Skip small objects (props, pickups)
    if part.Size.Magnitude < 5 then
        return false
    end

    -- Skip flora (trees, grass)
    if part.Material == Enum.Material.Grass or (part.Name:lower():find("tree")) then
        return false
    end

    -- Only affect anchored map parts
    if not part.Anchored then
        return false
    end

    return true
end

-- Apply charcoal effect only to map parts
local function applyCharcoal()
    for _, part in pairs(workspace:GetDescendants()) do
        if isMapPart(part) then
            part.Color = Color3.fromRGB(50, 50, 50)
            part.Material = Enum.Material.SmoothPlastic
        end
    end
end

-- Apply on player spawn
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(1) -- small delay to ensure map loads
        applyCharcoal()
    end)
end

-- Apply for all current players
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- Apply for future players
Players.PlayerAdded:Connect(onPlayerAdded) 
