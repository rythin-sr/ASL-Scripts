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
	// NB: This is really:
	// y_min, y_max, z_min, z_max, x_min, x_max, souls if you are looking at the CE / META xyz position coordinates.
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
		tB(5, 8, -7, -4, 276, 280, 0),                //46, Heide's Tower of Flame bonfire
		tB(-846, -843, 79, 86, -252, -248, 0),        //47, elevator after Guardian Dragon
		tB(-684, -680, 102, 110, -344, -340, 0),      //48, Mirror Knight elevator
		tB(-1038, -1035, -30, -25, -88, -86, 0),      //49, Door after Demon of Song
		tB(78, 82, 1, 2, -185, -181, 0),              //50, Melentia bonfire
		tB(-39, -33, 20, 23, 101, 107, 0),            //51, last Ascetic pickup in DLC1
		tB(-354, -348, 42, 44, -216, -210, 0),        //52, RTSR
		tB(-334, -325, 32, 33, -163, -157, 0),        //53, Ruined Fork Road bonfire
		tB(21, -37, 0, 0, 0, 0, 0),                   //54, (impossible condition for autosplitter error prevention)
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
		tB(38,64,1.6f,-9,-225,-244,16998),			  //66, Pursuer, Lucida 17k
		tB(-255,-247.8f,-229,-228,-158.8f,-147.6f,0), //67, DLC1 Entrance Portal
		tB(-677,-666,157,158,-660,-666,0),  		  //68, DLC2 Entrance Portal
		tB(-210.3f,-206,46,47,-214.3f,-204,0), 	      //69, DLC3 Entrance Portal
		tB(-197,-192,-221,-220,-114,-107,0),          //70, Dungeon: Gulch Portal
		tB(-460,-448,57,59,-220,-210,0),           	  //71, Dungeon: Woods Portal
		tB(-450,-442,65,66,-329,-320,0),           	  //72, Dungeon: Drangleic Portal
		tB(-431,-426,61,62,-184,-177,0),           	  //73, Shaded Ruins bonfire
		tB(-249,-242,28,29,38,45,0),           	  	  //74, Bridge Approach bonfire
		tB(-146,-139,-7,-6,-35,-28,0),           	  //75, Flynns ring room
		tB(-125,-123,100,101,384,389,0),           	  //76, DLC2 Chunks/Butterly pickup
		tB(34,54,-34.5f,-24,-213,-190,0),             //77, Vammar 20k
		tB(-650,-641,125,126,-37,-44,0),           	  //78, Tseldora ascetic
		tB(-119,-113,14,15,591,593,0),           	  //79, Bastille ascetic
		tB(-6, -4, -275, -224,-744, -700,0),    	  //80, Aldia / 0 souls finish
		tB(-488,-486.5f,58,59,-251,-247,0),           //81, Aldia's Keep Aslatiel door
		tB(25,31,-22,-21,-180,-175,0),                //82, Giant Lord Fragrant branch
		tB(156,160,12,13,-150,-146,0),                //83, Pursuer nest
		tB(-970,-960,-138,-137,-10,-5,0),             //84, King's ring
		tB(7,21,-6.5f,-5.8f,273,290,0),           	  //85, Licia / Tower of Flame bonfire
		tB(-125,-118,-81,-80,480,488,0),           	  //86, Sinner primal bonfire
		tB(-497,-467,70,71,-86,-57,0),				  //87, Freja primal bonfire
		tB(-584,-580,165,166,592,595,0),			  //88, Threshold Bridge bonfire
		tB(-481,-473,48,49,321,328,0),			  	  //89, Poison pool bonfire
		tB(119,125,-25.5f,-24.9f,-205,-201,0),	  	  //90, Memory of Orro exit
		tB(-563,-557,96,99,-220,-210,0),	  	  	  //91, Gyrm's respite bonfire
		tB(-717,-669,135,139,-161,-119,0),	  	  	  //92, Tseldora campsite bonfire [covers both vanilla/sotfs]
		tB(-538,-533,125,126,-333,-327,0),	  	  	  //93, Caitha's chime
		tB(-43,-37,-35,-34,-6,5,0), 			  	  //94, DLC1 key
		tB(-469,-462,72,73,-374,-368,0), 			  //95, King's gate bonfire
		tB(-91,-84,-2,1,597,606,0), 			  	  //96, Mcduff bonfire
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
		Tuple.Create("any", "Any%"), 
			new List<Tuple<string,string>>
			{
				Tsplit("Branch Skiop",  "53S"), 		// (bonfire light)
				Tsplit("Aldia's door", 	"81S"), 		// (door)
				Tsplit("Ashen Mist", 	"45L"), 		// (boneout)
				Tsplit("Giant Lord", 	"30L"), 		// (boneout)
				Tsplit("Nashandra", 	"44C"), 		// (black screen after Nash)
			}
		)
	);
	
	// Any% CP (17k, 5 Rotten)
	vars.routes.Add(
		Tuple.Create("17k_5r", "Any% CP (5 Rotten, 17k)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Pursuer", 			"50N 64S"), // (majula warp)
				Tsplit("Rotten 1", 			"04N 67L"), // (DLC1 portal)
				Tsplit("DLC1 Runthrough", 	"51S"), 	// (ascetic boneout)
				Tsplit("RTSR", 				"52N 53L"), // (warp after RTSR)
				Tsplit("Rotten 2 + 3", 		"05N 06L"), // (Rotten 3 boneout)
				Tsplit("Rotten 4", 			"07L"), 	// (boneout)
				Tsplit("Rotten 5", 			"08L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27N 84L"), // (King's ring boneout)
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
				Tsplit("Last Giant", 		"00L"),  	// (boneout)
				Tsplit("Pursuer", 			"01N 83L"), // (nest)
				Tsplit("Rotten 1", 			"04N 67L"), // (DLC1 portal)
				Tsplit("DLC1 Runthrough", 	"75L"), 	// (FLynns boneout)
				Tsplit("RTSR", 				"52L"), 	// (RTSR boneout)
				Tsplit("Sentinels", 		"16N 79L"), // (Bastille ascetic boneout)
				Tsplit("Rotten 2 + 3", 		"05N 06L"), // (Rotten 3 boneout)
				Tsplit("Rotten 4", 			"07L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27N 84L"), // (King's ring boneout)
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
				Tsplit("Last Giant", 		"00L"),  	// (boneout)
				Tsplit("Rotten 1", 			"04N 67L"), // (DLC1 portal)
				Tsplit("DLC1 Runthrough", 	"51S"), 	// (ascetic boneout)
				Tsplit("RTSR", 				"52L"), 	// (RTSR boneout)
				Tsplit("Rotten 2 + 3", 		"05N 06L"), // (Rotten 3 boneout)
				Tsplit("Rotten 4", 			"07L"), 	// (boneout)
				Tsplit("Rotten 5", 			"08L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27N 84L"), // (King's ring boneout)
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
				Tsplit("Rotten 1", 			"04N 67L"), // (DLC1 portal)
				Tsplit("DLC1 Runthrough", 	"51S"), 	// (ascetic boneout)
				Tsplit("RTSR", 				"52L"), 	// (RTSR boneout)
				Tsplit("Rotten 2 + 3", 		"05N 06L"), // (Rotten 3 boneout)
				Tsplit("Rotten 4", 			"07L"), 	// (boneout)
				Tsplit("Rotten 5", 			"08L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27N 84L"), // (King's ring boneout)
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
				Tsplit("Last Giant",		"00L"), 	// (boneout)
				Tsplit("Pursuer", 			"01N 83L"), // (nest)
				Tsplit("Dragonrider", 		"03N 85L"), // (Licia boneout)	
				Tsplit("Rotten", 			"04L"), 	// (boneout)
				Tsplit("Skeleton Lords", 	"11N 55S"), // (lever)
				Tsplit("Covetous", 			"12S"), 	// (kill)
				Tsplit("Mytha", 			"13N 56S"), // (elevator)
				Tsplit("Old Iron King", 	"15L"), 	// (boneout)
				Tsplit("Sentinels", 		"16S"), 	// (kill)
				Tsplit("Sinner", 			"18L"), 	// (boneout)
				Tsplit("Najka", 			"19S"), 	// (kill)
				Tsplit("Congregation", 		"21S"), 	// (kill)
				Tsplit("Freja", 			"22L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door to crypt elevator)
				Tsplit("Velstadt", 			"27N 84L"), // (King's ring boneout)
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ashen Mist", 		"45L"), 	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (boneout)
				Tsplit("Nashandra", 		"43N 44C"), // (black screen after Nash)
			}
		)
	);
	
	// All Bosses, Dark rapier/Lightning RITB: Restricted
	vars.routes.Add(
		Tuple.Create("AB", "All Bosses (Restricted, Dark Rapier/Lightning RITB)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Last Giant",		"00L"), 	// (boneout)
				Tsplit("Pursuer", 			"01N 83L"), // (nest)
				Tsplit("Dragonrider", 		"03N 85L"), // (warp after Licia)	
				Tsplit("Rotten 1", 			"04N 67L"), // (DLC1 portal)
				Tsplit("DLC1 Runthrough", 	"60L"), 	// (Dragon Stone bonfire)
				Tsplit("Dragonslayer", 		"09L"), 	// (boneout)
				Tsplit("Flexile", 			"10L"), 	// (boneout)
				Tsplit("Skeleton Lords", 	"11N 55S"), // (lever)
				Tsplit("Covetous", 			"12S"),		// (kill)
				Tsplit("Mytha", 			"13N 56S"), // (elevator)
				Tsplit("Smelter Demon",		"14N 57S"), // (door)
				Tsplit("Old Iron King", 	"15N 68L"), // (DLC2 portal)
				Tsplit("DLC2 Runthrough", 	"76L"), 	// (chunks boneout)
				Tsplit("Sentinels", 		"16S"), 	// (kill)
				Tsplit("Gargoyles", 		"17L"), 	// (boneout)
				Tsplit("Sinner", 			"18N 86L"), // (primal)
				Tsplit("Najka", 			"19S"), 	// (kill)
				Tsplit("Authority", 		"20S"), 	// (kill)
				Tsplit("Congregation", 		"21S"), 	// (kill)
				Tsplit("Freja", 			"22N 87L"),	// (boneout at primal)
				Tsplit("Vanguard", 			"23L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27N 84L"), // (King's ring boneout)
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ancient", 			"29L"),  	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (ASSUMED Soul of a Giant - not explicit)
				Tsplit("Fume Knight", 		"31L"),		// (boneout)
				Tsplit("Blue Smelter", 		"32L"), 	// (boneout)
				Tsplit("Sir Alonne", 		"33L"), 	// (boneout)
				Tsplit("Gulch Giants", 		"63N 70L"), // (Grandahl boneout)
				Tsplit("Vendrick", 			"34L"), 	// (boneout)
				Tsplit("Elana", 			"35S"), 	// (kill)
				Tsplit("Sinh", 				"36L"), 	// (boneout)
				Tsplit("Gank Squad", 		"37L"), 	// (boneout)
				Tsplit("Aava", 				"38N 59S"), // (big door)
				Tsplit("Burnt Ivory King", 	"39L"), 	// (boneout)
				Tsplit("Lud and Zallen", 	"40L"), 	// (boneout)
				Tsplit("Chariot", 			"41L"), 	// (boneout)
				Tsplit("Dungeon: Woods", 	"71L"), 	// (boneout after dungeon)
				Tsplit("Dungeon: Gulch", 	"70L"), 	// (boneout after dungeon)
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
				Tsplit("Shaded Ruins",		"73L"), 	// (warp)
				Tsplit("Licia",				"03N 85L"), // (warp after Licia)
				Tsplit("Pursuer QK",		"50N 64S"), // (warp)
				Tsplit("Bridge Approach",	"74L"), 	// (warp at Bridge Approach)
				Tsplit("Skeleton Lords", 	"11N 55S"), // (lever)
				Tsplit("Vanguard",			"23S"), 	// (kill)
				Tsplit("Gulch Giants", 		"63N 70L"), // (Grandahl boneout)
				Tsplit("Grandahl Drangleic","72L"), 	// (Grandahl boneout)
				Tsplit("Dragonriders",		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27N 84L"), // (King's ring boneout)
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ancient",			"29L"), 	// (boneout)
				Tsplit("Chariot", 			"41L"), 	// (boneout)
				Tsplit("Covetous",			"12S"), 	// (kill)
				Tsplit("Mytha", 			"13N 56S"), // (elevator)
				Tsplit("Smelter Demon",		"14S"), 	// (kill)
				Tsplit("Old Iron King",		"15L"), 	// (boneout)
				Tsplit("Last Giant",		"00L"), 	// (boneout)
				Tsplit("GL & Memories", 	"30N 90L"), // (memory of Orro exit)
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
				Tsplit("Shaded Ruins",		"73L"), 	// (warp)
				Tsplit("Guardian Elevator", "47S"), 	// (elevator)
				Tsplit("Ashen Mist", 		"45L"), 	// (boneout)
				Tsplit("Vammar Memory 20k", "77L"), 	// (near 20k pickup boneout)
				Tsplit("Dragonrider skip", 	"85L"),		// (bonfire boneback)		
				Tsplit("Bridge Approach", 	"74S"), 	// (bonfire light)
				Tsplit("Poison Pool", 		"89L"), 	// (warp)
				Tsplit("Najka Skip", 		"91L"), 	// (bonfire boneback)
				Tsplit("Tseldora campsite", "92L"), 	// (warp) TODO Tseldora bonfire
				Tsplit("Caitha's Chime", 	"93L"), 	// (Caitha's boneout) [might be too small]
				Tsplit("Mirror Knight skip","48S"), 	// (elevator)
				Tsplit("Frog Skip", 		"49S"), 	// (door)
				Tsplit("King's ring", 		"84L"), 	// (boneout) [check position is correct from OOB]
				Tsplit("Gulch Giants", 		"63N 70L"), // (Grandahl boneout) 	
				Tsplit("Throne Duo", 		"43L"), 	// (boneout)
				Tsplit("Pursuer skip v2", 	"30N 83L"), // (nest)
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
				Tsplit("Mytha skip", 		"88S"), 	// (bonfire light)
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
				//Tsplit("Pursuer QK", 		"??"), 		// (rest) TODO PQK properly!
				Tsplit("Last Giant",		"00L"), 	// (boneout)
				Tsplit("Finish", 			"80C"), 	// (final cutscene)
			}
		)
	);
	////////////////////////////////////////
	////		   SOTFS ROUTES 		 ////
	////////////////////////////////////////
	
	// sotfs_Any% (Restricted, 17k)
	vars.routes.Add(
		Tuple.Create("sotfs_17k", "Any% (Restricted, 17k)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Pursuer 17k", 		"50N 64S"), // (warp)
				Tsplit("Gulch Giants", 		"63L"), 	// (Giants boneout)
				Tsplit("Majula + RTSR", 	"52N 53L"), // (warp after RTSR)
				Tsplit("Rotten 1", 			"04N 67L"), // (DLC1 portal)
				Tsplit("DLC 1 runthrough", 	"51N 50S"), // (warp after ascetics)
				Tsplit("Melentia + Level", 	"50N 64L"), // (warp after level)
				Tsplit("Rotten 2 + 3", 		"05N 06L"), // (Rotten 3 boneout)
				Tsplit("Rotten 4", 			"07L"), 	// (boneout)
				Tsplit("Rotten 5", 			"08L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27N 84L"), // (King's ring boneout)
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ashen Mist", 		"45L"), 	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (boneout)
				Tsplit("Nashandra", 		"43N 44C"), // (black screen after Nash)
			}
		)
	);
	
	// sotfs_Any% (Restricted, 4 Rotten)
	vars.routes.Add(
		Tuple.Create("sotfs_4r", "Any% (Restricted, 4 Rotten)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Last Giant", 		"00L"), 	// (boneout)
				Tsplit("Pursuer", 			"01N 83L"), // (nest)
				Tsplit("Rotten 1", 			"04L"), 	// (boneout)
				Tsplit("Najka", 			"19S"), 	// (kill)
				Tsplit("Congregation", 		"21N 78L"), // (Tseldora ascetic boneout)
				Tsplit("Sentinels", 		"16N 79L"), // (Bastille ascetic boneout)
				Tsplit("Rotten 2", 			"05L"), 	// (boneout)
				Tsplit("Rotten 3", 			"06L"), 	// (boneout)
				Tsplit("Rotten 4", 			"07L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27N 84L"), // (King's ring boneout)
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ashen Mist", 		"45L"), 	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (boneout)
				Tsplit("Nashandra", 		"43N 44C"), // (black screen after Nash)
			}
		)
	);
	
	// sotfs_Old Souls (Restricted, Bandit start)
	vars.routes.Add(
		Tuple.Create("sotfs_OS", "Old Souls (Restricted, Bandit start)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Last Giant", 		"00L"), 	// (boneout)
				Tsplit("Pursuer", 			"01N 83L"), // (nest)
				Tsplit("Dragonrider", 		"03N 85L"), // (Licia boneout)
				Tsplit("Rotten 1", 			"04L"), 	// (boneout)
				Tsplit("Felkin", 			"65L"),		// (warp)
				Tsplit("Najka", 			"19S"), 	// (kill)
				Tsplit("Congregation", 		"21S"), 	// (kill)
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
				Tsplit("Velstadt", 			"27N 84L"), // (King's ring boneout)
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ashen Mist", 		"45L"), 	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (boneout)
				Tsplit("Nashandra", 		"43N 44C"), // (black screen after Nash)
			}
		)
	);
	
	// sotfs_All Bosses (Restricted, Rapier/Twinblade)
	vars.routes.Add(
		Tuple.Create("sotfs_AB", "All Bosses (Restricted, Rapier/Twinblade)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Last Giant", 		"00L"), 	// (boneout)
				Tsplit("Pursuer", 			"01N 83L"), // (nest)
				Tsplit("Dragonrider", 		"03N 85L"), // (warp after Licia)
				Tsplit("Rotten", 			"04L"), 	// (boneout)
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
				Tsplit("Freja", 			"22N 87L"),	// (boneout at primal)
				Tsplit("Sentinels", 		"16S"), 	// (kill)
				Tsplit("Gargoyles", 		"17L"), 	// (boneout)
				Tsplit("Sinner", 			"18N 86L"), // (primal)
				Tsplit("DLC2 Key", 			"62L"), 	// (boneout)
				Tsplit("Mytha", 			"13N 56S"), // (elevator)
				Tsplit("Smelter Demon", 	"14N 57S"), // (door)
				Tsplit("Old Iron King", 	"15N 68L"), // (DLC2 portal)
				Tsplit("DLC2 runthrough", 	"61L"), 	// (sceptre boneout)
				Tsplit("Fume Knight", 		"31L"), 	// (boneout)
				Tsplit("Blue Smelter", 		"32L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27N 84L"), // (King's ring boneout)
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
				Tsplit("Dungeon: Woods", 	"71L"), 	// (boneout after dungeon)
				Tsplit("Dungeon: Gulch", 	"70L"), 	// (boneout after dungeon)
				Tsplit("Darklurker", 		"42L"), 	// (boneout)
				Tsplit("Aldia", 			"43N 44C"), // (cutscene screen after Aldia)	
			}
		)
	);
	
	// sotfs_All Bosses (Unrestricted, Rapier/Twinblade)
	vars.routes.Add(
		Tuple.Create("sotfs_AB_PW", "All Bosses (Unrestricted, Rapier/Twinblade)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Last Giant", 		"00L"), 	// (boneout)
				Tsplit("Pursuer", 			"01N 83L"), // (nest)
				Tsplit("Dragonrider", 		"03N 85L"), // (warp)
				Tsplit("Gulch Giants", 		"63L"), 	// (quitout hopefully)
				Tsplit("DLC1 key/Gandalf", 	"94L 70L"), // (Grandahl boneout) 
				Tsplit("Rotten", 			"04S 67L"),	// (DLC1 entrance)
				Tsplit("Flynn's ring", 		"75L"), 	// (boneout)
				Tsplit("King's gate", 		"95L"), 	// (warp)
				Tsplit("Dragonslayer", 		"09L"), 	// (boneout)
				Tsplit("Flexile", 			"10L"), 	// (boneout)
				Tsplit("Skeleton Lords", 	"11N 55S"), // (lever)
				Tsplit("Covetous", 			"12S"), 	// (kill)
				Tsplit("Najka", 			"19S"), 	// (kill)
				Tsplit("Authority", 		"20S"), 	// (kill)
				Tsplit("Congregation", 		"21S"), 	// (kill)
				Tsplit("Freja", 			"22N 87L"),	// (boneout at primal)
				Tsplit("Vanguard", 			"23L"), 	// (boneout)			
				Tsplit("Sentinels", 		"16S"), 	// (kill)
				Tsplit("Sinner", 			"18N 86L"), // (primal)
				Tsplit("Aldia's skip", 		"81S"), 	// (Aslatiel door)
				Tsplit("Guardian", 			"28N 47S"), // (elevator)
				Tsplit("Ancient", 			"29L"), 	// (boneout)
				Tsplit("Giant Lord", 		"30L"), 	// (boneout) ASSUMED GIANT SOUL
				Tsplit("Mytha", 			"13N 56S"), // (elevator)
				Tsplit("Smelter Demon", 	"14S"), 	// (kill)
				Tsplit("Old Iron King", 	"15N 68L"), // (DLC2 portal)
				Tsplit("Fume Knight", 		"31S"), 	// (kill)
				Tsplit("Blue Smelter", 		"32L"), 	// (boneout)
				Tsplit("Sir Alonne", 		"33L"), 	// (boneout)
				Tsplit("Dragonriders", 		"24S"), 	// (kill)
				Tsplit("Mirror Knight", 	"25N 48S"), // (elevator)
				Tsplit("Demon of Song", 	"26N 49S"), // (door)
				Tsplit("Velstadt", 			"27S"), 	// (kill)
				Tsplit("Vendrick", 			"34L"), 	// (boneout)
				Tsplit("Levels/Upgrades",   "96L"), 	// (warp)
				Tsplit("Gank Squad", 		"37L"), 	// (boneout)
				Tsplit("Elana", 			"35S"), 	// (kill)
				Tsplit("Sinh", 				"36L"), 	// (boneout)
				Tsplit("Aava", 				"38N 59S"), // (big door)
				Tsplit("Burnt Ivory King", 	"39L"), 	// (boneout)
				Tsplit("Lud and Zallen", 	"40L"), 	// (boneout)
				Tsplit("Chariot", 			"41L"), 	// (boneout)
				Tsplit("Gargoyles", 		"17L"), 	// (boneout)
				Tsplit("Dungeon: Woods", 	"71L"), 	// (boneout after dungeon)
				Tsplit("Dungeon: Gulch", 	"70L"), 	// (boneout after dungeon)
				Tsplit("Darklurker", 		"42L"), 	// (boneout)
				Tsplit("Aldia", 			"43N 44C"), // (cutscene screen after Aldia)
			}
		)
	);
	
	// sotfs_Any% (Unrestricted, Rapier 17k)
	vars.routes.Add(
		Tuple.Create("sotfs_17k_PW", "Any% (Unrestricted, Rapier 17k)", 
			new List<Tuple<string,string>>
			{
				Tsplit("Pursuer 17k", 		"50N 64S"), // (warp)
				Tsplit("Branch", 			"82L"), 	// (Branch boneout)
				Tsplit("Aldia's skip", 		"81S"), 	// (Aslatiel door)
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
	
	
	for (int i = 0; i < vars.Nroutes; i++){
		var route = vars.routes[i];
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
			if (settings[vars.route_uids[i]]){
				vars.route_index = i; // selected route index in Livesplit settings list
				break;
			}
		}
		
		vars.doneSubsplits = 0;
		vars.doneSplits = 0;
		vars.bSubsplitComplete = false;
		vars.wait_for_cutscene = false;
		vars.wait_for_load = false;
		vars.first_update = true;
		vars.split_type = "S"; // type initialiser
		return true;
	}
}

split {
	
	Action<int, int> updateActiveSplit = (split_index, subsplit_index) => {
		vars.route_splits = vars.all_route_splits[vars.route_index];
		var thisTsplit = vars.route_splits[split_index];
		string[] split_tokens = thisTsplit.Item2.Split(' ');		
		string token = split_tokens[subsplit_index];
				
		// can't load Regex namespace it seems
		int cond_id = int.Parse(String.Join("", token.Where(Char.IsDigit)));
		string split_type = String.Join("", token.Where(Char.IsLetter));
		vars.split_type = split_type.ToUpper();
		
		// Tuple<float, float, float, float, float, float, int> splitcond = null;
		vars.splitcond = vars.split_conditions[cond_id];
		vars.split_token_count = split_tokens.Length;
		
		if (vars.debug_output)
		{
			print("token use: " + token.ToString());
			print("split_cond: " + vars.splitcond);
			print("split_type: " + split_type);
		}
		
	};
	
		
	if (vars.route_index < vars.Nroutes) {
		
		bool splitbool;
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
			vars.bSubsplitComplete = false; // for next check
			
			// check for completed split
			if (vars.doneSubsplits == vars.split_token_count){
				vars.doneSplits++;
				vars.doneSubsplits = 0;
				splitbool = true;
			} else 
			{
				splitbool = false;
			}
			
			// Reset things for next split
			updateActiveSplit(vars.doneSplits, vars.doneSubsplits);
			return splitbool;
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
