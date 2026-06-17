bookmarks = {
	bookmark = {
		name = "ouluoba_NAME"
		desc = "ouluoba_DESC"
		date = 3090.1.1.12
		picture = "GFX_select_date_ouluoba"
		default_country = "USR"
		# filters = { label_1 label_2 label_3 label_4 label_5 }
		default = yes

		"ELN" = {
			history = "ELN_GATHERING_STORM_DESC"
			ideology = neutrality
			ideas = {
				ELN_Aftermath_of_Black_Foaming_Night
				ELN_Quagmire_of_war
				#ELN_Political_chaos
			}
			focuses = {
				ELN_Red_Dawn
				ELN_Hold_general_elections
				#ELN_Breaking_promises
			}
			label = { label_1 }
		}
		"UNG"={
			history = "UNG_GATHERING_STORM_DESC"
			ideology = neutrality
			ideas = {
				UNG_idea_tuolidalu
				UNG_idea_ziyouanggeliyayundong
			}
			focuses = {
				UNG_Tianyouwuwang
				UNG_Angeliyagongtongtijinshen
			}
			label = { label_1 }
		}
		"DOC" = {
			history = "DOC_GATHERING_STORM_DESC"
			ideology = neutrality
			ideas = {
				DOC_Disaster_of_Black_Foaming_Night
				DOC_Undercurrents_of_Politics
				DOC_Thunder_Action_for_New_Grand_Duke
			}
			focuses = { 
				DOC_NF_A16_Break_the_Old_Shackle
				DOC_NF_A16_1_Run_Neck_and_Neck_for_Brilliance
				#DOC_NF_A01_Restore_order
				#DOC_NF_B01_Break_Reaffirmation_of_the_System_of_Primogeniture
				#DOC_NF_A_LAST_The_Now_Is_Here_The_Future_Is_the_Future
			}
			label = { label_2 }
		}
		"SKR"={
			history = "SKR_GATHERING_STORM_DESC"
			ideology = neutrality
			ideas = {
				SKR_shinsengumi_idea
				SKR_declining_bakufu
				SKR_black_foaming_night_north
			}
			focuses = {
				SKR_samurai_glory
				SKR_honoka_banzai
			}
			label = { label_4 }
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
			label = { label_4 }
		}
		
		
		
		
		
		
		#minor
		
		MDS = {
			minor = yes
			history = "MDS_GATHERING_STORM_DESC"
			ideology = democratic
			ideas = {
				MDS_whisper
				MDS_puppet_army
				MDS_puppet_modifier
			}
			focuses = {
				MDS_focus_dip_4
				MDS_focus_alt_6

			}
			label = { label_1 }
		}
		IKR = {
			minor = yes
			history = "IKR_GATHERING_STORM_DESC"
			ideology = neutrality
			ideas = {
				IKR_treaty_of_west_Istabul
				IKR_treaty_of_east_Istabul
				IKR_drug
			}
			focuses = {
				IKR_2
				IKR_restoration_final
			}
			label = { label_3 }
		}
		YUZ = {
			minor = yes
			history = "YUZ_GATHERING_STORM_DESC"
			ideology = neutrality
			ideas = {
				YUZ_nation_of_galgame
				YUZ_aftermath_of_crisis
				YUZ_yuzufan_army
			}
			focuses = {
				
			}
			label = { label_5 }
		}
		"BOW"={
			minor = yes
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
			label = { label_5 }
		}
	}
}
