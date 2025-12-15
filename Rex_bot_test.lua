--====================================================
-- REX CHAT BOT | DELTA SAFE | ORION UI
--====================================================

-- Services
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--====================
-- SETTINGS
--====================
local LINE = "__________________________________________________________________________________________________________________________________________________________________________________________"
local ChatSpam = false
local ChatDelay = 3 -- 3 seconds
local TargetName = "PlayerName"
local WordIndex = 1

-- Words list (ONE WORD PER MESSAGE)
local Words = {
"BUILDING","CLASSROOM","STUDENT","KNOWLEDGE","LEARNING","SCIENCE","MATH","HISTORY","GEOGRAPHY","PHYSICS","CHEMISTRY","BIOLOGY",
"LABORATORY","EXPERIMENT","FORMULA","EQUATION","PARAMETER","VARIABLE","CONSTANT","MEASUREMENT","THERMOMETER","TEMPERATURE",
"PRESSURE","GRAVITY","ENERGY","MOTION","CYCLE","ROTATION","REVOLUTION","ORBIT","SPACE","PLANET","EARTH","MOON","MARS",
"JUPITER","SATURN","NEPTUNE","URANUS","PLUTO","GALAXY","MILKYWAY","NEBULA","STAR","SUN","SUPERNOVA","BLACKHOLE",
"UNIVERSE","COSMOS","DIMENSION","TIMELINE","REALITY","QUANTUM","ATOM","MOLECULE","ELEMENT","REACTION","ELECTRICITY",
"MAGNETISM","CURRENT","VOLTAGE","CIRCUIT","ROBOT","TECHNOLOGY","SOFTWARE","HARDWARE","NETWORK","INTERNET","SATELLITE",
"TELESCOPE","MICROSCOPE","ANALYSIS","CALCULATION","ALGORITHM","LOGIC","THOUGHT","MEMORY","CREATIVITY","DISCOVERY",
"INVENTION","PROGRESS","FUTURE","TIME","DISCIPLINE","FOCUS","SUCCESS","POWER","BALANCE","DATA","SECURITY","CODE",
"PROGRAM","LANGUAGE","FUNCTION","OBJECT","FRAMEWORK","PLATFORM","APPLICATION","GAME","VIRTUAL","METAVERSE"
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
-- CHAT COMMANDS
--====================
local function HandleChat(message)
    message = string.lower(message)

    if message == "hi bot" or message == "bot" then
        SendChat(LINE .. " HELLO REX SIR")
    end

    if message == "start spam" and not ChatSpam then
        ChatSpam = true
        task.spawn(function()
            while ChatSpam do
                local word = Words[WordIndex]
                SendChat(LINE .. " " .. TargetName .. " TMKX ME " .. word)

                WordIndex += 1
                if WordIndex > #Words then
                    WordIndex = 1
                end

                task.wait(ChatDelay)
            end
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
                HandleChat(msg.Text)
            end
        end
    end)
else
    LocalPlayer.Chatted:Connect(HandleChat)
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

-- Hater Name Box
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

