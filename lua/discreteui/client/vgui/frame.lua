local PANEL = {}

DiscreteUI:CreateFont("DiscreteUI.Frame.TitleFont", 52, 0, false, {}, DiscreteUI.Fonts.TitleFont)
DiscreteUI:CreateFont("DiscreteUI.Frame.ButtonFont", 48, 0, false, {}, DiscreteUI.Fonts.TitleFont)

AccessorFunc(PANEL, "m_topBarColor", "TopBarColor")
AccessorFunc(PANEL, "m_backgroundColor", "BackgroundColor")

local border = DiscreteUI.Settings.DefaultBorder

function PANEL:Init()

    self:SetTopBarColor(DiscreteUI.Colors.Secondary)
    self:SetBackgroundColor(DiscreteUI.Colors.Background)

    self.topBar = vgui.Create("DPanel", self)
    self.topBar:Dock(TOP)
    function self.topBar.Paint(topBarm, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, self:GetTopBarColor(), true, true, false, false)
    end

    self.closeButton = vgui.Create("DiscreteUI.Button", self.topBar)
    self.closeButton:Dock(RIGHT)
    self.closeButton:DockMargin(0, border, border, border)
    self.closeButton:SetContentAlignment(5)
    self.closeButton:SetHoveredColor(DiscreteUI.Colors.Red)
    self.closeButton:SetImageIdleColor(DiscreteUI.Colors.LightGrey)
    self.closeButton:SetFont("DiscreteUI.Frame.ButtonFont")
    self.closeButton:SetImage("discrete/icons/x.png")
    self.closeButton:SetText("")
    function self.closeButton.DoClick()
        self:Remove()
    end

    self.topTitle = vgui.Create("DLabel", self.topBar)
    self.topTitle:Dock(FILL)
    self.topTitle:DockMargin(10, 0, 0, border)
    self.topTitle:SetContentAlignment(4)
    self.topTitle:SetTextColor(DiscreteUI.Colors.White)
    self.topTitle:SetFont("DiscreteUI.Frame.TitleFont")

    self.highlightBar = vgui.Create("DPanel", self)
    self.highlightBar:Dock(TOP)
    function self.highlightBar.Paint(bar, w, h)
        surface.SetDrawColor(DiscreteUI.Colors.Highlight)
        surface.DrawRect(0, 0, w, h)
    end
    self:DockPadding(0, 0, 0, 0)
end

function PANEL:SetTitle(title)
    self.topTitle:SetText(title)
end

function PANEL:PerformLayout(w, h)

    self.lblTitle:SetTall(0)
	self.btnClose:SetTall(0)
	self.btnMaxim:SetTall(0)
	self.btnMinim:SetTall(0)

    self.topBar:SetTall(54)
    self.highlightBar:SetTall(4)

    local buttonSize =self.topBar:GetTall() - border*2
    self.closeButton:SetWide(buttonSize)
    self.closeButton:SetImageSize(buttonSize*0.7)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, self:GetBackgroundColor())
end

vgui.Register("DiscreteUI.Frame", PANEL, "DFrame")
