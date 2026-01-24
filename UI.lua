-- if getgenv().loaded then 
--     return
-- end 

-- getgenv().loaded = true 

-- task.wait(8)

if LPH_OBFUSCATED == nil then
    local assert = assert
    local type = type
    local setfenv = setfenv
    LPH_ENCNUM = function(toEncrypt, ...)
        assert(type(toEncrypt) == "number" and #{...} == 0, "LPH_ENCNUM only accepts a single constant double or integer as an argument.")
        return toEncrypt
    end
    LPH_NUMENC = LPH_ENCNUM
    LPH_ENCSTR = function(toEncrypt, ...)
        assert(type(toEncrypt) == "string" and #{...} == 0, "LPH_ENCSTR only accepts a single constant string as an argument.")
        return toEncrypt
    end
    LPH_STRENC = LPH_ENCSTR
    LPH_ENCFUNC = function(toEncrypt, encKey, decKey, ...)
        
        assert(type(toEncrypt) == "function" and type(encKey) == "string" and #{...} == 0, "LPH_ENCFUNC accepts a constant function, constant string, and string variable as arguments.")
        return toEncrypt
    end
    LPH_FUNCENC = LPH_ENCFUNC
    LPH_JIT = function(f, ...)
        assert(type(f) == "function" and #{...} == 0, "LPH_JIT only accepts a single constant function as an argument.")
        return f
    end
    LPH_JIT_MAX = LPH_JIT
    LPH_NO_VIRTUALIZE = function(f, ...)
        assert(type(f) == "function" and #{...} == 0, "LPH_NO_VIRTUALIZE only accepts a single constant function as an argument.")
        return f
    end
    LPH_NO_UPVALUES = function(f, ...)
        assert(type(setfenv) == "function", "LPH_NO_UPVALUES can only be used on Lua versions with getfenv & setfenv")
        assert(type(f) == "function" and #{...} == 0, "LPH_NO_UPVALUES only accepts a single constant function as an argument.")
        local env = getrenv()
        return setfenv(
            LPH_NO_VIRTUALIZE(function(...)
                return func(...)
            end),
            setmetatable(
                {
                    func = f
                },
                {
                    __index = env,
                    __newindex = env
                }
            )
        )
    end
    LPH_CRASH = function(...)
        assert(#{...} == 0, "LPH_CRASH does not accept any arguments.")
        game:Shutdown()
        while true do end
    end
    LRM_IsUserPremium = false
    LRM_LinkedDiscordID = "0"
    LRM_ScriptName = "Razer.xyz"
    LRM_TotalExecutions = 0
    LRM_SecondsLeft = math.huge
    LRM_UserNote = "Developer";
end;

local Game_Name = (game.PlaceId == 4991214437 and "Town") or "Universal"

if not getexecutorname then
    getexecutorname = identifyexecutor
end

local Solara = string.match(getexecutorname(), "Solara") == "Solara" or string.match(getexecutorname(), "Xeno") == "Xeno" or getexecutorname() == string.match(getexecutorname(), "Zorara") == "Zorara";

local cloneref = cloneref or function(...) return ... end

local Services = setmetatable({}, {
    __index = LPH_NO_VIRTUALIZE(function(self, service, key)
        return cloneref(game:GetService(service))
    end)
})

local script_key;

if LPH_OBFUSCATED then
    script_key = getfenv().script_key
end

if script_key then
    writefile("Razer.xyz_Key.txt", script_key)
end

spawn(function()
    local getgc = getgc or debug.getgc
    local hookfunction = hookfunction
    local getrenv = getrenv
    local debugInfo = (getrenv and getrenv().debug and getrenv().debug.info) or debug.info
    local newcclosure = newcclosure or function(f) return f end

    if not (getgc and hookfunction and getrenv and debugInfo) then
        return
    end

    local ECSHookComponent = {}
    ECSHookComponent.__index = ECSHookComponent

    function ECSHookComponent.new(methodTable)
        return setmetatable({ methodTable = methodTable }, ECSHookComponent)
    end

    function ECSHookComponent:Hook(methodName, fn)
        local target = self.methodTable[methodName]
        if typeof(target) == "function" then
            hookfunction(target, newcclosure(fn))
        end
    end

    local AdonisDetectorSystem = {}
    AdonisDetectorSystem.__index = AdonisDetectorSystem

    function AdonisDetectorSystem.new()
        return setmetatable({
            detected = nil,
            kill = nil,
            debugMode = false
        }, AdonisDetectorSystem)
    end

    function AdonisDetectorSystem:Scan()
        for _, v in getgc(true) do
            if typeof(v) == "table" then
                local hasDetected = typeof(rawget(v, "Detected")) == "function"
                local hasKill = typeof(rawget(v, "Kill")) == "function"
                local hasVars = rawget(v, "Variables") ~= nil
                local hasProcess = rawget(v, "Process") ~= nil

                if hasDetected and not self.detected then
                    self.detected = rawget(v, "Detected")
                end

                if hasKill and hasVars and hasProcess and not self.kill then
                    self.kill = rawget(v, "Kill")
                end
            end
        end
    end

    function AdonisDetectorSystem:Bypass()
        if self.detected then
            local comp = ECSHookComponent.new({ Detected = self.detected })
            comp:Hook("Detected", function(name, func)
                if name ~= "_" and self.debugMode then
                end
                return true
            end)
        end

        if self.kill then
            local comp = ECSHookComponent.new({ Kill = self.kill })
            comp:Hook("Kill", function(func)
                if self.debugMode then
                end
            end)
        end
    end

    function AdonisDetectorSystem:BypassDebugInfo()
        if debugInfo and self.detected then
            local original; original = hookfunction(debugInfo, newcclosure(function(...)
                if (...) == self.detected then
                    if self.debugMode then
                    end
                    return coroutine.yield(coroutine.running())
                end
                return original(...)
            end))
        end
    end

    local adonis = AdonisDetectorSystem.new()
    adonis:Scan()

    if adonis.detected or adonis.kill then
        adonis:Bypass()
        adonis:BypassDebugInfo()
    else
    end
end)

do 
    Players = Services.Players;
    ReplicatedStorage = Services.ReplicatedStorage;
    UserInputService = Services.UserInputService;
    
    Workspace = Services.Workspace;
    RunService = Services.RunService;
    ProximityPromptService = Services.ProximityPromptService;
    MarketplaceService = Services.MarketplaceService;
    StarterGui = Services.StarterGui
    VirtualInputManager = Services.VirtualInputManager;
    Lighting = Services.Lighting
    mathrandom = math.random;
    mathabs = math.abs;
    Mobile = UserInputService.TouchEnabled

    Cars = {}

    Camera = Workspace.CurrentCamera

    LocalPlayer = Players.LocalPlayer
    Mouse = LocalPlayer:GetMouse()

    Move_Mouse_Function = mousemoverel
end;

local FireServer, InvokeServer, UnreliableFireServer = Instance.new("RemoteEvent").FireServer, Instance.new("RemoteFunction").InvokeServer, Instance.new("UnreliableRemoteEvent").FireServer

if isfunctionhooked then
    if isfunctionhooked(FireServer) or isfunctionhooked(UnreliableFireServer) or isfunctionhooked(InvokeServer) and LPH_OBFUSCATED then
        return Services.LocalPlayer:Kick("Razer.xyz | Rejoin")
    end
end

local SafePosition = CFrame.new(-437, 33, 6653)

local Config = Config or {}
Config = {
    ["Game"] = {
        ["Ray_Systems"] = (Game_Name == "Town" and {"Raycast"} or Game_Name == "Universal" and {"Raycast","FindPartOnRay","FindPartOnRayWithWhitelist"}) or {};
        ["Wall_Bang_Possible"] = (Game_Name == "Universal");
    };

    ["Aimlock"] = {
        ["Enabled"] = false;
        ["Aiming"] = false;
        ["TargetPart"] = "Head";
        ["MaxDistance"] = 300;
        ["Mode"] = "Toggle"; 
        ["Type"] = "Mouse"; 
        ["Keybind"] = nil;
        ["WallCheck"] = false;
        ["Priority"] = {};
        ["Whitelisted"] = {};
        ["DrawFieldOfView"] = false;
        ["UseFieldOfView"] = false;
        ["Radius"] = 100;
        ["FieldOfViewColor"] = Color3.new(1,1,1);
        ["FieldOfViewTransparency"] = 0.25;
        ["Sides"] = 100;
        ["Smoothness"] = 1;
        ["Snapline"] = false;
        ["SnaplineColor"] = Color3.new(1,1,1);
        ["SnaplineThickness"] = 1;
    };

    ["Silent"] = {
        ["Enabled"] = false;
        ["Targetting"] = false;
        ["TargetPart"] = {"Head"};
        ["Mode"] = "nil";
        ["MaxDistance"] = 300;
        ["Keybind"] = nil;
        ["WallCheck"] = false;
        ["WallBang"] = false;
        ["Priority"] = {};
        ["Whitelisted"] = {};
        ["DrawFieldOfView"] = false;
        ["UseFieldOfView"] = false;
        ["Radius"] = 100;
        ["FieldOfViewColor"] = Color3.new(1,1,1);
        ["FieldOfViewTransparency"] = 0.25;
        ["Sides"] = 100;
        ["HitChance"] = 100;
        ["Snapline"] = false;
        ["SnaplineColor"] = Color3.new(1,1,1);
        ["Damage"] = 100;
        ["SnaplineThickness"] = 1;
    };

    ["WorldVisuals"] = {
        ["SaturationEnabled"] = false;
        ["Saturation_Value"] = 1;

        ["FogColorEnabled"] = false;
        ["FogColor"] = Color3.new(1,1,1);

        ["AmbientEnabled"] = false;
        ["AmbientColor"] = Color3.new(1,1,1);

        ["FieldOfViewEnabled"] = false;
        ["FieldOfViewValue"] = 70;

        ["Fullbright"] = false;
    };

    ["MiscSettings"] = {
        ["Hitbox_Expander"] = {
            ["Enabled"] = false;
            ["Multiplier"] = 15;
            ["Color"] = Color3.new(1,1,1);
            ["Transparency"] = 0;
            ["Type"] = "Block";
            ["Material"] = "ForceField";
            ["Whitelist"] = {};
            ["Part"] = "HumanoidRootPart";
        };

        ["ModifySpeed"] = {
            ["Enabled"] = false;
            ["Value"] = 16;
        };

        ["ModifyJump"] = {
            ["Enabled"] = false;
            ["Infinity"] = false;
            ["Value"] = 50;
        };

        ["Fly"] = {
            ["Enabled"] = false;
            ["Type"] = "CFrame";
            ["Speed"] = 50;
        };

        ["SpinBot"] = {
            ["Enabled"] = false;
            ["Speed"] = 35;
        };

        ["No-Clip"] = false;
    };

    ["Guns"] = {};

    ESP = {
        Enabled = false,
        TeamCheck = false,
        MaxDistance = 500,
        FontSize = 12,
        Font = Enum.Font.Code,
        FadeOut = {
            OnDistance = false,
            OnDeath = true,
            OnLeave = false,
        },
        Options = { 
            Teamcheck = true, TeamcheckRGB = Color3.fromRGB(0, 255, 0),
            Friendcheck = true, FriendcheckRGB = Color3.fromRGB(0, 255, 0),
            Highlight = false, HighlightRGB = Color3.fromRGB(255, 0, 0),
        },
        Drawing = {
            Chams = {
                Enabled  = false,
                Thermal = true,
                FillRGB = Color3.fromRGB(119, 120, 255),
                Fill_Transparency = 80,
                OutlineRGB = Color3.fromRGB(0,0,0),
                Outline_Transparency = 80,
                VisibleCheck = false,
            },
            Names = {
                Enabled = false,
                Transparency = 0,
                RGB = Color3.fromRGB(255, 255, 255),
            },
            Flags = {
                Enabled = false,
            },
            Distances = {
                Enabled = false, 
                Position = "Bottom",
                Transparency = 0,
                RGB = Color3.fromRGB(255, 255, 255),
            },
            Weapons = {
                Enabled = false, WeaponTextRGB = Color3.fromRGB(119, 120, 255),
                Outlined = false,
                Gradient = false,
                Transparency = 0,
                GradientRGB1 = Color3.fromRGB(255, 255, 255), GradientRGB2 = Color3.fromRGB(119, 120, 255),
            },
            Inventory = {
                Enabled = false, RGB = Color3.fromRGB(255, 255, 255),
                Transparency = 0,
            },
            Healthbar = {
                Enabled = false,  
                HealthText = false, Lerp = true, HealthTextRGB = Color3.fromRGB(0, 255, 0),
                Width = 2.5,
                Transparency = 0,
                HealthTextTransparency = 0,
                Gradient = true, GradientRGB1 = Color3.fromRGB(255, 0, 0), GradientRGB2 = Color3.fromRGB(0,255,0)
            },
            Boxes = {
                Animate = true,
                RotationSpeed = 300,
                Gradient = false, GradientRGB1 = Color3.fromRGB(119, 120, 255), GradientRGB2 = Color3.fromRGB(0, 0, 0), 
                GradientFill = true, GradientFillRGB1 = Color3.fromRGB(119, 120, 255), GradientFillRGB2 = Color3.fromRGB(0, 0, 0), 
                Filled = {
                    Enabled = false,
                    Transparency = 0.75,
                    RGB = Color3.fromRGB(0, 0, 0),
                },
                Full = {
                    Enabled = true,
                    Transparency = 0,
                    RGB = Color3.fromRGB(255, 255, 255),
                },
                Bounding = {
                    Enabled = false,
                    Transparency = 0,
                    RGB = Color3.fromRGB(255, 255, 255),
                },
                Corner = {
                    Enabled = false,
                    Transparency = 0,
                    RGB = Color3.fromRGB(255, 255, 255),
                },
            };
        };
        Connections = {
            RunService = Services.RunService;
        };
        Fonts = {};
    };
};

getgenv().library = {
    directory = "Razer.xyz",
    folders = {
        "/fonts",
        "/configs",
        "/assets"
    },
    priority = {},
    whitelist = {},
    flags = {},
    config_flags = {},
    connections = {},   
    notifications = {notifs = {}},
    current_open; 
}

local Images = {"ESP.png", "World.png", "Wrench.png", "Settings.png", "Node.png", "cursor.png", "Bullet.png", "Snapline.png", "Pistol.png", "folder.png", "UZI.png", "FieldOfView2.png", "Lock.png", "Aimlock.png", "Cash.png", "Wheatt.png", "Pickkaxe.png", "unlocked.png"}

for _, path in next, library.folders do 
    makefolder(library.directory .. path)
end

for Index, Value in Images do
    local Location = library.directory.."/assets/"..Value
    if not isfile(Location) then
        local ImageDiddyAhhBlud = game:HttpGet("https://raw.githubusercontent.com/KingVonOBlockJoyce/imagessynex/main/"..Value)
        repeat wait() until ImageDiddyAhhBlud ~= nil
        writefile(Location, ImageDiddyAhhBlud)
    end
end

GetImage = LPH_NO_VIRTUALIZE(function(Name)
    local Location = library.directory.."/assets/"..Name
    if isfile(Location) then
        return getcustomasset(Location)
    end
end)

local Collide_Data = {}

local DefaultPlayerSettings = {}

if not Services.Players.LocalPlayer.Character then
    Services.Players.LocalPlayer.CharacterAdded:Wait()
    task.wait(1)
end

for Index, Value in Services.Players.LocalPlayer.Character:GetDescendants() do
    pcall(LPH_NO_VIRTUALIZE(function()
        if Value.CanCollide == true then
            Collide_Data[Value.Name] = true
        end
    end))
end

if not Solara then
    if Game_Name == "Universal" or Game_Name == "Town" then
        local DTC;

        LPH_NO_VIRTUALIZE(function()
            for Index, Value in next, getgc(true) do
                if type(Value) == "table" then
                    local Detected = rawget(Value, "Detected");
                    local Kill = rawget(Value, "Kill");
                    if type(Detected) == "function" and not DTC then
                        DTC = Detected
                        hookfunction(Detected, function(...)
                            return true
                        end);
                    end;
                    if rawget(Value, "Variables") and rawget(Value, "Process") and typeof(Kill) == "function" then          
                        hookfunction(Kill, function(...)
                        end)
                    end;
                end;
            end;
        end)()

        local Old; Old = hookfunction(getrenv().debug.info, LPH_NO_UPVALUES(function(...)
            local LevelOrFunc, Info = ...
            if DTC and LevelOrFunc == DTC then
                return coroutine.yield(coroutine.running())
            end
            return Old(...)
        end));

        getgenv().AntiCheatBypass = true
    end

    repeat Services.RunService.RenderStepped:Wait() until getgenv().AntiCheatBypass == true
end

local OldLightingSettings = {}

OldLightingSettings["Brightness"] = Lighting.Brightness
OldLightingSettings["ClockTime"] = Lighting.ClockTime
OldLightingSettings["FogEnd"] = Lighting.FogEnd
OldLightingSettings["GlobalShadows"] = Lighting.GlobalShadows
OldLightingSettings["OutdoorAmbient"] = Lighting.OutdoorAmbient

do
    LPH_JIT_MAX(function()
        local getnamecallmethod, hookmetamethod, hookfunction = (getnamecallmethod ~= nil) and clonefunction(getnamecallmethod) or function(...) end, (hookmetamethod ~= nil) and clonefunction(hookmetamethod) or function(...) end, (hookfunction ~= nil) and clonefunction(hookfunction) or function(...) end
        _fireproximityprompt = fireproximityprompt
        if Solara or not fireproximityprompt or string.find(identifyexecutor(), "MacSploit") then
            getgenv().fireproximityprompt = LPH_NO_VIRTUALIZE(function(self, vuln)
                local prompt_settings = {["HoldDuration"] = self.HoldDuration; ["RequiresLineOfSight"] = self.RequiresLineOfSight};

                if not vuln then
                    self.HoldDuration = 0; self.RequiresLineOfSight = false;

                    self:InputHoldBegin()

                    if not (self.HoldDuration == 0) then
                        task.wait(self.HoldDuration)
                    end

                    self:InputHoldEnd()

                    for Index, Value in prompt_settings do
                        self[Index] = Value
                    end
                else
                    self.HoldDuration = 0; self.RequiresLineOfSight = false;

                    _fireproximityprompt(self)
                end
            end)
        end

        local ColorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", Lighting)
        local Tint = Instance.new("ColorCorrectionEffect", Lighting)
        local OldSaturation = ColorCorrection.Saturation
        local OldFogColor = Lighting.FogColor
        local Set_Fog, Set_Fov, Set_FullBright = false, false, false
        RunService.PreRender:Connect(LPH_NO_VIRTUALIZE(function()
            pcall(function()
                if Config.WorldVisuals.SaturationEnabled then
                    ColorCorrection.Saturation = Config.WorldVisuals.Saturation_Value
                else
                    ColorCorrection.Saturation = OldSaturation
                end
            end)

            pcall(function()
                if Config.WorldVisuals.Fullbright then
                    Set_FullBright = false
                    Lighting.Brightness = 2
                    Lighting.ClockTime = 14
                    Lighting.FogEnd = 100000
                    Lighting.GlobalShadows = false
                    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                else
                    if not Set_FullBright then
                        Set_FullBright = true
                        
                        Lighting.Brightness = OldLightingSettings.Brightness
                        Lighting.FogEnd = OldLightingSettings.FogEnd
                        Lighting.GlobalShadows = OldLightingSettings.GlobalShadows
                        Lighting.OutdoorAmbient = OldLightingSettings.OutdoorAmbient
                    end
                end
            end)

            pcall(function()
                if Config.WorldVisuals.AmbientEnabled then
                    Tint.TintColor = Config.WorldVisuals.AmbientColor
                else
                    Tint.TintColor = Color3.new(1,1,1)
                end

                if Config.WorldVisuals.FogColorEnabled then
                    Set_Fog = false
                    Lighting.FogColor = Config.WorldVisuals.FogColor
                else
                    if not Set_Fog then
                        Set_Fog = true

                        Lighting.FogColor = OldFogColor
                    end
                end

                if Config.WorldVisuals.FieldOfViewEnabled then
                    Set_Fov = false
                    Camera.FieldOfView = Config.WorldVisuals.FieldOfViewValue
                else
                    if not Set_Fov then 
                        Set_Fov = true
                        Camera.FieldOfView = 70
                    end
                end
            end)
        end))

        local Stamina_Table = {};

        local Set_Speed, Set_JumpPower, Set_Spectate = false, false, false

        WorldToScreenPoint = Camera.WorldToScreenPoint;
        GetMouseLocation = UserInputService.GetMouseLocation;
        FindFirstChild = Workspace.FindFirstChild;
        GetPlayers = Players.GetPlayers;
        GetChildren = Workspace.GetChildren;
        GetPartsObscuringTarget = Camera.GetPartsObscuringTarget;
        GetDescendants = Workspace.GetDescendants;
        IsA = Workspace.IsA;
        FindFirstChildOfClass = Workspace.FindFirstChildOfClass

        DistanceCheck = LPH_NO_VIRTUALIZE(function(Player, Distance)
            if not Player then
                return false
            end

            if Player.Character and FindFirstChild(Player.Character,"HumanoidRootPart") then
                local Magnitude = (Camera.CFrame.Position - FindFirstChild(Player.Character,"HumanoidRootPart").Position).Magnitude;

                return Distance > Magnitude
            end;

            return false            
        end);

        WallCheck = LPH_NO_VIRTUALIZE(function(Character)
            local Origin = Camera.CFrame.Position;
            local Position = FindFirstChild(Character, "Head").Position;
            local Parameters = RaycastParams.new();
        
            Parameters.FilterDescendantsInstances = { LocalPlayer.Character, Camera, Character };
            Parameters.FilterType = Enum.RaycastFilterType.Blacklist;
            Parameters.IgnoreWater = true;
        
            return not Workspace:Raycast(Origin, Position - Origin, Parameters)            
        end)

        GetClosestPlayerToMouseAimbot = LPH_NO_VIRTUALIZE(function()
            if not Config.Aimlock.Enabled then return end
            if not Config.Aimlock.Aiming then return end
            
            local PriorityPlayers = {}

            local Plrs = Players:GetPlayers()

            if library.priority[1] then
                for Index, Value in Plrs do
                    if Value == LocalPlayer then continue end;
                    if not table.find(library.priority, Value.Name) then continue end;
                    if table.find(library.whitelist, Value.Name) then continue end;
                    if (Value.Character and Value.Character:FindFirstChild(Config.Aimlock.TargetPart) and Value.Character:FindFirstChild("Humanoid") and Value.Character:FindFirstChild("Humanoid").Health > 0) then
                        if FindFirstChildOfClass(Value.Character, "ForceField") then continue end
                        if FindFirstChild(Value.Character, "Torso") and FindFirstChild(Value.Character, "Torso").Material == Enum.Material.ForceField then continue end
                        if Value.Character.Parent == nil then continue end
                        local TargetPart = Value.Character:FindFirstChild(Config.Aimlock.TargetPart)
                        local MouseLocation = Vector2.new(Mouse.X, Mouse.Y)
                        local TargetPartPosition, OnScreen = Camera:WorldToScreenPoint(TargetPart.Position)
                        local Radius = Config.Aimlock.UseFieldOfView and Config.Aimlock.Radius or 9e9
                        local Magnitude = (Vector2.new(TargetPartPosition.X,TargetPartPosition.Y) - MouseLocation).Magnitude
                        if not DistanceCheck(Value, Config.Aimlock.MaxDistance) then continue end

                        if Radius > Magnitude and OnScreen and Value then
                            if (Config.Aimlock.WallCheck and not WallCheck(Value.Character)) then continue end
                            table.insert(PriorityPlayers, {Player = Value, Distance = Magnitude})
                        end
                    end;
                end;
                
                table.sort(PriorityPlayers, function(Player , PlayerTwo)
                    return Player.Distance<PlayerTwo.Distance
                end)

                if PriorityPlayers[1] then
                    return PriorityPlayers[1].Player
                end;
            end;

            local ValidPlayers = {};

            for Index, Value in Plrs do
                if Value == LocalPlayer then continue end;
                if table.find(library.whitelist, Value.Name) then continue end;
                if (Value.Character and Value.Character:FindFirstChild(Config.Aimlock.TargetPart) and Value.Character:FindFirstChild("Humanoid") and Value.Character:FindFirstChild("Humanoid").Health > 0) then
                    if FindFirstChildOfClass(Value.Character, "ForceField") then continue end
                    if FindFirstChild(Value.Character, "Torso") and FindFirstChild(Value.Character, "Torso").Material == Enum.Material.ForceField then continue end
                    if Value.Character.Parent == nil then continue end
                    local TargetPart = Value.Character:FindFirstChild(Config.Aimlock.TargetPart)
                    local MouseLocation = Vector2.new(Mouse.X, Mouse.Y)
                    local TargetPartPosition, OnScreen = Camera:WorldToScreenPoint(TargetPart.Position)
                    local Radius = Config.Aimlock.UseFieldOfView and Config.Aimlock.Radius or 9e9
                    local Magnitude = (Vector2.new(TargetPartPosition.X,TargetPartPosition.Y) - MouseLocation).Magnitude
                    if not DistanceCheck(Value, Config.Aimlock.MaxDistance) then continue end

                    if Radius > Magnitude and OnScreen and Value then
                        if (Config.Aimlock.WallCheck and not WallCheck(Value.Character)) then continue end
                        table.insert(ValidPlayers, {Player = Value, Distance = Magnitude})
                    end;
                end;
            end;
            
            table.sort(ValidPlayers, function(Player , PlayerTwo)
                return Player.Distance<PlayerTwo.Distance
            end);
            
            if ValidPlayers[1] then
                return ValidPlayers[1].Player
            end;

            return nil
        end);

        GetClosestPlayerToPlayer = LPH_NO_VIRTUALIZE(function(Player)
            local _Players = {}

            if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") or not Player.Character:FindFirstChild("Humanoid") then return end

            for Index, Value in Players:GetPlayers() do
                if Player == LocalPlayer and Value == LocalPlayer then continue end

                if not Value.Character or not Value.Character:FindFirstChild("HumanoidRootPart") or not Value.Character:FindFirstChild("Humanoid") then continue end
                if Value.Character:FindFirstChild("Humanoid").Health == 0 then continue end

                if (Player.Character.HumanoidRootPart.Position - Value.Character.HumanoidRootPart.Position).Magnitude > 15 then continue end

                table.insert(_Players, {Plr = Value, Range = (Player.Character.HumanoidRootPart.Position - Value.Character.HumanoidRootPart.Position).Magnitude})
            end

            table.sort(_Players, function(...)
                return select(1, ...).Range < select(2, ...).Range
            end)

            return _Players[1] and _Players[1].Plr or nil
        end);

        GetClosestPlayerToMouseSilent = LPH_NO_VIRTUALIZE(function()
            if not Config.Silent.Enabled then return end
            if not Config.Silent.Targetting then return end
            
            local PriorityPlayers = {}

            local Plrs = GetPlayers(Players)

            if library.priority[1] then
                for Index, Value in Plrs do
                    if Value == LocalPlayer then continue end;
                    if not table.find(library.priority, Value.Name) then continue end;
                    if table.find(library.whitelist, Value.Name) then continue end;
                    if (Value.Character and FindFirstChild(Value.Character, "HumanoidRootPart") and FindFirstChild(Value.Character,"Humanoid") and FindFirstChild(Value.Character,"Humanoid").Health > 0) then
                        if FindFirstChildOfClass(Value.Character, "ForceField") then continue end
                        if FindFirstChild(Value.Character, "Torso") and FindFirstChild(Value.Character, "Torso").Material == Enum.Material.ForceField then continue end
                        if Value.Character.Parent == nil then continue end
                        local TargetPart = FindFirstChild(Value.Character, "HumanoidRootPart");
                        local MouseLocation = Vector2.new(Mouse.X, Mouse.Y)
                        local TargetPartPosition, OnScreen = WorldToScreenPoint(Camera, TargetPart.Position);
                        local Radius = Config.Silent.UseFieldOfView and Config.Silent.Radius or 9e9;
                        local Magnitude = (Vector2.new(TargetPartPosition.X,TargetPartPosition.Y) - MouseLocation).Magnitude;
                        if not DistanceCheck(Value, Config.Silent.MaxDistance) then continue end
                        
                        if Radius > Magnitude and OnScreen and Value then
                            if not Config.Silent.WallBang and (Config.Silent.WallCheck and (not WallCheck(Value.Character))) then continue end;
                            table.insert(PriorityPlayers, {Player = Value, Distance = Magnitude});
                        end;
                    end;
                end;
                
                table.sort(PriorityPlayers, function(Player , PlayerTwo)
                    return Player.Distance<PlayerTwo.Distance
                end);

                if PriorityPlayers[1] then
                    return PriorityPlayers[1].Player
                end;
            end;

            local ValidPlayers = {};

            for Index, Value in Plrs do
                if Value == LocalPlayer then continue end;
                if table.find(library.whitelist, Value.Name) then continue end;
                if (Value.Character and FindFirstChild(Value.Character, "HumanoidRootPart") and FindFirstChild(Value.Character,"Humanoid") and FindFirstChild(Value.Character,"Humanoid").Health > 0) then
                    if FindFirstChildOfClass(Value.Character, "ForceField") then continue end
                    if FindFirstChild(Value.Character, "Torso") and FindFirstChild(Value.Character, "Torso").Material == Enum.Material.ForceField then continue end
                    if Value.Character.Parent == nil then continue end
                    local TargetPart = FindFirstChild(Value.Character, "HumanoidRootPart")
                    local MouseLocation = Vector2.new(Mouse.X, Mouse.Y)
                    local TargetPartPosition, OnScreen = WorldToScreenPoint(Camera, TargetPart.Position)
                    local Radius = Config.Silent.UseFieldOfView and Config.Silent.Radius or 9e9
                    local Magnitude = (Vector2.new(TargetPartPosition.X,TargetPartPosition.Y) - MouseLocation).Magnitude
                    if not DistanceCheck(Value, Config.Silent.MaxDistance) then continue end
                    
                    if Radius > Magnitude and OnScreen and Value then
                        if not Config.Silent.WallBang and (Config.Silent.WallCheck and not WallCheck(Value.Character)) then continue end
                        table.insert(ValidPlayers, {Player = Value, Distance = Magnitude})
                    end
                end;
            end;
            
            table.sort(ValidPlayers, function(Player , PlayerTwo)
                return Player.Distance<PlayerTwo.Distance                
            end);
            
            if ValidPlayers[1] then
                return ValidPlayers[1].Player                
            end;

            return nil            
        end);

        SilentTarget = GetClosestPlayerToMouseSilent()

        TargetTable = {}
        pcall(function()
            TargetTable = {GetClosestPlayerToMouseAimbot()}
        end)
        if not TargetTable then TargetTable = {} end
        
        local __namecall; __namecall = Solara and nil or not Solara and hookmetamethod(Workspace, "__namecall", LPH_NO_VIRTUALIZE(function(...)
            local Arguments = {...};
            local Method = getnamecallmethod();

            if checkcaller() then
                return __namecall(...)
            end;

            if not SilentTarget then
                return __namecall(...)
            end;

            if not Config.Silent.Enabled then
                return __namecall(...)
            end;

            if Game_Name == "Town" then
                if tostring(getcallingscript()) ~= "GunScript" then
                    return __namecall(...)
                end
            end

            if not (mathrandom(0, 100) <= Config.Silent.HitChance) then
                return __namecall(...)
            end

            local RandomPart = Config.Silent.TargetPart[1] and Config.Silent.TargetPart[math.random(1, #Config.Silent.TargetPart)] or "Head"
            
            if Method == "Raycast" and table.find(Config.Game.Ray_Systems, "Raycast") then
                if Config.Silent.Enabled then
                    if Config.Silent.Targetting then
                        local Target = SilentTarget
                        if Target and Target.Character and FindFirstChild(Target.Character, RandomPart) and FindFirstChild(Target.Character,"Humanoid") and FindFirstChild(Target.Character,"Humanoid").Health ~= 0 then
                            local TargetPart = FindFirstChild(Target.Character, RandomPart);
                            local Origin = Arguments[2];
                            local Direction = (TargetPart.Position - Origin).Unit * 1000;

                            Arguments[3] = Direction;
                        end;

                        if Config.Silent.WallBang then
                            local FilterDescendantsInstances = {};

                            if Target.Character then
                                for Index, Value in pairs(GetDescendants(Target.Character)) do
                                    if IsA(Value, "Part") or IsA(Value, "BasePart") or IsA(Value, "MeshPart") then
                                        table.insert(FilterDescendantsInstances, Value)
                                    end
                                end;
                            end;

                            local RaycastParams = RaycastParams.new();

                            RaycastParams.FilterType = Enum.RaycastFilterType.Include
                            RaycastParams.IgnoreWater = false
                            RaycastParams.RespectCanCollide = false
                            RaycastParams.FilterDescendantsInstances = FilterDescendantsInstances
                            Arguments[4] = RaycastParams
                        end;

                        return __namecall(unpack(Arguments))
                    end;
                end;
            end;

            if string.find(string.lower(Method), "findpartonray") and (table.find(Config.Game.Ray_Systems, "FindPartOnRay") or table.find(Config.Game.Ray_Systems, "FindPartOnRayWithWhitelist")) then
                if Config.Silent.Enabled then
                    if Config.Silent.Targetting and mathrandom(0, 100) <= Config.Silent.HitChance then
                        local Target = SilentTarget;
                        if Target and Target.Character and FindFirstChild(Target.Character, RandomPart) and FindFirstChild(Target.Character,"Humanoid") and FindFirstChild(Target.Character,"Humanoid").Health ~= 0 then
                            local TargetPart = FindFirstChild(Target.Character, RandomPart);
                            local Origin = Arguments[2].Origin;

                            local Direction = (TargetPart.Position - Origin).Unit * 9e17;

                            Arguments[2] = Ray.new(Origin, Direction)

                            if Config.Silent.WallBang then
                                return TargetPart, TargetPart.Position, Vector3.new(0,0,0)
                            end

                            return __namecall(unpack(Arguments))
                        end;
                    end;
                end;
            end;

            return __namecall(...)
        end));

        local function Draw(ClassName, Properties)
            if not Drawing or not Drawing.new then
                return {Visible = false, Remove = function() end}
            end
            local success, result = pcall(function()
                local Drawing = Drawing.new(ClassName);

                for Property, Value in Properties do
                    pcall(function() Drawing[Property] = Value end)
                end;

                return Drawing
            end)
            return success and result or {Visible = false, Remove = function() end}
        end;

        local AimbotFieldOfViewOutline = Draw("Circle", {Visible = false, Color = Color3.new(0, 0, 0), Radius = 100, NumSides = 100, Thickness = 4});
        local AimbotFieldOfView = Draw("Circle", {Visible = false, Color = Color3.new(1, 1, 1), Radius = 100, NumSides = 100, Thickness = 2});
        local AimbotFieldOfViewFill = Draw("Circle", {Visible = false, Color = Color3.new(1, 1, 1), Radius = 100, NumSides = 100, Thickness = 2, Filled = true});

        local AimbotSnaplineOutline = Draw("Line", {Visible = false, Color = Color3.new(0, 0, 0), Thickness = 3});
        local AimbotSnapline = Draw("Line", {Visible = false, Color = Color3.new(1, 1, 1), Thickness = 1});

        
        local SilentFieldOfViewOutline = Draw("Circle", {Visible = false, Color = Color3.new(0, 0, 0), Radius = 100, NumSides = 100, Thickness = 4});
        local SilentFieldOfView = Draw("Circle", {Visible = false, Color = Color3.new(1, 1, 1), Radius = 100, NumSides = 100, Thickness = 2});
        local SilentFieldOfViewFill = Draw("Circle", {Visible = false, Color = Color3.new(1, 1, 1), Radius = 100, NumSides = 100, Thickness = 2, Filled = true});
        
        local SilentSnaplineOutline = Draw("Line", {Visible = false, Color = Color3.new(0, 0, 0), Thickness = 3});
        local SilentSnapline = Draw("Line", {Visible = false, Color = Color3.new(1, 1, 1), Thickness = 1});

        RunService:BindToRenderStep("Functions",math.huge,LPH_NO_VIRTUALIZE(function()
            if not Config or not Config.Silent then return end
            if Config.Silent.Mode == "Always" then
                Config.Silent.Targetting = true;
            end;
        
            local MouseLocation = UserInputService:GetMouseLocation()

            if (not LocalPlayer) or (not LocalPlayer.Character) or (not LocalPlayer.Character:FindFirstChild("Humanoid")) then
                return                
            end;

            if not TargetTable then TargetTable = {} end
            if not TargetTable[1] then
                pcall(function()
                    TargetTable[1] = GetClosestPlayerToMouseAimbot()
                end)
            end;

            if (TargetTable[1] and TargetTable[1].Character and TargetTable[1].Character:FindFirstChild("Humanoid") and TargetTable[1].Character:FindFirstChild("Humanoid").Health == 0) then
                TargetTable[1] = nil
            end
            
            local Target = TargetTable[1]
            if (Config.Aimlock.Enabled and Config.Aimlock.Aiming and Config.Aimlock.Type == "Mouse") and (Target and Target.Character and Target.Character:FindFirstChild(Config.Aimlock.TargetPart)) then
                local TargetPosition = Target.Character:FindFirstChild(Config.Aimlock.TargetPart).Position;
                local Result, OnScreen = Camera:WorldToScreenPoint(TargetPosition);
                if OnScreen then
                    Move_Mouse_Function(Vector2.new(Result.X - Mouse.X, Result.Y - Mouse.Y).X / (Config.Aimlock.Smoothness+1) , Vector2.new(Result.X - Mouse.X, Result.Y - Mouse.Y).Y / (Config.Aimlock.Smoothness + 1));
                end
            elseif (Config.Aimlock.Enabled and Config.Aimlock.Aiming and Config.Aimlock.Type == "Camera") and (Target and Target.Character and Target.Character:FindFirstChild(Config.Aimlock.TargetPart)) then
                local Smoothness = Config.Aimlock.Smoothness * 10;
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.p, Target.Character:FindFirstChild(Config.Aimlock.TargetPart).Position), (100 - Smoothness) / 100);
            end;
        
            SilentTarget = GetClosestPlayerToMouseSilent()
            local AimlockTarget = TargetTable[1]

            AimbotFieldOfView.Visible = Config.Aimlock.Enabled and Config.Aimlock.DrawFieldOfView and Config.Aimlock.UseFieldOfView
            AimbotFieldOfView.Radius = Config.Aimlock.Radius
            AimbotFieldOfView.Color = Config.Aimlock.FieldOfViewColor
            AimbotFieldOfView.NumSides = Config.Aimlock.Sides
            AimbotFieldOfView.Position = MouseLocation
            AimbotFieldOfView.NumSides = Config.Aimlock.Sides
            AimbotFieldOfViewOutline.NumSides = Config.Aimlock.Sides
            AimbotFieldOfViewOutline.Radius = AimbotFieldOfView.Radius
            AimbotFieldOfViewOutline.Position = AimbotFieldOfView.Position
            AimbotFieldOfViewOutline.Visible = AimbotFieldOfView.Visible

            AimbotFieldOfViewFill.Visible = AimbotFieldOfView.Visible
            AimbotFieldOfViewFill.NumSides = AimbotFieldOfView.NumSides
            AimbotFieldOfViewFill.Color = AimbotFieldOfView.Color
            AimbotFieldOfViewFill.Radius = AimbotFieldOfView.Radius
            AimbotFieldOfViewFill.Position = AimbotFieldOfView.Position
            AimbotFieldOfViewFill.Transparency = Config.Aimlock.FieldOfViewTransparency

            SilentFieldOfView.Visible = Config.Silent.Enabled and Config.Silent.UseFieldOfView and Config.Silent.DrawFieldOfView
            SilentFieldOfView.Radius = Config.Silent.Radius
            SilentFieldOfView.NumSides = Config.Silent.Sides
            SilentFieldOfView.Color = Config.Silent.FieldOfViewColor
            SilentFieldOfView.NumSides = Config.Silent.Sides
            SilentFieldOfView.Position = MouseLocation

            SilentFieldOfViewFill.Visible = SilentFieldOfView.Visible
            SilentFieldOfViewFill.NumSides = SilentFieldOfView.NumSides
            SilentFieldOfViewFill.Color = SilentFieldOfView.Color
            SilentFieldOfViewFill.Radius = SilentFieldOfView.Radius
            SilentFieldOfViewFill.Position = SilentFieldOfView.Position
            SilentFieldOfViewFill.Transparency = Config.Silent.FieldOfViewTransparency

            SilentFieldOfViewOutline.NumSides = Config.Silent.Sides
            SilentFieldOfViewOutline.Position = SilentFieldOfView.Position
            SilentFieldOfViewOutline.Visible = SilentFieldOfView.Visible
            SilentFieldOfViewOutline.Radius = SilentFieldOfView.Radius

            SilentSnapline.Visible = (Config.Silent.Enabled == true) and (Config.Silent.Targetting == true) and Config.Silent.Snapline and (SilentTarget ~= nil)
            SilentSnapline.Color = Config.Silent.SnaplineColor
            SilentSnapline.Thickness = Config.Silent.SnaplineThickness;
            SilentSnaplineOutline.Thickness = Config.Silent.SnaplineThickness + 2
            SilentSnaplineOutline.Visible = SilentSnapline.Visible

            AimbotSnapline.Color = Config.Aimlock.SnaplineColor
            AimbotSnapline.Visible = (Config.Aimlock.Enabled == true) and (Config.Aimlock.Aiming == true) and Config.Aimlock.Snapline and (AimlockTarget ~= nil)
            AimbotSnapline.Thickness = Config.Aimlock.SnaplineThickness;
            AimbotSnaplineOutline.Thickness = Config.Aimlock.SnaplineThickness + 2
            AimbotSnaplineOutline.Visible = AimbotSnapline.Visible

            if (not SilentTarget or not SilentTarget.Character or not SilentTarget.Character:FindFirstChild("Head")) then
                SilentSnapline.Visible = false
            end;

            if (not AimlockTarget or not AimlockTarget.Character or not AimlockTarget.Character:FindFirstChild(Config.Aimlock.TargetPart)) then
                AimbotSnapline.Visible = false
            end;

            local _Part = "Head"

            if SilentTarget and SilentTarget.Character and SilentTarget.Character:FindFirstChild(_Part) then
                local SilentPosition, OnScreen = Camera:WorldToViewportPoint(SilentTarget.Character:FindFirstChild(_Part).Position)

                SilentSnapline.Visible = (Config.Silent.Snapline and SilentTarget and OnScreen)
                SilentSnapline.Visible = SilentSnapline.Visible

                if (SilentSnapline.Visible and OnScreen) then
                    SilentSnapline.From = MouseLocation
                    SilentSnaplineOutline.From = SilentSnapline.From

                    SilentSnapline.To = Vector2.new(SilentPosition.X, SilentPosition.Y)
                    SilentSnaplineOutline.To = SilentSnapline.To
                end;
            end;

            if AimlockTarget and AimlockTarget.Character and AimlockTarget.Character:FindFirstChild(Config.Aimlock.TargetPart) then
                local AimlockPosition, OnScreen = Camera:WorldToViewportPoint(AimlockTarget.Character:FindFirstChild(Config.Aimlock.TargetPart).Position)

                AimbotSnapline.Visible = (Config.Aimlock.Snapline and AimlockTarget and OnScreen)
                AimbotSnaplineOutline.Visible = AimbotSnapline.Visible

                if (AimbotSnapline.Visible and OnScreen) then
                    AimbotSnapline.From = MouseLocation
                    AimbotSnaplineOutline.From = AimbotSnapline.From

                    AimbotSnapline.To = Vector2.new(AimlockPosition.X, AimlockPosition.Y)
                    AimbotSnaplineOutline.To = AimbotSnapline.To
                end;
            end;
        end));

        if not LocalPlayer.Character then
            LocalPlayer.CharacterAdded:Wait()
        end

        local ConnectHitboxToPlayer = function(Player)
            task.spawn(LPH_NO_VIRTUALIZE(function()
                while (Player ~= nil) and task.wait(0.25) do
                    if not Player.Character then continue end
                    if Player.Character then
                        if not Player.Character:FindFirstChild("HumanoidRootPart") or not Player.Character:FindFirstChild("Humanoid") then
                            continue
                        end

                        if not Player.Character:FindFirstChild("Head") or not Player.Character:FindFirstChild("Humanoid") then
                            continue
                        end

                        local HumanoidRootPart, Head, Humanoid = Player.Character:FindFirstChild("HumanoidRootPart"), Player.Character:FindFirstChild("Head"), Player.Character:FindFirstChild("Humanoid")

                        if Humanoid.Sit and not DefaultPlayerSettings[Player.Name] then continue end

                        if not DefaultPlayerSettings[Player.Name] then
                            DefaultPlayerSettings[Player.Name] = {}
                            DefaultPlayerSettings[Player.Name].HeadSettings = {}
                            DefaultPlayerSettings[Player.Name].RootSettings = {}

                            DefaultPlayerSettings[Player.Name].HeadSettings.Size = Head.Size
                            DefaultPlayerSettings[Player.Name].HeadSettings.Color = Head.Color
                            DefaultPlayerSettings[Player.Name].HeadSettings.Massless = Head.Massless
                            DefaultPlayerSettings[Player.Name].HeadSettings.CanCollide = Head.CanCollide
                            DefaultPlayerSettings[Player.Name].HeadSettings.Material = Head.Material
                            DefaultPlayerSettings[Player.Name].HeadSettings.Transparency = Head.Transparency

                            DefaultPlayerSettings[Player.Name].RootSettings.Size = HumanoidRootPart.Size
                            DefaultPlayerSettings[Player.Name].RootSettings.Color = HumanoidRootPart.Color
                            DefaultPlayerSettings[Player.Name].RootSettings.Massless = HumanoidRootPart.Massless
                            DefaultPlayerSettings[Player.Name].RootSettings.CanCollide = HumanoidRootPart.CanCollide
                            DefaultPlayerSettings[Player.Name].RootSettings.Material = HumanoidRootPart.Material
                            DefaultPlayerSettings[Player.Name].RootSettings.Transparency = HumanoidRootPart.Transparency
                            DefaultPlayerSettings[Player.Name].RootSettings.Shape = HumanoidRootPart.Shape
                        end

                        if not Config.MiscSettings.Hitbox_Expander.Enabled or Humanoid.Sit or Humanoid.Health == 0 or table.find(library.whitelist, Player.Name) then
                            for Index, Value in DefaultPlayerSettings[Player.Name].RootSettings do
                                HumanoidRootPart[Index] = Value
                            end

                            for Index, Value in DefaultPlayerSettings[Player.Name].HeadSettings do
                                Head[Index] = Value
                            end

                            if Head:FindFirstChild("MeshPart") then
                                Head.Mesh.MeshId = "rbxassetid://8635368421"
                            end

                            continue
                        end

                        if Config.MiscSettings.Hitbox_Expander.Part == "Head" and Config.MiscSettings.Hitbox_Expander.Enabled then
                            for Index, Value in DefaultPlayerSettings[Player.Name].RootSettings do
                                HumanoidRootPart[Index] = Value
                            end
                        end

                        if Config.MiscSettings.Hitbox_Expander.Part == "HumanoidRootPart" and Config.MiscSettings.Hitbox_Expander.Enabled then
                            for Index, Value in DefaultPlayerSettings[Player.Name].HeadSettings do
                                Head[Index] = Value
                            end

                            if Head:FindFirstChild("MeshPart") then
                                Head.Mesh.MeshId = "rbxassetid://8635368421"
                            end
                        end

                        if Config.MiscSettings.Hitbox_Expander.Part == "Head" then
                            if Config.MiscSettings.Hitbox_Expander.Enabled and Humanoid.Health ~= 0 then
                                Head.Size = Vector3.new(Config.MiscSettings.Hitbox_Expander.Multiplier, Config.MiscSettings.Hitbox_Expander.Multiplier, Config.MiscSettings.Hitbox_Expander.Multiplier)
                                Head.Transparency = Config.MiscSettings.Hitbox_Expander.Transparency
                                Head.Material = Enum.Material[Config.MiscSettings.Hitbox_Expander.Material]
                                Head.Color = Config.MiscSettings.Hitbox_Expander.Color
                                Head.CanCollide = not DefaultPlayerSettings[Player.Name].HeadSettings.CanCollide
                                Head.Massless = not DefaultPlayerSettings[Player.Name].HeadSettings.Massless

                                if Head:FindFirstChild("MeshPart") then
                                    Head.Mesh.MeshId = ""
                                end
                            end
                        else
                            if Config.MiscSettings.Hitbox_Expander.Enabled and Humanoid.Health ~= 0 then
                                HumanoidRootPart.Size = Vector3.new(Config.MiscSettings.Hitbox_Expander.Multiplier, Config.MiscSettings.Hitbox_Expander.Multiplier, Config.MiscSettings.Hitbox_Expander.Multiplier)
                                HumanoidRootPart.Transparency = Config.MiscSettings.Hitbox_Expander.Transparency
                                HumanoidRootPart.Material = Enum.Material[Config.MiscSettings.Hitbox_Expander.Material]
                                HumanoidRootPart.Shape = Enum.PartType[Config.MiscSettings.Hitbox_Expander.Type]
                                HumanoidRootPart.Color = Config.MiscSettings.Hitbox_Expander.Color
                                HumanoidRootPart.CanCollide = not DefaultPlayerSettings[Player.Name].RootSettings.CanCollide
                            end
                        end
                    end
                end
            end))
        end

        for Index, Value in Players:GetPlayers() do
            if Value == LocalPlayer then continue end

            ConnectHitboxToPlayer(Value)
        end

        Players.PlayerAdded:Connect(function(Value)
            ConnectHitboxToPlayer(Value)
        end)

getgenv().Fonts = {}; do
    local function RegisterFont(Name, Weight, Style, Asset)
        if isfile(library.directory.."/assets/"..Asset.Id) then
            delfile(library.directory.."/assets/"..Asset.Id)
        end

        writefile(library.directory.."/assets/"..Asset.Id, Asset.Font)

        local Data = {
            name = Name,
            faces = {
                {
                    Name = "Normal",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(library.directory.."/assets/"..Asset.Id),
                },
            },
        }

        writefile(library.directory.."/fonts/"..Name .. ".font", Services.HttpService:JSONEncode(Data))

        return getcustomasset(library.directory.."/fonts/"..Name .. ".font");
    end
    
    local Tahoma = RegisterFont("Tahoma", 400, "Normal", {
        Id = "Tahoma.ttf",
        Font = game:HttpGet("https://github.com/KingVonOBlockJoyce/OctoHook-UI/raw/refs/heads/main/fs-tahoma-8px%20(3).ttf"),
    })

    local Pixel = RegisterFont("Pixel", 400, "Normal", {
        Id = "Pixel.ttf",
        Font = game:HttpGet("https://github.com/KingVonOBlockJoyce/vaderpaste.luau/raw/refs/heads/main/Pixel.ttf"),
    })

    local Minecraftia = RegisterFont("Minecraftia", 400, "Normal", {
        Id = "Minecraftia.ttf",
        Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Minecraftia-Regular.ttf"),
    }) 

    local Verdana = RegisterFont("Verdana", 400, "Normal", {
        Id = "Verdana.ttf",
        Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Verdana-Font.ttf"),
    })

    getgenv().Fonts["Plex"] = Font.new(Tahoma, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    getgenv().Fonts["Pixel"] = Font.new(Pixel, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    getgenv().Fonts["Minecraftia"] = Font.new(Minecraftia, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    getgenv().Fonts["Verdana"] = Font.new(Verdana, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
end
end)
end

local Fonts = getgenv().Fonts
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/BypassCash1/kat-ui-library/refs/heads/main/UI.lua"))() -- uii

getgenv().Toggles = getgenv().Toggles or {}
getgenv().Options = getgenv().Options or {}

-- \\ Script

local window = Library:Window({Prefix = "Razer.", Suffix = "xyz", accent = Color3.fromRGB(0, 255, 0)})

-- Helper functions
local function teleport(targetPos)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
    end
end

local function equip(itemName)
    local player = game.Players.LocalPlayer
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        local item = player.Backpack:FindFirstChild(itemName)
        if item then
            humanoid:EquipTool(item)
        end
    end
end

local function sell()
    local player = game.Players.LocalPlayer
    local camera = game.Workspace.CurrentCamera
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local cameraPosition = hrp.Position + Vector3.new(0, 100, -12)
        local lookAtPosition = hrp.Position + Vector3.new(0, -100, 0)
        camera.CFrame = CFrame.new(cameraPosition, lookAtPosition)
    end
    
    task.wait(0.2)
    
    local VirtualInputManager = game:GetService("VirtualInputManager")
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
    task.wait(2)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
end

local function log()
    local VIM = game:GetService("VirtualInputManager")
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(0.1)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

local TeleportLocations = {
    ["Bank"] = Vector3.new(-469, 317, -423),
    ["Mail Job"] = Vector3.new(-35, 317, -384),
    ["Ice Blox"] = Vector3.new(-1281, 317, 519),
    ["Barber Shop"] = Vector3.new(-157, 321, 749),
    ["Gun Shop"] = Vector3.new(92996, 122101, 17237),
    ["Laundromat"] = Vector3.new(-1, 317, 934),
    ["Black Market"] = Vector3.new(316, 317, 1093),
    ["Gas Station"] = Vector3.new(288, 317, 299),
    ["Car Dealership"] = Vector3.new(646, 317, 347),
    ["Clothing"] = Vector3.new(887, 318, -311),
    ["Devices"] = Vector3.new(693, 317, -76),
    ["Auto Shop"] = Vector3.new(1035, 317, 819),
    ["Beauty Studio"] = Vector3.new(802, 317, 958),
    ["Garbage Job"] = Vector3.new(288, 317, 797),
    ["Lumber Job"] = Vector3.new(742, 317, 847)
}

do -- \\ Main Page
    local MainPage = window:Tab({Name = "Main"})
    local MiscPage = window:Tab({name = "Miscellaneous", icon = GetImage("Wrench.png")})
    do -- \\ Local Player Sections
        local LocalPlayerSection = MainPage:Section({name = "Local Player", side = "left"})
        
        LocalPlayerSection:Toggle({
            type = "toggle",
            name = "Infinite Stamina",
            flag = "InfiniteStamina",
            default = false,
            Callback = function(state)
                if state then
                    getgenv().infiniteStaminaLoop = true
                    task.spawn(function()
                        while getgenv().infiniteStaminaLoop do
                            local args = { false }
                            local plr = game:GetService("Players").LocalPlayer
                            local events = plr:FindFirstChild("Events")
                            if events then
                                local energy = events:FindFirstChild("Energy")
                                if energy then
                                    energy:FireServer(unpack(args))
                                end
                            end
                            task.wait(0.2)
                        end
                    end)
                else
                    getgenv().infiniteStaminaLoop = false
                    local args = { false }
                    local plr = game:GetService("Players").LocalPlayer
                    local events = plr:FindFirstChild("Events")
                    if events then
                        local energy = events:FindFirstChild("Energy")
                        if energy then
                            energy:FireServer(unpack(args))
                        end
                    end
                end
            end
        })
        LocalPlayerSection:Toggle({
            type = "toggle",
            name = "Instant Interaction",
            flag = "InstantInteraction",
            default = false,
            Callback = function(state)
                local Workspace = game:GetService("Workspace")
                
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v.ClassName == "ProximityPrompt" then
                        v.HoldDuration = state and 0 or 0.5
                    end
                end

                if state then
                    getgenv().InstantInteractionConnection = Workspace.DescendantAdded:Connect(function(descendant)
                        if descendant.ClassName == "ProximityPrompt" then
                            descendant.HoldDuration = 0
                        end
                    end)
                else
                    if getgenv().InstantInteractionConnection then
                        getgenv().InstantInteractionConnection:Disconnect()
                        getgenv().InstantInteractionConnection = nil
                    end
                end
            end
        })
        LocalPlayerSection:Toggle({
            type = "toggle",
            name = "Infinite Jump",
            flag = "InfiniteJump",
            default = false,
            Callback = function(state)
                getgenv().InfJumpEnabled = state
            end
        })
        LocalPlayerSection:Toggle({
            type = "toggle",
            name = "No Combat",
            flag = "AntiCombat",
            default = false,
            Callback = function(state)
                local plr = game:GetService("Players").LocalPlayer
                local settings = plr:FindFirstChild("Settings")
                if settings then
                    local settingsObj = settings:FindFirstChild("Settings")
                    if settingsObj then
                        if state then
                            getgenv().antiCombatLoop = true
                            task.spawn(function()
                                while getgenv().antiCombatLoop do
                                    if settingsObj:GetAttribute("Combat") == true then
                                        settingsObj:SetAttribute("Combat", false)
                                    end
                                    task.wait(0.01)
                                end
                            end)
                        else
                            getgenv().antiCombatLoop = false
                        end
                    end
                end
            end
        })

        LocalPlayerSection:Toggle({
            type = "toggle",
            name = "No Knockout",
            flag = "AntiKnockout",
            default = false,
            Callback = function(state)
                local plr = game:GetService("Players").LocalPlayer
                local settings = plr:FindFirstChild("Settings")
                if settings then
                    local settingsObj = settings:FindFirstChild("Settings")
                    if settingsObj then
                        if state then
                            getgenv().antiKnockoutLoop = true
                            task.spawn(function()
                                while getgenv().antiKnockoutLoop do
                                    if settingsObj:GetAttribute("KnockedOut") == true then
                                        settingsObj:SetAttribute("KnockedOut", false)
                                    end
                                    task.wait(0.2)
                                end
                            end)
                        else
                            getgenv().antiKnockoutLoop = false
                        end
                    end
                end
            end
        })
        LocalPlayerSection:Toggle({
            type = "toggle",
            name = "No Climb",
            flag = "AntiClimb",
            default = false,
            Callback = function(state)
                local jumpsFolder = workspace:WaitForChild("GateJumps"):WaitForChild("Jumps")
                getgenv().DisabledTouchInterests = getgenv().DisabledTouchInterests or {}

                if state then
                    for _, jump in ipairs(jumpsFolder:GetDescendants()) do
                        if jump:IsA("BasePart") then
                            for _, child in ipairs(jump:GetChildren()) do
                                if child:IsA("TouchTransmitter") or child.Name == "TouchInterest" then
                                    local clone = child:Clone()
                                    child:Destroy()
                                    table.insert(getgenv().DisabledTouchInterests, {part = jump, obj = clone})
                                end
                            end
                        end
                    end
                    getgenv().ClimbBlockConnection = jumpsFolder.DescendantAdded:Connect(function(desc)
                        if desc:IsA("TouchTransmitter") or desc.Name == "TouchInterest" then
                            local parent = desc.Parent
                            local clone = desc:Clone()
                            desc:Destroy()
                            table.insert(getgenv().DisabledTouchInterests, {part = parent, obj = clone})
                        end
                    end)
                else
                    for _, data in ipairs(getgenv().DisabledTouchInterests) do
                        if data.part and data.obj and data.part:IsDescendantOf(workspace) then
                            data.obj.Parent = data.part
                        end
                    end
                    getgenv().DisabledTouchInterests = {}

                    if getgenv().ClimbBlockConnection then
                        getgenv().ClimbBlockConnection:Disconnect()
                        getgenv().ClimbBlockConnection = nil
                    end
                end
            end
        })
        LocalPlayerSection:Toggle({
            type = "toggle",
            name = "No On Camera",
            flag = "AntiOnCamera",
            default = false,
            Callback = function(state)
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage:FindFirstChild("cameraZoneFunction")

                if state then
                    if remote and remote:IsA("RemoteEvent") then
                        remote:FireServer(false, "\xE2\x80\x8E Pr\xE2\x80\x8E 1V\xE2\x80\x8E 4t3\xE2\x80\x8E ")
                        getgenv().OriginalCameraZoneRemote = remote
                        remote.Parent = nil
                    end
                else
                    if getgenv().OriginalCameraZoneRemote and getgenv().OriginalCameraZoneRemote:IsA("RemoteEvent") then
                        getgenv().OriginalCameraZoneRemote.Parent = ReplicatedStorage
                        getgenv().OriginalCameraZoneRemote = nil
                    end
                end
            end
        })
        UserInputService.JumpRequest:Connect(function()
            if getgenv().InfJumpEnabled and not getgenv().infJumpBounce then
                getgenv().infJumpBounce = true
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                task.wait()
                getgenv().infJumpBounce = false
            end
        end)

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.KeyCode == Enum.KeyCode.Space then
                getgenv().holdingSpace = true
                while getgenv().holdingSpace do
                    if getgenv().InfJumpEnabled and not getgenv().infJumpBounce then
                        getgenv().infJumpBounce = true
                        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                        task.wait()
                        getgenv().infJumpBounce = false
                    end
                    task.wait()
                end
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space then
                getgenv().holdingSpace = false
            end
        end)
    end

    do -- \\ Player Adjustments Section
        local PlayerAdjustmentsSection = MainPage:Section({Name = "Player Adjustments", Side = "left"})

        local speedvalue = 1
        PlayerAdjustmentsSection:Slider({
            Name = "Change Walkspeed",
            Flag = "SpeedValue",
            Min = 1,
            Max = 10,
            Value = 1,
            Callback = function(value)
                speedvalue = value
                getgenv().speedvalue = value
            end
        })

        local SpeedEnabled = false
        local SpeedConnection

        local function getCharacter()
            return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        end

        local function DisconnectSpeed()
            if SpeedConnection then
                SpeedConnection:Disconnect()
                SpeedConnection = nil
            end
        end

        local function SpeedControl()
            DisconnectSpeed()
            SpeedConnection = RunService.RenderStepped:Connect(function()
                if not SpeedEnabled then
                    DisconnectSpeed()
                    return
                end
                local character = getCharacter()
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                local currentSpeed = speedvalue or getgenv().speedvalue or 1
                if humanoid and hrp then
                    local MoveDirection = humanoid.MoveDirection
                    if MoveDirection.Magnitude > 0 then
                        hrp.CFrame = hrp.CFrame + MoveDirection * (currentSpeed * 1)
                    end
                end
            end)
        end

        local flying = false
        local speed = 100
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}

        local animationId = "rbxassetid://99870380291426"
        local animationTrack = nil
        local animationThread = nil

        PlayerAdjustmentsSection:Slider({
            Name = "Change Fly speed",
            Flag = "FlySpeedSlider",
            Min = 10,
            Max = 100,
            Value = 75,
            Callback = function(value)
                speed = value
            end
        })

        local function startAnimation()
            local char = LocalPlayer.Character
            if not char then return end

            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end

            if animationTrack then
                animationTrack:Stop()
            end

            local anim = Instance.new("Animation")
            anim.AnimationId = animationId

            animationTrack = hum:LoadAnimation(anim)
            animationTrack.Looped = true
            animationTrack:Play()
        end

        local function Fly()
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local torso = Character:WaitForChild("HumanoidRootPart")
            local humanoid = Character:WaitForChild("Humanoid")

            local bg = Instance.new("BodyGyro", torso)
            bg.P = 9e4
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.CFrame = torso.CFrame

            local bv = Instance.new("BodyVelocity", torso)
            bv.Velocity = Vector3.new(0, 0.1, 0)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

            humanoid.PlatformStand = true
            flying = true

            animationThread = task.spawn(function()
                while flying do
                    startAnimation()
                    task.wait(3)
                end
            end)

            while flying do
                task.wait()
                local camCF = workspace.CurrentCamera.CFrame
                if (ctrl.l + ctrl.r ~= 0) or (ctrl.f + ctrl.b ~= 0) then
                    bv.Velocity = (
                        (camCF.LookVector * (ctrl.f + ctrl.b)) +
                        ((camCF * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).Position - camCF.Position))
                    ).Unit * speed
                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0)
                end
                bg.CFrame = camCF
            end

            ctrl = {f = 0, b = 0, l = 0, r = 0}
            lastctrl = {f = 0, b = 0, l = 0, r = 0}
            humanoid.PlatformStand = false

            if animationTrack then
                animationTrack:Stop()
                animationTrack = nil
            end

            if animationThread then
                task.cancel(animationThread)
                animationThread = nil
            end

            bv:Destroy()
            bg:Destroy()
        end

        PlayerAdjustmentsSection:Toggle({
            Name = "Enable Fly",
            Flag = "FlyToggle",
            Value = false,
            Callback = function(state)
                if state then
                    flying = true
                    task.spawn(Fly)
                else
                    flying = false
                end
            end
        })

        UserInputService.InputBegan:Connect(function(input, processed)
            if processed or not flying then return end
            local key = input.KeyCode
            if key == Enum.KeyCode.W then ctrl.f = 1 end
            if key == Enum.KeyCode.S then ctrl.b = -1 end
            if key == Enum.KeyCode.A then ctrl.l = -1 end
            if key == Enum.KeyCode.D then ctrl.r = 1 end
        end)

        UserInputService.InputEnded:Connect(function(input)
            local key = input.KeyCode
            if key == Enum.KeyCode.W then ctrl.f = 0 end
            if key == Enum.KeyCode.S then ctrl.b = 0 end
            if key == Enum.KeyCode.A then ctrl.l = 0 end
            if key == Enum.KeyCode.D then ctrl.r = 0 end
        end)

        PlayerAdjustmentsSection:Toggle({
            Name = "Walkspeed",
            Flag = "Speedhack",
            Value = false,
            Callback = function(enabled)
                SpeedEnabled = enabled
                if enabled then
                    SpeedControl()
                else
                    DisconnectSpeed()
                end
            end
        })

        local player = LocalPlayer
        local Config = {
            ClickTeleportEnabled = false,
            ClickTeleportKeybind = Enum.KeyCode.E,
            ClickTeleportDistance = 50
        }

        local function setupClickTeleport()
            local mouse = player:GetMouse()
            local mouseConnection
            local keybindConnection

            local function teleportToMousePosition()
                if not Config.ClickTeleportEnabled then return end

                local target = mouse.Target
                if target then
                    local hitPosition = mouse.Hit.Position
                    local character = player.Character
                    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                    if humanoidRootPart then
                        local distance = (humanoidRootPart.Position - hitPosition).Magnitude
                        if distance <= Config.ClickTeleportDistance then
                            humanoidRootPart.CFrame = CFrame.new(hitPosition.X, hitPosition.Y + 3, hitPosition.Z)
                        end
                    end
                end
            end

            local function onMouseClick()
                teleportToMousePosition()
            end

            local function onKeybindPress(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode == Config.ClickTeleportKeybind then
                        teleportToMousePosition()
                    end
                end
            end

            return {
                Enable = function()
                    if mouseConnection then
                        mouseConnection:Disconnect()
                    end
                    if keybindConnection then
                        keybindConnection:Disconnect()
                    end

                    if Config.ClickTeleportKeybind == Enum.KeyCode.E then
                        keybindConnection = UserInputService.InputBegan:Connect(onKeybindPress)
                    elseif Config.ClickTeleportKeybind == Enum.UserInputType.MouseButton1 then
                        mouseConnection = mouse.Button1Down:Connect(onMouseClick)
                    else
                        keybindConnection = UserInputService.InputBegan:Connect(onKeybindPress)
                    end
                end,
                Disable = function()
                    if mouseConnection then
                        mouseConnection:Disconnect()
                        mouseConnection = nil
                    end
                    if keybindConnection then
                        keybindConnection:Disconnect()
                        keybindConnection = nil
                    end
                end,
                UpdateKeybind = function(newKeybind)
                    Config.ClickTeleportKeybind = newKeybind
                    if Config.ClickTeleportEnabled then
                        clickTeleportSystem.Disable()
                        clickTeleportSystem.Enable()
                    end
                end
            }
        end

        local clickTeleportSystem = setupClickTeleport()

        local clickTeleportToggle = PlayerAdjustmentsSection:Toggle({
            Name = "Click to Teleport",
            Flag = "Click_Teleport",
            Side = "Left",
            Value = false,
            Callback = function(Value)
                Config.ClickTeleportEnabled = Value
                if Value then
                    clickTeleportSystem.Enable()
                else
                    clickTeleportSystem.Disable()
                end
            end
        })

        clickTeleportToggle:Keybind({
            name = "Keybind",
            flag = "Click_Teleport_Bind",
            mode = "Always",
            default = Enum.KeyCode.E,
            Callback = function(state)
                if state then
                    if Config.ClickTeleportEnabled then
                        local mouse = player:GetMouse()
                        local hitPosition = mouse.Hit.Position
                        local character = player.Character
                        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart then
                            local distance = (humanoidRootPart.Position - hitPosition).Magnitude
                            if distance <= Config.ClickTeleportDistance then
                                humanoidRootPart.CFrame = CFrame.new(hitPosition.X, hitPosition.Y + 3, hitPosition.Z)
                            end
                        end
                    end
                end
            end,
            KeybindCallback = function(key)
                Config.ClickTeleportKeybind = key
                clickTeleportSystem.UpdateKeybind(key)
            end
        })

        PlayerAdjustmentsSection:Slider({
            name = "Teleport Distance",
            flag = "Click_Teleport_Distance",
            min = 10,
            max = 500,
            default = 50,
            Callback = function(value)
                Config.ClickTeleportDistance = value
            end
        })

        local respawnAtDeathEnabled = false
        local deathLocation = nil
        local deathConnection = nil

        PlayerAdjustmentsSection:Toggle({
            name = "Respawn At Death Location",
            flag = "RespawnAtDeath",
            default = false,
            Callback = function(state)
                respawnAtDeathEnabled = state
            
                if state then
                    local function setupDeathMonitoring(character)
                        if deathConnection then
                            deathConnection:Disconnect()
                        end
                    
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            deathConnection = humanoid.Died:Connect(function()
                                local rootPart = character:FindFirstChild("HumanoidRootPart")
                                if rootPart then
                                    deathLocation = rootPart.Position
                                end
                            
                                task.wait(3)
                            
                                if respawnAtDeathEnabled and deathLocation then
                                    local newCharacter = LocalPlayer.Character
                                    if newCharacter then
                                        local newRoot = newCharacter:FindFirstChild("HumanoidRootPart")
                                        if newRoot then
                                            newRoot.CFrame = CFrame.new(deathLocation)
                                        end
                                    end
                                end
                            end)
                        end
                    end
                
                    local currentChar = LocalPlayer.Character
                    if currentChar then
                        setupDeathMonitoring(currentChar)
                    end
                
                    LocalPlayer.CharacterAdded:Connect(function(character)
                        if respawnAtDeathEnabled then
                            task.wait(0.5)
                            setupDeathMonitoring(character)
                        end
                    end)
                else
                    if deathConnection then
                        deathConnection:Disconnect()
                        deathConnection = nil
                    end
                    deathLocation = nil
                end
            end
        })

        PlayerAdjustmentsSection:Toggle({
            Name = "No Clip",
            Flag = "NoclipToggle",
            Value = false,
            Callback = function(Value)
                getgenv().NoclipEnabled = Value
            
                local function applyNoclip(character)
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = not Value
                        end
                    end
                end
            
                local function noclipLoop()
                    while getgenv().NoclipEnabled and LocalPlayer.Character do
                        if LocalPlayer.Character then
                            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                        task.wait()
                    end
                end
            
                if Value then
                    local character = LocalPlayer.Character
                    if character then
                        applyNoclip(character)
                    end
                    
                    LocalPlayer.CharacterAdded:Connect(function(char)
                        if getgenv().NoclipEnabled then
                            applyNoclip(char)
                        end
                    end)
                    
                    task.spawn(noclipLoop)
                else
                    local character = LocalPlayer.Character
                    if character then
                        for _, part in pairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = true
                            end
                        end
                    end
                end
            end
        })
    end

    do -- \\ Target Section
        local TargetSection = MiscPage:Section({Name = "Target", Side = "left"})

        local SelectedPlayer
        local SpectateConnection
        local playerDropdown

        local function updatePlayerList()
            local players = {"None"}
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    table.insert(players, player.Name)
                end
            end
            return players
        end

        local function findPlayer(playerName)
            if not playerName or playerName == "None" then
                SelectedPlayer = nil
                return false
            end

            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Name == playerName then
                    SelectedPlayer = player
                    return true
                end
            end
            SelectedPlayer = nil
            return false
        end

        local function refreshPlayerDropdown()
            if not (playerDropdown and playerDropdown.RefreshOptions) then
                return
            end

            local options = updatePlayerList()
            pcall(function()
                playerDropdown.RefreshOptions(options)
            end)

            local desired = (SelectedPlayer and SelectedPlayer.Name) or "None"
            if not table.find(options, desired) then
                desired = "None"
                SelectedPlayer = nil
            end

            if playerDropdown.Set then
                pcall(function()
                    playerDropdown.Set(desired)
                end)
            end
        end

        pcall(function()
            playerDropdown = TargetSection:Dropdown({
                Name = "Select Player",
                Flag = "PlayerDropdown",
                Options = updatePlayerList(),
                Default = "None",
                Callback = function(selectedPlayer)
                    findPlayer(selectedPlayer) 
                end
            })
        end)

        pcall(function()
            if playerDropdown and playerDropdown.SetVisible then
                playerDropdown.Open = false
                playerDropdown.SetVisible(false)
            end
        end)

        game.Players.PlayerAdded:Connect(function()
            refreshPlayerDropdown()
        end)

        game.Players.PlayerRemoving:Connect(function()
            refreshPlayerDropdown()
        end)

        local function spectatePlayer(enable)
            if enable then
                if not SelectedPlayer then
                    return false
                end
                
                if SpectateConnection then 
                    SpectateConnection:Disconnect() 
                    SpectateConnection = nil
                end
                
                workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
                
                SpectateConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    local targetPos = Vector3.new(0, 10, 0) 
                    
                    if SelectedPlayer and SelectedPlayer.Character then
                        local hrp = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local torso = SelectedPlayer.Character:FindFirstChild("Torso") or SelectedPlayer.Character:FindFirstChild("UpperTorso")
                        local head = SelectedPlayer.Character:FindFirstChild("Head")
                        
                        if hrp then
                            targetPos = hrp.Position
                            workspace.CurrentCamera.CFrame = CFrame.new(hrp.Position + hrp.CFrame.LookVector * -10 + Vector3.new(0, 3, 0), hrp.Position)
                        elseif torso then
                            targetPos = torso.Position
                            workspace.CurrentCamera.CFrame = CFrame.new(torso.Position + Vector3.new(-10, 3, 0), torso.Position)
                        elseif head then
                            targetPos = head.Position
                            workspace.CurrentCamera.CFrame = CFrame.new(head.Position + Vector3.new(-10, 3, 0), head.Position)
                        else
                            workspace.CurrentCamera.CFrame = CFrame.new(targetPos + Vector3.new(-10, 3, 0), targetPos)
                        end
                    else
                        return
                    end
                end)
                
                return true
            else
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
                if SpectateConnection then 
                    SpectateConnection:Disconnect() 
                    SpectateConnection = nil
                end
                return true
            end
        end

        TargetSection:Toggle({
            Name = "Spectate Player",
            Flag = "SpectateToggle",
            Value = false,
            Callback = function(Value)
                spectatePlayer(Value)
            end
        })
        TargetSection:Button({
            Name = "Teleport To Player",
            Callback = function()
                if not SelectedPlayer then
                    return
                end
                
                local localChar = game.Players.LocalPlayer.Character
                if not localChar then
                    return
                end
                
                local localHRP = localChar:FindFirstChild("HumanoidRootPart")
                if not localHRP then
                    return
                end
                
                local targetPos
                
                if SelectedPlayer.Character then
                    local targetHRP = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        targetPos = targetHRP.Position
                    else
                        local torso = SelectedPlayer.Character:FindFirstChild("Torso") or SelectedPlayer.Character:FindFirstChild("UpperTorso")
                        local head = SelectedPlayer.Character:FindFirstChild("Head")
                        if torso then
                            targetPos = torso.Position
                        elseif head then
                            targetPos = head.Position
                        end
                    end
                end
                
                if not targetPos then
                    targetPos = Vector3.new(0, 10, 0)
                end
                
                localHRP.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
            end
        })
    end

    do -- \\ Money Section
        local MoneySection = MainPage:Section({Name = "Money", Side = "right"})

        MoneySection:Toggle({
            Name = "Auto Farm Garbage",
            Flag = "AutoGarbageFarm",
            Value = false,
            Callback = function(state)
                if state then
                    task.spawn(function()
                        while Toggles.AutoGarbageFarm.Value do
                            teleport(Vector3.new(284, 317, 794))
                            task.wait(0.5)
                            
                            if workspace.Interactions.toolInteractions:FindFirstChild("TrashPart") then
                                workspace.Interactions.toolInteractions.TrashPart.Interaction:FireServer()
                            end
                            task.wait(0.5)
                            
                            teleport(Vector3.new(294, 317, 660))
                            task.wait(0.5)
                            
                            equip("Trash Bag")
                            task.wait(2.5)
                            
                            sell()
                            task.wait(8)
                        end
                    end)
                end
            end
        })

        MoneySection:Toggle({
            Name = "Auto Farm Lumber",
            Flag = "AutoLumberFarm",
            Value = false,
            Callback = function(state)
                if state then
                    task.spawn(function()
                        teleport(Vector3.new(745, 317, 847)) 
                        task.wait(1)
                        sell()
                        task.wait(1)
                        
                        while Toggles.AutoLumberFarm.Value do
                            teleport(Vector3.new(667, 318, 845)) 
                            task.wait(1)
                            sell()
                            task.wait(1)
                            
                            teleport(Vector3.new(663, 318, 820)) 
                            equip("Full Log")
                            sell()
                            task.wait(1)
                            
                            teleport(Vector3.new(663, 318, 820)) 
                            task.wait(1)
                            
                            equip("Lumber Jack Axe")
                            log() 
                            task.wait(3)
                            
                            teleport(Vector3.new(718, 317, 820))
                            task.wait(1)
                            
                            equip("Half-Cut Log")
                            sell()
                            task.wait(1)
                            
                            equip("Lumber Jack Axe")
                            log()
                            task.wait(3)
                            
                            teleport(Vector3.new(718, 317, 820))
                            task.wait(4)
                            
                            equip("Half-Cut Log")
                            sell()
                            task.wait(1)
                            
                            equip("Lumber Jack Axe")
                            log()
                            task.wait(3)
                            
                            teleport(Vector3.new(755, 317, 841))
                            task.wait(1)
                            
                            for i = 1, 4 do
                                equip("Quarter-Cut Log")
                                sell()
                                task.wait(2)
                            end
                            
                            task.wait(1)
                        end
                    end)
                end
            end
        })

        MoneySection:Toggle({
            Name = "Auto Farm House",
            Flag = "AutoHouseRobbery",
            Value = false,
            Callback = function(state)
                if not state then return end

                task.spawn(function()
                    local House = workspace:WaitForChild("HouseRobbery")
                    local localPlayer = game.Players.LocalPlayer
                    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
                    
                    local WAIT_AFTER_TP = 0.25
                    local SPAM_INTERVAL = 0.06
                    local HOLD_DURATION = 0.05
                    local PROMPT_TIMEOUT = 100
                    
                    local function findPrompt(model)
                        local prompt = model:FindFirstChild("Interaction") or model:FindFirstChild("Prompt")
                        if not prompt then
                            for _, desc in pairs(model:GetDescendants()) do
                                if desc:IsA("ProximityPrompt") then
                                    prompt = desc
                                    break
                                end
                            end
                        end
                        return prompt
                    end
                    
                    local function spamPrompt(prompt)
                        local startTime = tick()
                        while Toggles.AutoHouseRobbery.Value and (tick() - startTime < PROMPT_TIMEOUT) do
                            pcall(function()
                                prompt:InputHoldBegin()
                                task.wait(HOLD_DURATION)
                                prompt:InputHoldEnd()
                            end)
                            task.wait(SPAM_INTERVAL)
                            if not prompt.Parent or not prompt.Enabled then
                                return true
                            end
                        end
                        return false
                    end
                    
                    local function breakDoor(doorName)
                        local brokenName = doorName .. "_Broken"
                        local startTime = tick()
                        
                        local doorModel = nil
                        for _, obj in pairs(House:GetDescendants()) do
                            if obj.Name:lower():find(doorName:lower()) then
                                doorModel = obj
                                break
                            end
                        end
                        
                        if not doorModel then return false end
                        
                        local prompt = findPrompt(doorModel)
                        if not prompt then return false end
                        
                        while Toggles.AutoHouseRobbery.Value and (tick() - startTime) < PROMPT_TIMEOUT do
                            pcall(function()
                                prompt:InputHoldBegin()
                                task.wait(HOLD_DURATION)
                                prompt:InputHoldEnd()
                            end)
                            task.wait(SPAM_INTERVAL)
                            
                            if House:FindFirstChild(brokenName) then
                                return true
                            end
                        end
                        return false
                    end
                    
                    local function waitForChildNamed(name, timeout)
                        timeout = timeout or 10
                        local start = tick()
                        while tick() - start < timeout do
                            local found = House:FindFirstChild(name)
                            if found then return true end
                            task.wait(0.1)
                        end
                        return false
                    end
                    
                    local function lootByKeyword(keyword)
                        local loot = {}
                        for _, obj in pairs(House:GetDescendants()) do
                            if obj:IsA("Model") or obj:IsA("Part") or obj:IsA("MeshPart") then
                                if obj.Name:lower():find(keyword:lower()) then
                                    local prompt = findPrompt(obj)
                                    if prompt then
                                        table.insert(loot, {
                                            model = obj,
                                            prompt = prompt,
                                            looted = false
                                        })
                                    end
                                end
                            end
                        end
                        return loot
                    end
                    
                    teleport(Vector3.new(222, 320, 1373))
                    task.wait(WAIT_AFTER_TP)
                    
                    breakDoor("KickDoor1")
                    if not waitForChildNamed("KickDoor1_Broken", 10) then return end
                    
                    local cash = lootByKeyword("cash")
                    if #cash == 0 then
                        cash = lootByKeyword("money")
                    end
                    
                    for _, item in pairs(cash) do
                        if not Toggles.AutoHouseRobbery.Value then break end
                        if not item.looted then
                            teleport(item.model.Position)
                            task.wait(0.15)
                            if spamPrompt(item.prompt) then
                                item.looted = true
                            end
                            task.wait(0.25)
                        end
                    end
                    
                    if House:FindFirstChild("KickDoor1_Broken") then
                        local door2Model = nil
                        for _, obj in pairs(House:GetDescendants()) do
                            if obj.Name:lower():find("kickdoor2") then
                                door2Model = obj
                                break
                            end
                        end
                        
                        if door2Model then
                            teleport(door2Model.Position)
                            task.wait(WAIT_AFTER_TP)
                            breakDoor("KickDoor2")
                        end
                    end
                    
                    if not waitForChildNamed("KickDoor2_Broken", 10) then return end
                    
                    local function lootItems(keyword)
                        local items = lootByKeyword(keyword)
                        for _, item in pairs(items) do
                            if not Toggles.AutoHouseRobbery.Value then break end
                            if not item.looted then
                                teleport(item.model.Position)
                                task.wait(0.15)
                                if spamPrompt(item.prompt) then
                                    item.looted = true
                                end
                                task.wait(0.25)
                            end
                        end
                    end
                    
                    lootItems("duffle")
                    lootItems("box")
                    lootItems("crate")
                    
                    teleport(Vector3.new(192.491028, 316.25, 942.423828))
                end)
            end
        })

        

        MoneySection:Label({wrapped = true, name = "Need 50+ Strength For House Farm."})

        MoneySection:Button({
            Name = "Rollback Dupe",
            Callback = function()
                local LocalPlayer = game:GetService("Players").LocalPlayer

                LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainGUI"):WaitForChild("clinicFrame"):WaitForChild("textboxEntry"):FireServer("How \237\190\140")

                replicatesignal(LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainGUI"):WaitForChild("clinicFrame").firstNameButton.MouseButton1Down, 1, 1)
            end
        })
        MoneySection:Button({
            Name = "Rejoin Server",
            Callback = function()
                game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
            end
        })

        MoneySection:Label({wrapped = true, name = "Need Custom Name Gamepass."})
        MoneySection:Label({wrapped = true, name = "Need $2,500."})
        MoneySection:Label({wrapped = true, name = "Click Rollback To Start."})
        MoneySection:Label({wrapped = true, name = "Spend/Drop Money Freely."})
        MoneySection:Label({wrapped = true, name = "Rejoin To Reset Everything."})

        MoneySection:Button({
            Name = "Counter Dupe",
            Callback = function()
                local Players = game:GetService('Players')
                local LocalPlayer = Players.LocalPlayer
                local PlayerName = LocalPlayer.Name

                local function findPlayerOwnedPrompts()
                    local prompts = {}

                    for _, machine in ipairs(workspace.MoneyCounterMachines:GetChildren()) do
                        if machine.Name:find(PlayerName) then
                            local base = machine:FindFirstChild('Base')
                            if base then
                                local interact = base:FindFirstChild('Interact')
                                if interact then
                                    local prompt = interact:FindFirstChild('Interaction')
                                    if prompt and prompt:IsA('ProximityPrompt') then
                                        prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
                                        table.insert(prompts, prompt)
                                    end
                                end
                            end
                        end
                    end

                    return prompts
                end

                local validPrompts = findPlayerOwnedPrompts()
                if #validPrompts < 2 then
                    return
                end

                local prompt1, prompt2 = validPrompts[1], validPrompts[2]

                for i = 1, 1 do
                    task.spawn(function()
                        prompt1:InputHoldBegin()
                        prompt2:InputHoldBegin()
                        prompt1:InputHoldEnd()
                        prompt2:InputHoldEnd()
                    end)
                end
            end
        }) 

        MoneySection:Label({wrapped = true, name = "Must Have 2 Money Counters Placed."})
        MoneySection:Label({wrapped = true, name = "Stand Infront Of Them."})
        MoneySection:Label({wrapped = true, name = "And Click The Button."})
        MoneySection:Label({wrapped = true, name = "This Only Doubles The Dirty."})
        MoneySection:Label({wrapped = true, name = "Money You Put In."})
    end

    do -- \\ Notifications Section
        local spams = MainPage:Section({name = "Notifications", side = "Right"})
        local spamNotificationEnabled = false
        local spamMessage = "Razer.xyz On Top Join Discord Here - https://discord.gg/getrazer"
        local spamCount = 1
        local spamDelay = 0.1
        local spamDuration = 999999

        spams:Textbox({
            Name = "Notification Message",
            Flag = "SpamMessageInput",
            Placeholder = "Enter message",
            Text = spamMessage,
            Callback = function(value)
                spamMessage = tostring(value)
            end
        })

        spams:Slider({
            Name = "Spam Count",
            Flag = "SpamCountSlider",
            Min = 1,
            Max = 60,
            Value = spamCount,
            Callback = function(value)
                spamCount = value
            end
        })

        spams:Slider({
            Name = "Spam Delay(s)",
            Flag = "SpamDelaySlider",
            Min = 0.01,
            Max = 5,
            Value = spamDelay,
            Callback = function(value)
                spamDelay = value
            end
        })

        spams:Slider({
            Name = "Message Duration(s)",
            Flag = "SpamDurationSlider",
            Min = 1,
            Max = 60,
            Value = 30,
            Callback = function(value)
                spamDuration = value
            end
        })

        spams:Toggle({
            Name = "Spam Notifications",
            Flag = "SpamNotificationToggle",
            Value = false,
            Callback = function(state)
                spamNotificationEnabled = state

                if state then
                    task.spawn(function()
                        local Event = game:GetService("ReplicatedStorage"):WaitForChild("notificationFunction")
                        for i = 1, spamCount do
                            if not spamNotificationEnabled then break end
                            pcall(function()
                                firesignal(Event.OnClientEvent, spamMessage or "Razer.xyz On Top Join Discord Here - https://discord.gg/getrazer", Color3.fromRGB(42, 208, 255), spamDuration)
                            end)
                            task.wait(spamDelay)
                        end
                        spamNotificationEnabled = false
                        pcall(function()
                            if Toggles and Toggles.SpamNotificationToggle and Toggles.SpamNotificationToggle.Set then
                                Toggles.SpamNotificationToggle:Set(false)
                            end
                        end)
                    end)
                end
            end
        })
    end

    do -- \\ Exploits Section
        local Exploits = MiscPage:Section({name = "Account Exploits", side = "left"})

        local Config = {
            FirstName = "",
            LastName = ""
        }

        Exploits:Textbox({
            Name = "First Name",
            Flag = "FirstNameInput",
            Placeholder = "Enter First Name",
            Text = "",
            Callback = function(text)
                Config.FirstName = text
            end
        })

        Exploits:Textbox({
            Name = "Last Name",
            Flag = "LastNameInput",
            Placeholder = "Enter Last Name",
            Text = "",
            Callback = function(text)
                Config.LastName = text
            end
        })

        Exploits:Button({
            Name = "Force Reset Player",
            Callback = function()
                local TeleportService = game:GetService("TeleportService")
                local PLACE_ID = 101606818845121
                TeleportService:Teleport(PLACE_ID, LocalPlayer)
            end
        })

        Exploits:Button({
            Name = "Set Names",
            Callback = function()
                for _, v in ipairs(getgc(true)) do
                    if typeof(v) == "function" and debug.getinfo(v).name == "changedAttribute" then
                        local UpValue = debug.getupvalues(v)[1]
                        if typeof(upValue) == "table" then
                            UpValue.stamina = 120
                            UpValue.strength = 120
                            UpValue.smarts = 120
                            UpValue.stress = 0
                            UpValue.FirstName = Config.FirstName ~= "" and Config.FirstName or "Aaron"
                            UpValue.LastName = Config.LastName ~= "" and Config.LastName or "Adams"
                            table.freeze(UpValue)
                            break
                        end
                    end
                end
            end
        })

        Exploits:Button({
            Name = "Perm Hide Name",
            Callback = function()
                local CreationRemote = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("CreationGUI"):WaitForChild("sendData")

                if not hookmetamethod then
                    return
                end

                local OldNamecall
                OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                    local method = getnamecallmethod()
                    local args = { ... }

                    if self == CreationRemote and method == "FireServer" then
                        if typeof(args[1]) == "table" then
                            local NewPayload = table.clone(args[1])

                            if NewPayload.AbilitiesData then
                                NewPayload.AbilitiesData.Smarts = 120
                                NewPayload.AbilitiesData.Strength = 120
                                NewPayload.AbilitiesData.Stamina = 120
                            end

                            if NewPayload.AppearanceData then
                                NewPayload.AppearanceData.FirstName = nil
                                NewPayload.AppearanceData.LastName = nil
                            end

                            return OldNamecall(self, NewPayload, select(2, ...))
                        end
                    end

                    return OldNamecall(self, ...)
                end))
            end
        })
    end

    do -- \\ Gun Adjustments Section
        local GunAdjustmentsSection = MiscPage:Section({Name = "Gun Adjustments", Side = "right"})

        local OriginalSettings = {}

        local function getAllGunSettings()
            local guns = {}

            local function scan(container)
                for _, item in ipairs(container:GetChildren()) do
                    if item:IsA("Tool") and item:FindFirstChild("Settings") and item.Settings:IsA("ModuleScript") then
                        table.insert(guns, item.Settings)
                    end
                end
            end

            scan(LocalPlayer.Backpack)
            if LocalPlayer.Character then
                scan(LocalPlayer.Character)
            end

            return guns
        end

        local function cacheOriginal(gunSettings, moduleId)
            if OriginalSettings[moduleId] then return end
            OriginalSettings[moduleId] = {
                jamChance = gunSettings.jamChance,
                spread = gunSettings.spread,
                semiCooldown = gunSettings.semiCooldown,
                autoCooldown = gunSettings.autoCooldown,
                fireMode = gunSettings.fireMode,
                projectiles = gunSettings.projectiles,
            }
        end

        local function applyMod(callback)
            for _, mod in ipairs(getAllGunSettings()) do
                local success, gunSettings = pcall(require, mod)
                if success and type(gunSettings) == "table" then
                    cacheOriginal(gunSettings, mod:GetDebugId())
                    callback(gunSettings)
                end
            end
        end

        GunAdjustmentsSection:Toggle({
            name = "No Jam",
            flag = "NoJam",
            default = false,
            Callback = function(state)
                if state then
                    applyMod(function(gun) gun.jamChance = 0 end)
                else
                    for _, mod in ipairs(getAllGunSettings()) do
                        local success, gunSettings = pcall(require, mod)
                        local backup = OriginalSettings[mod:GetDebugId()]
                        if success and type(gunSettings) == "table" and backup then
                            gunSettings.jamChance = backup.jamChance
                        end
                    end
                end
            end
        })

        GunAdjustmentsSection:Toggle({
            name = "No Spread",
            flag = "NoSpread", 
            default = false,
            Callback = function(state)
                if state then
                    applyMod(function(gun) gun.spread = 0 end)
                else
                    for _, mod in ipairs(getAllGunSettings()) do
                        local success, gunSettings = pcall(require, mod)
                        local backup = OriginalSettings[mod:GetDebugId()]
                        if success and type(gunSettings) == "table" and backup then
                            gunSettings.spread = backup.spread
                        end
                    end
                end
            end
        })

        GunAdjustmentsSection:Toggle({
            name = "Full Auto",
            flag = "FullAuto",
            default = false,
            Callback = function(state)
                if state then
                    applyMod(function(gun)
                        if gun.fireMode == "semi" then
                            gun.fireMode = "auto"
                            gun.autoCooldown = 0.05
                        end
                    end)
                else
                    for _, mod in ipairs(getAllGunSettings()) do
                        local success, gunSettings = pcall(require, mod)
                        local backup = OriginalSettings[mod:GetDebugId()]
                        if success and type(gunSettings) == "table" and backup then
                            gunSettings.fireMode = backup.fireMode
                            gunSettings.autoCooldown = backup.autoCooldown
                        end
                    end
                end
            end
        })
    end

    do -- \\ Purchase Item Section
        local PurchaseItemSection = MiscPage:Section({Name = "Purchase Item", Side = "right"})

        local SelectedToolPart
        local PurchaseAmount = 1
        local toolInteractionNames = {}
        local originalPosition 

        local toolInteractionsFolder = workspace.Interactions.toolInteractions
        
        for _, item in pairs(toolInteractionsFolder:GetChildren()) do
            if item.Name ~= "handler" then
                table.insert(toolInteractionNames, item.Name)
            end
        end
        table.sort(toolInteractionNames)

        PurchaseItemSection:Dropdown({
            name = "Select Item to Purchase",
            flag = "ToolItemDropdown",
            Options = toolInteractionNames,
            default = nil,
            Callback = function(Value)
                SelectedToolPart = Value
            end
        })

        PurchaseItemSection:Slider({
            name = "Purchase Amount",
            flag = "PurchaseAmount",
            min = 1,
            max = 10,
            default = 1,
            Callback = function(value)
                PurchaseAmount = value
            end
        })

        PurchaseItemSection:Button({
            name = "Purchase Selected Item",
            Callback = function()
                if SelectedToolPart then
                    local player = game.Players.LocalPlayer
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        if not originalPosition then
                            originalPosition = player.Character.HumanoidRootPart.Position
                        end
                    end
                    
                    for i = 1, PurchaseAmount do
                        teleport(Vector3.new(-446, 317, 790))
                        task.wait(0.5)
                        
                        local toolPart = workspace.Interactions.toolInteractions:FindFirstChild(SelectedToolPart)
                        
                        if toolPart then
                            teleport(toolPart.Position)
                            
                            task.wait(1)
                            
                            if toolPart:FindFirstChild("Interaction") then
                                toolPart.Interaction:FireServer()
                            end
                            
                            task.wait(1.5)
                            
                            if originalPosition then
                                teleport(originalPosition)
                            end
                        end
                        
                        if i < PurchaseAmount then
                            task.wait(0.5)
                        end
                    end
                end
            end
        })
    end

    do -- \\ Teleport Section
        local TeleportSection = MiscPage:Section({Name = "Teleport", Side = "right"})

        local SelectedLocation

        local locationNames = {}
        for locationName, _ in pairs(TeleportLocations) do
            table.insert(locationNames, locationName)
        end
        table.sort(locationNames)

        local LocationDropdown = TeleportSection:Dropdown({
            name = "Select Location",
            flag = "LocationDropdown",
            items = locationNames,
            default = nil,
            Callback = function(Value)
                SelectedLocation = Value
            end
        })

        TeleportSection:Button({
            name = "Teleport To Selected Location",
            Callback = function()
                if SelectedLocation and TeleportLocations[SelectedLocation] then
                    teleport(TeleportLocations[SelectedLocation])
                end
            end
        })
    end
end

local SilentAimTab = window:Tab({name = "Silent Aim", tabs = {"General Settings"}, icon = GetImage("Aimlock.png")})

if not Solara then
    local GeneralSection = SilentAimTab:Section({name = "General", side = "left" })

    GeneralSection:Toggle({type = "toggle", name = "Enabled", flag = "SilentAim_Enabled", default = false, callback = function(state)
        Config.Silent.Enabled = state
    end}):Keybind({name = "Keybind", flag = "SilentAim_Bind", mode = "Always", callback = function(state)
        Config.Silent.Targetting = state
    end})

    local SettingsSection = SilentAimTab:Section({name = "Settings", side = "left", size = 0.455, icon = GetImage("Settings.png")})

    SettingsSection:Toggle({name = "Visible Check", flag = "SilentAim_Wallcheck", type = "toggle", default = false, callback = function(state)
        Config.Silent.WallCheck = state
    end})

    local BodyParts = {}

    local RigType = "R15"

    if LocalPlayer.Character then
        RigType = LocalPlayer.Character:WaitForChild("Humanoid").RigType.Name
    else
        LocalPlayer.CharacterAdded:Wait()

        RigType = LocalPlayer.Character:WaitForChild("Humanoid").RigType.Name
    end

    BodyParts = (RigType == "R6") and {
        "Head",
        "Torso",
        "Left Arm",
        "Right Arm",
        "Left Leg",
        "Right Leg",
        "HumanoidRootPart"
    } or (RigType == "R15") and {
        "Head",
        "UpperTorso",
        "LowerTorso",
        "LeftUpperArm",
        "LeftLowerArm",
        "RightUpperArm",
        "RightLowerArm",
        "LeftUpperLeg",
        "LeftLowerLeg",
        "RightUpperLeg",
        "RightLowerLeg",
        "HumanoidRootPart"
    } or {}

    SettingsSection:Dropdown({name = "Target Parts", flag = "Silent_TargetPart", width = 110, items = BodyParts, seperator = false, multi = true, default = {'Head'}, callback = function(state)
        table.clear(Config.Silent.TargetPart)
        
        for Index, Value in state do
            table.insert(Config.Silent.TargetPart, Value)
        end
    end})

    SettingsSection:Slider({name = "Max Distance", flag = "MaxDistance_Silent", min = 0, max = 3000, default = 1000, suffix = "st", callback = function(state)
        Config.Silent.MaxDistance = state
    end})

    SettingsSection:Slider({name = "Hit Chance", flag = "SilentAim_HitChance", min = 0, max = 100, default = 100, suffix = "%", callback = function(state)
        Config.Silent.HitChance = state
    end})

    local FieldOfViewSection = SilentAimTab:Section({name = "Field Of View", side = "right", size = 0.23, icon = GetImage("FieldOfView2.png")})

    FieldOfViewSection:Toggle({type = "toggle", name = "Enabled", flag = "SilentAim_Usefov", default = false, callback = function(state)
        Config.Silent.UseFieldOfView = state
    end})

    FieldOfViewSection:Toggle({type = "toggle", name = "Draw Circle", flag = "SilentAim_DrawCircle", default = false, callback = function(state)
        Config.Silent.DrawFieldOfView = state
    end}):Colorpicker({flag = "SilentAim_FOVColor", default = Color3.new(1,1,1), alpha = 0.25, callback = function(state, alpha)
        Config.Silent.FieldOfViewColor = state
        Config.Silent.FieldOfViewTransparency = 1 - alpha
    end})

    local FieldOfViewSettingsSection = SilentAimTab:Section({name = "Field Of View Settings", side = "right", size = 0.3, icon = GetImage("Settings.png")})

    FieldOfViewSettingsSection:Slider({name = "Radius", flag = "SilentAim_Radius", min = 0, max = 1000, default = 100, suffix = "°", callback = function(state)
        Config.Silent.Radius = state
    end})

    FieldOfViewSettingsSection:Slider({name = "Sides", flag = "SilentAim_Sides", min = 3, max = 100, default = 25, suffix = "°", callback = function(state)
        Config.Silent.Sides = state
    end})

    local SnaplineSection = SilentAimTab:Section({name = "Snapline", side = "right", size = 0.275, icon = GetImage("Snapline.png")})

    SnaplineSection:Toggle({type = "toggle", name = "Enabled", flag = "SilentAim_Snapline", default = false, callback = function(state)
        Config.Silent.Snapline = state
    end}):Colorpicker({flag = "SilentAim_SnaplineColor", default = Color3.new(1,1,1), alpha = 1, callback = function(state, alpha)
        Config.Silent.SnaplineColor = state
    end})

    SnaplineSection:Slider({name = "Snapline Thickness", flag = "SilentAim_SnaplineThickness", min = 1, max = 5, default = 1, callback = function(state)
        Config.Silent.SnaplineThickness = state
    end})
end

local AimlockTab = window:Tab({name = "Aimlock", tabs = {"General Settings"}, icon = GetImage("Aimlock.png")})
local GeneralSection = AimlockTab:Section({name = "General", side = "left", size = 0.23, icon = GetImage("UZI.png")})

    GeneralSection:Toggle({type = "toggle", name = "Enabled", flag = "AimlockAim_Enabled", default = false, callback = function(state)
        Config.Aimlock.Enabled = state
    end}):Keybind({name = "Keybind", flag = "AimlockAim_Bind", mode = "Toggle", callback = function(state)
        Config.Aimlock.Aiming = state
        pcall(function() TargetTable[1] = nil end)
    end})

    local SettingsSection = AimlockTab:Section({name = "Settings", side = "left", size = 0.51, icon = GetImage("Settings.png")})

    SettingsSection:Toggle({name = "Visible Check", flag = "AimlockAim_Wallcheck", type = "toggle", default = false, callback = function(state)
        Config.Aimlock.WallCheck = state
    end})

    local BodyParts = {}

    local RigType = "R15"

    if LocalPlayer.Character then
        RigType = LocalPlayer.Character:WaitForChild("Humanoid").RigType.Name
    else
        LocalPlayer.CharacterAdded:Wait()

        RigType = LocalPlayer.Character:WaitForChild("Humanoid").RigType.Name
    end

    BodyParts = (RigType == "R6") and {
        "Head",
        "Torso",
        "Left Arm",
        "Right Arm",
        "Left Leg",
        "Right Leg",
        "HumanoidRootPart"
    } or (RigType == "R15") and {
        "Head",
        "UpperTorso",
        "LowerTorso",
        "LeftUpperArm",
        "LeftLowerArm",
        "RightUpperArm",
        "RightLowerArm",
        "LeftUpperLeg",
        "LeftLowerLeg",
        "RightUpperLeg",
        "RightLowerLeg",
        "HumanoidRootPart"
    } or {}

    SettingsSection:Dropdown({name = "Aimlock Type", flag = "Aimlock_AimType", width = 110, items = {'Camera', 'Mouse'}, seperator = false, multi = false, default = 'Mouse', callback = function(state)
        Config.Aimlock.Type = state
    end})

    SettingsSection:Dropdown({name = "Target Parts", flag = "Aimlock_TargetPart", width = 110, items = BodyParts, seperator = false, multi = false, default = 'Head', callback = function(state)
        Config.Aimlock.TargetPart = state
    end})

    SettingsSection:Slider({name = "Max Distance", flag = "MaxDistance_Aimlock", min = 0, max = 3000, default = 1000, suffix = "st", callback = function(state)
        Config.Aimlock.MaxDistance = state
    end})

    SettingsSection:Slider({name = "Smoothness", flag = "MaxDistance_Smoothness", min = 0, max = 100, default = 10, suffix = "%", callback = function(state)
        Config.Aimlock.Smoothness = state/10
    end})

    local FieldOfViewSection = AimlockTab:Section({name = "Field Of View", side = "right", size = 0.23, icon = GetImage("FieldOfView2.png")})

    FieldOfViewSection:Toggle({type = "toggle", name = "Enabled", flag = "AimlockAim_Usefov", default = false, callback = function(state)
        Config.Aimlock.UseFieldOfView = state
    end})

    FieldOfViewSection:Toggle({type = "toggle", name = "Draw Circle", flag = "AimlockAim_DrawCircle", default = false, callback = function(state)
        Config.Aimlock.DrawFieldOfView = state
    end}):Colorpicker({flag = "AimlockAim_FOVColor", default = Color3.new(1,1,1), alpha = 0.25, callback = function(state, alpha)
        Config.Aimlock.FieldOfViewColor = state
        Config.Aimlock.FieldOfViewTransparency = 1 - alpha
    end})

    local FieldOfViewSettingsSection = AimlockTab:Section({name = "Field Of View Settings", side = "right", size = 0.3, icon = GetImage("Settings.png")})

    FieldOfViewSettingsSection:Slider({name = "Radius", flag = "AimlockAim_Radius", min = 0, max = 1000, default = 100, suffix = "°", callback = function(state)
        Config.Aimlock.Radius = state
    end})

    FieldOfViewSettingsSection:Slider({name = "Sides", flag = "AimlockAim_Sides", min = 3, max = 100, default = 25, suffix = "°", callback = function(state)
        Config.Aimlock.Sides = state
    end})

    local SnaplineSection = AimlockTab:Section({name = "Snapline", side = "right", size = 0.275, icon = GetImage("Snapline.png")})

    SnaplineSection:Toggle({type = "toggle", name = "Enabled", flag = "AimlockAim_Snapline", default = false, callback = function(state)
        Config.Aimlock.Snapline = state
    end}):Colorpicker({flag = "AimlockAim_SnaplineColor", default = Color3.new(1,1,1), alpha = 1, callback = function(state, alpha)
        Config.Aimlock.SnaplineColor = state
    end})

    SnaplineSection:Slider({name = "Snapline Thickness", flag = "AimlockAim_SnaplineThickness", min = 1, max = 5, default = 1, callback = function(state)
        Config.Aimlock.SnaplineThickness = state
    end})
end -- Close the do block from line 1335
end -- Close the do block from line 1332

Library:Configs(window)
