local generalMethod = require("GeneralMethod")
local myBestiary = require("Entities/Bestiary")
local rooms = {}

rooms.nbr = 10

rooms[1] = {
    nbrEnemy = 1,
    enemyList = {
        myBestiary.DUMMIES
    },
    enemyType = {myBestiary.type.NORMAL},
    positionEnemy = {
        {px = generalMethod.WORLDWIDTH / 2, py = generalMethod.WORLDHEIGHT / 2}
    },
    sizeX = 1,
    sizeY = 1,
    neighboor = 10,
    doorNextRoom = {
        Top = {},
        Right = {{Room = 3, PositionDoor = 1}},
        Bottom = {},
        Left = {{Room = 2, PositionDoor = 1}}
    }
}

rooms[2] = {
    nbrEnemy = 0,
    isShop = false,
    isTreasure = true,
    sizeX = 1,
    sizeY = 1,
    neighboor = 2,
    doorNextRoom = {
        Top = {},
        Right = {{Room = 1, PositionDoor = 1}},
        Bottom = {},
        Left = {}
    }
}

rooms[3] = {
    nbrEnemy = 2,
    enemyList = {
        myBestiary.DUMMIES,
        myBestiary.DUMMIES
    },
    enemyType = {
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL
    },
    positionEnemy = {
        {px = generalMethod.WORLDWIDTH / 3, py = generalMethod.WORLDHEIGHT},
        {px = generalMethod.WORLDWIDTH * 2 / 3, py = generalMethod.WORLDHEIGHT}
    },
    sizeX = 1,
    sizeY = 2,
    neighboor = 18,
    doorNextRoom = {
        Top = {},
        Right = {{Room = 4, PositionDoor = 1}},
        Bottom = {},
        Left = {{Room = 1, PositionDoor = 1}}
    }
}

rooms[4] = {
    nbrEnemy = 3,
    enemyList = {
        myBestiary.DUMMIES,
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE
    },
    enemyType = {
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL
    },
    positionEnemy = {
        {px = generalMethod.WORLDWIDTH, py = generalMethod.WORLDHEIGHT / 3},
        {px = generalMethod.WORLDWIDTH / 2, py = generalMethod.WORLDHEIGHT * 2 / 3},
        {px = generalMethod.WORLDWIDTH * 3 / 2, py = generalMethod.WORLDHEIGHT * 2 / 3}
    },
    sizeX = 2,
    sizeY = 1,
    neighboor = 11,
    doorNextRoom = {
        Top = {{Room = 7, PositionDoor = 1}, {Room = 7, PositionDoor = 2}},
        Right = {},
        Bottom = {{Room = 5, PositionDoor = 1}},
        Left = {{Room = 3, PositionDoor = 1}}
    }
}

rooms[5] = {
    nbrEnemy = 3,
    enemyList = {
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE
    },
    enemyType = {
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL,
        myBestiary.type.ELITE
    },
    positionEnemy = {
        {px = generalMethod.WORLDWIDTH / 4, py = generalMethod.WORLDHEIGHT * 2 / 3},
        {px = generalMethod.WORLDWIDTH / 2, py = generalMethod.WORLDHEIGHT / 3},
        {px = generalMethod.WORLDWIDTH * 3 / 4, py = generalMethod.WORLDHEIGHT * 2 / 3}
    },
    sizeX = 1,
    sizeY = 1,
    neighboor = 5,
    doorNextRoom = {
        Top = {{Room = 4, PositionDoor = 1}},
        Right = {},
        Bottom = {{Room = 6, PositionDoor = 1}},
        Left = {}
    }
}

rooms[6] = {
    nbrEnemy = 0,
    isShop = true,
    isTreasure = false,
    sizeX = 1,
    sizeY = 1,
    neighboor = 1,
    doorNextRoom = {
        Top = {{Room = 5, PositionDoor = 1}},
        Right = {},
        Bottom = {},
        Left = {}
    }
}

