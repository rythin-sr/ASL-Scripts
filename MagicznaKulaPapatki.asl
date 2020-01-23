// Magiczna Kula Papatki Autosplitter + Load Remover by rythin
// Contact info:
// Discord - rythin#0135
// Twitter - @rythin_sr
// Twitch - rythin_sr

// Changelog:
// 1.0 - Initial release, added autostart, split, reset, load removal and settings
// 1.1 - fixed(?) final split not working Sometimes(tm)

state("gratka3d") {
	string7 mapName: 0xB2968; 
	int gameLoading: 0xB3818; //0 when gameplay is happening, some high number when loading. Seems more accurate than other pointers?
}

startup {
	//add settings 
	settings.Add("01", false, "Intro -> Level01");
	settings.Add("12", true, "Level01 -> Level02");
	settings.Add("23", true, "Level02 -> Level03");
	settings.Add("34", true, "Level03 -> Level04");
	settings.Add("45", true, "Level04 -> Level05");
	settings.Add("56", true, "Level05 -> Level06");
	settings.Add("67", false, "Level06 -> Outro");
	
}

start {
	//start the timer after the first load screen in the first level
	return (current.gameLoading == 0 && current.mapName == "Intro");
}
	
split {
	//split according to settings
	if (current.mapName == "level01" && old.mapName == "Intro" && settings["01"] == true) {
		return true;
	}
	
	if (current.mapName == "Level02" && old.mapName == "level01" && settings["12"] == true) {
		return true;
	}
	
	if (current.mapName == "Level03" && old.mapName == "Level02" && settings["23"] == true) {
		return true;
	}
	
	if (current.mapName == "Level04" && old.mapName == "Level03" && settings["34"] == true) {
		return true;
	}
	
	if (current.mapName == "Level05" && old.mapName == "Level04" && settings["45"] == true) {
		return true;
	}
	
	if (current.mapName == "Level06" && old.mapName == "Level05" && settings["56"] == true) {
		return true;
	}
	
	if (current.mapName == "Outro" && old.mapName == "Level06" && settings["67"] == true) {
		return true;
	}
	
	//final split
	if (current.mapName == "menu.le" && old.mapName == "Outro" || current.mapName == "menu.le" && current.gameLoading != 0 && old.gameLoading == 0) {
		return true;
	}
}

isLoading {
	return (current.gameLoading != 0 || current.mapName == "menu.le");
}

reset {
	return (current.mapName == "menu.le" && old.mapName != "Outro");
}
