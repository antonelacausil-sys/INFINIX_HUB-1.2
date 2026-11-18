
--==================================================
-- INIFINIX HUB 1.1
-- Volleyball Legends - Visual Training Edition
-- Black & Purple Neon
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Purple = Color3.fromRGB(170, 70, 255)
local Dark = Color3.fromRGB(13, 10, 20)
local Panel = Color3.fromRGB(30, 22, 42)
local White = Color3.fromRGB(245, 240, 255)

-- Remove previous GUI
local Previous = PlayerGui:FindFirstChild("INIFINIX_HUB")
if Previous then Previous:Destroy() end

-- Main GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "INIFINIX_HUB"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(330, 410)
Main.Position = UDim2.new(0.5, -165, 0.5, -205)
Main.BackgroundColor3 = Dark
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = Gui

Instance.new("UICorner", Main).CornerRadius =
    UDim.new(0, 14)

local Border = Instance.new("UIStroke")
Border.Color = Purple
Border.Thickness = 2
Border.Parent = Main

-- Header
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, -55, 0, 48)
Header.Position = UDim2.fromOffset(12, 0)
Header.BackgroundTransparency = 1
Header.Text = "INIFINIX HUB 1.1"
Header.TextColor3 = Purple
Header.TextSize = 21
Header.Font = Enum.Font.GothamBold
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Parent = Main

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -24, 0, 35)
Status.Position = UDim2.fromOffset(12, 365)
Status.BackgroundTransparency = 1
Status.Text = "SYSTEM READY"
Status.TextColor3 = Purple
Status.TextSize = 12
Status.Font = Enum.Font.GothamBold
Status.Parent = Main

local function notify(message)
    Status.Text = message
end

-- Mobile dragging
local dragging = false
local dragStart
local startPosition

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local pos = input.Position
        if pos.Y <= Main.AbsolutePosition.Y + 48 then
            dragging = true
            dragStart = pos
            startPosition = Main.Position
        end
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Minimize / restore
local Mini = Instance.new("TextButton")
Mini.Size = UDim2.fromOffset(35, 32)
Mini.Position = UDim2.new(1, -43, 0, 8)
Mini.BackgroundColor3 = Purple
Mini.Text = "-"
Mini.TextColor3 = White
Mini.TextSize = 22
Mini.Parent = Main

Instance.new("UICorner", Mini)

local Floating = Instance.new("TextButton")
Floating.Size = UDim2.fromOffset(55, 55)
Floating.Position = UDim2.new(0, 15, 0.5, 0)
Floating.BackgroundColor3 = Dark
Floating.Text = "IN"
Floating.TextColor3 = Purple
Floating.TextSize = 20
Floating.Font = Enum.Font.GothamBold
Floating.Visible = false
Floating.Parent = Gui

Instance.new("UICorner", Floating).CornerRadius =
    UDim.new(1, 0)

local FloatBorder = Instance.new("UIStroke")
FloatBorder.Color = Purple
FloatBorder.Thickness = 2
FloatBorder.Parent = Floating

Mini.MouseButton1Click:Connect(function()
    Main.Visible = false
    Floating.Visible = true
end)

Floating.MouseButton1Click:Connect(function()
    Main.Visible = true
    Floating.Visible = false
end)

-- Button creator
local function createButton(text, y, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -30, 0, 39)
    Button.Position = UDim2.fromOffset(15, y)
    Button.BackgroundColor3 = Panel
    Button.Text = text
    Button.TextColor3 = White
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.Parent = Main

    Instance.new("UICorner", Button).CornerRadius =
        UDim.new(0, 9)

    local Outline = Instance.new("UIStroke")
    Outline.Color = Purple
    Outline.Transparency = 0.55
    Outline.Parent = Button

    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- Aim guide
local aimEnabled = false

createButton("🎯 AIM GUIDE: OFF", 58, function(button)
    aimEnabled = not aimEnabled
    notify(aimEnabled and "AIM GUIDE ENABLED" or "AIM GUIDE DISABLED")
end).MouseButton1Click:Connect(function()
    -- Visual training indicator only
end)

-- Power serve guide
local serveEnabled = false

createButton("⚡ POWER SERVE GUIDE: OFF", 105, function()
    serveEnabled = not serveEnabled
    notify(serveEnabled and "SERVE GUIDE ENABLED" or "SERVE GUIDE DISABLED")
end)

-- Spins counter (local demonstration)
local spins = 0

local spinLabel = Instance.new("TextLabel")
spinLabel.Size = UDim2.new(1, -30, 0, 28)
spinLabel.Position = UDim2.fromOffset(15, 152)
spinLabel.BackgroundTransparency = 1
spinLabel.Text = "VISUAL SPINS: 0"
spinLabel.TextColor3 = Purple
spinLabel.TextSize = 14
spinLabel.Font = Enum.Font.GothamBold
spinLabel.Parent = Main

createButton("+ ADD VISUAL SPIN", 184, function()
    spins = spins + 1
    spinLabel.Text = "VISUAL SPINS: " .. spins
    notify("VISUAL COUNTER UPDATED")
end)

createButton("RESET VISUAL COUNTER", 231, function()
    spins = 0
    spinLabel.Text = "VISUAL SPINS: 0"
    notify("COUNTER RESET")
end)

-- Hitbox visualizer (own character only)
local hitboxEnabled = false
local highlight = nil

local function updateHitbox()
    local character = Player.Character
    if not character then return end

    if hitboxEnabled then
        if highlight then highlight:Destroy() end

        highlight = Instance.new("Highlight")
        highlight.Name = "InifinixVisual"
        highlight.Adornee = character
        highlight.FillColor = Purple
        highlight.OutlineColor = White
        highlight.FillTransparency = 0.85
        highlight.OutlineTransparency = 0
        highlight.Parent = character
    else
        if highlight then
            highlight:Destroy()
            highlight = nil
        end
    end
end

createButton("📦 HITBOX VISUALIZER: OFF", 278, function()
    hitboxEnabled = not hitboxEnabled
    updateHitbox()

    notify(hitboxEnabled and
        "VISUALIZER ENABLED" or "VISUALIZER DISABLED")
end)

Player.CharacterAdded:Connect(function()
    task.wait(1)
    if hitboxEnabled then updateHitbox() end
end)

createButton("CLOSE HUB", 325, function()
    Gui:Destroy()
end)

print("INIFINIX HUB 1.1 LOADED")
