// SAS: Secure Tomorrow Autosplitter/Load Remover made by rythin, contact in case you encounter any issues: 
// Discord: rythin#0135, Twitter: @rythin_sr, Twitch: rythin_sr

state("game") {
	int gameLoading: 		0x1BC48C;	//1 during gameplay, 0 in loads
	int gameLoading2: 		0x1C50CC;	//non 0 during gameplay
	int fmv: 				0x1BC668;	//2 outside of fmv
	int save: 				0x1C1A21;	//non 0 during saving lag
	string10 level: 		0x1C616D;	//map name
}

startup {

	var s = new Dictionary<string, string> {
		{@"SAS_lvl_1\", "Flashback"},
		{@"SAS_lvl_2\", "In Pursuit"},
		{@"SAS_lvl_3\", "Kick in the Wallet"},
		{@"SAS_lvl_4\", "Money for nothing"},
		{@"SAS_lvl_5\", "Worthless digits"},
		{@"SAS_lvl_8\", "Cold Day in Hell"},
		{@"SAS_lvl_9\", "Sharpshooter"},
		{"SAS_lvl_10", "Camp Century"},
		{"SAS_lvl_11", "Steps Down"},
		{"SAS_lvl_12", "Cold Path"},
		{"finale", "Two Birds One Stone"}
	};
	
	foreach (var Tag in s) {
		settings.Add(Tag.Key, true, Tag.Value);
	};
	
	vars.done_splits = new List<string>();
}

start {
	if (current.level.Contains("SAS_lvl_1") && current.gameLoading != 0 && old.gameLoading == 0) {
		vars.done_splits.Clear();
		return true;
	}
}
	
split {
	if (current.level != old.level && old.level != "" && !vars.done_splits.Contains(old.level)) {
		vars.done_splits.Add(old.level);
		return settings[old.level];
	}
	
	if (current.level == "SAS_lvl_13" && current.fmv == 0 && old.fmv == 2) {
		return settings["finale"];
	}
}
	
isLoading {
	if (current.level != "SAS_lvl_13" && current.gameLoading == 0 || current.save != 0) {
		return true;
	}

	if (current.level == "SAS_lvl_13" && current.gameLoading2 != 1) {
		return true;
	}

	else {
		return false;
	}
}
	
exit {
	timer.IsGameTimePaused = true;
}

