--====================================================
-- REX CHAT BOT | STABLE 1 MSG PER SECOND
--====================================================

-- Load Orion
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Services
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--====================
-- VARIABLES
--====================
local ChatSpam = false
local SpamRunning = false -- IMPORTANT: prevents duplicate loops
local ChatDelay = 1 -- EXACTLY 1 second
local TargetName = "PlayerName"

local SpamMessages = {}
local SpamIndex = 1

--====================
-- GENERATE SPAM LINES
--====================
local function GenerateSpamMessages()
    SpamMessages = {
        "____________________________________________________________________________________________ " .. TargetName .. " TMKX ME DRUM",
        "____________________________________________________________________________________________ " .. TargetName .. " TMKX ME GUITAR",
        "____________________________________________________________________________________________ " .. TargetName .. " TMKX ME BASS",
        "____________________________________________________________________________________________ " .. TargetName .. " TMKX ME MIC",
        "____________________________________________________________________________________________ " .. TargetName .. " TMKX ME PIANO"
    }
    SpamIndex = 1
end

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
-- START SPAM (SAFE)
--====================
local function StartSpam()
    if SpamRunning then return end -- PREVENT DOUBLE LOOP
    SpamRunning = true
    ChatSpam = true
    GenerateSpamMessages()

    task.spawn(function()
        while ChatSpam do
            SendChat(SpamMessages[SpamIndex])
            SpamIndex = SpamIndex + 1
            if SpamIndex > #SpamMessages then
                SpamIndex = 1
            end
            task.wait(ChatDelay) -- EXACT 1 SECOND
        end
        SpamRunning = false
    end)
end

--====================
-- STOP SPAM
--====================
local function StopSpam()
    ChatSpam = false
end

--====================
-- CHAT COMMANDS
--====================
local function HandleChatCommand(message)
    message = string.lower(message)

    if message == "hi bot" then
        SendChat("_______________________________________________________________________________________________________________________ HELLO REX SIR")
    elseif message == "start spam" then
        SendChat("[BOT] Spam started")
        StartSpam()
    elseif message == "stop spam" then
        StopSpam()
        SendChat("[BOT] Spam stopped")
    end
end

--====================
-- CHAT LISTENER
--====================
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.MessageReceived:Connect(function(message)
        if message.TextSource and Players:GetPlayerByUserId(message.TextSource.UserId) == LocalPlayer then
            HandleChatCommand(message.Text)
        end
    end)
else
    LocalPlayer.Chatted:Connect(HandleChatCommand)
end

--====================
-- UI
--====================
local Window = OrionLib:MakeWindow({
    Name = "Rex Chat Bot",
    SaveConfig = true,
    ConfigFolder = "RexBot"
})

local BotTab = Window:MakeTab({
    Name = "Chat Bot",
    Icon = "rbxassetid://4483345998"
})

-- Hello Button
BotTab:AddButton({
    Name = "Say HELLO REX SIR",
    Callback = function()
        SendChat("_______________________________________________________________________________________________________________________ HELLO REX SIR")
    end
})

-- HATER NAME TEXTBOX (WORKING)
BotTab:AddTextbox({
    Name = "Hater / Target Name",
    Default = "PlayerName",
    TextDisappear = false,
    Callback = function(Value)
        TargetName = Value
        GenerateSpamMessages()
    end
})

-- Spam Toggle
BotTab:AddToggle({
    Name = "Chat Spam (1 msg / sec)",
    Default = false,
    Callback = function(Value)
        if Value then
            SendChat("[BOT] Spam started")
            StartSpam()
        else
            StopSpam()
            SendChat("[BOT] Spam stopped")
        end
    end
})

-- Destroy UI
BotTab:AddButton({
    Name = "Destroy UI",
    Callback = function()
        OrionLib:Destroy()
    end
})

OrionLib:Init()

