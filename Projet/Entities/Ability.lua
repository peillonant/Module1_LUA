local abilities = {}

function abilities.ActivePower(myAbility)
    print(myAbility.name)
end

abilities.TANK = {
    name = "TANK",
    img = nil,
    cooldown = 1
}

abilities.CHARGE = {
    name = "CHARGE",
    img = nil,
    cooldown = 1
}

abilities.DASH = {
    name = "DASH",
    img = nil,
    cooldown = 1
}

abilities.INVISIBILITY = {
    name = "INVISIBILITY",
    img = nil,
    cooldown = 1
}

abilities.TOTEMTAUNT = {
    name = "TOTEMTAUNT",
    img = nil,
    cooldown = 1
}

abilities.TOTEMHEALT = {
    name = "TOTEMHEALT",
    img = nil,
    cooldown = 1
}

return abilities
