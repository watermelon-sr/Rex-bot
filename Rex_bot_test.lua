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
local ChatDelay = 3 -- 3 seconds ONLY
local TargetName = "PlayerName"
local WordIndex = 1

--====================
-- WORD LIST (ONE WORD PER MESSAGE)
--====================
local Words = {
"BUILDING","CLASSROOM","STUDENT","KNOWLEDGE","LEARNING","SCIENCE","MATH","HISTORY","GEOGRAPHY",
"PHYSICS","CHEMISTRY","BIOLOGY","LABORATORY","EXPERIMENT","FORMULA","EQUATION","PARAMETER",
"VARIABLE","CONSTANT","MEASUREMENT","THERMOMETER","TEMPERATURE","PRESSURE","GRAVITY","ENERGY",
"MOTION","CYCLE","ROTATION","REVOLUTION","ORBIT","SPACE","PLANET","EARTH","MOON","MARS",
"JUPITER","SATURN","NEPTUNE","URANUS","PLUTO","GALAXY","MILKYWAY","NEBULA","STAR","SUN",
"SUPERNOVA","BLACKHOLE","UNIVERSE","COSMOS","DIMENSION","TIMELINE","REALITY","PARALLEL",
"QUANTUM","PARTICLE","ATOM","MOLECULE","ELEMENT","COMPOUND","REACTION","FUSION","FISSION",
"ELECTRICITY","MAGNETISM","CURRENT","VOLTAGE","RESISTANCE","CIRCUIT","MACHINE","ENGINE",
"MOTOR","ROBOT","ANDROID","TECHNOLOGY","SOFTWARE","HARDWARE","NETWORK","INTERNET",
"SIGNAL","FREQUENCY","WAVELENGTH","SPECTRUM","RADIATION","SATELLITE","ANTENNA","RADAR",
"TELESCOPE","MICROSCOPE","OBSERVATION","ANALYSIS","CALCULATION","PREDICTION","SIMULATION",
"MODEL","STRUCTURE","SYSTEM","FRAMEWORK","ALGORITHM","LOGIC","REASON","THOUGHT","MIND",
"BRAIN","MEMORY","IMAGINATION","CREATIVITY","DREAM","VISION","IDEA","CONCEPT","THEORY",
"HYPOTHESIS","DISCOVERY","INVENTION","INNOVATION","PROGRESS","FUTURE","PAST","PRESENT",
"TIME","CLOCK","SECOND","MINUTE","HOUR","DAY","NIGHT","SEASON","YEAR","CENTURY","MILLENNIUM"
}

--====================
-- CHAT SEND
--====================
local function SendChat(msg)
    pcall(function()
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
        else
            ReplicatedStorage.DefaultChatSystemChatEvents
                .SayMessageRequest:FireServer(msg, "All")
        end
    end)
end

--====================
-- SPAM LOOP (SAFE)
--====================
local function StartSpam()
    if ChatSpam then return end
    ChatSpam = true

    task.spawn(function()
        while ChatSpam do
            local word = Words[WordIndex]
            WordIndex = WordIndex + 1
            if WordIndex > #Words then
                WordIndex = 1
            end

            SendChat("____________________________________________________________________________________________ " ..
                TargetName .. " TMKX ME " .. word)

            task.wait(ChatDelay)
        end
    end)
end

local function StopSpam()
    ChatSpam = false
end

--====================
-- COMMAND HANDLER
--====================
local function HandleChat(msg)
    msg = string.lower(msg)

    if msg == "hi bot" or msg == "bot/hi bot" then
        SendChat("_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________ HELLO REX SIR")
    elseif msg == "start spam" then
        StartSpam()
    elseif msg == "stop spam" then
        StopSpam()
    end
end

--====================
-- CHAT LISTENER
--====================
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.MessageReceived:Connect(function(m)
        if m.TextSource and Players:GetPlayerByUserId(m.TextSource.UserId) == LocalPlayer then
            HandleChat(m.Text)
        end
    end)
else
    LocalPlayer.Chatted:Connect(HandleChat)
end

--====================
-- UI
--====================
local Window = OrionLib:MakeWindow({
    Name = "Rex Chat Bot",
    SaveConfig = true,
    ConfigFolder = "RexBot"
})

local Tab = Window:MakeTab({
    Name = "Chat Bot",
    PremiumOnly = false
})

-- Hater Name Textbox
Tab:AddTextbox({
    Name = "Hater / Target Name",
    Default = "PlayerName",
    TextDisappear = false,
    Callback = function(v)
        TargetName = v
    end
})

-- Spam Toggle
Tab:AddToggle({
    Name = "Chat Spam",
    Default = false,
    Callback = function(v)
        if v then
            StartSpam()
        else
            StopSpam()
        end
    end
})

-- Destroy
Tab:AddButton({
    Name = "Destroy UI",
    Callback = function()
        OrionLib:Destroy()
    end
})

OrionLib:Init()

