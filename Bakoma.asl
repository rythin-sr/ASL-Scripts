//Bakoma 3D Games Autosplitter + Load Remover by rythin
//with contributions from hoxi (twitch.tv/hoxi___)

state("bakoma") {
	int             gameLoading:        0x9C2DC;    //0 during gameplay
	string10        mapName:            0x9B428;
	//map names for future reference:
	//menu.lev
	//Las.lev
	//Moczary.lev
	//Piramida.lev
	//Plaza.lev
	//Pustynia.lev
	//skaly.lev
	//wyspa.lev
    
}

startup 
{
	vars.maps = new Dictionary<string,string> {
		{"Las", "Las"},
		{"Moczary", "Moczary"},
		{"Piramida", "Piramida"},
		{"Plaza", "Plaza"},
		{"Pustynia", "Pustynia"},
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
	vars.firstMap = "h";	//variable for determining the reset point
	vars.splitCount = 0;	//variable used for final split
	vars.kurwa = 0;			//variable used to determine whether the runner is doing the category with or without wyspa.lev
} 

update {
	if (current.mapName == "menu" && old.mapName == "wyspa") {
		vars.kurwa = 1;
	}
}

start {
	if (vars.mapList.Contains(current.mapName) && current.gameLoading == 0 && old.gameLoading != 0) { 
		vars.doneMaps.Clear();
		vars.doneMaps.Add(current.mapName);
		vars.firstMap = current.mapName;
		vars.splitCount = 0;
		vars.kurwa = 0;
		return true;
	}
}

split {
	if (current.mapName != old.mapName) {
		if (current.mapName != "menu" && !vars.doneMaps.Contains(current.mapName)) {
			vars.doneMaps.Add(current.mapName);
			vars.splitCount = vars.splitCount + 1;
			return true;
       		}
   	}
	
	//final split based on category
	//will still have issues if you decide to do wyspa.lev last
	//but honestly why would you do that
	if (current.mapName == "menu" && old.mapName != "menu") {
		if (vars.kurwa == 0 && vars.splitCount == 5) {
			return true;
		}
		if (vars.kurwa == 1 && vars.splitCount == 6) {
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
