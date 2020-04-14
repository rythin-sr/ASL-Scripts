//Pingwin Zenek w Opałach Autosplitter + Load Remover by rythin

state("gratka3d") {
	int gameLoading:	0xCB548;
	string10 mapName:	0xCA6A8;

  //maps:
	//Snow_Intro
	//Snow1
	//Snow2
	//zamek
	//Snow4
	//skuter
	//skuter2
	//menu.lev
}

startup 
{
	vars.maps = new Dictionary<string,string> {
		{"Snow2", "Snow1"},
		{"zamek", "Snow2"},
		{"Snow4", "zamek"},
		{"skuter", "Snow4"},
		{"skuter2", "skuter"}
	};

	vars.mapList = new List<string>();

	foreach (var Tag in vars.maps) {
		settings.Add(Tag.Key, true, Tag.Value);
		vars.mapList.Add(Tag.Key);
	}    
}

start {
	return (current.mapName == "Snow_Intro" && current.gameLoading == 0 && old.gameLoading != 0);
}

split {
	//level splits
	if (current.mapName != old.mapName) {
		if (vars.mapList.Contains(current.mapName) && settings[current.mapName]) {
			return true;
		}
	}
	
	//final split 
	if (current.mapName == "menu.lev" && old.mapName == "skuter2") {
		return true;
	}
}

reset {
	return (current.mapName == "menu.lev" && old.mapName != "skuter2");
}

isLoading {
	return (current.gameLoading != 0);
}
