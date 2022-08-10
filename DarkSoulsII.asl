//Dark Souls II Autosplitter + Load Remover
//huge thank you to Dread for the original load remover,
//as well as pseudostripy for help finding correct coordinates, Ero for helping with the code
//Nyk for helping with SotFS routes

// [pseudo]: Shuffled state xyz to match CE/META position coordinates
state("DarkSoulsII", "1.11") {
	float xPos:	0x114A5B4, 0x8, 0x88, 0x14;
	float yPos:	0x114A5B4, 0x8, 0x88, 0xC;
	float zPos:	0x114A5B4, 0x8, 0x88, 0x10;
	int state:	0x11493F4, 0x74, 0xB8, 0x2D4;      //1 in cutscenes and backstabs/ripostes (lol), 2 when falling, 0 otherwise
	int souls:	0x11493F4, 0x74, 0x2EC, 0x238;		
	int load: 	0x118E8E0, 0x1D4;                  //1 in loads
}

state("DarkSoulsII", "1.02") {
	float xPos:	0xFB4F74, 0x8, 0xC4;				
	float yPos:	0xFB4F74, 0x8, 0xBC;				
	float zPos:	0xFB4F74, 0x8, 0xC0;		
	int state:	0xFB3E3C, 0x74, 0xB8, 0x2D4;		
	int souls:	0xFB3E3C, 0x74, 0x2EC, 0x238;		
	int load: 	0xFF9298, 0x1D4;
}

state("DarkSoulsII", "Scholar of the First Sin") {
	float xPos:	0x160DCD8, 0x8, 0x5D8;				
	float yPos:	0x160DCD8, 0x8, 0x5D0;				
	float zPos:	0x160DCD8, 0x8, 0x5D4;	
	int state:	0x160B8D0, 0xD0, 0x100, 0x304;		
	int souls:	0x160B8D0, 0xD0, 0x380, 0x21C;		
	int load: 	0x186CCB0, 0x11C;
}

