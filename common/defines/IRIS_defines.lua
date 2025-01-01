NDefines.NGame.START_DATE = "3090.1.1.12"
NDefines.NGame.END_DATE = "3103.1.1.1"


NDefines.NDiplomacy.TENSION_TIME_SCALE_START_DATE = "3090.1.1.12"
NDefines.NDiplomacy.MAX_OPINION_VALUE = 200							-- Max opinion value cap.
NDefines.NDiplomacy.MIN_OPINION_VALUE = -200						-- Min opinion value cap.

NDefines.NCountry.MIN_STABILITY = -1.0
NDefines.NCountry.MAX_WAR_SUPPORT = 1.0			

NDefines.NSupply.RIVER_RAILWAY_LEVEL = 3                            -- 水路=3级铁路

--------------------------------------------------------------------------------------------------------------
-- LAND AI
--------------------------------------------------------------------------------------------------------------

NDefines.NAI.MIN_AI_UNITS_PER_TILE_FOR_STANDARD_COHESION = 2.0	-- How many units should we have for each tile along a front in order to switch to standard cohesion (less moving around)
NDefines.NAI.MIN_FRONT_SIZE_TO_CONSIDER_STANDARD_COHESION = 2000	-- How long should fronts be before we consider switching to standard cohesion (under this, standard cohesion fronts will switch back to relaxed)

ASSIGN_DEFENSE_ARMY_DEFENSE_FACTOR = 0 -- 3.0,                   -- Importance of unit's ARMY_DEFENSE stat when assigning to an area defense order
ASSIGN_DEFENSE_ARMY_ENTRENCHMENT_FACTOR = 0 -- 2.0,              -- Importance of unit's ARMY_ENTRENCHMENT stat when assigning to an area defense order
ASSIGN_DEFENSE_TEMPLATE_CLASS_SCORE = 100 -- 3.0,                  -- Importance of unit's AI template class (AREA_DEFENSE, CAVALRY) when assigning to an area defense order

NDefines.NAI.ASSIGN_TANKS_TO_WAR_FRONT = 8.0 --4.0
NDefines.NAI.ASSIGN_TANKS_TO_NON_WAR_FRONT = 0.2 --0.4

NDefines.NAI.STATE_CONTROL_FOR_AREA_DEFENSE = 0.05

--NDefines.NAI.SUPPLY_CRISIS_LIMIT = 1.0

--NDefines.NAI.PLAN_ATTACK_DEPTH_FACTOR = 0.5									-- Factor applied to size or enemy being attacked.
--NDefines.NAI.PLAN_STEP_COST_LIMIT = 1											-- When stepping to draw a plan this cost makes it break if it hits hard terrain (multiplied by number of desired steps)
--NDefines.NAI.PLAN_STEP_COST_LIMIT_REDUCTION = 3								-- Cost limit is reduced per iteration, making hard terrain less likely to be crossed the further into enemy territory it is

--NDefines.NMilitary.PLAN_EXECUTE_CAREFUL_LIMIT = 10 --25							-- When looking for an attach target, this score limit is required in the battle plan to consider province for attack
--NDefines.NMilitary.PLAN_EXECUTE_BALANCED_LIMIT = -1								-- When looking for an attach target, this score limit is required in the battle plan to consider province for attack
NDefines.NMilitary.PLAN_EXECUTE_RUSH = -10									-- When looking for an attach target, this score limit is required in the battle plan to consider province for attack
--NDefines.NMilitary.PLAN_EXECUTE_CAREFUL_MAX_FORT = 5							-- If execution mode is set to careful, units will not attack provinces with fort levels greater than or equal to this

--NDefines.NAI.PLAN_ATTACK_MIN_ORG_FACTOR_LOW = 0.85				            -- Minimum org % for a unit to actively attack an enemy unit when executing a plan
--NDefines.NAI.PLAN_ATTACK_MIN_STRENGTH_FACTOR_LOW = 0.5 --0.4			        -- Minimum strength for a unit to actively attack an enemy unit when executing a plan
--NDefines.NAI.PLAN_ATTACK_MIN_ORG_FACTOR_MED = 0.75 		 		        	-- (LOW,MED,HIGH) corresponds to the plan execution agressiveness level.
--NDefines.NAI.PLAN_ATTACK_MIN_STRENGTH_FACTOR_MED = 0.4 --0.3
--NDefines.NAI.PLAN_ATTACK_MIN_ORG_FACTOR_HIGH = 0.25
--NDefines.NAI.PLAN_ATTACK_MIN_STRENGTH_FACTOR_HIGH = 0.3	--0.2

