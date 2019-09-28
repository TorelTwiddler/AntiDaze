--------------------------------------------------
--
-- AddOn			: AntiDaze
-- Author			: Qsek
-- Burning Crusade Bugfix	: xbjim
-- BC Multilanguage		: Minihunt EU@Ner'zhul
-- BC Translated FR		: Minihunt EU@Ner'zhul
-- BC Translated DE	: Endeavour EU@Arthas, Niro EU@Frostmourne
-- Wrath Bugfix		: TorelTwiddler
-- Cataclysm			: TorelTwiddler
-- Mists of Pandaria	: TorelTwiddler
-- Warlords of Draenor	: TorelTwiddler
-- Classic              : TorelTwiddler
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

    DEFAULT_CHAT_FRAME:AddMessage(AD_TITLE .. " " .. TXT_LOADED, 1, 1, 0.5);
    SLASH_AD1 = "/AD";
    SLASH_AD2 = "/antidaze";

    SlashCmdList["AD"] = function(msg)
        AD_SlashCommand(msg);
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
                CPlayerBuff()
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


local color = setmetatable({}, {__index = function(t, cl)
	local colorSet = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[cl] or RAID_CLASS_COLORS[cl]
	if colorSet then
		t[cl] = ("ff%02x%02x%02x"):format(colorSet.r * 255, colorSet.g * 255, colorSet.b * 255)
	else
		t[cl] = "ffffffff"
	end
	return t[cl]
end })


local function getCasterName(caster)
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
    return caster_name
end


local function HandleRaidWarning(message)
    if ADOptions.ADRaidWarning then
        RaidNotice_AddMessage(RaidWarningFrame, message, ChatTypeInfo["RAID_WARNING"]);
        PlaySound(8959); -- Raid warning
    end
end


local function HandleChatMessage(message)
    if ADOptions.ADChatMessage then
        print(message);
    end
end


local function HandleCheetah()
    if ADOptions.ADCCheet then
        local message = "Turn off Aspect of the Cheetah!"
        HandleRaidWarning(message)
        HandleChatMessage(message)
    end
end


local function HandlePack(caster)
    if ADOptions.ADCPack then
        if caster == 'player' then
            local message = "Turn off Aspect of the Pack!"
        else
            local caster_name = getCasterName(caster)
            local message = string.format("%s is using Aspect of the Pack!", caster_name);
        end
        HandleRaidWarning(message)
        HandleChatMessage(message)
    end
end


local function ScanForBuff()
    local i = 1
    while (UnitBuff('player', i)) do
        local spellID = select(10, UnitBuff('player', i))
        if spellID == 5118 then -- AotC
            HandleCheetah()
        elseif spellID == 13159 then -- AotP
            local caster = select(7, UnitBuff('player', i))
            HandlePack(caster)
        else
            -- Not Cheetah or Pack, ignore
        end
        i = i + 1
    end
end


-- Loops through all of the buffs currently active looking for a
-- string match, then print to chat or raid warn the player
function CPlayerBuff()
    local i = 1
    local caster, spellID

    while (UnitDebuff('player', i)) do
        spellID = select(10, UnitDebuff('player', i))
        caster = select(7, UnitDebuff('player', i))
        if spellID and spellID == 15571 then -- Dazed'
            AD_ready_for_warning = false

            ScanForBuff()
        else
            break;
        end
        i = i + 1
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
