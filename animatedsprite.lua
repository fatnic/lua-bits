AnimatedSprite = Object:extend()

function AnimatedSprite:new(filename, h_frames, v_frames)

    self.spritesheet = love.graphics.newImage(filename)
    self.spritesheet_width = self.spritesheet:getWidth()
    self.spritesheet_height = self.spritesheet:getHeight()

    self.h_frames = h_frames or 1
    self.v_frames = v_frames or 1
    self.frame_width  = self.spritesheet_width  / self.h_frames
    self.frame_height = self.spritesheet_height / self.v_frames
    self.flip_h = false
    self.flip_v = false

    self.animations = {}
    self.current_anim = nil
    self.anim_timer = nil
    self.finished = false
    self.is_playing = false

    self.quad = love.graphics.newQuad(0, 0, self.frame_width, self.frame_height, self.spritesheet_width, self.spritesheet_height)

end

function AnimatedSprite:addAnimation(name, frames, fps, loop)
    local anim = {}
    anim.name = name
    if not frames then frames = string.format("1-%d", self.h_frames * self.v_frames) end
    anim.frames = self:getFrames(frames)
    anim.fps = fps
    anim.frame_time = 1 / fps
    anim.loop = loop or false
    self.animations[name] = anim
    if #anim.frames == 1 then self:setQuad(anim.frames[1]) end
end

function AnimatedSprite:getFrames(string)
    local frames = {}
    string = string:gsub("%s+", "")

    for s in string.gmatch(string, "([^,]+)") do
        if s:match("^%d+$") then 
            table.insert(frames, tonumber(s)) 
        elseif s:match("^%d+[-]%d+$") then 
            local s, e = s:match("^(%d+)[-](%d+)$")
            for i = tonumber(s), tonumber(e) do table.insert(frames, i) end
        end
    end

    return frames
end

function AnimatedSprite:play(name)
    if self.current_anim and self.current_anim.name == name then return end
    self.current_anim = self.animations[name]
    self.current_anim.anim_timer = 0
    self.current_anim.frame_counter = 0
    self.finished = false
    self.is_playing = true
end

function AnimatedSprite:stop()
    local name = self.current_anim.name
    self.current_anim = nil
    self.finished = true
    self.is_playing = false
    if self.finished_callback then self.finished_callback(name) end
end

function AnimatedSprite:update(dt)

    if not self.current_anim then return end
    if #self.current_anim.frames == 1 then return end

    self.current_anim.anim_timer = self.current_anim.anim_timer - dt 

    if self.current_anim.anim_timer <= 0 then

        self.current_anim.frame_counter = self.current_anim.frame_counter + 1
        self.current_anim.anim_timer = self.current_anim.frame_time

        if self.current_anim.frame_counter > #self.current_anim.frames then 
            if self.current_anim.loop then 
                self.current_anim.frame_counter = 1 
            else
                self:stop()
                return
            end
        end

        local current_frame = self.current_anim.frames[self.current_anim.frame_counter] 
        self:setQuad(current_frame)
    end

end

function AnimatedSprite:setQuad(frame_number)
    local frame_x = ((frame_number - 1) % self.h_frames) * self.frame_width
    local frame_y = math.floor((frame_number -1) / self.h_frames) * self.frame_height
    self.quad:setViewport(frame_x, frame_y, self.frame_width, self.frame_height)
end

function AnimatedSprite:draw(x, y, rot, sx, sy)

    local rot = rot or 0
    local sx = sx or 1
    local sy = sy or 1

    if self.current_anim then
        local fh = self.flip_h and -1 or 1
        local fv = self.flip_v and -1 or 1
        love.graphics.draw(self.spritesheet, self.quad, x, y, rot, sx * fh, sy * fv, self.frame_width / 2, self.frame_height / 2)
    end
end

function AnimatedSprite:finishedCallback(f)
    self.finished_callback = f
end

return AnimatedSprite
