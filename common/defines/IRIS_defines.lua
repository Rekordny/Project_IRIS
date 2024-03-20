NDefines.NGame.START_DATE = "3090.1.1.12"
NDefines.NGame.END_DATE = "3103.1.1.1"


NDefines.NDiplomacy.TENSION_TIME_SCALE_START_DATE = "3090.1.1.12"
NDefines.NDiplomacy.MAX_OPINION_VALUE = 200							-- Max opinion value cap.
NDefines.NDiplomacy.MIN_OPINION_VALUE = -200						-- Min opinion value cap.

NDefines.NCountry.MIN_STABILITY = -1.0
NDefines.NCountry.MAX_WAR_SUPPORT = 1.0					

--------------------------------------------------------------------------------------------------------------
-- LAND AI
--------------------------------------------------------------------------------------------------------------

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