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
local ChatDelay = 1 -- FIXED TO 1 SECOND
local ChatCommandsEnabled = true
local TargetName = "PlayerName"
local SpamThreadRunning = false
local SpamMessage = ""

--====================
-- GENERATE SPAM MESSAGE
--====================
local function GenerateSpam()
    local baseLine =
        string.rep("_", 90)
        .. " "
        .. TargetName
        .. " TMKX ME DRUM "

    -- repeat to make it very long (1000+ characters)
    SpamMessage = string.rep(baseLine, 12)
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
-- START SPAM (SAFE)
--====================
local function StartSpam()
    if SpamThreadRunning then return end
    SpamThreadRunning = true
    ChatSpam = true
    GenerateSpam()

    task.spawn(function()
        while ChatSpam do
            task.wait(ChatDelay)
            SendChat(SpamMessage)
        end
        SpamThreadRunning = false
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

    if message == "start spam" then
        SendChat("[BOT] Spam started")
        StartSpam()
    end

    if message == "stop spam" then
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
-- ORION UI
--====================
local Window = OrionLib:MakeWindow({
    Name = "Rex Chat Bot",
    SaveConfig = true,
    ConfigFolder = "RexBot"
})

local BotTab = Window:MakeTab({
    Name = "Chat Bot",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

BotTab:AddButton({
    Name = "Say HELLO REX SIR",
    Callback = function()
        SendChat("_______________________________________________________________________________________________________________________ HELLO REX SIR")
    end
})

BotTab:AddTextbox({
    Name = "Target / Hater Name",
    Default = "PlayerName",
    TextDisappear = false,
    Callback = function(Value)
        TargetName = Value
        GenerateSpam()
    end
})

BotTab:AddToggle({
    Name = "Chat Spam",
    Default = false,
    Callback = function(Value)
        if Value then
            SendChat("[BOT] Spam started")
            StartSpam()
        else
            ChatSpam = false
            SendChat("[BOT] Spam stopped")
        end
    end
})

BotTab:AddToggle({
    Name = "Enable Chat Commands",
    Default = true,
    Callback = function(Value)
        ChatCommandsEnabled = Value
    end
})

BotTab:AddButton({
    Name = "Destroy UI",
    Callback = function()
        OrionLib:Destroy()
    end
})

OrionLib:Init()

