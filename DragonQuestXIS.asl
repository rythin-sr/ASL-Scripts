state("DRAGON QUEST XI S") {
	bool load:       0x5C797A0;                                             //1 when loading and mode == 4
	bool fade:       0x5EFB2CA;                                             //1 when fading and mode == 5, gets stuck on 1 when switching to 3D
	bool cs:         0x5F55CE4;                                             //1 during skippable cutscenes
	byte mode:       0x58057F0;                                             //4 in 3D, 5 in 2D
	byte start:      0x5C4B713; 	                                        //some variable that consistently goes to 0 from non-0 on run start
	byte menu_index: 0x5C08210, 0xE8, 0xD0, 0x3A0, 0x300, 0x3E8;            //the number of the option selected in the main menu, flickers randomly during gameplay
	byte max_index:  0x5C08210, 0xE8, 0xD0, 0x3A0, 0x300, 0x3E4;            //total number of options to choose from in the menu (i think)
	bool dialogue:   0x5D840B8, 0xA50, 0x4B0, 0x30, 0x20, 0x3E0;            //1 when in dialogue, can flicker from 1 to 0 occasionally but seems to never flicker from 0 to 1
	string100 tb2d:  0x5EF1614;                                             //text in the bottom textbox (dialogue, combat) when mode == 5
	float x:         0x5E51B30, 0x40, 0x3A0, 0x3F8, 0x138, 0x1D0;           //horizontal pos
	float y:         0x5E51B30, 0x40, 0x3A0, 0x3F8, 0x138, 0x1D4;           //horizontal pos
	float z:         0x5E51B30, 0x40, 0x3A0, 0x3F8, 0x138, 0x1D8;           //vertical pos
	float x_fr:      0x5E70C98, 0x818, 0x8, 0x120, 0xF8, 0x1D0;             //horizontal pos, only updates in freeroam
	int gold:        0x5C08210, 0x128, 0xC0;
}

startup {	
	
	vars.splits = new Dictionary<string, Tuple<int, float, float, float, float, float>> {
		//split name, split type, x-min, x-max, y-min, y-max, z-avg
		//split types: 0 - nothing, just for setting creation; 1 - wait for cutscene ; 
		//2 - any% end split ; 3 - on cutscene ; 4 - arrive at area
		//>4 - gold gain split, the number representing the amount of gold gained
		{"Smogs", Tuple.Create(1, -851f, 451f, 29200f, 30511f, 4220f)}, 
		{"Tricky Devil", Tuple.Create(1, 18016f, 19114f, -37136f, -36044f, 3140f)},
		{"Gryphons", Tuple.Create(1, -106989f, -105494f, -3101f, -1598f, -4905f)},
		{"Jarvis", Tuple.Create(1, -4651f, -1749f, -36651f, -33749f, 2780f)}, //check area
		{"Slayer of Sands", Tuple.Create(1, 28749f, 31652f, -36125f, -33231f, -100f)},
		{"Corallosuses", Tuple.Create(2, 18886f, 20577f, -25209f, -23519f, -960f)},
		{"Jasper 1", Tuple.Create(1, -608f, 589f, -6588f, -5385f, 690f)},
		{"Arena 1", Tuple.Create(120, 27094f, 29348f, -1132f, 1121f, 3394f)}, 
		{"Arena 2-1", Tuple.Create(150, 27094f, 29348f, -1132f, 1121f, 3394f)},
		{"Arena 2-2", Tuple.Create(180, 27094f, 29348f, -1132f, 1121f, 3394f)},
		{"Arena 2-3", Tuple.Create(4, -21f, -19f, -2222f, -2220f, 1200f)}, 
		{"Arachtagon", Tuple.Create(2700, 2459f, 4861f, -18491f, -16093f, 60f)},
		{"2D Grind", Tuple.Create(4, -1406f, -1404f, 3887f, 3889f, 1130f)}, 
		{"Tentacular", Tuple.Create(4, 4622f, 4623f, 6149f, 6150f, 1416f)},
		{"Act 2 Start", Tuple.Create(4, -5f, -4f, 13570f, 13572f, 208f)},
		{"Scenarios", Tuple.Create(4, 24224f, 24225f, 14524f, 14525f, 7532f)},
		{"Tyriant", Tuple.Create(1, -893f, 893f, -7751f, -5949f, 1795f)},
		{"Rab", Tuple.Create(1, 29051f, 30950f, -3951f, -2052f, -59843f)},
		{"Avarith", Tuple.Create(1, -8603f, -6707f, 29930f, 31825f, 3107f)},
		{"Gyldygga", Tuple.Create(1, -12673f, -10279f, -4750f, -2337f, 274f)},
		{"Tatsunanga 2", Tuple.Create(1, 15257f, 17841f, -10507f, -7904f, 10662f)},
		{"Indignus", Tuple.Create(1, -1596f, 1311f, 14141f, 17043f, 3099f)},
		{"Jasper Unbound", Tuple.Create(1, 379468f, 381216f, 18886f, 22781f, 4250f)},
		{"Mordegon and Tail", Tuple.Create(2, 840066f, 841966f, 18353f, 20254f, 16869f)},
		{"World Tree Jasper", Tuple.Create(1, -1957f, -247f, -409f, 1292f, 36720f)},
		{"Mordegon 2", Tuple.Create(1, -893f, 893f, -7751f, -5949f, 1795f)}, 
		{"Perfectly Pepped Paladins Quest (2D only)", Tuple.Create(0, 0f, 0f, 0f, 0f, 0f)},
		{"Calasmos", Tuple.Create(0, 0f, 0f, 0f, 0f, 0f)}
	};
	
	foreach (var h in vars.splits) {
		settings.Add(h.Key);
	}
	
	Func<float, float, float, Tuple<int, float, float, float, float, float>, bool> CheckPos = (x, y, z, range) => {
		if (x > range.Item2 && x < range.Item3 &&
		y > range.Item4 && y < range.Item5 &&
		z > range.Item6 - 100 && z < range.Item6 + 100) {
			return true;
		} else {
			return false;
		}
	};
	
	vars.CheckPos = CheckPos;
	vars.doneSplits = new List<string>();
	vars.waitForCS = false;
	vars.waitForPos = false;
	vars.isCombat = false;
	vars.delay = new Stopwatch();
	
	vars.queuedSplit = "";
}

