NDefines.NGame.START_DATE = "3090.1.1.12"
NDefines.NGame.END_DATE = "3103.1.1.1"


NDefines.NDiplomacy.TENSION_TIME_SCALE_START_DATE = "3090.1.1.12"
NDefines.NDiplomacy.MAX_OPINION_VALUE = 200							-- Max opinion value cap.
NDefines.NDiplomacy.MIN_OPINION_VALUE = -200						-- Min opinion value cap.

NDefines.NCountry.MIN_STABILITY = -1.0
NDefines.NCountry.MAX_WAR_SUPPORT = 1.0			

NDefines.NSupply.RIVER_RAILWAY_LEVEL = 3                            -- 水路=3级铁路

NDefines.NGame.MAX_SCRIPTED_LOC_RECURSION = 1001				-- max recursion for scripted localizations 最大递归

--------------------------------------------------------------------------------------------------------------
-- DESIGNS
--------------------------------------------------------------------------------------------------------------

-- NDefines.NAI.DEFAULT_MODULE_VARIANT_CREATION_XP_CUTOFF_LAND = 25 --35	-- Army XP needed before attempting to create a variant of a type that uses the tank designer (the tank designer DLC feature must be active).
-- NDefines.NAI.DEFAULT_MODULE_VARIANT_CREATION_XP_CUTOFF_NAVY = 25 --50	-- Same as above but for the ship designer.
-- NDefines.NAI.DEFAULT_MODULE_VARIANT_CREATION_XP_CUTOFF_AIR = 25 --25	-- Same as above but for the ship designer.

-- -- NDefines.NAI.DEFAULT_LEGACY_VARIANT_CREATION_XP_CUTOFF_LAND = 400 --10	-- Army XP needed before attempting to create a variant of a type that uses the legacy upgrades system. ai_strategy supports land_xp_spend_priority upgrade_xp_cutoff. If none is set this define is used instead.
-- -- NDefines.NAI.DEFAULT_LEGACY_VARIANT_CREATION_XP_CUTOFF_NAVY = 400 --25	-- Same as above but for navy XP and navy_xp_spend_priority.
-- -- NDefines.NAI.DEFAULT_LEGACY_VARIANT_CREATION_XP_CUTOFF_AIR  = 400 --25	-- Same as above but for air XP and air_xp_spend_priority.

-- NDefines.NAI.VARIANT_CREATION_XP_RESERVE_LAND = 25 --50					-- If the AI lacks army XP to create a variant it will reserve this much XP for variant creation so that it will eventually be able to create a variant.
-- NDefines.NAI.VARIANT_CREATION_XP_RESERVE_NAVY = 50 --50					-- Same as above but for navy XP.
-- NDefines.NAI.VARIANT_CREATION_XP_RESERVE_AIR = 50 --50					-- Same as above but for air XP.

-- -- The AI uses the below values when selecting which design to make among the types that use the tank designer
-- -- (the tank designer DLC feature must be active). For each role, the highest priority AI design that can be
-- -- created, if any, is assigned a weight. Any design with a weight of zero or a weight that falls below the
-- -- cutoff is dropped. A random design is then picked from the remaining.
-- -- Weight is calculated as AlternativeFactor * DemandFactor.
-- -- An "alternative" is a producible design of the same archetype (each specialized type is its own archetype).

-- NDefines.NAI.LAND_DESIGN_ALTERNATIVE_ABSENT = 10 --30000
-- NDefines.NAI.LAND_DESIGN_ALTERNATIVE_OF_LESSER_TECH = 1 --10000
-- NDefines.NAI.LAND_DESIGN_ALTERNATIVE_OF_EQUAL_TECH = 1 --100
-- NDefines.NAI.LAND_DESIGN_ALTERNATIVE_OF_GREATER_TECH = 1 --1

-- -- If a template may be reinforced with the archetype it's considered to be "demanded". If multiple conditions
-- -- are met, e.g. it's both in the field and in training, the largest value is used.

-- NDefines.NAI.LAND_DESIGN_DEMAND_FIELD_DIVISION = 5000
-- NDefines.NAI.LAND_DESIGN_DEMAND_TRAINING_DIVISION = 50
-- NDefines.NAI.LAND_DESIGN_DEMAND_GARRISON_DIVISION = 10
-- NDefines.NAI.LAND_DESIGN_DEMAND_UNUSED_TEMPLATE = 10 --1
-- NDefines.NAI.LAND_DESIGN_DEMAND_ABSENT = 10 --0

-- -- NDefines.NAI.AIR_DESIGN_ALTERNATIVE_ABSENT = 1
-- -- NDefines.NAI.AIR_DESIGN_ALTERNATIVE_OF_LESSER_TECH = 1
-- -- NDefines.NAI.AIR_DESIGN_ALTERNATIVE_OF_EQUAL_TECH = 1
-- -- NDefines.NAI.AIR_DESIGN_ALTERNATIVE_OF_GREATER_TECH = 1

-- -- If a design with a weight when divided by the largest weight falls below this value it's excluded from the
-- -- selection. Valid values are in the range [0, 1] inclusive.

-- NDefines.NAI.LAND_DESIGN_CUTOFF_AS_PERCENTAGE_OF_MAX = 0.01 --0.25

-- -- The AI "desires" to spend XP on doctrines, templates, and equipment.
-- -- The desire is built up over time and when XP is available it spends it on the action that has the highest accumulated desire. After spending XP the desire is reset, in effect balancing the desires.
-- -- Below is the daily desire gain for each action.

-- NDefines.NAI.DESIRE_USE_XP_TO_UNLOCK_LAND_DOCTRINE = 0.1    -- How quickly is desire to unlock land doctrines accumulated?
-- NDefines.NAI.DESIRE_USE_XP_TO_UNLOCK_NAVAL_DOCTRINE = 0.1   -- How quickly is desire to unlock naval doctrines accumulated?
-- NDefines.NAI.DESIRE_USE_XP_TO_UNLOCK_AIR_DOCTRINE = 0.1     -- How quickly is desire to unlock air doctrines accumulated?

-- --EAI: make sure land template desire is always at the top, if the doctrine desire is high but the mod blocks it, AI wont create templates
-- NDefines.NAI.DESIRE_USE_XP_TO_UPDATE_LAND_TEMPLATE = 100.0 --2.0    -- How quickly is desire to update/create templates accumulated?
-- NDefines.NAI.DESIRE_USE_XP_TO_UPGRADE_LAND_EQUIPMENT = 2.0 --0.1  -- How quickly is desire to update/create land equipment variants accumulated?

