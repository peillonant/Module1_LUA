local entitiesState = {}

entitiesState.IDLE = "IDLE"
entitiesState.RUN = "RUN"
entitiesState.ATTACK = "ATTACK"
entitiesState.DEAD = "DEAD"
entitiesState.WALK = "WALK"
entitiesState.SEARCHING = "SEARCHING"
entitiesState.CHARGING = "CHARGING"
entitiesState.HIT = "HIT"

entitiesState.type = {
    CHARACTER = "CHARACTER",
    ENEMIE = "ENEMIE"
}

return entitiesState
