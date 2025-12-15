--====================================================
-- REX CHAT BOT | DELTA SAFE
--====================================================
-- Services
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--====================
-- ACCESS CONTROL
--====================
local AllowedUsers = {
    ["YourUsernameHere"] = true,
    ["FriendUsername"] = true
}

if not AllowedUsers[LocalPlayer.Name] then
    return
end

--====================
-- VARIABLES
--====================
local ChatSpam = false
local ChatDelay = 3
local TargetName = "PlayerName"
local SpamIndex = 1

local LinePrefix = "____________________________________________________________________________________________"

local Words = {
"BUILDING","CLASSROOM","STUDENT","KNOWLEDGE","LEARNING","SCIENCE","MATH","HISTORY","GEOGRAPHY",
"PHYSICS","CHEMISTRY","BIOLOGY","LABORATORY","EXPERIMENT","FORMULA","EQUATION","VARIABLE",
"ENERGY","MOTION","SPACE","PLANET","GALAXY","UNIVERSE","ATOM","MOLECULE","ELEMENT","REACTION",
"ELECTRICITY","MAGNETISM","CIRCUIT","MACHINE","ROBOT","TECHNOLOGY","SOFTWARE","HARDWARE",
"NETWORK","INTERNET","SATELLITE","TELESCOPE","MICROSCOPE","ANALYSIS","CALCULATION",
"ALGORITHM","LOGIC","MEMORY","CREATIVITY","DISCOVERY","INNOVATION","FUTURE",
"DATA","SECURITY","ENCRYPTION","SERVER","CLIENT","INTERFACE","DISPLAY","PROCESS",
"PROGRAM","LANGUAGE","SCRIPT","CODE","GAME","VIRTUAL","REALITY"
}

--====================
-- SEND CHAT
--====================
local function SendChat(msg)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg,"All")
    end
end

--====================
-- SPAM LOOP
--====================
local function StartSpam()
    task.spawn(function()
        while ChatSpam do
            local word = Words[SpamIndex]
            SendChat(LinePrefix.." "..TargetName.." TMKX ME "..word)

            SpamIndex += 1
            if SpamIndex > #Words then
                SpamIndex = 1
            end

            task.wait(ChatDelay)
        end
    end)
end

--====================
-- COMMAND HANDLER
--====================
local function HandleCommand(msg)
    msg = string.lower(msg)

    if msg == "hi bot" or msg == "bot" then
        SendChat("______________________________________________________________________________________________________________________________________________________________________HELLO REX SIR 💖")
    end

    if msg == "start spam" and not ChatSpam then
        ChatSpam = true
        StartSpam()
    end

    if msg == "stop spam" then
        ChatSpam = false
    end
end

--====================
-- CHAT LISTENER
--====================
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.MessageReceived:Connect(function(m)
        if m.TextSource and Players:GetPlayerByUserId(m.TextSource.UserId) == LocalPlayer then
            HandleCommand(m.Text)
        end
    end)
else
    LocalPlayer.Chatted:Connect(HandleCommand)
end

--====================
-- UI
--====================
local Window = OrionLib:MakeWindow({Name="Rex Bot",SaveConfig=true})

local Tab = Window:MakeTab({Name="Chat Bot"})

Tab:AddTextbox({
    Name="Hater Name",
    Default="PlayerName",
    TextDisappear=false,
    Callback=function(v)
        TargetName = v
    end
})

Tab:AddToggle({
    Name="Spam",
    Default=false,
    Callback=function(v)
        ChatSpam = v
        if v then StartSpam() end
    end
})

Tab:AddButton({
    Name="Destroy UI",
    Callback=function()
        OrionLib:Destroy()
    end
})

OrionLib:Init()

