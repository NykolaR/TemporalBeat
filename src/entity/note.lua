local Class = require ("src.class")

local Note = Class.new ()

function Note:_init (section, note, speed)
    self.section = section
    self.progression = 0
    self.time = 0
    self.speed = 0.5
end

function Note:update (dt)
    if self.time < 1 then
        self.time = self.time + (dt * self.speed)
    else
        self.time = 0
    end

    self.progression = math.sin (self.time * (math.pi / 2))
end

local p = {x1 = 1, y1 = 2, x2 = 3, y2 = 4, x3 = 5, y3 = 6, x4 = 7, y4 = 8}

function Note:render ()
    -- progression: from 0 to 1
    -- render: from __ to __
    -- section order: x1,y1,x2,y2,x3,y3,x4,y1
    -- Grouped: 1-4, 2-3
    local p1x, p1y, p2x, p2y
    local s1, s2 = 1 - self.progression, self.progression
    p1x = self.section [p.x1] * s1 + self.section [p.x2] * s2
    p1y = self.section [p.y1] * s1 + self.section [p.y2] * s2
    p2x = self.section [p.x3] * s2 + self.section [p.x4] * s1
    p2y = self.section [p.y3] * s2 + self.section [p.y4] * s1

    love.graphics.setColor (255, 255, 255, 255)
    love.graphics.line (p1x, p1y, p2x, p2y)
end

return Note
