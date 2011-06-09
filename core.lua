local _, addon = ...
-- utility for rounding
local function round(input, places)
    if not places then
        places = 0
    end
    if type(input) == "number" and type(places) == "number" then
        local pow = 1
        for i = 1, ceil(places) do
            pow = pow * 10
        end
        return floor(input * pow + 0.5) / pow
    else
        return input
    end
end

-- for keeping a set's icon intact when it is updated
local function GetTextureIndex(tex) -- blatantly stolen from Tekkubs EquipSetUpdate. Thanks!
    RefreshEquipmentSetIconInfo()
    tex = tex:lower()
    local numicons = GetNumMacroIcons()
    for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do if GetInventoryItemTexture("player", i) then numicons = numicons + 1 end end
    for i = 1, numicons do
        local texture, index = GetEquipmentSetIconInfo(i)
        if texture:lower() == tex then return index end
    end
end

-- create Addon object
TopFit = LibStub("AceAddon-3.0"):NewAddon("TopFit", "AceConsole-3.0")
TopFit.locale = addon.locale

-- debug function
function TopFit:Debug(text)
    if self.db.profile.debugMode then
        TopFit:Print("Debug: "..text)
    end
end

-- debug function
function TopFit:Warning(text)
    --TODO: create table of warnings and dont print any multiples
    --TopFit:Print("|cffff0000Warning: "..text)
end

-- joins any number of tables together, one after the other. elements within the input-tables will get mixed, though
function TopFit:JoinTables(...)
    local result = {}
    local tab
    
    for i = 1, select("#", ...) do
        tab = select(i, ...)
        if tab then
            for index, value in pairs(tab) do
                tinsert(result, value)
            end
        end
    end
    
    return result
end

function TopFit.ShowTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    if self.tipText then
        GameTooltip:SetText(self.tipText, nil, nil, nil, nil, true)
    elseif self.itemLink then
        GameTooltip:SetHyperlink(self.itemLink)
    end
    GameTooltip:Show()
end
function TopFit.HideTooltip() GameTooltip:Hide() end

