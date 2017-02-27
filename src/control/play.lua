local Class = require ("src.class")

local Play = Class.new ()

local PlayCircle = require ("src.entity.playcircle")
local Note = require ("src.entity.note")

local sect = 1

function Play:_init (arcs)
    self.playcircle = PlayCircle (arcs)
    self.note = Note (self.playcircle.sections [sect])
end

function Play:update (dt)
    self.note:update (dt)
    self.playcircle:update ()

    if self.note.progression == 0 then
        sect = sect + 3
        if sect >= self.playcircle.arcs then
            sect = sect - self.playcircle.arcs
        end
        self.note.section = self.playcircle.sections [sect]
    end
end

function Play:render ()
    self.playcircle:render ()
    self.note:render ()
end

return Play
