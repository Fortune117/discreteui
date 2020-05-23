
function DiscreteUI:CreateFont(name, size, weight, useScreenScale, data, font)
    font = font or self.Fonts.Primary
    useScreenScale = useScreenScale or false
    data = data or {}

    local fontTable = {
        font = font,
        extended = true,
        size = useScreenScale and ScreenScale(size) or size,
        weight = weight
    }

    table.Add(fontTable, data)

    surface.CreateFont( name, fontTable )

end


function DiscreteUI:LerpColor(t, from, to)
    return Color(Lerp(t, from.r, to.r), Lerp(t, from.g, to.g), Lerp(t, from.b, to.b), Lerp(t, from.a, to.a))
end
