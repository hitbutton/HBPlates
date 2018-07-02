HBPlates = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0",
  "AceDB-2.0",
  "AceDebug-2.0",
  "AceEvent-2.0",
  "AceModuleCore-2.0" ,
  "FuBarPlugin-2.0")
HBPlates:SetModuleMixins("AceDebug-2.0")
local Tablet = AceLibrary("Tablet-2.0")

HBPlates.hasIcon = "Interface\\AddOns\\HBPlates\\Textures\\normal"
HBPlates.hasNoText = true
HBPlates.cannotDetachTooltip = true

local showPets = false
local Ignore = {}
local PetsENG = {
  "Orange Tabby",
  "Silver Tabby",
  "Cornish Rex",
  "Hawk Owl",
  "Great Horned Owl",
  "Black Kingsnake",
  "Brown Snake",
  "Crimson Snake",
  "Prairie Dog",
  "Ancona Chicken",
  "Worg Pup",
  "Smolderweb Hatchling",
  "Mechanical Chicken",
  "Sprite Darter",
  "Green Wing Macaw",
  "Hyacinth Macaw",
  "Tiny Black Whelpling",
  "Tiny Emerald Whelpling",
  "Tiny Crimson Whelpling",
  "Unconscious Dig Rat",
  "Mechanical Squirrel",
  "Pet Bombling",
  "Lil' Smokey",
  "Lifelike Mechanical Toad",
  -- REMOVE SINGLE WORD NAMES
  -- to handle players naming themselves or their pets these names and being ignored
  --"Siamese",
  --"Cockroach",
  --"Bombay",
  --"Cockatiel",
  --"Senegal",
}
for _,
 petName in pairs(PetsENG) do
  Ignore[petName] = true
end
local ENTERING_WORLD_DELAY = 1

local plateCache = {}
local IconCache = {}
local Icons = {
  ["Druid"] = "Interface\\AddOns\\HBPlates\\Textures\\druid",
 
  ["Hunter"] = "Interface\\AddOns\\HBPlates\\Textures\\hunter",
 
  ["Mage"] = "Interface\\AddOns\\HBPlates\\Textures\\mage",
 
  ["Paladin"] = "Interface\\AddOns\\HBPlates\\Textures\\paladin",
 
  ["Priest"] = "Interface\\AddOns\\HBPlates\\Textures\\priest",
 
  ["Rogue"] = "Interface\\AddOns\\HBPlates\\Textures\\rogue",
 
  ["Shaman"] = "Interface\\AddOns\\HBPlates\\Textures\\shaman",
 
  ["Warlock"] = "Interface\\AddOns\\HBPlates\\Textures\\warlock",
 
  ["Warrior"] = "Interface\\AddOns\\HBPlates\\Textures\\warrior",
 
  ["normal"] = "Interface\\AddOns\\HBPlates\\Textures\\normal",
 
  ["elite"] = "Interface\\AddOns\\HBPlates\\Textures\\elite",
 
  ["rare"] = "Interface\\AddOns\\HBPlates\\Textures\\rare",
 
  ["rareelite"] = "Interface\\AddOns\\HBPlates\\Textures\\rareelite",
 
}

function HBPlates:OnInitialize()
  self:RegisterDB("HBCastBarDB")
  self:RegisterDefaults("profile",
  self:GetDefaultDB() )
  self:RegisterChatCommand( { "/hbplates" } ,
  self:BuildOptions() )
  self.OnMenuRequest = self:BuildOptions()
  self.frame:SetScript("OnUpdate",
 self.OnUpdate)
  self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function HBPlates:GetDefaultDB()
  return {
    barW = 80,
 
    barH = 8,
 
  }
end

function HBPlates:BuildOptions()
  local opt = {
    type = "group",
 
    desc = "HBPlates Options",
 
    args = {
    },
 
  }
  return opt
end

-- HOOK NAMEPLATE FUNCTIONS
local oldShowNameplates = ShowNameplates
local oldShowFriendNameplates = ShowFriendNameplates
local oldHideNameplates = HideNameplates
local oldHideFriendNameplates = HideFriendNameplates

function HBPlates:HookShowNameplates()
  oldShowNameplates()
  NAMEPLATES_ON = "1"
  HBPlates:Update()
end
ShowNameplates = HBPlates.HookShowNameplates

function HBPlates:HookShowFriendNameplates()
  oldShowFriendNameplates()
  FRIENDNAMEPLATES_ON = "1"
  HBPlates:Update()
end
ShowFriendNameplates = HBPlates.HookShowFriendNameplates

function HBPlates:HookHideNameplates()
  oldHideNameplates()  
  NAMEPLATES_ON = "0"
  HBPlates:Update()
end
HideNameplates = HBPlates.HookHideNameplates

function HBPlates:HookHideFriendNameplates()
  oldHideFriendNameplates()
  FRIENDNAMEPLATES_ON = "0"
  HBPlates:Update()