-- NDefines.NAI.DESIRE_USE_XP_TO_UPGRADE_NAVAL_EQUIPMENT = 100.0 -- How quickly is desire to update/create naval equipment variants accumulated?
-- NDefines.NAI.DESIRE_USE_XP_TO_UPGRADE_AIR_EQUIPMENT = 100.0   -- How quickly is desire to update/create air equipment variants accumulated?

-- NDefines.NAI.DESIRE_USE_XP_TO_UNLOCK_ARMY_SPIRIT = 0.1    -- How quickly is desire to unlock army spirits accumulated?
-- NDefines.NAI.DESIRE_USE_XP_TO_UNLOCK_NAVY_SPIRIT = 0.1   -- How quickly is desire to unlock naval spirits accumulated?
-- NDefines.NAI.DESIRE_USE_XP_TO_UNLOCK_AIR_SPIRIT = 0.1     -- How quickly is desire to unlock air spirits accumulated?

-- NDefines.NAI.DAYS_BETWEEN_CHECK_BEST_DOCTRINE = 7       -- Recalculate desired best doctrine to unlock with this many days inbetween.
-- NDefines.NAI.DAYS_BETWEEN_CHECK_BEST_TEMPLATE = 7       -- Recalculate desired best template to upgrade with this many days inbetween.
-- NDefines.NAI.DAYS_BETWEEN_CHECK_BEST_EQUIPMENT = 7      -- Recalculate desired best equipment to upgrade with this many days inbetween.

-- NDefines.NAI.GARRISON_TEMPLATE_SCORE_IC_FACTOR = 1.0 -- ai uses these defines while calculating garrison template score of a template.
-- NDefines.NAI.GARRISON_TEMPLATE_SCORE_MANPOWER_FACTOR = 0.05 -- formula is (template_ic * ic_factor + template_manpower * manpower_factor ) / template_supression (lower is better)

-- ---------------

-- -- NDefines.NAI.REFIT_SHIP_RELUCTANCE = 5000							-- How often to consider refitting to new equipment variants for ships in the field
-- -- NDefines.NAI.REFIT_SHIP_PERCENTAGE_OF_FORCES = 0.0				-- How big part of the navy that should be considered for refitting

-- -- NDefines.NCountry.REINFORCEMENT_DIVISION_PRIORITY_COUNT = 8

-- --NDefines.NAI.DIVISION_DESIGN_MAX_FAILED_DAYS = 1 --60					            -- max days we keep track of since failure of a design update

-- --NDefines.NAI.BUILD_ARMOR_BASE_COST_WEIGHT = 0 --200
-- --NDefines.NAI.BUILD_ARMOR_STRENGTH_MULTIPLIER_WEIGHT = 0 --100
-- --NDefines.NAI.BUILD_ARMOR_ORGANIZATION_MULTIPLIER_WEIGHT = 0 --500

-- -- NDefines.NAI.UPGRADE_DIVISION_RELUCTANCE = 7 -- 7					-- How often to consider upgrading to new templates for units in the field
-- -- NDefines.NAI.UPGRADE_PERCENTAGE_OF_FORCES = 0.01 -- 0.03				-- How big part of the army that should be considered for upgrading
-- NDefines.NAI.UPGRADES_DEFICIT_LIMIT_DAYS = 30 -- 7                          -- Ai will avoid upgrading units in the field to new templates if it takes longer than this to fullfill their equipment need

-- --NDefines.NAI.LOW_PRIO_TEMPLATE_BONUS_FOR_GARRISONS = 100000		-- bonus to make ai more likely to assign low prio units to garrisons
-- --NDefines.NAI.LOW_PRIO_TEMPLATE_PENALTY_FOR_FRONTS = 100000		-- penalty to make ai less likely to assign low prio units to fronts

--------------------------------------------------------------------------------------------------------------
-- DIVISION PRODUCTION
--------------------------------------------------------------------------------------------------------------

-- -- NDefines.NAI.WANTED_UNITS_INDUSTRY_FACTORY = 0.1 --1 		        			-- How many units a country wants is partially based on how much military industry that is available

-- --NDefines.NAI.DEPLOYED_UNIT_MANPOWER_RATIO_TO_BUFFER_WARTIME = 0.2 				-- deployment will try to buffer a ratio of deployed manpower (for reinforcements) during war time
-- --NDefines.NAI.DEPLOYED_UNIT_MANPOWER_RATIO_TO_BUFFER_PEACETIME = 0.1     		-- deployment will try to buffer a ratio of deployed manpower (for reinforcements) during peace time

-- -- NDefines.NAI.MAX_AVAILABLE_MANPOWER_RATIO_TO_BUFFER_WARTIME = 0.2			-- deployment will try to buffer a ratio of manpower (for reinforcements) during war time
-- -- NDefines.NAI.MAX_AVAILABLE_MANPOWER_RATIO_TO_BUFFER_PEACETIME = 0.1		-- deployment will try to buffer a ratio of manpower (for reinforcements) during peace time

-- --NDefines.NAI.MANPOWER_RATIO_REQUIRED_TO_PRIO_MOBILIZATION_LAW = 0.4		-- percentage of manpower in field is desired to be buffered for AI when it has upcoming wars or already at war. if it has less manpower, it will prio manpower laws

-- NDefines.NAI.MAX_SUPPLY_DIVISOR = 2.5  --1.75
-- -- NDefines.NAI.MIN_SUPPLY_USE_SANITY_CAP = 100	                                -- Ignore supply cap if below this value when deciding on how many divisions to produce.

