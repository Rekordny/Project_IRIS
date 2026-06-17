bookmarks = {
	bookmark = {
		name = "ouluoba_NAME"
		desc = "ouluoba_DESC"
		date = 3090.1.1.12
		picture = "GFX_select_date_ouluoba"
		default_country = "USR"
		# filters = { new_content continent label_1 label_2 }
		default = yes
		"USR" = {
			history = "USR_GATHERING_STORM_DESC"
			ideology = fascism
			ideas = {
				USR_who_owns_the_republic
				USR_the_clemen_treaty
				USR_the_republic_congress
			}
			focuses = {
				USR_real_nishizumi_ryu
				USR_kings_title_is_a_glorious_chore
			}
		}
		
		"ELN" = {
			history = "ELN_GATHERING_STORM_DESC"
			ideology = neutrality
			ideas = {
				ELN_Aftermath_of_Black_Foaming_Night
				ELN_Quagmire_of_war
				ELN_Political_chaos
			}
			focuses = {
				ELN_Rearmament
				ELN_Partial_mobilization

				# ELN_Red_Dawn
				# ELN_Hold_general_elections
				#ELN_Breaking_promises
			}
			#label = { label_1 }
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
			#label = { label_2 }
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
			#label = { label_1 }
		}
		"ANZ" = {
			history = "ANZ_GATHERING_STORM_DESC"
			ideology = fascism
			ideas = {
				ANZ_ancient_mana_tradition
				ANZ_imbalance_development
				ANZ_senshado_industrialization
			}
			focuses = {
				ANZ_santa_sede_and_its_children
				ANZ_salute_to_shout
			}
			#label = { label_1 }
		}
		
		
		
		
		#minor

		"STG"={
			minor = yes
			history = "STG_GATHERING_STORM_DESC"
			ideology = democratic
			ideas = {
				STG_paradox
				STG_Graceful_Army
				STG_Nervous_Army
			}
			focuses = {
				STG_mil_11
				STG_grey_5
				#STG_mil_17
			}
			#label = { label_1 }
		}
		
		
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
			#label = { label_1 }
		}
		
		
		CID = {
			minor = yes
			history = "CID_GATHERING_STORM_DESC"
			ideology = neutrality
			ideas = {
				CID_new_constitution_idea
				CID_Unrecognized_regime
				CID_loan_ideas
			}
			focuses = {
				CID_Consolidate_coastal_defense
				CID_Expand_legacy_industries
			}
			#label = { label_1 }
		}
	}
}
