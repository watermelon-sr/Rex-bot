
--====================================================
-- REX CHAT BOT | DELTA SAFE | ORION UI
--====================================================
-- Services
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--====================
-- VARIABLES
--====================
local ChatSpam = false
local SpamRunning = false
local ChatDelay = 2 -- 2 seconds (safe)
local TargetName = "PlayerName"

local SpamWords = {
    "DRUM",
    "GUITAR",
    "BASS",
    "PIANO",
    "MIC",
    "SPEAKER",
    "VIOLIN",
    "TRUMPET",
    "SYNTH",
    "DJ"
}

local WordIndex = 1

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
-- GET NEXT SPAM MESSAGE
--====================
local function GetSpamMessage()
    local word = SpamWords[WordIndex]
    WordIndex += 1
    if WordIndex > #SpamWords then
        WordIndex = 1
    end

    return "____________________________________________________________________________________________ "
        .. TargetName .. " TMKX ME " .. word
end

--====================
-- CHAT COMMAND HANDLER
--====================
local function HandleChatCommand(message)
    message = string.lower(message)

    if message == "bot/hi bot" then
        SendChat("______________________________________________________________________________________________________________________________________________________________________________________________________________________________________ HELLO REX SIR")
    end

    if message == "start spam" and not SpamRunning then
        ChatSpam = true
        SpamRunning = true

        task.spawn(function()
            while ChatSpam do
                task.wait(ChatDelay)
                SendChat(GetSpamMessage())
            end
            SpamRunning = false
        end)
    end

    if message == "stop spam" then
        ChatSpam = false
    end
end

--====================
-- CHAT LISTENER
--====================
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.MessageReceived:Connect(function(msg)
        if msg.TextSource then
            local plr = Players:GetPlayerByUserId(msg.TextSource.UserId)
            if plr == LocalPlayer then
                HandleChatCommand(msg.Text)
            end
        end
    end)
else
    LocalPlayer.Chatted:Connect(HandleChatCommand)
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

-- Hello Button
Tab:AddButton({
    Name = "Say HELLO REX SIR",
    Callback = function()
        SendChat("______________________________________________________________________________________________________________________________________________________________________________________________________________________________________ HELLO REX SIR")
    end
})

-- Hater Name Textbox (VISIBLE + WORKING)
Tab:AddTextbox({
    Name = "Hater / Target Name",
    Default = "PlayerName",
    TextDisappear = false,
    Callback = function(Value)
        TargetName = Value
    end
})

-- Spam Toggle
Tab:AddToggle({
    Name = "Chat Spam",
    Default = false,
    Callback = function(Value)
        ChatSpam = Value
        if Value and not SpamRunning then
            SpamRunning = true
            task.spawn(function()
                while ChatSpam do
                    task.wait(ChatDelay)
                    SendChat(GetSpamMessage())
                end
                SpamRunning = false
            end)
        end
    end
})

-- Destroy UI
Tab:AddButton({
    Name = "Destroy UI",
    Callback = function()
        OrionLib:Destroy()
    end
})

OrionLib:Init()
