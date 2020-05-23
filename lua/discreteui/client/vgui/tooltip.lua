local PANEL = {}

DiscreteUI:CreateFont("DiscreteUI.ToolTip.Default", 22, 500)

local border = DiscreteUI.Settings.DefaultBorder/2
function PANEL:Init()

    self:SetBackgroundColor(DiscreteUI.Colors.LightGrey)

    self.canvas = vgui.Create("DiscreteUI.Panel", self)
    self.canvas:Dock(FILL)
    self.canvas:DockMargin(border, border, border, border)
    self.canvas:SetBackgroundColor(DiscreteUI.Colors.Background)

    self.label = vgui.Create("DLabel", self.canvas)
    self.label:SetFont("DiscreteUI.ToolTip.Default")
    self.label:SetTextColor(DiscreteUI.Colors.White)
    self.label:Dock(FILL)
    self.label:SetContentAlignment(5)

end

function PANEL:SetText(text)
    self.label:SetText(text)
end

function PANEL:OpenForPanel(panel)
    local x, y = panel:LocalToScreen(0, 0)

    surface.SetFont(self.label:GetFont())
    local tWidth, tHeight = surface.GetTextSize(self.label:GetText())

    self:SetSize(tWidth + border*8, tHeight + border*4)

    local w, h = self:GetSize()

    self:SetPos(x, y - h - border)

    self:MakePopup()
end

function PANEL:Close()
    self:Remove()
end

vgui.Register("DiscreteUI.ToolTip", PANEL, "DiscreteUI.Panel")
