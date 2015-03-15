--------------------------------------------------
--
-- AddOn			: AntiDaze
-- Date			: 2014.10.13
-- Author			: Qsek
-- Burning Crusade Bugfix	: xbjim
-- BC Multilanguage		: Minihunt EU@Ner'zhul
-- BC Translated FR		: Minihunt EU@Ner'zhul
-- BC Translated DE	: Endeavour EU@Arthas, Niro EU@Frostmourne
-- Wrath Bugfix		: TorelTwiddler
-- Cataclysm			: TorelTwiddler
-- Mists of Pandaria	: TorelTwiddler
-- Warlords of Draenor	: TorelTwiddler
--------------------------------------------------

AD_VERSION = "v1.0.3";
AD_TITLE = "AntiDaze";
AD_VERS_TITLE = AD_TITLE .. " " .. AD_VERSION;

BINDING_HEADER_AD_TITLE = AD_TITLE;
BINDING_NAME_AD_TOGGLE = TXT_TOGGLE .. " " .. AD_TITLE;

BINDING_HEADER_AD_OPTIONS_TITLE = AD_TITLE;

AD_variables_loaded = false;

--AD_TEXT_AURA = string.gsub(AURAADDEDOTHERHARMFUL,'%%s','(.+)')

function AD_OnLoad(self)
    local _, class = UnitClass("player");
    if (class == "HUNTER") then
        --local frame = CreateFrame("FRAME", "FooAddonFrame");

        self:RegisterEvent("VARIABLES_LOADED");

        self:RegisterEvent("UNIT_AURA"); -- Triggers when Player becomes Buff

        self:RegisterEvent("PLAYER_AURAS_CHANGED");

        DEFAULT_CHAT_FRAME:AddMessage(AD_VERS_TITLE .. " " .. TXT_LOADED, 1, 1, 0.5);
    else
        DEFAULT_CHAT_FRAME:AddMessage(AD_VERS_TITLE .. " " .. TXT_NOTLOADED, 1, 1, 0.5);
    end
    SLASH_AD1 = "/AD";
    SLASH_AD2 = "/antidaze";

    SlashCmdList["AD"] = function(msg)
        AD_SlashCommand(msg);
    end
end

function AD_OnEvent(self, event, ...)
    local arg1 = select(1, ...)
    if IsMounted() then
        --do nothing
    else
        if (event == "UNIT_AURA") then
            if ADOptions.ADtoggle then
                if ADOptions.ADCCheet and arg1 == "player" and PlayerBuff(BUFF_DAZED) and isCheetahActive() then
                    CPlayerBuff("JungleTiger")
                end
                if ADOptions.ADCPack and arg1 == "player" and PlayerBuff(BUFF_DAZED) and isPackActive() then
                    CPlayerBuff("WhiteTiger")
                end
                if ADOptions.ADCPack and (string.find(arg1, "party%d")) and TargetBuff(BUFF_DAZED, arg1) and isPackActive() then
                    CPlayerBuff("WhiteTiger")
                end
                if ADOptions.ADCPack and (string.find(arg1, "raid%d")) and TargetBuff(BUFF_DAZED, arg1) and isPackActive() then
                    CPlayerBuff("WhiteTiger")
                end
                if ADOptions.ADCPackPets and (string.find(arg1, "pet")) and TargetBuff(BUFF_DAZED, arg1) and isPackActive() then
                    CPlayerBuff("WhiteTiger")
                end
            end
        end
    end

    if (event == "VARIABLES_LOADED") then
        if not AD_variables_loaded then
            ADOptions_Init();
            AD_variables_loaded = true;
        end
        ---------------------
        -- support for Cosmos
        ---------------------
        if (Cosmos_RegisterButton) then
            Cosmos_RegisterButton(AD_VERS_TITLE,
                AD_SUBTITLE,
                AD_DESC,
                "Interface\\Icons\\Ability_Mount_JungleTiger",
                ADOptions_Toggle);
        end

        -----------------------
        -- support for myAddOns
        -----------------------
        if (myAddOnsFrame) then
            myAddOnsList.AD = {
                name = AD_TITLE,
                description = AD_DESC,
                version = AD_VERSION,
                category = MYADDONS_CATEGORY_COMBAT,
                frame = "AntiDazeFrame",
                optionsframe = 'AntiDazeOptionsFrame'
            };
        end
    end
