--====================================================
-- REX CHAT BOT | DELTA SAFE | NO DOUBLE TEXT
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

-- Anti-duplicate system
local LastMessage = ""
local LastTime = 0

local Words = {
    "BUILDING","CLASSROOM","STUDENT","KNOWLEDGE","LEARNING","SCIENCE","MATH","HISTORY",
    "GEOGRAPHY","PHYSICS","CHEMISTRY","BIOLOGY","LABORATORY","EXPERIMENT","FORMULA",
    "EQUATION","ENERGY","MOTION","SPACE","PLANET","GALAXY","UNIVERSE","QUANTUM",
    "ATOM","MOLECULE","ELECTRICITY","TECHNOLOGY","SOFTWARE","HARDWARE","INTERNET",
    "ALGORITHM","LOGIC","MEMORY","CREATIVITY","DISCOVERY","INNOVATION","FUTURE"
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
    return "_________________________________________________________________________________________________________________________________________________________________ " ..
           TargetName .. " TMKX MAI " .. word
end

--====================
-- START SPAM LOOP
--====================
local function StartSpam()
    if SpamThread then return end
    SpamThread = task.spawn(function()
        while ChatSpam do
            SendChat(GetNextSpamMessage())
            task.wait(3 + math.random()) -- 3–4 sec
        end
        SpamThread = nil
    end)
end

--====================
-- COMMAND HANDLER
--====================
local function HandleCommand(msg)
    local now = os.clock()
    msg = string.lower(msg)

    -- 🔒 Anti double trigger
    if msg == LastMessage and (now - LastTime) < 0.7 then
        return
    end
    LastMessage = msg
    LastTime = now

    if BotLocked then
        if msg == "unlock bot" then
            BotLocked = false
            SendChat("___________________________________________________________________________________________________________________________________________ bot unlocked 🔓")
        end
        return
    end

    if msg == "lock bot" then
        BotLocked = true
        ChatSpam = false
        SendChat("_______________________________________________________________________________________________________________________________________________ bot locked 🔐")
        return
    end

    if msg == "hi bot" or msg == "bot" then
        SendChat("____________________________________________________________________________________________________________________________________________________________HELLO REX SIR 💖")
        return
    end

    if msg == "start spam" then
        if ChatSpam then return end
        SendChat("_________________________________________________________________________________________________________________________________________________ Spam starting in 20 seconds script by Rex")
        task.delay(20, function()
            if not BotLocked then
                ChatSpam = true
                StartSpam()
            end
        end)
        return
    end

    if msg == "stop spam" then
        ChatSpam = false
        return
    end

    if msg == "stop" then
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
-- SINGLE CHAT LISTENER (FIXED)
--====================
TextChatService.OnIncomingMessage = function(message)
    if message.TextSource and message.TextSource.UserId == LocalPlayer.UserId then
        HandleCommand(message.Text)
    end
end

--====================
-- ORION UI
--====================
local Window = OrionLib:MakeWindow({
    Name = "Rex Chat Bot",
    SaveConfig = true,
    ConfigFolder = "RexBot"
})

local Tab = Window:MakeTab({
    Name = "Chat Bot",
    Icon = "rbxassetid://4483345998"
})

Tab:AddTextbox({
    Name = "Hater Name",
    Default = "RyZ HATERS",
    TextDisappear = false,
    Callback = function(v)
        TargetName = v
        WordIndex = 1
    end
})

Tab:AddToggle({
    Name = "Chat Spam",
    Default = false,
    Callback = function(v)
        ChatSpam = v
        if v then StartSpam() end
    end
})

Tab:AddButton({
    Name = "Destroy UI",
    Callback = function()
        OrionLib:Destroy()
    end
})

OrionLib:Init()

