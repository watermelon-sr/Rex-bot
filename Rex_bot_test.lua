locallocal Players = game:GetSer"Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
if not player then
    warn("This script must run as a LocalScript (LocalPlayer is nil).")
    return
end

-- SETTINGS
local TargetName = "Friends"
local MaxMessageLength = 200
local Forbidden = { "badword1", "badword2" } -- add any exact forbidden tokens you want locally blocked

-- UTIL: simple sanitizer (client-side only; Roblox servers still perform official filtering)
local function isAllowedMessage(msg)
    if type(msg) ~= "string" then return false end
    msg = msg:match("^%s*(.-)%s*$") or "" -- trim
    if #msg == 0 or #msg > MaxMessageLength then return false end
    local lower = string.lower(msg)
    for _, token in ipairs(Forbidden) do
        if token ~= "" and string.find(lower, string.lower(token), 1, true) then
            return false
        end
    end
    return true
end

-- UTIL: send chat (uses TextChatService when available; falls back to legacy event)
local function SendChat(msg)
    if type(msg) ~= "string" or #msg == 0 then return end
    pcall(function()
        if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            if TextChatService.TextChannels and TextChatService.TextChannels.RBXGeneral and TextChatService.TextChannels.RBXGeneral.SendAsync then
                TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
            else
                for _, ch in pairs(TextChatService.TextChannels:GetChildren()) do
                    if ch and ch.SendAsync then
                        ch:SendAsync(msg)
                        return
                    end
                end
            end
        else
            local events = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if events and events:FindFirstChild("SayMessageRequest") then
                events.SayMessageRequest:FireServer(msg, "All")
            end
        end
    end)
end

-- BUILD UI
local playerGui = player:WaitForChild("PlayerGui")
-- Remove existing GUI if present to avoid duplicates
local existing = playerGui:FindFirstChild("RexChatBotSafeGUI")
if existing then existing:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RexChatBotSafeGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
screenGui.DisplayOrder = 50

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 220)
frame.Position = UDim2.new(0, 20, 0, 80)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 28)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Rex Chat Bot (Safe)"
title.TextColor3 = Color3.fromRGB(235,235,235)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(0, 90, 0, 22)
targetLabel.Position = UDim2.new(0, 10, 0, 44)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "Target Name:"
targetLabel.TextColor3 = Color3.fromRGB(200,200,200)
targetLabel.Font = Enum.Font.SourceSans
targetLabel.TextSize = 14
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = frame

local targetBox = Instance.new("TextBox")
targetBox.Size = UDim2.new(0, 240, 0, 22)
targetBox.Position = UDim2.new(0, 110, 0, 44)
targetBox.Text = TargetName
targetBox.ClearTextOnFocus = false
targetBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
targetBox.TextColor3 = Color3.fromRGB(230,230,230)
targetBox.Font = Enum.Font.SourceSans
targetBox.TextSize = 14
targetBox.PlaceholderText = "1-32 characters"
targetBox.Parent = frame

local startStopLabel = Instance.new("TextLabel")
startStopLabel.Size = UDim2.new(0, 110, 0, 22)
startStopLabel.Position = UDim2.new(0, 10, 0, 72)
startStopLabel.BackgroundTransparency = 1
startStopLabel.Text = "Bot Enabled:"
startStopLabel.TextColor3 = Color3.fromRGB(200,200,200)
startStopLabel.Font = Enum.Font.SourceSans
startStopLabel.TextSize = 14
startStopLabel.TextXAlignment = Enum.TextXAlignment.Left
startStopLabel.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 22)
toggleButton.Position = UDim2.new(0, 130, 0, 72)
toggleButton.Text = "Start (Enable)"
toggleButton.BackgroundColor3 = Color3.fromRGB(50,150,50)
toggleButton.TextColor3 = Color3.fromRGB(230,230,230)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 14
toggleButton.Parent = frame

