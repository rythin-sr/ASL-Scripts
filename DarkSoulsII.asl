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
	vars.debug_output = false;
	var tB = (Func<float, float, float, float, float, float, int, Tuple<float, float, float, float, float, float, int>>) ((elmt1, elmt2, elmt3, elmt4, elmt5, elmt6, elmt7) => { return Tuple.Create(elmt1, elmt2, elmt3, elmt4, elmt5, elmt6, elmt7); });
	
	//print("testing");
	
	//list with info on all the boss areas and soul rewards
	//set soul count to 0 for non-boss areas
	//x_min, x_max, y_min, y_max, z_min, z_max, souls
	vars.split_conditions = new List<Tuple<float, float, float, float, float, float, int>>{
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
		tB(73.5f, 77.5f, -2.5f, 0.5f, -55, -51.5f, 0),//59, big door after Aava
		tB(-84, -78, -13, -12, -18, -12, 0),          //60, DLC1 Dragon Stone Bonfire
		tB(-198, -190, 34, 36, 311, 321, 0),          //61, DLC2 scorching iron sceptre
		tB(39, 49, -39, -37, -154, -144, 0),          //62, DLC2 Key
		tB(-247, -190, -233, -230, -139, -93, 4000),  //63, Black Gulch giant 
		tB(10, 11, 5, 6, -17, -16, 0),                //64, Majula bonfire (from warp)
		tB(-174, -171, 24, 25, 54, 58, 0),            //65, Felkin bonfire
		tB(-225,-244,38,64,1.6f,-9,16998),			  //66, Pursuer, Lucida 17k
		// TODO
		// 67 DLC1 Entrance
		// 68 DLC2 Entrance
		// 69 DLC3 Entrance
		// 73 Dungeon: Woods portal
		// 74 Dungeon: Gulch portal
		// 75 Dungeon: Drangleic portal
		// 76 Shaded Ruins Bonfire
		// 77 Bridge Approach bonfire
		// 69 Dragon Stone bonfire
		// 67 Flynns
		// 72 DLC2 Chunks/Butterly pickup
		// 78 Vammar 20k
		// 80 Tseldora ascetic
		// 81 Bastille ascetic
		// 79 Aldia / 0 souls finish
	};
	
	// Routes are described by a list of splits, with split conditions represented by:
	// Number: Index representing above condition to meet.
	// Letter: 
	// 		'L' - "Next Load"
	//  	'S' - "Split (now)"
	//  	'N' - "NO split"
	// 		'C' - "Next cutscene"
	
	
	
	// Define anon type (shorthand)
	//var Troute = (Func<string, string, Tuple<string, string>>) ((UID, routename) => { return Tuple.Create(UID, routename); });
	var Tsplit = (Func<string, string, Tuple<string, string>>) ((name, cond) => { return Tuple.Create(name, cond); });
	
	// Route definitions (Scholar routes must have "sotfs" somewhere in unique id)
	vars.routes = new List<Tuple<string, string, List<Tuple<string,string>>>>();
	////////////////////////////////////////
	////		 VANILLA ROUTES 		////
	////////////////////////////////////////
	// Any%, Dragon Tooth
	vars.routes.Add(
		Tuple.Create("any", "Any%", 
			new List<Tuple<string,string>>
			{
				Tsplit("Giant Lord", 	"30L"),
				Tsplit("Nashandra", 	"44C"),
			}
		)
	);
	
	// Any% CP (17k, 5 Rotten)
	vars.routes.Add(
		Tuple.Create("17k_5r", "Any% CP (17k, 5 Rotten)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Pursuer", 			"50N 64S"), // (majula warp)
				Tsplit("Rotten 1", 			"04L"), 	// (dlc entrance) TODO ??
				Tsplit("DLC1 Runthrough", 	"51S"), 	// (ascetic boneout)
				Tsplit("RTSR", 				"52N 53L"), // (warp after RTSR)
				Tsplit("Rotten 2 + 3", 		"05N 06L"), // (Rotten 3 boneout)
				Tsplit("Rotten 4", 			"07L"), 	// (boneout)
				Tsplit("Rotten 5", 			"08L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27L"), 	// (boneout) TODO KINGS RING
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ashen Mist", 		"45L"), 	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (boneout)
				Tsplit("Nashandra", 		"43N 44C"), // (black screen after Nash)
			}
		)
	);
	
	// Any% CP (4 Rotten)
	vars.routes.Add(
		Tuple.Create("4r", "Any% CP (4 Rotten)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Last Giant", 		"00L"), 
				Tsplit("Pursuer", 			"01L"), 	// (ASSUMED NEST - not explicit)
				Tsplit("Rotten 1", 			"04L"), 	// (ASSUMED DLC1 entrance - not explicit)
				Tsplit("DLC1 Runthrough", 	""), 		// (TODO - FLynns)
				Tsplit("RTSR", 				"52L"), 	// (RTSR boneout)
				Tsplit("Sentinels", 		"16L"), 	// (ASSUMED ASCETIC - not explicit) 
				Tsplit("Rotten 2 + 3", 		"05N 06L"), // (Rotten 3 boneout)
				Tsplit("Rotten 4", 			"07L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27L"), 	// (boneout) TODO KINGS RING
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ashen Mist", 		"45L"), 	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (boneout)
				Tsplit("Nashandra", 		"43N 44C"), // (black screen after Nash)
			}
		)
	);
	
	// Any% CP (5 Rotten, Pursuer Quick Kill)
	vars.routes.Add(
		Tuple.Create("5r_PQK", "Any% CP (5 Rotten, Pursuer Quick Kill)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Last Giant", 		"00L"), 
				Tsplit("Rotten 1", 			"04L"), 	// (ASSUMED DLC1 entrance - not explicit)
				Tsplit("DLC1 Runthrough", 	"51S"), 	// (ascetic boneout)
				Tsplit("RTSR", 				"52L"), 	// (RTSR boneout)
				Tsplit("Rotten 2 + 3", 		"05N 06L"), // (Rotten 3 boneout)
				Tsplit("Rotten 4", 			"07L"), 	// (boneout)
				Tsplit("Rotten 5", 			"08L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27L"), 	// (boneout) TODO KINGS RING
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ashen Mist", 		"45L"), 	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (boneout)
				Tsplit("Nashandra", 		"43N 44C"), // (black screen after Nash)
			}
		)
	);
	
	// Any% CP (Cat Ring Skip)
	vars.routes.Add(
		Tuple.Create("5r_CRS", "Any% CP (Cat Ring Skip)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Pursuer QK",		"50N 64S"), // (Majula warp)
				Tsplit("Rotten 1", 			"04L"), 	// (ASSUMED DLC1 entrance - not explicit)
				Tsplit("DLC1 Runthrough", 	"51S"), 	// (ascetic boneout)
				Tsplit("RTSR", 				"52L"), 	// (RTSR boneout)
				Tsplit("Rotten 2 + 3", 		"05N 06L"), // (Rotten 3 boneout)
				Tsplit("Rotten 4", 			"07L"), 	// (boneout)
				Tsplit("Rotten 5", 			"08L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27L"), 	// (boneout) TODO KINGS RING
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ashen Mist", 		"45L"), 	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (boneout)
				Tsplit("Nashandra", 		"43N 44C"), // (black screen after Nash)
			}
		)
	);
	
	// Old Souls, Dark rapier
	vars.routes.Add(
		Tuple.Create("OS", "Old Souls (Dark rapier)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Last Giant",		"00L"),
				Tsplit("Pursuer", 			"01L"), 	// (ASSUMED NEST - not explicit)
				Tsplit("Dragonrider", 		"03L"), 	
				Tsplit("Rotten", 			"04L"),
				Tsplit("Skeleton Lords", 	"11N 55S"), // (lever)
				Tsplit("Covetous", 			"12S"),
				Tsplit("Mytha", 			"13N 56S"), // (elevator)
				Tsplit("Old Iron King", 	"15L"),
				Tsplit("Sentinels", 		"16S"),
				Tsplit("Sinner", 			"18L"),
				Tsplit("Najka", 			"19S"),
				Tsplit("Congregation", 		"21S"),
				Tsplit("Freja", 			"22L"),
				Tsplit("Dragonriders", 		"24S"), 	// (boss death)
				Tsplit("Mirror Knight", 	"25N 48S"), // (mirror elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door to crypt elevator)
				Tsplit("Velstadt", 			"27L"),
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ashen Mist", 		"45L"),
				Tsplit("Giant Lord", 		"30L"),
				Tsplit("Nashandra", 		"43N 44C"), 	// (black screen after Nash)
			}
		)
	);
	
	// All Bosses, Dark rapier/Lightning RITB: No parrywalk
	vars.routes.Add(
		Tuple.Create("AB", "All Bosses (No Parrywalk, Dark Rapier/Lightning RITB)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Last Giant",		"00L"), 	// (boneout)
				Tsplit("Pursuer ", 			"01L"), 	// (ASSUMED NEST - not explicit)
				Tsplit("Dragonrider", 		"03L"),  	// (ASSUMED WARP AFTER LICIA - not explicit)	
				Tsplit("Rotten", 			"04L"), 	// (ASSUMED DLC1 ENTRANCE - not explicit)
				Tsplit("DLC1 Runthrough", 	""), 		// TODO (Dragon Stone bonfire)
				Tsplit("Dragonslayer", 		"09L"), 	// (boneout)
				Tsplit("Flexile", 			"10L"), 	// (boneout)
				Tsplit("Skeleton Lords", 	"11N 55S"), // (lever)
				Tsplit("Covetous", 			"12S"),		// (kill)
				Tsplit("Mytha", 			"13N 56S"), // (elevator)
				Tsplit("Smelter Demon",		"14N 57S"), // (door)
				Tsplit("Old Iron King", 	"15L"), 	// (ASSUMED DLC2 ENTRANCE - not explicit)
				Tsplit("DLC2 Runthrough", 	""), 		// (chunks) TODO
				Tsplit("Sentinels", 		"16S"), 	// (kill)
				Tsplit("Gargoyles", 		"17L"), 	// (boneout)
				Tsplit("Sinner", 			"18L"), 	// (ASSUMED PRIMAL - not explicit)
				Tsplit("Najka", 			"19S"), 	// (kill)
				Tsplit("Authority", 		"20S"), 	// (kill)
				Tsplit("Congregation", 		"21S"), 	// (kill)
				Tsplit("Freja", 			"22L"), 	// (ASSUMED PRIMAL - not explicit)
				Tsplit("Vanguard", 			"23L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27L"), 	// (ASSUMED KING'S RING - not explicit)
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ancient", 			"29L"),  	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (ASSUMED Soul of a Giant - not explicit)
				Tsplit("Fume Knight", 		"31L"),		// (boneout)
				Tsplit("Blue Smelter", 		"32L"), 	// (boneout)
				Tsplit("Sir Alonne", 		"33L"), 	// (boneout)
				Tsplit("Gulch Giants", 		""), 		// (TODO Dungeon Gulch / Grandahl boneout)
				Tsplit("Vendrick", 			"34L"), 	// (boneout)
				Tsplit("Elana", 			"35S"), 	// (kill)
				Tsplit("Sinh", 				"36L"), 	// (boneout)
				Tsplit("Gank Squad", 		"37L"), 	// (boneout)
				Tsplit("Aava", 				"38N 59S"), // (big door)
				Tsplit("Burnt Ivory King", 	"39L"), 	// (boneout)
				Tsplit("Lud and Zallen", 	"40L"), 	// (boneout)
				Tsplit("Chariot", 			"41L"), 	// (boneout)
				Tsplit("Dungeon: Woods", 	""), 		// TODO Dungeon Woods boneout
				Tsplit("Dungeon: Gulch", 	""), 		// TODO Dungeon Gulch boneout
				Tsplit("Darklurker", 		"42L"), 	// (boneout)
				Tsplit("Aldia", 			"43N 44C"), // (cutscene screen after Aldia)	
			}
		)
	);
	
	// All Bosses - No DLC, Hexes
	vars.routes.Add(
		Tuple.Create("old_bosses", "All Bosses No DLC (Hexes)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Shaded Ruins",		""), 		// (warp) TODO Shaded Ruins bonfire
				Tsplit("Licia",				"03N ??"), 	// (warp) TODO Heides: Tower of Prayer
				Tsplit("Pursuer QK",		"50N 64S"), // (warp)
				Tsplit("Bridge Approach",	"L"), 		// (warp) TODO Bridge Approach bonfire
				Tsplit("Skeleton Lords", 	"11N 55S"), // (lever)
				Tsplit("Vanguard",			"23S"), 	// (kill)
				Tsplit("Giants / Grandahl",	""), 		// (Grandahl boneout) (TODO Dungeon Gulch / Grandahl boneout)
				Tsplit("Grandahl Drangleic","00L"), 	// (boneout) (TODO Dungeon Gulch / Grandahl boneout)
				Tsplit("Dragonriders",		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27L"), 	// (ASSUMED KING'S RING - not explicit)
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ancient",			"29L"), 	// (boneout)
				Tsplit("Chariot", 			"41L"), 	// (boneout)
				Tsplit("Covetous",			"12S"), 	// (kill)
				Tsplit("Mytha", 			"13N 56S"), // (elevator)
				Tsplit("Smelter Demon",		"14S"), 	// (kill)
				Tsplit("Old Iron King",		"15L"), 	// (boneout)
				Tsplit("Last Giant",		"00L"), 	// (boneout)
				Tsplit("GL & Memories", 	"30N ??"), 	// (memory exit??) TODO Memory of Orro
				Tsplit("Gargoyles",			"17L"), 	// (boneout)
				Tsplit("Sentinels", 		"16L"), 	// (boneout)
				Tsplit("Sinner", 			"18L"), 	// (boneout)
				Tsplit("Vendrick", 			"34L"), 	// (boneout)
				Tsplit("Najka", 			"19S"), 	// (kill)
				Tsplit("Authority", 		"20S"), 	// (kill)
				Tsplit("Congregation", 		"21S"), 	// (kill)
				Tsplit("Freja", 			"22L"), 	// (boneout)
				Tsplit("Rotten", 			"04L"), 	// (boneout)
				Tsplit("Flexile", 			"10L"), 	// (boneout)
				Tsplit("Dragonslayer", 		"09L"), 	// (boneout)
				Tsplit("Darklurker", 		"42L"), 	// (boneout)
				Tsplit("Nashandra", 		"43N 44C"), // (black screen after Nash)
			}
		)
	);
	
	
	// Reverse Boss Order - Hexes
	vars.routes.Add(
		Tuple.Create("rbo", "Reverse Boss Order (Hexes)", 
			new List<Tuple<string,string>>
			{
				
				Tsplit("Shaded Ruins",		""), 		// (warp) TODO Shaded Ruins bonfire
				Tsplit("Guardian Elevator", "47S"), 	// (elevator)
				Tsplit("Ashen Mist", 		"45L"), 	// (boneout)
				Tsplit("Vammar Memory 20k", "??"), 		// (near 20k pickup boneout) (TODO 20k boneout place)
				Tsplit("Dragonrider skip", 	"??L"),		// (bonfire boneback) (TODO Tower of prayer bonfire)		
				Tsplit("Bridge Approach", 	"??S"), 	// (bonfire action??)
				Tsplit("Poison Pool", 		"??"), 		// (warp) TODO - POISON POOL BONFIRE
				Tsplit("Najka Skip", 		"??L"), 	// (bonfire boneback) TODO - DOORS OF PHARROS BONFIRE
				Tsplit("Tseldora campsite", "??L"), 	// (warp) TODO Tseldora bonfire
				Tsplit("Caitha's Chime", 	"??L"), 	// (boneout) TODO Caitha's Chime Location
				Tsplit("Mirror Knight skip","48S"), 	// (elevator)
				Tsplit("Frog Skip", 		"49S"), 	// (door)
				Tsplit("King's ring", 		"??L"), 	// (boneout) TODO King's Ring
				Tsplit("Giants / Grandahl",	""), 		// (Grandahl boneout) (TODO Dungeon Gulch / Grandahl boneout) 	
				Tsplit("Throne Duo", 		"43L"), 	// (boneout)
				Tsplit("Pursuer skip v2", 	"30N ??"), 	// (nest) TODO Nest
				Tsplit("Nashandra escape", 	"44L"), 	// (boneout)
				Tsplit("Ancient",			"29L"), 	// (boneout)
				Tsplit("Guardian", 			"28L"), 	// (boneout)
				Tsplit("Vendrick", 			"34L"), 	// (boneout) TODO Extend Arena for OOB
				Tsplit("Velstadt", 			"27L"), 	// (boneout)
				Tsplit("Demon of Song", 	"26L"), 	// (boneout)
				Tsplit("Mirror Knight", 	"25L"), 	// (boneout)
				Tsplit("Dragonriders",		"24L"), 	// (boneout)
				Tsplit("Darklurker", 		"42L"), 	// (boneout)
				Tsplit("Rotten", 			"04L"), 	// (boneout)
				Tsplit("Vanguard",			"23L"), 	// (boneout)
				Tsplit("Freja", 			"22L"), 	// (boneout)
				Tsplit("Congregation", 		"21S"), 	// (boneout)				
				Tsplit("Authority", 		"20L"), 	// (boneout)
				Tsplit("Najka", 			"19L"), 	// (boneout)
				Tsplit("Mytha skip", 		"??S"), 	// (bonfire light) TODO Iron Keep Bonfire
				Tsplit("Old Iron King",		"15L"), 	// (boneout)
				Tsplit("Smelter Demon",		"14L"), 	// (boneout)
				Tsplit("Mytha", 			"13L"), 	// (boneout)
				Tsplit("Covetous", 			"12L"), 	// (boneout)
				Tsplit("Skeleton Lords", 	"11L"), 	// (boneout)
				Tsplit("Chariot", 			"41L"), 	// (boneout)
				Tsplit("Sinner", 			"18L"), 	// (boneout)
				Tsplit("Gargoyles",			"17L"), 	// (boneout)
				Tsplit("Sentinels", 		"16L"), 	// (boneout)
				Tsplit("Flexile", 			"10L"), 	// (boneout)
				Tsplit("Dragonslayer", 		"09L"), 	// (boneout)
				Tsplit("Dragonrider", 		"03L"),  	// (boneout)
				Tsplit("Pursuer QK", 		"??"), 		// (rest) TODO PQK properly!
				Tsplit("Last Giant",		"00L"), 	// (boneout)
				Tsplit("Finish", 			"??C"), 	// (cutscene) TODO Aldia cutscene
			}
		)
	);
	////////////////////////////////////////
	////		   SOTFS ROUTES 		 ////
	////////////////////////////////////////
	
	// sotfs_Any% (17k, No Parrywalk)
	vars.routes.Add(
		Tuple.Create("sotfs_17k", "Any% (17k, No Parrywalk)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Pursuer 17k", 		"50N 64S"), // (warp)
				Tsplit("Gulch Giants", 		"63L"), 	// (Giants boneout)
				Tsplit("Majula + RTSR", 	"52N 53L"), // (warp after RTSR)
				Tsplit("Rotten 1", 			"04L"), 	// TODO ASSUMED DLC1 entrance
				Tsplit("DLC 1 runthrough", 	"51N 50S"), // (warp after ascetics)
				Tsplit("Melentia + Level", 	"50N 64L"), // (warp after level)
				Tsplit("Rotten 2 + 3", 		"05N 06L"), // (Rotten 3 boneout)
				Tsplit("Rotten 4", 			"07L"), 	// (boneout)
				Tsplit("Rotten 5", 			"08L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27L"), 	// (boneout) TODO KINGS RING
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ashen Mist", 		"45L"), 	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (boneout)
				Tsplit("Nashandra", 		"43N 44C"), // (black screen after Nash)
			}
		)
	);
	
	// sotfs_Any% (4 Rotten)
	vars.routes.Add(
		Tuple.Create("sotfs_4r", "Any% (4 Rotten)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Last Giant", 		"00L"), 	// (boneout)
				Tsplit("Pursuer", 			"01L"), 	// (ASSUMED NEST - not explicit)
				Tsplit("Rotten 1", 			"04L"), 	// (boneout)
				Tsplit("Najka", 			"19S"), 	// (kill)
				Tsplit("Congregation", 		"21L"), 	// (ascetic boneout) TODO NOT EXPLICIT
				Tsplit("Sentinels", 		"16L"), 	// (ascetic boneout) TODO NOT EXPLICIT
				Tsplit("Rotten 2", 			"05L"), 	// (boneout)
				Tsplit("Rotten 3", 			"06L"), 	// (boneout)
				Tsplit("Rotten 4", 			"07L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27L"), 	// (boneout) TODO KINGS RING
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ashen Mist", 		"45L"), 	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (boneout)
				Tsplit("Nashandra", 		"43N 44C"), // (black screen after Nash)
			}
		)
	);
	
	// sotfs_Old Souls (No Parrywalk, Bandit start)
	vars.routes.Add(
		Tuple.Create("sotfs_OS", "Old Souls (No Parrywalk, Bandit start)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Last Giant", 		"00L"), 	// (boneout)
				Tsplit("Pursuer", 			"01L"), 	// (ASSUMED NEST - not explicit)
				Tsplit("Dragonrider", 		"03L"), 	// ASSUMED LICIA 
				Tsplit("Rotten 1", 			"04L"), 	// (boneout)
				Tsplit("Felkin", 			"65L"),		// (warp)
				Tsplit("Najka", 			"19S"), 	// (kill)
				Tsplit("Congregation", 		"21L"), 	// (ascetic boneout) TODO NOT EXPLICIT
				Tsplit("Freja", 			"22L"), 	// (boneout)
				Tsplit("Sentinels", 		"16S"), 	// (kill)
				Tsplit("Sinner", 			"18L"), 	// (boneout)
				Tsplit("Skeleton Lords", 	"11N 55S"), // (lever)
				Tsplit("Covetous", 			"12S"), 	// (kill)
				Tsplit("Mytha", 			"13N 56S"), // (elevator)
				Tsplit("Old Iron King", 	"15L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27L"), 	// (boneout) TODO KINGS RING
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ashen Mist", 		"45L"), 	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (boneout)
				Tsplit("Nashandra", 		"43N 44C"), // (black screen after Nash)
			}
		)
	);
	
	// sotfs_All Bosses (No Parrywalk, Rapier/Twinblade)
	vars.routes.Add(
		Tuple.Create("sotfs_OS", "Old Souls (No Parrywalk, Bandit start)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Last Giant", 		"00L"), 	// (boneout)
				Tsplit("Pursuer", 			"01L"), 	// (ASSUMED NEST - not explicit)
				Tsplit("Dragonrider", 		"03L"), 	// ASSUMED LICIA 
				Tsplit("Rotten 1", 			"04L"), 	// (boneout)
				Tsplit("Skeleton Lords", 	"11N 55S"), // (lever)
				Tsplit("Covetous", 			"12S"), 	// (kill)
				Tsplit("Gulch Giants", 		"63L"), 	// (boneout)
				Tsplit("Vanguard", 			"23L"), 	// (boneout)
				Tsplit("DLC1 runthrough", 	"60L"), 	// (warp)
				Tsplit("Dragonslayer", 		"09L"), 	// (boneout)
				Tsplit("Flexile", 			"10L"), 	// (boneout)
				Tsplit("Najka", 			"19S"), 	// (kill)
				Tsplit("Authority", 		"20S"), 	// (kill)
				Tsplit("Congregation", 		"21S"), 	// (kill)
				Tsplit("Freja", 			"22L"), 	// (boneout) ASSUMED PRIMAL LOCATION
				Tsplit("Sentinels", 		"16S"), 	// (kill)
				Tsplit("Gargoyles", 		"17L"), 	// (boneout)
				Tsplit("Sinner", 			"18L"), 	// (primal warp) ASSUMED NOT EXPLICIT
				Tsplit("DLC2 Key", 			"62L"), 	// (boneout)
				Tsplit("Mytha", 			"13N 56S"), // (elevator)
				Tsplit("Smelter Demon", 	"14N 57S"), // (door)
				Tsplit("Old Iron King", 	"15L"), 	// ASSUMED DLC2 ENTRANCE
				Tsplit("DLC2 runthrough", 	"61L"), 	// (sceptre boneout)
				Tsplit("Fume Knight", 		"31L"), 	// (boneout)
				Tsplit("Blue Smelter", 		"32L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27L"), 	// (boneout) TODO KINGS RING
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ancient", 			"29L"), 	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (boneout) ASSUMED GIANT SOUL
				Tsplit("Sir Alonne", 		"33L"), 	// (boneout)
				Tsplit("Vendrick", 			"34L"), 	// (boneout)
				Tsplit("Elana", 			"35S"), 	// (kill)
				Tsplit("Sinh", 				"36L"), 	// (boneout)
				Tsplit("Gank Squad", 		"37L"), 	// (boneout)
				Tsplit("Aava", 				"38N 59S"), // (big door)
				Tsplit("Burnt Ivory King", 	"39L"), 	// (boneout)
				Tsplit("Lud and Zallen", 	"40L"), 	// (boneout)
				Tsplit("Chariot", 			"41L"), 	// (boneout)
				Tsplit("Dungeon: Woods", 	""), 		// TODO Dungeon Woods boneout
				Tsplit("Dungeon: Gulch", 	""), 		// TODO Dungeon Gulch boneout
				Tsplit("Darklurker", 		"42L"), 	// (boneout)
				Tsplit("Aldia", 			"43N 44C"), // (cutscene screen after Aldia)	
			}
		)
	);
	
	
	//new string[] {"50n", "64i", "63l", "52n", "53l", "04l", "51n", "50i", "05n", "06l", "07l", "08l", "24i", "25n", "48i", "26n", "49i", "27l", "28n", "47i", "45l", "30l", "54n"},	//SOTFS 17k Partywalk
	//{"sotfs_17kPW", "Any% (17k Partywalk)", " -Pursuer\n -Fragrant branch\n -Aslatiel door\n Guardian elevator\n -Ashen Mist\n -Giant Lord\n"},
	// sotfs_Any% (Parrywalk, 17k Rapier)
	vars.routes.Add(
		Tuple.Create("sotfs_17k_PW", "Any% (Parrywalk, 17k Rapier)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Pursuer 17k", 		"50N 64S"), // (warp)
				Tsplit("Branch", 			""), 		// (boneout) TODO Giant Lord Branch
				Tsplit("Aldia's skip", 		""), 		// (door) TODO door position
				Tsplit("Guardian Elevator", "47S"), 	// (elevator)
				Tsplit("Ashen Mist Heart", 	"45L"), 	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (boneout)
				Tsplit("Nashandra", 		"43N 44C"), // (black screen after Nash)
			}
		)
	);
	
	
	// build separate objects from above user definition
	vars.Nroutes = vars.routes.Count;
	vars.route_uids = new List<string>();
	vars.route_names = new List<string>();
	vars.all_route_splits = new List<List<Tuple<string, string>>>();
	
	//print(vars.Nroutes.ToString());
	
	for (int i = 0; i < vars.Nroutes; i++){
		var route = vars.routes[i];
		//print(route.Item1);
		vars.route_uids.Add(route.Item1);
		vars.route_names.Add(route.Item2);
		vars.all_route_splits.Add(route.Item3);
	}	
	
	// Setup livesplit settings (aka route selector)
	settings.Add("rt", true, "Route");
	settings.Add("vanilla", true, "Dark Souls II", "rt");
	settings.Add("scholar", true, "Scholar of the First Sin", "rt");
	
	for (int i = 0; i < vars.Nroutes; i++) {
		string route_uid = vars.route_uids[i];
		string route_name = vars.route_names[i];
		if (route_uid.Contains("sotfs")) {
			settings.Add(route_uid, false, route_name, "scholar");
		} else {
			settings.Add(route_uid, false, route_name, "vanilla");
		}
		
		// build tooltip for route:
		//List<Tuple<string, string>> route_splits = vars.all_route_splits[i];
		//string route_tooltip = "Feel free to add manual splits at your own leisure.\nThis route has the following autosplits:\n" ;//+ vars.route_splits.Join("\n");
		//settings.SetToolTip(route_uid, route_tooltip);
	}
	
	settings.Add("ffleret", false, "Split on every loading screen");
	settings.SetToolTip("ffleret", "This setting will only work if no route is selected.");
	
	//additional variables used for keeping track of split order
	vars.doneSplits = 0;
	vars.category = 50;
	vars.wait_for_load = false;
	vars.wait_for_cutscene = false;
	
	vars.route_index = 1; // testing
	vars.doneSubsplits = 0;
	vars.doneSplits = 0;
	vars.bSubsplitComplete = false;
	vars.wait_for_cutscene = false;
	vars.wait_for_load = false;
	vars.first_update = true;
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
		
		// get selected route
		for (int i = 0; i < vars.Nroutes; i++){
			if (settings[vars.route_names[i]]){
				vars.route_index = i; // selected route index in Livesplit settings list
				break;
			}
		}
		
		/*
		vars.route_index = 0;
		while (vars.route_index < vars.cat.GetLength(0) && !settings[vars.cat[vars.category, 0]]) {
			vars.category++;
		}
		//print("CATEGORY: " + vars.category.ToString());
		*/
		vars.doneSubsplits = 0;
		vars.doneSplits = 0;
		vars.bSubsplitComplete = false;
		vars.wait_for_cutscene = false;
		vars.wait_for_load = false;
		vars.first_update = true;
		
		//print(vars.route_index);
		
		
		vars.split_type = "S"; // random type initialiser
		
		print("test");
		return true;
	}
}

