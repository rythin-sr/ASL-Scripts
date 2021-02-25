//Dark Souls II Autosplitter + Load Remover
//huge thank you to Dread for the original load remover,
//as well as pseudostripy for help finding correct coordinates, Ero for helping with the code
//Nyk for helping with SotFS routes

state("DarkSoulsII", "1.11") {
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
	
	var tB = (Func<float, float, float, float, float, float, int, Tuple<float, float, float, float, float, float, int>>) ((elmt1, elmt2, elmt3, elmt4, elmt5, elmt6, elmt7) => { return Tuple.Create(elmt1, elmt2, elmt3, elmt4, elmt5, elmt6, elmt7); });
	
	//list with info on all the boss areas and soul rewards
	//set soul count to 0 for non-boss areas
	//x_max, x_min, y_max, y_min, z_max, z_min, souls
	vars.split_area = new List<Tuple<float, float, float, float, float, float, int>>{
		tB(86, 113, -41, -39, -143, -112, 10000),     //00, Last Giant
		tB(130, 145, 9, 11, -220, -175, 17000),       //01, Pursuer, normal kill
		tB(78, 82, 1, 2, -185, -181, 16900),          //02, Pursuer, 17k
		tB(-7, 22, -15, -14, 275, 290, 12000),        //03, Dragonrider
		tB(-285, -240, -228, -225, -128, -93, 47000), //04, Rotten NG
		tB(-285, -240, -228, -225, -128, -93, 94000), //05, Rotten NG+
		tB(-285, -240, -228, -225, -128, -93, 117500),//06, Rotten NG+2
		tB(-285, -240, -228, -225, -128, -93, 129250),//07, Rotten NG+3
		tB(-285, -240, -228, -225, -128, -93, 141000),//08, Rotten NG+4
		tB(-184, -144, 7, 9, 144, 185, 20000),        //09, Dragonslayer
		tB(1, 23, -72, -71, 518, 532, 14000),         //10, Flexile
		tB(-435, -393, 36, 40, 226, 267, 15000),      //11, Skeleton Lords
		tB(-550, -520, 52, 54, 530, 558, 13000),      //12, Covetous Demon
		tB(-576, -548, 85, 87, 534, 565, 20000),      //13, Mytha 
		tB(-731, -706, 176, 177, 645, 667, 32000),    //14, Smelter Demon (Red)
		tB(-653, -627, 166, 167, 710, 731, 48000),    //15, Old Iron King
		tB(-170, -144, -1, 12, 531, 564, 33000),      //16, Sentinels
		tB(-227, -187, 12, 15, 498, 524, 25000),      //17, Gargoyles
		tB(-136, -110, -78, -76, 518, 553, 45000),    //18, Sinner
		tB(-472, -432, 83, 88, -325, -287, 23000),    //19, Najka
		tB(-553, -488, 107, 108, -216, -161, 14000),  //20, Rat Authority
		tB(-652, -627, 116, 117, -59, -32, 7000),     //21, Congregation
		tB(-593, -537, 72, 74, -129, -80, 42000),     //22, Freja
		tB(-126, -110, -31, -29, 4, 34, 11000),       //23, Royal Rat Vanguard
		tB(-496, -466, 108, 110, -373, -353, 26000),  //24, Dragonriders
		tB(-675, -635, 103, 105, -360, -323, 34000),  //25, Mirror Knight
		tB(-1113, -1069, -33, -31, -171, -115, 26000),//26, Demon of Song
		tB(-1009, -981, -133, -131, -73, -38, 50000), //27, Velstadt
		tB(-803, -749, 80, 81, -274, -225, 37000),    //28, Guardian Dragon
		tB(-909, -817, 336, 337, -794, -671, 120000), //29, Ancient Dragon
		tB(129, 158, -5, 1, -278, -172, 75000),       //30, Giant Lord
		tB(-166, -131, -62, -59, 383, 420, 84000),    //31, Fume Knight
		tB(-256, -234, -27, -25, 437, 460, 75000),    //32, Smelter Demon (Blue)
		tB(-115, -85, 52, 53, 697, 730, 80000),       //33, Sir Alonne
		tB(-983, -957, -138, -137, -29, -3, 90000),   //34, Vendrick
		tB(-134, -96, -72, -71, -41, -7, 72000),      //35, Elana
		tB(-256, -173, -80, -79, -28, 52, 96000),     //36, Sinh
		tB(-31, 10, 14, 21, 52, 113, 60000),          //37, Gank Squad
		tB(-90, 8, -24, -23, -35, 3, 78000),          //38, Aava
		tB(209, 297, -285, -280, -78, -30, 92000),    //39, Ivory
		tB(-414, -354, -70, -68, 358, 400, 56000),    //40, Twin Pets
		tB(-283, -220, 47, 49, -132, -41, 19000),     //41, Chariot
		tB(-1033, -1004, 11, 14, 264, 301, 35000),    //42, Darklurker
		tB(-744, -700, -6, -4, -275, -224, 68000),    //43, Throne Duo
		tB(-744, -700, -6, -4, -275, -224, 90000),    //44, Nashandra
		tB(-909, -817, 336, 337, -794, -671, 0),      //45, Ancient Dragon Arena
		tB(5, 8, -7, -4, 276, 280, 0),                //46, bonfire after dragonrider
		tB(-846, -843, 79, 86, -252, -248, 0),        //47, elevator after Guardian Dragon
		tB(-684, -680, 102, 110, -344, -340, 0),      //48, Mirror Knight elevator
		tB(-1038, -1035, -30, -25, -88, -86, 0),      //49, Door after Demon of Song
		tB(78, 82, 1, 2, -185, -181, 0),              //50, Melentia bonfire
		tB(-39, -33, 20, 23, 101, 107, 0),            //51, last Ascetic pickup in DLC1
		tB(-354, -348, 42, 44, -216, -210, 0),        //52, RTSR
		tB(-334, -325, 32, 33, -163, -157, 0),        //53, Ruined Fork Road bonfire
		tB(21, -37, 0, 0, 0, 0, 0),                   //54, impossible condition to put at the end of the route to prevent errors
		tB(-457, -447, 38, 39, 234, 238, 0),          //55, before bridge after Skeleton Lords
		tB(-554, -550, 89, 92, 589, 591, 0),          //56, Mytha elevator
		tB(-736, -734, 184, 185, 648, 650.4f, 0),     //57, door after Smelter Demon
		tB(-185, -181.5f, 7, 8, 547, 551, 0),         //58, bonfire room after Ruin Sentinels
		tB(74, 77, -2, 0, -54.5f, -52, 0)             //59, big door after Aava
	};
	
	//array of possible routes for each category
	//routes consist of strings with info on each split in order
	//the strings are be structured as follows:
	// - a number, indicating which entry in the appropriate list should be checked
	// - a letter, either 'l', 'i' or 'n', indicating whether the split should happen on the next load, instantly or not at all (useful if you're revisiting an area in the route and only want the split to happen on the second instance of visiting, for example)
	
	vars.route = new string[][] {
		new string[] {"30l", "54n"},	//any
		new string[] {"02l", "04l", "51n", "50i", "52n", "53l", "05n", "06l", "07l", "08l", "24i", "25n", "48i", "26n", "49i", "27l", "28n", "47i", "45l", "30l", "54n"},	//17k
		new string[] {"00l", "01l", "04l", "16l", "05n", "06l", "07l", "24i", "25n", "48i", "26n", "49i", "27l", "28n", "47i", "45l", "30l", "54n"},	//4 rotten
		new string[] {"00l", "04l", "05n", "06l", "07l", "08l", "24i", "25n", "48i", "26n", "49i", "27l", "28n", "47i", "45l", "30l", "54n"},	//5 rotten
		new string[] {"04l", "05n", "06l", "07l", "08l", "24i", "25n", "48i", "26n", "49i", "27l", "28n", "47i", "45l", "30l", "54n"},	//crs
		new string[] {"00l", "01l", "03l", "04l", "09l", "10l", "11n", "55i", "12i", "13n", "56i", "14n", "57i", "15l", "16n", "58i", "17l", "18l", "19i", "20i", "21i", "22l", "23l", "24i", "25i", "26i", "27l", "28i", "29l", "30l", "31l", "32l", "33l", "34l", "35i", "36l", "37l", "38n", "59i", "39l", "40l", "41l", "42l", "54n"},	//ab
		new string[] {"03l", "11l", "23i", "24i", "25i", "26i", "27l", "28i", "29l", "41l", "12i", "13i", "14i", "15l", "00l", "30l", "16l", "17l", "18l", "34l", "19i", "20i", "21i", "22l", "04l", "09l", "10l", "42l", "54n"},	//ab no dlc
		new string[] {"45l", "46l", "43l", "44l", "29l", "28l", "34l", "27l", "26l", "25l", "24l", "42l", "04l", "23l", "22l", "21l", "20l", "19l", "15l", "14l", "13l", "12l", "11l", "41l", "18l", "17l", "16l", "10l", "09l", "03l", "00l", "54n"},	//rbo
		new string[] {"00l", "04l", "19i", "21l", "16l", "05l", "06l", "07l", "24i", "25n", "48i", "26n", "49i", "27l", "28n", "47i", "45l", "30l", "54n"} //SOFTS Any%
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
		{"rbo", "Reverse Boss Order", " -Ashen Mist pickup (load)\n -Dragonrider Skip (load)\n -Every boss, splitting on a following load or instantly on boss death if no load happens"},
		{"sotfs_any", "Scholar Any%", "-Last Giant (load)\n-Rotten (load)\n-Najka (boss death)\n-Congregation (load)\n-Sentinels (load)\n-Rotten 2 (load)\n-Rotten 3 (load)\n-Rotten 4 (load)\n-Dragonriders (boss death)\n-Mirror Knight (elevator)\n-Demon of Song (door)\n-Velstadt (load)\n-Guardian Dragon (elevator)\n-Ashen Mist Heart pickup (load)\n-Giant Lord (load)"}
	};
	
	settings.Add("rt", true, "Route");
	
	for (int i = 0; i < vars.cat.GetLength(0); i++) {
		settings.Add(vars.cat[i, 0], false, vars.cat[i, 1], "rt");
		settings.SetToolTip(vars.cat[i, 0], "Feel free to add manual splits at your own leisure.\nThe following autosplits are supported:\n" + vars.cat[i, 2] + "\n-Nashandra (final cutscene)");
	}
	
	settings.Add("ffleret", false, "Split on every loading screen");
	settings.SetToolTip("ffleret", "This setting will only work if no route is selected.");
	
	//additional variables used for keeping track of split order
	vars.doneSplits = 0;
	vars.category = 50;
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
		Tuple<float, float, float, float, float, float, int> split = null;

		if (vars.split_area.Count > route_index) split = vars.split_area[route_index];
		//if (split_a != null) print(split_a.Item1.ToString());	
		
		if (current.xPos <= split.Item2 && current.xPos >= split.Item1 &&
		current.yPos <= split.Item4 && current.yPos >= split.Item3 &&
		current.zPos <= split.Item6 && current.zPos >= split.Item5 &&
		current.souls >= old.souls + split.Item7 && current.souls <= old.souls + (split.Item7 * 1.69)) {
			if (split_data[2] == 'i') {
				vars.doneSplits++;
				//print("Boss splitting for route entry: " + split_data);
				return true;
			} else if (split_data[2] == 'l') {
				vars.wait_for_load = true;
			} else {
				vars.doneSplits++;
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
