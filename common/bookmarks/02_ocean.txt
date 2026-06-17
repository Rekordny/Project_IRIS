bookmarks = {
	bookmark = {
		name = "ocean_NAME"
		desc = "ocean_DESC"
		date = 3090.1.1.12
		picture = "GFX_select_date_ocean"
		default_country = "OCE"
		
		# "SLL" = {
		# 	history = "SLL_GATHERING_STORM_DESC"
		# 	ideology = neutrality
		# 	ideas = {
				
		# 	}
		# 	focuses = {
		# 	}
		# }
		
		"OCE"={
			history = "OCE_GATHERING_STORM_DESC"
			ideology = neutrality
			ideas = {
				OCE_idea_Federation_Ocean
				OCE_idea_Expand_ideological_police
				OCE_idea_fourth_three_year_plan
			}
			focuses = {
				OCE_Osia_is_supreme
				OCE_Federation_Ocean
			}
		}

		AKL = {
			history = "AKL_GATHERING_STORM_DESC"
			ideology = democratic
			ideas = {
				AKL_dark_memory
				AKL_reubild_our_country
				AKL_spirit_of_empire
			}
			focuses = {
				AKL_opening_1
				AKL_akari_ending
			}
		}


		BRG = {
			# minor = yes
			history = "BRG_GATHERING_STORM_DESC"
			ideology = neutrality
			ideas = {
				BRG_pain_separation
				BRG_arms_limitation
				BRG_economic_collapse
			}
			focuses = {
				BRG_focus_tree_1
				BRG_focus_MacArthur_14
			}
			label = { label_2 }
		}



		effect = {
			randomize_weather = 22345 # <- Obligatory in every bookmark !
			#123 = { rain_light = yes }
		}
	}
}
