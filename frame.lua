local minimalist = [=[Interface\AddOns\TopFit\media\minimalist]=]

-- tooltip functions for equipment buttons
local function ShowTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    if self.tipText then
        GameTooltip:SetText(self.tipText, nil, nil, nil, nil, true)
    elseif self.itemLink then
        GameTooltip:SetHyperlink(self.itemLink)
    end
    GameTooltip:Show()
end
local function HideTooltip() GameTooltip:Hide() end

function TopFit:CreateProgressFrame()
    if not TopFit.ProgressFrame then
        -- actual frame
        
        --[[--
        --              Left part of Panel
        --]]--
        
        TopFit.ProgressFrame = CreateFrame("Frame", "TopFit_ProgressFrame")
        tinsert(UISpecialFrames, "TopFit_ProgressFrame")
        TopFit.ProgressFrame:ClearAllPoints()
        TopFit.ProgressFrame:SetBackdrop(StaticPopup1:GetBackdrop())
        TopFit.ProgressFrame:SetHeight(32 * 8 + 16 + 70 + 20 * 2)
        TopFit.ProgressFrame:SetWidth(32 * 5 + 48 * 2 + 20 * 2)
        TopFit.ProgressFrame:EnableMouse(true)
        --TopFit.ProgressFrame:SetScale(GetCVar("uiScale"))
        local titleRegion = TopFit.ProgressFrame:CreateTitleRegion()
        titleRegion:SetAllPoints(TopFit.ProgressFrame)
        
        -- the most important thing: the close-button
        TopFit.ProgressFrame.closeButton = CreateFrame("Button", "TopFit_ProgressFrame_closeButton", TopFit.ProgressFrame, "UIPanelCloseButton")
        TopFit.ProgressFrame.closeButton:SetWidth(30)
        TopFit.ProgressFrame.closeButton:SetHeight(30)
        TopFit.ProgressFrame.closeButton:SetPoint("TOPRIGHT", TopFit.ProgressFrame, "TOPRIGHT")
        TopFit.ProgressFrame.closeButton:SetScript("OnClick", function(...) TopFit:HideProgressFrame() end)
        
        -- select set label
        TopFit.ProgressFrame.selectSetLabel = TopFit.ProgressFrame:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
        TopFit.ProgressFrame.selectSetLabel:SetPoint("TOPLEFT", TopFit.ProgressFrame, "TOPLEFT", 20, -30)
        --TopFit.ProgressFrame.selectSetLabel:SetPoint("TOPRIGHT", TopFit.ProgressFrame, "TOPRIGHT", -20, -20)
        TopFit.ProgressFrame.selectSetLabel:SetWidth(TopFit.ProgressFrame:GetWidth() - 40)
        TopFit.ProgressFrame.selectSetLabel:SetText("Select set to calculate:")
        TopFit.ProgressFrame.selectSetLabel:SetJustifyH("LEFT")
        
        -- abort button
        TopFit.ProgressFrame.abortButton = CreateFrame("Button", "TopFit_ProgressFrame_abortButton", TopFit.ProgressFrame, "UIPanelButtonTemplate")
        TopFit.ProgressFrame.abortButton:SetPoint("TOPRIGHT", TopFit.ProgressFrame.selectSetLabel, "BOTTOMRIGHT", 0, 0)
        TopFit.ProgressFrame.abortButton:SetText("Abort")
        TopFit.ProgressFrame.abortButton:SetHeight(22)
        TopFit.ProgressFrame.abortButton:SetWidth(80)
        TopFit.ProgressFrame.abortButton:Hide()
        
        TopFit.ProgressFrame.abortButton:SetScript("OnClick", TopFit.AbortCalculations)
        
        -- start button
        TopFit.ProgressFrame.startButton = CreateFrame("Button", "TopFit_ProgressFrame_startButton", TopFit.ProgressFrame, "UIPanelButtonTemplate")
        TopFit.ProgressFrame.startButton:SetAllPoints(TopFit.ProgressFrame.abortButton)
        TopFit.ProgressFrame.startButton:SetText("Start")
        --TopFit.ProgressFrame.startButton:Hide()
        
        TopFit.ProgressFrame.startButton:SetScript("OnClick", function(...)
            if not TopFit.isBlocked then
                if TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet] then
                    TopFit.workSetList = { TopFit.ProgressFrame.selectedSet }
                    TopFit:CalculateSets()
                end
            end
        end)
        
        -- progress bar
        TopFit.ProgressFrame.progressBar = CreateFrame("StatusBar", "TopFit_ProgressFrame_StatusBar", TopFit.ProgressFrame)
        TopFit.ProgressFrame.progressBar:SetPoint("TOPLEFT", TopFit.ProgressFrame.selectSetLabel, "BOTTOMLEFT", 2, -2)
        --TopFit.ProgressFrame.progressBar:SetPoint("BOTTOMRIGHT", TopFit.ProgressFrame.abortButton, "BOTTOMLEFT", -2, 2)
        TopFit.ProgressFrame.progressBar:SetWidth(170)
        TopFit.ProgressFrame.progressBar:SetHeight(20)
        TopFit.ProgressFrame.progressBar:SetStatusBarTexture(minimalist)
        TopFit.ProgressFrame.progressBar:SetMinMaxValues(0, 100)
        TopFit.ProgressFrame.progressBar:SetStatusBarColor(0, 1, 0, 0.8)
        TopFit.ProgressFrame.progressBar:Hide()
        
        -- progress text
        TopFit.ProgressFrame.progressText = TopFit.ProgressFrame.progressBar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        TopFit.ProgressFrame.progressText:SetAllPoints()
        TopFit.ProgressFrame.progressText:SetText("0.00%")
        
        -- set selection
        TopFit.ProgressFrame.setDropDown = CreateFrame("Frame", "TopFit_ProgressFrame_setDropDown", TopFit.ProgressFrame, "UIDropDownMenuTemplate")
        TopFit.ProgressFrame.setDropDown:SetPoint("TOPLEFT", TopFit.ProgressFrame.selectSetLabel, "BOTTOMLEFT", -20, 2)
        TopFit.ProgressFrame.setDropDown:SetWidth(150)
        UIDropDownMenu_Initialize(TopFit.ProgressFrame.setDropDown, function(self, level)
            local info = UIDropDownMenu_CreateInfo()
            for k, v in pairs(TopFit.db.profile.sets) do
                if not TopFit.ProgressFrame.selectedSet then
                    TopFit.ProgressFrame.selectedSet = k
                end
                info = UIDropDownMenu_CreateInfo()
                info.text = v.name
                info.value = k
                info.func = function(self)
                    TopFit.ProgressFrame:SetSelectedSet(self.value)
                end
                UIDropDownMenu_AddButton(info, level)
            end
        end)
        UIDropDownMenu_SetSelectedID(TopFit.ProgressFrame.setDropDown, 1)
        UIDropDownMenu_JustifyText(TopFit.ProgressFrame.setDropDown, "LEFT")
        
        -- add set button
        TopFit.ProgressFrame.addSetButton = CreateFrame("Button", "TopFit_ProgressFrame_addSetButton", TopFit.ProgressFrame)
        TopFit.ProgressFrame.addSetButton:SetPoint("LEFT", TopFit.ProgressFrame.setDropDown, "RIGHT", 0, 8)
        --TopFit.ProgressFrame.optionsButton:SetText("Options")
        TopFit.ProgressFrame.addSetButton:SetHeight(12)
        TopFit.ProgressFrame.addSetButton:SetWidth(12)
        TopFit.ProgressFrame.addSetButton:SetNormalTexture("Interface\\Icons\\Spell_chargepositive")
        TopFit.ProgressFrame.addSetButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
        
        -- set selection for add set button
        TopFit.ProgressFrame.addSetButton.setDropDown = CreateFrame("Frame", "TopFit_ProgressFrame_addSetButton_setDropDown", TopFit.ProgressFrame.addSetButton, "UIDropDownMenuTemplate")
        TopFit.ProgressFrame.addSetButton.setDropDown:SetPoint("TOPLEFT", TopFit.ProgressFrame.addSetButton, "BOTTOMLEFT", 0, 0)
        UIDropDownMenu_Initialize(TopFit.ProgressFrame.addSetButton.setDropDown, function(self, level)
            local info = UIDropDownMenu_CreateInfo()
            info.hasArrow = false; -- no submenu
            info.notCheckable = true;
            info.text = "Empty Set"
            info.value = 0
            info.func = function(self)
                TopFit:AddSet()
            end
            UIDropDownMenu_AddButton(info, level)
            
            local presets = TopFit:GetPresets()
            for k, v in pairs(presets) do
                info = UIDropDownMenu_CreateInfo()
                info.hasArrow = false; -- no submenu
                info.notCheckable = true;
                info.text = v.name
                info.value = k
                info.func = function(self)
                    TopFit:AddSet(v)
                end
                UIDropDownMenu_AddButton(info, level)
            end
        end, "MENU")
        
        TopFit.ProgressFrame.addSetButton:SetScript("OnClick", function(self)
            ToggleDropDownMenu(1, nil, TopFit.ProgressFrame.addSetButton.setDropDown, self, 0, 0)
        end)
        TopFit.ProgressFrame.addSetButton.tipText = "Add a new equipment set\n|cffffffffAftewards, you can adjust this set's weights and caps in the right frame, or force items by clicking on any equipment slots below."
        TopFit.ProgressFrame.addSetButton:SetScript("OnEnter", ShowTooltip)
        TopFit.ProgressFrame.addSetButton:SetScript("OnLeave", HideTooltip)
        
        -- delete set button
        TopFit.ProgressFrame.deleteSetButton = CreateFrame("Button", "TopFit_ProgressFrame_deleteSetButton", TopFit.ProgressFrame)
        TopFit.ProgressFrame.deleteSetButton:SetPoint("TOP", TopFit.ProgressFrame.addSetButton, "BOTTOM", 0, 0)
        --TopFit.ProgressFrame.optionsButton:SetText("Options")
        TopFit.ProgressFrame.deleteSetButton:SetHeight(12)
        TopFit.ProgressFrame.deleteSetButton:SetWidth(12)
        TopFit.ProgressFrame.deleteSetButton:SetNormalTexture("Interface\\Icons\\Spell_chargenegative")
        TopFit.ProgressFrame.deleteSetButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
        
        TopFit.ProgressFrame.deleteSetButton:SetScript("OnClick", function(...)
            -- on first click: mark red
            if not TopFit.ProgressFrame.deleteSetButton.firstClick then
                if not TopFit.ProgressFrame.deleteSetButton.redHightlight then
                    TopFit.ProgressFrame.deleteSetButton.redHightlight = TopFit.ProgressFrame.deleteSetButton:CreateTexture("$parent_higlightTexture")
                    TopFit.ProgressFrame.deleteSetButton.redHightlight:SetTexture("Interface\\Buttons\\CheckButtonHilight")
                    TopFit.ProgressFrame.deleteSetButton.redHightlight:SetAllPoints()
                    TopFit.ProgressFrame.deleteSetButton.redHightlight:SetBlendMode("ADD")
                    TopFit.ProgressFrame.deleteSetButton.redHightlight:SetDrawLayer("OVERLAY")
                    TopFit.ProgressFrame.deleteSetButton.redHightlight:SetVertexColor(1, 0, 0, 1)
                end
                TopFit.ProgressFrame.deleteSetButton.redHightlight:Show();
                TopFit.ProgressFrame.deleteSetButton.firstClick = true
            else
            -- on second click: delete set
                TopFit:DeleteSet(TopFit.ProgressFrame.selectedSet)
                TopFit.ProgressFrame.deleteSetButton.redHightlight:Hide();
                TopFit.ProgressFrame.deleteSetButton.firstClick = false
            end
        end)
        TopFit.ProgressFrame.deleteSetButton.tipText = "Delete the selected set\n|cffffffffYou will have to click this button a second time to confirm the deletion.\n\n|cffff0000WARNING|cffffffff: The associated set in the equipment manager will also be deleted! If you want to keep it, create a copy in Blizzard's equipment manager first!"
        TopFit.ProgressFrame.deleteSetButton:SetScript("OnEnter", ShowTooltip)
        TopFit.ProgressFrame.deleteSetButton:SetScript("OnLeave", function() HideTooltip() if TopFit.ProgressFrame.deleteSetButton.redHightlight then TopFit.ProgressFrame.deleteSetButton.redHightlight:Hide(); TopFit.ProgressFrame.deleteSetButton.firstClick = false end end)
        
        -- expand / contract button
        TopFit.ProgressFrame.expandButton = CreateFrame("Button", "TopFit_ProgressFrame_expandButton", TopFit.ProgressFrame, "UIPanelButtonTemplate")
        TopFit.ProgressFrame.expandButton:SetPoint("TOPRIGHT", TopFit.ProgressFrame.selectSetLabel, "BOTTOMRIGHT", 0, 30)
        TopFit.ProgressFrame.expandButton:SetText(">>")
        TopFit.ProgressFrame.expandButton:SetHeight(22)
        TopFit.ProgressFrame.expandButton:SetWidth(80)
        
        TopFit.ProgressFrame.expandButton:SetScript("OnClick", function(...)
            if TopFit.ProgressFrame.isExpanded then
                TopFit.ProgressFrame.expandButton:SetText(">>")
                TopFit.ProgressFrame.isExpanded = false
                TopFit.ProgressFrame.rightFrame:Hide()
                TopFit.ProgressFrame:SetWidth(TopFit.ProgressFrame:GetWidth() / 2)
            else
                TopFit.ProgressFrame.expandButton:SetText("<<")
                TopFit.ProgressFrame.isExpanded = true
                TopFit.ProgressFrame.rightFrame:Show()
                TopFit.ProgressFrame:SetWidth(TopFit.ProgressFrame:GetWidth() * 2)
            end
        end)
        
        -- equipment buttons
        TopFit.ProgressFrame.equipButtons = {}
        for slotID, _ in pairs(TopFit.slotNames) do
            TopFit.ProgressFrame.equipButtons[slotID] = CreateFrame("Button", "TopFit_ProgressFrame_slot"..slotID.."Button", TopFit.ProgressFrame)
            TopFit.ProgressFrame.equipButtons[slotID]:SetHeight(32)
            TopFit.ProgressFrame.equipButtons[slotID]:SetWidth(32)
            TopFit.ProgressFrame.equipButtons[slotID]:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
            
            -- create extra highlight texture for marking purposes
            TopFit.ProgressFrame.equipButtons[slotID].highlightTexture = TopFit.ProgressFrame.equipButtons[slotID]:CreateTexture("$parent_higlightTexture")
            TopFit.ProgressFrame.equipButtons[slotID].highlightTexture:SetTexture("Interface\\Buttons\\CheckButtonHilight")
            TopFit.ProgressFrame.equipButtons[slotID].highlightTexture:SetAllPoints()
            TopFit.ProgressFrame.equipButtons[slotID].highlightTexture:SetBlendMode("ADD")
            TopFit.ProgressFrame.equipButtons[slotID].highlightTexture:SetDrawLayer("OVERLAY")
            TopFit.ProgressFrame.equipButtons[slotID].highlightTexture:SetVertexColor(1, 1, 1, 0)
        end
        -- anchor them all like in the equipment window
        TopFit.ProgressFrame.equipButtons[1]:SetPoint("LEFT", TopFit.ProgressFrame.selectSetLabel, "LEFT")
        TopFit.ProgressFrame.equipButtons[1]:SetPoint("TOP", TopFit.ProgressFrame.abortButton, "BOTTOM", 0, -15)
        TopFit.ProgressFrame.equipButtons[2]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[1], "BOTTOMLEFT")
        TopFit.ProgressFrame.equipButtons[3]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[2], "BOTTOMLEFT")
        TopFit.ProgressFrame.equipButtons[15]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[3], "BOTTOMLEFT")
        TopFit.ProgressFrame.equipButtons[5]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[15], "BOTTOMLEFT")
        TopFit.ProgressFrame.equipButtons[4]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[5], "BOTTOMLEFT")
        TopFit.ProgressFrame.equipButtons[19]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[4], "BOTTOMLEFT")
        TopFit.ProgressFrame.equipButtons[9]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[19], "BOTTOMLEFT")
        
        TopFit.ProgressFrame.equipButtons[16]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[9], "BOTTOMRIGHT", 48, 16)
        TopFit.ProgressFrame.equipButtons[17]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[16], "TOPRIGHT")
        TopFit.ProgressFrame.equipButtons[18]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[17], "TOPRIGHT")
        
        TopFit.ProgressFrame.equipButtons[14]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[18], "TOPRIGHT", 48, -16)
        TopFit.ProgressFrame.equipButtons[13]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[14], "TOPLEFT")
        TopFit.ProgressFrame.equipButtons[12]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[13], "TOPLEFT")
        TopFit.ProgressFrame.equipButtons[11]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[12], "TOPLEFT")
        TopFit.ProgressFrame.equipButtons[8]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[11], "TOPLEFT")
        TopFit.ProgressFrame.equipButtons[7]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[8], "TOPLEFT")
        TopFit.ProgressFrame.equipButtons[6]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[7], "TOPLEFT")
        TopFit.ProgressFrame.equipButtons[10]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[6], "TOPLEFT")
        
        -- set their default (empty) textures
        TopFit.ProgressFrame.equipButtons[1].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Head"
        TopFit.ProgressFrame.equipButtons[2].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Neck"
        TopFit.ProgressFrame.equipButtons[3].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Shoulder"
        TopFit.ProgressFrame.equipButtons[15].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Chest"
        TopFit.ProgressFrame.equipButtons[5].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Chest"
        TopFit.ProgressFrame.equipButtons[4].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Shirt"
        TopFit.ProgressFrame.equipButtons[19].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Tabard"
        TopFit.ProgressFrame.equipButtons[9].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Wrists"
        TopFit.ProgressFrame.equipButtons[16].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-MainHand"
        TopFit.ProgressFrame.equipButtons[17].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-SecondaryHand"
        TopFit.ProgressFrame.equipButtons[18].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Ranged"
        TopFit.ProgressFrame.equipButtons[14].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Trinket"
        TopFit.ProgressFrame.equipButtons[13].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Trinket"
        TopFit.ProgressFrame.equipButtons[12].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-RFinger"
        TopFit.ProgressFrame.equipButtons[11].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-RFinger"
        TopFit.ProgressFrame.equipButtons[8].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Feet"
        TopFit.ProgressFrame.equipButtons[7].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Legs"
        TopFit.ProgressFrame.equipButtons[6].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Waist"
        TopFit.ProgressFrame.equipButtons[10].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Hands"
        for slotID, button in pairs(TopFit.ProgressFrame.equipButtons) do
            button:SetNormalTexture(button.emptyTexture)
            -- also set tooltip functions
            button.slotID = slotID
            button:SetScript("OnEnter", ShowTooltip)
            button:SetScript("OnLeave", function (...)
                HideTooltip()
                if TopFit.ProgressFrame.forceItemsFrame then
                    if not TopFit.ProgressFrame.forceItemsFrame:IsMouseOver() then
                        TopFit.ProgressFrame.forceItemsFrame:Hide()
                    end
                end
            end)
            button:SetScript("OnClick", function (self, ...)
                if not TopFit.isBlocked then
                    TopFit:collectItems()
                    if not TopFit.ProgressFrame.forceItemsFrame then
                        -- creat frame for forced items
                        TopFit.ProgressFrame.forceItemsFrame = CreateFrame("Frame", "TopFit_ProgressFrame_forceItemsFrame", UIParent)
                        --TopFit.ProgressFrame.forceItemsFrame:SetBackdrop(StaticPopup1:GetBackdrop())
                        TopFit.ProgressFrame.forceItemsFrame:SetBackdrop({
                            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
                            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                            tile = true,
                            tileSize = 16,
                            edgeSize = 16,
                            -- distance from the edges of the frame to those of the background texture (in pixels)
                            insets = {
                                left = 4,
                                right = 4,
                                top = 4,
                                bottom = 4
                            }
                        })
                        TopFit.ProgressFrame.forceItemsFrame:SetBackdropColor(0, 0, 0)
                        TopFit.ProgressFrame.forceItemsFrame:SetWidth(300)
                        TopFit.ProgressFrame.forceItemsFrame:EnableMouse(true)
                        TopFit.ProgressFrame.forceItemsFrame:SetScript("OnLeave", function (self, ...)
                            if not self:IsMouseOver() then
                                self:Hide()
                            end
                        end)
                        
                        -- label
                        TopFit.ProgressFrame.forceItemsFrame.slotLabel = TopFit.ProgressFrame.forceItemsFrame:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
                        TopFit.ProgressFrame.forceItemsFrame.slotLabel:SetPoint("TOPLEFT", TopFit.ProgressFrame.forceItemsFrame, "TOPLEFT", 10, -10)
                        
                        TopFit.ProgressFrame.forceItemsFrame.itemButtons = {}
                        --TopFit.ProgressFrame.forceItemsFrame.itemLabels = {}
                    end
                    TopFit.ProgressFrame.forceItemsFrame.slotLabel:SetText("Force Item for "..TopFit.slotNames[self.slotID]..":")
                    
                    local itemButtons = TopFit.ProgressFrame.forceItemsFrame.itemButtons
                    -- create "Force none" button
                    if not itemButtons[1] then
                        itemButtons[1] = CreateFrame("Button", "TopFit_ProgressFrame_forceItemsFrame_itemButton1", TopFit.ProgressFrame.forceItemsFrame)
                        itemButtons[1]:SetWidth(280)
                        itemButtons[1]:SetHeight(24)
                        itemButtons[1]:SetHighlightTexture("Interface\\Buttons\\UI-ListBox-Highlight")
                        itemButtons[1]:SetPoint("TOPLEFT", TopFit.ProgressFrame.forceItemsFrame.slotLabel, "BOTTOMLEFT", 0, -5)
                        
                        itemButtons[1].itemTexture = itemButtons[1]:CreateTexture()
                        itemButtons[1].itemTexture:SetWidth(24)
                        itemButtons[1].itemTexture:SetHeight(24)
                        itemButtons[1].itemTexture:SetPoint("TOPLEFT")
                        
                        itemButtons[1].itemLabel = itemButtons[1]:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
                        itemButtons[1].itemLabel:SetPoint("LEFT", itemButtons[1].itemTexture, "RIGHT", 3)
                        
                        itemButtons[1].itemLabel:SetText("Do not force")
                        itemButtons[1].itemTexture:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
                        
                        itemButtons[1]:SetScript("OnClick", function(self)
                            TopFit:Debug("Cleared forced item for slot "..self.slotID)
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].forced[self.slotID] = nil
                            TopFit.ProgressFrame.equipButtons[self.slotID].highlightTexture:SetVertexColor(1, 1, 1, 0)
                            TopFit.ProgressFrame.forceItemsFrame:Hide()
                        end)
                    end
                    itemButtons[1].slotID = self.slotID
                    
                    -- create buttons for all items
                    TopFit:collectItems()
                    local i = 2
                    local maxWidth = 200
                    if TopFit.itemListBySlot[self.slotID] then
                        for _, itemTable in pairs(TopFit.itemListBySlot[self.slotID]) do
                            if not itemButtons[i] then
                                itemButtons[i] = CreateFrame("Button", "TopFit_ProgressFrame_forceItemsFrame_itemButton"..i, TopFit.ProgressFrame.forceItemsFrame)
                                itemButtons[i]:SetWidth(280)
                                itemButtons[i]:SetHeight(24)
                                itemButtons[i]:SetHighlightTexture("Interface\\Buttons\\UI-ListBox-Highlight")
                                itemButtons[i]:SetPoint("TOPLEFT", itemButtons[i - 1], "BOTTOMLEFT")
                                
                                itemButtons[i].itemTexture = itemButtons[i]:CreateTexture()
                                itemButtons[i].itemTexture:SetWidth(24)
                                itemButtons[i].itemTexture:SetHeight(24)
                                itemButtons[i].itemTexture:SetPoint("TOPLEFT")
                                
                                itemButtons[i].itemLabel = itemButtons[i]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
                                itemButtons[i].itemLabel:SetPoint("LEFT", itemButtons[i].itemTexture, "RIGHT", 3)
                                
                                -- script handlers
                                itemButtons[i]:SetScript("OnClick", function(self)
                                    TopFit:Debug("Forced item "..select(2, GetItemInfo(self.itemID)).." for slot "..self.slotID)
                                    TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].forced[self.slotID] = self.itemID
                                    TopFit.ProgressFrame.equipButtons[self.slotID].highlightTexture:SetVertexColor(1, 0, 0, 1)
                                    TopFit.ProgressFrame.forceItemsFrame:Hide()
                                end)
                            end
                            
                            itemButtons[i].itemID = itemTable.itemID
                            itemButtons[i].slotID = self.slotID
                            itemButtons[i]:Show()
                            itemButtons[i].itemLabel:SetText(itemTable.itemLink)
                            
                            if itemButtons[i].itemLabel:GetWidth() > maxWidth then
                                maxWidth = itemButtons[i].itemLabel:GetWidth()
                            end
                            
                            local tex = select(10, GetItemInfo(itemTable.itemID))
                            if not tex then tex = "Interface\\Icons\\Inv_misc_questionmark" end
                            itemButtons[i].itemTexture:SetTexture(tex)
                            
                            i = i + 1
                        end
                    end
                    
                    TopFit.ProgressFrame.forceItemsFrame:SetHeight(25 + (i - 1) * 24 + TopFit.ProgressFrame.forceItemsFrame.slotLabel:GetHeight())
                    TopFit.ProgressFrame.forceItemsFrame:SetWidth(maxWidth + 24 + 20)
                    for j = 1, i - 1 do
                        itemButtons[j]:SetWidth(maxWidth + 24)
                    end
                    
                    -- hide unused buttons
                    for i = i, #itemButtons do
                        itemButtons[i]:Hide()
                    end
                    
                    TopFit.ProgressFrame.forceItemsFrame:Show()
                    TopFit.ProgressFrame.forceItemsFrame:ClearAllPoints()
                    TopFit.ProgressFrame.forceItemsFrame:SetParent(self) -- so "OnLeave" will fire when the mouse leaves this frame or the button
                    --[[if self.slotID < 6 or self.slotID == 9 or self.slotID == 15 or self.slotID == 19 then -- left buttons
                    elseif  self.slotID < 19 and self.slotID > 15 then -- bottom buttons
                    else
                    end]]--
                    TopFit.ProgressFrame.forceItemsFrame:SetPoint("RIGHT", self, "RIGHT")
                end
            end)
        end
        
        function TopFit.ProgressFrame:ResetProgress()
            TopFit.ProgressFrame.progress = nil
            TopFit.ProgressFrame.startButton:Hide()
            TopFit.ProgressFrame.setDropDown:Hide()
            TopFit.ProgressFrame.abortButton:Show()
            TopFit.ProgressFrame.progressBar:Show()
        end
        function TopFit.ProgressFrame:StoppedCalculation()
            TopFit.ProgressFrame.startButton:Show()
            TopFit.ProgressFrame.setDropDown:Show()
            TopFit.ProgressFrame.abortButton:Hide()
            TopFit.ProgressFrame.progressBar:Hide()
        end
        function TopFit.ProgressFrame:SetProgress(progress)
            if (TopFit.ProgressFrame.progress == nil) or (TopFit.ProgressFrame.progress < progress) then
                TopFit.ProgressFrame.progress = progress
                TopFit.ProgressFrame.progressText:SetText(round(progress * 100, 2).."%")
                TopFit.ProgressFrame.progressBar:SetValue(progress * 100)
            end
        end
        
        -- centered scrollframe for stats summary
        local boxHeight = 32 * 8 - 16
        local boxWidth = 32 * 3 + 48 * 2 - 22
	TopFit.ProgressFrame.statScrollFrame = CreateFrame("ScrollFrame", "TopFit_StatScrollFrame", TopFit.ProgressFrame, "UIPanelScrollFrameTemplate")
	TopFit.ProgressFrame.statScrollFrame:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[1], "TOPRIGHT")
	TopFit.ProgressFrame.statScrollFrame:SetHeight(boxHeight)
	TopFit.ProgressFrame.statScrollFrame:SetWidth(boxWidth)
	local group2 = CreateFrame("Frame", nil, TopFit.ProgressFrame.statScrollFrame)
	group2:SetAllPoints()
	group2:SetHeight(boxHeight)
	group2:SetWidth(boxWidth)
	TopFit.ProgressFrame.statScrollFrame:SetScrollChild(group2)
	
	local backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            tile = true,
            tileSize = 32,
            insets = { left = 0, right = -22, top = 0, bottom = 0 }}
	TopFit.ProgressFrame.statScrollFrame:SetBackdrop(backdrop)
	TopFit.ProgressFrame.statScrollFrame:SetBackdropBorderColor(0.4, 0.4, 0.4)
	TopFit.ProgressFrame.statScrollFrame:SetBackdropColor(0.1, 0.1, 0.1)
        
        -- fontstrings for set name
        TopFit.ProgressFrame.setNameFontString = group2:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
        TopFit.ProgressFrame.setNameFontString:SetHeight(32)
        TopFit.ProgressFrame.setNameFontString:SetPoint("TOP", TopFit.ProgressFrame.statScrollFrame, "TOP")
        TopFit.ProgressFrame.setNameFontString:SetText("Set Name")
        
        -- fontsting for set value
        TopFit.ProgressFrame.setScoreFontString = group2:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        TopFit.ProgressFrame.setScoreFontString:SetHeight(32)
        TopFit.ProgressFrame.setScoreFontString:SetPoint("TOP", TopFit.ProgressFrame.setNameFontString, "BOTTOM")
        TopFit.ProgressFrame.setScoreFontString:SetText("Total Score: -")
        
        -- List of Score contributing Texts and Bars
        TopFit.ProgressFrame.statNameFontStrings = {}
        TopFit.ProgressFrame.statValueFontStrings = {}
        TopFit.ProgressFrame.statValueStatusBars = {}
        
        -- function for changing set name
        function TopFit.ProgressFrame:SetSelectedSet(setCode)
            if not setCode then
                -- select the first set
                local i = 1
                if TopFit.db.profile.sets and TopFit.db.profile.sets ~= {} then
                    while not TopFit.db.profile.sets["set_"..i] do i = i + 1 end
                    setCode = "set_"..i
                end
            end
            
            TopFit.ProgressFrame.selectedSet = setCode
            UIDropDownMenu_SetSelectedValue(TopFit.ProgressFrame.setDropDown, setCode)
            UIDropDownMenu_SetText(TopFit.ProgressFrame.setDropDown, TopFit.db.profile.sets[setCode].name)
            TopFit.ProgressFrame:SetSetName(TopFit.db.profile.sets[setCode].name)
            
            TopFit.ProgressFrame:UpdateSetStats()
            
            -- generate pseudo equipment set to display when selecting a set
            local items = GetEquipmentSetItemIDs(TopFit:GenerateSetName(TopFit.db.profile.sets[setCode].name))
            local combination = {
                items = {},
                totalStats = {},
                totalScore = 0,
            }
            if items then
                for slotID, itemID in pairs(items) do
                    if itemID and itemID ~= 1 then
                        itemTable = TopFit:GetItemInfoTable(itemID, nil, nil, nil)
                        TopFit:CalculateItemTableScore(itemTable, TopFit.db.profile.sets[setCode].weights, TopFit.db.profile.sets[setCode].caps)
                        combination.items[slotID] = itemTable
                        
                        -- add to total stats and score
                        for statName, statValue in pairs(itemTable.totalBonus) do
                            combination.totalStats[statName] = (combination.totalStats[statName] or 0) + statValue
                        end
                        combination.totalScore = combination.totalScore + itemTable.itemScore
                    end
                end
            end
            
            TopFit.ProgressFrame:SetCurrentCombination(combination)
        end
        
        function TopFit.ProgressFrame:SetSetName(text)
            TopFit.ProgressFrame.setNameFontString:SetText(text)
        end
        
        -- function for showing current calculated set
        function TopFit.ProgressFrame:SetCurrentCombination(combination)
            -- reset to default icon
            for _, button in pairs(TopFit.ProgressFrame.equipButtons) do
                button:SetNormalTexture(button.emptyTexture)
                button.itemLink = nil
            end
            for slotID, itemTable in pairs(combination.items) do
                -- set to item icon
                _, _, _, _, _, _, _, _, _, texture, _ = GetItemInfo(itemTable.itemID)
                TopFit.ProgressFrame.equipButtons[slotID]:SetNormalTexture(texture)
                TopFit.ProgressFrame.equipButtons[slotID].itemLink = itemTable.itemLink
                
                -- set highlight if forced item
                if TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].forced[slotID] then
                    TopFit.ProgressFrame.equipButtons[slotID].highlightTexture:SetVertexColor(1, 0, 0, 1)
                else
                    TopFit.ProgressFrame.equipButtons[slotID].highlightTexture:SetVertexColor(1, 1, 1, 0)
                end
            end
            
            TopFit.ProgressFrame.setScoreFontString:SetText("Total Score: "..round(combination.totalScore, 2))
            
            -- sort stats by score contribution
            statList = {}
            scorePerStat = {}
            for key, _ in pairs(combination.totalStats) do
                tinsert(statList, key)
            end
            table.sort(statList, function(a, b)
                local set = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights
                local caps = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps
                
                local score1, score2 = 0, 0
                if set[a] and ((not caps) or (not caps[a]) or (not caps[a]["active"]) or (caps[a]["soft"])) then
                    score1 = combination.totalStats[a] * set[a]
                end
                if set[b] and ((not caps) or (not caps[b]) or (not caps[b]["active"]) or (caps[b]["soft"])) then
                    score2 = combination.totalStats[b] * set[b]
                end
                
                scorePerStat[a] = score1
                scorePerStat[b] = score2
                
                return score1 > score2
            end)
            
            local statTexts = TopFit.ProgressFrame.statNameFontStrings
            local valueTexts = TopFit.ProgressFrame.statValueFontStrings
            local statusBars = TopFit.ProgressFrame.statValueStatusBars
            local lastStat = 0
            local maxStatValue = scorePerStat[statList[1]]
            for i = 1, #statList do
                if (scorePerStat[statList[i]] ~= nil) and (scorePerStat[statList[i]] > 0) then
                    lastStat = i
                    if not statTexts[i] then
                        -- create FontStrings
                        -- fontsting for stat name
                        statusBars[i] = CreateFrame("StatusBar", "TopFit_ProgressFrame_statValueBar"..i, group2)
                        statTexts[i] = statusBars[i]:CreateFontString(nil, "ARTWORK", "GameFontHighlightExtraSmall")
                        valueTexts[i] = statusBars[i]:CreateFontString(nil, "ARTWORK", "GameFontHighlightExtraSmall")
                        statTexts[i]:SetTextHeight(11)
                        valueTexts[i]:SetTextHeight(11)
                        --statTexts[i]:SetHeight(32)
                        if i == 1 then
                            statTexts[i]:SetPoint("TOP", TopFit.ProgressFrame.setScoreFontString, "BOTTOM", 0, -10)
                            valueTexts[i]:SetPoint("TOP", TopFit.ProgressFrame.setScoreFontString, "BOTTOM", 0, -10)
                            statTexts[i]:SetPoint("LEFT", group2, "LEFT", 3, 0)
                            valueTexts[i]:SetPoint("RIGHT", group2, "RIGHT", -3, 0)
                        else
                            statTexts[i]:SetPoint("TOPLEFT", statTexts[i - 1], "BOTTOMLEFT")
                            valueTexts[i]:SetPoint("TOPRIGHT", valueTexts[i - 1], "BOTTOMRIGHT")
                        end
                        statusBars[i]:SetPoint("TOPLEFT", statTexts[i], "TOPLEFT")
                        statusBars[i]:SetPoint("BOTTOMRIGHT", valueTexts[i], "BOTTOMRIGHT", 0, 1)
                        statusBars[i]:SetStatusBarTexture(minimalist)
                    end
                    statTexts[i]:Show()
                    valueTexts[i]:Show()
                    statusBars[i]:Show()
                    statTexts[i]:SetText(_G[statList[i]])
                    valueTexts[i]:SetText(round(combination.totalStats[statList[i]], 1))
                    statusBars[i]:SetMinMaxValues(0, maxStatValue)
                    statusBars[i]:SetValue(scorePerStat[statList[i]])
                    statusBars[i]:SetStatusBarColor(0.3, 1, 0.5, 0.5)
                    --TopFit:Debug(_G[statList[i]]..": "..combination.totalStats[statList[i]].." ("..scorePerStat[statList[i]]..")")
                end
            end
            for i = lastStat + 1, #statTexts do
                statTexts[i]:Hide()
                valueTexts[i]:Hide()
                statusBars[i]:Hide()
            end
        end
        
        --[[--
        --              Right part of Panel
        --]]--
        
        -- stuff for second half of the frame goes here!
        TopFit.ProgressFrame.isExpanded = false
        
        TopFit.ProgressFrame.rightFrame = CreateFrame("Frame", "TopFit_ProgressFrame_rightFrame", TopFit.ProgressFrame)
        TopFit.ProgressFrame.rightFrame:SetPoint("TOPRIGHT")
        TopFit.ProgressFrame.rightFrame:SetPoint("BOTTOMRIGHT")
        TopFit.ProgressFrame.rightFrame:SetWidth(TopFit.ProgressFrame:GetWidth())
        TopFit.ProgressFrame.rightFrame:Hide()
        
        -- options button
        TopFit.ProgressFrame.optionsButton = CreateFrame("Button", "TopFit_ProgressFrame_optionsButton", TopFit.ProgressFrame.rightFrame)
        TopFit.ProgressFrame.optionsButton:SetPoint("TOPRIGHT", TopFit.ProgressFrame.rightFrame, "TOPRIGHT", -30, -20)
        --TopFit.ProgressFrame.optionsButton:SetText("Options")
        TopFit.ProgressFrame.optionsButton:SetHeight(32)
        TopFit.ProgressFrame.optionsButton:SetWidth(32)
        TopFit.ProgressFrame.optionsButton:SetNormalTexture("Interface\\Icons\\INV_Misc_Gear_02")
        TopFit.ProgressFrame.optionsButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
        
        TopFit.ProgressFrame.optionsButton:SetScript("OnClick", function(...)
            InterfaceOptionsFrame_OpenToCategory(TopFit.optionsFrame)
        end)
        TopFit.ProgressFrame.optionsButton.tipText = "Open TopFit's options"
        TopFit.ProgressFrame.optionsButton:SetScript("OnEnter", ShowTooltip)
        TopFit.ProgressFrame.optionsButton:SetScript("OnLeave", HideTooltip)
        
        TopFit.ProgressFrame.statDropDown = CreateFrame("Frame", "TopFit_ProgressFrame_statDropDown", TopFit.ProgressFrame.rightFrame, "UIDropDownMenuTemplate")
        --TopFit.ProgressFrame.statDropDown:SetPoint("TOPLEFT", TopFit.ProgressFrame.rightFrame, "TOPLEFT", 20, -20)
        UIDropDownMenu_Initialize(TopFit.ProgressFrame.statDropDown, function(self, level)
            level = level or 1
            local info = UIDropDownMenu_CreateInfo()
            if (level == 1) then
                local info = UIDropDownMenu_CreateInfo();
                info.hasArrow = false; -- no submenu
                info.notCheckable = true;
                info.text = "Add stat...";
                info.isTitle = true;
                UIDropDownMenu_AddButton(info, level);
                
                for categoryName, statTable in pairs(TopFit.statList) do
                    local info = UIDropDownMenu_CreateInfo();
                    info.hasArrow = true;
                    info.notCheckable = true;
                    info.text = categoryName;
                    info.isTitle = false;
                    info.value = categoryName
                    UIDropDownMenu_AddButton(info, level);
                end
            elseif level == 2 then
                local parentValue = UIDROPDOWNMENU_MENU_VALUE
                
                for key, value in pairs(TopFit.statList[parentValue]) do
                    local info = UIDropDownMenu_CreateInfo();
                    info.hasArrow = false;
                    info.notCheckable = true;
                    info.text = _G[value];
                    info.isTitle = false;
                    info.isChecked = false;
                    info.value = value
                    info.func = function(...)
                        TopFit:Debug("Adding stat: "..value)
                        TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights[value] = 0
                        TopFit.ProgressFrame:UpdateSetStats()
                    end
                    UIDropDownMenu_AddButton(info, level);
                end
            end
        end, "MENU")
        UIDropDownMenu_JustifyText(TopFit.ProgressFrame.statDropDown, "LEFT")
        
        TopFit.ProgressFrame.addStatButton = CreateFrame("Button", "TopFit_ProgressFrame_expandButton", TopFit.ProgressFrame.rightFrame, "UIPanelButtonTemplate")
        TopFit.ProgressFrame.addStatButton:SetPoint("TOPLEFT", TopFit.ProgressFrame.rightFrame, "TOPLEFT", 20, -60)
        TopFit.ProgressFrame.addStatButton:SetText("Add stat...")
        TopFit.ProgressFrame.addStatButton:SetHeight(22)
        TopFit.ProgressFrame.addStatButton:SetWidth(80)
        
        TopFit.ProgressFrame.addStatButton:SetScript("OnClick", function(self, button)
            ToggleDropDownMenu(1, nil, TopFit.ProgressFrame.statDropDown, self, -20, 0)
        end)
        
        TopFit.ProgressFrame.editStatScrollFrame = CreateFrame("ScrollFrame", "TopFit_StatScrollFrame", TopFit.ProgressFrame.rightFrame, "UIPanelScrollFrameTemplate")
        TopFit.ProgressFrame.editStatScrollFrame:SetPoint("TOPLEFT", TopFit.ProgressFrame.addStatButton, "BOTTOMLEFT", 0, -25)
        TopFit.ProgressFrame.editStatScrollFrame:SetPoint("BOTTOMRIGHT", TopFit.ProgressFrame, "BOTTOMRIGHT", -40, 20)
        TopFit.ProgressFrame.editStatScrollFrame:SetHeight(boxHeight)
        TopFit.ProgressFrame.editStatScrollFrame:SetWidth(boxWidth)
        local group3 = CreateFrame("Frame", nil, TopFit.ProgressFrame.editStatScrollFrame)
        group3:SetAllPoints()
        group3:SetHeight(boxHeight)
        group3:SetWidth(235)
        TopFit.ProgressFrame.editStatScrollFrame:SetScrollChild(group3)
        TopFit.ProgressFrame.editStatScrollFrame:SetBackdrop(backdrop)
        TopFit.ProgressFrame.editStatScrollFrame:SetBackdropBorderColor(0.4, 0.4, 0.4)
        TopFit.ProgressFrame.editStatScrollFrame:SetBackdropColor(0.1, 0.1, 0.1)
        
        TopFit.ProgressFrame.rightFrame.menuHeaders = {}
        TopFit.ProgressFrame.rightFrame.statCapCheckboxes = {}
        TopFit.ProgressFrame.editStatNameTexts = {}
        TopFit.ProgressFrame.editStatValueTexts = {}
        TopFit.ProgressFrame.editStatButtons = {}
        
        function TopFit.ProgressFrame:CreateHeaderButton(parent, name)
            local butt = CreateFrame("Button", name, parent)
            butt:SetWidth(80) butt:SetHeight(18)

            -- Fonts --
            butt:SetHighlightFontObject(GameFontHighlightSmall)
            butt:SetNormalFontObject(GameFontNormalSmall)

            -- Textures --
            --butt:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
            --butt:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
            butt:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")
            butt:GetHighlightTexture():SetBlendMode("ADD")
            
            local left = butt:CreateTexture("$parentLeft")
            left:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
            left:SetTexCoord(0, 0.078125, 0, 0.59375)
            left:SetPoint("BOTTOMLEFT")
            left:SetWidth(5)
            left:SetHeight(butt:GetHeight())
            
            local right = butt:CreateTexture("$parentRight")
            right:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
            right:SetTexCoord(0.90625, 0.96875, 0, 0.59375)
            right:SetPoint("BOTTOMRIGHT")
            right:SetWidth(5)
            right:SetHeight(butt:GetHeight())
            
            local center = butt:CreateTexture("$parentCenter")
            center:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
            center:SetTexCoord(0.078125, 0.90625, 0, 0.59375)
            center:SetPoint("LEFT", "$parentLeft", "RIGHT")
            center:SetPoint("RIGHT", "$parentRight", "LEFT")
            center:SetWidth(5)
            center:SetHeight(butt:GetHeight())

            -- Tooltip bits
            butt:SetScript("OnEnter", ShowTooltip)
            butt:SetScript("OnLeave", HideTooltip)

            return butt
        end
        
        function TopFit.ProgressFrame:UpdateSetStats()
            local menuHeaders = TopFit.ProgressFrame.rightFrame.menuHeaders
            local statTexts = TopFit.ProgressFrame.editStatNameTexts
            local valueTexts = TopFit.ProgressFrame.editStatValueTexts
            local capBox = TopFit.ProgressFrame.rightFrame.statCapCheckboxes
            local statButtons = TopFit.ProgressFrame.editStatButtons
            
            local sortableStatWeightTable = {}
            for stat, value in pairs(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights) do
                table.insert(sortableStatWeightTable, {stat, value})
            end
            
            table.sort(sortableStatWeightTable, function(a,b)
                local order = TopFit.db.profile.statSortOrder
                
                if order == "NameAsc" then
                    return _G[a[1]] < _G[b[1]]
                elseif order == "NameDesc" then
                    return _G[a[1]] > _G[b[1]]
                    
                elseif order == "ValueAsc" then
                    return a[2] < b[2]
                elseif order == "ValueDesc" then
                    return a[2] > b[2]
                    
                elseif order == "CapAsc" then
                    -- capped stats first, then ordered by name
                    local a_capped = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[a[1]]
                    local b_capped = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[b[1]]
                    if (a_capped and a_capped.active) and (b_capped and b_capped.active) then
                        return _G[a[1]] < _G[b[1]]
                    elseif a_capped and a_capped.active then
                        return true
                    elseif b_capped and b_capped.active then
                        return false
                    else
                        return _G[a[1]] < _G[b[1]]
                    end
                elseif order == "CapDesc" then
                    -- capped stats last, then ordered by name
                    local a_capped = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[a[1]]
                    local b_capped = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[b[1]]
                    if (a_capped and a_capped.active) and (b_capped and b_capped.active) then
                        return _G[a[1]] < _G[b[1]]
                    elseif a_capped and a_capped.active then
                        return false
                    elseif b_capped and b_capped.active then
                        return true
                    else
                        return _G[a[1]] < _G[b[1]]
                    end
                else
                    return a[1] < b[1]
                end
            end)
            
            -- headers
            local headerTitles = {{"Name", 180}, {"Value", 40}, {"Cap", 20}}
            if not menuHeaders[1] then
                local prefix = "TopFit_ProgressFrame_MenuHeader_"
                for i = 1, #headerTitles do
                    menuHeaders[i] = TopFit.ProgressFrame:CreateHeaderButton(TopFit.ProgressFrame.rightFrame, prefix .. headerTitles[i][1])
                    if i == 1 then
                        menuHeaders[i]:SetPoint("BOTTOMLEFT", group3, "TOPLEFT")
                    else
                        menuHeaders[i]:SetPoint("TOPLEFT", menuHeaders[i-1], "TOPRIGHT")
                    end
                    menuHeaders[i]:SetText(headerTitles[i][1])
                    menuHeaders[i].tiptext = headerTitles[i][1]
                    menuHeaders[i]:SetWidth(headerTitles[i][2])
                    menuHeaders[i]:SetScript("OnClick", function(self)
                        if TopFit.db.profile.statSortOrder == headerTitles[i][1].."Asc" then
                            TopFit.db.profile.statSortOrder = headerTitles[i][1].."Desc"
                        else
                            TopFit.db.profile.statSortOrder = headerTitles[i][1].."Asc"
                        end
                        
                        TopFit.ProgressFrame:UpdateSetStats()
                    end)
                    menuHeaders[i]:Show()
                end
            end
            
            -- actual stat entries
            local stat, value
            local actualStatCount = 1
            for i = 1, #sortableStatWeightTable do
                stat = sortableStatWeightTable[i][1]
                value = sortableStatWeightTable[i][2]
                
                if not statTexts[i] then
                    statButtons[i] = CreateFrame("Button", "TopFit_ProgressFrame_editStatButton"..i, group3)
                    statTexts[i] = group3:CreateFontString(nil, "ARTWORK", "GameFontHighlightExtraSmall")
                    valueTexts[i] = group3:CreateFontString(nil, "ARTWORK", "GameFontHighlightExtraSmall")
                    capBox[i] = CreateFrame("CheckButton", "TopFit_ProgressFrame_CapCheckBox"..i, group3, "UICheckButtonTemplate")

                    statTexts[i]:SetTextHeight(11)
                    valueTexts[i]:SetTextHeight(11)
                    --statTexts[i]:SetHeight(32)
                    if i == 1 then
                        statTexts[i]:SetPoint("TOPLEFT", group3, "TOPLEFT", 3, -3)
                    else
                        statTexts[i]:SetPoint("TOPLEFT", statTexts[i - 1], "BOTTOMLEFT")
                    end
                    valueTexts[i]:SetPoint("RIGHT", statTexts[i], "LEFT", headerTitles[1][2] + headerTitles[2][2] - 4, 0)
                    statButtons[i].i = i
                    statButtons[i]:SetPoint("TOPLEFT", statTexts[i], "TOPLEFT")
                    statButtons[i]:SetPoint("BOTTOMRIGHT", valueTexts[i], "BOTTOMRIGHT")
                    --statButtons[i]:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
                    statButtons[i]:SetHighlightTexture("Interface\\Buttons\\UI-ListBox-Highlight")
                    statButtons[i]:SetAlpha(0.5)
                    statButtons[i]:SetScript("OnClick", function(self)
                        TopFit.ProgressFrame:HideStatEditTextBox()
                        TopFit.ProgressFrame:ShowStatEditTextBox(self.i)
                    end)
                    
                    capBox[i]:SetHeight(12); capBox[i]:SetWidth(12)
                    capBox[i]:SetPoint("LEFT", valueTexts[i], "RIGHT")
                end
                statTexts[i]:Show()
                valueTexts[i]:Show()
                statTexts[i]:SetText(_G[stat])
                valueTexts[i]:SetText(value)
                if TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat] then
                    capBox[i]:SetChecked(true)
                else
                    capBox[i]:SetChecked(false)
                end
                capBox[i]:Show()
                statButtons[i].myStat = stat
                actualStatCount = actualStatCount + 1
            end
            
            -- hide any texts not in use
            for i = actualStatCount, #statTexts do
                statTexts[i]:Hide()
                valueTexts[i]:Hide()
                statButtons[i]:Hide()
                capBox[i]:Hide()
            end
        end
        
        function TopFit.ProgressFrame:ShowStatEditTextBox(statID)
            if not TopFit.ProgressFrame.statEditTextBox then
                -- create box
                TopFit.ProgressFrame.statEditTextBox = CreateFrame("EditBox", "TopFit_ProgressFrame_statEditTextBox", group3)
                TopFit.ProgressFrame.statEditTextBox:SetWidth(50)
                TopFit.ProgressFrame.statEditTextBox:SetHeight(11)
                TopFit.ProgressFrame.statEditTextBox:SetAutoFocus(false)
                TopFit.ProgressFrame.statEditTextBox:SetFontObject("GameFontHighlightSmall")
                TopFit.ProgressFrame.statEditTextBox:SetJustifyH("RIGHT")
                
                -- background textures
                local left = TopFit.ProgressFrame.statEditTextBox:CreateTexture(nil, "BACKGROUND")
                left:SetWidth(8) left:SetHeight(20)
                left:SetPoint("LEFT", -5, 0)
                left:SetTexture("Interface\\Common\\Common-Input-Border")
                left:SetTexCoord(0, 0.0625, 0, 0.625)
                local right = TopFit.ProgressFrame.statEditTextBox:CreateTexture(nil, "BACKGROUND")
                right:SetWidth(8) right:SetHeight(20)
                right:SetPoint("RIGHT", 0, 0)
                right:SetTexture("Interface\\Common\\Common-Input-Border")
                right:SetTexCoord(0.9375, 1, 0, 0.625)
                local center = TopFit.ProgressFrame.statEditTextBox:CreateTexture(nil, "BACKGROUND")
                center:SetHeight(20)
                center:SetPoint("RIGHT", right, "LEFT", 0, 0)
                center:SetPoint("LEFT", left, "RIGHT", 0, 0)
                center:SetTexture("Interface\\Common\\Common-Input-Border")
                center:SetTexCoord(0.0625, 0.9375, 0, 0.625)
                
                -- scripts
                TopFit.ProgressFrame.statEditTextBox:SetScript("OnEscapePressed", function (self)
                    TopFit.ProgressFrame:HideStatEditTextBox()
                    TopFit.ProgressFrame:UpdateSetStats()
                end)
                
                TopFit.ProgressFrame.statEditTextBox:SetScript("OnEnterPressed", function (self)
                    -- save new stat value if it is numeric
                    local value = tonumber(TopFit.ProgressFrame.statEditTextBox:GetText())
                    local stat = TopFit.ProgressFrame.editStatButtons[TopFit.ProgressFrame.statEditTextBox.statID].myStat
                    if value and stat then -- otherwise, the text was probably not a number
                        --TopFit:Debug("Setting ".._G[stat].." weight to "..value)
                        if value == 0 then value = nil end
                        TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights[stat] = value
                    else
                        TopFit:Debug("invalid input")
                    end
                    TopFit.ProgressFrame:HideStatEditTextBox()
                    TopFit.ProgressFrame:UpdateSetStats()
                end)
            end
            TopFit.ProgressFrame.statEditTextBox:SetPoint("RIGHT", TopFit.ProgressFrame.editStatValueTexts[statID], "RIGHT")
            TopFit.ProgressFrame.statEditTextBox:SetText(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights[TopFit.ProgressFrame.editStatButtons[statID].myStat])
            TopFit.ProgressFrame.statEditTextBox:Show()
            TopFit.ProgressFrame.statEditTextBox:HighlightText()
            TopFit.ProgressFrame.statEditTextBox:SetFocus()
            TopFit.ProgressFrame.statEditTextBox.statID = statID
            TopFit.ProgressFrame.editStatValueTexts[statID]:Hide()
        end
        
        function TopFit.ProgressFrame:HideStatEditTextBox()
            if TopFit.ProgressFrame.statEditTextBox then
                TopFit.ProgressFrame.statEditTextBox:Hide()
                TopFit.ProgressFrame.statEditTextBox:ClearFocus()
            end
        end
        
        -- center frame on screen
        TopFit.ProgressFrame:SetPoint("CENTER", 0, 0)
        
        -- select default set
        TopFit.ProgressFrame:SetSelectedSet()
    end
    
    if not TopFit.ProgressFrame:IsShown() then
        TopFit.ProgressFrame:Show()
        TopFit.ProgressFrame:UpdateSetStats()
    end
end

function TopFit:HideProgressFrame()
    TopFit.ProgressFrame:Hide()
end

