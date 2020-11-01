//Red Faction Guerrilla Autosplitter + Load Remover by rythin

//Contanct info in case issues arise:
//Discord: rythin#0135
//Twitter: rythin_sr
//Twitch:  rythin_sr

//changelog:
//(31/05/2020) 1.0 - initial script
//(27/06/2020) 1.1 - added support for re-mars-tered edition
//(04/08/2020) 1.2 - added support for DLC missions, rewrote everything cutscene-based 
//(04/08/2020) 1.2.1 - hopefully fixed early split for marauder cutscene 
//(05/08/2020) 1.2.1.1 - fixed the name of the first mission

state("RFG", "Steam") {

	//basic splitting
	int missions:			0xDDC350;	//completed mission counter
	string35 missionVid:		0x1C8FF0D; 	//name of the little video that plays before each mission, updates when a new one plays
	int activities:			0xDDC3BC;	//completed guerrilla activity counter
	int cutscene:			0x10FF210;	//1 in cutscene, 0 otherwise
	int subCS:			0x7EACD0;	//different values on different cutscenes, only when subtitles are on
	int loading:			0x768D90;	//0 in loads, menu and the first cutscene (why?), 1 otherwise
	
	//collectibles & hundo related
	int ores:			0xDDDC34;
	int radioLogs:			0x1102CD8;
	int pwrCells:			0xDECFA0;
	
	//currently unused 
	//int crates:			0xDDDE50;	//EDF Supply Crates counter
	//int sectors:			0xDCEA48;	//liberated sectors counter
}

state("RFG", "Remarstered") {

	//basic splitting
	int missions:			0x21126B0;	
	string35 missionVid:		0x27DB1F5; 	
	int activities:			0x211275C;	
	int cutscene:			0x21338B4;
	int subCS:			0x124BEB4;
	int loading:			0x125E86C;
	
	//collectibles & hundo related
	int ores:			0x2114E54;
	int radioLogs:			0x279DCE0;
	int pwrCells:			0x212D200;
}
	
startup {

	settings.Add("missions", true, "Main Missions");
	settings.Add("dlc", true, "DLC Missions");
	
	//missions
	
	var m = new Dictionary<string,string> { 				
		{"tutorial", "Welcome to Mars"},
		{"intro_1.bik", "Better Red Than Dead"}, 					
		{"intro_2.bik", "Ambush"},
		{"we_know_where_you_are.bik", "Start Your Engines"},
		{"walker_martian_ranger.bik", "Industrial Revolution"},
		{"friends_martians_countrymen.bik", "Rallying Point"},
		{"partytime.bik", "Ultor Echo"},
		{"death_from_above.bik", "Ashes to Ashes..."},
		{"refugee_truck.bik", "Emergency Response"},
		{"highway_to_hell.bik", "Catch and Release"},
		{"start_your_engines.bik", "Air Traffic Control"},
		{"traffic_jam.bik", "Access Denied"},
		{"tank_attack.bik", "Blitzkrieg"},
		{"guns_of_tharsis.bik", "The Guns of Tharsis"},
		{"death_by_committee.bik", "Death by Committee"},
		{"sniper_hunter.bik", "The Dogs of War"},
		{"save_the_guerrilla_camp.bik", "Hammer of the Gods"},
		{"marauderCS", "Marauder Negotiations (Cutscene)"},
		{"ants_vs_magnifying_glass.bik", "Manual Override"},
		{"emergency_broadcast_system.bik", "Emergency Broadcast System"},
		{"assault_the_edf_central_command.bik", "Guerrillas at the Gates"},
		{"final_mission.bik", "Mars Attacks"}
	};

	foreach (var Tag in m) {							
		settings.Add(Tag.Key, true, Tag.Value, "missions");					
	};
	
	settings.SetToolTip("marauderCS", "This specific autosplit is still a WIP, for now subtitles are required to be ON for it to work.");
	
	var dlcm = new Dictionary<string, string> {
		{"dlc_mission_1.bik", "Rescue"},
		{"dlc_mission_2.bik", "Retribution"},
		{"dlc_mission_3.bik", "Redemption"}
	};
	
	foreach (var Tag in dlcm) {							
		settings.Add(Tag.Key, true, Tag.Value, "dlc");					 
	};
	
	//while technically this should never be necessary, i noticed the mission count flicker to 0
	//in loading screens, which may cause issues in case of dying after the first mission
	//i suppose it could still cause issues if you die on the 2nd mission, but this is 
	//an edge case i dont feel like preventing atm
	
	//update: preventing splitting in loading screens actually makes this obsolete but i'll keep 
	//it around since there's no real reason not to
	vars.doneSplit = new List<string>();
	
	//variable used to split correctly at the end of the intro
	vars.introSplit = 0;
	
	//activities *WIP*
	
	settings.Add("act", true, "Activities");
	settings.Add("actAll", false, "Split on completing any Guerrilla Activity", "act");
	
	//initially i wanted to be able to enable/disable every activity but nah its not happening lol
	//var a = new Dictionary<string, string> {
	//	{"", ""}
	//};
	
	//vars.al = new List<string>();						
	//foreach (var Tag in vars.a) {							
	//	settings.Add(Tag.Key, true, Tag.Value, "act");					
	//};
	
	//collectibles
	settings.Add("col", false, "Collectibles");
	settings.Add("ore1", false, "Split when destroying an ore cluster", "col");
	settings.Add("ore300", false, "Split upon having destroyed all 300 ore clusters", "col");
	settings.Add("log1", false, "Split upon collecting a Radio Log", "col");
	settings.Add("log36", false, "Split upon collecting all 36 Radio Logs", "col");
	settings.Add("pwr1", false, "(DLC) Split upon collecting a Power Cell", "col");
	settings.Add("pwr75", false, "(DLC) Split upon collecting all 75 Power Cells", "col");
	//crates are probably not necessary for hundo
	//settings.Add("crate1", false, "Split upon destroying an EDF Supply Crate", "col");
	//settings.Add("crate250", false, "Split upon having destroyed all 250 EDF Supply Crates", "col");
}

