local PANEL = {}

local border = DiscreteUI.Settings.DefaultBorder

function PANEL:AddActiveOption(key)
    if self.options[key] then
        self.options[key].active = true
    end
end

function PANEL:AddActiveOptionID(id)
    for k,v in pairs(self.options) do
        if v.id == id then
            v.active = true
            return
        end
    end
end

function PANEL:RemoveActiveOption(key)
    if self.options[key] then
        self.options[key].active = false
    end
end

function PANEL:GetActiveOptions()
    local temp = {}
    for k,v in ipairs(self.options) do
        if v.active then
            table.insert(temp, v)
        end
    end
    return temp
end

function PANEL:AddOption(optionData, active)
    active = active or false
    optionData.active = active
    table.insert(self.options, optionData)
end

function PANEL:RemoveAllActiveOptions()
    for k,v in pairs(self.options) do
        v.active = false
    end
end

function PANEL:CreateOptionsList()
    self.list = vgui.Create("DFrame")
    self.list:DockPadding(0, 0, 0, border)
    self.list:SetWide(self:GetWide())
    self.list:SetDraggable(false)
    self.list:ShowCloseButton(false)
    self.list:SetTitle("")
    for k,v in ipairs(self.options) do
        local option = vgui.Create("DiscreteUI.Button", self.list)
        option:Dock(TOP)
        option:SetTall(25)
        option:DockMargin(border, border, border, 0)
        option:SetDisabledColor(self:GetOptionColor())
        option:SetHoveredColor(self:GetOptionColor())
        option:SetIdleColor(self:GetOptionColor())
        option:SetFont(self:GetOptionFont())
        option:SetText(v.name)
        option:SetRoundness(4)

        if v.description and #v.description > 0 then
            option:SetToolTip(v.description)
            option:SetTooltipPanelOverride("DiscreteUI.ToolTip")
        end

        option.optionData = v


        local checkBox = vgui.Create("DiscreteUI.CheckBox", option)
        checkBox:Dock(RIGHT)
        checkBox:SetRoundness(4)
        checkBox:SetChecked(v.active)

        function checkBox.OnChecked(box, isChecked)
            if option.optionData.active then
                self:RemoveActiveOption(k)
                option.optionData.active = false
            else
                self:AddActiveOption(k)
                option.optionData.active = true
            end
        end

        function option.DoClick(opt)
            checkBox:DoClick()
        end

        function option.PerformLayout( opt, w, h)
            checkBox:SetWide(checkBox:GetTall())
        end

    end

    function self.list.Paint(list, w, h)
        draw.RoundedBox(self:GetRoundness(), 0, 0, w, h, self:GetOptionBackgroundColor())
    end

    local x, y = self:LocalToScreen(0, self:GetTall())
    self.list:SetPos(x, y)

    self.list:InvalidateLayout(true)
    self.list:SizeToChildren(false, true)
    self.list:MakePopup()
    self.list:SetIsMenu(true)

    function self.list.GetDeleteSelf(list)
        self.inputDelay = CurTime() + 0.2
        return list
    end

    RegisterDermaMenuForClose(self.list)

end

vgui.Register("DiscreteUI.DropDownCheckList", PANEL, "DiscreteUI.DropDown")