-- 	-- Calculating wanted nr of divisions
-- NDefines.NAI.WANTED_UNITS_INDUSTRY_FACTOR = 1.30 --1.60                       -- How many units a country wants is partially based on how much military industry that is available
-- -- NDefines.NAI.WANTED_UNITS_THREAT_BASE = 0.7                             -- If no threat, multiply min wanted units by this
-- NDefines.NAI.WANTED_UNITS_THREAT_MAX = 3.0 --6.0                            -- Normalized threat is clamped to this
-- -- NDefines.NAI.WANTED_UNITS_WAR_THREAT_FACTOR = 1.5                       -- Factor threat with this if country is at war. this value is overriden by the value in ideology database if that value exceedes this.
-- -- NDefines.NAI.WANTED_UNITS_DANGEROUS_NEIGHBOR_FACTOR = 1.25              -- Factor if has dangerous neighbor
-- NDefines.NAI.WANTED_UNITS_MANPOWER_DIVISOR = 40000 --21000                     -- Normalizing divisor for AI manpower. (for each x max available manpower, they want one division)
-- -- NDefines.NAI.WANTED_UNITS_WEIGHT_FRONTS_WANT = 1                      -- Weight of front needs when computing final nr wanted units
-- NDefines.NAI.WANTED_UNITS_WEIGHT_FACTORIES = 0.35 --0.45                       -- Weight of military factories when computing final nr wanted units
-- -- NDefines.NAI.WANTED_UNITS_WEIGHT_MANPOWER = 1                         -- Weight of manpower availability when computing final nr wanted units
-- -- NDefines.NAI.WANTED_UNITS_MIN_DEFENCE_FACTOR = 0.4						-- Factor on units required for min defence
-- 	-- End of calculating wanted nr of divisions

-- NDefines.NAI.WANTED_UNITS_MAX_WANTED_CAP = 250 --500	-- Maximum wanted divisions for a country. This can be exceeded by certain hardcoded multipliers, but not by base calculation logic. 

-- -- NDefines.NAI.MIN_FIELD_STRENGTH_TO_BUILD_UNITS = 0.7 --0.7			            -- Cancel unit production if below this to get resources out to units in the field
-- -- NDefines.NAI.MIN_MANPOWER_TO_BUILD_UNITS = 0.7 --0.7					        -- Cancel unit production if below this to get resources out to units in the field

-- -- NDefines.NAI.DEPLOY_MIN_TRAINING_SURRENDER_FACTOR = 0.5		-- Required percentage of training (1.0 = 100%) for AI to deploy unit in wartime while surrender progress is higher than 0 
-- NDefines.NAI.DEPLOY_MIN_EQUIPMENT_SURRENDER_FACTOR = 0.8 --0.90	-- Required percentage of equipment (1.0 = 100%) for AI to deploy unit in wartime while surrender progress is higher than 0 
-- NDefines.NAI.DEPLOY_MIN_TRAINING_PEACE_FACTOR = 0.4	--0.98	-- Required percentage of training (1.0 = 100%) for AI to deploy unit in peacetime
-- NDefines.NAI.DEPLOY_MIN_EQUIPMENT_PEACE_FACTOR = 0.9 --0.98	-- Required percentage of equipment (1.0 = 100%) for AI to deploy unit in peacetime
-- NDefines.NAI.DEPLOY_MIN_TRAINING_WAR_FACTOR = 0.9 --0.95		-- Required percentage of training (1.0 = 100%) for AI to deploy unit in wartime
-- NDefines.NAI.DEPLOY_MIN_EQUIPMENT_WAR_FACTOR = 0.9 --0.95	-- Required percentage of equipment (1.0 = 100%) for AI to deploy unit in wartime
-- --NDefines.NAI.DEPLOY_MIN_EQUIPMENT_CAP_DEPLOY_FACTOR = 0.85 -- If training is capped by equipment deficit and we have reached that cap, deploy unit anyway if percentage is above this (reinforce in field instead).

-- -- NDefines.NAI.START_TRAINING_EQUIPMENT_LEVEL = 0.8 --0.9                               -- ai will not start to train if equipment drops below this level
-- -- NDefines.NAI.STOP_TRAINING_EQUIPMENT_LEVEL = 0.7 --0.8                                -- ai will not train if equipment drops below this level

--------------------------------------------------------------------------------------------------------------
-- EQUIPMENT PRODUCTION
--------------------------------------------------------------------------------------------------------------

-- NDefines.NAI.PRODUCTION_EQUIPMENT_SURPLUS_FACTOR = 0.5 -- 0.8 -- Base value for how much of currently used equipment the AI will at least strive to have in stock
-- -- NDefines.NAI.PRODUCTION_EQUIPMENT_SURPLUS_FACTOR_GARRISON = -- [0.3]

-- --NDefines.NAI.SHIPS_PRODUCTION_BASE_COST = 1
-- --NDefines.NAI.NEEDED_NAVAL_FACTORIES_EXPENSIVE_SHIP_BONUS = 1000
-- --NDefines.NAI.PRODUCTION_MAX_PROGRESS_TO_SWITCH_NAVAL = 0.001 -- temp fix
-- --NDefines.NAI.PRODUCTION_WAIT_TO_FINISH_IF_EXPENSIVE = 0.25
-- --NDefines.NAI.PRODUCTION_WAIT_TO_FINISH_IF_CHEAP = 0.75

-- --NDefines.NAI.NAVAL_DOCKYARDS_SHIP_FACTOR = 1000			-- The extent to which number of dockyards play into amount of sips a nation wants
-- --NDefines.NAI.NAVAL_BASES_SHIP_FACTOR = 1000				-- The extent to which number of naval bases play into amount of sips a nation wants
-- --NDefines.NAI.NAVAL_STATES_SHIP_FACTOR = 1000			-- The extent to which number of states play into amount of sips a nation wants

-- --NDefines.NAI.PRODUCTION_LINE_SWITCH_SURPLUS_NEEDED_MODIFIER = 0 -- 0.2 --delays the AI from upgrading air lines too long, this is handled by strategies instead

-- --NDefines.NAI.PRODUCTION_UNAVAILABLE_RESORCE_FACTORY_FACTOR = 0.5

--------------------------------------------------------------------------------------------------------------
-- LAND AI
--------------------------------------------------------------------------------------------------------------

-- NDefines.NAI.MIN_AI_UNITS_PER_TILE_FOR_STANDARD_COHESION = 2.0	-- How many units should we have for each tile along a front in order to switch to standard cohesion (less moving around)
-- NDefines.NAI.MIN_FRONT_SIZE_TO_CONSIDER_STANDARD_COHESION = 2000	-- How long should fronts be before we consider switching to standard cohesion (under this, standard cohesion fronts will switch back to relaxed)

-- ASSIGN_DEFENSE_ARMY_DEFENSE_FACTOR = 0 -- 3.0,                   -- Importance of unit's ARMY_DEFENSE stat when assigning to an area defense order
-- ASSIGN_DEFENSE_ARMY_ENTRENCHMENT_FACTOR = 0 -- 2.0,              -- Importance of unit's ARMY_ENTRENCHMENT stat when assigning to an area defense order
-- ASSIGN_DEFENSE_TEMPLATE_CLASS_SCORE = 100 -- 3.0,                  -- Importance of unit's AI template class (AREA_DEFENSE, CAVALRY) when assigning to an area defense order

