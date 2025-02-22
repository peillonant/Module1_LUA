local entitiesState = {}

entitiesState.IDLE = "IDLE"
entitiesState.ATTACK = "ATTACK"
entitiesState.WALK = "WALK"
entitiesState.SEARCHING = "SEARCHING"
entitiesState.TAUNTED = "TAUNTED"
entitiesState.HIT = "HIT"

entitiesState.type = {
    CHARACTER = "CHARACTER",
    ENEMIE = "ENEMIE",
    TOTEM = "TOTEM"
}

return entitiesState
