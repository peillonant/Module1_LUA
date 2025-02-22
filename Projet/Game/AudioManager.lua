local mySettings = require("Menu/SettingsManager")

local sound = {}

sound.musicVolume = 0.90
sound.sfxVolume = 1.0

function sound.InitSound()
    -- SoundGame
    sound.soundGame = {}
    sound.soundGame[1] = love.audio.newSource("Asset/Audio/Game/Song_1.mp3", "stream")
    sound.soundGame[2] = love.audio.newSource("Asset/Audio/Game/Song_2.mp3", "stream")
    sound.soundGame[3] = love.audio.newSource("Asset/Audio/Game/Song_3.mp3", "stream")

    sound.soundGame[1]:play()
    sound.currentMusicIndex = 1


    -- Abilities sound
    sound.dash = love.audio.newSource("Asset/Audio/Abilities/Dash.wav", "static")
    sound.wand = love.audio.newSource("Asset/Audio/Abilities/MagicWand.wav", "static")

    -- Event sound
    sound.hit = love.audio.newSource("Asset/Audio/Event/Hit.mp3", "static")
    sound.death = love.audio.newSource("Asset/Audio/Event/Death.wav", "static")
    sound.doorsOpen = love.audio.newSource("Asset/Audio/Event/Doors.ogg", "static")
    sound.endDoor = love.audio.newSource("Asset/Audio/Event/EndDoor.wav", "static")

    -- Props sound
    sound.coin = love.audio.newSource("Asset/Audio/Props/Coin.wav", "static")
    sound.buy = love.audio.newSource("Asset/Audio/Props/ShopBuy.wav", "static")
end

function sound.playSound(soundToPlay)
    soundToPlay:setVolume(sound.sfxVolume * mySettings.effectSound)
    soundToPlay:play()
end

function sound.UpdateBackgroundMusic()

    sound.soundGame[sound.currentMusicIndex]:setVolume(sound.musicVolume * mySettings.masterSound)

    if not sound.soundGame[sound.currentMusicIndex]:isPlaying() then
        sound.currentMusicIndex = (sound.currentMusicIndex % #sound.soundGame) + 1
        sound.soundGame[sound.currentMusicIndex]:play()
    end
end

return sound