function TopFit:EquipRecommendedItems()
    -- skip equipping if virtual items were included
    if (not TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].skipVirtualItems) and TopFit.db.profile.sets[TopFit.setCode].virtualItems and #(TopFit.db.profile.sets[TopFit.setCode].virtualItems) > 0 then
        TopFit:Print(TopFit.locale.NoticeVirtualItemsUsed)
        
        -- reenable options and quit
        TopFit.ProgressFrame:StoppedCalculation()
        TopFit.isBlocked = false
        
        -- reset relevant score field
        TopFit.ignoreCapsForCalculation = nil
        
        -- initiate next calculation if necessary
        if (#TopFit.workSetList > 0) then
            TopFit:CalculateSets()
        end
        return
    end
    
    -- equip them
    TopFit.updateEquipmentCounter = 10000
    TopFit.equipRetries = 0
    TopFit.updateFrame:SetScript("OnUpdate", TopFit.onUpdateForEquipment)
end

function TopFit:onUpdateForEquipment()
    -- don't try equipping in combat or while dead
    if UnitAffectingCombat("player") or UnitIsDeadOrGhost("player") then
        return
    end

    -- see if all items already fit
    allDone = true
    for slotID, recTable in pairs(TopFit.itemRecommendations) do
        if (TopFit:GetItemScore(recTable.locationTable.itemLink, TopFit.setCode, TopFit.ignoreCapsForCalculation) > 0) then
            slotItemLink = GetInventoryItemLink("player", slotID)
            if (slotItemLink ~= recTable.locationTable.itemLink) then
                allDone = false
            end
        end
    end
    
    TopFit.updateEquipmentCounter = TopFit.updateEquipmentCounter + 1
    
    -- try equipping the items every 100 frames (some weird ring positions might stop us from correctly equipping items on the first try, for example)
    if (TopFit.updateEquipmentCounter > 100) then
        for slotID, recTable in pairs(TopFit.itemRecommendations) do
            slotItemLink = GetInventoryItemLink("player", slotID)
            if (slotItemLink ~= recTable.locationTable.itemLink) then
                -- find itemLink in bags
                local itemTable = nil
                local found = false
                local foundBag, foundSlot
                for bag = 0, 4 do
                    for slot = 1, GetContainerNumSlots(bag) do
                        local itemLink = GetContainerItemLink(bag,slot)
                        
                        if itemLink == recTable.locationTable.itemLink then
                            foundBag = bag
                            foundSlot = slot
                            found = true
                            break
                        end
                    end
                end
                
                if not found then
                    -- try to find item in equipped items
                    for _, invSlot in pairs(TopFit.slots) do
                        local itemLink = GetInventoryItemLink("player", invSlot)
                        
                        if itemLink == recTable.locationTable.itemLink then
                            foundBag = nil
                            foundSlot = invSlot
                            found = true
                            break
                        end
                    end
                end
                
                if not found then
                    TopFit:Print(string.format(TopFit.locale.ErrorItemNotFound, recTable.locationTable.itemLink))
                    TopFit.itemRecommendations[slotID] = nil
                else
                    -- try equipping the item again
                    --TODO: if we try to equip offhand, and mainhand is two-handed, and no titan's grip, unequip mainhand first
                    ClearCursor()
                    if foundBag then
                        PickupContainerItem(foundBag, foundSlot)
                    else
                        PickupInventoryItem(foundSlot)
                    end
                    EquipCursorItem(slotID)
                end
            end
        end
        
        TopFit.updateEquipmentCounter = 0
        TopFit.equipRetries = TopFit.equipRetries + 1
    end
    
    -- if all items have been equipped, save equipment set and unregister script
    -- also abort if it takes to long, just save the items that _have_ been equipped
    if ((allDone) or (TopFit.equipRetries > 5)) then
        if (not allDone) then
            TopFit:Print(TopFit.locale.NoticeEquipFailure)
            
            for slotID, recTable in pairs(TopFit.itemRecommendations) do
                slotItemLink = GetInventoryItemLink("player", slotID)
                if (slotItemLink ~= recTable.locationTable.itemLink) then
                    TopFit:Print(string.format(TopFit.locale.ErrorEquipFailure, recTable.locationTable.itemLink, slotID, TopFit.slotNames[slotID]))
                    TopFit.itemRecommendations[slotID] = nil
                end
            end
        end
        
        TopFit:Debug("All Done!")
        TopFit.updateFrame:SetScript("OnUpdate", nil)
        TopFit.ProgressFrame:StoppedCalculation()
        
        EquipmentManagerClearIgnoredSlotsForSave()
        for _, slotID in pairs(TopFit.slots) do
            if (not TopFit.itemRecommendations[slotID]) then
                TopFit:Debug("Ignoring slot "..slotID)
                EquipmentManagerIgnoreSlotForSave(slotID)
            end
        end
        
        -- save equipment set
        if (CanUseEquipmentSets()) then
            setName = TopFit:GenerateSetName(TopFit.currentSetName)
            -- check if a set with this name exists
            if (GetEquipmentSetInfoByName(setName)) then
                texture = GetEquipmentSetInfoByName(setName)
                texture = "Interface\\Icons\\"..texture
                
                textureIndex = GetTextureIndex(texture)
            else
                textureIndex = GetTextureIndex("Interface\\Icons\\Spell_Holy_EmpowerChampion")
            end
            
            TopFit:Debug("Trying to save set: "..setName..", "..(textureIndex or "nil"))
            SaveEquipmentSet(setName, textureIndex)
        end
    
        -- we are done with this set
        TopFit.isBlocked = false
        
        -- reset relevant score field
        TopFit.ignoreCapsForCalculation = nil
        
        -- initiate next calculation if necessary
        if (#TopFit.workSetList > 0) then
            TopFit:CalculateSets()
        end
    end
end

function TopFit:GenerateSetName(name)
    -- using substr because blizzard interface only allows 16 characters
    -- although technically SaveEquipmentSet & co allow more ;)
    return (((name ~= nil) and string.sub(name.." ", 1, 12).."(TF)") or "TopFit")
end

function TopFit:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory("TopFit")
    else
        if input:trim():lower() == "show" then
            TopFit:CreateProgressFrame()
        elseif input:trim():lower() == "options" then
            InterfaceOptionsFrame_OpenToCategory("TopFit")
        else
            TopFit:Print(TopFit.locale.SlashHelp)
        end
    end
end

function TopFit:OnInitialize()
    -- load saved variables
    self.db = LibStub("AceDB-3.0"):New("TopFitDB")
    
    -- set callback handler
    TopFit.eventHandler = TopFit.eventHandler or LibStub("CallbackHandler-1.0"):New(TopFit)
    
    -- create gametooltip for scanning
    TopFit.scanTooltip = CreateFrame('GameTooltip', 'TFScanTooltip', UIParent, 'GameTooltipTemplate')
    
    -- check if any set is saved already, if not, create default
    if (not self.db.profile.sets) then
        self.db.profile.sets = {
            set_1 = {
                name = "Default Set",
                weights = {},
                caps = {},
                forced = {},
            },
        }
    end
    
    -- for savedvariable updates: check if each set has a forced table
    for set, table in pairs(self.db.profile.sets) do
        if table.forced == nil then
            table.forced = {}
        end
        
        -- also set if all stat and cap values are numbers
        for stat, value in pairs(table.weights) do
            table.weights[stat] = tonumber(value) or nil
        end
        for _, capTable in pairs(table.caps) do
            capTable.value = tonumber(capTable.value)
        end
    end
    
    -- list of weight categories and stats
    TopFit.statList = {
        [TopFit.locale.StatsCategoryBasic] = {
            [1] = "ITEM_MOD_AGILITY_SHORT",
            [2] = "ITEM_MOD_INTELLECT_SHORT",
            [3] = "ITEM_MOD_SPIRIT_SHORT",
            [4] = "ITEM_MOD_STAMINA_SHORT",
            [5] = "ITEM_MOD_STRENGTH_SHORT",
        },
        [TopFit.locale.StatsCategoryMelee] = {
            [1] = "ITEM_MOD_EXPERTISE_RATING_SHORT",
            [2] = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
            [3] = "ITEM_MOD_ATTACK_POWER_SHORT",
        },
        [TopFit.locale.StatsCategoryCaster] = {
            [1] = "ITEM_MOD_SPELL_PENETRATION_SHORT",
            [2] = "ITEM_MOD_SPELL_POWER_SHORT",
            --[3] = "ITEM_MOD_MANA_REGENERATION_SHORT",
        },
        [TopFit.locale.StatsCategoryDefensive] = {
            [1] = "ITEM_MOD_BLOCK_RATING_SHORT",
            [4] = "ITEM_MOD_DODGE_RATING_SHORT",
            [5] = "ITEM_MOD_PARRY_RATING_SHORT",
            [6] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
            [7] = "RESISTANCE0_NAME",                   -- armor
        },
        [TopFit.locale.StatsCategoryHybrid] = {
            [1] = "ITEM_MOD_CRIT_RATING_SHORT",
            [2] = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT",
            [3] = "ITEM_MOD_HASTE_RATING_SHORT",
            [4] = "ITEM_MOD_HIT_RATING_SHORT",
            [5] = "ITEM_MOD_MASTERY_RATING_SHORT",
        },
        [TopFit.locale.StatsCategoryMisc] = {
            [1] = "ITEM_MOD_HEALTH_SHORT",
            [2] = "ITEM_MOD_MANA_SHORT",
            [3] = "ITEM_MOD_HEALTH_REGENERATION_SHORT",
        },
        [TopFit.locale.StatsCategoryResistances] = {
            [1] = "RESISTANCE1_NAME",                   -- holy
            [2] = "RESISTANCE2_NAME",                   -- fire
            [3] = "RESISTANCE3_NAME",                   -- nature
            [4] = "RESISTANCE4_NAME",                   -- frost
            [5] = "RESISTANCE5_NAME",                   -- shadow
            [6] = "RESISTANCE6_NAME",                   -- arcane
        },
        [TopFit.locale.StatsCategoryArmorTypes] = {
            [1] = "TOPFIT_ARMORTYPE_CLOTH",
            [2] = "TOPFIT_ARMORTYPE_LEATHER",
            [3] = "TOPFIT_ARMORTYPE_MAIL",
            [4] = "TOPFIT_ARMORTYPE_PLATE",
        }
    }

    TOPFIT_ARMORTYPE_CLOTH = select(2, GetAuctionItemSubClasses(2));
    TOPFIT_ARMORTYPE_LEATHER = select(3, GetAuctionItemSubClasses(2));
    TOPFIT_ARMORTYPE_MAIL = select(4, GetAuctionItemSubClasses(2));
    TOPFIT_ARMORTYPE_PLATE = select(5, GetAuctionItemSubClasses(2));

    -- list of inventory slot names
    TopFit.slotList = {
        --"AmmoSlot",
        "BackSlot",
        "ChestSlot",
        "FeetSlot",
        "Finger0Slot",
        "Finger1Slot",
        "HandsSlot",
        "HeadSlot",
        "LegsSlot",
        "MainHandSlot",
        "NeckSlot",
        "RangedSlot",
        "SecondaryHandSlot",
        "ShirtSlot",
        "ShoulderSlot",
        "TabardSlot",
        "Trinket0Slot",
        "Trinket1Slot",
        "WaistSlot",
        "WristSlot",
    }
    
    -- create list of slot names with corresponding slot IDs
    TopFit.slots = {}
    TopFit.slotNames = {}
    for _, slotName in pairs(TopFit.slotList) do
        local slotID, _, _ = GetInventorySlotInfo(slotName)
        TopFit.slots[slotName] = slotID;
        TopFit.slotNames[slotID] = slotName;
    end
    
    -- create frame for OnUpdate
    TopFit.updateFrame = CreateFrame("Frame")
    
    -- create options
    TopFit:createOptions()

    -- register Slash command
    self:RegisterChatCommand("topfit", "ChatCommand")
    self:RegisterChatCommand("tf", "ChatCommand")
    
    -- cache tables
    TopFit.itemsCache = {}
    TopFit.scoresCache = {}
    
    -- table for equippable item list
    TopFit.equippableItems = {}
    TopFit:collectEquippableItems()
    TopFit.loginDelay = 150
    
    -- frame for eventhandling
    TopFit.eventFrame = CreateFrame("Frame")
    TopFit.eventFrame:RegisterEvent("BAG_UPDATE")
    TopFit.eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
    TopFit.eventFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    TopFit.eventFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
    TopFit.eventFrame:SetScript("OnEvent", TopFit.FrameOnEvent)
    TopFit.eventFrame:SetScript("OnUpdate", TopFit.delayCalculationOnLogin)
    
    -- frame for calculation function
    TopFit.calculationsFrame = CreateFrame("Frame");
    
    -- heirloom info
    local isPlateWearer, isMailWearer = false, false
    if (select(2, UnitClass("player")) == "WARRIOR") or (select(2, UnitClass("player")) == "PALADIN") or (select(2, UnitClass("player")) == "DEATHKNIGHT") then
        isPlateWearer = true
    end
    if (select(2, UnitClass("player")) == "SHAMAN") or (select(2, UnitClass("player")) == "HUNTER") then
        isMailWearer = true
    end
    
    -- tables of itemIDs for heirlooms which change armor type
    TopFit.heirloomInfo = {
        plateHeirlooms = {
            [3] = {
                [1] = 42949,
                [2] = 44100,
                [3] = 44099,
            },
            [5] = {
                [1] = 48685,
            },
        },
        mailHeirlooms = {
            [3] = {
                [1] = 44102,
                [2] = 42950,
                [3] = 42951,
                [4] = 44101,
            },
            [5] = {
                [1] = 48677,
                [2] = 48683,
            },
        },
        isPlateWearer = isPlateWearer,
        isMailWearer = isMailWearer
    }
    
    -- container for plugin information and frames
    TopFit.plugins = {}
    
    -- button to open frame
    hooksecurefunc("ToggleCharacter", function (...)
        if not TopFit.toggleProgressFrameButton then
            TopFit.toggleProgressFrameButton = CreateFrame("Button", "TopFit_toggleProgressFrameButton", PaperDollSidebarTab1)
            TopFit.toggleProgressFrameButton:SetWidth(30)
            TopFit.toggleProgressFrameButton:SetHeight(32)
            TopFit.toggleProgressFrameButton:SetPoint("RIGHT", PaperDollSidebarTab1, "LEFT")
            
            local normalTexture = TopFit.toggleProgressFrameButton:CreateTexture()
            local pushedTexture = TopFit.toggleProgressFrameButton:CreateTexture()
            local highlightTexture = TopFit.toggleProgressFrameButton:CreateTexture()
            normalTexture:SetTexture("Interface\\Buttons\\UI-MicroButtonCharacter-Up")
            pushedTexture:SetTexture("Interface\\Buttons\\UI-MicroButtonCharacter-Down")
            highlightTexture:SetTexture("Interface\\Buttons\\UI-MicroButton-Hilight")
            normalTexture:SetTexCoord(0, 25/64, 0, 63/64, 1, 25/64, 1, 62/64)
            normalTexture:SetAllPoints()
            pushedTexture:SetTexCoord(0, 25/64, 0, 63/64, 1, 25/64, 1, 62/64)
            pushedTexture:SetAllPoints()
            highlightTexture:SetTexCoord(0, 25/64, 0, 63/64, 1, 25/64, 1, 62/64)
            highlightTexture:SetAllPoints()
            TopFit.toggleProgressFrameButton:SetNormalTexture(normalTexture)
            TopFit.toggleProgressFrameButton:SetPushedTexture(pushedTexture)
            TopFit.toggleProgressFrameButton:SetHighlightTexture(highlightTexture)
            local iconTexture = TopFit.toggleProgressFrameButton:CreateTexture()
            iconTexture:SetTexture("Interface\\Icons\\Achievement_BG_trueAVshutout") -- golden sword
            iconTexture:SetTexCoord(9/64, 4/64, 9/64, 61/64, 55/64, 4/64, 55/64, 61/64)
            iconTexture:SetDrawLayer("OVERLAY")
            iconTexture:SetBlendMode("ADD")
            iconTexture:SetPoint("TOPLEFT", TopFit.toggleProgressFrameButton, "TOPLEFT", 6, -4)
            iconTexture:SetPoint("BOTTOMRIGHT", TopFit.toggleProgressFrameButton, "BOTTOMRIGHT", -6, 4)
            
            TopFit.toggleProgressFrameButton:SetScript("OnClick", function(...)
                if (not TopFit.ProgressFrame) or (not TopFit.ProgressFrame:IsShown()) then
                    TopFit:CreateProgressFrame()
                else
                    TopFit:HideProgressFrame()
                end
            end)
            
            TopFit.toggleProgressFrameButton:SetScript("OnMouseDown", function(...)
                iconTexture:SetVertexColor(0.5, 0.5, 0.5)
            end)
            TopFit.toggleProgressFrameButton:SetScript("OnMouseUp", function(...)
                iconTexture:SetVertexColor(1, 1, 1)
            end)
            
            -- tooltip
            TopFit.toggleProgressFrameButton:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText("Open TopFit", nil, nil, nil, nil, true)
                GameTooltip:Show()
            end)
            TopFit.toggleProgressFrameButton:SetScript("OnLeave", function(...)
                GameTooltip:Hide()
            end)
        end
        
        TopFit:initializeCharacterFrameUI()
    end)
    
    -- create default plugin frames
    TopFit:CreateStatsPlugin()
    TopFit:CreateVirtualItemsPlugin()
    TopFit:CreateUtilitiesPlugin()
    
    TopFit:collectItems()
