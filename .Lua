local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "Grimoires Legacy Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "GLHub"})
 
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local VirtualUser = game:service('VirtualUser')
 
getgenv().AutoFarm = false
getgenv().AutoQuest = false
getgenv().AutoFastAttack = false
getgenv().EquipAutoBest = false
getgenv().AutoStats = false
getgenv().SafeTPEnabled = false
getgenv().LifeThreshold = 30
getgenv().AutoFinderName = ""
getgenv().FarmMode = "Individual"
getgenv().ThemeColor = Color3.fromRGB(0, 120, 255)
getgenv().StatsDistribution = {Strength = 5, Mana = 5, Health = 5}
getgenv().DetectedAdmins = {"admin", "staff", "mod", "owner"}
 
local FarmTab = Window:MakeTab({Name = "Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false})
FarmTab:AddToggle({Name = "Auto Farm", Default = false, Callback = function(val) getgenv().AutoFarm = val end})
FarmTab:AddToggle({Name = "Auto Fast Attack", Default = false, Callback = function(val) getgenv().AutoFastAttack = val end})
FarmTab:AddDropdown({
    Name = "Opções de Farm",
    Default = "Individual",
    Options = {"Individual", "Aglomerado"},
    Callback = function(val) getgenv().FarmMode = val end
})
 
local OutTab = Window:MakeTab({Name = "Outros", Icon = "rbxassetid://4483345998", PremiumOnly = false})
OutTab:AddColorpicker({Name = "Cor do Tema", Default = getgenv().ThemeColor, Callback = function(val) getgenv().ThemeColor = val Window:SetColor(val) end})
 
local ExtraTab = Window:MakeTab({Name = "Extras", Icon = "rbxassetid://4483345998", PremiumOnly = false})
ExtraTab:AddToggle({Name = "Auto Equipar Melhor Grimoire", Default = false, Callback = function(val) getgenv().EquipAutoBest = val end})
ExtraTab:AddToggle({Name = "Distribuir Pontos Automaticamente", Default = false, Callback = function(val) getgenv().AutoStats = val end})
ExtraTab:AddToggle({Name = "Safe Teleport Automático", Default = false, Callback = function(val) getgenv().SafeTPEnabled = val end})
ExtraTab:AddTextbox({Name = "Threshold de Vida (%)", Default = "30", TextDisappear = false, Callback = function(val) getgenv().LifeThreshold = tonumber(val) or 30 end})
ExtraTab:AddTextbox({Name = "Nome do Grimoire Desejado", Default = "", TextDisappear = false, Callback = function(val) getgenv().AutoFinderName = val end})
 
game:GetService("RunService").Stepped:Connect(function()
    if getgenv().SafeTPEnabled then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health <= getgenv().LifeThreshold then
            char:SetPrimaryPartCFrame(CFrame.new(0, 500, 0))
        end
    end
end)
 
player.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
 
game.Players.PlayerAdded:Connect(function(p)
    for _, admin in pairs(getgenv().DetectedAdmins) do
        if string.find(p.Name:lower(), admin:lower()) then
            OrionLib:MakeNotification({Name = "Admin Detectado", Content = "Jogador suspeito: " .. p.Name, Time = 5})
            getgenv().AutoFarm = false
        end
    end
end)
 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = player:WaitForChild("PlayerGui")
local EquipGrimoireEvent = ReplicatedStorage:FindFirstChild("EquipGrimoire")
local Inventory = {}
 
local function updateInventory()
    Inventory = {}
    local invGui = playerGui:FindFirstChild("InventoryGui")
    if not invGui then return end
    local invList = invGui:FindFirstChild("InventoryList")
    if not invList then return end
 
    for _, grimoireFrame in pairs(invList:GetChildren()) do
        if grimoireFrame:IsA("Frame") then
            local grimoireData = {
                ID = grimoireFrame:GetAttribute("ID") or 0,
                Name = grimoireFrame:GetAttribute("Name") or "Unknown",
                Level = grimoireFrame:GetAttribute("Level") or 0,
                Rarity = grimoireFrame:GetAttribute("Rarity") or 0,
                Equipped = grimoireFrame:GetAttribute("Equipped") or false,
            }
            table.insert(Inventory, grimoireData)
        end
    end
end
 
local function findBestGrimoire()
    table.sort(Inventory, function(a, b)
        if a.Level == b.Level then return a.Rarity > b.Rarity end
        return a.Level > b.Level
    end)
    for _, grimoire in ipairs(Inventory) do
        if not grimoire.Equipped then return grimoire end
    end
    return nil
end
 
local function equipGrimoire(grimoire)
    if not grimoire or not EquipGrimoireEvent then return end
    EquipGrimoireEvent:FireServer(grimoire.ID)
end
 
local function autoEquipBestGrimoire()
    updateInventory()
    local best = findBestGrimoire()
    if best then equipGrimoire(best) end
end
 
local function distributeStats()
    if not getgenv().AutoStats then return end
    local statEvent = ReplicatedStorage:FindFirstChild("DistributeStat") -- verifique nome correto
    if not statEvent then return end
    for stat, value in pairs(getgenv().StatsDistribution) do
        statEvent:FireServer(stat, value)
        wait(0.1)
    end
end
 
game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().EquipAutoBest then
        autoEquipBestGrimoire()
    end
    if getgenv().AutoStats then
        distributeStats()
    end
end)
 
Window:MakeNotification({
    Name = "Script Carregado",
    Content = "Grimoires Legacy Hub ativado com sucesso!",
    Time = 5
})
 
OrionLib:Init()
 
 
Add Comment
Please, Sign In to add comment
create new paste  /  syntax languages  /  archive  /  faq  /  tools  /  night mode  /  api  /  scraping api  /  news  /  pro
privacy statement  /  cookies policy  /  terms of service /  security disclosure  /  dmca  /  report abuse  /  contact

