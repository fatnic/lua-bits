Object = require 'classic'

AnimatedSprite = require 'animatedsprite'

local expl = nil

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    anim_sprite = AnimatedSprite("assets/hero.png", 6, 5)
    anim_sprite:addAnimation("idle", "1-4", 10, true)
    anim_sprite:addAnimation("run", "7-12", 15, true)
    anim_sprite:addAnimation("swim", "19-24", 15, true)
    anim_sprite:addAnimation("punch", "25,26,27", 5, true)
    anim_sprite:play("run")
end

function love.update(dt)
    anim_sprite:update(dt)
end

function love.draw()
    love.graphics.clear(.25, .25, .25)
    anim_sprite:draw(100, 100, 0, 4, 4)
end

