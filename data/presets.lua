local addonName, ns = ...

function ns:GetPresets(class)
	class = class or select(2, UnitClass("player"))
	return ns.presets[class]
end

ns.presets = {
	DEATHKNIGHT = {
		{
			name = "Blood",
			wizardName = "Blood: Survival",
			specialization = 250,
			default = true,
			weights = {
				ITEM_MOD_EXTRA_ARMOR_SHORT = 10,
				RESISTANCE0_NAME = 7.29,
				ITEM_MOD_STRENGTH_SHORT = 6.67,
				ITEM_MOD_MASTERY_RATING_SHORT = 4.17,
				ITEM_MOD_HASTE_RATING_SHORT = 4.06,
				ITEM_MOD_VERSATILITY = 3.96,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 3.75,
				ITEM_MOD_STAMINA_SHORT = 3.13,
				ITEM_MOD_CRIT_RATING_SHORT = 3.02,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 2.6,
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2.08,
				ITEM_MOD_CR_AVOIDANCE_SHORT = 1.56,
			},
		},
		{
			name = "Blood",
			wizardName = "Blood: Offensive",
			specialization = 250,
			weights = {
				ITEM_MOD_STRENGTH_SHORT = 10,
				ITEM_MOD_EXTRA_ARMOR_SHORT = 8,
				RESISTANCE0_NAME = 7,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.8,
				ITEM_MOD_CRIT_RATING_SHORT = 3.6,
				ITEM_MOD_HASTE_RATING_SHORT = 3.2,
				ITEM_MOD_STAMINA_SHORT = 3,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 2.5,
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2,
				ITEM_MOD_CR_AVOIDANCE_SHORT = 1.5,
			},
		},
		{
			name = "Frost",
			wizardName = "Frost: Single-Target",
			specialization = 251,
			default = true,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 15.5,
				ITEM_MOD_STRENGTH_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 7,
				ITEM_MOD_HASTE_RATING_SHORT = 4.5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.4,
				ITEM_MOD_VERSATILITY = 4,
				ITEM_MOD_CRIT_RATING_SHORT = 3.4,
				ITEM_MOD_MASTERY_RATING_SHORT = 3.3,
			},
		},
		{
			name = "Frost",
			wizardName = "Frost: Multi-Target",
			specialization = 251,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 15.5,
				ITEM_MOD_STRENGTH_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 7,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.5,
				ITEM_MOD_MASTERY_RATING_SHORT = 4.1,
				ITEM_MOD_HASTE_RATING_SHORT = 3.9,
				ITEM_MOD_VERSATILITY = 3.8,
				ITEM_MOD_CRIT_RATING_SHORT = 3.6,
			},
		},
		{
			name = "Frost",
			wizardName = "Frost (Dual-Wield)",
			specialization = 251,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 9.5,
				ITEM_MOD_STRENGTH_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 7.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 4.8,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.4,
				ITEM_MOD_VERSATILITY = 4.1,
				ITEM_MOD_HASTE_RATING_SHORT = 4,
				ITEM_MOD_CRIT_RATING_SHORT = 3.2,
			},
		},
		{
			name = "Unholy",
			wizardName = "Unholy",
			specialization = 252,
			default = true,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 7.8,
				ITEM_MOD_STRENGTH_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 7.5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5.3,
				ITEM_MOD_MASTERY_RATING_SHORT = 4.2,
				ITEM_MOD_CRIT_RATING_SHORT = 3.9,
				ITEM_MOD_VERSATILITY = 3.8,
				ITEM_MOD_HASTE_RATING_SHORT = 3.7,
			},
		},
	},
	DRUID = {
		{
			name = "Balance",
			wizardName = "Balance: Euphoria",
			specialization = 102,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.4,
				ITEM_MOD_HASTE_RATING_SHORT = 4.9,
				ITEM_MOD_CRIT_RATING_SHORT = 4.8,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.7,
				ITEM_MOD_VERSATILITY = 4.2,
			},
		},
		{
			name = "Balance",
			wizardName = "Balance: Stellar Flare",
			specialization = 102,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.3,
				ITEM_MOD_HASTE_RATING_SHORT = 5.2,
				ITEM_MOD_CRIT_RATING_SHORT = 5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.7,
				ITEM_MOD_VERSATILITY = 4.1,
			},
		},
		{
			name = "Feral",
			wizardName = "Feral: Single-Target",
			specialization = 103,
			default = true,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 9.3,
				ITEM_MOD_AGILITY_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9.1,
				ITEM_MOD_CRIT_RATING_SHORT = 4.2,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 3.7,
				ITEM_MOD_VERSATILITY = 3.6,
				ITEM_MOD_HASTE_RATING_SHORT = 3.1,
			},
		},
		{
			name = "Feral",
			wizardName = "Feral: Multi-Target",
			specialization = 103,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 9.3,
				ITEM_MOD_AGILITY_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.4,
				ITEM_MOD_CRIT_RATING_SHORT = 4.3,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 3.9,
				ITEM_MOD_VERSATILITY = 3.5,
				ITEM_MOD_HASTE_RATING_SHORT = 2.5,
			},
		},
		{
			name = "Guardian",
			wizardName = "Guardian",
			specialization = 104,
			default = true,
			weights = {
				RESISTANCE0_NAME = 10,
				ITEM_MOD_EXTRA_ARMOR_SHORT = 4,
				ITEM_MOD_AGILITY_SHORT = 3.5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 3.25,
				ITEM_MOD_MASTERY_RATING_SHORT = 2.2,
				ITEM_MOD_STAMINA_SHORT = 2,
				ITEM_MOD_HASTE_RATING_SHORT = 1.5,
				ITEM_MOD_VERSATILITY = 1.95,
				ITEM_MOD_CRIT_RATING_SHORT = 1.05,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 1,
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1,
				ITEM_MOD_CR_AVOIDANCE_SHORT = 0.75,
			},
		},
		{
			name = "Restoration",
			wizardName = "Restoration: Haste",
			specialization = 105,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_SPIRIT_SHORT = 6,
				ITEM_MOD_HASTE_RATING_SHORT = 5.5,
				ITEM_MOD_MASTERY_RATING_SHORT = 5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.5,
				ITEM_MOD_CRIT_RATING_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.5,
			},
		},
		{
			name = "Restoration",
			wizardName = "Restoration: Mastery",
			specialization = 105,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_SPIRIT_SHORT = 6,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.5,
				ITEM_MOD_HASTE_RATING_SHORT = 5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.5,
				ITEM_MOD_CRIT_RATING_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.5,
			},
		},
	},
	HUNTER = {
		{
			name = "BeastMastery",
			wizardName = "BeastMastery",
			specialization = 253,
			default = true,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 9.3,
				ITEM_MOD_AGILITY_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9,
				ITEM_MOD_MASTERY_RATING_SHORT = 4.6,
				ITEM_MOD_HASTE_RATING_SHORT = 4.5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.3,
				ITEM_MOD_CRIT_RATING_SHORT = 3.8,
				ITEM_MOD_VERSATILITY = 3.6,
			},
		},
		{
			name = "Marksmanship",
			wizardName = "Marksmanship: Lone Wolf",
			specialization = 254,
			default = true,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 27.3,
				ITEM_MOD_AGILITY_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.7,
				ITEM_MOD_CRIT_RATING_SHORT = 4.6,
				ITEM_MOD_MASTERY_RATING_SHORT = 4.5,
				ITEM_MOD_VERSATILITY = 4.3,
				ITEM_MOD_HASTE_RATING_SHORT = 2.9,
			},
		},
		{
			name = "Marksmanship",
			wizardName = "Marksmanship: Pet",
			specialization = 254,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 20.4,
				ITEM_MOD_AGILITY_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 8.9,
				ITEM_MOD_CRIT_RATING_SHORT = 4.3,
				ITEM_MOD_HASTE_RATING_SHORT = 4.1,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.9,
				ITEM_MOD_MASTERY_RATING_SHORT = 3.3,
			},
		},
		{
			name = "Survival",
			wizardName = "Survival",
			specialization = 255,
			default = true,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 6.7,
				ITEM_MOD_AGILITY_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 8.9,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5.9,
				ITEM_MOD_CRIT_RATING_SHORT = 3.4,
				ITEM_MOD_VERSATILITY = 3.3,
				ITEM_MOD_MASTERY_RATING_SHORT = 2.9,
				ITEM_MOD_HASTE_RATING_SHORT = 2.2,
			},
		},
	},
	MAGE = {
		{
			name = "Arcane",
			wizardName = "Arcane",
			specialization = 62,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.8,
				ITEM_MOD_HASTE_RATING_SHORT = 5.2,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.7,
				ITEM_MOD_CRIT_RATING_SHORT = 4.5,
				ITEM_MOD_VERSATILITY = 4.2,
			},
		},
		{
			name = "Fire",
			wizardName = "Fire: Pre-Tier 17",
			specialization = 63,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9.1,
				ITEM_MOD_CRIT_RATING_SHORT = 8,
				ITEM_MOD_MASTERY_RATING_SHORT = 6.7,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5.7,
				ITEM_MOD_HASTE_RATING_SHORT = 5.2,
				ITEM_MOD_VERSATILITY = 4.5,
			},
		},
		{
			name = "Fire",
			wizardName = "Fire: Tier 17 Single-Target",
			specialization = 63,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9.1,
				ITEM_MOD_CRIT_RATING_SHORT = 6.2,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.6,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5.2,
				ITEM_MOD_HASTE_RATING_SHORT = 5.1,
				ITEM_MOD_VERSATILITY = 4.2,
			},
		},
		{
			name = "Fire",
			wizardName = "Fire: Tier 17 Multi-Target",
			specialization = 63,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 7.7,
				ITEM_MOD_CRIT_RATING_SHORT = 6.6,
				ITEM_MOD_HASTE_RATING_SHORT = 5.8,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5.3,
				ITEM_MOD_VERSATILITY = 4.1,
			},
		},
		{
			name = "Frost",
			wizardName = "Frost",
			specialization = 64,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9.1,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5.4,
				ITEM_MOD_CRIT_RATING_SHORT = 4.8,
				ITEM_MOD_HASTE_RATING_SHORT = 4.3,
				ITEM_MOD_VERSATILITY = 4.2,
				ITEM_MOD_MASTERY_RATING_SHORT = 3.9,
			},
		},
	},
	MONK = {
		{
			name = "Brewmaster",
			wizardName = "Brewmaster: Survival",
			specialization = 268,
			default = true,
			weights = {
				ITEM_MOD_EXTRA_ARMOR_SHORT = 10,
				RESISTANCE0_NAME = 8,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.1,
				ITEM_MOD_AGILITY_SHORT = 4.5,
				ITEM_MOD_STAMINA_SHORT = 3.25,
				ITEM_MOD_VERSATILITY = 2.9,
				ITEM_MOD_CRIT_RATING_SHORT = 2.8,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 2,
				ITEM_MOD_HASTE_RATING_SHORT = 1.2,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 1,
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1,
				ITEM_MOD_CR_AVOIDANCE_SHORT = 0.75,
			},
		},
		{
			name = "Brewmaster",
			wizardName = "Brewmaster: Crit",
			specialization = 268,
			weights = {
				ITEM_MOD_EXTRA_ARMOR_SHORT = 10,
				RESISTANCE0_NAME = 8,
				ITEM_MOD_AGILITY_SHORT = 4.5,
				ITEM_MOD_CRIT_RATING_SHORT = 3,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 2.5,
				ITEM_MOD_VERSATILITY = 2.4,
				ITEM_MOD_STAMINA_SHORT = 2.25,
				ITEM_MOD_MASTERY_RATING_SHORT = 2,
				ITEM_MOD_HASTE_RATING_SHORT = 1.2,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 1,
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1,
				ITEM_MOD_CR_AVOIDANCE_SHORT = 0.6,
			},
		},
		{
			name = "Brewmaster",
			wizardName = "Brewmaster (Dual-Wield): Survival",
			specialization = 268,
			weights = {
				ITEM_MOD_EXTRA_ARMOR_SHORT = 10,
				RESISTANCE0_NAME = 8,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.1,
				ITEM_MOD_AGILITY_SHORT = 4.5,
				ITEM_MOD_STAMINA_SHORT = 3.25,
				ITEM_MOD_VERSATILITY = 2.9,
				ITEM_MOD_CRIT_RATING_SHORT = 2.8,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 2,
				ITEM_MOD_HASTE_RATING_SHORT = 1.2,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 1,
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1,
				ITEM_MOD_CR_AVOIDANCE_SHORT = 0.75,
			},
		},
		{
			name = "Brewmaster",
			wizardName = "Brewmaster (Dual-Wield): Crit",
			specialization = 268,
			weights = {
				ITEM_MOD_EXTRA_ARMOR_SHORT = 10,
				RESISTANCE0_NAME = 8,
				ITEM_MOD_AGILITY_SHORT = 4.5,
				ITEM_MOD_CRIT_RATING_SHORT = 3,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 2.5,
				ITEM_MOD_VERSATILITY = 2.4,
				ITEM_MOD_STAMINA_SHORT = 2.25,
				ITEM_MOD_MASTERY_RATING_SHORT = 2,
				ITEM_MOD_HASTE_RATING_SHORT = 1.2,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 1,
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1,
				ITEM_MOD_CR_AVOIDANCE_SHORT = 0.6,
			},
		},
		{
			name = "Mistweaver",
			wizardName = "Mistweaver",
			specialization = 270,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_SPIRIT_SHORT = 6,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5.5,
				ITEM_MOD_CRIT_RATING_SHORT = 5,
				ITEM_MOD_HASTE_RATING_SHORT = 4.5,
				ITEM_MOD_VERSATILITY = 4,
				ITEM_MOD_MASTERY_RATING_SHORT = 3.5,
			},
		},
		{
			name = "Windwalker",
			wizardName = "Windwalker: Single-Target",
			specialization = 269,
			default = true,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 26.8,
				ITEM_MOD_AGILITY_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5,
				ITEM_MOD_CRIT_RATING_SHORT = 4.1,
				ITEM_MOD_HASTE_RATING_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.9,
				ITEM_MOD_MASTERY_RATING_SHORT = 2.3,
			},
		},
		{
			name = "Windwalker",
			wizardName = "Windwalker: Multi-Target",
			specialization = 269,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 26.8,
				ITEM_MOD_AGILITY_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9.1,
				ITEM_MOD_HASTE_RATING_SHORT = 5.4,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5,
				ITEM_MOD_VERSATILITY = 4.3,
				ITEM_MOD_CRIT_RATING_SHORT = 4.2,
				ITEM_MOD_MASTERY_RATING_SHORT = 1.5,
			},
		},
		{
			name = "Windwalker",
			wizardName = "Windwalker (Dual-Wield): Single-Target",
			specialization = 269,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 23.2,
				ITEM_MOD_AGILITY_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5,
				ITEM_MOD_CRIT_RATING_SHORT = 4.1,
				ITEM_MOD_HASTE_RATING_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.9,
				ITEM_MOD_MASTERY_RATING_SHORT = 2.3,
			},
		},
		{
			name = "Windwalker",
			wizardName = "Windwalker (Dual-Wield): Multi-Target",
			specialization = 269,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 23.2,
				ITEM_MOD_AGILITY_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9.1,
				ITEM_MOD_HASTE_RATING_SHORT = 5.4,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5,
				ITEM_MOD_VERSATILITY = 4.3,
				ITEM_MOD_CRIT_RATING_SHORT = 4.2,
				ITEM_MOD_MASTERY_RATING_SHORT = 1.5,
			},
		},
	},
	PALADIN = {
		{
			name = "Holy",
			wizardName = "Holy: Crit",
			specialization = 65,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_SPIRIT_SHORT = 6,
				ITEM_MOD_CRIT_RATING_SHORT = 5.5,
				ITEM_MOD_HASTE_RATING_SHORT = 5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.5,
				ITEM_MOD_MASTERY_RATING_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.5,
			},
		},
		{
			name = "Holy",
			wizardName = "Holy: Mastery",
			specialization = 65,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_SPIRIT_SHORT = 6,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.5,
				ITEM_MOD_HASTE_RATING_SHORT = 5,
				ITEM_MOD_CRIT_RATING_SHORT = 4.5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.5,
			},
		},
		{
			name = "Holy",
			wizardName = "Holy: Output",
			specialization = 65,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_SPIRIT_SHORT = 6,
				ITEM_MOD_CRIT_RATING_SHORT = 5.5,
				ITEM_MOD_MASTERY_RATING_SHORT = 5,
				ITEM_MOD_HASTE_RATING_SHORT = 4.5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.5,
			},
		},
		{
			name = "Protection",
			wizardName = "Protection: Holy Shield",
			specialization = 66,
			default = true,
			weights = {
				ITEM_MOD_EXTRA_ARMOR_SHORT = 10,
				ITEM_MOD_STRENGTH_SHORT = 7.5,
				RESISTANCE0_NAME = 6,
				ITEM_MOD_HASTE_RATING_SHORT = 6,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.9,
				ITEM_MOD_STAMINA_SHORT = 5,
				ITEM_MOD_VERSATILITY = 4.5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.4,
				ITEM_MOD_CRIT_RATING_SHORT = 4,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 2,
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2,
				ITEM_MOD_CR_AVOIDANCE_SHORT = 1.5,
			},
		},
		{
			name = "Protection",
			wizardName = "Protection: Seraphim",
			specialization = 66,
			weights = {
				ITEM_MOD_EXTRA_ARMOR_SHORT = 10,
				ITEM_MOD_STRENGTH_SHORT = 7.5,
				RESISTANCE0_NAME = 6,
				ITEM_MOD_HASTE_RATING_SHORT = 6,
				ITEM_MOD_VERSATILITY = 4.5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.4,
				ITEM_MOD_CRIT_RATING_SHORT = 4.3,
				ITEM_MOD_MASTERY_RATING_SHORT = 4.2,
				ITEM_MOD_STAMINA_SHORT = 4,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 2,
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2,
				ITEM_MOD_CR_AVOIDANCE_SHORT = 1.5,
			},
		},
		{
			name = "Protection",
			wizardName = "Protection: Empowered Seals",
			specialization = 66,
			weights = {
				ITEM_MOD_EXTRA_ARMOR_SHORT = 10,
				ITEM_MOD_STRENGTH_SHORT = 7.5,
				RESISTANCE0_NAME = 6,
				ITEM_MOD_HASTE_RATING_SHORT = 6,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.9,
				ITEM_MOD_STAMINA_SHORT = 5,
				ITEM_MOD_VERSATILITY = 4.5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.1,
				ITEM_MOD_CRIT_RATING_SHORT = 4,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 2,
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2,
				ITEM_MOD_CR_AVOIDANCE_SHORT = 1.5,
			},
		},
		{
			name = "Retribution",
			wizardName = "Retribution",
			specialization = 70,
			default = true,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 20.9,
				ITEM_MOD_STRENGTH_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.6,
				ITEM_MOD_HASTE_RATING_SHORT = 5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.8,
				ITEM_MOD_CRIT_RATING_SHORT = 4.7,
				ITEM_MOD_VERSATILITY = 4.3,
			},
		},
	},
	PRIEST = {
		{
			name = "Discipline",
			wizardName = "Discipline: Mastery",
			specialization = 256,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_SPIRIT_SHORT = 7,
				ITEM_MOD_MASTERY_RATING_SHORT = 6,
				ITEM_MOD_CRIT_RATING_SHORT = 5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.5,
				ITEM_MOD_HASTE_RATING_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.5,
			},
		},
		{
			name = "Discipline",
			wizardName = "Discipline: Balanced",
			specialization = 256,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_SPIRIT_SHORT = 6,
				ITEM_MOD_CRIT_RATING_SHORT = 5.5,
				ITEM_MOD_MASTERY_RATING_SHORT = 5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.5,
				ITEM_MOD_HASTE_RATING_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.5,
			},
		},
		{
			name = "Holy",
			wizardName = "Holy: Multistrike/Haste",
			specialization = 257,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_SPIRIT_SHORT = 6,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5.5,
				ITEM_MOD_HASTE_RATING_SHORT = 5,
				ITEM_MOD_MASTERY_RATING_SHORT = 4.5,
				ITEM_MOD_CRIT_RATING_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.5,
			},
		},
		{
			name = "Holy",
			wizardName = "Holy: Multistrike/Mastery",
			specialization = 257,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_SPIRIT_SHORT = 7.5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 6,
				ITEM_MOD_MASTERY_RATING_SHORT = 5,
				ITEM_MOD_HASTE_RATING_SHORT = 4.5,
				ITEM_MOD_CRIT_RATING_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.5,
			},
		},
		{
			name = "Holy",
			wizardName = "Holy: Crit",
			specialization = 257,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_SPIRIT_SHORT = 6,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5.5,
				ITEM_MOD_CRIT_RATING_SHORT = 5,
				ITEM_MOD_HASTE_RATING_SHORT = 4.5,
				ITEM_MOD_MASTERY_RATING_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.5,
			},
		},
		{
			name = "Shadow",
			wizardName = "Shadow: Clarity of Power",
			specialization = 258,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.3,
				ITEM_MOD_HASTE_RATING_SHORT = 5,
				ITEM_MOD_CRIT_RATING_SHORT = 4.9,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.8,
				ITEM_MOD_VERSATILITY = 4.2,
			},
		},
		{
			name = "Shadow",
			wizardName = "Shadow: Auspicious Spirits",
			specialization = 258,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_CRIT_RATING_SHORT = 7.5,
				ITEM_MOD_HASTE_RATING_SHORT = 5.9,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.7,
				ITEM_MOD_VERSATILITY = 4,
				ITEM_MOD_MASTERY_RATING_SHORT = 1,
			},
		},
	},
	ROGUE = {
		{
			name = "Assassination",
			wizardName = "Assassination",
			specialization = 259,
			default = true,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 7.5,
				ITEM_MOD_AGILITY_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9.1,
				ITEM_MOD_CRIT_RATING_SHORT = 4.8,
				ITEM_MOD_MASTERY_RATING_SHORT = 4.7,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.2,
				ITEM_MOD_VERSATILITY = 4,
				ITEM_MOD_HASTE_RATING_SHORT = 3.4,
			},
		},
		{
			name = "Combat",
			wizardName = "Combat",
			specialization = 260,
			default = true,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 7.8,
				ITEM_MOD_AGILITY_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9.1,
				ITEM_MOD_HASTE_RATING_SHORT = 4.5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.3,
				ITEM_MOD_CRIT_RATING_SHORT = 4.2,
				ITEM_MOD_VERSATILITY = 4.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 3.9,
			},
		},
		{
			name = "Subtlety",
			wizardName = "Subtlety",
			specialization = 261,
			default = true,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 10.7,
				ITEM_MOD_AGILITY_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 7.8,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.1,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.9,
				ITEM_MOD_CRIT_RATING_SHORT = 4.2,
				ITEM_MOD_HASTE_RATING_SHORT = 4.1,
				ITEM_MOD_VERSATILITY = 4,
			},
		},
	},
	SHAMAN = {
		{
			name = "Elemental",
			wizardName = "Elemental",
			specialization = 262,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9.1,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 6.6,
				ITEM_MOD_HASTE_RATING_SHORT = 5,
				ITEM_MOD_CRIT_RATING_SHORT = 4.4,
				ITEM_MOD_MASTERY_RATING_SHORT = 4.2,
				ITEM_MOD_VERSATILITY = 3.8,
			},
		},
		{
			name = "Enhancement",
			wizardName = "Enhancement",
			specialization = 263,
			default = true,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 5.1,
				ITEM_MOD_AGILITY_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9.1,
				ITEM_MOD_HASTE_RATING_SHORT = 4.9,
				ITEM_MOD_MASTERY_RATING_SHORT = 4.1,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4,
				ITEM_MOD_CRIT_RATING_SHORT = 3.6,
				ITEM_MOD_VERSATILITY = 3.5,
			},
		},
		{
			name = "Restoration",
			wizardName = "Restoration: Mastery",
			specialization = 264,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_SPIRIT_SHORT = 6,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.5,
				ITEM_MOD_HASTE_RATING_SHORT = 5,
				ITEM_MOD_CRIT_RATING_SHORT = 4.5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.5,
			},
		},
		{
			name = "Restoration",
			wizardName = "Restoration: Crit",
			specialization = 264,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9,
				ITEM_MOD_SPIRIT_SHORT = 6,
				ITEM_MOD_CRIT_RATING_SHORT = 5.5,
				ITEM_MOD_HASTE_RATING_SHORT = 5,
				ITEM_MOD_MASTERY_RATING_SHORT = 4.5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4,
				ITEM_MOD_VERSATILITY = 3.5,
			},
		},
	},
	WARLOCK = {
		{
			name = "Affliction",
			wizardName = "Affliction",
			specialization = 265,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9.1,
				ITEM_MOD_HASTE_RATING_SHORT = 6.3,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.9,
				ITEM_MOD_CRIT_RATING_SHORT = 4.8,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.6,
				ITEM_MOD_VERSATILITY = 4.2,
			},
		},
		{
			name = "Demonology",
			wizardName = "Demonology",
			specialization = 266,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.6,
				ITEM_MOD_HASTE_RATING_SHORT = 5.1,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5,
				ITEM_MOD_CRIT_RATING_SHORT = 4.8,
				ITEM_MOD_VERSATILITY = 4.3,
			},
		},
		{
			name = "Destruction",
			wizardName = "Destruction",
			specialization = 267,
			default = true,
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10,
				ITEM_MOD_SPELL_POWER_SHORT = 9.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 6.7,
				ITEM_MOD_CRIT_RATING_SHORT = 6.1,
				ITEM_MOD_HASTE_RATING_SHORT = 5.3,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.4,
				ITEM_MOD_VERSATILITY = 4.2,
			},
		},
	},
	WARRIOR = {
		{
			name = "Arms",
			wizardName = "Arms",
			specialization = 71,
			default = true,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 25.1,
				ITEM_MOD_STRENGTH_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 8.9,
				ITEM_MOD_CRIT_RATING_SHORT = 5.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.5,
				ITEM_MOD_VERSATILITY = 4.2,
				ITEM_MOD_HASTE_RATING_SHORT = 3.7,
			},
		},
		{
			name = "Fury",
			wizardName = "Fury",
			specialization = 72,
			default = true,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 18.3,
				ITEM_MOD_STRENGTH_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9,
				ITEM_MOD_CRIT_RATING_SHORT = 6.5,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.1,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.6,
				ITEM_MOD_VERSATILITY = 4.5,
				ITEM_MOD_HASTE_RATING_SHORT = 4.4,
			},
		},
		{
			name = "Fury",
			wizardName = "Fury (Titan's Grip)",
			specialization = 72,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 17.8,
				ITEM_MOD_STRENGTH_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9,
				ITEM_MOD_CRIT_RATING_SHORT = 7.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.5,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 5.4,
				ITEM_MOD_VERSATILITY = 5,
				ITEM_MOD_HASTE_RATING_SHORT = 4.5,
			},
		},
		{
			name = "Protection",
			wizardName = "Protection: Balanced",
			specialization = 73,
			default = true,
			weights = {
				ITEM_MOD_EXTRA_ARMOR_SHORT = 10,
				RESISTANCE0_NAME = 8.5,
				ITEM_MOD_STAMINA_SHORT = 7.5,
				ITEM_MOD_STRENGTH_SHORT = 6.5,
				ITEM_MOD_CRIT_RATING_SHORT = 6,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.7,
				ITEM_MOD_VERSATILITY = 5.4,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4,
				ITEM_MOD_HASTE_RATING_SHORT = 2.8,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 2,
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2,
				ITEM_MOD_CR_AVOIDANCE_SHORT = 1.7,
			},
		},
		{
			name = "Protection",
			wizardName = "Protection: Offensive",
			specialization = 73,
			weights = {
				ITEM_MOD_EXTRA_ARMOR_SHORT = 10,
				RESISTANCE0_NAME = 8.5,
				ITEM_MOD_STRENGTH_SHORT = 6.5,
				ITEM_MOD_CRIT_RATING_SHORT = 6,
				ITEM_MOD_STAMINA_SHORT = 5.7,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.5,
				ITEM_MOD_VERSATILITY = 5.3,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4,
				ITEM_MOD_HASTE_RATING_SHORT = 2.8,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 2,
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2,
				ITEM_MOD_CR_AVOIDANCE_SHORT = 1.7,
			},
		},
		{
			name = "Gladiator",
			wizardName = "Protection: Gladiator",
			specialization = 73,
			weights = {
				ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 9.5,
				ITEM_MOD_STRENGTH_SHORT = 10,
				ITEM_MOD_MELEE_ATTACK_POWER_SHORT = 9.3,
				ITEM_MOD_EXTRA_ARMOR_SHORT = 9.3,
				ITEM_MOD_CRIT_RATING_SHORT = 5.4,
				ITEM_MOD_HASTE_RATING_SHORT = 0.45,
				ITEM_MOD_VERSATILITY = 4.4,
				ITEM_MOD_CR_MULTISTRIKE_SHORT = 4.3,
				ITEM_MOD_MASTERY_RATING_SHORT = 4,
			},
		},
	},
}

-- add some universal stats to every spec at very low scores for leveling if character is low level
if UnitLevel('player') < MAX_PLAYER_LEVEL_TABLE[EXPANSION_LEVEL_CLASSIC] then
	for class, presets in pairs(ns.presets) do
		for _, preset in pairs(presets) do
			preset.weights.RESISTANCE0_NAME = preset.weights.RESISTANCE0_NAME or 0.001
			preset.weights.ITEM_MOD_STAMINA_SHORT = preset.weights.ITEM_MOD_STAMINA_SHORT or 0.01
		end
	end
end
