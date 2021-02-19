//Dark Souls II Autosplitter + Load Remover
//huge thank you to Dread for the original load remover,
//as well as pseudostripy for help finding correct coordinates and Ero for helping with the code

state("DarkSoulsII", "1.11")
{
	float xPos:	0x114A5B4, 0x8, 0x88, 0xC;         //horizontal
	float yPos:	0x114A5B4, 0x8, 0x88, 0x10;        //vertical
	float zPos:	0x114A5B4, 0x8, 0x88, 0x14;        //horizontal
	int state:	0x11493F4, 0x74, 0xB8, 0x2D4;      //1 in cutscenes and backstabs/ripostes (lol), 2 when falling, 0 otherwise
	int souls:	0x11493F4, 0x74, 0x2EC, 0x238;		
	int load: 	0x118E8E0, 0x1D4;                  //1 in loads
}

state("DarkSoulsII", "1.02") {
	float xPos:	0xFB4F74, 0x8, 0xBC;				
	float yPos:	0xFB4F74, 0x8, 0xC0;				
	float zPos:	0xFB4F74, 0x8, 0xC4;				
	int state:	0xFB3E3C, 0x74, 0xB8, 0x2D4;		
	int souls:	0xFB3E3C, 0x74, 0x2EC, 0x238;		
	int load: 	0xFF9298, 0x1D4;
}

state("DarkSoulsII", "Scholar of the First Sin") {
	float xPos:	0x160DCD8, 0x8, 0x5D0;				
	float yPos:	0x160DCD8, 0x8, 0x5D4;				
	float zPos:	0x160DCD8, 0x8, 0x5D8;				
	int state:	0x160B8D0, 0xD0, 0x100, 0x304;		
	int souls:	0x160B8D0, 0xD0, 0x380, 0x21C;		
	int load: 	0x186CCB0, 0x11C;
}