-- NDefines.NAI.ASSIGN_TANKS_TO_WAR_FRONT = 8.0 --4.0
-- NDefines.NAI.ASSIGN_TANKS_TO_NON_WAR_FRONT = 0.2 --0.4

-- NDefines.NAI.STATE_CONTROL_FOR_AREA_DEFENSE = 0.05

-- --NDefines.NAI.SUPPLY_CRISIS_LIMIT = 1.0

-- --NDefines.NAI.PLAN_ATTACK_DEPTH_FACTOR = 0.5									-- Factor applied to size or enemy being attacked.
-- --NDefines.NAI.PLAN_STEP_COST_LIMIT = 1											-- When stepping to draw a plan this cost makes it break if it hits hard terrain (multiplied by number of desired steps)
-- --NDefines.NAI.PLAN_STEP_COST_LIMIT_REDUCTION = 3								-- Cost limit is reduced per iteration, making hard terrain less likely to be crossed the further into enemy territory it is

-- --NDefines.NMilitary.PLAN_EXECUTE_CAREFUL_LIMIT = 10 --25							-- When looking for an attach target, this score limit is required in the battle plan to consider province for attack
-- --NDefines.NMilitary.PLAN_EXECUTE_BALANCED_LIMIT = -1								-- When looking for an attach target, this score limit is required in the battle plan to consider province for attack
-- NDefines.NMilitary.PLAN_EXECUTE_RUSH = -10									-- When looking for an attach target, this score limit is required in the battle plan to consider province for attack
-- --NDefines.NMilitary.PLAN_EXECUTE_CAREFUL_MAX_FORT = 5							-- If execution mode is set to careful, units will not attack provinces with fort levels greater than or equal to this

-- --NDefines.NAI.PLAN_ATTACK_MIN_ORG_FACTOR_LOW = 0.85				            -- Minimum org % for a unit to actively attack an enemy unit when executing a plan
-- --NDefines.NAI.PLAN_ATTACK_MIN_STRENGTH_FACTOR_LOW = 0.5 --0.4			        -- Minimum strength for a unit to actively attack an enemy unit when executing a plan
-- --NDefines.NAI.PLAN_ATTACK_MIN_ORG_FACTOR_MED = 0.75 		 		        	-- (LOW,MED,HIGH) corresponds to the plan execution agressiveness level.
-- --NDefines.NAI.PLAN_ATTACK_MIN_STRENGTH_FACTOR_MED = 0.4 --0.3
-- --NDefines.NAI.PLAN_ATTACK_MIN_ORG_FACTOR_HIGH = 0.25
-- --NDefines.NAI.PLAN_ATTACK_MIN_STRENGTH_FACTOR_HIGH = 0.3	--0.2

-- --NDefines.NAI.FRONT_UNITS_CAP_FACTOR = 15.0									-- A factor applied to total front size and supply use. Primarily effects small fronts

-- --NDefines.NAI.MAX_UNITS_FACTOR_AREA_ORDER = 1.5 --1.0								-- Factor for max number of units to assign to area defense orders
-- --NDefines.NAI.DESIRED_UNITS_FACTOR_AREA_ORDER = 1.5 --1.0							-- Factor for desired number of units to assign to area defense orders
-- --NDefines.NAI.MIN_UNITS_FACTOR_AREA_ORDER = 1.5									-- Factor for min number of units to assign to area defense orders
-- --NDefines.NAI.MAX_UNITS_FACTOR_FRONT_ORDER = 1.5									-- Factor for max number of units to assign to area front orders
-- --NDefines.NAI.DESIRED_UNITS_FACTOR_FRONT_ORDER = 1.5								-- Factor for desired number of units to assign to area front orders
-- --NDefines.NAI.MIN_UNITS_FACTOR_FRONT_ORDER = 1.0									-- Factor for min number of units to assign to area front orders
-- --NDefines.NAI.MAX_UNITS_FACTOR_INVASION_ORDER = 1.0								-- Factor for max number of units to assign to naval invasion orders
-- --NDefines.NAI.DESIRED_UNITS_FACTOR_INVASION_ORDER = 1.0							-- Factor for desired number of units to assign to naval invasion orders
-- --NDefines.NAI.MIN_UNITS_FACTOR_INVASION_ORDER = 1.0								-- Factor for min number of units to assign to naval invasion orders

-- --NDefines.NAI.STATE_CONTROL_FOR_AREA_DEFENSE = 0.4 			                    -- To avoid AI sending area defense to area with very little foothold
-- --NDefines.NAI.AREA_DEFENSE_BASE_IMPORTANCE = 3 				                -- Area defense order base importance value (used for determining order of troop selections)
-- --NDefines.NAI.AREA_DEFENSE_CIVIL_WAR_IMPORTANCE = 10000 		                -- Area defense order importance value when a country is in a civil war as target or revolter.
-- --NDefines.NAI.MIN_STATE_VALUE_TO_PROTECT = 7.5 				                -- When AI is considering which states to protect it looks at state values to consider if it is worth it.
-- --NDefines.NAI.STATE_GARRISON_MAX_UNITS = 5 					                	-- Max units to guard a garrison under normal circumstances (isolated core areas like England has is excempt)

-- --NDefines.NAI.VP_LEVEL_IMPORTANCE_HIGH = 1 --30					                -- Victory points with values higher than or equal to this are considered to be of high importance.
-- --NDefines.NAI.VP_LEVEL_IMPORTANCE_MEDIUM = 1 --10				                -- Victory points with values higher than or equal to this are considered to be of medium importance.
-- --NDefines.NAI.VP_LEVEL_IMPORTANCE_LOW = 1 --5					                -- Victory points with values higher than or equal to this are considered to be of low importance.
-- --NDefines.NAI.VP_GARRISON_VALUE_FACTOR = 0 				                    -- Extent to which VP garrisons are prioritized  based on VP value and compared to other priority values.