update {
	if (!current.load && !current.cs) {
		if (current.x == current.x_fr && current.x_fr != 0) {
			vars.isCombat = false;
		} else {
			vars.isCombat = true;
		}
	}
}

start {
	if (current.max_index == 2 && current.menu_index == 0 || current.max_index >= 4 && current.menu_index == 1) {
		if (current.dialogue && !old.dialogue) {
			vars.doneSplits.Clear();
			vars.queuedSplit = "null";
			vars.waitForCS = false;
			return true;
		}
	}
}

split {
	//regular fight splits
	if (current.dialogue && !old.dialogue && vars.isCombat) {
		foreach (var h in vars.splits) {
			if (!vars.doneSplits.Contains(h.Key) && (h.Value.Item1 == 1 || h.Value.Item1 == 2) && vars.CheckPos(current.x, current.y, current.z, h.Value)) {
				if (h.Value.Item1 == 1) {
					vars.queuedSplit = h.Key;
					if (settings[h.Key]) vars.waitForCS = true;
				} else {
					vars.doneSplits.Add(h.Key);
					vars.queuedSplit = h.Key;
					vars.delay.Restart();
				}
			}
		}
	}
	
	//any% delayed split
	if (vars.delay.ElapsedMilliseconds >= 1550) {
		vars.delay.Reset();
		return settings[vars.queuedSplit];
	}
	
	//cutscene split logic
	if (current.cs && !old.cs) {
		if (vars.waitForCS) {
			vars.doneSplits.Add(vars.queuedSplit);
			vars.waitForCS = false;
			return true;
		} else {
			foreach (var h in vars.splits) {
				if (h.Value.Item1 == 3 && !vars.doneSplits.Contains(h.Key) && vars.CheckPos(current.x, current.y, current.z, h.Value)) {
					vars.queuedSplit = h.Key;
					vars.doneSplits.Add(h.Key);
					return settings[h.Key];
				}
			}
		}
	}
	
	//gold splits
	int diff = 0;
	if (current.gold > old.gold) {
		diff = current.gold - old.gold;
		foreach (var h in vars.splits) {
			if (h.Value.Item1 > 4 && vars.CheckPos(current.x, current.y, current.z, h.Value) && diff == h.Value.Item1) {
				vars.queuedSplit = h.Key;
				vars.doneSplits.Add(h.Key);
				return settings[h.Key];
			}
		}
	}
	
	//2d text splits
	if (current.tb2d.Contains("You've completed the") && current.tb2d.Contains("Perfectly Pepped Paladins") && !vars.doneSplits.Contains("Perfectly Pepped Paladins Quest (2D only)")) {
		vars.doneSplits.Add("Perfectly Pepped Paladins Quest (2D only)");
		vars.queuedSplit = "2D Quest"; 
		return settings["Perfectly Pepped Paladins Quest (2D only)"];
	}

	if (current.tb2d == "Calasmos is defeated." && !vars.doneSplits.Contains("Calasmos")) {
		vars.doneSplits.Add("Calasmos");
		vars.queuedSplit = "Calasmos";
		return settings["Calasmos"];
	}
	
	/*if (current.load && !old.load) {
		if (vars.CheckPos(old.x, old.y, old.z, vars.splits["World Tree Jasper"]) && !vars.doneSplits.Contains("Act 2 Start")) {
			print("Waiting for Act 2 Split!");
			vars.waitForPos = true;
		}
	}*/
	
	//since im only checking for position after a load
	//waitForPos might be unnecessary, leaving it here until a runner tests this
	if (/*vars.waitForPos && */!current.load && old.load) {
		foreach (var h in vars.splits) {
			if (!vars.doneSplits.Contains(h.Key) && h.Value.Item1 == 4 && vars.CheckPos(current.x, current.y, current.z, h.Value)) {
				vars.doneSplits.Add(h.Key);
				vars.waitForPos = false;
				vars.queuedSplit = h.Key;
				return settings[h.Key];
			}
		}
	}
	
	/*if (current.mode == old.mode - 1 && !vars.doneSplits.Contains("2D Grind")){
		print("Switched to 3D Mode!");
		vars.waitForPos = true;
	} */
	//setting waitForCS to false when not in combat in case it gets incorrectly set to true 
	//from a random fight
	if (!vars.isCombat && vars.waitForCS) {
		print("Leaving combat, setting waitForCS to false");
		vars.waitForCS = false;
	}
}

isLoading {
	return current.load || (current.fade && current.mode == 5);
}