startup {
	vars.debug_output = false;
	
		
	// Utility functions:
	Func<float, float, float, Vector3f> v3f = (x,y,z) => new Vector3f(x,y,z);
	// Func<float, float, float, Vector3f> v3fYZX = (y,z,x) => new Vector3f(x,y,z); // Backwards compatibility (deprecated)
	
	Func<float, float, float, bool> isBetween = (val, min, max) => (val >= min) && (val <= max);
	Func<Vector3f, Vector3f, Vector3f, bool> isVecBetween = (vpos, vmin, vmax) => ( isBetween(vpos.X, vmin.X, vmax.X) && isBetween(vpos.Y, vmin.Y, vmax.Y) && isBetween(vpos.Z, vmin.Z, vmax.Z) ); 
	
	// save across calls
	vars.isBetween = isBetween;
	vars.isVecBetween = isVecBetween;
	vars.v3f = v3f;
	
	// System.Tuple cannot have named parameters :(
	Func<Vector3f, Vector3f, float, Tuple<Vector3f, Vector3f, float>> SC = (min, max, souls) => Tuple.Create(min, max, souls);
	
	// Define split conditions in this array, and reference the ID when creating new split lists.	
	// set soul count to 0 for non-boss areas
	//
	// Anon type defines:
	//	 minimum/maximum coordinates as XYZ order (matching CE/META), & number of souls to trigger split
	var def_splitconds = new[]
	{
		new {MinPos = v3f(-143, 86, -41),		MaxPos = v3f(-112, 113, -39),	Souls = 10000},  	//00, Last Giant
		new {MinPos = v3f(-220, 130, 9),		MaxPos = v3f(-175, 145, 11),	Souls = 17000},  	//01, Pursuer, normal kill
		new {MinPos = v3f(-185, 78, 1),			MaxPos = v3f(-181, 82, 2),		Souls = 16900},  	//02, Pursuer, 17k
		new {MinPos = v3f(275, -7, -15),		MaxPos = v3f(290, 22, -14),		Souls = 12000},  	//03, Dragonrider
		new {MinPos = v3f(-128, -285, -228),	MaxPos = v3f(-93, -240, -225),	Souls = 47000},  	//04, Rotten NG
		new {MinPos = v3f(-128, -285, -228),	MaxPos = v3f(-93, -240, -225),	Souls = 94000},  	//05, Rotten NG+
		new {MinPos = v3f(-128, -285, -228),	MaxPos = v3f(-93, -240, -225),	Souls = 117500}, 	//06, Rotten NG+2
		new {MinPos = v3f(-128, -285, -228),	MaxPos = v3f(-93, -240, -225),	Souls = 129250}, 	//07, Rotten NG+3
		new {MinPos = v3f(-128, -285, -228),	MaxPos = v3f(-93, -240, -225),	Souls = 141000}, 	//08, Rotten NG+4
		new {MinPos = v3f(144, -184, 7),		MaxPos = v3f(185, -144, 9),		Souls = 20000},  	//09, Dragonslayer
		new {MinPos = v3f(518, 1, -72),			MaxPos = v3f(532, 23, -71),		Souls = 14000},  	//10, Flexile
		new {MinPos = v3f(226, -435, 36),		MaxPos = v3f(267, -393, 40),	Souls = 15000},  	//11, Skeleton Lords
		new {MinPos = v3f(530, -550, 52),		MaxPos = v3f(558, -520, 54),	Souls = 13000},  	//12, Covetous Demon
		new {MinPos = v3f(534, -576, 85),		MaxPos = v3f(565, -548, 87),	Souls = 20000},  	//13, Mytha 
		new {MinPos = v3f(645, -731, 176),		MaxPos = v3f(667, -706, 177),	Souls = 32000},  	//14, Smelter Demon (Red)
		new {MinPos = v3f(710, -658, 166),		MaxPos = v3f(730, -622, 167),	Souls = 48000},  	//15, Old Iron King
		new {MinPos = v3f(531, -170, -1),		MaxPos = v3f(564, -144, 12),	Souls = 33000},  	//16, Sentinels
		new {MinPos = v3f(498, -227, 12),		MaxPos = v3f(524, -187, 15),	Souls = 25000},  	//17, Gargoyles
		new {MinPos = v3f(518, -136, -78),		MaxPos = v3f(553, -110, -76),	Souls = 45000},  	//18, Sinner
		new {MinPos = v3f(-325, -472, 83),		MaxPos = v3f(-287, -432, 88),	Souls = 23000},  	//19, Najka
		new {MinPos = v3f(-216, -553, 107),		MaxPos = v3f(-161, -488, 108),	Souls = 14000},  	//20, Rat Authority
		new {MinPos = v3f(-59, -652, 116),		MaxPos = v3f(-32, -627, 117),	Souls = 7000},   	//21, Congregation
		new {MinPos = v3f(-129, -593, 72),		MaxPos = v3f(-80, -537, 74),	Souls = 42000},  	//22, Freja
		new {MinPos = v3f(4, -126, -31),		MaxPos = v3f(34, -110, -29),	Souls = 11000},  	//23, Royal Rat Vanguard
		new {MinPos = v3f(-373, -496, 108),		MaxPos = v3f(-353, -466, 110),	Souls = 26000},  	//24, Dragonriders
		new {MinPos = v3f(-360, -675, 103),		MaxPos = v3f(-323, -635, 105),	Souls = 34000},  	//25, Mirror Knight
		new {MinPos = v3f(-171, -1113, -33),	MaxPos = v3f(-115, -1069, -31),	Souls = 26000},  	//26, Demon of Song
		new {MinPos = v3f(-73, -1009, -133),	MaxPos = v3f(-38, -981, -131),	Souls = 50000},  	//27, Velstadt
		new {MinPos = v3f(-274, -803, 80),		MaxPos = v3f(-225, -749, 81),	Souls = 37000},  	//28, Guardian Dragon
		new {MinPos = v3f(-794, -909, 336),		MaxPos = v3f(-671, -817, 337),	Souls = 120000}, 	//29, Ancient Dragon
		new {MinPos = v3f(-278, 129, -5),		MaxPos = v3f(-172, 158, 1),		Souls = 75000},  	//30, Giant Lord
		new {MinPos = v3f(383, -166, -62),		MaxPos = v3f(420, -131, -59),	Souls = 84000},  	//31, Fume Knight
		new {MinPos = v3f(437, -256, -27),		MaxPos = v3f(460, -234, -25),	Souls = 75000},  	//32, Smelter Demon (Blue)
		new {MinPos = v3f(697, -115, 52),		MaxPos = v3f(730, -85, 53),		Souls = 80000},  	//33, Sir Alonne
		new {MinPos = v3f(-29, -983, -138),		MaxPos = v3f(-3, -957, -137),	Souls = 90000},  	//34, Vendrick
		new {MinPos = v3f(-41, -134, -72),		MaxPos = v3f(-7, -96, -71),		Souls = 72000},  	//35, Elana
		new {MinPos = v3f(-28, -256, -80),		MaxPos = v3f(52, -173, -79),	Souls = 96000},  	//36, Sinh
		new {MinPos = v3f(52, -31, 14),			MaxPos = v3f(113, 10, 21),		Souls = 60000},  	//37, Gank Squad
		new {MinPos = v3f(-35, -90, -24),		MaxPos = v3f(3, 8, -23),		Souls = 78000},  	//38, Aava
		new {MinPos = v3f(-78, 209, -285),		MaxPos = v3f(-30, 297, -280),	Souls = 92000},  	//39, Ivory
		new {MinPos = v3f(358, -414, -70),		MaxPos = v3f(400, -354, -68),	Souls = 56000},  	//40, Twin Pets
		new {MinPos = v3f(-132, -283, 47),		MaxPos = v3f(-41, -220, 49),	Souls = 19000},  	//41, Chariot
		new {MinPos = v3f(264, -1033, 11),		MaxPos = v3f(301, -1004, 14),	Souls = 35000},  	//42, Darklurker
		new {MinPos = v3f(-275, -744, -6),		MaxPos = v3f(-224, -700, -4),	Souls = 68000},  	//43, Throne Duo
		new {MinPos = v3f(-275, -744, -6),		MaxPos = v3f(-224, -700, -4),	Souls = 90000},  	//44, Nashandra
		new {MinPos = v3f(-794, -909, 336),		MaxPos = v3f(-671, -817, 337),	Souls = 0},      	//45, Ancient Dragon Arena
		new {MinPos = v3f(276, 5, -7),			MaxPos = v3f(280, 8, -4),		Souls = 0},      	//46, Heide's Tower of Flame bonfire
		new {MinPos = v3f(-252, -846, 79),		MaxPos = v3f(-248, -843, 86),	Souls = 0},      	//47, elevator after Guardian Dragon
		new {MinPos = v3f(-344, -684, 102),		MaxPos = v3f(-340, -680, 110),	Souls = 0},      	//48, Mirror Knight elevator
		new {MinPos = v3f(-88, -1038, -30),		MaxPos = v3f(-86, -1035, -25),	Souls = 0},      	//49, Door after Demon of Song
		new {MinPos = v3f(-185, 78, 1),			MaxPos = v3f(-181, 82, 2),		Souls = 0},      	//50, Melentia bonfire
		new {MinPos = v3f(101, -39, 20),		MaxPos = v3f(107, -33, 23),		Souls = 0},      	//51, last Ascetic pickup in DLC1
		new {MinPos = v3f(-216, -354, 42),		MaxPos = v3f(-210, -348, 44),	Souls = 0},      	//52, RTSR
		new {MinPos = v3f(-163, -334, 32),		MaxPos = v3f(-157, -325, 33),	Souls = 0},      	//53, Ruined Fork Road bonfire
		new {MinPos = v3f(0, 21, 0),			MaxPos = v3f(0, -37, 0),		Souls = 0},      	//54, (impossible condition for autosplitter error prevention)
		new {MinPos = v3f(234, -457, 38),		MaxPos = v3f(238, -447, 39),	Souls = 0},      	//55, before bridge after Skeleton Lords
		new {MinPos = v3f(589, -554, 89),		MaxPos = v3f(591, -550, 92),	Souls = 0},      	//56, Mytha elevator
		new {MinPos = v3f(648, -736, 184),		MaxPos = v3f(651, -734, 185),	Souls = 0},      	//57, door after Smelter Demon
		new {MinPos = v3f(547, -185, 7),		MaxPos = v3f(551, -181, 8),		Souls = 0},      	//58, bonfire room after Ruin Sentinels
		new {MinPos = v3f(-55, 73, -3),			MaxPos = v3f(-51, 78, 1),		Souls = 0}, 	 	//59, big door after Aava
		new {MinPos = v3f(-18, -84, -13),		MaxPos = v3f(-12, -78, -12),	Souls = 0},      	//60, DLC1 Dragon Stone Bonfire
		new {MinPos = v3f(311, -198, 34),		MaxPos = v3f(321, -190, 36),	Souls = 0},      	//61, DLC2 scorching iron sceptre
		new {MinPos = v3f(-154, 39, -39),		MaxPos = v3f(-144, 49, -37),	Souls = 0},      	//62, DLC2 Key
		new {MinPos = v3f(-139, -247, -233),	MaxPos = v3f(-93, -190, -230),	Souls = 4000},   	//63, Black Gulch giant 
		new {MinPos = v3f(-17, 10, 5),			MaxPos = v3f(-16, 11, 6),		Souls = 0},      	//64, Majula bonfire (from warp)
		new {MinPos = v3f(54, -174, 24),		MaxPos = v3f(58, -171, 25),		Souls = 0},      	//65, Felkin bonfire
		new {MinPos = v3f(-225, 38, -9),		MaxPos = v3f(-244, 64, 2),		Souls = 16998},  	//66, Pursuer, Lucida 17k
		new {MinPos = v3f(-159, -255, -229),	MaxPos = v3f(-147, -247, -228),	Souls = 0},  	 	//67, DLC1 Entrance Portal
		new {MinPos = v3f(660, -677, 157),		MaxPos = v3f(666, -666, 158),	Souls = 0},   	 	//68, DLC2 Entrance Portal
		new {MinPos = v3f(-215, -211, 46),		MaxPos = v3f(-204, -206, 47),	Souls = 0},  	 	//69, DLC3 Entrance Portal
		new {MinPos = v3f(-114, -197, -221),	MaxPos = v3f(-107, -192, -220),	Souls = 0},      	//70, Dungeon: Gulch Portal
		new {MinPos = v3f(-220, -460, 57),		MaxPos = v3f(-210, -448, 59),	Souls = 0},      	//71, Dungeon: Woods Portal
		new {MinPos = v3f(-329, -450, 65),		MaxPos = v3f(-320, -442, 66),	Souls = 0},      	//72, Dungeon: Drangleic Portal
		new {MinPos = v3f(-184, -431, 61),		MaxPos = v3f(-177, -426, 62),	Souls = 0},      	//73, Shaded Ruins bonfire
		new {MinPos = v3f(38, -249, 28),		MaxPos = v3f(45, -242, 29),		Souls = 0},      	//74, Bridge Approach bonfire
		new {MinPos = v3f(-35, -146, -7),		MaxPos = v3f(-28, -139, -6),	Souls = 0},      	//75, Flynns ring room
		new {MinPos = v3f(384, -125, 100),		MaxPos = v3f(389, -123, 101),	Souls = 0},      	//76, DLC2 Chunks/Butterly pickup
		new {MinPos = v3f(-213, 34, -35),		MaxPos = v3f(-190, 54, -24),	Souls = 0},      	//77, Vammar 20k
		new {MinPos = v3f(-44, -650, 125),		MaxPos = v3f(-37, -641, 126),	Souls = 0},      	//78, Tseldora ascetic
		new {MinPos = v3f(591, -119, 14),		MaxPos = v3f(593, -113, 15),	Souls = 0},      	//79, Bastille ascetic
		new {MinPos = v3f(-744, -6, -275),		MaxPos = v3f(-700, -4, -224),	Souls = 0},      	//80, Aldia / 0 souls finish
		new {MinPos = v3f(-251, -488, 58),		MaxPos = v3f(-247, -486, 59),	Souls = 0},      	//81, Aldia's Keep Aslatiel door
		new {MinPos = v3f(-180, 25, -22),		MaxPos = v3f(-175, 31, -21),	Souls = 0},      	//82, Giant Lord Fragrant branch
		new {MinPos = v3f(-150, 156, 12),		MaxPos = v3f(-146, 160, 13),	Souls = 0},      	//83, Pursuer nest
		new {MinPos = v3f(-10, -970, -138),		MaxPos = v3f(-5, -960, -137),	Souls = 0},      	//84, King's ring
		new {MinPos = v3f(273, 7, -7),			MaxPos = v3f(290, 21, -5),		Souls = 0},      	//85, Licia / Tower of Flame bonfire
		new {MinPos = v3f(480, -125, -81),		MaxPos = v3f(488, -118, -80),	Souls = 0},      	//86, Sinner primal bonfire
		new {MinPos = v3f(-86, -497, 70),		MaxPos = v3f(-57, -467, 71),	Souls = 0}, 	 	//87, Freja primal bonfire
		new {MinPos = v3f(592, -584, 165),		MaxPos = v3f(595, -580, 166),	Souls = 0}, 	 	//88, Threshold Bridge bonfire
		new {MinPos = v3f(321, -481, 48),		MaxPos = v3f(328, -473, 49),	Souls = 0}, 	 	//89, Poison pool bonfire
		new {MinPos = v3f(-205, 119, -26),		MaxPos = v3f(-201, 125, -24),	Souls = 0}, 	 	//90, Memory of Orro exit
		new {MinPos = v3f(-220, -563, 96),		MaxPos = v3f(-210, -557, 99),	Souls = 0}, 	 	//91, Gyrm's respite bonfire
		new {MinPos = v3f(-161, -717, 135),		MaxPos = v3f(-119, -669, 139),	Souls = 0}, 	 	//92, Tseldora campsite bonfire [covers both vanilla/sotfs]
		new {MinPos = v3f(-333, -538, 125),		MaxPos = v3f(-327, -533, 126),	Souls = 0}, 	 	//93, Caitha's chime
		new {MinPos = v3f(-6, -43, -35),		MaxPos = v3f(5, -37, -34),		Souls = 0},  	 	//94, DLC1 key
		new {MinPos = v3f(-374, -469, 72),		MaxPos = v3f(-368, -462, 73),	Souls = 0},  	 	//95, King's gate bonfire
		new {MinPos = v3f(597, -91, -2),		MaxPos = v3f(606, -84, 1),		Souls = 0},  	 	//96, Mcduff bonfire
		new {MinPos = v3f(-260, -701, -7),		MaxPos = v3f(-256, -699, -4),	Souls = 0},      	//97, Duo fog wall
	};
	
	// Interface this to tuple (to allow nice above notation to be kept)
	Tuple<Vector3f, Vector3f, float>[] tup_splitconds = new Tuple<Vector3f, Vector3f, float>[def_splitconds.Count()]; // preallocate
	for (int i = 0; i < def_splitconds.Count(); i++)
	{
		var splitcond = def_splitconds[i];
		tup_splitconds[i] = SC(splitcond.MinPos, splitcond.MaxPos, splitcond.Souls); // save in tuple form for passing across method boundary
	}	
	vars.split_conditions = tup_splitconds; // save
	
	
	// Routes are described by a list of splits, with split conditions represented by:
	// Number: Index representing above condition to meet.
	// Letter: 
	// 		'L' - "Next Load"
	//  	'S' - "Split (now)"
	//  	'N' - "NO split"
	// 		'C' - "Next cutscene"
	// 		'D' - "Dungeons" (3rd-loadscreen at portal)
	
	
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
				Tsplit("Branch Skip",  	"53S"), 		// (bonfire light)
				Tsplit("Aldia's door", 	"81S"), 		// (door)
				Tsplit("Ashen Mist", 	"45L"), 		// (boneout)
				Tsplit("Giant Lord", 	"30L"), 		// (boneout)
				Tsplit("Duo Fogwall", 	"97S"), 		// (Fogwall)
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
				Tsplit("Dungeon: Woods", 	"71D"), 	// (boneout after dungeon)
				Tsplit("Dungeon: Gulch", 	"70D"), 	// (boneout after dungeon)
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
				Tsplit("Dungeon: Woods", 	"71D"), 	// (boneout after dungeon)
				Tsplit("Dungeon: Gulch", 	"70D"), 	// (boneout after dungeon)
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
				Tsplit("Dungeon: Woods", 	"71D"), 	// (boneout after dungeon)
				Tsplit("Dungeon: Gulch", 	"70D"), 	// (boneout after dungeon)
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
	
	// Testing/Debugging
	// vars.routes.Add(
	// 	Tuple.Create("sotfs_DungeonDebugTest", "Dungeon_Debugging", 
	// 		new List<Tuple<string,string>>
	// 		{
	// 			Tsplit("Gargoyles", 		"17L"), 	// (boneout)
	// 			Tsplit("Dungeon: Woods", 	"71D"), 	// (boneout after dungeon)
	// 			Tsplit("Gulch Dungeon", 	"70D"), 	// (homeward after dungeon)
	// 			Tsplit("Darklurker", 		"42L"), 	// (boneout)
	// 		}
	// 	)
	// );

	
	
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
        	//var route_splits = vars.all_route_splits[i];
        	string route_tooltip = "Feel free to add manual splits at your own leisure.\nThis route has the following autosplits:\n";
        	foreach (Tuple<string, string> entry in vars.all_route_splits[i]) {
           		route_tooltip +=  entry.Item1 + "\n";
        	}
        	settings.SetToolTip(route_uid, route_tooltip);
	}
	
	settings.Add("ffleret", false, "Split on every loading screen");
	settings.SetToolTip("ffleret", "This setting will only work if no route is selected.");
	
	//additional variables used for keeping track of split order
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
	vars.numloads = 0;
	
	
	Action<int, int> updateActiveSplit = (split_index, subsplit_index) => 
	{
		vars.route_splits = vars.all_route_splits[vars.route_index];
		var thisTsplit = vars.route_splits[split_index];
		string[] split_tokens = thisTsplit.Item2.Split(' ');		
		string token = split_tokens[subsplit_index];
				
		// can't load Regex namespace it seems
		int cond_id = int.Parse(String.Join("", token.Where(Char.IsDigit)));
		string split_type = String.Join("", token.Where(Char.IsLetter));
		vars.split_type = split_type.ToUpper();
		
		var localSC = vars.split_conditions[cond_id];
		
		// Unpack here... (I hate ASL)... 
		vars.SCMin = localSC.Item1; 		// Vector3f
		vars.SCMax = localSC.Item2; 		// Vector3f
		vars.SCSouls = localSC.Item3;		// int
		
		
		vars.split_token_count = split_tokens.Length;
		
		if (vars.debug_output)
		{
			print("token use: " + token.ToString());
			print("split_index:" + split_index);
			print("subsplit_index: " + subsplit_index);
			print("split_type: " + split_type);
		}
		
	};
	vars.updateActiveSplit = updateActiveSplit; // save reference to function
	
	// Prepare debug print function:
	Action<Vector3f, Vector3f, Vector3f, float, float, float> printSplitInfo = (currpos, scminpos, scmaxpos, currsouls, scminsouls, scmaxsouls) => 
	{
		print("Current State and Split information......");
		print("Curr PosX:  " + currpos.X);
		print("Curr PosY:  " + currpos.Y);
		print("Curr PosZ:  " + currpos.Z);
		print("Curr Souls: " + currsouls);
		print(" ...split conditions ... ");
		print("Req MinPosX:  " + scminpos.X);
		print("Req MaxPosX:  " + scmaxpos.X);
		print("Req MinPosY:  " + scminpos.Y);
		print("Req MaxPosY:  " + scmaxpos.Y);
		print("Req MinPosZ:  " + scminpos.Z);
		print("Req MaxPosZ:  " + scmaxpos.Z);
		print("Split soul range: " + scminsouls + " to " + scmaxsouls);
	};
	vars.printSplitInfo = printSplitInfo; // make available
	
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
	
	// Keep selected route updated:
	for (int i = 0; i < vars.Nroutes; i++){
		if (settings[vars.route_uids[i]]){
			vars.route_index = i; // selected route index in Livesplit settings list
			break;
		}
	}
	vars.first_update = true;
	
	// Autostart:
	if (current.load == old.load - 1 &&
		current.yPos < -322.0f && current.yPos > -323.0f &&
		current.xPos < -213.0f && current.xPos > -214.0f)
	{
		vars.doneSubsplits = 0;
		vars.doneSplits = 0;
		vars.bSubsplitComplete = false;
		vars.wait_for_cutscene = false;
		vars.wait_for_load = false;
		vars.numloads = 0;
		vars.split_type = "S"; // type initialiser
		return true;
	}
}

