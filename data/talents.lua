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

local ActorTalents = require "engine.interface.ActorTalents" --for Perfect Counterspell

newTalentType{ type="role/combat", name = "combat", description = "Combat techniques" }
newTalentType{ type="role/damage", name = "danage", description = "Damage boost" }
newTalentType{ type="role/hp", name = "hp", description = "life boost" }
newTalentType{ type="role/summon", name = "summon", description = "summon creatures to fight for you." }

function setupSummon(self, m, x, y, no_control)
	m.no_inventory_access = true
	m.no_points_on_levelup = true
	m.save_hotkeys = true
	m.ai_state = m.ai_state or {}
	m.ai_state.tactic_leash = 100
	m:resolve() m:resolve(nil, true)
	game.zone:addEntity(game.level, m, "actor", x, y)
	game.level.map:particleEmitter(x, y, 1, "summon")

	-- Summons never flee
	m.ai_tactic = m.ai_tactic or {}
	m.ai_tactic.escape = 0
end


newTalent{
	name = "Boost Damage",
	type = {"role/damage", 1},
	points = 1,
	mode = "passive",
	info =  function(self, t)
		return "You got stronger through multiple adventures, and do double damage." 
	end,
	on_learn = function(self, t)
			self.combat.dam = self.combat.dam * 2
	end,
}

newTalent{
	name = "Boost HP",
	type = {"role/hp", 1},
	points = 1,
	mode = "passive",
	info =  function(self, t) return "You went through extreme endurance training, and can survive more hits." end,
	on_learn = function(self, t)
			self.max_life = self.max_life + 24 
			self.life = self.life  + 24 
	end,
}

newTalent {
	name = "Summon Dragon",
	type = {"role/summon", 1},
	points = 1,
	info = "Summon 1 loyal Dragon from a world you created. Dragons have 50 HP and do 4 Damage per attack.",
	action = function(self, t)
		if (WasCounterspelled(self)) then
			game.log(t.name .. " was Counterspelled!")
			return true;
		end
		local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
		local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to summon!")
			return
		end
		local NPC = require "mod.class.NPC"
		local m = NPC.new{
			type = "dragon", subtype = "dragon",
			name = "dragon",
			display = "D", color_r = self.color_r, color_b = self.color_b, color_g = self.color_g,
			desc = _t[[Big and Green!]],
			faction = self.faction,

			ai = "dumb_talented_simple", ai_state = { talent_in=3, },
			combat_armor = 0,

			level_range = {1, 1}, exp_worth = 0,
			rarity = 1,
			max_life = 50,
			combat = { dam=4 },

			summoner = self,
			ai_target = {actor=target}
		}
		setupSummon(self, m, x, y)
		return true
	end,	
}

newTalent {
	name = "Summon Dire Wolves",
	type = {"role/summon", 1},
	points = 1,
	info = "Summon 2 Dire Wolves from a world you created. Dire Wolves have 25 HP and do 2 Damage per attack.",
	action = function(self, t)
		if (WasCounterspelled(self)) then
			game.log(t.name .. " was Counterspelled!")
			return true;
		end
			local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
			local tx, ty, target = self:getTarget(tg)
			if not tx or not ty then return nil end
			local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
			local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				return
			end
			local NPC = require "mod.class.NPC"
			for i = 1, 2 do
				local m = NPC.new{
					type = "canine", subtype = "dire wolf",
					name = "dire wolf",
					display = "W", color_r = self.color_r, color_b = self.color_b, color_g = self.color_g,
					desc = _t[[Big and fluffy!]],
					faction = self.faction,

					ai = "dumb_talented_simple", ai_state = { talent_in=3, },

					level_range = {1, 1}, exp_worth = 0,
					rarity = 1,
					max_life = 25,
					combat = { dam=2 },
	
					summoner = self,
					ai_target = {actor=target}
				}
				setupSummon(self, m, x, y)
			end
			return true
		end,
}

