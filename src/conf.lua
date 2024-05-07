local libConf = {}

function libConf.fillConf(t) -- A method actually used to fill the table for getConf
    t.window = {}
    t.audio = {}
    t.modules = {}
end


function libConf.getConf(t) -- Explicit is better than implicit. We fill the configuration for any table here
    -- Setup game window
    t.window.title = "The Apul Game+"
    t.console = false
    t.gammacorrect = true
    t.window.width = 800
    t.window.height = 600
    t.window.borderless = false
    t.window.resizable = false
    t.window.fullscreen = false
    t.window.icon = "assets/image/icon.png"

    -- Setup misc
    t.identity = "TheApulGamePlus"
    t.version = "11.5"
    t.externalstorage = false

    -- Setup input
    t.accelerometerjoystick = false
    t.audio.mic = false

    -- Setup audio
    t.audio.mixwithsystem = true

    -- Setup modules
    t.modules.audio = true
    t.modules.data = true
    t.modules.event = true
    t.modules.font = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = false
    t.modules.keyboard = false
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = true
    t.modules.sound = true
    t.modules.system = false
    t.modules.thread = true
    t.modules.timer = true
    t.modules.touch = true
    t.modules.video = false
    t.modules.window = true
end

love.conf = libConf.getConf -- Where love.conf is really defined in

return libConf