split {
	
	if (vars.route_index < vars.Nroutes) {
		
		bool splitbool;
		if (vars.first_update){
			vars.first_update = false;
			vars.updateActiveSplit(vars.doneSplits, vars.doneSubsplits);
		}
		
		// Shorthand:
		var currpos = vars.v3f(current.xPos, current.yPos, current.zPos);
		float currsouls = (float)current.souls;
		float soulsmin = old.souls + vars.SCSouls;
		float soulsmax = old.souls + (vars.SCSouls * 1.69f); // 1.69 = max soul boost due to gear
		
		// Debug helper:
		if (vars.debug_output)
			vars.printSplitInfo(currpos, vars.SCMin, vars.SCMax, currsouls, soulsmin, soulsmax);
				
		
		// check whether split condition (SC) is met
		if ( vars.isVecBetween(currpos, vars.SCMin, vars.SCMax) &&
			vars.isBetween(currsouls, soulsmin, soulsmax)  ) 
		{
			string local_type = vars.split_type;
			switch (local_type)
			{
				case null:
				case "S":
				case "N":
					vars.bSubsplitComplete = true;
					break;
				case "L":
				case "D":
					vars.wait_for_load = true;
					break;
				case "C":
					vars.wait_for_cutscene = true;
					break;
			}
		}
		
		// check for load screen
		if (current.load == old.load + 1 && vars.wait_for_load == true) {
			vars.wait_for_load = false;
			vars.numloads++;
			
			// Check how many desired load screens we've had
			if ((vars.split_type == "L" && vars.numloads==1) || (vars.split_type == "D" && vars.numloads == 3))
				vars.bSubsplitComplete = true;
		}
		
		
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
			
			// Check for end of splits:
			if (vars.doneSplits == vars.route_splits.Count)
				return true;
			
			
			// Reset things for next split
			vars.numloads = 0; // reset condition-loadscreen counter
			vars.updateActiveSplit(vars.doneSplits, vars.doneSubsplits);
			return splitbool;
		}
		
	} else {
		if (settings["ffleret"]) {
			return current.load == old.load + 1;
		}
	}

}

reset {
	if (current.yPos == 0 && current.xPos == 0 && 
		current.zPos <= -100 && old.zPos > -100 &&
		current.state == 2) {
		return true;
	}
}

isLoading {
	return current.load == 1;
}
