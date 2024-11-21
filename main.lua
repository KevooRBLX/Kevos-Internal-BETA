-- Create GUI Elements
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KevosInternalGui"
screenGui.Parent = playerGui

-- Notification Frame
local notificationFrame = Instance.new("Frame")
notificationFrame.Size = UDim2.new(0.3, 0, 0.1, 0)
notificationFrame.Position = UDim2.new(0.35, 0, 0.9, 0)
notificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
notificationFrame.BorderSizePixel = 0
notificationFrame.Visible = true
notificationFrame.Parent = screenGui

-- Notification Text
local notificationText = Instance.new("TextLabel")
notificationText.Size = UDim2.new(1, 0, 1, 0)
notificationText.Text = "Kevos Internal Loaded! Click 'Internal' to open and close."
notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
notificationText.BackgroundTransparency = 1
notificationText.Font = Enum.Font.GothamBold
notificationText.TextSize = 14
notificationText.Parent = notificationFrame

-- Internal GUI Frame
local internalFrame = Instance.new("Frame")
internalFrame.Size = UDim2.new(0.4, 0, 0.5, 0)
internalFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
internalFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
internalFrame.BorderSizePixel = 0
internalFrame.Visible = false
internalFrame.Parent = screenGui

-- Insert Button
local insertButton = Instance.new("TextButton")
insertButton.Size = UDim2.new(0.2, 0, 0.1, 0)
insertButton.Position = UDim2.new(0.4, 0, 0.8, 0)
insertButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
insertButton.TextColor3 = Color3.fromRGB(255, 255, 255)
insertButton.Font = Enum.Font.GothamBold
insertButton.TextSize = 16
insertButton.Text = "Insert"
insertButton.Parent = internalFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.1, 0, 0.05, 0)
toggleButton.Position = UDim2.new(0.45, 0, 0.01, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Text = "Internal"
toggleButton.Parent = screenGui

-- Button Functionality
toggleButton.MouseButton1Click:Connect(function()
    internalFrame.Visible = not internalFrame.Visible
end)

insertButton.MouseButton1Click:Connect(function()
    print("Insert button clicked!")
    -- Add your script functionality here
end)

-- Notification Hide Timer
task.wait(5)
notificationFrame:TweenPosition(
    UDim2.new(0.35, 0, 1.1, 0),
    Enum.EasingDirection.Out,
    Enum.EasingStyle.Quad,
    0.5,
    true,
    function()
        notificationFrame.Visible = false
    end
)

-- Aimlock Variables
local aimlockEnabled = false

-- Function to get the closest player to the mouse
local function getClosestPlayerToMouse()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local character = target.Character
            local rootPart = character.HumanoidRootPart
            local screenPos = workspace.CurrentCamera:WorldToScreenPoint(rootPart.Position)

            if rootPart and rootPart.Parent then
                local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distance < shortestDistance then
                    closestPlayer = target
                    shortestDistance = distance
                end
            end
        end
    end

    return closestPlayer
end

-- Aimlock functionality
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.E then
        aimlockEnabled = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        aimlockEnabled = false
    end
end)

RunService.RenderStepped:Connect(function()
    if aimlockEnabled then
        local closestPlayer = getClosestPlayerToMouse()

        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPart = closestPlayer.Character.HumanoidRootPart
            mouse.Hit = targetPart.CFrame
        end
    end
end)
