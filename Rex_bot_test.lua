--====================================================
-- REX CHAT BOT | FINAL | DELTA SAFE
--====================================================

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--====================
-- STATE
--====================
local ChatSpam = false
local BotLocked = false
local TargetName = "RyZ HATERS"
local WordIndex = 1
local SpamThread = nil

local Words = {
    "BUILDING","CLASSROOM","STUDENT","KNOWLEDGE","LEARNING","SCIENCE","MATH","HISTORY",
    "GEOGRAPHY","PHYSICS","CHEMISTRY","BIOLOGY","LABORATORY","EXPERIMENT","FORMULA",
    "EQUATION","ENERGY","MOTION","SPACE","PLANET","GALAXY","UNIVERSE","QUANTUM",
    "ATOM","MOLECULE","ELECTRICITY","TECHNOLOGY","SOFTWARE","HARDWARE","INTERNET",
    "ALGORITHM","LOGIC","MEMORY","CREATIVITY","DISCOVERY","INNOVATION","FUTURE"
}

--====================
-- CHAT SEND
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
local function NextSpam()
    local word = Words[WordIndex]
    WordIndex += 1
    if WordIndex > #Words then
        WordIndex = 1
    end
    return "____________________________________________________________________________________________________ " ..
           TargetName .. " TMKX MAI " .. word
end

--====================
-- START SPAM
--====================
local function StartSpam(resetIndex)
    if resetIndex then
        WordIndex = 1
    end
    if ChatSpam then return end
    ChatSpam = true
    SpamThread = task.spawn(function()
        while ChatSpam do
            SendChat(NextSpam())
            task.wait(3 + math.random())
        end
    end)
end

--====================
-- STOP SPAM
--====================
local function StopSpam()
    ChatSpam = false
end

--====================
-- COMMAND HANDLER
--====================
local function HandleCommand(msg)
    if BotLocked then return end
    msg = string.lower(msg)

    if msg == "hi bot" or msg == "bot" then
        SendChat("____________________________________________________________________________________________________ HELLO REX SIR 💖")
        return
    end

    if msg == "start spam" then
        SendChat("____________________________________________________________________________________________________ Spam starting in 20 seconds script by Rex")
        task.delay(20, function()
            if not BotLocked then
                StartSpam(false)
            end
        end)
        return
    end

    if msg == "start-" then
        StartSpam(false)
        return
    end

    if msg == "stop-" then
        StopSpam()
        StartSpam(true)
        return
    end

    if msg == "stop spam" then
        StopSpam()
        return
    end

    if msg == "lock bot" then
        BotLocked = true
        StopSpam()
        SendChat("____________________________________________________________________________________________________ bot locked 🔐")
        return
    end

    if msg == "unlock bot" then
        BotLocked = false
        SendChat("____________________________________________________________________________________________________ bot unlocked 🔓")
        return
    end
end

--====================
-- CHAT LISTENER (NO DUPLICATES)
--====================
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.OnIncomingMessage = function(m)
        if m.TextSource and m.TextSource.UserId == LocalPlayer.UserId then
            HandleCommand(m.Text)
        end
    end
else
    LocalPlayer.Chatted:Connect(HandleCommand)
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
    end
})

Tab:AddToggle({
    Name = "Chat Spam",
    Default = false,
    Callback = function(v)
        if v then
            StartSpam(false)
        else
            StopSpam()
        end
    end
})

Tab:AddButton({
    Name = "Destroy UI",
    Callback = function()
        OrionLib:Destroy()
    end
})

OrionLib:Init()