startup {
	
	var tB_a = (Func<float, float, float, float, float, float, Tuple<float, float, float, float, float, float>>) ((elmt1, elmt2, elmt3, elmt4, elmt5, elmt6) => { return Tuple.Create(elmt1, elmt2, elmt3, elmt4, elmt5, elmt6); });
	var tB_b = (Func<float, float, float, float, float, float, int, Tuple<float, float, float, float, float, float, int>>) ((elmt1, elmt2, elmt3, elmt4, elmt5, elmt6, elmt7) => { return Tuple.Create(elmt1, elmt2, elmt3, elmt4, elmt5, elmt6, elmt7); });
	
	//list with info on all the boss areas and soul rewards
	//x_max, x_min, y_max, y_min, z_max, z_min, souls
	vars.boss_area = new List<Tuple<float, float, float, float, float, float, int>>{
		tB_b(86, 113, -41, -39, -143, -112, 10000),         //00, Last Giant
		tB_b(130, 145, 9, 11, -220, -175, 17000),           //01, Pursuer, normal kill
		tB_b(78, 82, 1, 2, -185, -181, 16900),              //02, Pursuer, 17k
		tB_b(-7, 22, -15, -14, 275, 290, 12000),            //03, Dragonrider
		tB_b(-285, -240, -228, -225, -128, -93, 47000),     //04, Rotten NG
		tB_b(-285, -240, -228, -225, -128, -93, 94000),     //05, Rotten NG+
		tB_b(-285, -240, -228, -225, -128, -93, 117500),    //06, Rotten NG+2
		tB_b(-285, -240, -228, -225, -128, -93, 129250),    //07, Rotten NG+3
		tB_b(-285, -240, -228, -225, -128, -93, 141000),    //08, Rotten NG+4
		tB_b(-184, -144, 7, 9, 144, 185, 20000),            //09, Dragonslayer
		tB_b(1, 23, -72, -71, 518, 532, 14000),             //10, Flexile
		tB_b(-435, -393, 36, 40, 226, 267, 15000),          //11, Skeleton Lords
		tB_b(-550, -520, 52, 54, 530, 558, 13000),          //12, Covetous Demon
		tB_b(-576, -548, 85, 87, 534, 565, 20000),          //13, Mytha 
		tB_b(-731, -706, 176, 177, 645, 667, 32000),        //14, Smelter Demon (Red)
		tB_b(-653, -627, 166, 167, 710, 731, 48000),        //15, Old Iron King
		tB_b(-170, -144, -1, 12, 531, 564, 33000),          //16, Sentinels
		tB_b(-227, -187, 12, 15, 498, 524, 25000),          //17, Gargoyles
		tB_b(-136, -110, -78, -76, 518, 553, 45000),        //18, Sinner
		tB_b(-472, -432, 83, 88, -325, -287, 23000),        //19, Najka
		tB_b(-553, -488, 107, 108, -216, -161, 14000),      //20, Rat Authority
		tB_b(-652, -627, 116, 117, -59, -32, 7000),         //21, Congregation
		tB_b(-593, -537, 72, 74, -129, -80, 42000),         //22, Freja
		tB_b(-126, -110, -31, -29, 4, 34, 11000),           //23, Royal Rat Vanguard
		tB_b(-496, -466, 108, 110, -373, -353, 26000),      //24, Dragonriders
		tB_b(-675, -635, 103, 105, -360, -323, 34000),      //25, Mirror Knight
		tB_b(-1113, -1069, -33, -31, -171, -115, 26000),    //26, Demon of Song
		tB_b(-1009, -981, -133, -131, -73, -38, 50000),     //27, Velstadt
		tB_b(-803, -749, 80, 81, -274, -225, 37000),        //28, Guardian Dragon
		tB_b(-909, -817, 336, 337, -794, -671, 120000),     //29, Ancient Dragon
		tB_b(129, 158, -5, 1, -278, -172, 75000),           //30, Giant Lord
		tB_b(-166, -131, -62, -59, 383, 420, 84000),        //31, Fume Knight
		tB_b(-256, -234, -27, -25, 437, 460, 75000),        //32, Smelter Demon (Blue)
		tB_b(-115, -85, 52, 53, 697, 730, 80000),           //33, Sir Alonne
		tB_b(-983, -957, -138, -137, -29, -3, 90000),       //34, Vendrick
		tB_b(-134, -96, -72, -71, -41, -7, 72000),          //35, Elana
		tB_b(-256, -173, -80, -79, -28, 52, 96000),         //36, Sinh
		tB_b(-31, 10, 14, 21, 52, 113, 60000),              //37, Gank Squad
		tB_b(-90, 8, -24, -23, -35, 3, 78000),              //38, Aava
		tB_b(209, 297, -285, -280, -78, -30, 92000),        //39, Ivory
		tB_b(-414, -354, -70, -68, 358, 400, 56000),        //40, Twin Pets
		tB_b(-283, -220, 47, 49, -132, -41, 19000),         //41, Chariot
		tB_b(-1033, -1004, 11, 14, 264, 301, 35000),        //42, Darklurker
		tB_b(-744, -700, -6, -4, -275, -224, 68000),        //43, Throne Duo
		tB_b(-744, -700, -6, -4, -275, -224, 90000)	    //44, Nashandra
	};
	
	//pos_area is redundant and can be substituted with an entry in boss_area with the soul count of 0
	//will be fixed once i have all the boss entries set up
	
	vars.pos_area = new List<Tuple<float, float, float, float, float, float>>{
		tB_a(-909, -817, 336, 337, -794, -671),         //00, Ancient Dragon Arena
		tB_a(5, 8, -7, -4, 276, 280),                   //01, bonfire after dragonrider
		tB_a(-846, -843, 79, 86, -252, -248),           //02, elevator after Guardian Dragon
		tB_a(-684, -680, 102, 110, -344, -340),         //03, Mirror Knight elevator
		tB_a(-1038, -1035, -30, -25, -88, -86),         //04, Door after Demon of Song
		tB_a(78, 82, 1, 2, -185, -181),                 //05, Melentia bonfire
		tB_a(-39, -33, 20, 23, 101, 107),               //06, last Ascetic pickup in DLC1
		tB_a(-354, -348, 42, 44, -216, -210),           //07, RTSR
		tB_a(-334, -325, 32, 33, -163, -157),           //08, Ruined Fork Road bonfire
		tB_a(21, -37, 0, 0, 0, 0),                      //09, impossible condition to put at the end of the route to prevent errors
		tB_a(-457, -447, 38, 39, 234, 238),             //10, before bridge after Skeleton Lords
		tB_a(-554, -550, 89, 92, 589, 591),             //11, Mytha elevator
		tB_a(-736, -734, 184, 185, 648, 650.4f),        //12, door after Smelter Demon
		tB_a(-185, -181.5f, 7, 8, 547, 551),            //13, bonfire room after Ruin Sentinels
		tB_a(74, 77, -2, 0, -54.5f, -52)                //14, big door after Aava
	};
	
	//array of possible routes for each category
	//routes consist of strings with info on each split in order
	//the strings are be structured as follows:
	// - a letter, either 'a' or 'b', indicating whether the split is for the boss or an area
	// - a number, indicating which entry in the appropriate list should be checked
	// - a letter, either 'l', 'i' or 'n', indicating whether the split should happen on the next load, instantly or not at all (useful if you're revisiting an area in the route and only want the split to happen on the second instance of visiting, for example)
	
	vars.route = new string[][] {
		new string[] {"b30l", "a09n"},	//any
		new string[] {"b02l", "b04l", "a06n", "a05i", "a07n", "a08l", "b05n", "b06l", "b07l", "b08l", "b24i", "b25n", "a03i", "b26n", "a04i", "b27l", "b28n", "a02i", "a00l", "b30l", "a09n"},	//17k
		new string[] {"b00l", "b01l", "b04l", "b16l", "b05n", "b06l", "b07l", "b24i", "b25n", "a03i", "b26n", "a04i", "b27l", "b28n", "a02i", "a00l", "b30l", "a09n"},	//4 rotten
		new string[] {"b00l", "b04l", "b05n", "b06l", "b07l", "b08l", "b24i", "b25n", "a03i", "b26n", "a04i", "b27l", "b28n", "a02i", "a00l", "b30l", "a09n"},	//5 rotten
		new string[] {"b04l", "b05n", "b06l", "b07l", "b08l", "b24i", "b25n", "a03i", "b26n", "a04i", "b27l", "b28n", "a02i", "a00l", "b30l", "a09n"},	//crs
		new string[] {"b00l", "b01l", "b03l", "b04l", "b09l", "b10l", "b11n", "a10i", "b12i", "b13n", "a11i", "b14n", "a12i", "b15l", "b16n", "a13i", "b17l", "b18l", "b19i", "b20i", "b21i", "b22l", "b23l", "b24i", "b25i", "b26i", "b27l", "b28i", "b29l", "b30l", "b31l", "b32l", "b33l", "b34l", "b35i", "b36l", "b37l", "b38n", "a14i", "b39l", "b40l", "b41l", "b42l", "a09n"},	//ab
		new string[] {"b03l", "b11l", "b23i", "b24i", "b25i", "b26i", "b27l", "b28i", "b29l", "b41l", "b12i", "b13i", "b14i", "b15l", "b00l", "b30l", "b16l", "b17l", "b18l", "b34l", "b19i", "b20i", "b21i", "b22l", "b04l", "b09l", "b10l", "b42l", "a09n"},	//ab no dlc
		new string[] {"a00l", "a01l", "b43l", "b44l", "b29l", "b28l", "b34l", "b27l", "b26l", "b25l", "b24l", "b42l", "b04l", "b23l", "b22l", "b21l", "b20l", "b19l", "b15l", "b14l", "b13l", "b12l", "b11l", "b41l", "b18l", "b17l", "b16l", "b10l", "b09l", "b03l", "b00l", "a09n"}	//rbo
	};
	
	//todo: add scholar categories/routes
	
	//array of supported categories
	vars.cat = new[,]{
		{"any", "Any%", " -Giant Lord (load)"},
		{"17k", "Any% (17000 Souls)", " -Pursuer (load)\n -Rotten (load)\n -Rotten 2 & 3 (load)\n -Rotten 4 (load)\n -Rotten 5 (load)\n -Mirror Knight (elevator)\n -Demon of Song (door)\n -Velstadt (load)\n -Guardian Dragon (elevator)\n -Ashen Mist Pickup (load)\n -Giant Lord (load)"},
		{"4r", "Any% (4 Rotten)", " -Last Giant (load)\n -Pursuer (load)\n -Rotten (load)\n -Sentinels (load)\n -Rotten 2 & 3 (load)\n -Rotten 4 (load)\n -Rotten 5 (load)\n -Mirror Knight (elevator)\n -Demon of Song (door)\n -Velstadt (load)\n -Guardian Dragon (elevator)\n -Ashen Mist Pickup (load)\n -Giant Lord (load)"},
		{"5r", "Any% (5 Rotten)", " -Last Giant (load)\n -Rotten (load)\n -Rotten 2 & 3 (load)\n -Rotten 4 (load)\n -Rotten 5 (load)\n -Mirror Knight (elevator)\n -Demon of Song (door)\n -Velstadt (load)\n -Guardian Dragon (elevator)\n -Ashen Mist Pickup (load)\n -Giant Lord (load)"},
		{"crs", "Any% (Cat Ring Skip)", " -Rotten (load)\n -Rotten 2 & 3 (load)\n -Rotten 4 (load)\n -Rotten 5 (load)\n -Mirror Knight (elevator)\n -Demon of Song (door)\n -Velstadt (load)\n -Guardian Dragon (elevator)\n -Ashen Mist Pickup (load)\n -Giant Lord (load)"},
		{"ab", "All Bosses", " -Every boss, splitting on a following load, instantly on boss or in a specific area, based on WR splits with small adjustments.\nNon-boss splits currently not automated."},
		{"abnodlc", "All Bosses No DLC", " -Every boss, splitting on a following load or instantly on boss death if no load happens"},
		{"rbo", "Reverse Boss Order", " -Ashen Mist pickup (load)\n -Dragonrider Skip (load)\n -Every boss, splitting on a following load or instantly on boss death if no load happens"}
	};
	
	settings.Add("rt", true, "Route");
	
	for (int i = 0; i < vars.cat.GetLength(0); i++) {
		settings.Add(vars.cat[i, 0], false, vars.cat[i, 1], "rt");
		settings.SetToolTip(vars.cat[i, 0], "Feel free to add manual splits at your own leisure.\nThe following autosplits are supported:\n" + vars.cat[i, 2]);
	}
	
	settings.Add("ffleret", false, "Split on every loading screen");
	settings.SetToolTip("ffleret", "This setting will only work if no route is selected.");
	
	//additional variables used for keeping track of split order
	vars.doneSplits = 0;
	vars.category = 0;
	vars.wait_for_load = false;
	vars.wait_for_cutscene = false;
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
		//print("CATEGORY: " + vars.category.ToString());
		vars.doneSplits = 0;
		vars.wait_for_cutscene = false;
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
		
		//todo: see line 79
		if (split_data[0] == 'a' && split_a != null) {
			if (current.xPos <= split_a.Item2 && current.xPos >= split_a.Item1 &&
			current.yPos <= split_a.Item4 && current.yPos >= split_a.Item3 &&
			current.zPos <= split_a.Item6 && current.zPos >= split_a.Item5) {
				if (split_data[3] == 'i') {
					vars.doneSplits++;
					print("Area splitting for route entry: " + split_data);
					return (old.xPos > split_a.Item2 || old.xPos < split_a.Item1 ||
					old.yPos > split_a.Item4 || old.yPos < split_a.Item3 ||
					old.zPos > split_a.Item6 || old.zPos < split_a.Item5);
				} else if (split_data[3] == 'l') {
					vars.wait_for_load = true;
				} else {
					vars.doneSplits++;
				}
			}
		}
		
		if (split_data[0] == 'b' && split_b != null) {
			if (current.xPos <= split_b.Item2 && current.xPos >= split_b.Item1 &&
			current.yPos <= split_b.Item4 && current.yPos >= split_b.Item3 &&
			current.zPos <= split_b.Item6 && current.zPos >= split_b.Item5 &&
			current.souls >= old.souls + split_b.Item7 && current.souls <= old.souls + (split_b.Item7 * 1.69)) {
				if (split_data[3] == 'i') {
					vars.doneSplits++;
					//print("Boss splitting for route entry: " + split_data);
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
			//print("Load splitting for route entry: " + split_data);
			return true;
		}
	} else {
		if (settings["ffleret"]) {
			return current.load == old.load + 1;
		}
	}
	
	//final split for all categories		
	if (current.xPos > -744 && current.xPos < -700 &&
	current.zPos > -275 && current.zPos < -224 &&
	current.souls >= old.souls + 90000) {
		print("Nashandra killed!");
		vars.wait_for_cutscene = true;
	}
		
	if (timer.CurrentSplitIndex == timer.Run.Count() - 1) {
		if (current.xPos > -744 && current.xPos < -700 &&
		current.zPos > -275 && current.zPos < -224 &&
		current.state == old.state + 1 && vars.wait_for_cutscene == true) {
			vars.wait_for_cutscene = false;
			return true;
		}
	}
}

reset {
	if (current.xPos == 0 && current.zPos == 0 && 
	current.yPos <= -100 && old.yPos > -100 &&
	current.state == 2) {
		return true;
	}
}

isLoading {
	return current.load == 1;
}