local messageLabel = Instance.new("TextLabel")
messageLabel.Size = UDim2.new(0, 80, 0, 22)
messageLabel.Position = UDim2.new(0, 10, 0, 104)
messageLabel.BackgroundTransparency = 1
messageLabel.Text = "Message:"
messageLabel.TextColor3 = Color3.fromRGB(200,200,200)
messageLabel.Font = Enum.Font.SourceSans
messageLabel.TextSize = 14
messageLabel.TextXAlignment = Enum.TextXAlignment.Left
messageLabel.Parent = frame

local messageBox = Instance.new("TextBox")
messageBox.Size = UDim2.new(0, 340, 0, 60)
messageBox.Position = UDim2.new(0, 10, 0, 130)
messageBox.TextWrapped = true
messageBox.ClearTextOnFocus = false
messageBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
messageBox.TextColor3 = Color3.fromRGB(230,230,230)
messageBox.Font = Enum.Font.SourceSans
messageBox.TextSize = 14
messageBox.PlaceholderText = "Type a single, non-abusive message to broadcast"
messageBox.MultiLine = true
messageBox.Parent = frame

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0, 160, 0, 28)
sendButton.Position = UDim2.new(0, 10, 1, -38)
sendButton.Text = "Send Broadcast"
sendButton.BackgroundColor3 = Color3.fromRGB(70,130,200)
sendButton.TextColor3 = Color3.fromRGB(230,230,230)
sendButton.Font = Enum.Font.SourceSansBold
sendButton.TextSize = 16
sendButton.Parent = frame

local destroyButton = Instance.new("TextButton")
destroyButton.Size = UDim2.new(0, 160, 0, 28)
destroyButton.Position = UDim2.new(0, 190, 1, -38)
destroyButton.Text = "Destroy UI"
destroyButton.BackgroundColor3 = Color3.fromRGB(180,70,70)
destroyButton.TextColor3 = Color3.fromRGB(230,230,230)
destroyButton.Font = Enum.Font.SourceSansBold
destroyButton.TextSize = 16
destroyButton.Parent = frame

-- UI state
local botEnabled = false
local function updateToggleUI()
    if botEnabled then
        toggleButton.Text = "Stop (Disable)"
        toggleButton.BackgroundColor3 = Color3.fromRGB(180,50,50)
        sendButton.Visible = true
        sendButton.Active = true
        sendButton.AutoButtonColor = true
        sendButton.Text = "Send Broadcast"
    else
        toggleButton.Text = "Start (Enable)"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50,150,50)
        -- When disabled, prevent sending to avoid accidental spam usage
        sendButton.Visible = true
        sendButton.Active = false
        sendButton.AutoButtonColor = false
        sendButton.Text = "Send Disabled"
    end
end

updateToggleUI()

-- EVENTS
toggleButton.MouseButton1Click:Connect(function()
    botEnabled = not botEnabled
    updateToggleUI()
end)

-- Update TargetName when focus is lost (or on Enter)
targetBox.FocusLost:Connect(function(enterPressed)
    local val = targetBox.Text or ""
    val = val:match("^%s*(.-)%s*$") or ""
    if #val > 0 and #val <= 32 then
        TargetName = val
    else
        -- reset textbox to current valid TargetName
        targetBox.Text = TargetName
    end
end)

-- Send operation (single moderated broadcast)
sendButton.MouseButton1Click:Connect(function()
    if not botEnabled then
        -- extra guard
        return
    end

    local payload = messageBox.Text or ""
    payload = payload:match("^%s*(.-)%s*$") or ""

    if not isAllowedMessage(payload) then
        -- Provide user feedback by briefly changing button text
        local old = sendButton.Text
        sendButton.Text = "Blocked / Too long"
        task.delay(1.2, function()
            if sendButton then sendButton.Text = old end
        end)
        return
    end

    -- Compose final message (neutral prefix)
    local final = "[" .. TargetName .. "] " .. payload
    SendChat(final)

    -- Clear message box after send
    messageBox.Text = ""
end)

destroyButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Optional: allow pressing Enter in messageBox to send (if botEnabled)
messageBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and botEnabled then
        sendButton.MouseButton1Click:Fire()
    end
end)

-- End of script
