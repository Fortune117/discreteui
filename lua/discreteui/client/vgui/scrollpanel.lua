local PANEL = {}

AccessorFunc(PANEL, "m_scrollBarBackgroundColor", "ScrollBarBackgroundColor")
AccessorFunc(PANEL, "m_scrollBarBorderColor", "ScrollBarBorderColor")
AccessorFunc(PANEL, "m_scrollBarGripColor", "ScrollBarGripColor")
AccessorFunc(PANEL, "m_scrollBarGripHoveredColor", "ScrollBarGripHoveredColor")

local border = DiscreteUI.Settings.DefaultBorder
local gap = 2
function PANEL:Init()

    self:SetScrollBarBorderColor(DiscreteUI.Colors.Background)
    self:SetScrollBarBackgroundColor(DiscreteUI.Colors.Secondary)
    self:SetScrollBarGripColor(DiscreteUI.Colors.Primary)
    self:SetScrollBarGripHoveredColor(DiscreteUI.Colors.LightGrey)


    local sbar = self:GetVBar()
    sbar:SetHideButtons(true)
    function sbar.Paint(bar, w, h)
    	draw.RoundedBox(4, 0, 0, w, h, self:GetScrollBarBorderColor())
    	draw.RoundedBox(4, gap, gap, w - 2*gap, h - 2*gap, self:GetScrollBarBackgroundColor())
    end
    function sbar.btnGrip.Paint(grip, w, h)
        if grip:IsHovered() or grip.Depressed then
    	    draw.RoundedBox(4, gap, gap, w - gap*2, h - gap*2, self:GetScrollBarGripHoveredColor())
        else
            draw.RoundedBox(4, gap, gap, w - gap*2, h - gap*2, self:GetScrollBarGripColor())
        end
    end

end

vgui.Register("DiscreteUI.ScrollPanel", PANEL, "DScrollPanel")
