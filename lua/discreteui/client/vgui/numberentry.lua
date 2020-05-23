local PANEL = {}

AccessorFunc(PANEL,"m_allowDecimals", "AllowDecimals", FORCE_BOOL)
AccessorFunc(PANEL,"m_forcePositive", "ForcePositive", FORCE_BOOL)

function PANEL:Init()
    self:SetNumeric(true)
    self:SetAllowDecimals(true)
    self:SetForcePositive(true)
end

function PANEL:HasDecimal()
    local val = self:GetValue()
    print(val)
    print(string.find(val, ".", 1))
    if  string.find(val, ".", 1, true) != nil then
        return true
    end
    return false
end

function PANEL:HasMinusSign()
    local val = self:GetValue()
    if #val == 0 then return false end
    if string.sub(val, 1, 1) == "-" then
        return true
    end
    return false
end

function PANEL:AllowInput(char)
    local val = self:GetValue()
    if self:GetForcePositive() and char == "-" then return true end
    if !self:GetAllowDecimals() and char == "." then return true end
    if self:HasDecimal() and char == "." then return true end
    if self:CheckNumeric(char) then return true end

    return false
end

vgui.Register("DiscreteUI.NumberEntry", PANEL, "DiscreteUI.TextEntry")
