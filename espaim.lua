local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- Settings
local Settings = {
    AimBot = { Enabled = false, FOV = 100, Smoothness = 0.05, Key = Enum.KeyCode.E },
    ESP = { Enabled = false, Box = true, Tracer = true, Key = Enum.KeyCode.Q },
    Rage = { SpinBot = false, Speed = 30, Key = Enum.KeyCode.T },
    Misc = { Funny = false, Key = Enum.KeyCode.F }
}

-- Instances
local Instances = { ESP = {}, Tracers = {} }
local isActive = false

-- GUI Setup (Xone Style)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "XoneMenu"
ScreenGui.Enabled = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "Xone"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- Femboy Image
local FemboyImage = Instance.new("ImageLabel")
FemboyImage.Parent = MainFrame
FemboyImage.Size = UDim2.new(0, 180, 0, 120)
FemboyImage.Position = UDim2.new(0, 10, 0, 50)
FemboyImage.BackgroundTransparency = 1
FemboyImage.Image = "rbxassetid://1842809352" -- Замените на актуальный ID

local ButtonFrame = Instance.new("Frame")
ButtonFrame.Parent = MainFrame
ButtonFrame.Size = UDim2.new(1, 0, 0, 120)
ButtonFrame.Position = UDim2.new(0, 0, 0, 180)
ButtonFrame.BackgroundTransparency = 1

local ESPButton = Instance.new("TextButton")
ESPButton.Parent = ButtonFrame
ESPButton.Size = UDim2.new(0, 180, 0, 30)
ESPButton.Position = UDim2.new(0, 10, 0, 0)
ESPButton.Text = "ESP: OFF"
ESPButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.Font = Enum.Font.SourceSans
ESPButton.TextSize = 16

local AimBotButton = Instance.new("TextButton")
AimBotButton.Parent = ButtonFrame
AimBotButton.Size = UDim2.new(0, 180, 0, 30)
AimBotButton.Position = UDim2.new(0, 10, 0, 40)
AimBotButton.Text = "AimBot: OFF"
AimBotButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
AimBotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimBotButton.Font = Enum.Font.SourceSans
AimBotButton.TextSize = 16

local RageButton = Instance.new("TextButton")
RageButton.Parent = ButtonFrame
RageButton.Size = UDim2.new(0, 180, 0, 30)
RageButton.Position = UDim2.new(0, 10, 0, 80)
RageButton.Text = "SpinBot: OFF"
RageButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
RageButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RageButton.Font = Enum.Font.SourceSans
RageButton.TextSize = 16

local MiscButton = Instance.new("TextButton")
MiscButton.Parent = ButtonFrame
MiscButton.Size = UDim2.new(0, 180, 0, 30)
MiscButton.Position = UDim2.new(0, 10, 0, 120)
MiscButton.Text = "Funny: OFF"
MiscButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
MiscButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MiscButton.Font = Enum.Font.SourceSans
MiscButton.TextSize = 16

-- Visuals (Xone Style)
local function createESP(player)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(0, 255, 0)
    box.Filled = false

    local tracer = Drawing.new("Line")
    tracer.Thickness = 2
    tracer.Color = Color3.fromRGB(255, 0, 0)

    Instances.ESP[player] = { box = box, tracer = tracer }
    player.CharacterAdded:Connect(function()
        box.Visible = false
        tracer.Visible = false
    end)
end

RunService.RenderStepped:Connect(function()
    if Settings.ESP.Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not Instances.ESP[player] then
                createESP(player)
            end
            local esp = Instances.ESP[player]
            if esp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
                local rootPart = player.Character.HumanoidRootPart
                local head = player.Character:FindFirstChild("Head")
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

                if onScreen then
                    local pos = Camera:WorldToViewportPoint(head.Position)
                    local size = (Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0)) - pos).Y
                    local width = size / 2

                    if Settings.ESP.Box then
                        esp.box.Size = Vector2.new(width, size)
                        esp.box.Position = Vector2.new(pos.X - width / 2, pos.Y - size)
                        esp.box.Visible = true
                    else
                        esp.box.Visible = false
                    end

                    if Settings.ESP.Tracer then
                        esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        esp.tracer.To = Vector2.new(pos.X, pos.Y + size / 2)
                        esp.tracer.Visible = true
                    else
                        esp.tracer.Visible = false
                    end
                else
                    esp.box.Visible = false
                    esp.tracer.Visible = false
                end
            end
        end
    else
        for _, esp in pairs(Instances.ESP) do
            esp.box.Visible = false
            esp.tracer.Visible = false
        end
    end

    if Settings.AimBot.Enabled and UserInputService:IsKeyDown(Settings.AimBot.Key) and LocalPlayer.Character then
        local target = nil
        local shortest = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character.Humanoid.Health > 0 then
                local headPos = Camera:WorldToViewportPoint(player.Character.Head.Position)
                local distance = (Vector2.new(headPos.X, headPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if distance < shortest and distance <= Settings.AimBot.FOV then
                    shortest = distance
                    target = player.Character.Head
                end
            end
        end
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            TweenService:Create(Camera, TweenInfo.new(Settings.AimBot.Smoothness), {CFrame = CFrame.new(Camera.CFrame.Position, target.Position)}):Play()
        end
    end

    if Settings.Rage.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        local angle = tick() * Settings.Rage.Speed
        rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, math.rad(angle), 0)
    end
end)

-- Input Handling
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    elseif input.KeyCode == Settings.ESP.Key then
        Settings.ESP.Enabled = not Settings.ESP.Enabled
        ESPButton.Text = "ESP: " .. (Settings.ESP.Enabled and "ON" or "OFF")
    elseif input.KeyCode == Settings.AimBot.Key then
        Settings.AimBot.Enabled = not Settings.AimBot.Enabled
        AimBotButton.Text = "AimBot: " .. (Settings.AimBot.Enabled and "ON" or "OFF")
    elseif input.KeyCode == Settings.Rage.Key then
        Settings.Rage.SpinBot = not Settings.Rage.SpinBot
        RageButton.Text = "SpinBot: " .. (Settings.Rage.SpinBot and "ON" or "OFF")
    elseif input.KeyCode == Settings.Misc.Key then
        Settings.Misc.Funny = not Settings.Misc.Funny
        MiscButton.Text = "Funny: " .. (Settings.Misc.Funny and "ON" or "OFF")
        if Settings.Misc.Funny then
            local sound = Instance.new("Sound")
            sound.Parent = SoundService
            sound.SoundId = "rbxassetid://1837829147"
            sound.Volume = 1
            sound:Play()
            sound.Ended:Connect(function() sound:Destroy() end)
        end
    end
end)

-- Watermark
local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.Size = UDim2.new(0, 150, 0, 20)
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.BackgroundTransparency = 1
Watermark.TextColor3 = Color3.fromRGB(0, 120, 255)
Watermark.Text = "Xone - 05/06/2025"
Watermark.Font = Enum.Font.SourceSans
Watermark.TextSize = 14
