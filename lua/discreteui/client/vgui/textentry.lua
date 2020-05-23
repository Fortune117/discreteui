local PANEL = {}

DiscreteUI:CreateFont("DiscreteUI.TextEntry.Default", 28)
DiscreteUI:CreateFont("DiscreteUI.TextEntry.PlaceHolder", 26)

AccessorFunc(PANEL, "m_backgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "m_placeHolderColor", "PlaceHolderColor")
AccessorFunc(PANEL, "m_placeHolderText", "PlaceHolderText", FORCE_STRING)
AccessorFunc(PANEL, "m_placeHolderFont", "PlaceHolderFont", FORCE_STRING)
AccessorFunc(PANEL, "m_drawPlaceHolder", "ShouldDrawPlaceHolder", FORCE_BOOL)
AccessorFunc(PANEL, "m_roundness", "Roundness")

function PANEL:Init()
    self:SetFont("DiscreteUI.TextEntry.Default")

    self:SetBackgroundColor(DiscreteUI.Colors.Secondary)
    self:SetPlaceHolderText("Enter text here.")
    self:SetPlaceHolderFont("DiscreteUI.TextEntry.PlaceHolder")
    self:SetPlaceHolderColor(ColorAlpha(DiscreteUI.Colors.White, 10))
    self:SetRoundness(8)
    self:SetTextColor(DiscreteUI.Colors.White)

    self:SetValue("")

    self:SetContentAlignment(5)
    self:SetEditable(true)
end

function PANEL:OnGetFocus()
end

function PANEL:Paint(w, h)

    draw.RoundedBox(self:GetRoundness(), 0, 0, w, h, self:GetBackgroundColor())

    local col = self:GetTextColor()
    self:DrawTextEntryText(col, col, col)

    local placeHolder = self:GetPlaceHolderText()
    if placeHolder and #placeHolder > 0 and #self:GetValue() == 0 and !self:IsEditing() then
        draw.SimpleText(placeHolder, self:GetPlaceHolderFont(), 5, h/2, self:GetPlaceHolderColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

end

vgui.Register("DiscreteUI.TextEntry", PANEL, "DTextEntry")
