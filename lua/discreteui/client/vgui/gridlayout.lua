local PANEL = {}

AccessorFunc(PANEL, "m_columns", "Columns")
AccessorFunc(PANEL, "m_matchHeightToWidth", "MatchHeightToWidth")

function PANEL:Init()
    self:SetColumns(2)
    self:SetMatchHeightToWidth(false)
end

function PANEL:PerformLayout(w, h)
    local columns = self:GetColumns()
    local border = self:GetBorder()
    local spaceX = self:GetSpaceX()
    local spaceY = self:GetSpaceY()
    local children = self:GetChildren()

    local numChildren = #children
    local childSize = (w - border*2 - (columns-1)*spaceX)/columns

    local x = 0
    local y = 0

    for k,v in ipairs(children) do
        v:SetWide(childSize)
        if self:GetMatchHeightToWidth() then
            v:SetTall(childSize)
        end

        local childX = border + (x > 0 and (spaceX*x + childSize*x) or 0)
        local childY = border + (y > 0 and (spaceY*y + v:GetTall()*y) or 0)
        v:SetPos(childX, childY)

        x = x + 1
        if x == columns then
            y = y + 1
            x = 0
        end
    end

    self:SizeToChildren(false, true)
    self:SetTall(self:GetTall() + border)
end

vgui.Register("DiscreteUI.GridLayout", PANEL, "DIconLayout")
