class = require 'middleclass'
AnimatedSprite = require 'animatedsprite'

function love.load()
    anim_sprite = AnimatedSprite:new("assets/testsheet.png", 4, 4)
    anim_sprite:addAnimation("cycle", "1-5", 1, true)
    anim_sprite:play("cycle")
end

function love.update(dt)
    anim_sprite:update(dt)
end

function love.draw()
    anim_sprite:draw(0, 0)
end

