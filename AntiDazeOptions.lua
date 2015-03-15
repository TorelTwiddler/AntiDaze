function ADOptions_Toggle()
    if (AntiDazeOptionsFrame:IsVisible()) then
        AntiDazeOptionsFrame:Hide();
    else
        AntiDazeOptionsFrame:Show();
    end
end

function ADOptions_OnLoad(panel)
    panel.name = "AntiDaze " .. GetAddOnMetadata("AntiDaze", "Version")
    panel.okay = function (self) AdOptions_OnHide(); end;
    InterfaceOptions_AddCategory(panel);
end


function ADOptions_OnShow(self)
end

function ADOptions_Init()
    if (ADOptions == nil) then
        ADOptions = {};
        ADOptions.ADtoggle = 1;
        ADOptions.ADCCheet = 1;
        ADOptions.ADCPack = 1;
        ADOptions.ADCPackPets = 1;
    elseif (ADOptions.ADtoggle == nil) then
        ADOptions.ADtoggle = 1;
    elseif (ADOptions.ADCCheet == nil) then
        ADOptions.ADCCheet = 1;
    elseif (ADOptions.ADCPack == nil) then
        ADOptions.ADCPack = 1;
    elseif (ADOptions.ADCPackPets == nil) then
        ADOptions.ADCPackPets = 1;
    end
    AntiDazeOptionsFrameADtoggle:SetChecked(ADOptions.ADtoggle);
    AntiDazeOptionsFrameADCCheet:SetChecked(ADOptions.ADCCheet);
    AntiDazeOptionsFrameADCPack:SetChecked(ADOptions.ADCPack);
    AntiDazeOptionsFrameADCPackPets:SetChecked(ADOptions.ADCPackPets)
end

function ADOptions_OnHide(self)
    local frame = CreateFrame("FRAME", "ADOptions_OnHideFrame");
    if (MYADDONS_ACTIVE_OPTIONSFRAME == frame) then
        ShowUIPanel(myAddOnsFrame);
    end
end
