repeat wait() until game:IsLoaded()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SkyLi000/KoalaHub/main/Library.lua"))()

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Client = Players.LocalPlayer

local Stats = ReplicatedStorage.Stats[Client.Name]
local DataManager = require(ReplicatedStorage.Modules.DataManager)
local JobHandler = require(Client.PlayerGui.MainGUI.Scripts.JobHandler)

local FileName = "KoalaHub/Bloxburg.json"
local HttpService = game:GetService("HttpService")

_G.Settings = {
    SaveVersion = "1.0";
    AutoFarm = {
        BloxyCashier = {
            Enabled = false
        };
        StylezHairdresser = {
            Enabled = false
        }
    }
}

local TempSettings

local function ResetTempSettings()
    TempSettings = {}
    TempSettings = {
        Gui = {
            Enabled = true
        }
    }
end

ResetTempSettings()

local function FireServer(Data)
    local OldI = getfenv(DataManager.FireServer).i
    getfenv(DataManager.FireServer).i = function() end
    DataManager:FireServer(Data)
    getfenv(DataManager.FireServer).i = OldI
end

local function GetOrder(Customer)
    if not Customer or Customer and not Customer:FindFirstChild("Order") then
        return
    end
    if Stats.Job.Value == "BloxyBurgersCashier" then
        local Burger = Customer.Order:WaitForChild("Burger").Value
        local Fries = Customer.Order:WaitForChild("Fries").Value
        local Cola = Customer.Order:WaitForChild("Cola").Value

        return {Burger, Fries, Cola}
    end
end

function RecurseTable(Table, i1, i2)
    for Index, Value in pairs(Table) do
        if type(Value) == "table" then
            if i2 then
                _G.Settings[i1][i2][Index] = Value
            elseif i1 then
                RecurseTable(Value, i1, Index)
            elseif Value then
                RecurseTable(Value, Index)
            end
        else
            if i2 then
                _G.Settings[i1][i2][Index] = Value
            elseif i1 then
                _G.Settings[i1][Index] = Value
            end
        end
    end
end

local function LoadSettings()
    if isfile and readfile then
        if isfile(FileName) then
            local Data = HttpService:JSONDecode(readfile(FileName))
            RecurseTable(Data)
            if not Data["SaveVersion"] == _G.Settings["SaveVersion"] then
                writefile(FileName, HttpService:JSONEncode(_G.Settings))
            end
        end
    end
end

succ, err = pcall(LoadSettings)
if err then
    warn(err)
end

local function SaveSettings()
    if writefile and isfile then
        if isfolder("KoalaHub") then
            writefile(FileName, HttpService:JSONEncode(_G.Settings))
        else
            makefolder("KoalaHub")
            writefile(FileName, HttpService:JSONEncode(_G.Settings))
        end
    end
end

local function DeleteSettings()
    if isfile and delfile then
        if isfolder("KoalaHub") then
            if isfile(FileName) then
                delfile(FileName)
            end
        end
    end
end

function Work(Work)
    JobHandler:GoToWork(Work)
end

function CheckJob(Job)
    if Stats.Job.Value == Work then
        return true
    else
        return false
    end
end

local function CreateUI()
    local Window = Library.CreateWindow("Bloxburg")
    local FarmingTab = Window:Tab("Auto Farm")
    local FarmingSection1 = FarmingTab:Section("Bloxy Burger Cashier")

    FarmingSection1:Toggle("Start Auto Farm", _G.Settings.AutoFarm.BloxyCashier.Enabled, function(Value)
        if not _G.Settings.AutoFarm.StylezHairdresser.Enabled then
            if Value then
                _G.Settings.AutoFarm.BloxyCashier.Enabled = Value
            end
        end
    end)

    local FarmingSection2 = FarmingTab:Section("Stylez Hairdresser - Not Avaliable")

    FarmingSection2:Toggle("Start Auto Farm", _G.Settings.AutoFarm.BloxyCashier.Enabled, function(Value)
        if not _G.Settings.AutoFarm.BloxyCashier.Enabled then
            if Value then
                _G.Settings.AutoFarm.StylezHairdresser.Enabled = Value
            end
        end
    end)

    local OtherTab = Window:Tab("Others")
    local ScriptSection = OtherTab:Section("Scripts")
    local UISection = OtherTab:Section("UI")

    ScriptSection:Button("Save Settings", function()
        SaveSettings()
    end)

    ScriptSection:Button("Delete Settings", function()
        DeleteSettings()
    end)

    UISection:Button("Reload UI", function()
        UISection:DestroyUI()
        CreateUI()
    end)

    UISection:Button("Destroy UI", function()
        ResetTempSettings()
        UISection:DestroyUI()
    end)
end

CreateUI()
print("UI Created!")
print("Initialization Complete!")
wait(5)
print("Intallization Complete!")
while true do
    if _G.Settings.AutoFarm.BloxyCashier.Enabled then
        if not _G.Settings.AutoFarm.StylezHairdresser.Enabled then
            if Stats.Job.Value ~= "BloxyBurgersCashier" then
                JobHandler:GoToWork("BloxyBurgersCashier")
            end
            repeat wait(1) until Stats.Job.Value == "BloxyBurgersCashier"
            TweenService:Create(Client.Character.HumanoidRootPart, TweenInfo.new(0.75,Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(826.7995, 13.3779049, 282.034729, 0.0559822656, -2.75701861e-08, -0.998431742, 2.21829417e-08, 1, -2.63696887e-08, 0.998431742, -2.06719193e-08, 0.0559822656)}):Play()
            local Workstation = Workspace.Environment.Locations.BloxyBurgers.CashierWorkstations
            for i,v in next, Workstation:GetChildren() do
                if v.Occupied.Value then
                    FireServer({
                        Type = "FinishOrder",
                        Workstation = v,
                        Order = GetOrder(v.Occupied.Value)
                    })
                end
            end
        end
    end
    wait()
    if _G.Settings.AutoFarm.StylezHairdresser.Enabled then
        --[[local Workstation = Workspace.Environment.Locations.StylezHairStudio.HairdresserWorkstations
        for i,v in next, Workstation:GetChildren() do
            if v.Occupied.Value then
                FireServer({
                    Type = "FinishOrder",
                    Workstation = v,
                    Order = GetOrder(v.Occupied.Value)
                })
            end
        end]]
    end
end