--NDefines.NAI.FRONT_UNITS_CAP_FACTOR = 15.0									-- A factor applied to total front size and supply use. Primarily effects small fronts

--NDefines.NAI.MAX_UNITS_FACTOR_AREA_ORDER = 1.5 --1.0								-- Factor for max number of units to assign to area defense orders
--NDefines.NAI.DESIRED_UNITS_FACTOR_AREA_ORDER = 1.5 --1.0							-- Factor for desired number of units to assign to area defense orders
--NDefines.NAI.MIN_UNITS_FACTOR_AREA_ORDER = 1.5									-- Factor for min number of units to assign to area defense orders
--NDefines.NAI.MAX_UNITS_FACTOR_FRONT_ORDER = 1.5									-- Factor for max number of units to assign to area front orders
--NDefines.NAI.DESIRED_UNITS_FACTOR_FRONT_ORDER = 1.5								-- Factor for desired number of units to assign to area front orders
--NDefines.NAI.MIN_UNITS_FACTOR_FRONT_ORDER = 1.0									-- Factor for min number of units to assign to area front orders
--NDefines.NAI.MAX_UNITS_FACTOR_INVASION_ORDER = 1.0								-- Factor for max number of units to assign to naval invasion orders
--NDefines.NAI.DESIRED_UNITS_FACTOR_INVASION_ORDER = 1.0							-- Factor for desired number of units to assign to naval invasion orders
--NDefines.NAI.MIN_UNITS_FACTOR_INVASION_ORDER = 1.0								-- Factor for min number of units to assign to naval invasion orders

--NDefines.NAI.STATE_CONTROL_FOR_AREA_DEFENSE = 0.4 			                    -- To avoid AI sending area defense to area with very little foothold
--NDefines.NAI.AREA_DEFENSE_BASE_IMPORTANCE = 3 				                -- Area defense order base importance value (used for determining order of troop selections)
--NDefines.NAI.AREA_DEFENSE_CIVIL_WAR_IMPORTANCE = 10000 		                -- Area defense order importance value when a country is in a civil war as target or revolter.
--NDefines.NAI.MIN_STATE_VALUE_TO_PROTECT = 7.5 				                -- When AI is considering which states to protect it looks at state values to consider if it is worth it.
--NDefines.NAI.STATE_GARRISON_MAX_UNITS = 5 					                	-- Max units to guard a garrison under normal circumstances (isolated core areas like England has is excempt)

--NDefines.NAI.VP_LEVEL_IMPORTANCE_HIGH = 1 --30					                -- Victory points with values higher than or equal to this are considered to be of high importance.
--NDefines.NAI.VP_LEVEL_IMPORTANCE_MEDIUM = 1 --10				                -- Victory points with values higher than or equal to this are considered to be of medium importance.
--NDefines.NAI.VP_LEVEL_IMPORTANCE_LOW = 1 --5					                -- Victory points with values higher than or equal to this are considered to be of low importance.
--NDefines.NAI.VP_GARRISON_VALUE_FACTOR = 0 				                    -- Extent to which VP garrisons are prioritized  based on VP value and compared to other priority values.

NDefines.NAI.FALLBACK_LOSING_FACTOR = 0.0 					                    -- The lower this number  the longer the AI will hold the line before sending them to the fallback line
--NDefines.NAI.SCARY_LEVEL_AVERAGE_DEFENSE = -0.7                               -- average front defense modifier to make it consider it as a PITA to go for
--NDefines.NAI.ATTACK_HEAVILY_DEFENDED_LIMIT = 0.45 			                -- AI will not launch attacks against heavily defended fronts unless they consider to have this level of advantage (1.0 = 100%)
NDefines.NAI.HOUR_BAD_COMBAT_REEVALUATE = 24                                 	-- if we are in combat for this amount and it goes shitty then try skipping it

