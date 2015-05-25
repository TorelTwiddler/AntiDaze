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

AD_TITLE = "AntiDaze";

BINDING_HEADER_AD_TITLE = AD_TITLE;
BINDING_NAME_AD_TOGGLE = TXT_TOGGLE .. " " .. AD_TITLE;

BINDING_HEADER_AD_OPTIONS_TITLE = AD_TITLE;

AD_variables_loaded = false;

AD_ready_for_warning = true;

function AD_OnLoad(self)
    self:RegisterEvent("VARIABLES_LOADED");

    self:RegisterEvent("UNIT_AURA"); -- Triggers when Player becomes Buff

    self:RegisterEvent("PLAYER_AURAS_CHANGED");

    DEFAULT_CHAT_FRAME:AddMessage(AD_TITLE .. " " .. TXT_LOADED, 1, 1, 0.5);
    SLASH_AD1 = "/AD";
    SLASH_AD2 = "/antidaze";

    SlashCmdList["AD"] = function(msg)
        AD_SlashCommand(msg);
    end
end

function AD_OnEvent(self, event, ...)
    local arg1 = select(1, ...)
    if IsMounted() or not AD_ready_for_warning then
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
    end
end

function AD_SlashCommand(msg)
    InterfaceOptionsFrame_OpenToCategory("AntiDaze")
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

-- Loops through all of the buffs currently active looking for a
-- string match on the Player
function PlayerBuff(buff)
    local i = 1
    while (UnitBuff("player", i)) or (UnitDebuff("player", i)) do
        Buff1 = UnitBuff("player", i)
        DeBuff1 = UnitDebuff("player", i)
        if (Buff1) then
            if (string.find(Buff1, buff)) then
                return i - 1
            end
        end
        if (DeBuff1) then
            if (string.find(DeBuff1, buff)) then
                return i - 1
            end
        end
        i = i + 1
    end
end

-- Loops through all of the buffs currently active looking for a
-- string match for Target or (if specified) for Unit
function TargetBuff(buff, Unit)
    local i = 1
    if (Unit) then what = Unit else what = "target" end
    while (UnitBuff(what, i)) or (UnitDebuff(what, i)) do
        found = false
        Buff1 = UnitBuff(what, i)
        DeBuff1 = UnitDebuff(what, i)
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
            return i;
        end
        i = i + 1
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


-- Loops through all of the buffs currently active looking for a
-- string match, then print to chat or raid warn the player
function CPlayerBuff(buff)
    local i = 1
    local texture, caster, caster_name, class, _

    while (UnitBuff('player', i)) do
        _, _, texture, _, _, _, _, caster = UnitBuff('player', i);
        if texture then
            if (string.find(texture, buff)) then
                AD_ready_for_warning = false
                --if ( DEFAULT_CHAT_FRAME ) then DEFAULT_CHAT_FRAME:AddMessage("CPlayer: "..GetPlayerBuffTexture(i)..", i: "..i, 1, 1, 0.5) end
                _, class = UnitClass(caster)
                if caster then
                    name, realm = UnitName(caster)
                    if realm then
                        name = string.format("%s-%s", name, realm)
                    end
                    caster_name = string.format("|c%s%s|r", color[class], name);
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
                    text = "Turn off Aspect of the Cheetah!"
                end

                if ADOptions.ADRaidWarning then
                    RaidNotice_AddMessage(RaidWarningFrame, text, ChatTypeInfo["RAID_WARNING"]);
                    PlaySoundFile("Sound\\Spells\\PVPFlagTaken.wav");
                end

                if ADOptions.ADChatMessage then
                    print(text);
                end

                -- This function is now protected, and can not be called from an addon.
                --CancelUnitBuff('player',UnitBuff('player',i))

                return UnitBuff('player', i)
            end
        else
            break;
        end
        i = i + 1
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

local AD_WarningInterval = 10
local AD_TimeRemainingForWarning = AD_WarningInterval

function AD_OnUpdate(self, elapsed)
    if not AD_ready_for_warning then
        AD_TimeRemainingForWarning = AD_TimeRemainingForWarning - elapsed
        if AD_TimeRemainingForWarning < 0 then
            AD_ready_for_warning = true;
            AD_TimeRemainingForWarning = AD_WarningInterval
        end
    end
end
