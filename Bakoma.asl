//Bakoma 3D Games Autosplitter + Load Remover by rythin
//with contributions from hoxi (twitch.tv/hoxi___)

state("bakoma") {
	int             gameLoading:        0x9C2DC;    //0 during gameplay
	string10        mapName:            0x9B428;
	//map names for future reference:
	//menu.lev
	//las.lev
	//m2.lev
	//piramida.lev
	//p2.lev
	//Pustynia1.lev
	//skaly.lev
	//wyspa.lev
    
}

startup 
{
	vars.maps = new Dictionary<string,string> {
		{"las", "las"},
		{"m2", "m2"},
		{"piramida", "piramida"},
		{"p2", "p2"},
		{"Pustynia1", "Pustynia1"},
		{"skaly", "skaly"},
		{"wyspa", "wyspa"}
	};

	vars.mapList = new List<string>();

	foreach (var Tag in vars.maps) {
		vars.mapList.Add(Tag.Key);
	}    
}

init {
	vars.doneMaps = new List<string>();   
	vars.firstMap = "h";
} 

start {
	if (vars.mapList.Contains(current.mapName) && current.gameLoading == 0 && old.gameLoading != 0) { 
		vars.doneMaps.Clear();
		vars.doneMaps.Add(current.mapName);
		vars.firstMap = current.mapName;
		return true;
	}
}

split {
	if (current.mapName != old.mapName) {
		if (current.mapName != "menu" && !vars.doneMaps.Contains(current.mapName)) {
			vars.doneMaps.Add(current.mapName);
			return true;
        	}
    	}    
}

reset {
	return (vars.firstMap == current.mapName && old.mapName == "menu");
}



isLoading {
	return (current.gameLoading != 0);
}
