//Kao the Kangaroo 3 Autosplitter + Load Remover by rythin
//base script and most important addresses by Flower35

state("kao_tw", "Polish Cracked")
{
	int l: 		0x36BE80;	//level ID
	int m: 		0x35F0B8;	//1 when menu is up
	int load: 	0x352500;	//1 when loading
	int s:		0x36C024;	//global spirit counter
	int a:		0x36C028;	//artifact counter
	int d:		0x36C26C;	//dynamine counter
	int cs:		0x36B1E8;	//1 when text on screen or cutscene
	//1 when boss is dead, might be weird on other levels, untested
	float b:	0x360498, 0x48, 0x04, 0x48, 0x0110, 0x48, 0x00, 0x48, 0x00, 0x48, 0x00, 0x04D8, 0x48, 0x10;
}

state("kao_tw", "Hungarian") {
	int l:		0x36BD80;
	int m:		0x35EFE0;
	int load:	0x352430;
	int s:		0x36BF24;
	int a:		0x36BF28;
	int d:		0x36C16C;
	int cs:		0x36B0E8;
	float b:	0x003603C0, 0x48, 0x04, 0x48, 0x0110, 0x48, 0x00, 0x48, 0x00, 0x48, 0x00, 0x04D8, 0x48, 0x10; 
}

//0 - Flight
//1 - Pelican Village
//2 - Gardens of Life
//3 - Virtual Race
//4 - Wuthering Height
//5 - Steersman Test
//6 - Waterfall Island
//7 - Battle in the Sky
//8 - The Well
//9 - The Volcano

startup {

	settings.Add("IL", false, "Start/Split according to IL rules");
	settings.Add("ml", true, "Main Levels");
	settings.Add("en", true, "Area Entry");
	settings.Add("mc", true, "Misc");
	
	settings.Add("td", false, "Picking up the dynamite bundle in the tutorial", "mc");
	settings.Add("ho", false, "Collecting 1000 Spirits", "mc");
	
	vars.ds = new List<string>();
	
	vars.ml = new Dictionary<string, string>{
		{"0", "Flight"},
		{"2", "Gardens of Life"},
		{"3", "Virtual Race"},
		{"4", "Wuthering Height"},
		{"5", "Steersman Test"},
		{"6", "Waterfall Island"},
		{"7", "Battle in the Sky"},
		{"8", "The Well"},
		{"v", "The Volcano"}
	};
	
	foreach (var Tag in vars.ml) {
		settings.Add(Tag.Key, true, Tag.Value, "ml");
	}

	vars.le = new Dictionary<string, string> {
		{"2e", "Gardens of Life"},
		{"3e", "Virtual Race"},
		{"4e", "Wuthering Heights"},
		{"5e", "Steersman Test"},
		{"6e", "Waterfall Island"},
		{"7e", "Battle in the Sky"},
		{"8e", "The Well"},
		{"9e", "The Volcano"}
	};
	
	foreach (var Tag in vars.le) {
		settings.Add(Tag.Key, false, Tag.Value, "en");
	}
	
	vars.al = new Dictionary<string, string> {
		{"2a", "Artifact of Earth"},
		{"4a", "Artifact of Wind"},
		{"6a", "Artifact of Water"},
		{"8a", "Artifact of Fire"}
	};
	
	foreach (var Tag in vars.al) {
		settings.Add(Tag.Key, false, Tag.Value, "mc");
	}
}

init {
	//print(modules.First().ModuleMemorySize.ToString());
	
	int v = modules.First().ModuleMemorySize;
	
	switch (v) {
		case 3899392:
		version = "Hungarian";
		break;
		
		case 3903488:
		version = "Polish Cracked";
		break;

		default:
		version = "Unrecognised Version";
		break;
	}
}

start {
	if (current.m == 0 && old.m == 1 && current.l == 0 && current.cs == 1) {
		vars.ds.Clear();
		return true;
	}

	
	if (settings["IL"]) {
		if (current.l != 0 && current.l != 1 && current.load == 0 && old.load == 1) {
			return true;
		}
	}
}

split {
	//split based on settings
	//levels (walking into village from x)
	if (current.l != old.l && current.l == 1 && settings[old.l.ToString()] && !vars.ds.Contains(old.l.ToString())) {
		//print("KAO3SPLITTER: Splitting for: Level End " + old.l.ToString());
		vars.ds.Add(old.l.ToString());
		return true;
	}
	
	//level entry splits
	if (old.l == 1 && current.l > 1 && settings[current.l.ToString() + "e"] && !vars.ds.Contains(current.l.ToString() + "e")) {
		//print("KAO3SPLITTER: Splitting for: Level Entry " + old.l.ToString() + "e");
		vars.ds.Add(current.l.ToString() + "e");
		return true;
	}
	
	//IL splits
	if (settings["IL"]) {
		if (current.l != 1 && current.load == 1 && old.load == 0) {
			//print("KAO3SPLITTER: Splitting for: IL");
			return true;
		}
	}
	
	//tutorial dynamite pickup
	if (current.l == 1 && current.d > old.d && settings["td"] && !vars.ds.Contains("td")) {
		//print("KAO3SPLITTER: Splitting for: Tutorial Dynamite Pickup");
		vars.ds.Add("td");		
		return true;
	}
	
	//artifact pickup
	if (current.a == old.a + 1 && settings[current.l.ToString() + "a"] && !vars.ds.Contains(current.a.ToString() + "a")) {
		//print("KAO3SPLITTER: Splitting for: Artifact Pickup, level: " + current.l.ToString());
		vars.ds.Add(current.a.ToString() + "a");
		return true;
	}
	
	//hundo 
	if (current.s == 1000 && old.s == 999 && settings["ho"] && !vars.ds.Contains("ho")) {
		//print("KAO3SPLITTER: Splitting for: 1000 Spirits");
		vars.ds.Add("ho");
		return true;
	}
	
	//final split
	if (current.l == 9 && current.b == 1 && old.b == 0 && settings["v"] && !vars.ds.Contains("v")) {
		//print("KAO3SPLITTER: Splitting for: Final Split");
		vars.ds.Add("v");
		return true;
	} 
	
}

isLoading {
	return (current.load == 1);
}
