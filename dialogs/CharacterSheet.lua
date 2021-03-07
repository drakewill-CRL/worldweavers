--TODO:
--Close window on losing focus

require "engine.class"
local Dialog = require "engine.ui.Dialog"
local Textzone = require "engine.ui.Textzone"
local Separator = require "engine.ui.Separator"
local List = require "engine.ui.List"
local Savefile = require "engine.Savefile"
local Map = require "engine.Map"
local ActorTalents = require "engine.interface.ActorTalents"

module(..., package.seeall, class.inherit(Dialog))

--reminder: to add new powers
--1: make talent for power
--2: add entry to generateList()
--3: add entry to use()

function _M:init(actor)
	self.actor = actor
	Dialog.init(self, _t"Character Sheet", 500, 500)

	self:generateList()

	self.c_desc = Textzone.new{width=self.iw, auto_height=true, text=[[You have arrived at the Throne of the Multiverse, just in time to stop your rival from conquering existance. What have you done in preparation to stop them? They have access to the same powers you did, and they may have done any of these themselves.]]}

	local existingUpgrades = ""
	for i,v in pairs(self.actor.talents) do
		existingUpgrades = existingUpgrades .. self.actor:getTalentFromId(i):info(self, i) .. "\n"
	end

	self.c_desc3 = Textzone.new{width=self.iw, auto_height=true, text=existingUpgrades}
	
	self.c_desc2 = Textzone.new{width=self.iw, auto_height=true, text=[[You have ]] .. actor.charPoints .. [[ unspent points]]}
	    self.c_list = List.new{width=self.iw, nb_items=#self.list, list=self.list, fct=function(item) self:use(item) end}
    
	self:loadUI{
		{left=0, top=0, ui=self.c_desc},
		{left=0, top=self.c_desc.h, ui=self.c_desc2},
		{left=0, top=self.c_desc2.h + 45, ui=self.c_desc3},
		{left=5, bottom = self.c_list.h,  padding_h=10, ui=Separator.new{dir="vertical", size=self.iw - 10}}, 
		{left=0, bottom=0, ui=self.c_list},
	}
	self:setFocus(self.c_list)
	self:setupUI(false, true)
end

--This is where actions/buttons/links occur from the c_list entry.
function _M:use(item)
	if not item then return end
	local act = item.action

	if act == "close" then
		game:unregisterDialog(self)
	elseif act == "sword" then
		if (self.actor.charPoints > 0) then
			game.logPlayer(self.actor, "You have a pointy sword!")
			self.actor.charPoints = self.actor.charPoints - 1
			self.actor:learnTalent(ActorTalents.T_BOOST_DAMAGE, true, 1)
			game:unregisterDialog(self)
			game:registerDialog(require("mod.dialogs.CharacterSheet").new(self.actor)) --This works, so tired of everything else NOT working that this is sufficient.

		end
	elseif act == "life" then
		if (self.actor.charPoints > 0) then
			game.logPlayer(self.actor, "You underwent extreme durability training!")
			self.actor.charPoints = self.actor.charPoints - 1
			self.actor:learnTalent(ActorTalents.T_BOOST_HP, true, 1)
			game:unregisterDialog(self)
			game:registerDialog(require("mod.dialogs.CharacterSheet").new(self.actor))

		end
	elseif act == "fireball" then
		if (self.actor.charPoints > 0) then
			game.logPlayer(self.actor, "You prepared a Fireball spell!")
			self.actor.charPoints = self.actor.charPoints - 1
			self.actor:learnTalent(ActorTalents.T_FIREBALL, true, 1)
			game:unregisterDialog(self)
			game:registerDialog(require("mod.dialogs.CharacterSheet").new(self.actor))

		end
	elseif act == "dragon" then
		if (self.actor.charPoints > 0) then
			game.logPlayer(self.actor, "You prepared a Summon Dragon spell!")
			self.actor.charPoints = self.actor.charPoints - 1
			self.actor:learnTalent(ActorTalents.T_SUMMON_DRAGON, true, 1)
			game:unregisterDialog(self)
			game:registerDialog(require("mod.dialogs.CharacterSheet").new(self.actor))

		end
	elseif act == "wolves" then
		if (self.actor.charPoints > 0) then
			game.logPlayer(self.actor, "You prepared a Summon Dire Wolves spell!")
			self.actor.charPoints = self.actor.charPoints - 1
			self.actor:learnTalent(ActorTalents.T_SUMMON_DIRE_WOLVES, true, 1)
			game:unregisterDialog(self)
			game:registerDialog(require("mod.dialogs.CharacterSheet").new(self.actor))
		end
	elseif act == "goblins" then
		if (self.actor.charPoints > 0) then
			game.logPlayer(self.actor, "You prepared a Summon Goblins spell!")
			self.actor.charPoints = self.actor.charPoints - 1
			self.actor:learnTalent(ActorTalents.T_SUMMON_GOBLINS, true, 1)
			game:unregisterDialog(self)
			game:registerDialog(require("mod.dialogs.CharacterSheet").new(self.actor))

		end
	elseif act == "counterspell" then
		if (self.actor.charPoints > 0) then
			game.logPlayer(self.actor, "You prepared a Perfect Counterspell!")
			self.actor.charPoints = self.actor.charPoints - 1
			self.actor:learnTalent(ActorTalents.T_PERFECT_COUNTERSPELL, true, 1)
			game:unregisterDialog(self)
			game:registerDialog(require("mod.dialogs.CharacterSheet").new(self.actor))

		end
	elseif act == "manabolt" then
		if (self.actor.charPoints > 0) then
			game.logPlayer(self.actor, "You mastered the Manabolt cantrip!")
			self.actor.charPoints = self.actor.charPoints - 1
			self.actor:learnTalent(ActorTalents.T_MANABOLT, true, 1)
			game:unregisterDialog(self)
			game:registerDialog(require("mod.dialogs.CharacterSheet").new(self.actor))

		end
	elseif act == "cheat" then
		game.logPlayer(self.actor, "#LIGHT_BLUE#You resurrect! CHEATER !")

		self:cleanActor()
		self:restoreResources()
		self:resurrectBasic()
	end
end

--Create the list of actions for the dialog.
function _M:generateList()
	--Most options are single-chance, not upgradeable.
	local list = {}
	if (not self.actor:knowTalent(ActorTalents.T_BOOST_DAMAGE))then list[#list+1] = {name="Strengthen Self", action="sword"} end
	if (not self.actor:knowTalent(ActorTalents.T_BOOST_HP))then list[#list+1] = {name="Endurance Training", action="life"} end
	if (not self.actor:knowTalent(ActorTalents.T_FIREBALL))then list[#list+1] = {name="Prepare Fireball Spell", action="fireball"} end
	if (not self.actor:knowTalent(ActorTalents.T_SUMMON_GOBLINS))then list[#list+1] = {name="Prepare Summon Gobins Spell", action="goblins"} end
	if (not self.actor:knowTalent(ActorTalents.T_SUMMON_DIRE_WOLVES))then list[#list+1] = {name="Prepare Summon Dire Wolves Spell", action="wolves"} end
	if (not self.actor:knowTalent(ActorTalents.T_SUMMON_DRAGON))then list[#list+1] = {name="Prepare Summon Dragon Spell", action="dragon"} end
	if (not self.actor:knowTalent(ActorTalents.T_PERFECT_COUNTERSPELL))then list[#list+1] = {name="Prepare Perfect Counterspell", action="counterspell"} end
	if (not self.actor:knowTalent(ActorTalents.T_MANABOLT))then list[#list+1] = {name="Master Manabolt", action="manabolt"} end
	list[#list+1] = {name="close screen", action="close"}
	self.list = list
end

function _M:hasBoughtEntry(entry)
	for i,v in ipairs(self.actor.upgrades) do
		if (v == entry) then
			return true
		end
	end
	return false
end
