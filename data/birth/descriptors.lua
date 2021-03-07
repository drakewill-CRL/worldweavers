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

newBirthDescriptor{
	type = "base",
	name = "base",
	desc = {
	},
	experience = 1.0,

	copy = {
		max_level = 1,
		lite = 6,
		max_life = 100,
	},
}

newBirthDescriptor{
	type = "difficulty",
	name = "Easy",
	desc =
	{
		"You get 5 points to spend on talents. You opponent will have 2 random talents.",
	},
	copy = {
		charPoints = 5,
		rivalTalents = 2,
	},
} 

newBirthDescriptor{
	type = "difficulty",
	name = "Normal",
	desc =
	{
		"You get 3 points to spend on talents, as does your opponent.",
	},
	copy = {
		charPoints = 3,
		rivalTalents = 3,
	},
	
}

newBirthDescriptor{
	type = "difficulty",
	name = "Hard",
	desc =
	{
		"You get 2 points for talents, but your rival will have 4 random ones.",
	},
	copy = {
		charPoints = 2,
		rivalTalents = 4,
	},
	
}
