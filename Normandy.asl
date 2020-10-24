state("CLIENT") {
	string5 map:	0xACC70, 0x20, 0x20, 0x1B0;	//goes to garbage in load screens and at the end of the run
	byte load:	"cshell.dll", 0xFAD18;		
}

startup {
	var d = new Dictionary<string, string> {
		{"map01", "Fields"},
		{"map02", "Bunkers"},
		{"map03", "Village"},
		{"map04", "Big Guns"},
		{"map05", "Hedgerows"},
		{"map06", "Tank Patrol"},
		{"map07", "Railroad Station"},
		{"map08", "TankHill"},
		{"map09", "Farmhouse"},
		{"map10", "StMereEglise"}
	};
	
	foreach (var Tag in d) {
		settings.Add(Tag.Key, true, Tag.Value);
	};
}

start {
	return (current.map == "map01" && current.load != 1 && old.load == 1);
}

split {
	if (current.map != old.map) {		//can sometimes split on death because the address is weird
		return settings[old.map];	//but i dont really care
	}
}

isLoading {
	return current.load == 1;
}