end

function TopFit:collectEquippableItems()
    local newItem = false
    
    -- check bags
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local item = GetContainerItemLink(bag, slot)
            
            if IsEquippableItem(item) then
                local found = false
                for _, link in pairs(TopFit.equippableItems) do
                    if link == item then
                        found = true
                        break
                    end
                end
                
                if not found then
                    tinsert(TopFit.equippableItems, item)
                    newItem = true
                end
            end
        end
    end
    
    -- check equipment (mostly so your set doesn't get recalculated just because you unequip an item)
    for _, invSlot in pairs(TopFit.slots) do
        local item = GetInventoryItemLink("player", invSlot)
        if IsEquippableItem(item) then
            local found = false
            for _, link in pairs(TopFit.equippableItems) do
                if link == item then
                    found = true
                    break
                end
            end
            
            if not found then
                tinsert(TopFit.equippableItems, item)
                newItem = true
            end
        end
    end
    
    return newItem
end

function TopFit:delayCalculationOnLogin()
    if TopFit.loginDelay then
        TopFit.loginDelay = TopFit.loginDelay - 1
        if TopFit.loginDelay <= 0 then
            TopFit.loginDelay = nil
            TopFit.eventFrame:SetScript("OnUpdate", nil)
        end
    end
end

function TopFit:FrameOnEvent(event, ...)
    if (event == "BAG_UPDATE") then
        -- update item list
        --TODO: only update affected bag
        TopFit:collectItems()
        
        -- check inventory for new equippable items
        if TopFit:collectEquippableItems() and not TopFit.loginDelay then
            -- new equippable item in inventory!!!!
            -- calculate set silently if player wishes
            if not TopFit.workSetList then
                TopFit.workSetList = {}
            end
            local runUpdate = false;
            if (TopFit.db.profile.defaultUpdateSet and GetActiveTalentGroup() == 1) then
                tinsert(TopFit.workSetList, TopFit.db.profile.defaultUpdateSet)
                runUpdate = true;
            end
            if (TopFit.db.profile.defaultUpdateSet2 and GetActiveTalentGroup() == 2) then
                tinsert(TopFit.workSetList, TopFit.db.profile.defaultUpdateSet2)
                runUpdate = true;
            end
            if runUpdate then
                TopFit:CalculateSets(true) -- calculate silently
            end
        end
    elseif (event == "PLAYER_LEVEL_UP") then
        -- remove cache info for heirlooms so they are rescanned
        for itemLink, itemTable in pairs(TopFit.itemsCache) do
            if itemTable.itemQuality == 7 then
                TopFit.itemsCache[itemLink] = nil
                TopFit.scoresCache[itemLink] = nil
            end
        end
        
        -- if an auto-update-set is set, update that as well
            if not TopFit.workSetList then
                TopFit.workSetList = {}
            end
            local runUpdate = false;
            if (TopFit.db.profile.defaultUpdateSet and GetActiveTalentGroup() == 1) then
                tinsert(TopFit.workSetList, TopFit.db.profile.defaultUpdateSet)
                runUpdate = true;
            end
            if (TopFit.db.profile.defaultUpdateSet2 and GetActiveTalentGroup() == 2) then
                tinsert(TopFit.workSetList, TopFit.db.profile.defaultUpdateSet2)
                runUpdate = true;
            end
            if runUpdate then
                -- because right on level up there seem to be problems finding the items for equipping, delay the actual update
                if (not TopFit.eventFrame:HasScript("OnUpdate")) then
                    TopFit.delayCalculation = 100
                    TopFit.eventFrame:SetScript("OnUpdate", function(self)
                        if (TopFit.delayCalculation > 0) then
                            TopFit.delayCalculation = TopFit.delayCalculation - 1
                        else
                            TopFit.eventFrame:SetScript("OnUpdate", nil)
                            TopFit:CalculateSets(true) -- calculate silently
                        end
                    end)
                end
            end
    elseif (event == "ACTIVE_TALENT_GROUP_CHANGED") then
        TopFit:ClearCache()
    elseif (event == "PLAYER_TALENT_UPDATE") then
        TopFit:ClearCache()
    end
end

function TopFit:OnEnable()
    -- Called when the addon is enabled
end

function TopFit:OnDisable()
    -- Called when the addon is disabled
end

TopFit.characterFrameUIcreated = false;

function TopFit:initializeCharacterFrameUI()
    if (TopFit.characterFrameUIcreated) then return end
    TopFit.characterFrameUIcreated = true;
    PaperDollSidebarTab3:SetPoint("BOTTOMRIGHT", PaperDollSidebarTabs, "BOTTOMRIGHT", -64, 0)
    PanelTemplates_SetNumTabs(CharacterFrame, 4);
    PanelTemplates_UpdateTabs(CharacterFrame);
    
    local pane = TopFitSidebarFrameScrollChild
    
    local setDropDown = TopFit:initializeSetDropdown(pane)
    
    local i = 1
    for statCategory, statsTable in pairs(TopFit.statList) do
        local statGroup = CreateFrame("Frame", "TopFitSidebarStatGroup"..i, pane, "TopFitStatGroupTemplate")
        if (i == 1) then
            statGroup:SetPoint("TOPLEFT", setDropDown, "BOTTOMLEFT", 0, -5)
        else
            statGroup:SetPoint("TOPLEFT", _G["TopFitSidebarStatGroup"..(i - 1)], "BOTTOMLEFT", 0, -2)
        end
        statGroup.NameText:SetText(statCategory)
        TopFit:UpdateStatGroup(statGroup)
        
        i = i + 1
    end

    TopFit:CreateEditStatPane(pane)
end

function TopFit:initializeSetDropdown(pane)
    local paneWidth = pane:GetWidth()
    
    local setDropDown = CreateFrame("Frame", "TopFitSetDropDown", pane, "UIDropDownMenuTemplate")
    setDropDown:SetPoint("TOPLEFT", pane, "TOPLEFT")
    setDropDown:SetWidth(paneWidth)
    _G["TopFitSetDropDownMiddle"]:SetWidth(paneWidth - 35)
    _G["TopFitSetDropDownButton"]:SetWidth(paneWidth - 20)
    
    UIDropDownMenu_Initialize(setDropDown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        for k, v in pairs(TopFit.db.profile.sets) do
            if not TopFit.selectedSet then
                TopFit.selectedSet = k
            end
            info = UIDropDownMenu_CreateInfo()
            info.text = v.name
            info.value = k
            info.func = function(self)
                TopFit:SetSelectedSet(self.value)
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    UIDropDownMenu_SetSelectedID(setDropDown, 1)
    UIDropDownMenu_JustifyText(setDropDown, "LEFT")
    
    return setDropDown
end

function TopFit.StatValueEditBoxFocusLost(self)
    local statCode = self:GetParent().statCode
    self:SetText(TopFit:GetStatValue(TopFit.selectedSet, statCode))
    self:ClearFocus()
end

function TopFit:CreateEditStatPane(pane)
    local editStatPane = CreateFrame("Frame", "TopFitSidebarEditStatPane", pane)
    --[[local valueString = editStatPane:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
            valueString:SetPoint("TOPLEFT", editStatPane, "TOPLEFT", 0, -5)
            valueString:SetPoint("RIGHT")
            valueString:SetJustifyH("LEFT")
            valueString:SetTextHeight(10)
            valueString:SetText("Has a value of:")]]

    local capString = editStatPane:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    --capString:SetPoint("TOPLEFT", valueString, "BOTTOMLEFT")
    capString:SetPoint("TOPLEFT", editStatPane, "TOPLEFT", 0, -5)
    capString:SetPoint("RIGHT")
    capString:SetJustifyH("LEFT")
    capString:SetTextHeight(10)
    capString:SetText("Until you reach:")

    local forceCapString = editStatPane:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    forceCapString:SetPoint("TOPLEFT", capString, "BOTTOMLEFT")
    forceCapString:SetPoint("RIGHT")
    forceCapString:SetJustifyH("LEFT")
    forceCapString:SetTextHeight(10)
    forceCapString:SetText("Which must be reached:")

    local afterCapValueString = editStatPane:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    afterCapValueString:SetPoint("TOPLEFT", forceCapString, "BOTTOMLEFT")
    afterCapValueString:SetPoint("RIGHT")
    afterCapValueString:SetJustifyH("LEFT")
    afterCapValueString:SetTextHeight(10)
    afterCapValueString:SetText("After which its value is:")

    editStatPane:SetHeight(--[[valueString:GetHeight() +]] capString:GetHeight() + forceCapString:GetHeight() + afterCapValueString:GetHeight() + 10)

    --[[
            local function EditBoxFocusLost(self)
                local statCode = self:GetParent().statCode
                self:SetText(TopFit:GetStatValue(TopFit.selectedSet, statCode))
                self:ClearFocus()
            end
        
            statValueTextBox = CreateFrame("EditBox", "TopFitSidebarEditStatPaneStatValue", editStatPane)
            statValueTextBox:SetFrameStrata("HIGH")
            statValueTextBox:SetPoint("TOP", valueString, "TOP")
            statValueTextBox:SetPoint("BOTTOM", valueString, "BOTTOM")
            statValueTextBox:SetPoint("RIGHT", editStatPane, "RIGHT")
            statValueTextBox:SetWidth(100)
            statValueTextBox:SetAutoFocus(false)
            statValueTextBox:EnableMouse(true)
            statValueTextBox:SetFontObject("GameFontHighlightSmall")
            statValueTextBox:SetJustifyH("RIGHT")
            
            -- scripts
            statValueTextBox:SetScript("OnEditFocusGained", function(...) statValueTextBox.HighlightText(...) end)
            statValueTextBox:SetScript("OnEditFocusLost", EditBoxFocusLost)
            statValueTextBox:SetScript("OnEscapePressed", EditBoxFocusLost)
            statValueTextBox:SetScript("OnEnterPressed", function(self)
                local value = tonumber(self:GetText())
                local stat = self:GetParent().statCode
                if stat and value then
                    if value == 0 then value = nil end  -- used for removing stats from the list
                    TopFit:SetStatValue(TopFit.selectedSet, stat, value)
                else
                    TopFit:Debug("invalid input")
                end
                EditBoxFocusLost(self)
                TopFit:UpdateStatGroups()
                TopFit:CalculateScores()
            end)]]
    
    local function EditBoxFocusLostCap(self)
        local stat = self:GetParent().statCode
        self:SetText(TopFit:GetCapValue(TopFit.selectedSet, stat))
        self:ClearFocus()
    end

    capValueTextBox = CreateFrame("EditBox", "TopFitSidebarEditStatPaneStatCap", editStatPane)
    capValueTextBox:SetFrameStrata("HIGH")
    capValueTextBox:SetPoint("TOP", capString, "TOP")
    capValueTextBox:SetPoint("BOTTOM", capString, "BOTTOM")
    capValueTextBox:SetPoint("RIGHT", editStatPane, "RIGHT")
    capValueTextBox:SetWidth(100)
    capValueTextBox:SetAutoFocus(false)
    capValueTextBox:EnableMouse(true)
    capValueTextBox:SetFontObject("GameFontHighlightSmall")
    capValueTextBox:SetJustifyH("RIGHT")
    
    -- scripts
    capValueTextBox:SetScript("OnEditFocusGained", function(...) capValueTextBox.HighlightText(...) end)
    capValueTextBox:SetScript("OnEditFocusLost", EditBoxFocusLostCap)
    capValueTextBox:SetScript("OnEscapePressed", EditBoxFocusLostCap)
    capValueTextBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText())
        local stat = self:GetParent().statCode
        if stat and value then
            TopFit:SetCapValue(TopFit.selectedSet, stat, value)
        else
            TopFit:Debug("invalid input")
        end
        EditBoxFocusLostCap(self)
        TopFit:UpdateStatGroups()
        TopFit:CalculateScores()
    end)
    
    local function EditBoxFocusLostAfterCap(self)
        local statCode = self:GetParent().statCode
        self:SetText(TopFit:GetAfterCapStatValue(TopFit.selectedSet, statCode))
        self:ClearFocus()
    end

    afterCapStatValueTextBox = CreateFrame("EditBox", "TopFitSidebarEditStatPaneStatAfterCapValue", editStatPane)
    afterCapStatValueTextBox:SetFrameStrata("HIGH")
    afterCapStatValueTextBox:SetPoint("TOP", afterCapValueString, "TOP")
    afterCapStatValueTextBox:SetPoint("BOTTOM", afterCapValueString, "BOTTOM")
    afterCapStatValueTextBox:SetPoint("RIGHT", editStatPane, "RIGHT")
    afterCapStatValueTextBox:SetWidth(100)
    afterCapStatValueTextBox:SetAutoFocus(false)
    afterCapStatValueTextBox:EnableMouse(true)
    afterCapStatValueTextBox:SetFontObject("GameFontHighlightSmall")
    afterCapStatValueTextBox:SetJustifyH("RIGHT")
    
    -- scripts
    afterCapStatValueTextBox:SetScript("OnEditFocusGained", function(...) afterCapStatValueTextBox.HighlightText(...) end)
    afterCapStatValueTextBox:SetScript("OnEditFocusLost", EditBoxFocusLostAfterCap)
    afterCapStatValueTextBox:SetScript("OnEscapePressed", EditBoxFocusLostAfterCap)
    afterCapStatValueTextBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText())
        local stat = self:GetParent().statCode
        if stat and value then
            if value == 0 then value = nil end  -- used for removing stats from the list
            TopFit:SetAfterCapStatValue(TopFit.selectedSet, stat, value)
        else
            TopFit:Debug("invalid input")
        end
        EditBoxFocusLostAfterCap(self)
        TopFit:UpdateStatGroups()
        TopFit:CalculateScores()
    end)
    