newTalent {
	name = "Summon Goblins",
	type = {"role/summon", 1},
	points = 1,
	info = "Summon 4 loyal Goblins from a world you created. Goblins have 12 HP and do 1 Damage per attack.",
	action = function(self, t)
		if (WasCounterspelled(self)) then
			game.log(t.name .. " was Counterspelled!")
			return true;
		end
			local tg = {type="bolt", nowarning=true, range=self:getTalentRange(t), nolock=true, talent=t}
			local tx, ty, target = self:getTarget(tg)
			if not tx or not ty then return nil end
			local _ _, _, _, tx, ty = self:canProject(tg, tx, ty)
			local x, y = util.findFreeGrid(tx, ty, 5, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				return
			end
			local NPC = require "mod.class.NPC"
			for i = 1, 4 do
				local m = NPC.new{
					type = "goblin", subtype = "goblin",
					name = "goblin",
					display = "G", color_r = self.color_r, color_b = self.color_b, color_g = self.color_g,
					desc = _t[[Small and Green!]],
					faction = self.faction,
	
					ai = "dumb_talented_simple", ai_state = { talent_in=3, },
					combat_armor = 0,
	
					level_range = {1, 1}, exp_worth = 0,
					rarity = 1,
					max_life = 12,
					combat = { dam=1 },
	
					summoner = self,
					ai_target = {actor=target}
				}
				setupSummon(self, m, x, y)
			end
			return true
		end,
}

newTalent{
	name = "Fireball", --Fireball will one-shot goblins and dire wolves, not dragons.
	type = {"role/combat", 1},
	points = 1,
	range = 8,
	action = function(self, t)
		if (WasCounterspelled(self)) then
			game.log(t.name .. " was Counterspelled!")
			return true;
		end
		local tg = {type="ball", range=self:getTalentRange(t), radius=3, talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.FIRE, 25, {type="fire"})
		--self:unlearnTalent(t)
		return true
	end,
	info = function(self, t)
		return "A large ball of fire. Does 25 fire damage to all targest within a 3-tile radius."
	end,
}

newTalent{
	name = "Manabolt", --The counter to Counterspell. Let that eat a 4 point spell, so you can use your big spells later.
	type = {"role/combat", 1},
	points = 1,
	range = 4,
	permanent = true,
	is_beam_spell = true,
	action = function(self, t)
		if (WasCounterspelled(self)) then
			game.log(t.name .. " was Counterspelled!")
			return true;
		end
		local tg = {type="beam", range=self:getTalentRange(t), radius=1, talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.MANA, 4, {type="mana"})
		return true
	end,
	info = function(self, t)
		return "Manabolt does 4 mana damage to in a beam, and will not be forgotten on use."
	end,
}

newTalent{
	name = "Perfect Counterspell", --Effectively trades 1 of your talent points for one of your opponents. Is a pretty wide cover versus a more direct answer to a specific spell.
	type = {"role/combat", 1},
	points = 1,
	mode = "passive",
	action = function(self, t)
		game.logPlayer("This will automatically go off when your rival casts a spell.")
		return false
	end,
	info = function(self, t)
		return "You will automatically negate the first spell your opponent casts."
	end,
}

function WasCounterspelled(caster)
	if (caster.faction == "players") then
		--Rival, i think is always Entity 10.
		if (game.level.entities[10]:knowTalent(ActorTalents.T_PERFECT_COUNTERSPELL)) then
			game.level.entities[10]:unlearnTalent(ActorTalents.T_PERFECT_COUNTERSPELL, 1)
			return true;
		end
	else
		if (game.player:knowTalent(ActorTalents.T_PERFECT_COUNTERSPELL)) then
			--our counterspell has gone off.
			game.player:unlearnTalent(ActorTalents.T_PERFECT_COUNTERSPELL, 1)
			return true
		end
	end
	return false
end
