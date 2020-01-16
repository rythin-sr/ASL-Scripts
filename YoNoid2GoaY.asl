// Autosplitter/Game Time for Yo! Noid 2: Game of a Year Edition
// Made by rythin (contact @rythin_sr on twitter/twitch and rythin#0135 on discord)
// With help from SpectralPlatypus (t.tv/SpectralPlatypus)

// Game Time will most likely not work because unity sucks
// Autosplitting will work always, except for BossSplit 
// again, unity sucks.
// to make BossSplit work, restart the game until it decides to play nice

// Changelog:
// 1.0 - initial release
// 1.1 - added IGT
// 2.0 - complete re-write with settings
// 2.1 - added BossSplit and final split, fixed wrong/missing splits
// 2.2 - added a BossSplit check setting

state("noid") {
	string4	level1: "mono.dll", 0x00298AE8, 0x20, 0x478, 0x8, 0x38, 0x44;
	string4	levelL: "mono.dll", 0x00298AE8, 0x20, 0x478, 0x8, 0x38, 0x48;
	long gameTime: "mono.dll", 0x00298AE8, 0xC8, 0x2C8, 0x80, 0x40, 0xD0;
	int gameEnd: "mono.dll", 0x00298AE8, 0x20, 0x4A0, 0x28;
	int bossState: "mono.dll", 0x00298AE8, 0xC8, 0x248, 0x80, 0x40, 0x0;
}
	
startup {
	settings.Add("Autosplit", true, "Enable autosplitting");
	settings.Add("NYtoV", true, "New York -> Noid Void", "Autosplit");
	settings.Add("VtoF", false, "Noid Void -> Swing Factory", "Autosplit");
	settings.Add("FtoV", true, "Swing Factory -> Noid Void", "Autosplit");
	settings.Add("VtoD", false, "Noid Void -> Domino Dungeon", "Autosplit");
	settings.Add("DtoV", true, "Domino Dungeon -> Noid Void", "Autosplit");
	settings.Add("VtoP", false, "Noid Void -> Plizzanet", "Autosplit");
	settings.Add("PtoV", true, "Plizzanet -> Noid Void", "Autosplit");
	settings.Add("VtoM", false, "Noid Void -> Mike's Lair", "Autosplit");
	settings.Add("BossSplit", false, "Split upon starting the Mike fight", "Autosplit");
	settings.Add("MikeSplit", false, "Split when quitting to menu from Mike's Lair");
	settings.Add("BossCheck", false, "Print whether Mike fight split will work (requires DbgView)", "BossSplit");
	settings.SetToolTip("BossSplit", "BossSplit");
}

update {
	if (current.bossState > 8) {
		print("Mike split: Broken");
	}
	
	if (current.bossState < 8) {
		print("Mike split: Working(hopefully)");
	}
}

start {
	return (current.level1 == " int");
	}
	
reset {
	if (current.level1 == " tit" && old.level1 == " Mik" && settings["MikeSplit"] == true) {
		return false;
	}
	
	if (current.level1 == " tit" && settings["MikeSplit"] == false) {
		return true;
	}
}
	
split {
	
	if (settings["Autosplit"] == true) {
		
		if (old.levelL == "elIn" && current.level1 == " voi" && settings["NYtoV"] == true) {
			return true;
		}
		
		if (old.level1 == " voi" && current.levelL == "iLev" && settings["VtoF"] == true) {
			return true;
		}
		
		if (old.levelL == "iLev" && current.level1 == " voi" && settings["FtoV"] == true) {
			return true;
		}
		
		if (old.level1 == " voi" && current.level1 == " dun" && settings["VtoD"] == true) {
			return true;
		}
		
		if (old.level1 == " dun" && current.level1 == " voi" && settings["DtoV"] == true) {
			return true;
		}
		
		if (old.level1 == " voi" && current.level1 == " PZN" && settings["VtoP"] == true) {
			return true;
		}
		
		if (old.level1 == " PZN" && current.level1 == " voi" && settings["PtoV"] == true) {
			return true;
		}
		
		if (old.level1 == " voi" && current.level1 == " Mik" && settings["VtoM"] == true) {
			return true;
		}
		
		if (old.level1 == " Mik" && current.level1 == " tit" && settings["MikeSplit"] == true) {
			return true;
		}
		
		if (current.bossState == 6 && old.bossState == 5 && current.level1 == " Mik" && settings["BossSplit"] == true) {
			return true;
		}
		
		if (current.gameEnd == 1 && old.gameEnd == 0 && current.level1 == " Mik") {
			return true;
		}
	}
}

gameTime{
	return TimeSpan.FromMilliseconds(current.gameTime /10000);
}

isLoading {
	return true;
}