end
HideFriendNameplates = HBPlates.HookHideFriendNameplates

-- EVENTS

function HBPlates:PLAYER_ENTERING_WORLD()
  if self.db.profile.NAMEPLATES_ON == "1" then
    self:HookShowNameplates()
  else
    self:HookHideNameplates()
  end
  if self.db.profile.FRIENDNAMEPLATES_ON == "1" then
    self:HookShowFriendNameplates()
  else
    self:HookHideFriendNameplates()
  end
--[[
  if self.db.profile.NAMEPLATES_ON == "1" then
    self:ScheduleEvent(function() self:HookShowNameplates() end,
  ENTERING_WORLD_DELAY)
  else
    self:ScheduleEvent(function() self:HookHideNameplates() end,
  ENTERING_WORLD_DELAY)
  end
  if self.db.profile.FRIENDNAMEPLATES_ON == "1" then
    self:ScheduleEvent(function() self:HookShowFriendNameplates() end,
  ENTERING_WORLD_DELAY)
  else
    self:ScheduleEvent(function() self:HookHideFriendNameplates() end,
  ENTERING_WORLD_DELAY)
  end
]]
end

-- FUBAR FRAME FUNCS

function HBPlates:OnTextUpdate()
  if NAMEPLATES_ON == "1" then
    if FRIENDNAMEPLATES_ON == "1" then
      self.iconFrame:SetVertexColor(0,
 1,
 0)
    else
      self.iconFrame:SetVertexColor(1,
 0,
 0)
    end
  else
    self.iconFrame:SetVertexColor(0.6,
 0.6,
 0.6)
  end
end

function HBPlates:OnClick()
  if NAMEPLATES_ON == "1" then
    if FRIENDNAMEPLATES_ON == "1" then
      HideNameplates()
      HideFriendNameplates()
    else
      ShowFriendNameplates()
    end
  else
    ShowNameplates()
  end
  self.db.profile.NAMEPLATES_ON = NAMEPLATES_ON
  self.db.profile.FRIENDNAMEPLATES_ON = FRIENDNAMEPLATES_ON
end

function HBPlates:OnTooltipUpdate()
  local cat = Tablet:AddCategory()
  if NAMEPLATES_ON == "1" then
    if FRIENDNAMEPLATES_ON == "1" then
      cat:AddLine("text",
 "Showing Friend and Enemy Plates")
    else
      cat:AddLine("text",
 "Showing Enemy Plates")
    end
  else
    if FRIENDNAMEPLATES_ON == "1" then
      cat:AddLine("text",
 "Showing Friend Plates Only")
    else
      cat:AddLine("text",
 "Not showing Plates")
    end
  end
end

-- NAMEPLATES

local function IsNamePlateFrame(frame)
 local overlayRegion = frame:GetRegions()
  if not overlayRegion or overlayRegion:GetObjectType() ~= "Texture" or overlayRegion:GetTexture() ~= "Interface\\Tooltips\\Nameplate-Border" then
    return false
  end
  return true
end

local function CacheIcon()
  local name = UnitName("target") or "-nil-"
  if UnitIsPlayer("target") then
    IconCache[name] = UnitClass("target")
  else
    if UnitCreatureType("target") == "Critter" then
      Ignore[name] = true
    end
    IconCache[name] = UnitClassification("target")
  end
end



function HBPlates:OnUpdate()
  local frames = { WorldFrame:GetChildren() }
  for _,
 namePlate in ipairs(plateCache) do
    HBPlates:PlateRefresh(namePlate)
  end
  for _,
  namePlate in pairs(frames) do
    if IsNamePlateFrame(namePlate) then
      if not namePlate.HBPlatesHooked then
        namePlate.HBPlatesHooked = true
        namePlate:SetScript("OnShow",
 HBPlates.OnPlateShow)
        HBPlates:PlateInit(namePlate)
        table.insert(plateCache,
 namePlate)
      end
    end
  end
end

function HBPlates:OnPlateShow()
  HBPlates:PlateInit(this)
end

