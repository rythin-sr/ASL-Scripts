state("BoneExe") {
	int r:		0x50F300;	//current room id
}

startup {

	settings.Add("l", true, "Levels");
	settings.Add("b", true, "Bosses");
	settings.Add("s", true, "Secrets");	
	
	vars.dl = new Dictionary<string, string> {
		{"3", "1-1"},
		{"4", "1-2"},
		{"5", "1-3"},
		{"8", "2-1"},
		{"9", "2-2"},
		{"12", "3-1"},
		{"13", "3-2"},
		{"16", "4-1"},
		{"17", "4-2"},
	};
	
	foreach (var Tag in vars.dl)
	{
		settings.Add(Tag.Key, false, Tag.Value, "l");
	}
	
	vars.db = new Dictionary<string, string> {
		{"6", "Leenkh"},
		{"10", "Full-Time Masochist"},
		{"14", "Mario.exe"},
		{"18", "Sunik.txt"}
	};
	
	foreach (var Tag in vars.db)
	{
		settings.Add(Tag.Key, true, Tag.Value, "b");
	}
	
	vars.ds = new Dictionary<string, string> {
		{"31", "Apparition.gba"},
		{"33", "Ghost Town Figure"},
	};
	
	foreach (var Tag in vars.ds)
	{
		settings.Add(Tag.Key, true, Tag.Value, "s");
	}
	
	settings.SetToolTip("18", "Disabling this will not prevent final split from occuring, rather allows for disabling this split when going to SkeleSatan");
	
}
	
start {
	if (current.r == 2 && old.r == 1) {
		vars.hundo = 0;
		return true;
	}
}

split {
	if (old.r != current.r && current.r != 0) {
		//splits according to settings
		if (settings[old.r.ToString()] && current.r != 19 && current.r != 22) {
			return true;
		}
		
		//final split
		if (current.r == 19 || current.r == 22 || current.r == 25) {
			return true;
		}
	}	
}

reset {
	if (current.r == 0 && old.r != 24 && current.r != old.r) {
		return true;
	}
}
