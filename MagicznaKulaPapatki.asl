state("gratka3d") {
	string7 mapName: 0xB2968; 
	int gameLoading: 0xB3818; //0 when gameplay is happening, some high number when loading. Seems more accurate than other pointers?
}

startup {
	vars.maps = new Dictionary<string, string> {
		{"level01", "Intro -> Level01"},
		{"Level02", "Level01 -> Level02"},
		{"Level03", "Level02 -> Level03"},
		{"Level04", "Level03 -> Level04"},
		{"level05", "Level04 -> Level05"},
		{"Level06", "Level05 -> Level06"},
		{"Outro", "Level06 -> Outro"},
	};
	
	vars.allMaps = new List<string>();
	
	foreach (var Tag in vars.maps) {
		settings.Add(Tag.Key, true, Tag.Value);
		vars.allMaps.Add(Tag.Key); 
	};
}

start {
	//start the timer after the first load screen in the first level
	return (current.gameLoading == 0 && current.mapName == "Intro");
}
	
split {
	if (current.mapName != old.mapName) {
		if (vars.allMaps.Contains(current.mapName) && settings[current.mapName]) {
			return true;
		}
	}
	
	if (old.mapName == "Outro" && current.mapName == "menu.le") {
		return true;
	}

}

isLoading {
	return (current.gameLoading != 0 || current.mapName == "menu.le");
}

reset {
	return (current.mapName == "menu.le" && old.mapName != "Outro");
}