-- NDefines.NAI.FALLBACK_LOSING_FACTOR = 0.0 					                    -- The lower this number  the longer the AI will hold the line before sending them to the fallback line
-- --NDefines.NAI.SCARY_LEVEL_AVERAGE_DEFENSE = -0.7                               -- average front defense modifier to make it consider it as a PITA to go for
-- --NDefines.NAI.ATTACK_HEAVILY_DEFENDED_LIMIT = 0.45 			                -- AI will not launch attacks against heavily defended fronts unless they consider to have this level of advantage (1.0 = 100%)
-- NDefines.NAI.HOUR_BAD_COMBAT_REEVALUATE = 24                                 	-- if we are in combat for this amount and it goes shitty then try skipping it

-- --NDefines.NAI.MIN_PLAN_VALUE_TO_MICRO_INACTIVE = 0.2			                -- The AI will not consider members of groups which plan is not activated AND evaluates lower than this.
-- --NDefines.NAI.MAX_MICRO_ATTACKS_PER_ORDER = 5 				                    -- AI goes through its orders and checks if there are situations to take advantage of
-- --NDefines.NAI.MICRO_POCKET_SIZE = 10 						                    -- Pockets with a size equal to or lower than this will be mocroed by the AI  for efficiency.
-- --NDefines.NAI.POCKET_DISTANCE_MAX = 40000 					                    -- shortest square distance we bother about chasing pockets

-- --NDefines.NAI.RESERVE_TO_COMMITTED_BALANCE = 0.1 				                -- How many reserves compared to number of committed divisions in a combat (1.0 = as many as reserves as committed)
-- --NDefines.NAI.REDEPLOY_DISTANCE_VS_ORDER_SIZE = 1.0 			                -- Factor applied to the path length of a unit compared to length of an order to determine if it should use strategic redeployment
-- --NDefines.NAI.UNIT_ASSIGNMENT_TERRAIN_IMPORTANCE = 5.0 		                -- Terrain score for units are multiplied by this when the AI is deciding which front they should be assigned to
-- --NDefines.NAI.FRONT_REASSIGN_DISTANCE = 120.0 					                -- If a unit is this far away from a front it is not considered to be assigned to it unless the new front is much more important
-- --NDefines.NAI.OLD_FRONT_IMPORTANCE_FACTOR = 1.50 				                -- If a unit is considered for reassignment  the importance of both new and old front is considered with a weight applied to the old ones score
-- --NDefines.NAI.ENTRENCHMENT_WEIGHT = 100.0						                -- AI should favour units with less entrenchment when assigning units around.
-- --NDefines.NAI.MAIN_ENEMY_FRONT_IMPORTANCE = 7.5				                -- How much extra focus the AI should put on who it considers to be its current main enemy.

-- --NDefines.NAI.PLAN_ACTIVATION_SUPERIORITY_AGGRO = 1	                        -- How aggressive a country is in activating a plan based on how superiour their force is.



-- NDefines.NAI.PLAN_ATTACK_MIN_ORG_FACTOR_LOW = 0.85							-- Minimum org % for a unit to actively attack an enemy unit when executing a plan
-- NDefines.NAI.PLAN_ATTACK_MIN_STRENGTH_FACTOR_LOW = 0.85						-- Minimum strength for a unit to actively attack an enemy unit when executing a plan

-- NDefines.NAI.PLAN_ATTACK_MIN_ORG_FACTOR_MED = 0.65							-- (LOW,MED,HIGH) corresponds to the plan execution agressiveness level.
-- NDefines.NAI.PLAN_ATTACK_MIN_STRENGTH_FACTOR_MED = 0.65	

-- NDefines.NAI.PLAN_ATTACK_MIN_ORG_FACTOR_HIGH = 0.5		
-- NDefines.NAI.PLAN_ATTACK_MIN_STRENGTH_FACTOR_HIGH = 0.5	



-- NDefines.NAI.PLAN_FACTION_STRONG_TO_EXECUTE = 0.65 --0.80	0.60		        -- % or more of units in an order to consider ececuting the plan
-- NDefines.NAI.ORG_UNIT_STRONG = 0.75												-- Organization % for unit to be considered strong
-- NDefines.NAI.STR_UNIT_STRONG = 0.75												-- Strength (equipment) % for unit to be considered strong

-- NDefines.NAI.PLAN_FACTION_NORMAL_TO_EXECUTE = 0.65
-- NDefines.NAI.ORG_UNIT_NORMAL = 0.6 --6												-- Organization % for unit to be considered normal
-- NDefines.NAI.STR_UNIT_NORMAL = 0.6 --6												-- Strength (equipment) % for unit to be considered normal

-- NDefines.NAI.PLAN_FACTION_WEAK_TO_ABORT = 0.5 --0.50		0.65		        -- % or more of units in an order to consider ececuting the plan
-- NDefines.NAI.ORG_UNIT_WEAK = 0.45 --0.45												-- Organization % for unit to be considered weak
-- NDefines.NAI.STR_UNIT_WEAK = 0.4 --0.45												-- Strength (equipment) % for unit to be considered weak

-- NDefines.NAI.PLAN_AVG_PREPARATION_TO_EXECUTE = 0.5				            -- % or more average plan preparation before executing
-- NDefines.NAI.AI_FRONT_MOVEMENT_FACTOR_FOR_READY = 0.5			                -- If less than this fraction of units on a front is moving  AI sees it as ready for action



-- --NDefines.NAI.PLAN_VALUE_TO_EXECUTE = -1.1                                     -- AI will typically avoid carrying out a plan it below this value (0.0 is considered balanced).

-- --NDefines.NAI.LOCATION_BALANCE_TO_ADVANCE = 0.0				                -- Limit on location strength balance between country and enemy for unit to dare to move forward.
-- NDefines.NAI.PLAN_ACTIVATION_MAJOR_WEIGHT_FACTOR = 1		                    -- AI countries will hold on activating plans if stronger countries have plans in the same location. Majors count extra (value of 1 will negate this)
-- NDefines.NAI.PLAN_ACTIVATION_PLAYER_WEIGHT_FACTOR = 1 		                -- AI countries will hold on activating plans if player controlled countries have plans in the same location. Majors count extra (value of 1 will negate this)
-- --NDefines.NAI.FRONT_TERRAIN_DEFENSE_FACTOR = 5.0 				                -- Multiplier applied to unit defense modifier for terrain on front province multiplied by terrain importance
-- --NDefines.NAI.FRONT_TERRAIN_ATTACK_FACTOR = 5.0 				                -- Multiplier applied to unit attack modifier for terrain on enemy front province multiplied by terrain importance
-- NDefines.NAI.PLAN_MIN_SIZE_FOR_FALLBACK = 5000					                -- A country with less provinces than this will not draw fallback plans  but rather station their troops along the front

