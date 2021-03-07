local Talents = require("engine.interface.ActorTalents")

newEntity{
	define_as = "BASE_RIVAL",
	type = "humanoid", subtype = "worldweaver",
    name="Rival", --Make a Resolver to pick a random name?
	display = "@", color=colors.RED,
	desc = _t[[You rival! They're trying to conquer the multiverse!]],

	ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	--stats = { str=5, dex=5, con=5 },
	combat_armor = 0,
    level_range = {1, 1}, exp_worth = 0,
	rarity = 1,
    --They have the same baseline stats as the player.
	max_life = 100,
	combat = { dam=8 },
    --TODO: resolver for random bonuses
}