end

function TopFit:SetSelectedSet(setID)
    local i
    if not setID then
        for i = 1, 500 do
            if (TopFit.db.profile.sets["set_"..i]) then
                setID = "set_"..i
                break
            end
        end
        if not setID then return end
    end
    
    TopFit.selectedSet = setID
    
    TopFit:UpdateStatGroups()
end

function TopFit:ExpandStatGroup(statGroup)
    statGroup.collapsed = false
    statGroup.CollapsedIcon:Hide()
    statGroup.ExpandedIcon:Show()
    TopFit:UpdateStatGroup(statGroup)
    statGroup.BgMinimized:Hide()
    statGroup.BgTop:Show()
    statGroup.BgMiddle:Show()
    statGroup.BgBottom:Show()
end

function TopFit:CollapseStatGroup(statGroup)
    statGroup.collapsed = true
    statGroup.CollapsedIcon:Show()
    statGroup.ExpandedIcon:Hide()
    local i = 1;
    while (_G[statGroup:GetName().."Stat"..i]) do 
        _G[statGroup:GetName().."Stat"..i]:Hide()
        i = i + 1;
    end
    statGroup:SetHeight(18)
    statGroup.BgMinimized:Show()
    statGroup.BgTop:Hide()
    statGroup.BgMiddle:Hide()
    statGroup.BgBottom:Hide()

    TopFit:CalculateStatFrameHeight()
