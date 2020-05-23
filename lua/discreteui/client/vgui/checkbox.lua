local PANEL = {}

DiscreteUI:CreateFont("ZoneManager.ZoneSetting.Name", 36)

AccessorFunc(PANEL, "m_checked", "Checked", FORCE_BOOL)

AccessorFunc(PANEL, "m_checkedImageIdleColor", "CheckedImageIdleColor")
AccessorFunc(PANEL, "m_uncheckedImageIdleColor", "UncheckedImageIdleColor")

AccessorFunc(PANEL, "m_checkedImageHoveredColor", "CheckedImageHoveredColor")
AccessorFunc(PANEL, "m_uncheckedImageHoveredColor", "UncheckedImageHoveredColor")

local border = DiscreteUI.Settings.DefaultBorder
function PANEL:Init()
    self:SetChecked(false)

    self:SetCheckedImage("discrete/icons/tick.png")
    self:SetUncheckedImage("discrete/icons/x.png")
    self:SetImage("discrete/icons/x.png")

    self:SetHoveredColor(DiscreteUI.Colors.Primary)

    self:SetCheckedImageIdleColor(DiscreteUI.Colors.DullGreen)
    self:SetCheckedImageHoveredColor(DiscreteUI.Colors.Green)

    self:SetUncheckedImageIdleColor(DiscreteUI.Colors.DullRed)
    self:SetUncheckedImageHoveredColor(DiscreteUI.Colors.Red)

    self:SetImageColors()

    self:SetText("")
end

function PANEL:SetImageColors()
    local checked = self:GetChecked()
    if checked then
        self:SetImageIdleColor(self:GetCheckedImageIdleColor())
        self:SetImageHoveredColor(self:GetCheckedImageHoveredColor())
    else
        self:SetImageIdleColor(self:GetUncheckedImageIdleColor())
        self:SetImageHoveredColor(self:GetUncheckedImageHoveredColor())
    end
end

function PANEL:DoClick()
    self:SetChecked(!self:GetChecked())
end

function PANEL:SetChecked(b)
    self.m_checked = b
    self:SetImageColors()
    self:OnChecked(self:GetChecked())
end

function PANEL:SetCheckedImage(string)
    self._checkedImage = Material(string)
end

function PANEL:GetCheckedImage()
    return self._checkedImage
end

function PANEL:SetUncheckedImage(string)
    self._uncheckedImage = Material(string)
end

function PANEL:GetUncheckedImage()
    return self._uncheckedImage
end

//For override
function PANEL:OnChecked(isChecked)
end

function PANEL:PerformLayout(w, h)
    self:SetImageSize(w*0.7)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(self:GetRoundness(),0, 0, w, h, self:GetCurrentColor())

    surface.SetDrawColor(self:GetImageColor())
    surface.SetMaterial(self:GetChecked() and self:GetCheckedImage() or self:GetUncheckedImage())

    local size = self:GetImageSize()
    local x = w/2 - size/2 + 1
    local y = h/2 - size/2 + 1

    surface.DrawTexturedRect(x, y, size, size)
end

vgui.Register("DiscreteUI.CheckBox", PANEL, "DiscreteUI.Button")