--NDefines.NAI.MIN_PLAN_VALUE_TO_MICRO_INACTIVE = 0.2			                -- The AI will not consider members of groups which plan is not activated AND evaluates lower than this.
--NDefines.NAI.MAX_MICRO_ATTACKS_PER_ORDER = 5 				                    -- AI goes through its orders and checks if there are situations to take advantage of
--NDefines.NAI.MICRO_POCKET_SIZE = 10 						                    -- Pockets with a size equal to or lower than this will be mocroed by the AI  for efficiency.
--NDefines.NAI.POCKET_DISTANCE_MAX = 40000 					                    -- shortest square distance we bother about chasing pockets

--NDefines.NAI.RESERVE_TO_COMMITTED_BALANCE = 0.1 				                -- How many reserves compared to number of committed divisions in a combat (1.0 = as many as reserves as committed)
--NDefines.NAI.REDEPLOY_DISTANCE_VS_ORDER_SIZE = 1.0 			                -- Factor applied to the path length of a unit compared to length of an order to determine if it should use strategic redeployment
--NDefines.NAI.UNIT_ASSIGNMENT_TERRAIN_IMPORTANCE = 5.0 		                -- Terrain score for units are multiplied by this when the AI is deciding which front they should be assigned to
--NDefines.NAI.FRONT_REASSIGN_DISTANCE = 120.0 					                -- If a unit is this far away from a front it is not considered to be assigned to it unless the new front is much more important
--NDefines.NAI.OLD_FRONT_IMPORTANCE_FACTOR = 1.50 				                -- If a unit is considered for reassignment  the importance of both new and old front is considered with a weight applied to the old ones score
--NDefines.NAI.ENTRENCHMENT_WEIGHT = 100.0						                -- AI should favour units with less entrenchment when assigning units around.
--NDefines.NAI.MAIN_ENEMY_FRONT_IMPORTANCE = 7.5				                -- How much extra focus the AI should put on who it considers to be its current main enemy.

--NDefines.NAI.PLAN_ACTIVATION_SUPERIORITY_AGGRO = 1	                        -- How aggressive a country is in activating a plan based on how superiour their force is.



NDefines.NAI.PLAN_ATTACK_MIN_ORG_FACTOR_LOW = 0.85							-- Minimum org % for a unit to actively attack an enemy unit when executing a plan
NDefines.NAI.PLAN_ATTACK_MIN_STRENGTH_FACTOR_LOW = 0.85						-- Minimum strength for a unit to actively attack an enemy unit when executing a plan

NDefines.NAI.PLAN_ATTACK_MIN_ORG_FACTOR_MED = 0.65							-- (LOW,MED,HIGH) corresponds to the plan execution agressiveness level.
NDefines.NAI.PLAN_ATTACK_MIN_STRENGTH_FACTOR_MED = 0.65	

NDefines.NAI.PLAN_ATTACK_MIN_ORG_FACTOR_HIGH = 0.5		
NDefines.NAI.PLAN_ATTACK_MIN_STRENGTH_FACTOR_HIGH = 0.5	



NDefines.NAI.PLAN_FACTION_STRONG_TO_EXECUTE = 0.65 --0.80	0.60		        -- % or more of units in an order to consider ececuting the plan
NDefines.NAI.ORG_UNIT_STRONG = 0.75												-- Organization % for unit to be considered strong
NDefines.NAI.STR_UNIT_STRONG = 0.75												-- Strength (equipment) % for unit to be considered strong

NDefines.NAI.PLAN_FACTION_NORMAL_TO_EXECUTE = 0.65
NDefines.NAI.ORG_UNIT_NORMAL = 0.6 --6												-- Organization % for unit to be considered normal
NDefines.NAI.STR_UNIT_NORMAL = 0.6 --6												-- Strength (equipment) % for unit to be considered normal

NDefines.NAI.PLAN_FACTION_WEAK_TO_ABORT = 0.5 --0.50		0.65		        -- % or more of units in an order to consider ececuting the plan
NDefines.NAI.ORG_UNIT_WEAK = 0.45 --0.45												-- Organization % for unit to be considered weak
NDefines.NAI.STR_UNIT_WEAK = 0.4 --0.45												-- Strength (equipment) % for unit to be considered weak

NDefines.NAI.PLAN_AVG_PREPARATION_TO_EXECUTE = 0.5				            -- % or more average plan preparation before executing
NDefines.NAI.AI_FRONT_MOVEMENT_FACTOR_FOR_READY = 0.5			                -- If less than this fraction of units on a front is moving  AI sees it as ready for action