split {
	
	Action<int, int> updateActiveSplit = (split_index, subsplit_index) => {
		vars.route_splits = vars.all_route_splits[vars.route_index];
		var thisTsplit = vars.route_splits[split_index];
		string[] split_tokens = thisTsplit.Item2.Split(' ');
		string token = split_tokens[subsplit_index];
		
		
		//print(token);
		
		// can't load Regex namespace it seems
		int cond_id = int.Parse(String.Join("", token.Where(Char.IsDigit)));
		string split_type = String.Join("", token.Where(Char.IsLetter));
		vars.split_type = split_type.ToUpper();
		
		// Tuple<float, float, float, float, float, float, int> splitcond = null;
		vars.splitcond = vars.split_conditions[cond_id];
		vars.split_token_count = split_tokens.Length;
		
	};
	
	print("testing");
	
	if (vars.route_index < vars.Nroutes) {
		
		if (vars.first_update){
			vars.first_update = false;
			updateActiveSplit(vars.doneSplits, vars.doneSubsplits);
		}
		
		if (vars.debug_output)
		{
			//updateActiveSplit(vars.doneSplits,vars.doneSubsplits);
			print("Curr PosX:  " + current.xPos.ToString());
			print("Curr PosY:  " + current.yPos.ToString());
			print("Curr PosZ:  " + current.zPos.ToString());
			print("Souls: " + current.souls.ToString());
			print("Req MinPosX:  " + vars.splitcond.Item1.ToString());
			print("Req MaxPosx:  " + vars.splitcond.Item2.ToString());
			print("Req MinPosY:  " + vars.splitcond.Item3.ToString());
			print("Req MaxPosY:  " + vars.splitcond.Item4.ToString());
			print("Req MinPosZ:  " + vars.splitcond.Item5.ToString());
			print("Req MinPosZ:  " + vars.splitcond.Item6.ToString());
			print("Required Souls: " + vars.splitcond.Item7.ToString());
			print("Old Souls:  " + old.souls.ToString());
			print("booltest 1 complete");
		}
		
		// check whether conditions are met for split
		if (current.xPos >= vars.splitcond.Item1 && current.xPos <= vars.splitcond.Item2 &&
		current.yPos >= vars.splitcond.Item3 && current.yPos <= vars.splitcond.Item4 &&
		current.zPos >= vars.splitcond.Item5 && current.zPos <= vars.splitcond.Item6 &&
		current.souls >= old.souls + vars.splitcond.Item7 && current.souls <= old.souls + (vars.splitcond.Item7 * 1.69)) {
			string local_type = vars.split_type;
			switch (local_type)
			{
				case null:
				case "S":
				case "N":
					vars.bSubsplitComplete = true;
					break;
				case "L":
					vars.wait_for_load = true;
					break;
				case "C":
					vars.wait_for_cutscene = true;
					break;
			}
		}
		
		// check for load screen
		if (current.load == old.load + 1 && vars.wait_for_load == true) {
			vars.bSubsplitComplete = true;
			vars.wait_for_load = false;
		}
		
		// check for cutscene:
		if (current.state == old.state + 1 && vars.wait_for_cutscene == true) {
			vars.bSubsplitComplete = true;
			vars.wait_for_cutscene = false;
		}
		
		// Update tokens for next split/subsplit
		if (vars.bSubsplitComplete){
			vars.doneSubsplits++;
			
			// check for completed split
			if (vars.doneSubsplits == vars.split_token_count){
				vars.doneSplits++;
				vars.doneSubsplits = 0;
			}
			
			// Reset things for next split
			updateActiveSplit(vars.doneSplits, vars.doneSubsplits);
			vars.bSubsplitComplete = false;
			return true;
		}
		
	} else {
		if (settings["ffleret"]) {
			return current.load == old.load + 1;
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