-- --NDefines.NAI.FRONT_BULGE_RATIO_UPPER_CUTOFF = 1.5								-- If total bulginess is lower than this, the front is ignored.
-- --NDefines.NAI.FRONT_BULGE_RATIO_LOWER_CUTOFF = 0.95							-- If local bulginess drops below this, a point of interest is found
-- --NDefines.NAI.FRONT_CUTOFF_MIN_EDGE_PROXIMITY = 2								-- Minimum number of provinces to the front edge to determine for cutoff oportunity.


-- -- these are all 3 numbers for min, desired, max unit need weights for area defense
-- NDefines.NAI.AREA_DEFENSE_CAPITAL_PEACE_VP_WEIGHT = { 1.0, 1.0, 1.0 }
-- NDefines.NAI.AREA_DEFENSE_CAPITAL_VP_WEIGHT = { 0.0, 1.0, 2.0 }
-- NDefines.NAI.AREA_DEFENSE_HOME_VP_WEIGHT = { 0.0, 0.5, 1.0 }
-- NDefines.NAI.AREA_DEFENSE_OTHER_VP_WEIGHT = { 0.0, 0.0, 1.0 }

-- NDefines.NAI.AREA_DEFENSE_CAPITAL_PEACE_COAST_WEIGHT = { 0.0, 0.0, 0.0 }
-- NDefines.NAI.AREA_DEFENSE_CAPITAL_COAST_WEIGHT = { 0.0, 0.2, 0.7 }
-- NDefines.NAI.AREA_DEFENSE_HOME_COAST_WEIGHT = { 0.0, 0.1, 0.5 }
-- NDefines.NAI.AREA_DEFENSE_OTHER_COAST_WEIGHT = { 0.0, 0.0, 0.0 }

-- NDefines.NAI.AREA_DEFENSE_CAPITAL_PEACE_BASE_WEIGHT = { 0.0, 0.0, 0.0 }
-- NDefines.NAI.AREA_DEFENSE_CAPITAL_BASE_WEIGHT = { 0.5, 1.0, 1.5 }
-- NDefines.NAI.AREA_DEFENSE_HOME_BASE_WEIGHT = { 0.5, 1.0, 1.0 }
-- NDefines.NAI.AREA_DEFENSE_OTHER_BASE_WEIGHT = { 0.5, 0.5, 1.0 }

-------------------
-- Composition
-------------------

-- -- NDefines.NAI.NAVAL_MISSION_MIN_FLEET_SIZE = 3								-- AI will not send too small fleets on missions. Ignored if total number of ships country has is below	this.
-- NDefines.NAI.NAVY_PREFERED_MAX_SIZE = 120 -- was 80								-- AI will generally attempt to merge fleets into this size but as a soft limit.

-- -- NDefines.NAI.CARRIER_TASKFORCE_MAX_CARRIER_COUNT = -- 4 		-- optimum carrier count for carrier taskforces
-- NDefines.NAI.CAPITAL_TASKFORCE_MAX_CAPITAL_COUNT = 40 -- from 12 		-- optimum capital count for capital taskforces
-- NDefines.NAI.SCREEN_TASKFORCE_MAX_SHIP_COUNT = 5 -- from 12			-- optimum screen count for screen taskforces
-- NDefines.NAI.SUB_TASKFORCE_MAX_SHIP_COUNT = 5 -- from 16				-- optimum sub count for sub taskforces

-- -- NDefines.NAI.MIN_CAPITALS_FOR_CARRIER_TASKFORCE = -- 6			-- carrier fleets will at least have this amount of capitals
-- -- NDefines.NAI.CAPITALS_TO_CARRIER_RATIO = -- 1.5				-- capital to carrier count in carrier taskfoces
-- NDefines.NAI.SCREENS_TO_CAPITAL_RATIO = 5.0 -- from 4.0					-- screens to capital/carrier count in carrier & capital taskforces

-- -- NDefines.NAI.MIN_MAIN_SHIP_RATIO = -- 0.3                      -- if main ship ratio is below this steal other ships.
-- -- NDefines.NAI.MIN_SUPPORT_SHIP_RATIO = -- 0.7                   -- if support ship ratio is below this steal other ships.
-- -- NDefines.NAI.MIN_MAIN_SHIP_RATIO_TO_REINFORCE = -- 0.5         -- the main ships will be tried to reinforce this level.
-- -- NDefines.NAI.MIN_SUPPORT_SHIP_RATIO_TO_REINFORCE = -- 0.9      -- the support ships will be tried to reinforce this level.
-- -- NDefines.NAI.MIN_MAIN_SHIP_TO_SPARE = -- 0.7                   -- can only steal ships from a task force if their main ship ratio is above this.
-- -- NDefines.NAI.MIN_SUPPORT_SHIP_TO_SPARE = -- 1.0                -- can only steal ships from a task force if their support ship ratio is above this.
-- -- NDefines.NAI.MIN_MAIN_SHIP_RATIO_TO_MERGE = -- 0.7             -- try merge task force if main ship ratio is lower than this.
-- -- NDefines.NAI.MAX_MAIN_SHIP_RATIO_TO_MERGE = -- 1.001           -- if resulting main ship ratio would be at most this allow merging into this task force.
-- -- NDefines.NAI.MAIN_SHIP_RATIO_TO_SPLIT = -- 1.8                 -- if main ship ratio in a task force is larger than this split it. (If a carrier TF wants 4 carriers (see defines above) but it has more than [this * 4] carriers then we try to split the TF.)

-- --NDefines.NAI.MAX_SCREEN_TASKFORCES_FOR_CONVOY_DEFENSE_MIN = -- 0.20 -- maximum ratio of all screen-ships forces to be used in convoy defense (increases up to max as AI loses convoys).
-- --NDefines.NAI.MAX_SCREEN_TASKFORCES_FOR_CONVOY_DEFENSE_MAX = -- 0.70 -- maximum ratio of all screen-ships forces to be used in convoy defense (increases up to max as AI loses convoys).
-- --NDefines.NAI.MAX_SCREEN_TASKFORCES_FOR_CONVOY_DEFENSE_MIN_CONVOY_THREAT = -- 100 -- AI will increase screen assignment for escort missions as threate increases
-- --NDefines.NAI.MAX_SCREEN_TASKFORCES_FOR_CONVOY_DEFENSE_MAX_CONVOY_THREAT = -- 1500-- AI will increase screen assignment for escort missions as threate increases

