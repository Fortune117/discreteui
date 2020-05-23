local PANEL = {}

AccessorFunc(PANEL, "m_barColor", "BarColor")

DiscreteUI:CreateFont("DiscreteUI.NumberSlider", 16)

local border = DiscreteUI.Settings.DefaultBorder
function PANEL:Init()

    self:SetBarColor(DiscreteUI.Colors.LightGrey)
    self:SetRoundness(4)

    self.label = vgui.Create("DLabel", self)
    self.label:Dock(LEFT)
    self.label:SetFont("DiscreteUI.NumberSlider")
    self.label:SetTextColor(DiscreteUI.Colors.White)
    self.label:SetContentAlignment(5)

    self.slideBar = vgui.Create("DiscreteUI.Panel", self)
    function self.slideBar.Paint(bar, w, h)
        draw.RoundedBox(self:GetRoundness(),0, 0, w, h, self:GetBackgroundColor())

        local fracWidth = w*self:GetSlideFraction()
        draw.RoundedBox(self:GetRoundness(),0, 0, fracWidth, h, self:GetBarColor())
    end

    function self.slideBar.PerformLayout(bar, w, h)
        self.grip.SetPosWithFraction()
    end

    self.grip = vgui.Create("DiscreteUI.Button", self)
    self.grip:SetWide(10)
    self.grip:SetRoundness(4)
    self.grip:SetText("")
    self.grip:SetIdleColor(DiscreteUI.Colors.Secondary)

    function self.grip.SetPosWithFraction()
        local barX, barY = self.slideBar:GetPos()
        local barW, barH = self.slideBar:GetSize()

        local w,h = self.grip:GetSize()
        local frac = self:GetSlideFraction()
        self.grip:SetPos(barX + barW*frac - w/2, barY + barH/2 - h/2)
    end

    function self.grip.OnMousePressed( keyCode )
        self:SetGripped(true)
    end

    function self.grip.OnMouseReleased( keyCode )
        self:SetGripped(false)
        self.grip.SetPosWithFraction()
    end

    local gap = 1
    function self.grip.Paint(grip, w, h)
        draw.RoundedBox(self:GetRoundness(), 0, 0, w, h, DiscreteUI.Colors.Background)
        draw.RoundedBox(self.grip:GetRoundness(), gap, gap, w - gap*2, h - gap*2, self.grip:GetCurrentColor())
    end

    self:SetMax(10)
    self:SetMin(1)
    self:SetDefaultValue(1)
    self:SetDecimals(0)

    self:SetSlideFraction(0)
    self:SetGripped(false)

    self:SetBarHeight(20)
    self:ResetToDefaultValue()

end

function PANEL:SetRawValue(n)
    local frac = n/self:GetMax()
    self:SetSlideFraction(frac)
    self._value = n
    self.label:SetText(tostring(n))
end

function PANEL:SetValue(n)
    self._value = n
    self.label:SetText(tostring(n))
end

function PANEL:GetValue()
    return self._value
end

function PANEL:SetDecimals(n)
    self._decimals = n
end

function PANEL:GetDecimals()
    return self._decimals
end

function PANEL:SetMin(n)
    self._min = n
end

function PANEL:GetMin()
    return self._min
end

function PANEL:SetMax(n)
    self._max = n
end

function PANEL:GetMax()
    return self._max
end

function PANEL:SetDefaultValue(n)
    self._defaultValue = n
end

function PANEL:GetDefaultValue()
    return self._defaultValue
end

function PANEL:ResetToDefaultValue()
    local frac = self:GetDefaultValue()/self:GetMax()
    self:SetSlideFraction(frac)
    self:SetValue(self:GetDefaultValue())
end

function PANEL:Think()
    if self:IsGripped() then
        self:GripLogic()
    end
end

function PANEL:GripLogic()

    if !input.IsMouseDown(MOUSE_LEFT) then
        self:SetGripped(false)
        return
    end

    local mX, mY = gui.MousePos()
    local barX, barY = self.slideBar:LocalToScreen(0, 0)
    local barW, barH = self.slideBar:GetSize()

    local dif = mX - barX

    local frac = (dif/barW)
    self:SetSlideFraction(frac)

end

function PANEL:SetGripped(b)
    self._gripped = b
end

function PANEL:IsGripped()
    return self._gripped
end

function PANEL:SetSlideFraction(n)
    self._fraction = math.Clamp(n, 0, 1)
    self.grip.SetPosWithFraction()

    local dif = self:GetMax() - self:GetMin()
    local val = self:GetMin() + dif*self:GetSlideFraction()
    val = math.Round(val, self:GetDecimals())
    self:SetValue(val)
end

function PANEL:GetSlideFraction()
    return self._fraction
end

function PANEL:SetBarHeight(n)
    self.slideBar:SetTall(n)
    self.grip:SetTall(n + border*2)
    self.grip.SetPosWithFraction()
end

function PANEL:OnMouseWheeled(scrollDelta)
    self:SetSlideFraction(self:GetSlideFraction() + scrollDelta/100)
end

function PANEL:PerformLayout(w, h)

    surface.SetFont(self.label:GetFont())
    local text = tostring(self:GetMax())
    if self:GetDecimals() > 0 then
        text = text..tostring(self:GetDecimals()..".12")
    end
    local tWidth, tHeight = surface.GetTextSize(text)
    self.label:SetWide(tWidth)

    local barW = w - self.label:GetWide() - border - self.grip:GetWide()

    self.slideBar:SetWide(barW)
    self.slideBar:SetPos(self.label:GetWide() + border)
    self.slideBar:CenterVertical()

end

function PANEL:Paint(w, h)
end

vgui.Register("DiscreteUI.NumberSlider", PANEL, "DiscreteUI.Panel")
