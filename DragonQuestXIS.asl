state("DRAGON QUEST XI S") {
	byte load:       0x5C797A0;                                             //1 when loading and mode == 4
	byte fade:       0x5EFB2CA;                                             //1 when fading and mode == 5, gets stuck on 1 when switching to 3D
	byte cs:         0x5F55CE4;                                             //1 during skippable cutscenes
	byte mode:       0x58057F0;                                             //4 in 3D, 5 in 2D
	byte start:      0x5C4B713; 	                                        //some variable that consistently goes to 0 from non-0 on run start
	byte jingle:     0x5BEF771;                                             //non-0 when jingle 
	byte menu_index: 0x3110F34, 0x1C4, 0xC0, 0x4F8, 0x3E8;                  //the number of the option selected in the main menu, flickers randomly during gameplay
	byte dialogue:   0x26814E4, 0x218;                                      //1 when in dialogue, can flicker from 1 to 0 occasionally but seems to never flicker from 0 to 1
	string100 tb2d:  0x5EF1614;                                             //text in the bottom textbox (dialogue, combat) when mode == 5
	string200 area:  0x5C08210, 0x220, 0xE0, 0x20, 0x14;                    //area label, updates when the golden text appears on screen, gets wiped on any dialogue/menu
	float xPos:      0x5E6EE10, 0x8, 0x8, 0x1A0, 0x548, 0x300, 0x1C0, 0xA0; //horizontal in 3D
	float yPos:      0x5E6EE10, 0x8, 0x8, 0x1A0, 0x548, 0x300, 0x1C0, 0xA4; //horizontal in 3D
	float zPos:      0x5E6EE10, 0x8, 0x8, 0x1A0, 0x548, 0x300, 0x1C0, 0xA8; //vertical in 3D
	int gold:        0x5C08210, 0x128, 0xC0;                                //money, only updates in 3D
	int xp:          0x5C08210, 0x128, 0xF0, 0x0, 0xB0;                     //experience, only updates in 3D
}

startup {
	vars.splits = new string[,] {
		{"22", "Smogs"},
		{"74", "Tricky Devil"},
		{"162", "Gryphons"},
		{"Jarvis1", "Jarvis"},
		{"1000", "Slayer of Sands"},
		{"126", "Corallosuses"},
		{"2000", "Jasper 1"},
		{"120", "Arena 1"},
		{"150", "Arena 2-1"},
		{"180", "Arena 2-2"},
		{"arena3", "Arena 2-3"}, 
		{"2700", "Arachtagon"},
		{"2dgrind1", "2D Grind"},
		{"squid", "Tentacular"},
		{"act2", "Act 2 Start"},
		{"scenarios", "Scenarios"},
		{"Tyriant", "Tyriant"},
		{"Rab", "Rab"},
		{"10000", "Avarith"},
		{"30000", "Gyldygga"},
		{"9600", "Tatsunanga 2"},
		{"15000", "Indingus"},
		{"20000", "Jasper Unbound"},
		{"MordegonTail", "Mordegon and Tail"},  //battle end split
		{"WTJasper", "World Tree Jasper"},
		{"MordegonSolo", "Mordegon 2"},
		{"quest", "Perfectly Pepped Paladins Quest (2D only)"},
		{"Calasmos", "Calasmos"}
	};
	
	for (int i = 0; i < vars.splits.GetLength(0); i++) {
		settings.Add(vars.splits[i, 0], true, vars.splits[i, 1]);
	}
	
	vars.valid_areas = new List<string>{"The Void", "The Cryptic Crypt", "Lonalulu", "The World Tree", "Heliodor Castle", "Arena - Waiting Room", "Fortress of Fear - Palace of Malice"};
	vars.doneSplits = new List<string>();
	
	vars.wait_for_cutscene = false;
	vars.wait_for_jingle = false;
	vars.start_ready = false;
	vars.area_ready = "";
	vars.last_area = "";
}

init {
	timer.IsGameTimePaused = false;
}

start {
	
	if (current.menu_index == 1 && old.menu_index != 1) {
		vars.start_ready = true;
	}
	
	if (vars.start_ready == true && current.start == 0 && old.start != 0) {
		vars.last_area = "";
		vars.area_ready = "";
		vars.wait_for_jingle = false;
		vars.start_ready = false;
		vars.wait_for_cutscene = false;
		vars.doneSplits.Clear();
		return true;
	}
}

