-- ToME - Tales of Middle-Earth
-- Copyright (C) 2009 - 2019 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

require "engine.class"
local ActorAI = require "engine.interface.ActorAI"
local Faction = require "engine.Faction"
local Dialog = require "engine.ui.Dialog"
local ActorTalents = require "engine.interface.ActorTalents"
require "mod.class.Actor"

module(..., package.seeall, class.inherit(mod.class.Actor, engine.interface.ActorAI))

function _M:init(t, no_default)
	mod.class.Actor.init(self, t, no_default)
	ActorAI.init(self, t)
end

function _M:act()
	-- Do basic actor stuff
	if not mod.class.Actor.act(self) then return end

	-- Compute FOV, if needed
	self:computeFOV(self.sight or 20)

	-- Let the AI think .... beware of Shub !
	-- If AI did nothing, use energy anyway
	self:doAI()
	if not self.energy.used then self:useEnergy() end
end

--- Called by ActorLife interface
-- We use it to pass aggression values to the AIs
function _M:onTakeHit(value, src)
	if not self.ai_target.actor and src.targetable then
		self.ai_target.actor = src
	end

	return mod.class.Actor.onTakeHit(self, value, src)
end

function _M:tooltip()
	local str = mod.class.Actor.tooltip(self)
	return str..([[

	Target: %s
	UID: %d]]):format(
	self.ai_target.actor and self.ai_target.actor.name or "none",
	self.uid)
end

--Hook called after entity is resolved. Using this to apply talents to rivals.
function _M:addedToLevel(level, x, y)
	game.log("Created NPC!")
	if (self.subtype ~= "worldweaver") then
		return
	end
	--i think i need a list of talents to look through.
	local talentRef = {}

	local talentcounter = 1
	for k in pairs(game.player.talents_def) do
		talentRef[talentcounter] = k
		talentcounter = talentcounter + 1
	end

	for  i = 1, game.player.rivalTalents do
		local picked = false
		while (picked == false) do
			local talentID = rng.range(1, #talentRef)  --probably a better place for that value.
		 	if (self:knowTalent(talentRef[talentID])) then
		 		--re-roll
		 	else
		 		--learn it
		 		self:learnTalent(talentRef[talentID], 1)
		 		picked = true
				 game.log("Rival learned " .. talentRef[talentID])
		 	end
		end
	end
	
end

 function _M:die(src)
 	engine.interface.ActorLife.die(self, src)
 	return true
 end
