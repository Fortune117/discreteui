local border = DiscreteUI.Settings.DefaultBorder
local PANEL = {}

DiscreteUI:CreateFont("DiscreteUI.PropertySheet.Tab", 34, 200, false, {}, DiscreteUI.Fonts.TitleFont)

function PANEL:Init()

    self:SetText("")

    self.title = vgui.Create("DLabel", self)
    self.title:Dock(FILL)
    self.title:SetFont("DiscreteUI.PropertySheet.Tab")
    self.title:SetText("")
    self.title:SetTextColor(DiscreteUI.Colors.White)
    self.title:SetContentAlignment(5)

    self.propertySheet = nil
    self.sheetPanel = nil

end

function PANEL:SetUp(propertySheet, title, sheetPanel)
    self.title:SetText(title)
    self.propertySheet = propertySheet
    self.sheetPanel = sheetPanel
end

function PANEL:PerformLayout(w, h)
    surface.SetFont(self.title:GetFont())
    local tWidth, tHeight = surface.GetTextSize(self.title:GetText())
    self:SetWide(tWidth + border*4)
end

function PANEL:DoClick()
    if self.propertySheet then
        self.propertySheet:SetActiveTab(self)
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(self:GetRoundness(),0, 0, w, h, self:GetCurrentColor(), true, true, false, false)

    if !self:GetImage() then return end
    surface.SetDrawColor(self:GetImageColor())
    surface.SetMaterial(self:GetImage())

    local size = self:GetImageSize()
    local x = w/2 - size/2
    local y = h/2 - size/2

    surface.DrawTexturedRect(x, y, size, size)
end

vgui.Register("DiscreteUI.PropertySheet.Tab", PANEL, "DiscreteUI.Button")

local PANEL = {}

AccessorFunc(PANEL, "m_activeColor", "ActiveTabColor")
AccessorFunc(PANEL, "m_inactiveTabColor", "InactiveTabColor")

function PANEL:Init()

    self:SetActiveTabColor(DiscreteUI.Colors.Primary)
    self:SetInactiveTabColor(DiscreteUI.Colors.Secondary)

    self.sheetPanel = vgui.Create("DiscreteUI.Panel", self)
    self.sheetPanel:Dock(TOP)
    function self.sheetPanel:Paint(w, h)
        draw.RoundedBoxEx(self:GetRoundness(),0, 0, w, h, self:GetBackgroundColor(), true, true, false, false)
    end

    self.sheetHighlight = vgui.Create("DiscreteUI.Panel", self)
    self.sheetHighlight:Dock(TOP)
    self.sheetHighlight:SetBackgroundColor(DiscreteUI.Colors.Highlight)
    function self.sheetHighlight:Paint(w, h)
        surface.SetDrawColor(self:GetBackgroundColor())
        surface.DrawRect(0, 0, w, h)
    end

    self.canvas = vgui.Create("DiscreteUI.Panel", self)
    self.canvas:Dock(FILL)
    self.canvas:DockMargin(border, border, border, border)
    self.canvas:SetBackgroundColor(ColorAlpha(DiscreteUI.Colors.Primary, 0))

    self.items = {}
    self._activeTab = nil
end

function PANEL:SetHighlightColor(color)
    self.sheetHighlight:SetBackgroundColor(color)
end

function PANEL:GetHighlightColor()
    return self.sheetHighlight:GetBackgroundColor()
end

function PANEL:SetActiveTab(tab)
    if self._activeTab != tab then

        local oldTab = nil
        if IsValid(self._activeTab) then
            oldTab = self._activeTab
            self._activeTab.sheetPanel:SetVisible(false)
            self._activeTab.sheetPanel:Dock(NODOCK)
            self._activeTab:SetIdleColor(self:GetInactiveTabColor())
        end

        self._activeTab = tab
        self._activeTab.sheetPanel:SetVisible(true)
        self._activeTab.sheetPanel:Dock(FILL)
        self._activeTab:SetIdleColor(self:GetActiveTabColor())

        self:OnActiveTabChanged(oldTab, self._activeTab)

    end
end

//For override
function PANEL:OnActiveTabChanged(oldTab, newTab)
end

function PANEL:GetActiveTab()
    return self._activeTab
end

function PANEL:AddTab(tab)
    tab:Dock(LEFT)
    tab:DockMargin(0, 0, border, 0)
end

function PANEL:AddSheet(panel, title, icon, toolTip)

    if ( !IsValid( panel ) ) then
		ErrorNoHalt( "DPropertySheet:AddSheet tried to add invalid panel!" )
		debug.Trace()
		return
	end

	local sheet = {}

	sheet.title = title

	sheet.tab = vgui.Create( "DiscreteUI.PropertySheet.Tab", self.sheetPanel )
	sheet.tab:SetTooltip( toolTip )
	sheet.tab:SetUp( self, title, panel )
    sheet.tab:SetIdleColor(self:GetInactiveTabColor())

	sheet.panel = panel
	sheet.panel:SetPos( 0, 0 )
	sheet.panel:SetVisible( false )

	panel:SetParent( self.canvas )

	table.insert( self.items, sheet )

	if ( !self:GetActiveTab() ) then
		self:SetActiveTab( sheet.tab )
	end

	self:AddTab(sheet.tab)

	return sheet

end

function PANEL:PerformLayout(w, h)

    self.sheetPanel:SetTall(34)
    self.sheetHighlight:SetTall(3)

end

vgui.Register("DiscreteUI.PropertySheet", PANEL)