-- NDefines.NAI.MAX_SCREEN_TASKFORCES_FOR_MINE_LAYING = 0.05  -- 0.10 -- maximum ratio of screens forces to be used in mine laying
-- NDefines.NAI.MAX_PATROL_TO_STRIKE_FORCE_RATIO = 4.0 -- 3.0	-- maximum patrol/strike force ratio

-- -- NDefines.NAI.MAX_SCREEN_TASKFORCES_FOR_MINE_SWEEPING = -- 0.10 -- maximum ratio of screens forces to be used in mine sweeping
-- -- NDefines.NAI.MAX_SCREEN_TASKFORCES_FOR_MINE_SWEEPING_PRIO = -- 0.8 -- if you have mines near your owned states, you will start priotize mine missions and will assign this ratio of screens
-- -- NDefines.NAI.MAX_SCREEN_TASKFORCES_FOR_MINE_SWEEPING_PRIO_MIN_MINES = -- 10 -- lowest mine for prioing mine missions
-- NDefines.NAI.MAX_SCREEN_TASKFORCES_FOR_MINE_SWEEPING_PRIO_MAX_MINES = 250 -- 1000 -- highest mines for highest prio for mine missions

-------------------
-- Missions
-------------------

-- NDefines.NAI.NAVAL_MAX_PRIO_THEATRES = 5										-- A nation may have a large number of theatres but all of them having stationed/assigned navy is redundant
-- NDefines.NAI.NAVAL_THEATRE_PRIO_CAPITAL_SCORE = 100							-- Weight of capital when calculating naval theatre assignment
-- NDefines.NAI.NAVAL_THEATRE_PRIO_NAVAL_BASE_SCORE = 1							-- Weight of naval bases when calculating naval theatre assignment
-- NDefines.NAI.NAVAL_THEATRE_PRIO_MIN_DISTANCE = 2000							-- Minimum distance (in km) between priority theatres for naval assignment to spread navy out

-- NDefines.NAI.NAVAL_MISSION_AGGRESSIVE_PATROL_DIVISOR = -- 1						-- Divides patrol score when not defending
-- NDefines.NAI.NAVAL_MISSION_PATROL_NEAR_OWNED = -- 500							-- Extra patrol mission score near owned provinces
-- NDefines.NAI.NAVAL_MISSION_PATROL_NEAR_CONTROLLED = -- 120						-- Extra patrol mission score near controlled provinces

-- NDefines.NAI.STRIKE_FLEET_MAX_DISTANCE_TO_COMBAT = 500.0						-- The strike fleet will not attempt to intervene in combats further away than this.

-- NDefines.NAI.NAVAL_MISSION_AGGRESSIVE_ESCORT_DIVISOR = 1 -- 2		-- Divides escort score when not defending
-- NDefines.NAI.NAVAL_MISSION_ESCORT_NEAR_OWNED = -- 300			-- Extra escort mission score near owned provinces
-- NDefines.NAI.NAVAL_MISSION_ESCORT_NEAR_CONTROLLED = -- 200		-- Extra escort mission score near controlled provinces
-- NDefines.NAI.CONVOY_ESCORT_SCORE_FROM_CONVOYS =  -- 15                       -- score for each convoy you have in area
-- NDefines.NAI.CONVOY_ESCORT_MUL_FROM_NO_CONVOYS = -- 0.02                  	 -- score multiplier when no convoys are around

-- NDefines.NAI.MIN_NAVAL_MISSION_PRIO_TO_ASSIGN = {  -- priorities for regions to get assigned to a mission
-- 	0, -- HOLD (consumes fuel HOLD_MISSION_MOVEMENT_COST fuel while moving)
-- 	200, -- PATROL
-- 	200, -- STRIKE FORCE
-- 	200, -- CONVOY RAIDING
-- 	100, -- CONVOY ESCORT
-- 	200, -- MINES PLANTING
-- 	100, -- MINES SWEEPING
-- 	0, -- TRAIN
-- 	0, -- RESERVE_FLEET
-- 	100, -- NAVAL INVASION SUPPORT
-- }

-- NDefines.NAI.HIGH_PRIO_NAVAL_MISSION_SCORES = {  -- priorities for regions to get assigned to a mission
-- 	0, -- HOLD (consumes fuel HOLD_MISSION_MOVEMENT_COST fuel while moving)
-- 	1000000, -- PATROL
-- 	1000, -- STRIKE FORCE
-- 	1500, -- CONVOY RAIDING
-- 	1000, -- CONVOY ESCORT
-- 	10, -- MINES PLANTING
-- 	300, -- MINES SWEEPING
-- 	0, -- TRAIN
-- 	0, -- RESERVE_FLEET
-- 	1000, -- NAVAL INVASION SUPPORT
-- }

-- NDefines.NAI.MAX_MISSION_PER_TASKFORCE = {  -- max mission region/taskforce ratio
-- 	0, -- HOLD (consumes fuel HOLD_MISSION_MOVEMENT_COST fuel while moving)
-- 	1.5, -- PATROL
-- 	6, -- STRIKE FORCE
-- 	1.5, -- CONVOY RAIDING
-- 	4, -- CONVOY ESCORT
-- 	2, -- MINES PLANTING
-- 	2, -- MINES SWEEPING
-- 	0, -- TRAIN
-- 	0, -- RESERVE_FLEET
-- 	10, -- NAVAL INVASION SUPPORT
-- }

-------------------------
-- naval invasions
-------------------------

-- NDefines.NAI.INVASION_COASTAL_PROVS_PER_ORDER = 12 -- 24 -- AI will consider one extra invasion per number of provinces stated here (num orders = total coast / this)

-- -- NDefines.NAI.ENEMY_HOME_AREA_RATIO_TO_DISABLE_INVASIONS = 2 --0.3 -- if we are fighting against an enemy home area from our home area and if the enemy area is larger than this ratio, non strategy invasions are disabled

