state("DarkSoulsII", "1.11")
{
	float xPos:	0x114A5B4, 0x8, 0x88, 0xC;		//horizontal
	float yPos:	0x114A5B4, 0x8, 0x88, 0x10;		//vertical
	float zPos:	0x114A5B4, 0x8, 0x88, 0x14;		//horizontal
	int state:	0x11493F4, 0x74, 0xB8, 0x2D4;		//1 in cutscenes and backstabs/ripostes (lol), 2 when falling, 0 otherwise
	int souls:	0x11493F4, 0x74, 0x2EC, 0x238;		
	int load: 	0x118E8E0, 0x1D4;			//1 in loads
}

state("DarkSoulsII", "1.02") {
	float xPos:	0xFB4F74, 0x8, 0xBC;				
	float yPos:	0xFB4F74, 0x8, 0xC0;				
	float zPos:	0xFB4F74, 0x8, 0xC4;				
	int state:	0xFB3E3C, 0x74, 0xB8, 0x2D4;		
	int souls:	0xFB3E3C, 0x74, 0x2EC, 0x238;		
	int load: 	0xFF9298, 0x1D4;
}

startup {
	
	var tB_a = (Func<float, float, float, float, float, float, Tuple<float, float, float, float, float, float>>) ((elmt1, elmt2, elmt3, elmt4, elmt5, elmt6) => { return Tuple.Create(elmt1, elmt2, elmt3, elmt4, elmt5, elmt6); });
	var tB_b = (Func<float, float, float, float, float, float, int, Tuple<float, float, float, float, float, float, int>>) ((elmt1, elmt2, elmt3, elmt4, elmt5, elmt6, elmt7) => { return Tuple.Create(elmt1, elmt2, elmt3, elmt4, elmt5, elmt6, elmt7); });
	
	//list with info on all the boss areas and soul rewards
	//x_max, x_min, y_max, y_min, z_max, z_min, souls
	vars.boss_area = new List<Tuple<float, float, float, float, float, float, int>>{
		tB_b(22, -6, -14, -15, 296, 270, 12000),	//0, dragonrider
		tB_b(0, 0, 0, 0, 0, 0, 0),					//a load of empty entries to prevent errors
		tB_b(0, 0, 0, 0, 0, 0, 0),					//i could actually solve this issue the smart way
		tB_b(0, 0, 0, 0, 0, 0, 0),					//however i am not smart and this works
		tB_b(0, 0, 0, 0, 0, 0, 0)					//as long as both boss_area and pos_area have the same amount of entries
	};
	
	vars.pos_area = new List<Tuple<float, float, float, float, float, float>>{
		tB_a(-217, -227.5f, 12, 10, -166, -170),	//0, bridge in things betwixt
		tB_a(8, 5, -6, -7, 280, 276),				//1, bonfire after dragonrider
		tB_a(-180, -190, 14, 13, -137, -147),		//2, after character creation
		tB_a(-25, -28, 20, 19, -90, -95),			//3, majula entrance
		tB_a(7, 3, -9.5f, -10.3f, 165, 153)			//4, heide's tower of flame entry
	};
	
	//array of possible routes for each category
	//routes consist of strings with info on each split in order
	//the strings are be structured as follows:
	// - a letter, either 'a' or 'b', indicating whether the split is for the boss or an area
	// - a number, indicating which entry in the appropriate list should be checked
	// - a letter, either 'l', 'i' or 'n', indicating whether the split should happen on the next load, instantly or not at all (useful if you're revisiting an area in the route and only want the split to happen on the second instance of visiting, for example)
	
	vars.route = new[,]{
	//	{},	//any
	//	{},	//17k
	//	{},	//4 rotten
	//	{},	//5 rotten
	//	{},	//crs
	//	{},	//ab
	//	{},	//ab no dlc
		{"a0i", "a2i", "a3i", "a4i", "b0i", "a1l", "b0i"}	//rbo (just testing stuff on this one for now)
	};
	
	//todo: add scholar categories/routes
	
	//array of supported categories
	vars.cat = new[,]{
		{"any", "Any%"},
		{"17k", "Any% (17000 Souls)"},
		{"4r", "Any% (4 Rotten)"},
		{"5r", "Any% (5 Rotten)"},
		{"crs", "Any% (Cat Ring Skip)"},
		{"ab", "All Bosses"},
		{"abnodlc", "All Bosses No DLC"},
		{"rbo", "Reverse Boss Order"}
	};
	
	for (int i = 0; i < vars.cat.GetLength(0); i++) {
		settings.Add(vars.cat[i, 0], false, vars.cat[i, 1]);
	}
	
	//additional variables used for keeping track of split order
	vars.doneSplits = 0;
	vars.category = 0;
	vars.wait_for_load = false;
}