end

function TopFit:UpdateStatGroups()
    local i = 1
    while (_G["TopFitSidebarStatGroup"..i]) do
        TopFit:UpdateStatGroup(_G["TopFitSidebarStatGroup"..i])
        i = i + 1
    end
end

function TopFit:UpdateStatGroup(statGroup)
    local STRIPE_COLOR = {r = 0.9, g = 0.9, b = 1}
    local subStats = TopFit.statList[statGroup.NameText:GetText()]
    local i = 1
    local totalHeight = statGroup.NameText:GetHeight() + 10
    for i = 1, #subStats do
        local statCode = subStats[i]
        local statFrame = _G[statGroup:GetName().."Stat"..i]
        
        if not statFrame then
            statFrame = CreateFrame("Button", statGroup:GetName().."Stat"..i, statGroup, "TopFitStatFrameTemplate")
            statFrame:SetPoint("TOPLEFT", _G[statGroup:GetName().."Stat"..(i - 1)], "BOTTOMLEFT", 0, 0)
            statFrame:SetPoint("TOPRIGHT", _G[statGroup:GetName().."Stat"..(i - 1)], "BOTTOMRIGHT", 0, 0)
        end
        
        --statFrame.statID = i
        --statFrame.statGroup = statGroup:GetName()
        statFrame.statCode = statCode
        _G[statGroup:GetName().."Stat"..i.."Label"]:SetText(_G[statCode]..":")
        _G[statGroup:GetName().."Stat"..i.."StatText"]:SetText(TopFit.db.profile.sets[TopFit.selectedSet].weights[statCode] or "0")
        statFrame:Show()
        
        totalHeight = totalHeight + statFrame:GetHeight()
        
        if (i % 2 == 0) then
            if (not statFrame.Bg) then
                statFrame.Bg = statFrame:CreateTexture(statFrame:GetName().."Bg", "BACKGROUND")
                statFrame.Bg:SetPoint("LEFT", statGroup, "LEFT", 1, 0)
                statFrame.Bg:SetPoint("RIGHT", statGroup, "RIGHT", 0, 0)
                statFrame.Bg:SetPoint("TOP")
                statFrame.Bg:SetPoint("BOTTOM")
                statFrame.Bg:SetTexture(STRIPE_COLOR.r, STRIPE_COLOR.g, STRIPE_COLOR.b)
                statFrame.Bg:SetAlpha(0.1)
            end
        end
    end
    statGroup:SetHeight(totalHeight)
    
    -- fix for groups with only 1 item
    if (totalHeight < 44) then
        statGroup.BgBottom:SetHeight(totalHeight - 2)
    else
        statGroup.BgBottom:SetHeight(46)
    end

    TopFit:CalculateStatFrameHeight()
