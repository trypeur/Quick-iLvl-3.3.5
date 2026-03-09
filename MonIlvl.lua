local frame = CreateFrame("Frame")
frame:RegisterEvent("BAG_UPDATE")
frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

local function UpdateItemLevel(button, itemLink)
    if not button then return end
    
    -- Création du texte s'il n'existe pas
    if not button.ilvlText then
        button.ilvlText = button:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
        button.ilvlText:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
        button.ilvlText:SetTextColor(1, 1, 1) -- Blanc pour que ça se voie bien
    end

    if itemLink then
        local _, _, _, iLevel = GetItemInfo(itemLink)
        if iLevel and iLevel > 1 then
            button.ilvlText:SetText(iLevel)
        else
            button.ilvlText:SetText("")
        end
    else
        button.ilvlText:SetText("")
    end
end

local function ScanEverything()
    -- Scan des sacs (1 à 5 sacs de base)
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local button = _G["ContainerFrame"..(bag+1).."Item"..slot]
            if not button then -- Pour certains addons de sacs, le nom change
                button = _G["BagFrame"..bag.."Item"..slot]
            end
            local link = GetContainerItemLink(bag, slot)
            UpdateItemLevel(button, link)
        end
    end

    -- Scan du personnage
    local slots = {"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand", "SecondaryHand", "Ranged", "Tabard"}
    for _, slotName in ipairs(slots) do
        local slotId, _ = GetInventorySlotInfo(slotName.."Slot")
        local button = _G["Character"..slotName.."Slot"]
        local link = GetInventoryItemLink("player", slotId)
        UpdateItemLevel(button, link)
    end
end

-- Lancement lors des événements
frame:SetScript("OnEvent", function()
    ScanEverything()
end)

-- Force la mise à jour à l'ouverture des sacs
hooksecurefunc("ContainerFrame_Update", ScanEverything)