init {
	var m = modules.First().ModuleMemorySize;
	
	if (m == 34299904 || m == 34361344) {
		version = "Scholar";
	} else if (m == 33902592 || m == 33927168) {
		version = "1.11";
	} else {
		version = "1.02";
	}
}

start {
	if (current.load == old.load - 1 &&
	current.xPos < -322.0f && current.zPos < -213.0f &&
	current.xPos > -323.0f && current.zPos > -214.0f) {
		
		vars.category = 0;
		while (!settings[vars.cat[vars.category, 0]]) {
			vars.category++;
		}
		vars.doneSplits = 0;
		vars.wait_for_load = false;
		return true;
	}
}

split {
	if (vars.category < 8) {
		//eventually I'd like to have the route 
		string split_data = vars.route[vars.category, vars.doneSplits];
		var split_a = vars.pos_area[Int32.Parse(split_data[1].ToString())];
		var split_b = vars.boss_area[Int32.Parse(split_data[1].ToString())];	
		
		if (split_data[0] == 'a') {
			if (current.xPos <= split_a.Item1 && current.xPos >= split_a.Item2 &&
			current.yPos <= split_a.Item3 && current.yPos >= split_a.Item4 &&
			current.zPos <= split_a.Item5 && current.zPos >= split_a.Item6) {
				if (split_data[2] == 'i') {
					vars.doneSplits++;
					print("Area splitting for route entry: " + split_data);
					return (old.xPos > split_a.Item1 || old.xPos < split_a.Item2 ||
					old.yPos > split_a.Item3 || old.yPos < split_a.Item4 ||
					old.zPos > split_a.Item5 || old.zPos < split_a.Item6);
				} else if (split_data[2] == 'l') {
					vars.wait_for_load = true;
				} else {
					vars.doneSplits++;
				}
			}
		}
		
		if (split_data[0] == 'b') {
			if (current.xPos < split_b.Item1 && current.xPos > split_b.Item2 &&
			current.yPos < split_b.Item3 && current.yPos > split_b.Item4 &&
			current.zPos < split_b.Item5 && current.zPos > split_b.Item6 &&
			current.souls >= old.souls + split_b.Item7 && current.souls <= old.souls + (split_b.Item7 * 1.69)) {
				if (split_data[2] == 'i') {
					vars.doneSplits++;
					print("Boss splitting for route entry: " + split_data);
					return true;
				} else if (split_data[2] == 'l') {
					vars.wait_for_load = true;
				} else {
					vars.doneSplits++;
				}
			}
		}
		
		if (current.load == old.load + 1 && vars.wait_for_load == true) {
			vars.wait_for_load = false;
			vars.doneSplits++;
			print("Load splitting for route entry: " + split_data);
			return true;
		}
	}
	
	//final split condition will go here eventually
	//if (current.xPos >  && current.xPos <  &&
	//current.zPos >  && current.zPos <  &&
	//current.state == old.state + 1) {
	//	return true;
	//}
}

reset {
	if (current.load == 1 && current.xPos != old.xPos &&
	current.xPos < -322.0f && current.zPos < -213.0f &&
	current.xPos > -323.0f && current.zPos > -214.0f) {
		return true;
	}
}

isLoading {
	return current.load == 1;
}