rooms[7] = {
    nbrEnemy = 5,
    enemyList = {
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE
    },
    enemyType = {
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL,
        myBestiary.type.ELITE,
        myBestiary.type.ELITE
    },
    positionEnemy = {
        {px = generalMethod.WORLDWIDTH * 3 / 4, py = generalMethod.WORLDHEIGHT / 4},
        {px = generalMethod.WORLDWIDTH * 5 / 4, py = generalMethod.WORLDHEIGHT / 4},
        {px = generalMethod.WORLDWIDTH * 2 / 3, py = generalMethod.WORLDHEIGHT * 2 / 3},
        {px = generalMethod.WORLDWIDTH, py = generalMethod.WORLDHEIGHT / 3},
        {px = generalMethod.WORLDWIDTH * 4 / 3, py = generalMethod.WORLDHEIGHT * 2 / 3}
    },
    sizeX = 2,
    sizeY = 2,
    neighboor = 252,
    doorNextRoom = {
        Top = {},
        Right = {{Room = 8, PositionDoor = 1}, {Room = 8, PositionDoor = 2}},
        Bottom = {{Room = 4, PositionDoor = 1}, {Room = 4, PositionDoor = 2}},
        Left = {{Room = 9, PositionDoor = 1}}
    }
}

rooms[8] = {
    nbrEnemy = 6,
    enemyList = {
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE,
        myBestiary.WITCH
    },
    enemyType = {
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL
    },
    positionEnemy = {
        {px = generalMethod.WORLDWIDTH * 3 / 4, py = generalMethod.WORLDHEIGHT / 4},
        {px = generalMethod.WORLDWIDTH * 5 / 4, py = generalMethod.WORLDHEIGHT / 4},
        {px = generalMethod.WORLDWIDTH * 2 / 3, py = generalMethod.WORLDHEIGHT * 2 / 3},
        {px = generalMethod.WORLDWIDTH, py = generalMethod.WORLDHEIGHT / 3},
        {px = generalMethod.WORLDWIDTH * 4 / 3, py = generalMethod.WORLDHEIGHT * 2 / 3},
        {px = generalMethod.WORLDWIDTH, py = generalMethod.WORLDHEIGHT / 2}
    },
    sizeX = 2,
    sizeY = 2,
    neighboor = 192,
    doorNextRoom = {
        Top = {},
        Right = {},
        Bottom = {},
        Left = {{Room = 7, PositionDoor = 1}, {Room = 7, PositionDoor = 2}}
    }
}

rooms[9] = {
    nbrEnemy = 8,
    enemyList = {
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE,
        myBestiary.SLIMBLUE,
        myBestiary.WITCH,
        myBestiary.WITCH,
        myBestiary.WITCH
    },
    enemyType = {
        myBestiary.type.ELITE,
        myBestiary.type.ELITE,
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL,
        myBestiary.type.NORMAL
    },
    positionEnemy = {
        {px = generalMethod.WORLDWIDTH / 2, py = generalMethod.WORLDHEIGHT / 2},
        {px = generalMethod.WORLDWIDTH / 2, py = generalMethod.WORLDHEIGHT / 2},
        {px = generalMethod.WORLDWIDTH, py = 50},
        {px = generalMethod.WORLDWIDTH * 3 / 2, py = generalMethod.WORLDHEIGHT / 2},
        {px = generalMethod.WORLDWIDTH * 3 / 2, py = generalMethod.WORLDHEIGHT / 2},
        {px = generalMethod.WORLDWIDTH * 2, py = 50},
        {px = generalMethod.WORLDWIDTH * 5 / 2, py = generalMethod.WORLDHEIGHT / 2},
        {px = generalMethod.WORLDWIDTH * 5 / 2, py = generalMethod.WORLDHEIGHT / 2}
    },
    sizeX = 3,
    sizeY = 2,
    neighboor = 824,
    doorNextRoom = {
        Top = {},
        Right = {{Room = 7, PositionDoor = 1}},
        Bottom = {},
        Left = {{Room = 10, PositionDoor = 1}}
    }
}

rooms[10] = {
    nbrEnemy = 1,
    enemyList = {
        myBestiary.SLIMBLUE
    },
    enemyType = {
        myBestiary.type.BOSS
    },
    positionEnemy = {{px = generalMethod.WORLDWIDTH * 3 / 4, py = generalMethod.WORLDHEIGHT / 4}},
    sizeX = 1,
    sizeY = 2,
    neighboor = 6,
    doorNextRoom = {
        Top = {},
        Right = {{Room = 9, PositionDoor = 1}},
        Bottom = {},
        Left = {}
    }
}

return rooms
