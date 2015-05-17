function ADOptions_Toggle()
    if (AntiDazeOptionsFrame:IsVisible()) then
        AntiDazeOptionsFrame:Hide();
    else
        AntiDazeOptionsFrame:Show();
    end
end

function ADOptions_Init()
    if (ADOptions == nil) or (type(ADOptions.ADtoggle) == 'number') then
        ADOptions = {};
    end
    if (ADOptions.ADtoggle == nil) then
        ADOptions.ADtoggle = true;
    end
    if (ADOptions.ADCCheet == nil) then
        ADOptions.ADCCheet = true;
    end
    if (ADOptions.ADCPack == nil) then
        ADOptions.ADCPack = true;
    end
    if (ADOptions.ADCPackPets == nil) then
        ADOptions.ADCPackPets = true;
    end
    if (ADOptions.ADRaidWarning == nil) then
        ADOptions.ADRaidWarning = true;
    end
    if (ADOptions.ADChatMessage == nil) then
        ADOptions.ADChatMessage = false;
    end
    AntiDazeOptionsFrameADtoggle:SetChecked(ADOptions.ADtoggle);
    AntiDazeOptionsFrameADCCheet:SetChecked(ADOptions.ADCCheet);
    AntiDazeOptionsFrameADCPack:SetChecked(ADOptions.ADCPack);
    AntiDazeOptionsFrameADCPackPets:SetChecked(ADOptions.ADCPackPets)
    AntiDazeOptionsFrameADRaidWarning:SetChecked(ADOptions.ADRaidWarning)
    AntiDazeOptionsFrameADChatMessage:SetChecked(ADOptions.ADChatMessage)
end

function ADOptions_OnLoad(panel)
    panel.name = "AntiDaze"
    InterfaceOptions_AddCategory(panel);
end

