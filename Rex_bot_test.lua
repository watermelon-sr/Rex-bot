--====================================================
-- REX CHAT BOT | DELTA SAFE
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
local TargetName = "RyZ HATERS"
local WordIndex = 1

local Words = {
    "BUILDING","CLASSROOM","STUDENT","KNOWLEDGE","LEARNING","SCIENCE","MATH","HISTORY",
    "GEOGRAPHY","PHYSICS","CHEMISTRY","BIOLOGY","LABORATORY","EXPERIMENT","FORMULA",
    "EQUATION","ENERGY","MOTION","SPACE","PLANET","GALAXY","UNIVERSE","QUANTUM",
    "ATOM","MOLECULE","ELECTRICITY","TECHNOLOGY","SOFTWARE","HARDWARE","INTERNET",
    "ALGORITHM","LOGIC","MEMORY","CREATIVITY","DISCOVERY","INNOVATION","FUTURE"
}

--====================
-- SEND CHAT FUNCTION
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
local function GetNextSpamMessage()
    local word = Words[WordIndex]
    WordIndex = WordIndex + 1
    if WordIndex > #Words then
        WordIndex = 1
    end
    return "_________________________________________________________________________________________________________________________________________________________________ " .. TargetName .. " TMKX MAI " .. word
end

--====================
-- HANDLE CHAT COMMAND
--====================
local function HandleChatCommand(message)
    message = string.lower(message)

    -- hi bot or bot command
    if message == "hi bot" or message == "bot" then
        SendChat("______________________________________________________________________________________________________________________________________________________________________HELLO REX SIR 💖")
        return
    end

    -- start spam
    if message == "start spam" then
        if not ChatSpam then
            ChatSpam = true
            task.spawn(function()
                while ChatSpam do
                    SendChat(GetNextSpamMessage())
                    task.wait(3 + math.random()) -- random delay 3-4 seconds
                end
            end)
        end
        return
    end

    -- stop spam
    if message == "stop spam" then
        ChatSpam = false
        return
    end
end

--====================
-- CHAT LISTENER
--====================
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.OnIncomingMessage = function(message)
        if message.TextSource and message.TextSource.UserId == LocalPlayer.UserId then
            HandleChatCommand(message.Text)
        end
    end
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

-- Hater Name Textbox
Tab:AddTextbox({
    Name = "Hater Name",
    Default = "RyZ HATERS",
    TextDisappear = false,
    Callback = function(Value)
        TargetName = Value
        WordIndex = 1 -- reset index
    end
})

-- Spam Toggle
Tab:AddToggle({
    Name = "Chat Spam",
    Default = false,
    Callback = function(Value)
        ChatSpam = Value
        if ChatSpam then
            task.spawn(function()
                while ChatSpam do
                    SendChat(GetNextSpamMessage())
                    task.wait(3 + math.random()) -- random delay 3-4 seconds
                end
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

