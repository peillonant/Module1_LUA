local sceneState = {}

sceneState.MENU = "MENU"
sceneState.GAME = "GAME"
sceneState.NEWGAME = "NEWGAME"
sceneState.GAMEOVER = "GAMEOVER"
sceneState.WIN = "WIN"

sceneState.DEBUGGERMODE = false

sceneState.currentState = sceneState.MENU

return sceneState
