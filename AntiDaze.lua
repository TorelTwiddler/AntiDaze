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
            if ADOptions.ADtoggle == 1 then
                if ADOptions.ADCCheet == 1 and arg1 == "player" and PlayerBuff(BUFF_DAZED) and isCheetahActive() then
                    CPlayerBuff("JungleTiger")
                end
                if ADOptions.ADCPack == 1 and arg1 == "player" and PlayerBuff(BUFF_DAZED) and isPackActive() then
                    CPlayerBuff("WhiteTiger")
                end
                if ADOptions.ADCPack == 1 and (string.find(arg1, "party%d")) and TargetBuff(BUFF_DAZED, arg1) and isPackActive() then
                    CPlayerBuff("WhiteTiger")
                end
                if ADOptions.ADCPack == 1 and (string.find(arg1, "raid%d")) and TargetBuff(BUFF_DAZED, arg1) and isPackActive() then
                    CPlayerBuff("WhiteTiger")
                end
                if ADOptions.ADCPackPets == 1 and (string.find(arg1, "pet")) and TargetBuff(BUFF_DAZED, arg1) and isPackActive() then
                    CPlayerBuff("WhiteTiger")
                end
            end
        end
    end

    if (event == "VARIABLES_LOADED") then

        ADOptions_Init();

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
        if (msg == "toggle") then
            AD_Toggle();
        elseif (msg == "ccheet") then
            ADCCheet_Toogle()
        elseif (msg == "cpack") then
            ADCPack_Toogle()
        elseif (msg == "cpackpets") then
            ADCPackPets_Toogle()
        elseif (msg == "gui") then
            ADOptions_Toggle();
        else
            if (DEFAULT_CHAT_FRAME) then
                DEFAULT_CHAT_FRAME:AddMessage(AD_VERS_TITLE, 1, 1, 0.5);
                DEFAULT_CHAT_FRAME:AddMessage(TXT_HELP1, 1, 1, 0.5);
                DEFAULT_CHAT_FRAME:AddMessage(TXT_HELP2, 1, 1, 0.5);
                DEFAULT_CHAT_FRAME:AddMessage(TXT_HELP3, 1, 1, 0.5);
                DEFAULT_CHAT_FRAME:AddMessage(TXT_HELP4, 1, 1, 0.5);
                DEFAULT_CHAT_FRAME:AddMessage(TXT_HELP5, 1, 1, 0.5);
                DEFAULT_CHAT_FRAME:AddMessage(TXT_HELP6, 1, 1, 0.5);
            end
        end
        ADOptions_Init();
    else
        DEFAULT_CHAT_FRAME:AddMessage(AD_VERS_TITLE .. " " .. TXT_NOTLOADED, 1, 1, 0.5);
    end
end

function AD_Toggle()
    if (ADOptions.ADtoggle == 1) then
        ADOptions.ADtoggle = 0;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_AD_OFF, 1, 1, 0.5);
        end
    else
        ADOptions.ADtoggle = 1
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_AD_ON, 1, 1, 0.5);
        end
    end
end

function ADCCheet_Toogle()
    if (ADOptions.ADCCheet == 1) then
        ADOptions.ADCCheet = 0;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_CHEETAH_OFF, 1, 1, 0.5);
        end
    else
        ADOptions.ADCCheet = 1;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_CHEETAH_ON, 1, 1, 0.5);
        end
    end
end

function ADCPack_Toogle()
    if (ADOptions.ADCPack == 1) then
        ADOptions.ADCPack = 0;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_PACK_OFF, 1, 1, 0.5);
        end
    else
        ADOptions.ADCPack = 1;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_PACK_ON, 1, 1, 0.5);
        end
    end
end

function ADCPackPets_Toogle()
    if (ADOptions.ADCPackPets == 1) then
        ADOptions.ADCPackPets = 0;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_PACK_ON_PETS_OFF, 1, 1, 0.5);
        end
    else
        ADOptions.ADCPackPets = 1;
        if (DEFAULT_CHAT_FRAME) then
            DEFAULT_CHAT_FRAME:AddMessage(TXT_PACK_ON_PETS_ON, 1, 1, 0.5);
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

-- same but will return right index for use with CancelPlayerBuff
function CPlayerBuff(buff, a)
    local iIterator = 1
    local texture
    while (UnitBuff('player', iIterator)) do
        _, _, texture, _ = UnitBuff('player', iIterator);
        if texture then
            if (string.find(texture, buff)) then
                --if ( DEFAULT_CHAT_FRAME ) then DEFAULT_CHAT_FRAME:AddMessage("CPlayer: "..GetPlayerBuffTexture(iIterator)..", iIterator: "..iIterator, 1, 1, 0.5) end
                local text = ""
                if (buff == "WhiteTiger") then
                    text = "Turn off Aspect of the Pack!"
                else
                    text = "Turn off Aspect of the Cheetah!"
                end
                RaidNotice_AddMessage(RaidWarningFrame, text, ChatTypeInfo["RAID_WARNING"])

                --PlaySoundFile("Sound\\Doodad\\BellTollNightElf.wav")
                PlaySoundFile("Sound\\Spells\\PVPFlagTaken.wav")

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
