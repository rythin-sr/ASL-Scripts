state("kao") {
	int level:			0xDB1F0;
	int load:			0xD3D24;
	byte hunterAnim:		0x1149D0;
}

state("kao2") {
	int level: 			0x22B7D4;
   	int menu: 			0x23D9AC;
    	int load:			0x22451C;
	int cs: 			0x21E6EC;
	float Xpos:			0x22C648;
	float Ypos:			0x22C64C;
	float Zpos:			0x22C650;
}

state("kao_tw") {
	int l:				0x36BD80;
	int m:				0x35EFE0;
	int load:			0x352430;
	int s:				0x36BF24;
	int a:				0x36BF28;
	int d:				0x36C16C;
	int cs:				0x36B0E8;
	float b:			0x003603C0, 0x48, 0x04, 0x48, 0x0110, 0x48, 0x00, 0x48, 0x00, 0x48, 0x00, 0x04D8, 0x48, 0x10;
}

startup {
	
	//define setting groups & general variables
	settings.Add("k1", true, "Kao the Kangaroo");
	settings.Add("k2", true, "Kao the Kangaroo: Round 2");
	settings.Add("k3", true, "Kao the Kangaroo: Mystery of the Volcano");
	
	vars.done_levels = new List<string>();
	
	//kao1 settings & variables
	var k1_levs = new Dictionary<int, string> {
		{1, "Lava 1"},
		{2, "Lava 2"},
		{3, "Lava 3 (Glider)"},
		{4, "Lava 4"},
		{5, "Ice 1"},
		{6, "Ice 2"},
		{7, "Bear Boss"},
		{8, "Ice 3"},
		{9, "Ice 4"},
		{10, "Ice 5 (Snowboard)"},
		{11, "Ice 6"},
		{12, "Greece 1"},
		{13, "Captain Boss"},
		{14, "Greece 2"},
		{15, "Greece 3 (Motorboat)"},
		{16, "Greece 4"},
		{17, "Greece 5"},
		{18, "Greece 6"},
		{19, "Zeus"},
		{20, "Space 1"},
		{21, "Space 2"},
		{22, "Space 3"},
		{23, "Space 4"},
		{24, "Alien"},
		{25, "Tropics 1"},
		{26, "Tropics 2"},
		{27, "Tropics 3"},
		{28, "Tropics 4"},
		{29, "Tropics 5"},
		{30, "Hunter"}
	};
	
	foreach (var Tag in k1_levs) {
		settings.Add("kao-" + Tag.Key.ToString(), true, Tag.Value, "k1");
    };
	
	vars.k1_last_lev = 0;
	
	//kao2 settings
	settings.Add("k2_lc", true, "Level Completion", "k2");
	settings.Add("k2_le", true, "Level Entry", "k2");
	
	var k2_levs = new Dictionary<int, string> {
		{0, "The Ship"},
		{2, "Beavers' Forest"},
		{3, "The Great Escape"},
		{4, "Great Trees"},
		{5, "River Raid"},
		{6, "Shaman's Cave"},
		{7, "Igloo Village"},
		{8, "Ice Cave"},
		{9, "Down the Mountain"},
		{10, "Crystal Mines"},
		{11, "The Station"},
		{12, "The Race"},
		{13, "Hostile Reef"},
		{14, "Deep Ocean"},
		{15, "Liar of Poison"},
		{16, "Trip to Island"},
		{17, "Treasure Island"},
		{18, "The Volcano"},
		{19, "Pirate's Bay"},
		{20, "Abandoned Town"},
		{21, "Hunter's Galleon"}
	};
	
	var k2_lev_ent = new Dictionary<string, string> {
		{"2e", "Beavers' Forest"},
		{"7e", "Igloo Village"},
		{"12e", "The Race"},
		{"16e", "Trip to Island"},
		{"20e", "Abandoned Town"}
	};
	
	foreach (var Tag in k2_levs) {
		settings.Add("kao2-" + Tag.Key.ToString(), true, Tag.Value, "k2_lc");
    };
	
	foreach (var Tag in k2_lev_ent) {
		settings.Add("kao2-" + Tag.Key, true, Tag.Value, "k2_le");
    };
	
	//kao3 settings
	settings.Add("k3_lc", true, "Level Completion", "k3");
	settings.Add("k3_le", true, "Level Entry", "k3");
	settings.Add("k3_mc", true, "Misc", "k3");
	
	var k3_levs = new Dictionary<string, string>{
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
	
	foreach (var Tag in k3_levs) {
		settings.Add("kao_tw-" + Tag.Key, true, Tag.Value, "k3_lc");
	}

	var k3_lev_ent = new Dictionary<string, string> {
		{"2e", "Gardens of Life"},
		{"3e", "Virtual Race"},
		{"4e", "Wuthering Heights"},
		{"5e", "Steersman Test"},
		{"6e", "Waterfall Island"},
		{"7e", "Battle in the Sky"},
		{"8e", "The Well"},
		{"9e", "The Volcano"}
	};
	
	foreach (var Tag in k3_lev_ent) {
		settings.Add("kao_tw-" + Tag.Key, false, Tag.Value, "k3_le");
	}
	
	var k3_ar = new Dictionary<string, string> {
		{"2a", "Artifact of Earth"},
		{"4a", "Artifact of Wind"},
		{"6a", "Artifact of Water"},
		{"8a", "Artifact of Fire"}
	};
	
	foreach (var Tag in k3_ar) {
		settings.Add("kao_tw-" + Tag.Key, false, Tag.Value, "k3_mc");
	}
	
	settings.Add("td", false, "Picking up the dynamite bundle in the tutorial", "k3_mc");
	settings.Add("ho", false, "Collecting 1000 Spirits", "k3_mc");
}

start {
	if (game.ProcessName == "kao") {
		if ((old.level == 100 || old.level == 101) && current.level == 1) {
			vars.done_levels.Clear();
			vars.k1_last_lev = 1;
			return true;
		}
	}
	
	if (game.ProcessName == "kao2") {
		if (current.level == 0 && old.menu == 1 && current.menu == 0 && current.cs == 1) {
			vars.done_levels.Clear();
			return true;
		}
		
	}
	
	if (game.ProcessName == "kao_tw") {
		if (current.m == 0 && old.m == 1 && current.l == 0 && current.cs == 1) {
			vars.done_levels.Clear();
			return true;
		}
	}
}

split {
	
	//split off the "game switch" split when the start condition for one of the games is met
	if (timer.Run[timer.CurrentSplitIndex].Name.ToLower().Replace(" ", "").Contains("gameswitch")) {
		if (game.ProcessName == "kao") {
			if ((old.level == 100 || old.level == 101) && current.level == 1) {
				vars.k1_last_lev = 1;
				return true;
			}
		}
	
		if (game.ProcessName == "kao2") {
			if (current.level == 0 && current.cs == 1 && old.cs == 0) {
				return true;
			}
		}
	
		if (game.ProcessName == "kao_tw") {
			if (current.m == 0 && old.m == 1 && current.l == 0 && current.cs == 1) {
				return true;
			}
		}
	}
	
	//kao1 splits
	if (game.ProcessName == "kao") {
		if (current.level != old.level) {
			if (current.level == 101) {
				vars.k1_last_lev = old.level;
			}
			
			if (current.level == vars.k1_last_lev + 1 && !vars.done_levels.Contains("kao-" + vars.k1_last_lev.ToString())) {
				vars.done_levels.Add("kao-" + vars.k1_last_lev.ToString());
				return settings["kao-" + vars.k1_last_lev.ToString()];
			}
		}
		
		if (old.level == 30 && current.hunterAnim == 5 && old.hunterAnim != 5) {
			return settings["kao-30"];
		}
	}
	
	//kao2 splits
	if (game.ProcessName == "kao2") {
		if (current.level != old.level && current.level != 0) {
			//level completion splits
			if (settings["kao2-" + old.level.ToString()] && !vars.done_levels.Contains("kao2-" + old.level.ToString())) {
				vars.done_levels.Add("kao2-" + old.level.ToString());
				return true;
			}
			//level entry splits
			if (settings["kao2-" + current.level.ToString() + "e"] && !vars.done_levels.Contains("kao2-" + current.level.ToString() + "e")) {
				vars.done_levels.Add("kao2-" + current.level.ToString() + "e");
				return true;
			}	
		}
	
		//final split
		if (current.level == 22 && current.cs == 1 && old.cs == 0 && current.Ypos > 9000) {
			return true;
		}
	}
	
	//kao3 splits
	if (game.ProcessName == "kao_tw") {
		//levels (walking into village from x)
		if (current.l != old.l && current.l == 1 && settings["kao_tw-" + old.l.ToString()] && !vars.done_levels.Contains("kao_tw-" + old.l.ToString())) {
			vars.done_levels.Add("kao_tw-" + old.l.ToString());
			return true;
		}
	
		//level entry splits
		if (old.l == 1 && current.l > 1 && settings["kao_tw-" + current.l.ToString() + "e"] && !vars.done_levels.Contains("kao_tw-" + current.l.ToString() + "e")) {
			vars.done_levels.Add("kao_tw-" + current.l.ToString() + "e");
			return true;
		}
	
		//tutorial dynamite pickup
		if (current.l == 1 && current.d > old.d && settings["td"] && !vars.done_levels.Contains("td")) {
			vars.done_levels.Add("td");		
			return true;
		}
	
		//artifact pickup
		if (current.a == old.a + 1 && settings["kao_tw-" + current.l.ToString() + "a"] && !vars.done_levels.Contains("kao_tw-" + current.a.ToString() + "a")) {
			vars.done_levels.Add("kao_tw-" + current.a.ToString() + "a");
			return true;
		}
	
		//hundo 
		if (current.s == 1000 && old.s == 999 && settings["ho"] && !vars.done_levels.Contains("ho")) {
			vars.done_levels.Add("ho");
			return true;
		}
	
		//final split
		if (current.l == 9 && current.b == 1 && old.b == 0 && settings["kao_tw-v"] && !vars.done_levels.Contains("kao_tw-v")) {
			vars.done_levels.Add("kao_tw-v");
			return true;
		}
	}
	
}


isLoading {
	return current.load == 1 || timer.Run[timer.CurrentSplitIndex].Name.ToLower().Replace(" ", "").Contains("gameswitch");
}
