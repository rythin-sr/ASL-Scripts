//Kao the Kangaroo 3 Autosplitter + Load Remover by rythin
//base script and most important addresses by Flower35

state("kao_tw")
{
	int l: 		0x36BE80;	//level ID
	int m: 		0x35F0B8;	//1 when menu is up
	byte load: 	0x352500;	//1 when loading
	int s:		0x36C024;	//global spirit counter
	int a:		0x36C028;	//artifact counter
	int d:		0x36C26C;	//dynamine counter
	int cs:		0x36B1E8;	//1 when text on screen or cutscene
	//1 when boss is dead, might be weird on other levels, untested
	float b:	0x00360498, 0x48, 0x04, 0x48, 0x0110, 0x48, 0x00, 0x48, 0x00, 0x48, 0x00, 0x04D8, 0x48, 0x10;

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

	settings.Add("ml", true, "Main Levels");
	settings.Add("mg", true, "Minigames");
	settings.Add("mc", true, "Misc");
	settings.Add("td", false, "Picking up the dynamite bundle in the tutorial", "mc");
	settings.Add("ar", false, "Picking up an artifact", "mc");
	settings.Add("ve", false, "Volcano Entry", "mc");
	settings.Add("ho", false, "Reaching 100% completion", "mc");
	
	vars.ds = new List<string>();
	
	vars.ml = new Dictionary<string, string>{
		{"0", "Flight"},
		{"2", "Gardens of Life"},
		{"4", "Wuthering Height"},
		{"6", "Waterfall Island"},
		{"8", "The Well"}
	};
	
	foreach (var Tag in vars.ml) {
		settings.Add(Tag.Key, true, Tag.Value, "ml");
	}
	
	settings.Add("v", true, "The Volcano", "ml");
	
	vars.mg = new Dictionary<string, string>{
		{"3", "Virtual Race"},
		{"5", "Steersman Test"},
		{"7", "Battle in the Sky"},
	};
	
	foreach (var Tag in vars.mg) {
		settings.Add(Tag.Key, false, Tag.Value, "mg");
	}
}

update {

}

start {
	if (current.m == 0 && old.m == 1 && current.l == 0 && current.cs == 1) {
		vars.ds.Clear();
		return true;
	}
}

split {
	//split based on settings
	//levels (walking into village from x)
	if (current.l != old.l && current.l == 1 && settings[old.l.ToString()] && !vars.ds.Contains(old.l.ToString())) {
		vars.ds.Add(old.l.ToString());
		return true;
	}
	
	//volcano entry
	if (settings["ve"] && current.l == 9 && old.l != 9 && !vars.ds.Contains("ve")) {
		vars.ds.Add("ve");
		return true;
	}
	
	//tutorial dynamite pickup
	if (current.l == 1 && current.d == 10 && old.d == 0 && settings["td"] && !vars.ds.Contains("td")) {
		vars.ds.Add("td");
		return true;
	}
	
	//artifact pickup
	if (current.a == old.a + 1 && settings["ar"]) {
		return true;
	}
	
	//hundo 
	if (current.s == 1000 && old.s == 999 && settings["ho"] && !vars.ds.Contains("ho")) {
		vars.ds.Add("ho");
		return true;
	}
	
	//final split
	if (current.l == 9 && current.b == 1 && old.b == 0 && settings["v"] && !vars.ds.Contains("v")) {
		vars.ds.Add("v");
		return true;
	} 
	
}

isLoading {
	return (current.load == 1);
}
