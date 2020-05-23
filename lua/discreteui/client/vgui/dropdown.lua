local PANEL = {}

DiscreteUI:CreateFont("DiscreteUI.DropDown.Title", 19, 200)

AccessorFunc(PANEL, "m_optionFont", "OptionFont", FORCE_STRING)
AccessorFunc(PANEL, "m_optionPlaceHolder", "PlaceHolderText", FORCE_STRING)
AccessorFunc(PANEL, "m_optionColor", "OptionColor")
AccessorFunc(PANEL, "m_optionBackgroundColor", "OptionBackgroundColor")

local border = DiscreteUI.Settings.DefaultBorder
function PANEL:Init()
    self:SetOptionFont("DiscreteUI.DropDown.Title")
    self:SetPlaceHolderText("Choose an Option")
    self:SetOptionColor(DiscreteUI.Colors.Secondary)
    self:SetOptionBackgroundColor(DiscreteUI.Colors.Background)

    self._activeOption = nil
    self.options = {}
end

function PANEL:SetActiveOption(optionData)
    self:SetText(optionData.name)

    self._activeOption = optionData
    self:OnOptionSet(optionData)
end

function PANEL:GetActiveOption()
    return self._activeOption
end

function PANEL:SetActiveOptionID(id)
    for k,v in pairs(self.options) do
        if v.id == id then
            self:SetActiveOption(v)
            return
        end
    end
end

function PANEL:SetPlaceHolderText(text)
    self.m_optionPlaceHolder = text
    self:SetText(text)
end

function PANEL:SetOptionFont(font)
    self.m_optionFont = font
    self:SetFont(font)
end

//For override
function PANEL:OnOptionSet(optionData)
end

function PANEL:DoClick()
    if self.inputDelay and CurTime() < self.inputDelay then return end
    if IsValid(self.list) then
        self:RemoveList()
        return
    end
    self:CreateOptionsList()
end

function PANEL:RemoveList()
    if IsValid(self.list) then
        self.list:Remove()
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
        option:SetIdleColor(self:GetOptionColor())
        option:SetFont(self:GetOptionFont())
        option:SetText(v.name)

        if v.description and #v.description > 0 then
            option:SetToolTip(v.description)
            option:SetTooltipPanelOverride("DiscreteUI.ToolTip")
        end

        option.optionData = v
        function option.DoClick(opt)
            self:SetActiveOption(opt.optionData)
            self:RemoveList()
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

//Option data is of the form:
-- data =
-- {
--     name = "some name",
--     description = "some description", //Will be displayed as a tooltip
--     id = "some_id",
--     data = {}
-- }
function PANEL:AddOption(optionData, select)
    select = select or false
    table.insert(self.options, optionData)

    if select then
        self:SetActiveOption(optionData)
    end
end

vgui.Register("DiscreteUI.DropDown", PANEL, "DiscreteUI.Button")
