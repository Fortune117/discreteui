local PANEL = {}

AccessorFunc(PANEL, "m_backColor", "BackgroundColor")
AccessorFunc(PANEL, "m_roundness", "Roundness")

function PANEL:Init()
    self:SetBackgroundColor(DiscreteUI.Colors.Background)
    self:SetRoundness(8)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(self:GetRoundness(),0, 0, w, h, self:GetBackgroundColor())
end

vgui.Register("DiscreteUI.Panel", PANEL)
