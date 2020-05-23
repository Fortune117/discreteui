local PANEL = {}

AccessorFunc(PANEL, "m_expanded", "Expanded", FORCE_BOOL)
AccessorFunc(PANEL, "m_animTime", "AnimTime", FORCE_NUMBER)

DiscreteUI:CreateFont("DiscreteUI.CollapsibleCategory.ButtonFont", 48, 0, false, {}, DiscreteUI.Fonts.TitleFont)

local border = DiscreteUI.Settings.DefaultBorder
function PANEL:Init()

    self:SetAnimTime(0.2)

    self.topBar = vgui.Create("DiscreteUI.Button", self)
    self.topBar:Dock(TOP)
    self.topBar:SetTall(32)
    self.topBar:SetFont("DiscreteUI.CollapsibleCategory.ButtonFont")

    function self.topBar.DoClick(bar)
        self:SetExpanded(!self:GetExpanded())
    end

    self.anim = Derma_Anim("DiscreteUI.AnimSlide", self, self.Animate)

    self.canvas = vgui.Create("DiscreteUI.Panel", self)
    self.canvas:Dock(FILL)
    self.canvas:DockMargin(border, border, border, border)
    self.canvas.Paint = function() end

    function self.canvas.InvalidateLayout(canvas, b)
        self:InvalidateLayout(b)
    end

    self:SetExpanded(false)

    self:InvalidateLayout()

end

function PANEL:SetText(text)
    self.topBar:SetText(text)
end

function PANEL:GetText()
    return self.topBar:GetText()
end

function PANEL:SetBarHeight(h)
    self.topBar:SetTall(h)
end

function PANEL:SetTitle(text)
    self.topBar:SetText(text)
end

function PANEL:SetTextColor(color)
    self.topBar:SetTextColor(color)
end

function PANEL:SetFont(font)
    self.topBar:SetFont(font)
end

function PANEL:SetExpanded(b, fast)
    fast = fast or false
    self.m_expanded = b
    self.canvas:SetVisible(b)

    if fast then
        self:QuickExpand()
    else
        self:DoExpansion()
    end
end

function PANEL:GetTargetSize()
    local newHeight = self.topBar:GetTall()
    for k,v in pairs(self.canvas:GetChildren()) do
        local x, y = v:GetPos()
        y = y + self.topBar:GetTall()
        newHeight = math.max(newHeight, y + v:GetTall())
    end
    newHeight = newHeight + border*2
    return newHeight
end

function PANEL:PerformLayout(w, h)

    if self:GetExpanded() and !self.anim:Active() then
        if math.abs(self:GetTall() - self:GetTargetSize()) > 0.05 then
            self:SetExpanded(true, true)
        end
    end

    self.anim:Run()
end

function PANEL:QuickExpand()
    self.anim:Start( 0.05, {oldHeight = self:GetTall()})
    self:InvalidateLayout()
    self:InvalidateParent()
end

function PANEL:DoExpansion()
    self.anim:Start( self:GetAnimTime(), {oldHeight = self:GetTall()})
    self:InvalidateLayout()
    self:InvalidateParent()
end

function PANEL:Animate(anim, delta, data)

    self:InvalidateLayout()
    self:InvalidateParent()

    if ( anim.Started ) then
        if ( self:GetExpanded() ) then
            local newHeight = self.topBar:GetTall()
            for k,v in pairs(self.canvas:GetChildren()) do
                local x, y = v:GetPos()
                y = y + self.topBar:GetTall()
                newHeight = math.max(newHeight, y + v:GetTall())
            end
            data.newHeight = newHeight + border*2
        else
            data.newHeight = self.topBar:GetTall()
        end
    end

    self:SetTall( Lerp( delta, data.oldHeight, data.newHeight ) )

    data.oldHeight = self:GetTall()


end

function PANEL:Add( panelClass )
    local pnl = vgui.Create(panelClass, self.canvas)

    return pnl
end

vgui.Register("DiscreteUI.CollapsibleCategory", PANEL, "DiscreteUI.Panel")
