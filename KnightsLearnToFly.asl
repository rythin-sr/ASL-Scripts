state("kk") {
	//polish version off legendsworld i think? idk i got this ages ago
	int loading:		0x38B370; 	//1 when loading, 0 otherwise
	int cutscene:		0x5B3094;	//0 -> !0 on final cutscene, idc about anything else
	string6 map:		0x280533;
}

startup {
	vars.h = new Dictionary<string,string> { 				
		{"level1", "Level 1"}, 					
		{"level2", "Level 2"},
		{"level3", "Level 3"},
		{"las1.w", "Level 4"},
		{"las-da", "Level 5"},
		{"level6", "Level 6"},
		{"las-po", "Level 7"},
		{"las-wy", "Level 8"}
		//level9
	};
	
	vars.mapList = new List<string>();	
	vars.doneMaps = new List<string>();		//in case the runner reloads the wrong map
	
	foreach (var Tag in vars.h) {							
		settings.Add(Tag.Key, true, Tag.Value);					
		vars.mapList.Add(Tag.Key);
	};								
}

start {
	if (current.map == "level1" && current.loading == 0 && old.loading == 1) {
		vars.doneMaps.Clear();
		vars.doneMaps.Add(current.map);
		vars.doneMaps.Add(old.map);		//most likely unnecessary but better safe than sorry
		return true;
	}
}

split {

	//between level splits based on settings
	if (current.map != old.map && !vars.doneMaps.Contains(current.map)) {
		if (settings[old.map]) {
			vars.doneMaps.Add(current.map);
			return true;
		}
	}
	
	//final split
	if (current.map == "level9" && old.cutscene == 0 && current.cutscene != 0) {
		return true;
	}
}

reset {
	return (current.map == "level1" && old.map != "level1");
}
	
isLoading {
	return (current.loading == 1);
}
