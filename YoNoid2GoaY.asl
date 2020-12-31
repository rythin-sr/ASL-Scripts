// Autosplitter/Game Time for Yo! Noid 2: Game of a Year Edition
// Made by rythin (contact @rythin_sr on twitter/twitch and rythin#0135 on discord)
// With help from SpectralPlatypus (t.tv/SpectralPlatypus)

state("noid") {
	string12 level: "mono.dll", 0x298AE8, 0x20, 0x478, 0x8, 0x38, 0x44;
	byte mikehp:	"UnityPlayer.dll", 0x1469C58, 0x8, 0x60, 0xAD8, 0x118, 0xAA;
	byte dialogue:	"mono.dll", 0x264A68, 0x28, 0xEB0, 0x10, 0x180, 0x128, 0x28, 0x10C;
}

startup {
	settings.Add("lc", true, "Level Completion");
	settings.Add("le", false, "Level Entry");
	
	settings.Add("levelintro", true, "New York", "lc");
	
	var m = new Dictionary<string, string> {
		{"levi", "Swing Factory"},
		{"dungeon", "Domino Dungeon"},
		{"pznt", "Plizzanet"},
		{"mike", "???"}
	};
	
	foreach (var h in m) {
		settings.Add(h.Key, true, h.Value, "lc");
		settings.Add(h.Key + "e", false, h.Value, "le");
	}
	
	settings.Add("mikestart", false, "Split upon starting the Mike fight");
	settings.Add("npc", false, "Split upon starting dialogue with an NPC");
	settings.SetToolTip("npc", "Might split an extra time when going through level transitions?\n Not tested very thoroughly.");
	
	timer.Run.Offset = TimeSpan.FromSeconds(1.05);
}

start {
	return current.level.ToLower().Contains("intro");
}

split {
	//im sure theres a much better way to do this but working around with how janky the level address behaves is annoying so im just leaving this mess here 
	if (current.level != old.level) {
		//level copmpletion
		if (current.level.ToLower().Contains("void")) {
			if (old.level.ToLower().Contains("levelintro")) {
				return settings["levelintro"];
			}
			
			else if (old.level.ToLower().Contains("levi")) {
				return settings["levi"];
			}
			
			else if (old.level.ToLower().Contains("dungeon")) {
				return settings["dungeon"];
			}
			
			else if (old.level.ToLower().Contains("pznt")) {
				return settings["pznt"];
			}
		}
		
		//level entry
		if (old.level.ToLower().Contains("void")) {
			if (current.level.ToLower().Contains("levi")) {
				return settings["levie"];
			}
			
			else if (current.level.ToLower().Contains("dungeon")) {
				return settings["dungeone"];
			}
			
			else if (current.level.ToLower().Contains("pznt")) {
				return settings["pznte"];
			}
			
			else if (current.level.ToLower().Contains("mike")) {
				return settings["mike"];
			}
		}
	}
	
	//other splits
	if (current.level.ToLower().Contains("mike")) {
		if (current.mikehp == 5 && current.dialogue == old.dialogue - 1) {
			return settings["mikestart"];
		}
		
		if (current.mikehp == 0 && current.dialogue == old.dialogue - 1) {
			return settings["mike"];
		}
	}
	
	if (!current.level.ToLower().Contains("mike")) {
		return current.dialogue == old.dialogue + 1 && settings["npc"];
	}
}

reset {
	return current.level.ToLower().Contains("title");
}
