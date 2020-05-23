local PANEL = {}

AccessorFunc(PANEL, "m_disabledColor", "DisabledColor")
AccessorFunc(PANEL, "m_hoveredColor", "HoveredColor")
AccessorFunc(PANEL, "m_idleColor", "IdleColor")
AccessorFunc(PANEL,"m_currentColor", "CurrentColor")

AccessorFunc(PANEL, "m_roundness", "Roundness", FORCE_NUMBER)
AccessorFunc(PANEL, "m_enableShadows", "ShadowsEnabled", FORCE_BOOL)
AccessorFunc(PANEL,"m_shadow", "ShadowSize", FORCE_NUMBER)

AccessorFunc(PANEL,"m_imageDisabledColor", "ImageDisabledColor")
AccessorFunc(PANEL,"m_imageHoveredColor", "ImageHoveredColor")
AccessorFunc(PANEL,"m_imageIdleColor", "ImageIdleColor")
AccessorFunc(PANEL,"m_imageColor", "ImageColor")
AccessorFunc(PANEL,"m_imageSize", "ImageSize", FORCE_NUMBER)

DiscreteUI:CreateFont("DiscreteUI.Button.Font", 20)

function PANEL:Init()
    self:SetDisabledColor(DiscreteUI.Colors.Tertary)
    self:SetHoveredColor(DiscreteUI.Colors.Highlight)
    self:SetIdleColor(DiscreteUI.Colors.Secondary)
    self:SetCurrentColor(DiscreteUI.Colors.Secondary)

    self:SetRoundness(8)
    self:SetShadowsEnabled(true)
    self:SetShadowSize(15)

    self:SetImageDisabledColor(DiscreteUI.Colors.Tertary)
    self:SetImageHoveredColor(DiscreteUI.Colors.White)
    self:SetImageIdleColor(DiscreteUI.Colors.Secondary)
    self:SetImageColor(DiscreteUI.Colors.Secondary)
    self:SetImageSize(0)

    self:SetFont("DiscreteUI.Button.Font")
    self:SetTextColor(DiscreteUI.Colors.White)
    self:SetText("Click me!")
    self:SetEnabled(true)
end

function PANEL:Think()
    self:LerpColor()
end

function PANEL:SetEnabled(b)
    self.BaseClass.SetEnabled(self, b)
    self:SetCursor(b and "hand" or "no")
end

function PANEL:SetDisabled(b)
    self.BaseClass.SetDisabled(self, b)
    self:SetCursor(b and "no" or "hand")
end

function PANEL:LerpColor()
    if !self:IsEnabled() then
        local curColor = self:GetCurrentColor()
        self:SetCurrentColor(DiscreteUI:LerpColor(FrameTime()*20, curColor, self:GetDisabledColor()))
        if self._image then
            local imgColor = self:GetImageColor()
            self:SetImageColor(DiscreteUI:LerpColor(FrameTime()*20, imgColor, self:GetImageDisabledColor()))
        end
    elseif self:IsHovered() then
        local curColor = self:GetCurrentColor()
        self:SetCurrentColor(DiscreteUI:LerpColor(FrameTime()*20, curColor, self:GetHoveredColor()))
        if self._image then
            local imgColor = self:GetImageColor()
            self:SetImageColor(DiscreteUI:LerpColor(FrameTime()*20, imgColor, self:GetImageHoveredColor()))
        end
    else
        local curColor = self:GetCurrentColor()
        self:SetCurrentColor(DiscreteUI:LerpColor(FrameTime()*20, curColor, self:GetIdleColor()))
        if self._image then
            local imgColor = self:GetImageColor()
            self:SetImageColor(DiscreteUI:LerpColor(FrameTime()*20, imgColor, self:GetImageIdleColor()))
        end
    end
end

function PANEL:DoClick()
end

function PANEL:SetImage(string)
    self._image = Material(string, "noclamp smooth")
end

function PANEL:GetImage()
    return self._image
end

function PANEL:Paint(w, h)
    draw.RoundedBox(self:GetRoundness(),0, 0, w, h, self:GetCurrentColor())

    if !self:GetImage() then return end
    surface.SetDrawColor(self:GetImageColor())
    surface.SetMaterial(self:GetImage())

    local size = self:GetImageSize()
    local x = w/2 - size/2 + 1
    local y = h/2 - size/2 + 1

    surface.DrawTexturedRect(x, y, size, size)
end

vgui.Register("DiscreteUI.Button", PANEL, "DButton")
