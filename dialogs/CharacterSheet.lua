--TODO:
--Close window on losing focus

require "engine.class"
local Dialog = require "engine.ui.Dialog"
local Textzone = require "engine.ui.Textzone"
local Separator = require "engine.ui.Separator"
local List = require "engine.ui.List"
local Savefile = require "engine.Savefile"
local Map = require "engine.Map"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(actor)
	self.actor = actor
	Dialog.init(self, _t"Character Sheet", 500, 300)

	self:generateList()

	self.c_desc = Textzone.new{width=self.iw, auto_height=true, text=[[The Character Sheet Goes Here]]}

	local existingUpgrades = ""
	if (#self.actor.upgrades == 0) then
		existingUpgrades = "You have not yet decided on your upgrades."
	else
		for i,v in ipairs(self.actor.upgrades) do
			existingUpgrades = existingUpgrades .. v .. "\n"
		end
	end

	self.c_desc3 = Textzone.new{width=self.iw, auto_height=true, text=existingUpgrades}
	
	self.c_desc2 = Textzone.new{width=self.iw, auto_height=true, text=[[You have ]] .. actor.charPoints .. [[ unspent points]]}
	--TODO: set up a description of what you have here.
    self.c_list = List.new{width=self.iw, nb_items=#self.list, list=self.list, fct=function(item) self:use(item) end}
    
    --TODO: make a list of all available talents
    --TODO: split up a few different window panes with separators.
    --TODO: set up events to notice when an item gets clicked?

	self:loadUI{
		{left=0, top=0, ui=self.c_desc},
		{left=0, top=self.c_desc.h, ui=self.c_desc2},
		{left=0, top=self.c_desc2.h + 13, ui=self.c_desc3},
		{left=5, top=self.c_desc3.h, padding_h=10, ui=Separator.new{dir="vertical", size=self.iw - 10}},
		{left=0, bottom=0, ui=self.c_list},
	}
	--self:setFocus(self.c_list)
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
			self.actor.combat.dam = self.actor.combat.dam + 3
			self.actor.upgrades[#self.actor.upgrades+1] = "sword"

			self.c_desc2 = Textzone.new{width=self.iw, auto_height=true, text=[[You have ]] .. self.actor.charPoints .. [[ unspent points]]}

			--self.changed = true
			--not these 2 in either order.
			--self:display()
			--self:setupUI(false, false)
			--self:generate()
			--game:registerDialog(self);
			--core.display.forceRedraw()
			--self:init(self.actor) --closer to wokring, but throws errors when drawing the new window.
			--self.uis.:generate()
			--self:setupUI(false, true)
			--for i, ui in ipairs(self.uis) do
				--ui.ui:generate()
			--end
			--game:registerDialog(self) -- does create a new dialog, but doesn't include updated data. weird.
			self.actor.changed = true
			game:unregisterDialog(self)
			game:registerDialog(require("mod.dialogs.CharacterSheet").new(self.actor)) --This works, so tired of everything else NOT working that this is sufficient.

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
	--SHould probably check what's already purchased, and not make repeatable options.
	local list = {}
	if (not self:hasBoughtEntry("sword")) then list[#list+1] = {name="Buy a Pointy Sword", action="sword"} end
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