--NDefines.NAI.PLAN_VALUE_TO_EXECUTE = -1.1                                     -- AI will typically avoid carrying out a plan it below this value (0.0 is considered balanced).

--NDefines.NAI.LOCATION_BALANCE_TO_ADVANCE = 0.0				                -- Limit on location strength balance between country and enemy for unit to dare to move forward.
NDefines.NAI.PLAN_ACTIVATION_MAJOR_WEIGHT_FACTOR = 1		                    -- AI countries will hold on activating plans if stronger countries have plans in the same location. Majors count extra (value of 1 will negate this)
NDefines.NAI.PLAN_ACTIVATION_PLAYER_WEIGHT_FACTOR = 1 		                -- AI countries will hold on activating plans if player controlled countries have plans in the same location. Majors count extra (value of 1 will negate this)
--NDefines.NAI.FRONT_TERRAIN_DEFENSE_FACTOR = 5.0 				                -- Multiplier applied to unit defense modifier for terrain on front province multiplied by terrain importance
--NDefines.NAI.FRONT_TERRAIN_ATTACK_FACTOR = 5.0 				                -- Multiplier applied to unit attack modifier for terrain on enemy front province multiplied by terrain importance
NDefines.NAI.PLAN_MIN_SIZE_FOR_FALLBACK = 5000					                -- A country with less provinces than this will not draw fallback plans  but rather station their troops along the front

--NDefines.NAI.FRONT_BULGE_RATIO_UPPER_CUTOFF = 1.5								-- If total bulginess is lower than this, the front is ignored.
--NDefines.NAI.FRONT_BULGE_RATIO_LOWER_CUTOFF = 0.95							-- If local bulginess drops below this, a point of interest is found
--NDefines.NAI.FRONT_CUTOFF_MIN_EDGE_PROXIMITY = 2								-- Minimum number of provinces to the front edge to determine for cutoff oportunity.


-- these are all 3 numbers for min, desired, max unit need weights for area defense
NDefines.NAI.AREA_DEFENSE_CAPITAL_PEACE_VP_WEIGHT = { 1.0, 1.0, 1.0 }
NDefines.NAI.AREA_DEFENSE_CAPITAL_VP_WEIGHT = { 0.0, 1.0, 2.0 }
NDefines.NAI.AREA_DEFENSE_HOME_VP_WEIGHT = { 0.0, 0.5, 1.0 }
NDefines.NAI.AREA_DEFENSE_OTHER_VP_WEIGHT = { 0.0, 0.0, 1.0 }

NDefines.NAI.AREA_DEFENSE_CAPITAL_PEACE_COAST_WEIGHT = { 0.0, 0.0, 0.0 }
NDefines.NAI.AREA_DEFENSE_CAPITAL_COAST_WEIGHT = { 0.0, 0.2, 0.7 }
NDefines.NAI.AREA_DEFENSE_HOME_COAST_WEIGHT = { 0.0, 0.1, 0.5 }
NDefines.NAI.AREA_DEFENSE_OTHER_COAST_WEIGHT = { 0.0, 0.0, 0.0 }

NDefines.NAI.AREA_DEFENSE_CAPITAL_PEACE_BASE_WEIGHT = { 0.0, 0.0, 0.0 }
NDefines.NAI.AREA_DEFENSE_CAPITAL_BASE_WEIGHT = { 0.5, 1.0, 1.5 }
NDefines.NAI.AREA_DEFENSE_HOME_BASE_WEIGHT = { 0.5, 1.0, 1.0 }
NDefines.NAI.AREA_DEFENSE_OTHER_BASE_WEIGHT = { 0.5, 0.5, 1.0 }

--------------------------------------------------------------------------------------------------------------

NDefines.NNavy.NAVAL_RANGE_TO_INGAME_DISTANCE = 0.18

NDefines.NCountry.MAJOR_MIN_FACTORIES = 50
NDefines.NDiplomacy.BASE_SURRENDER_LEVEL = 0.85
NDefines.NDiplomacy.VOLUNTEERS_PER_TARGET_PROVINCE = 0.0
NDefines.NDiplomacy.VOLUNTEERS_PER_COUNTRY_ARMY = 0.01
NDefines.NDiplomacy.VOLUNTEERS_RETURN_EQUIPMENT = 0.95
NDefines.NDiplomacy.VOLUNTEERS_TRANSFER_SPEED = 7