end

function AD_SlashCommand(msg)
    local _, class = UnitClass("player");
    if (class == "HUNTER") then
        InterfaceOptionsFrame_OpenToCategory("AntiDaze " .. GetAddOnMetadata("AntiDaze", "Version"))
    else
        DEFAULT_CHAT_FRAME:AddMessage(AD_VERS_TITLE .. " " .. TXT_NOTLOADED, 1, 1, 0.5);
    end
end

function AD_Toggle()
    if (ADOptions.ADtoggle) then
        ADOptions.ADtoggle = false;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_AD_OFF, 1, 1, 0.5);
        end
    else
        ADOptions.ADtoggle = true
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_AD_ON, 1, 1, 0.5);
        end
    end
end

function ADCCheet_Toggle()
    if (ADOptions.ADCCheet) then
        ADOptions.ADCCheet = false;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_CHEETAH_OFF, 1, 1, 0.5);
        end
    else
        ADOptions.ADCCheet = true;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_CHEETAH_ON, 1, 1, 0.5);
        end
    end
end

function ADCPack_Toggle()
    if (ADOptions.ADCPack) then
        ADOptions.ADCPack = false;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_PACK_OFF, 1, 1, 0.5);
        end
    else
        ADOptions.ADCPack = true;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_PACK_ON, 1, 1, 0.5);
        end
    end
end

function ADCPackPets_Toggle()
    if (ADOptions.ADCPackPets) then
        ADOptions.ADCPackPets = false;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_PACK_ON_PETS_OFF, 1, 1, 0.5);
        end
    else
        ADOptions.ADCPackPets = true;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_PACK_ON_PETS_ON, 1, 1, 0.5);
        end
    end
end

function ADRaidWarning_Toggle()
    if (ADOptions.ADRaidWarning) then
        ADOptions.ADRaidWarning = false;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_RAIDWARNING_OFF, 1, 1, 0.5);
        end
    else
        ADOptions.ADRaidWarning = true;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_RAIDWARNING_ON, 1, 1, 0.5);
        end
    end
end

function ADChatMessage_Toggle()
    if (ADOptions.ADChatMessage) then
        ADOptions.ADChatMessage = false;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_CHATMESSAGE_OFF, 1, 1, 0.5);
        end
    else
        ADOptions.ADChatMessage = true;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_CHATMESSAGE_ON, 1, 1, 0.5);
        end
    end
end

------------------------
-- Helper Functions  --
------------------------

--Loops through all of the buffs currently active looking for a string match
function PlayerBuff(buff)
    local iIterator = 1
    while (UnitBuff("player", iIterator)) or (UnitDebuff("player", iIterator)) do
        Buff1 = UnitBuff("player", iIterator)
        DeBuff1 = UnitDebuff("player", iIterator)
        if (Buff1) then
            if (string.find(Buff1, buff)) then
                return iIterator - 1
            end
        end
        if (DeBuff1) then
            if (string.find(DeBuff1, buff)) then
                return iIterator - 1
            end
        end
        iIterator = iIterator + 1
    end
end

-- same for Target or (if specified) for Unit
function TargetBuff(buff, Unit)
    local iIterator = 1
    if (Unit) then what = Unit else what = "target" end
    while (UnitBuff(what, iIterator)) or (UnitDebuff(what, iIterator)) do
        found = false
        Buff1 = UnitBuff(what, iIterator)
        DeBuff1 = UnitDebuff(what, iIterator)
        if (Buff1) then
            if (string.find(Buff1, buff)) then
                found = true
            end
        end
        if (DeBuff1) then
            if (string.find(DeBuff1, buff)) then
                found = true
            end
        end
        if (found) then
            return iIterator;
        end
        iIterator = iIterator + 1
    end
end