function HBPlates:PlateInit(namePlate)
  local playerTarget = UnitName("target")
  if playerTarget ~= nil and IconCache[playerTarget] == nil then
    CacheIcon()
  end
  local Border,
  Glow,
  Name,
  Level,
  BossSkull,
  RaidIcon = namePlate:GetRegions()
  local name = Name:GetText()
  if not name then
    return
  end
  if not IconCache[name] then
    namePlate:Click()
    CacheIcon()
    if playerTarget~=nil then
      TargetLastTarget()
    else
      ClearTarget()
    end
  end
  if Ignore[name] then
      namePlate:Hide()
  else
    local yOffset = 18
    namePlate:SetFrameStrata("BACKGROUND")
    namePlate:SetWidth(HBPlates.db.profile.barW + 6)
    namePlate:SetHeight(HBPlates.db.profile.barH + 6 + yOffset)
    local HealthBar = namePlate:GetChildren()
    HealthBar:SetStatusBarTexture("Interface\\AddOns\\HBPlates\\Textures\\bartexture")
    HealthBar:ClearAllPoints()
    HealthBar:SetPoint("TOP",
  namePlate,
  "TOP",
  0,
  -yOffset)
    HealthBar:SetWidth(HBPlates.db.profile.barW)
    HealthBar:SetHeight(HBPlates.db.profile.barH)
    Glow:SetTexture("Interface\\AddOns\\HBPlates\\Textures\\Glow")
    Glow:SetAlpha(0.5)
    Glow:ClearAllPoints()
    Glow:SetPoint("CENTER",
  HealthBar,
  "CENTER",
  0,
  0)
    Glow:SetWidth(HealthBar:GetWidth() + 4)
    Glow:SetHeight(HealthBar:GetHeight() + 4)
    RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("CENTER",
  HealthBar,
  "BOTTOM",
  0,
  -4)
    RaidIcon:SetWidth(12)
    RaidIcon:SetHeight(12)
    if HealthBar.bg == nil then
      HealthBar.bg = HealthBar:CreateTexture(nil,
  "BORDER")
      HealthBar.bg:SetTexture(0,
 0,
 0,
 0.5)
      HealthBar.bg:ClearAllPoints()
      HealthBar.bg:SetPoint("CENTER",
  HealthBar,
  "CENTER",
  0,
  0)
      HealthBar.bg:SetWidth(HealthBar:GetWidth() + 4)
      HealthBar.bg:SetHeight(HealthBar:GetHeight() + 4)
    end
    Name:SetFontObject(GameFontNormal)
    Name:SetFont("Interface\\AddOns\\HBPlates\\Fonts\\barframes.ttf",
 11)
    Name:SetPoint("BOTTOM",
  HealthBar,
  "TOP",
  0,
  4)
    Level:SetFontObject(GameFontNormal)
    Level:SetFont("Interface\\AddOns\\HBPlates\\Fonts\\barframes.ttf",
 11)
    Level:SetPoint("LEFT",
  Name,
  "RIGHT",
  2,
  0)
    if namePlate.classIcon == nil then
      namePlate.classIcon = namePlate:CreateTexture(nil,
  "BORDER")
      namePlate.classIcon:SetTexture(0,
 0,
 0,
 0)
      namePlate.classIcon:ClearAllPoints()
      namePlate.classIcon:SetPoint("BOTTOMRIGHT",
  Name,
  "BOTTOMLEFT",
  -2,
  0)
      namePlate.classIcon:SetWidth(12)
      namePlate.classIcon:SetHeight(12)
    end
    Border:Hide()
    HealthBar:Show()
    HealthBar.bg:Show()
    Name:Show()
    if BossSkull:IsShown() then
      Level:Hide()
      BossSkull:SetHeight(12)
      BossSkull:SetWidth(12)
      BossSkull:SetTexture("Interface\\AddOns\\HBPlates\\Textures\\skull")
      BossSkull:ClearAllPoints()
      BossSkull:SetPoint("LEFT",
  Name,
  "RIGHT",
  2,
  0)
    else
      Level:Show()
    end
    if  IconCache[name] ~= nil and namePlate.classIcon:GetTexture() ~= Icons[IconCache[name]] then
      namePlate.classIcon:SetTexture(Icons[IconCache[name]])
      namePlate.classIcon:SetAlpha(0.9)
      namePlate.classIcon:SetTexCoord(0,
 1,
 0,
 1)
    end
    HBPlates:PlateRefresh(namePlate)
  end
end

function HBPlates:PlateRefresh(namePlate)
  namePlate:SetAlpha(math.max(0.7,
 namePlate:GetAlpha()))
  local HealthBar = namePlate:GetChildren()
  local Border,
  Glow,
  Name,
  Level,
  BossSkull,
  RaidIcon = namePlate:GetRegions()
  local name = Name:GetText()
  if not name then
    return
  end
  local r,
 g,
 b = HealthBar:GetStatusBarColor()
  if IconCache[name] == "normal" or IconCache[name] == "elite" or IconCache[name] == "rare" or IconCache[name] == "rareelite" or IconCache[name] == "worldboss" then
    if r < 0.9 and math.ceil( g * 100 ) == 100 then
      HealthBar:SetStatusBarColor(0,
 0.5,
 0)
    end
    if namePlate.classIcon then
      namePlate.classIcon:SetVertexColor(HealthBar:GetStatusBarColor())
    end
  else
    if math.ceil( b * 100 ) == 100 then
      HealthBar:SetStatusBarColor(0,
 1,
 0)
    end
    if namePlate.classIcon then
      namePlate.classIcon:SetVertexColor(1,
 1,
 1,
 1)
    end
  end
end
