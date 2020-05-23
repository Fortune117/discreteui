local PANEL = {}

AccessorFunc(PANEL, "m_colorSelected", "SelectedColor")

local border = DiscreteUI.Settings.DefaultBorder
function PANEL:Init()
    self:SetSelectedColor(DiscreteUI.Colors.White)
    self:SetText("")
end

function PANEL:DoClick()
    self.list = vgui.Create("DFrame")
    self.list:DockPadding(0, 0, 0, border)
    self.list:SetSize(200, 250)
    self.list:SetDraggable(false)
    self.list:ShowCloseButton(false)
    self.list:SetTitle("")

    function self.list.Paint(list, w, h)
        draw.RoundedBox(self:GetRoundness(), 0, 0, w, h, DiscreteUI.Colors.Tertary)
    end

    local x, y = self:LocalToScreen(0, self:GetTall())
    self.list:SetPos(x, y)

    self.list:InvalidateLayout(true)
    self.list:MakePopup()
    self.list:SetIsMenu(true)

    function self.list.GetDeleteSelf(list)
        return list
    end
    RegisterDermaMenuForClose(self.list)

    self.colorMixer = vgui.Create("DColorMixer", self.list)
    self.colorMixer:Dock(FILL)					-- Make Mixer fill place of Frame
    self.colorMixer:SetPalette(true)  			-- Show/hide the palette 				DEF:true
    self.colorMixer:SetAlphaBar(true) 			-- Show/hide the alpha bar 				DEF:true
    self.colorMixer:SetWangs(true) 				-- Show/hide the R G B A indicators 	DEF:true
    self.colorMixer:SetColor(self:GetSelectedColor())

    function self.colorMixer.Think()
        self:SetSelectedColor(self.colorMixer:GetColor())
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(self:GetRoundness(),0, 0, w, h, self:GetSelectedColor())
end

vgui.Register("DiscreteUI.ColorSelector", PANEL, "DiscreteUI.Button")
