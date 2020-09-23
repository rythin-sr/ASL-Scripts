//Earth 2150 Autosplitter + Load Remover by rythin

state("Earth2150") {
	
	//name of the area the player is currently in
	string30 areaName: 	0x63D254, 0x58, 0x0C, 0x44, 0x0C;
	
	//1 when in "freeroam" (able to start a mission), 0 otherwise
	int freeroam: 		0x5D0914;
	
	//1 when on the mission-end stats screen and on fullscreen overlays (F1-3 buttons)
	int overlay:		0x381454;
	
	//1 on mission end screens, will sometimes flicker to 1 when starting a mission
	int missionEnd:		0x5D08D4;
	
	//1 when loading
	int load:		0x5DB8F0;
	
	//4 in (some)loads and in the menu
	int menu:		0x345420;
	
	//1 in the campaign-end cutscene
	int fmv:		0x359F54;
}

startup {
	
	//add settings groups
	settings.Add("ED", true, "Eurasian Dynasty");
	settings.Add("UCS", true, "United Civilized States");
	settings.Add("LC", true, "Lunar Corporation");
	
	//add settings for each mission
	//since mission names repeat between campaigns, we add the campaign name as the prefix to the setting
	vars.missionsLC = new Dictionary<string, string> {
		{"LCUral", "Ural"},
		{"LCArctic", "Arctic"},
		{"LCHimalaya", "Himalaya"},
		{"LCKamchatka", "Kamchatka"},
		{"LCCanada", "Canada"},
		{"LCBaikal", "Baikal"},
		{"LCAmazon", "Amazon"},
		{"LCThe Great Lakes", "The Great Lakes"},
		{"LCMadagascar", "Madagascar"},
		{"LCAustralia", "Australia"},
		{"LCMozambique", "Mozambique"},
		{"LCRio de Janeiro", "Rio de Janeiro"},
		{"LCLesotho", "Lesotho"},
		{"LCIndia", "India"},
		{"LCEgypt", "Egypt"},
		{"LCCongo", "Congo"},
		{"LCPeru", "Peru"},
		{"LCAmazon2", "Amazon 2"},
		{"LCAndes", "Andes"},
		{"ACME", "Split at the end of ACME Lab missions"}
	};
	
	foreach (var Tag in vars.missionsLC) {
		settings.Add(Tag.Key, true, Tag.Value, "LC");
    };
	
	vars.missionsUCS = new Dictionary<string, string> {
		{"UCSUral", "Ural"},
		{"UCSArctic", "Arctic"},
		{"UCSArctic II", "Arctic II"},
		{"UCSBaikal", "Baikal"},
		{"UCSAlaska", "Alaska"},
		{"UCSJapan", "Japan"},
		{"UCSKurtshatov FZ", "Kurtshatov FZ"},
		{"UCSGreat Lakes", "Great Lakes"},
		{"UCSNew York", "New York"},
		{"UCSIndia", "India"},
		{"UCSMadagascar", "Madagascar"},
		{"UCSAustralia", "Australia"},
		{"UCSEgypt", "Egypt"},
		{"UCSMozambique", "Mozambique"},
		{"UCSAndes", "Andes"},
		{"UCSColumbia", "Columbia"},
		{"UCSAchimania", "Achimania"},
		{"UCSStanford Lab", "Split at the end of Stanford Lab missions"}
	};
		
	foreach (var Tag in vars.missionsUCS) {
		settings.Add(Tag.Key, true, Tag.Value, "UCS");
    };
	
	vars.missionsED = new Dictionary<string, string> {
		{"EDUral", "Ural"},
		{"EDArctic", "Arctic"},
		{"EDArctic 2", "Arctic 2"},
		{"EDKamchatka", "Kamchatka"},
		{"EDLeviathan", "Leviathan"},
		{"EDAlaska", "Alaska"},
		{"EDJapan", "Japan"},
		{"EDCanada", "Canada"},
		{"EDAmazon -N-", "Amazon -N-"},
		{"EDGreat Lakes", "Great Lakes"},
		{"EDNew York", "New York"}
	};
	
	foreach (var Tag in vars.missionsED) {
		settings.Add(Tag.Key, true, Tag.Value, "ED");
    };
	
	//variable keeping track of the last played mission
	vars.realMission = "";
	
	//variable keeping track of progress in the campaign to use in lab splits
	vars.currentProgress = 0;
	
	//variable keeping track of the campaign being played at the moment
	vars.campaign = "";
	
	refreshRate = 30;
}

