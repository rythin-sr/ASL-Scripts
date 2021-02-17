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
		tB_b(113, 86, -39, -41, -112, -143, 10000),		//00, Last Giant
		tB_b(145, 130, 11, 9, -175, -220, 17000),		//01, Pursuer, normal kill
		tB_b(82, 78, 2, 1, -181, -185, 17000),			//02, Pursuer, 17k
		tB_b(22, -7, -14, -15, 290, 275, 12000),		//03, Dragonrider
		tB_b(-240, -285, -225, -228, -93, -128, 47000),		//04, Rotten NG
		tB_b(-240, -285, -225, -228, -93, -128, 94000),		//05, Rotten NG+
		tB_b(-144, -184, 9, 7, 185, 144, 20000),		//06, Dragonslayer
		tB_b(23, 1, -71, -72, 532, 518, 14000),			//07, Flexile
		tB_b(-393, -435, 40, 36, 267, 226, 15000),		//08, Skeleton Lords
		tB_b(-520, -550, 54, 52, 558, 530, 13000),		//09, Covetous Demon
		tB_b(-548, -576, 87, 85, 565, 534, 20000),		//10, Mytha 
		tB_b(-706, -731, 177, 176, 667, 645, 32000),		//11, Smelter Demon (Red)
		tB_b(-627, -653, 167, 166, 731, 710, 48000),		//12, Old Iron King
		tB_b(-144, -170, 12, -1, 564, 531, 33000),		//13, Sentinels
		tB_b(-187, -227, 15, 12, 524, 498, 25000),		//14, Gargoyles
		tB_b(-110, -136, -76, -78, 553, 518, 45000)		//15, Sinner
	};
	
	//pos_area is redundant and can be substituted with an entry in boss_area with the soul count of 0
	//will be fixed once i have all the boss entries set up
	
	vars.pos_area = new List<Tuple<float, float, float, float, float, float>>{
		tB_a(-217, -227.5f, 12, 10, -166, -170),	//00, bridge in things betwixt
		tB_a(8, 5, -6, -7, 280, 276),			//01, bonfire after dragonrider
		tB_a(-180, -190, 14, 13, -137, -147),		//02, after character creation
		tB_a(-25, -28, 20, 19, -90, -95),		//03, majula entrance
		tB_a(7, 3, -9.5f, -10.5f, 165, 153)		//04, heide's tower of flame entry
	};
	
	//array of possible routes for each category
	//routes consist of strings with info on each split in order
	//the strings are be structured as follows:
	// - a letter, either 'a' or 'b', indicating whether the split is for the boss or an area
	// - a number, indicating which entry in the appropriate list should be checked
	// - a letter, either 'l', 'i' or 'n', indicating whether the split should happen on the next load, instantly or not at all (useful if you're revisiting an area in the route and only want the split to happen on the second instance of visiting, for example)
	
	vars.route = new string[][] {
		new string[] {"a00i"},	//any
		new string[] {"a00i"},	//17k
		new string[] {"a00i"},	//4 rotten
		new string[] {"a00i"},	//5 rotten
		new string[] {"a00i"},	//crs
		new string[] {"a00i"},	//ab
		new string[] {"b03i", "b00i", "b01i", "b13i", "b06i"},	//ab no dlc
		new string[] {"a00i", "a02i", "a03i", "a04i", "b00i", "a01l", "b00i"}	//rbo (just testing stuff on this one for now)
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
	switch (modules.First().ModuleMemorySize) {
		case 34299904: case 34361344:
		version = "Scholar of the First Sin";
		break;
		case 33902592: case 33927168:
		version = "1.11";
		break;
		default:
		version = "1.02";
		break;
	}
}

start {
	if (current.load == old.load - 1 &&
	current.xPos < -322.0f && current.zPos < -213.0f &&
	current.xPos > -323.0f && current.zPos > -214.0f) {
		
		vars.category = 0;
		while (vars.category < vars.cat.GetLength(0) && !settings[vars.cat[vars.category, 0]]) {
			vars.category++;
		}
		print("CATEGORY: " + vars.category.ToString());
		vars.doneSplits = 0;
		vars.wait_for_load = false;
		return true;
	}
}

split {
	if (vars.category < vars.cat.GetLength(0)) {
		string split_data = vars.route[vars.category][vars.doneSplits];
		int route_index = int.Parse(String.Join("", split_data.Where(Char.IsDigit)));
		Tuple<float, float, float, float, float, float> split_a = null;
		Tuple<float, float, float, float, float, float, int> split_b = null;

		if (vars.pos_area.Count > route_index) split_a = vars.pos_area[route_index];
		if (vars.boss_area.Count > route_index) split_b = vars.boss_area[route_index];
		//if (split_a != null) print(split_a.Item1.ToString());
		
		//todo: see line 46
		if (split_data[0] == 'a' && split_a != null) {
			if (current.xPos <= split_a.Item1 && current.xPos >= split_a.Item2 &&
			current.yPos <= split_a.Item3 && current.yPos >= split_a.Item4 &&
			current.zPos <= split_a.Item5 && current.zPos >= split_a.Item6) {
				if (split_data[3] == 'i') {
					vars.doneSplits++;
					print("Area splitting for route entry: " + split_data);
					return (old.xPos > split_a.Item1 || old.xPos < split_a.Item2 ||
					old.yPos > split_a.Item3 || old.yPos < split_a.Item4 ||
					old.zPos > split_a.Item5 || old.zPos < split_a.Item6);
				} else if (split_data[3] == 'l') {
					vars.wait_for_load = true;
				} else {
					vars.doneSplits++;
				}
			}
		}
		
		if (split_data[0] == 'b' && split_b != null) {
			if (current.xPos < split_b.Item1 && current.xPos > split_b.Item2 &&
			current.yPos < split_b.Item3 && current.yPos > split_b.Item4 &&
			current.zPos < split_b.Item5 && current.zPos > split_b.Item6 &&
			current.souls >= old.souls + split_b.Item7 && current.souls <= old.souls + (split_b.Item7 * 1.69)) {
				if (split_data[3] == 'i') {
					vars.doneSplits++;
					print("Boss splitting for route entry: " + split_data);
					return true;
				} else if (split_data[3] == 'l') {
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
	current.xPos > -323.0f && current.zPos > -214.0f &&
	current.souls == 0) {
		return true;
	}
}

isLoading {
	return current.load == 1;
}
