loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()

getgenv().Vepar = {
    ['Camlock'] = {
        ['Prediction'] = 0.1475,
        ['Prediction Method'] = {
            ['X'] = 0.19,
            ['Y'] = 0.19,
            }
        },
        ['JumpCheck'] = {
            ['Jump'] = -0.92,
            ['Fall'] = -1.91,

        ['Target Part'] = "HumanoidRootPart"
    },
    ['Silent'] = {
        ['FOV'] = {
            ['Enabled'] = true,
            ['Prediction'] = 0.124,
            ['AutoCheckJump'] = true,
            ['AntiGroundShot'] = false,
        },
        ['AutoAir'] = {
            ['AutoAir'] = true,
            ['AirMaterial'] = Jump, -- Nothing, Move, Jumps, WhenMove, Around, Parent
        }
    }
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = game.Players.LocalPlayer:GetMouse()
local CamlockState = false
local Prediction = 0.15634
local Smoothness = 0.405
local SmoothEnabled = true
local AutoAir = true
local EnemyAir = true
local AirshotMaterial = Jump -- Move, Around, Jumps, Nothing
local JumpCheck = true
local Jump = -0.92
local Fall = -1.91
local Keybind = Enum.Keycode.X

-- Function to remove ESP chams
local function removeCham(cham)
    if cham then
        cham:Destroy()
    end
end

local currentCham

function FindNearestEnemy()
    local ClosestDistance, ClosestPlayer = math.huge, nil
    local CenterPosition = Vector2.new(game:GetService("GuiService"):GetScreenResolution().X / 2, game:GetService("GuiService"):GetScreenResolution().Y / 2)

    for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character
            if Character and Character:FindFirstChild("HumanoidRootPart") and Character.Humanoid.Health > 0 then
                local Position, IsVisibleOnViewport = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(Character.HumanoidRootPart.Position)

                if IsVisibleOnViewport then
                    local Distance = (CenterPosition - Vector2.new(Position.X, Position.Y)).Magnitude
                    if Distance < ClosestDistance then
                        ClosestPlayer = Character.HumanoidRootPart
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end

    return ClosestPlayer
end

local enemy = nil

-- Function to aim the camera at the nearest enemy's HumanoidRootPart
RunService.Heartbeat:Connect(function()
    if CamlockState == true then
        if enemy then
            local camera = workspace.CurrentCamera
            local targetCFrame = CFrame.new(camera.CFrame.p, enemy.Position + enemy.Velocity * Prediction)
            if SmoothEnabled then
                camera.CFrame = camera.CFrame:Lerp(targetCFrame, Smoothness)
            else
                camera.CFrame = targetCFrame
            end
        end
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "Dukeshadow"
gui.Parent = game.CoreGui

local TextButton = Instance.new("TextButton")
TextButton.Text = "trust.lua"
TextButton.TextSize = 25
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1) -- Dark shade of black
TextButton.BorderColor3 = Color3.new(0.3, 0.3, 0.3) -- Slightly lighter shade of black
TextButton.BorderSizePixel = 4
TextButton.BackgroundTransparency = 1
TextButton.Font = Enum.Font.Code
TextButton.Size = UDim2.new(0.2, 0, 0.2, 0)
TextButton.Position = UDim2.new(0, 0.9, 0.3, 1)
local state = true

TextButton.MouseButton1Click:Connect(function()
    state = not state
    if not state then
        TextButton.Text = "trust.lua"
        TextButton.TextColor3 = Color3.new(0, 255, 255)
        getgenv().SilentAimEnabled = true
        CamlockState = true
        enemy = FindNearestEnemy()
        if enemy then
            Air.Parent = true
            enabled = true
            Plr = LockToPlayer()
        end
    else
        TextButton.Text = "trust.lua"
        TextButton.TextColor3 = Color3.new(1, 1, 1)
        getgenv().SilentAimEnabled = false
        CamlockState = false
        enabled = false
        if AutoAir then
            AirMaterial(Material.Auto.Air)
            Airshot = nil
            enemyair = nil
        end
        enemy = nil
    end
end)
TextButton.Parent = gui
TextButton.Draggable = true

local cornerUI = Instance.new("UICorner")
cornerUI.CornerRadius = UDim.new(0, 5)
cornerUI.Parent = TextButton

local function OnKeyPress(Input, GameProcessedEvent)
    if Input.KeyCode == Keybind and not GameProcessedEvent then 
        state = not state
        if not state then
            TextButton.Text = "trust.lua"
            TextButton.TextColor3 = Color3.new(0, 255, 255)
            getgenv().SilentAimEnabled = true
            CamlockState = true
            enemy = FindNearestEnemy()
            if enemy then
                Air.Parent = true
                enabled = true
                Plr = LockToPlayer()
            end
        else
            TextButton.Text = "trust.lua"
            TextButton.TextColor3 = Color3.new(1, 1, 1)
            getgenv().SilentAimEnabled = false
            CamlockState = false
            enabled = false
            if AutoAir then
                AirMaterial(Material.Auto.Air)
                Airshot = nil
                enemyair = nil
            end
            enemy = nil
        end
    end
end

UserInputService.InputBegan:Connect(OnKeyPress)

getgenv().HitPart = "HumanoidRootPart"
getgenv().Prediction_SilentAim = 0.1201
getgenv().SilentAimEnabled = false  -- Default to disabled
getgenv().SilentAimShowFOV = false  -- Default to showing FOV

getgenv().SilentAimFOVSize = 90
getgenv().SilentAimFOVTransparency = 1
getgenv().SilentAimFOVThickness = 2.0
getgenv().SilentAimFOVColor = Color3.new(255, 0, 0)

local SilentAimFOVCircle = Drawing.new("Circle")
SilentAimFOVCircle.Color = getgenv().SilentAimFOVColor
SilentAimFOVCircle.Visible = getgenv().SilentAimShowFOV
SilentAimFOVCircle.Filled = false
SilentAimFOVCircle.Radius = getgenv().SilentAimFOVSize
SilentAimFOVCircle.Transparency = getgenv().SilentAimFOVTransparency
SilentAimFOVCircle.Thickness = getgenv().SilentAimFOVThickness

local function updateFOVCirclePosition()
    local centerScreenPosition = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
    SilentAimFOVCircle.Position = centerScreenPosition
end


local function getClosestPlayerToCenter()
    local centerScreenPosition = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
    local closestPlayer
    local closestDistance = math.huge
    local localPlayer = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerRootPart = player.Character.HumanoidRootPart
            local screenPosition, onScreen = camera:WorldToViewportPoint(playerRootPart.Position)

            if onScreen then
                local KOd = player.Character:FindFirstChild("BodyEffects") and player.Character.BodyEffects["K.O"].Value
                local Grabbed = player.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil

                if not KOd and not Grabbed then
                    local ray = Ray.new(camera.CFrame.Position, playerRootPart.Position - camera.CFrame.Position)
                    local part, position = workspace:FindPartOnRay(ray, localPlayer.Character, false, true)

                    if part and part:IsDescendantOf(player.Character) then
                        local distance = (centerScreenPosition - Vector2.new(screenPosition.X, screenPosition.Y)).Magnitude

                        if distance < closestDistance and distance <= SilentAimFOVCircle.Radius then
                            closestPlayer = player
                            closestDistance = distance
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end




local SilentAimTarget = nil

game:GetService("RunService").RenderStepped:Connect(function()
    SilentAimTarget = getClosestPlayerToCenter()
end)

game:GetService("RunService").RenderStepped:Connect(function()
    updateFOVCirclePosition()
end)

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = {...}
    if getgenv().SilentAimEnabled and SilentAimTarget ~= nil and SilentAimTarget.Character and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
    args[3] = SilentAimTarget.Character[getgenv().HitPart].Position + (SilentAimTarget.Character[getgenv().HitPart].Velocity * getgenv().Prediction_SilentAim)

        return old(unpack(args))
    end
    return old(...)
end)
setreadonly(mt, true)

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = {...}
    if getgenv().SilentAimEnabled and SilentAimTarget ~= nil and SilentAimTarget.Character and getnamecallmethod() == "FireServer" then
        if args[2] == "UpdateMousePos" or args[2] == "MOUSE" or args[2] == "UpdateMousePosI" or args[2] == "MousePosUpdate" then
            args[3] = SilentAimTarget.Character[getgenv().HitPart].Position + (SilentAimTarget.Character[getgenv().HitPart].Velocity * getgenv().Prediction_SilentAim)

            return old(unpack(args))
        end
    end
    return old(...)
end)
setreadonly(mt, true)

-- expand hitbox by xr/pamcles/airhitpart
local function randomizeHitbox(player)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local HitBoxGram = character.HumanoidRootPart
        local randomSize = Vector3.new(math.random(7, 30), math.random(7, 30), math.random(7, 30))
        HitBoxGram.Size = randomSize
        HitBoxGram.Massless = true
        HitBoxGram.CanCollide = false
        HitBoxGram.Anchored = true
        wait(0.1)
        hrp.Anchored = false
    end
end