update {
	if (current.areaName != old.areaName) {
		//keeping track of the mission last played, since you can go to your Base mid-mission
		//and also the value goes to null on stats screens
		if (current.areaName != null && !current.areaName.Contains("Base")) {
			vars.realMission = current.areaName;
			print("realMission = " + vars.realMission);
		}
		
		//Ural happens to be the first mission of every campaign so we use it to reset the progress counter
		if (current.areaName == "Ural") {
			vars.currentProgress = 0;
		}
	}
	
	//because in the LC campaign the mission Amazon happens twice, we need to keep track of
	//when the player finished the first one and is on to the 2nd one
	//so that the setting works
	//since you have to complete The Great Lakes before you gain access to Amazon 2, we check if that mission
	//has been completed, and if so, set the progress to 1
	if (vars.realMission == "The Great Lakes" && vars.campaign == "LC") {
		if (current.missionEnd == 1 && old.missionEnd == 0 && current.overlay == 1) {
			vars.currentProgress = 1;
		}
	}
	
	//at the beginning of each campaign you gain "freeroam" after some time spent in your base
	//the base for each campaign has a unique name, allowing us to determine which campaign is being played
	if (current.freeroam == 1 && old.freeroam == 0) {
		string currentBase = current.areaName;
		switch (currentBase) {
			case "LC Base":
			vars.campaign = "LC";
			print("Campaign set to: " + vars.campaign);
			break;
			
			case "ED Base":
			vars.campaign = "ED";
			print("Campaign set to: " + vars.campaign);
			break;
			
			case "UCS Base":
			vars.campaign = "UCS";
			print("Campaign set to: " + vars.campaign);
			break;
		}
	}
	
	//debug stuff
	
	//if (current.missionEnd != old.missionEnd) {
	//	print(old.missionEnd + " -> " + current.missionEnd + current.areaName);
	//}
	
	if (current.fmv == 1 && old.fmv == 0) {
		print("FMV Started!");
	}

	//if (current.areaName != old.areaName) {
	//	print(old.areaName + " -> " + current.areaName);
	//}
}

start {
	if (current.menu == 0 && old.menu == 4) {
		vars.realMission = "";
		vars.campaign = "";
		vars.currentProgress = 0;
		return true;
	}
}

split {
	//regular mission splits
	if (current.missionEnd == 1 && old.missionEnd == 0 && current.overlay == 1 || current.overlay == 1 && old.overlay == 0 && current.missionEnd == 1) {
		if (settings[vars.campaign + vars.realMission]) {
			return true;
		}
	}
	
	//amazon2 split
	if (settings["LCAmazon2"]) {
		if (vars.realMission == "Amazon" && vars.currentProgress == 1) {
			if (current.missionEnd == 1 && old.missionEnd == 0 && current.overlay == 1) {
				return true;
			}
		}
	}
	
	//ACME Lab splits
	if (vars.realMission == "ACME-Lab" || vars.realMission == "ACME-Laboratory") {
		if (current.freeroam == 1 && old.freeroam == 0) {
			if (settings["ACME"]) {
				return true;
			}
		}
	}
	
	//campaign end splits
	//i really hope this just works
	if (current.fmv == 1 && old.fmv == 0) {
		return true;
	}
}

isLoading {
	return (current.load == 1 || current.menu == 4);
}
