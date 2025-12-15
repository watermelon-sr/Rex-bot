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
    return "_________________________________________________________________________________________________________________________________________________________________ "
        .. TargetName .. " TMKX MAI " .. word
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
-- CHAT COMMAND HANDLER
--====================
local function HandleCommand(msg)
    msg = string.lower(msg)

    -- CHANGE HATER NAME COMMAND
    local newName = msg:match("^bot change hater name to (.+)")
    if newName then
        TargetName = newName
        WordIndex = 1
        SendChat("__________________________________________________________________________________________________________________________________________________________ hater name changed to " .. newName)
        return
    end

    -- BOT LOCKED
    if BotLocked then
        if msg == "unlock bot" then
            BotLocked = false
            SendChat("____________________________________________________________________________________________________________________________________________________ bot unlocked🔓")
        end
        return
    end

    -- LOCK BOT
    if msg == "lock bot" then
        BotLocked = true
        ChatSpam = false
        SendChat("__________________________________________________________________________________________________________________________________________________ bot locked 🔐")
        return
    end

    -- HELLO COMMAND
    if msg == "hi bot" or msg == "bot" then
        SendChat("______________________________________________________________________________________________________________________________________________________________________HELLO REX SIR 💖")
        return
    end

    -- START SPAM (WITH 20 SEC DELAY)
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

    -- STOP SPAM
    if msg == "stop spam" then
        ChatSpam = false
        return
    end

    -- PAUSE
    if msg == "stop" then
        ChatSpam = false
        return
    end

    -- RESUME
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

