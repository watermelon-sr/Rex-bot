--====================================================
-- REX CHAT BOT | DELTA SAFE | FINAL FINAL FIX
--====================================================

-- Services
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--====================
-- SETTINGS
--====================
local ChatSpam = false
local BotLocked = false
local TargetName = "RyZ HATERS"
local WordIndex = 1
local SpamThread = nil
local PendingStart = false
local LastMessageId = nil

local Words = {
    "BUILDING","CLASSROOM","STUDENT","KNOWLEDGE","LEARNING","SCIENCE","MATH","HISTORY",
    "GEOGRAPHY","PHYSICS","CHEMISTRY","BIOLOGY","LABORATORY","EXPERIMENT","FORMULA",
    "EQUATION","ENERGY","MOTION","SPACE","PLANET","GALAXY","UNIVERSE","QUANTUM",
    "ATOM","MOLECULE","ELECTRICITY","TECHNOLOGY","SOFTWARE","HARDWARE","INTERNET",
    "ALGORITHM","LOGIC","MEMORY","CREATIVITY","DISCOVERY","INNOVATION","FUTURE",
    "AREY","BHAI","KYA","SCENE","OP","LOL","BINDASS","CHILL","MAST","JHAKKAS",
    "😂🔥","😁💞","😑✌🏻","🚀","😁💕","🌴🔥","😂👌🏿","💪😁"
}

--====================
-- SEND CHAT
--====================
local function SendChat(msg)
    pcall(function()
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
        else
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        end
    end)
end

--====================
-- SPAM MESSAGE
--====================
local function GetNextSpamMessage()
    local word = Words[WordIndex]
    WordIndex += 1
    if WordIndex > #Words then WordIndex = 1 end
    return "_________________________________________________________________________________________________________________________________________________________________ "
        .. TargetName .. " TRY MA " .. word
end

--====================
-- START SPAM LOOP
--====================
local function StartSpam()
    if SpamThread then return end
    SpamThread = task.spawn(function()
        while ChatSpam do
            SendChat(GetNextSpamMessage())
            task.wait(2 + math.random()) -- 2–3 sec
        end
        SpamThread = nil
    end)
end

--====================
-- CHAT COMMAND HANDLER
--====================
local function HandleCommand(msg)
    msg = string.lower(msg)

    local newName = msg:match("^bot change hater name to (.+)")
    if newName then
        TargetName = newName
        WordIndex = 1
        SendChat("__________________________________________________________________________________________________________________________________________________________ hater name changed to " .. newName)
        return
    end

    if BotLocked then
        if msg == "unlock bot" then
            BotLocked = false
            SendChat("____________________________________________________________________________________________________________________________________________________ bot unlocked🔓")
        end
        return
    end

    if msg == "lock bot" then
        BotLocked = true
        ChatSpam = false
        SendChat("__________________________________________________________________________________________________________________________________________________ bot locked 🔐")
        return
    end

    if msg == "hi bot" or msg == "bot" then
        SendChat("______________________________________________________________________________________________________________________________________________________________________HELLO REX SIR 💖")
        return
    end

    if msg == "start spam" then
        if ChatSpam or PendingStart then return end
        PendingStart = true
        SendChat("__________________________________________________________________________________________________________________________________________ Spam starting in 20 seconds script by Rex")
        task.delay(20, function()
            PendingStart = false
            if not BotLocked then
                ChatSpam = true
                StartSpam()
            end
        end)
        return
    end

    if msg == "stop spam" or msg == "stop" then
        ChatSpam = false
        return
    end

    if msg == "start" then
        if not ChatSpam then
            ChatSpam = true
            StartSpam()
        end
        return
    end
end

--====================
-- SINGLE CHAT LISTENER (ANTI-DOUBLE FIX)
--====================
TextChatService.OnIncomingMessage = function(message)
    if not message.TextSource then return end
    if message.TextSource.UserId ~= LocalPlayer.UserId then return end
    if message.MessageId == LastMessageId then return end

    LastMessageId = message.MessageId
    HandleCommand(message.Text)
end

--====================
-- SMALL BLACK GUI (REX BOT)
--====================
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.Name = "RexBotGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0.02, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -30, 0, 25)
title.Text = "rex bot"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -25, 0, 0)
close.Text = "✖"
close.BackgroundColor3 = Color3.fromRGB(30,30,30)
close.TextColor3 = Color3.new(1,0,0)
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1, -20, 0, 30)
box.Position = UDim2.new(0, 10, 0, 40)
box.Text = TargetName
box.BackgroundColor3 = Color3.fromRGB(20,20,20)
box.TextColor3 = Color3.new(1,1,1)
box.FocusLost:Connect(function()
    TargetName = box.Text
    WordIndex = 1
end)

local startBtn = Instance.new("TextButton", frame)
startBtn.Size = UDim2.new(0.45, 0, 0, 30)
startBtn.Position = UDim2.new(0.05, 0, 0, 85)
startBtn.Text = "START"
startBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
startBtn.TextColor3 = Color3.new(0,1,0)
startBtn.MouseButton1Click:Connect(function()
    ChatSpam = true
    StartSpam()
end)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Size = UDim2.new(0.45, 0, 0, 30)
stopBtn.Position = UDim2.new(0.5, 0, 0, 85)
stopBtn.Text = "STOP"
stopBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
stopBtn.TextColor3 = Color3.new(1,0,0)
stopBtn.MouseButton1Click:Connect(function()
    ChatSpam = false
end)

