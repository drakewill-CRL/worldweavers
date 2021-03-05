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

newTalentType{ type="role/combat", name = "combat", description = "Combat techniques" }
newTalentType{ type="role/damage", name = "danage", description = "Damage boost" }
newTalentType{ type="role/hp", name = "hp", description = "life boost" }
newTalentType{ type="role/summon", name = "summon", description = "summon creatures to fight for you." }

newTalent{
	name = "Kick",
	type = {"role/combat", 1},
	points = 1,
	cooldown = 6,
	power = 2,
	range = 1,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		target:knockback(self.x, self.y, 2 + self:getDex())
		return true
	end,
	info = function(self, t)
		return "Kick!"
	end,
}

newTalent{
	name = "Acid Spray",
	type = {"role/combat", 1},
	points = 1,
	cooldown = 6,
	power = 2,
	range = 6,
	action = function(self, t)
		local tg = {type="ball", range=self:getTalentRange(t), radius=1, talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.ACID, 1 + self:getDex(), {type="acid"})
		return true
	end,
	info = function(self, t)
		return "Zshhhhhhhhh!"
	end,
}

--start my code here
newTalent{
	name = "Boost Damage",
	type = {"role/damage", 1},
	points = 1,
	mode = "passive",
	info =  function(self, t)
		return "You worked on hitting harder, and do double damage." 
	end,
	on_learn = function(self, t)
			self.combat.dam = self.combat.dam * 2  --2 ^ (GetTalentLevel(t) + 1)
	end,
}

newTalent{
	name = "Boost HP",
	type = {"role/hp", 1},
	points = 1,
	mode = "passive",
	info =  function(self, t) return "You worked on living harder, and can take more hits." end,
	on_learn = function(self, t)
			self.max_life = self.max_life * 1.5 -- 2 ^ (GetTalentLevel(t) + 1)
			self.life = self.life * 1.5 --scale up proportionally
	end,
}

newTalent {
	name = "Summon Goblins",
	type = {"role/summon", 1},
	points = 1,
	cooldown = 600,
	mode = "activated",
	info = "Summon loyal Goblins from a world you created. Goblin summons focus on quantity over quality.",
	action = function(self, t)
	end,	
}
