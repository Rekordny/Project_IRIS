bookmarks = {
	bookmark = {
		name = "meiledi_NAME"
		desc = "meiledi_DESC"
		date = 3090.1.1.12
		picture = "GFX_select_date_meiledi"
		default_country = "BOW"
		
		"BOW"={
			history = "BOW_GATHERING_STORM_DESC"
			ideology = neutrality
			ideas = {
				BOW_feud_of_era_standing
				BOW_dysprosium
				WML_idea_concession_dependence
			}
			focuses = {
				BOW_A_sudden_war
				BOW_ABA_ours_new_republic
			}
		}
		"MAG"={
			history = "MAG_GATHERING_STORM_DESC"
			ideology = neutrality
			ideas = {
				MAG_AA_yhzl1
				MAG_AD_whhpdjd
				MAG_AN_fkdgd
			}
			focuses = {
				MAG_AA_pfsndhy
				MAG_AN_gjsj
			}
		}
		RLN = {
			history = "RLN_GATHERING_STORM_DESC"
			ideology = communism
			ideas = {
				RLN_country_on_railroad
				RLN_love_peace
				RLN_engine_of_meiledi
			}
			focuses = {
				RLN_econ_16
				RLN_final
			}
		}
		YUZ = {
			history = "YUZ_GATHERING_STORM_DESC"
			ideology = neutrality
			ideas = {
				YUZ_nation_of_galgame
				YUZ_aftermath_of_crisis
				YUZ_yuzufan_army
			}
			focuses = {
				
			}
		}
		"TAU"={
			history = "TAU_GATHERING_STORM_DESC"
			ideology = neutrality
			ideas = {
				TAU_independent_political_status
				TAU_glorious_inheritance
				TAU_away_from_human
			}
			focuses = {
				TAU_the_treble_tradition
				TAU_restart_ura_competition
			}
		}





		effect = {
			randomize_weather = 22345 # <- Obligatory in every bookmark !
			#123 = { rain_light = yes }
		}
	}
}