-- NDefines.NAI.ENEMY_NAVY_STRENGTH_DONT_BOTHER = 1000							-- If the enemy has a navy at least these many times stronger that the own, don't bother invading
-- NDefines.NAI.RELATIVE_STRENGTH_TO_INVADE = 0 -- 0.08			-- Compares the estimated strength of the country/faction compared to it's enemies to see if it should invade or stay at home to defend.
-- NDefines.NAI.RELATIVE_STRENGTH_TO_INVADE_DEFENSIVE = 0 -- 0.4	-- Compares the estimated strength of the country/faction compared to it's enemies to see if it should invade or stay at home to defend, but while being a defensive country.

-- -- NDefines.NAI.MAX_UNIT_RATIO_FOR_INVASIONS = -- 0.4                         -- countries won't use armies more than this ratio of total units for invasions
-- -- NDefines.NAI.MIN_UNIT_RATIO_FOR_INVASIONS = -- 0.1                         -- don't allocate more divisions than this for naval invasions
-- -- NDefines.NAI.MAX_INVASION_FRONT_SCORE = -- 1000                            -- max score for naval invasion front scores
-- -- NDefines.NAI.MIN_FRONT_SCORE_FOR_AFTER_INVASION_AREAS = -- 1500			-- min score for army fronts that are created on recently invaded regions

-- -- NDefines.NAI.NAVAL_INVADED_AREA_PRIO_DURATION = -- 90								-- after successful invasion AI will prio the enemy area for this number of days
-- NDefines.NAI.NAVAL_INVADED_AREA_PRIO_MULT = 2 -- 1.2									-- fronts that belongs to recent invasions gets more prio
-- NDefines.NAI.MIN_NUM_CONQUERED_PROVINCES_TO_DEPRIO_NAVAL_INVADED_FRONTS = 50 -- 20	-- if you conquer this amount of provinces after a naval invasion it will lose its prio status and will act as a regular front

-- -- NDefines.NAI.MIN_INVASION_PLAN_VALUE_TO_EXECUTE = -- 0.3               -- ai will only activate invasions if plan value is above this
-- -- NDefines.NAI.MIN_INVASION_ORG_FACTOR_TO_EXECUTE = -- 0.9               -- ai will only activate invasions if average org factor is above this
-- -- NDefines.NAI.MIN_INVASION_UNITS_READY_TO_EXECUTE = -- 0.9              -- ai will only activate invasions if this ratio of assigned units are ready
-- NDefines.NAI.MAX_INVASION_SIZE = 12 -- 24                                 -- max invasion group size
-- NDefines.NAI.MIN_INVASION_AREA_SIZE_FOR_FLOATING_HARBORS = 10 -- 15

-- NDefines.NAI.MAX_DISTANCE_NAVAL_INVASION = 5000.0				-- AI is extremely unwilling to plan naval invasions above this naval distance limit.

-- -- NDefines.NAI.INVASION_TARGET_DISTANCE_DENOMINATOR = 1 -- 1000            -- When selecting invasion target, divide this with (pixel) distance to get distance score factor. (Doesn't really affect the relative scoring, but it affects the linearity of the score function.)
-- -- NDefines.NAI.INVASION_TARGET_NO_PORT_FACTOR = 0.6 -- 0.3                   -- When selecting invasion target, multiply score with this if the target has no port
-- -- NDefines.NAI.INVASION_TARGET_TRUNCATION_SELECT_THRESHOLD = 0 -- 0.6      -- When selecting invasion target, use this threshold for truncation selection. (1.0 means select highest scored target, 0.0 means select randomly from all possible target, 0.5 means select randomly from all targets with more than 50 % of highest score)
-- -- NDefines.NAI.INVASION_TARGET_PRIO_NOT_ENEMY_FACTOR =  -- 0.17           -- When calculating priority for an invasion, factor the score with this if the target is not an actual enemy.
-- NDefines.NAI.FAILED_INVASION_AVOID_DURATION = 1 -- 60                    -- after a failed invasion, AI will down-prioritize invading the same area again for this number of days
-- NDefines.NAI.FAILED_INVASION_AREA_PRIO_FACTOR = 1 -- 0.5                 -- for every failed invasion on an area, factor that area's invasion prio with this value
-- NDefines.NAI.FAILED_INVASION_PORT_PRIO_FACTOR = 1 -- 0.66                -- for every failed invasion on a target port (province), factor the chance that we try to invade that same port again (relative to other ports)

--------------------------------------------------------------------------------------------------------------

NDefines.NNavy.NAVAL_RANGE_TO_INGAME_DISTANCE = 0.18 -- Scale the ship stats "naval_range" to the ingame distance

NDefines.NCountry.MAJOR_MIN_FACTORIES = 50
NDefines.NDiplomacy.BASE_SURRENDER_LEVEL = 0.85
NDefines.NDiplomacy.VOLUNTEERS_PER_TARGET_PROVINCE = 0.0
-- NDefines.NDiplomacy.VOLUNTEERS_PER_COUNTRY_ARMY = 0.01
NDefines.NDiplomacy.VOLUNTEERS_RETURN_EQUIPMENT = 0.95
NDefines.NDiplomacy.VOLUNTEERS_TRANSFER_SPEED = 7

--------------------------------------------------------------------------------------------------------------
-- Military
--------------------------------------------------------------------------------------------------------------

-- NDefines.NMilitary.UNIT_EXPERIENCE_PER_COMBAT_HOUR = 0.0003 -- 0.0001
-- --NDefines.NMilitary.EXPERIENCE_LOSS_FACTOR = 0.85 -- 1.00                 -- percentage of experienced solders who die when manpower is removed
-- NDefines.NMilitary.EQUIPMENT_COMBAT_LOSS_FACTOR = 0.50 -- 0.70	 	   -- % of equipment lost to strength ratio in combat, so some % is returned if below 1
-- EXPERIENCE_COMBAT_FACTOR = 0.35 -- 0.25

-- -- 穿甲机制
-- NDefines.NMilitary.PIERCING_THRESHOLDS = {					-- Our piercing / their armor must be this value to deal damage fraction equal to the index in the array below [higher number = higher penetration]. If armor is 0, 1.00 will be returned.
-- 1.00,
-- 0.75,
-- 0.50,
-- 0.00, --there isn't much point setting this higher than 0
-- }
-- NDefines.NMilitary.PIERCING_THRESHOLD_DAMAGE_VALUES = {	-- 0 armor will always receive maximum damage (so add overmatching at your own peril). the system expects at least 2 values, with no upper limit.
-- 1.00,
-- 0.75, -- 0.80
-- 0.50, -- 0.65
-- 0.25, -- 0.50
-- }