split {
	
	if (current.area != null && current.area != old.area && vars.valid_areas.Contains(current.area.Split(',')[0].Substring(1)) && current.load == 0 && current.dialogue == 0) {
		vars.last_area = current.area.Split(',')[0].Substring(1);
	}
	
	if (vars.area_ready == "" || vars.area_ready == "mordegon") {
		if (vars.last_area == "Heliodor Castle") {
			if (current.xPos > -152 && current.xPos < 152 && current.yPos <= -5394 && current.zPos > 1795 && current.zPos < 1956 && !vars.doneSplits.Contains("Tyriant")) {
				vars.area_ready = "tyr";
			}
			else if (!vars.doneSplits.Contains("MordegonSolo")) {
				vars.area_ready = "mordegon";
			}
		}
	}
	
	if (vars.area_ready == "") {
		if (vars.last_area == "Arena - Waiting Room" && !vars.doneSplits.Contains("arena3")) {
			vars.area_ready = "arena1";
		}
		
		if (vars.last_area.Contains("The Cryptic Crypt") && !vars.doneSplits.Contains("Jarvis1")) {
			vars.area_ready = "Jarvis1";
		}
		
		if (vars.last_area.Contains("The Void") && !vars.doneSplits.Contains("Rab")) {
			vars.area_ready = "Rab";
		}
		
		if (vars.last_area.Contains("Lonalulu") && !vars.doneSplits.Contains("squid")) {
			vars.area_ready = "squid";
		}
		
		if (vars.last_area.Contains("The World Tree") && !vars.doneSplits.Contains("WTJasper")) {
			vars.area_ready = "WTJasper";
		}
		
		if (vars.last_area == "Fortress of Fear - Palace of Malice" && !vars.doneSplits.Contains("MordegonTail")) {
			vars.area_ready = "mordy0";
		}
	}
	
	//money based
	if (current.gold > old.gold && old.gold != 0) {
		
		int reward = 0;
		
		if ((current.gold - old.gold) >= 30000 && (current.gold - old.gold) < 40000) {
			reward = 30000;
		} else if ((current.gold - old.gold) >= 20000 && (current.gold - old.gold) < 30000) {
			reward = 20000;
		} else {
			reward = current.gold - old.gold;
		}

		switch (reward) {
			case 22: case 74: case 162: case 1000: case 126: case 2000: case 2700: case 10000: case 20000: case 9600: case 15000: case 30000:
			if (settings[reward.ToString()] && !vars.doneSplits.Contains(reward.ToString())) {
				vars.wait_for_cutscene = true;
				vars.doneSplits.Add(reward.ToString());
			}
			break;
			
			case 120: case 150:
			if (vars.area_ready == "arena1") {
				if (settings[reward.ToString()] && !vars.doneSplits.Contains(reward.ToString())) {
					vars.wait_for_cutscene = true;
					vars.doneSplits.Add(reward.ToString());
				}
			}
			break;
			
			case 180:
			if (settings[reward.ToString()] && !vars.doneSplits.Contains(reward.ToString())) {
				vars.wait_for_cutscene = true;
				vars.area_ready = "arena3";
				vars.doneSplits.Add(reward.ToString());
			}
			break;
			
			case 500: case 4000:
			if (vars.area_ready == "Jarvis1" && settings["Jarvis1"] && !vars.doneSplits.Contains("Jarvis1")) {
				vars.wait_for_cutscene = true;
				vars.doneSplits.Add("Jarvis1");
				vars.area_ready = "";
			} 
			else if (vars.area_ready == "Rab" && settings["Rab"] && !vars.doneSplits.Contains("Rab")) {
				vars.wait_for_cutscene = true;
				vars.doneSplits.Add("Rab");
				vars.area_ready = "";
			}
			else if (vars.area_ready == "squid" && settings["squid"] && !vars.doneSplits.Contains("squid")) {
				vars.wait_for_cutscene = true;
				vars.doneSplits.Add("squid");
				vars.area_ready = "";
			}
			else if (vars.area_ready == "WTJasper" && settings["WTJasper"] && !vars.doneSplits.Contains("WTJasper")) {
				vars.wait_for_cutscene = true;
				vars.doneSplits.Add("WTJasper");
				vars.area_ready = "";
			}
			break;
			
			case 8000:
			if (vars.area_ready == "mordegon" && settings["MordegonSolo"] && !vars.doneSplits.Contains("MordegonSolo")) {
				vars.wait_for_cutscene = true;
				vars.doneSplits.Add("MordegonSolo");
				vars.area_ready = "";
			}
			
			else if (vars.area_ready == "tyr" && settings["Tyriant"] && !vars.doneSplits.Contains("Tyriant")) {
				vars.wait_for_cutscene = true;
				vars.doneSplits.Add("Tyriant");
				vars.area_ready = "";
			}
			break;
			
			default:
			break;
		}
	}
	
	//position based
	if (current.xPos != old.xPos) {
		if (old.xPos == 0 && old.yPos == 0 && old.zPos == 0) {
			if (current.xPos >= 24224 && current.xPos <= 24225 && current.yPos >= 14524 && current.yPos <= 14525 && current.zPos >= 7532 && current.zPos <= 7533) {
				if (settings["scenarios"] && !vars.doneSplits.Contains("scenarios")) {
					vars.doneSplits.Add("scenarios");
					return true;
				}
			}
		
			if (current.xPos >= -1405 && current.xPos <= -1404 && current.yPos >= 3887 && current.yPos <= 3888 && current.zPos >= 1130 && current.zPos <= 1131) {
				if (current.xp > 60000 && settings["2dgrind1"] && !vars.doneSplits.Contains("2dgrind1")) {
					vars.doneSplits.Add("2dgrind1");
					return true;
				}
			}
			
			if (current.xPos >= -5 && current.xPos <= -4 && current.yPos >= 13571 && current.yPos <= 13572 && current.zPos >= 208 && current.zPos <= 209) {
				if (settings["act2"] && !vars.doneSplits.Contains("act2")) {
					vars.doneSplits.Add("act2");
					return true;
				}
			}
		}
		
		if (current.xPos >= -20 && current.xPos <= -19 && current.yPos >= -2221 && current.yPos <= -2220 && current.zPos >= 1201 && current.zPos <= 1202) {
			if (vars.area_ready == "arena3" && settings["arena3"] && !vars.doneSplits.Contains("arena3")) {
				vars.doneSplits.Add("arena3");
				vars.area_ready = "";
				return true;
			}
		}		
	}
	
	//2d text based
	
	if (current.tb2d.Contains("Perfectly Pepped Paladins") && !vars.doneSplits.Contains("quest")) {
		vars.doneSplits.Add("quest");
		return settings["quest"];
	}
		
	if (current.tb2d == "Calasmos is defeated." && !vars.doneSplits.Contains("Calasmos")) {
		vars.doneSplits.Add("Calasmos");
		return settings["Calasmos"];
	}
	
	//any% end split
	//i hate this code but im so done with this game at this point that im not improving it
	if (vars.area_ready == "mordy0" && current.xPos == 0 && current.yPos == 0 && current.zPos == 0 && old.xPos > 0) {
		if (!vars.area_ready.Contains("mordy")) {
			vars.area_ready = "mordy";
		}
	}
	
	if (vars.area_ready == "mordy" && current.cs == old.cs - 1) {
		vars.area_ready = "mordy1";
	}
	
	if (vars.area_ready == "mordy1" && current.cs == old.cs + 1) {
		vars.area_ready = "mordy2";
	}
	
	if (vars.area_ready == "mordy2" && current.cs == old.cs - 1) {
		vars.area_ready = "mordy_fin";
	}
	
	if (vars.area_ready == "mordy_fin") {
		vars.wait_for_jingle = true;
	}
	
	if (current.dialogue == 1 && current.jingle == 0 && old.jingle > 0 && vars.wait_for_jingle) {
		vars.wait_for_jingle = false;
		vars.area_ready = "";
		vars.doneSplits.Add("MordegonTail");
		return true;
	}
	
	if (current.cs == old.cs + 1 && vars.wait_for_cutscene == true) {
		vars.wait_for_cutscene = false;
		return true;
	}
}

isLoading {
	return current.load == 1 || (current.fade == 1 && current.mode == 5);
}

exit {
	timer.IsGameTimePaused = true;
}
