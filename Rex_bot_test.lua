--====================================================
-- UNIVERSAL ROBLOX CHAT BOT | ORION UI
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
local ChatDelay = 1 -- spam delay 1 second
local ChatCommandsEnabled = true
local TargetName = "PlayerName" -- default hater/target
local SpamMessages = {} -- table of spam lines with different endings

--====================
-- FUNCTION TO GENERATE SPAM LINES
--====================
local function GenerateSpamMessages()
    local endings = {"DRUM", "GUITAR", "BASS", "PIANO", "MIC", "SYNTH", "TRUMPET", "VIOLIN"}
    SpamMessages = {}
    for _, ending in pairs(endings) do
        table.insert(SpamMessages, "____________________________________________________________________________________________ " .. TargetName .. " TMKX ME " .. ending)
    end
end

--====================
-- CHAT SEND FUNCTION
--====================
local function SendChat(msg)
    pcall(function()
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
        else
            ReplicatedStorage
                .DefaultChatSystemChatEvents
                .SayMessageRequest
                :FireServer(msg, "All")
        end
    end)
end

--====================
-- CHAT COMMAND HANDLER
--====================
local function HandleChatCommand(message)
    if not ChatCommandsEnabled then return end
    message = string.lower(message)

    if message == "hi bot" then
        SendChat("_______________________________________________________________________________________________________________________ HELLO REX SIR")
    end

    if message == "start spam" and not ChatSpam then
        ChatSpam = true
        SendChat("[BOT] Spam started")

        task.spawn(function()
            GenerateSpamMessages()
            while ChatSpam do
                task.wait(ChatDelay)
                for _, msg in pairs(SpamMessages) do
                    if not ChatSpam then break end
                    SendChat(msg)
                end
            end
        end)
    end

    if message == "stop spam" and ChatSpam then
        ChatSpam = false
        SendChat("[BOT] Spam stopped")
    end
end

--====================
-- CHAT LISTENER
--====================
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.MessageReceived:Connect(function(message)
        if message.TextSource then
            local plr = Players:GetPlayerByUserId(message.TextSource.UserId)
            if plr == LocalPlayer then
                HandleChatCommand(message.Text)
            end
        end
    end)
else
    LocalPlayer.Chatted:Connect(HandleChatCommand)
end

--====================
-- ORION WINDOW
--====================
local Window = OrionLib:MakeWindow({
    Name = "Rex Chat Bot",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "RexBot"
})

--====================
-- BOT TAB
--====================
local BotTab = Window:MakeTab({
    Name = "Chat Bot",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Say Hello Button
BotTab:AddButton({
    Name = "Say: HELLO REX SIR",
    Callback = function()
        SendChat("_______________________________________________________________________________________________________________________ HELLO REX SIR")
    end
})

-- Hater/Target Name Box
BotTab:AddTextbox({
    Name = "Hater / Target Name",
    Default = "PlayerName",
    TextDisappear = false,
    Callback = function(Value)
        TargetName = Value
        GenerateSpamMessages() -- update spam messages immediately
    end
})

-- Spam Delay Slider
BotTab:AddSlider({
    Name = "Spam Delay (seconds)",
    Min = 1,
    Max = 10,
    Default = 1,
    Increment = 0.5,
    Callback = function(Value)
        ChatDelay = Value
    end
})

-- Spam Toggle
BotTab:AddToggle({
    Name = "Chat Spam",
    Default = false,
    Callback = function(Value)
        ChatSpam = Value
        if ChatSpam then
            SendChat("[BOT] Spam started")
            task.spawn(function()
                GenerateSpamMessages()
                while ChatSpam do
                    task.wait(ChatDelay)
                    for _, msg in pairs(SpamMessages) do
                        if not ChatSpam then break end
                        SendChat(msg)
                    end
                end
            end)
        else
            SendChat("[BOT] Spam stopped")
        end
    end
})

-- Chat Commands Toggle
BotTab:AddToggle({
    Name = "Enable Chat Commands",
    Default = true,
    Callback = function(Value)
        ChatCommandsEnabled = Value
    end
})

-- Destroy UI
BotTab:AddButton({
    Name = "Destroy UI",
    Callback = function()
        OrionLib:Destroy()
    end
})

-- Init Orion
OrionLib:Init()