init {
	
	if (modules.First().ModuleMemorySize == 60276736) {
		version = "Remarstered";
	}
	
	else if (modules.First().ModuleMemorySize == 34639872) {
		version = "Steam";
	}
	
	else {
		version = "Unsupported";
	}
	
	//print(modules.First().ModuleMemorySize.ToString());
}

update {

	if (version == "Unsupported") {
		return false;
	}
	
	if (current.cutscene == 0 && old.cutscene == 1) {
		vars.introSplit++;
	}
	
}

start {
	//most likely has a couple false-positives but cutscenes in this game are so few and far between
	//i dont really care honestly
	if (current.cutscene == 1 && old.cutscene == 0 && current.missions == 0) {
		vars.introSplit = 0;
		vars.doneSplit.Clear();
		return true;
	}
}

split {

	//MAIN MISSION SPLITS

	//intro split
	//seems like there's 2 cutscenes in the game that share the same ID, but since this is not one of them
	//its convenient enough to use for the split after the intro
	if (current.cutscene == 0 && old.cutscene == 1 && settings["tutorial"] == true && vars.introSplit == 2 && current.missions == 0) {
		return true;
	}
	
	//split on completing a mission
	if (current.missions == old.missions + 1 && settings[current.missionVid] == true && !vars.doneSplit.Contains(current.missionVid) && current.loading != 0) {
		vars.doneSplit.Add(current.missionVid);
		return true;
	}
	
	//split on marauder cutscene
	if (current.subCS == 0 && old.subCS == 23 && settings["marauderCS"] == true) {
		return true;
	}
	
	//ACTIVITIES
	
	//to be improved at a later date
	//for now it just splits on any activity completion
	if (current.activities == old.activities + 1 && settings["actAll"] && current.loading != 0) {
		return true;
	}
	
	//COLLECTIBLES
	
	//ores
	//logic for when its set to only split for full completion and NOT to split for every ore
	if (settings["ore300"] == true && settings["ore1"] == false) {
		if (current.ores == 300 && old.ores == 299) {
			return true;
		}
	}
	
	//if splitting for every ore is enabled we can safely ignore the other setting
	//all this is simply to prevent double split on final pickup in case both options are enabled
	if (settings["ore1"] == true && current.ores > old.ores) {
		return true;
	}
	
	//radio logs
	//this is just a copy-paste of the bit above with altered variables to work for radio logs 
	if (settings["log36"] == true && settings["log1"] == false) {
		if (current.radioLogs == 36 && old.radioLogs == 35) {
			return true;
		}
	}
	
	if (settings["log1"] == true && current.radioLogs > old.radioLogs) {
		return true;
	}
	
	//power cells
	if (settings["pwr75"] == true && settings["pwr1"] == false) {
		if (current.pwrCells == 75 && old.pwrCells == 74) {
			return true;
		}
	}
	
	if (settings["pwr1"] == true && current.pwrCells > old.pwrCells) {
		return true;
	}
}

isLoading {
	//pauses the timer from the moment a loading screen appears until gaining control of mason after a load
	//id prefer it to unpause the moment the loading screen disappears but i cba looking for a better address
	
	//the loading address also goes to 0 in the first cutscene as you start a run, where it shouldn't be paused
	return current.loading == 0 && current.cutscene != 1;
}
