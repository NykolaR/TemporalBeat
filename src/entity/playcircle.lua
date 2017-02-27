local Class = require ("src.class")

local PlayCircle = Class.new ()

local Input = require ("src.boundary.input")
local Palettes = require ("src.boundary.palettes")

local oradius, a, b = 300, 350, 350

PlayCircle.colors = Palettes [2]

function PlayCircle:_init (arcs)
    self.outerCircle = {}
    self.innerCircle = {}
    self.playerCircle = {}
    self.connectLines = {}
    self.sections = {}

    self.arcs = arcs

    for i=0, arcs do
        local t1, t2 = math.pi * 2 * (i / arcs), math.pi * 2 * ((i + 1) / arcs)
        local t1s, t1c, t2s, t2c = math.sin (t1), math.cos (t1), math.sin (t2), math.cos (t2)

        local radius = oradius

        local x1, y1 = a + radius * t1c, b + radius * t1s
        local x2, y2 = a + radius * t2c, b + radius * t2s

        local cx1, cy1 = x1, y1

        table.insert (self.outerCircle, {x1, y1, x2, y2})

        radius = radius / 20

        x1, y1 = a + radius * t1c, b + radius * t1s
        x2, y2 = a + radius * t2c, b + radius * t2s

        local cx2, cy2 = x1, y1

        --table.insert (self.connectLines, {cx1, cy1, cx2, cy2})
        table.insert (self.connectLines, {cx2, cy2, cx1, cy1})

        if #self.connectLines > 1 then
            table.insert (self.sections, {self.connectLines [i][1], self.connectLines [i][2], self.connectLines [i][3], self.connectLines [i][4], cx1, cy1, cx2, cy2})
        end
        
        table.insert (self.innerCircle, {x1, y1, x2, y2})

        radius = oradius / 5 * 4

        x1, y1 = a + radius * t1c, b + radius * t1s
        x2, y2 = a + radius * t2c, b + radius * t2s

        table.insert (self.playerCircle, {x1, y1, x2, y2})
    end

    local temp = {}
    local size = #self.sections

    for i,sec in pairs (self.sections) do
        temp [size - i] = sec
    end

    self.sections = temp
    self.angle1 = 0
    self.angle2 = 0
end

function PlayCircle:update ()
    self:updateAngles ()
end

function PlayCircle:updateAngles ()
    local x1, y1 = Input.getLeftStick ()
    local x2, y2 = Input.getRightStick ()

    if x1 == 0 and y1 == 0 then
        self.angle1 = nil
    else
        self.angle1 = math.pi - math.atan2 (-y1, -x1)
    end

    if x2 == 0 and y2 == 0 then
        self.angle2 = nil
    else
        self.angle2 = math.pi - math.atan2 (-y2, -x2)
    end
end

function PlayCircle:render ()
    love.graphics.clear (self.colors [4])
    love.graphics.setBlendMode ("add")

    if self.angle1 then
        -- angle = 0 to 2pi
        -- section = 0 to 7
        local section1 = math.floor (self.angle1 * (self.arcs / (2 * math.pi)))

        if section1 == self.arcs then section1 = 0 end

        if section1 <= (self.arcs - 1) and section1 >= 0 then
            self:setColor (1, true)
            love.graphics.polygon ("fill", self.sections [section1])
        end
    end

    if self.angle2 then
        local section2 = math.floor (self.angle2 * (self.arcs / (2 * math.pi)))

        if section2 == self.arcs then section2 = 0 end

        if section2 <= (self.arcs - 1) and section2 >= 0 then
            self:setColor (2, true)
            love.graphics.polygon ("fill", self.sections [section2])
        end
    end

    --love.graphics.setColor (255, 255, 255)
    self:setColor (3, false)
    for i=1, #self.outerCircle do
        love.graphics.line (self.outerCircle [i])
        love.graphics.line (self.innerCircle [i])
        love.graphics.line (self.playerCircle [i])
        love.graphics.line (self.connectLines [i])
    end
end

function PlayCircle:setColor (index, transparent)
    if transparent then
        love.graphics.setColor (self.colors [index][1], self.colors [index][2], self.colors [index][3], 100)
    else
        love.graphics.setColor (self.colors [index][1], self.colors [index][2], self.colors [index][3], 255)
    end
end

return PlayCircle