local color = setmetatable({}, {__index = function(t, cl)
	local colorSet = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[cl] or RAID_CLASS_COLORS[cl]
	if colorSet then
		t[cl] = ("ff%02x%02x%02x"):format(colorSet.r * 255, colorSet.g * 255, colorSet.b * 255)
	else
		t[cl] = "ffffffff"
	end
	return t[cl]
end })


-- same but will return right index for use with CancelPlayerBuff
function CPlayerBuff(buff, a)
    local iIterator = 1
    local texture, caster, caster_name, class, _
    while (UnitBuff('player', iIterator)) do
        _, _, texture, _, _, _, _, caster = UnitBuff('player', iIterator);
        if texture then
            if (string.find(texture, buff)) then
                --if ( DEFAULT_CHAT_FRAME ) then DEFAULT_CHAT_FRAME:AddMessage("CPlayer: "..GetPlayerBuffTexture(iIterator)..", iIterator: "..iIterator, 1, 1, 0.5) end
                _, class = UnitClass(caster)
                if caster then
                    caster_name = string.format("|c%s%s|r", color[class], UnitName(caster));
                else
                    caster_name = "Unknown Player"
                end
                local text = ""
                if (buff == "WhiteTiger") then
                    if UnitName(caster) == UnitName('player') then
                        text = "Turn off Aspect of the Pack!"
                    else
                        text = string.format("%s is using Aspect of the Pack!", caster_name);
                    end
                else
--                    text = "Turn off Aspect of the Cheetah!"
                    text = string.format("%s is using Aspect of the Cheetah!", caster_name);
                end

                if ADOptions.ADRaidWarning then
                    RaidNotice_AddMessage(RaidWarningFrame, text, ChatTypeInfo["RAID_WARNING"]);
                    PlaySoundFile("Sound\\Spells\\PVPFlagTaken.wav");
                end

                if ADOptions.ADChatMessage then
                    print(text);
                end

                -- This function is now protected, and can not be called from an addon.
                --CancelUnitBuff('player',UnitBuff('player',iIterator))

                return UnitBuff('player', iIterator)
            end
        else
            break;
        end
        iIterator = iIterator + 1
    end
end


function GetSpellBookSlotTex(wtexture)
    --Sea.IO.print("----- "..spell)
    local i = 1;
    while true do
        local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL);
        local texture = GetSpellTexture(i, BOOKTYPE_SPELL)
        if not spellName then
            do break end;
        end
        --Sea.IO.print("Vergleiche: "..spellName.." == "..spell);
        if (string.find(texture, wtexture)) then
            --Sea.IO.print("Tex: "..texture.." == "..wtexture..", Buchplatz: "..i);
            spelltexture = texture
            spellbookslot = i
            --Sea.IO.print("Textur: "..spelltexture);
            do break end;
        end
        i = i + 1;
    end
    BuffPos = TargetBuff(spelltexture)
    --Sea.IO.print(BuffPos)
    return spellbookslot, spellName, spelltexture, BuffPos
end


function GetSpellBookSlot(spell)
    --Sea.IO.print("----- "..spell)
    local i = 1;
    while true do
        local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL);
        local texture = GetSpellTexture(i, BOOKTYPE_SPELL)
        if not spellName then
            do break end;
        end
        --Sea.IO.print("Vergleiche: "..spellName.." == "..spell);
        if (string.find(spellName, spell)) then
            --Sea.IO.print(spellName.." == "..spell..", Buchplatz: "..i);
            spelltexture = texture
            spellbookslot = i
            --Sea.IO.print("Textur: "..spelltexture);
            do break end;
        end
        i = i + 1;
    end
    BuffPos = TargetBuff(spelltexture)
    --Sea.IO.print(BuffPos)
    return spellbookslot, spellName, spelltexture, BuffPos
end

--Returns true if Aspect of the Cheetah is active
function isCheetahActive()
    if PlayerBuff(SPELL_CHEETAH) then
        return true
    end
end

--Returns true if Aspect of the Pack is active
function isPackActive()
    if PlayerBuff(SPELL_PACK) then
        return true
    end
end
