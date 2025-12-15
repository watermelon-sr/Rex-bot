-- REX CHAT BOT | ORION UI

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

local ChatSpam = false
local ChatMessage = "Hello world!"
local ChatDelay = 2
local ChatCommands = true
local TargetName = "PlayerName"
local SpamThread = false

local function SendChat(msg)
    pcall(function()
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
        else
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        end
    end)
end

local function StartSpam()
    if SpamThread then return end
    SpamThread = true
    ChatSpam = true
    task.spawn(function()
        while ChatSpam do
            task.wait(ChatDelay)
            SendChat("@" .. TargetName .. " " .. ChatMessage)
        end
        SpamThread = false
    end)
end

local function HandleChat(msg)
    if not ChatCommands then return end
    msg = msg:lower()
    if msg == "hi bot" then
        SendChat("hello rex sir")
    elseif msg == "start spam" then
        SendChat("[BOT] Spam started")
        StartSpam()
    elseif msg == "stop spam" then
        ChatSpam = false
        SendChat("[BOT] Spam stopped")
    end
end

if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.MessageReceived:Connect(function(m)
        if m.TextSource and Players:GetPlayerByUserId(m.TextSource.UserId) == LP then
            HandleChat(m.Text)
        end
    end)
else
    LP.Chatted:Connect(HandleChat)
end

local Window = OrionLib:MakeWindow({Name="Rex Chat Bot",SaveConfig=true,ConfigFolder="RexBot"})
local Tab = Window:MakeTab({Name="Chat Bot",Icon="rbxassetid://4483345998"})

Tab:AddTextbox({Name="Target Name",Default="PlayerName",Callback=function(v) TargetName=v end})
Tab:AddTextbox({Name="Spam Message",Default="Hello world!",Callback=function(v) ChatMessage=v end})
Tab:AddSlider({Name="Delay",Min=0.5,Max=10,Default=2,Increment=0.5,Callback=function(v) ChatDelay=v end})

Tab:AddToggle({
    Name="Chat Spam",
    Callback=function(v)
        if v then
            SendChat("[BOT] Spam started")
            StartSpam()
        else
            ChatSpam=false
            SendChat("[BOT] Spam stopped")
        end
    end
})

Tab:AddToggle({Name="Chat Commands",Default=true,Callback=function(v) ChatCommands=v end})
Tab:AddButton({Name="Destroy UI",Callback=function() OrionLib:Destroy() end})

OrionLib:Init()