end

function TopFit:CalculateStatFrameHeight()
    local totalHeight = 30
    local i = 1

    while (_G["TopFitSidebarStatGroup"..i]) do
        totalHeight = totalHeight + _G["TopFitSidebarStatGroup"..i]:GetHeight()
        i = i + 1
    end

    TopFitSidebarFrameScrollChild:SetHeight(totalHeight)
end

function TopFit:ToggleStatFrame(statFrame)
    if (statFrame:GetHeight() > 20) then
        statFrame:SetHeight(13)
        TopFitSidebarEditStatPane:Hide()
    else
        TopFit:CollapseAllStatGroups()
        TopFitSidebarEditStatPane:SetPoint("TOPLEFT", statFrame, "TOPLEFT", 0, -13)
        TopFitSidebarEditStatPane:SetPoint("TOPRIGHT", statFrame, "TOPRIGHT", 0, -13)
        TopFitSidebarEditStatPane:Show()
        TopFitSidebarEditStatPane.statCode = statFrame.statCode
        statFrame:SetHeight(13 + TopFitSidebarEditStatPane:GetHeight())

        local statInSet = TopFit:GetStatValue(TopFit.selectedSet, statFrame.statCode)
        --TopFitSidebarEditStatPaneStatValue:SetText(statInSet)
        local capInSet = TopFit:GetCapValue(TopFit.selectedSet, statFrame.statCode)
        TopFitSidebarEditStatPaneStatCap:SetText(capInSet)
        local afterCap = TopFit:GetAfterCapStatValue(TopFit.selectedSet, statFrame.statCode)
        TopFitSidebarEditStatPaneStatAfterCapValue:SetText(afterCap)
        --TopFitSidebarEditStatPaneStatValue:Raise()
    end
    
    TopFit:UpdateStatGroups()
end

function TopFit:CollapseAllStatGroups()
    local i = 1
    local statGroup = _G["TopFitSidebarStatGroup"..i]
    while (statGroup) do
        local j = 1
        local statFrame = _G[statGroup:GetName().."Stat"..j]
        while (statFrame) do
            if (statFrame:GetHeight() > 20) then
                statFrame:SetHeight(13)
            end

            j = j + 1
            statFrame = _G[statGroup:GetName().."Stat"..j]
        end

        i = i + 1
        statGroup = _G["TopFitSidebarStatGroup"..i]
    end
end
