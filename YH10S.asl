//You Have 10 Seconds Series autosplitter
//YH10S autosplitter originally by Arcree, cleaned up a tad by rythin
//YH10S2 & TH10S3 autosplitter by rythin
//IGT by rythin

//	ToDo: 
//	-better start and final split for 2
//	-better start for 3 MAYBE
//	-3 IGT MAYBE
//	-settings to split for every room in yh10s 1 and 2 and maybe 3

//															YOU HAVE 10 SECONDS
state("You Have 10 Secondsfinal", "yh10s"){
	int roomID:		0x59C310;
	int hasControl:	0x399F04, 0x0, 0xF8, 0xC, 0xB4;
	double y1IGT:		0x0034D464, 0x5C8, 0xC, 0x140, 0x4, 0x130;	//10s countdown
}
//															YOU HAVE 10 SECONDS 2
state("You Have 10 Seconds 2 Steam Release", "yh10s2") {
	int roomID: 	0x59C310;
	double y2IGT:	0x0059C34C, 0x80, 0x13C, 0x13C, 0x4, 0x20;		//built in IGT per area
}
//															YOU HAVE 10 SECONDS 3
state("You Have 10 Seconds 3", "yh10s3") {
	//bro this game fucking blows
	int runStart:	0x3DBFBC; 							//changes from 0 to 1 upon run start
	int levelState:	0x0040761C, 0x0, 0x404, 0x2C, 0xCC; //2 between screens and on the last screen?
	int inHub:		0x0040761C, 0x0, 0x474, 0x2C, 0xCC; //0 when in level, 1 in hub
	int credits:	0x0040761C, 0x0, 0x51C, 0x2C, 0xCC; //1 when credits activate, 0 otherwise
}

init {	
	//assigning versions is entirely unnecessary here but it makes it easier for my tiny brain
    byte[] exeMD5HashBytes = new byte[0];
    using (var md5 = System.Security.Cryptography.MD5.Create())
    {
        using (var s = File.Open(modules.First().FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
        {
            exeMD5HashBytes = md5.ComputeHash(s); 
        } 
    }
    var MD5Hash = exeMD5HashBytes.Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);
    print("MD5Hash: " + MD5Hash.ToString()); //Lets DebugView show me the MD5Hash of the game executable, which is actually useful.
	
	if(MD5Hash == "E64C90393DA6757886A0CA83E9E95F49"){
      version = "yh10s";
    }
	
	if(MD5Hash == "23CCDAAC497C78C6527BB5E7EF267CAB"){
      version = "yh10s2";
    }
	
	if(MD5Hash == "61440EE61E428A66FEC51FB0AC32A274"){
      version = "yh10s3";
    }
	
	if (version == "yh10s") {
		vars.IGT = 0;
	}
	
	if (version == "yh10s2") {
		vars.IGTfinal = 0;			//final IGT displayed
		vars.areaIGT = 0;			//basically current.y2IGT but without 0
		vars.IGT = 0;				//sum of IGT from the previous levels
		vars.areaEndTransition = 0;
		vars.timerPausedRoom = 0;
	}
}    

startup {
	vars.yh3SplitCounter = 0;
}

update {
	if (version == "yh10s") {
		
		if (current.y1IGT != old.y1IGT && current.y1IGT != 0 && old.y1IGT != 0) {	//add a second to IGT whenever a second ticks in-game
			vars.IGT = vars.IGT + 1;												//but not when IGT is 0,
		}																			//as that adds an extra second every area transition
	}
	
	if (version == "yh10s2") {
		if (old.roomID == 29 && current.roomID == 30 || old.roomID == 40 && current.roomID == 41 ||old.roomID == 51 && current.roomID == 52 ||
		old.roomID == 62 && current.roomID == 63 || old.roomID == 73 && current.roomID == 74 || old.roomID == 84 && current.roomID == 85 ||
		old.roomID == 95 && current.roomID == 96 || old.roomID == 106 && current.roomID == 107 || old.roomID == 117 && current.roomID == 118 ||
		old.roomID == 128 && current.roomID == 129 || old.roomID == 139 && current.roomID == 140) {
			vars.areaEndTransition = 1;
		}
	
		else {
			vars.areaEndTransition = 0;
		}
	
		if (current.roomID == 30 || current.roomID == 41 || current.roomID == 52 ||
		current.roomID == 63 || current.roomID == 74 || current.roomID == 85 ||
		current.roomID == 96 || current.roomID == 107 || current.roomID == 118 ||
		current.roomID == 129 || current.roomID == 140 || current.roomID == 6) {
			vars.timerPausedRoom = 1;
		}

		else {
			vars.timerPausedRoom = 0;
		}
		//the ugly mess above surely could be cleaned up but I Don't Know How For I Have The Small Brian
		
		if (current.y2IGT != 0) {			//IGT resets to 0 every screen transition, this is just to avoid that on the splits
			vars.areaIGT = current.y2IGT;	
		}
	
		if (vars.areaEndTransition == 1) {	//since IGT resets every area, we need to sum it up to get the final run time
			vars.IGT = vars.IGT + vars.areaIGT;
		}
	
		if (vars.timerPausedRoom == 1) {	//when in X-11 or hub, display the sum of times of the previous areas 
			vars.IGTfinal = vars.IGT;
		}
	
		if (vars.timerPausedRoom == 0) {	//when in an area, display the above + current IGT of the area
			vars.IGTfinal = vars.IGT + vars.areaIGT;
		}
	
		if (current.roomID == 6) {			//reset current IGT when in the hub, otherwise it flickers when entering the next area
			vars.areaIGT = 0;
		}
	
	}
	
	if (version == "yh10s3") {
		if (current.inHub == 1 && old.inHub == 0) {
			vars.yh3SplitCounter = vars.yh3SplitCounter + 1;
		}
	}
}

start {

	if (version == "yh10s") {
		if (current.roomID == 3 && old.roomID == 1) {
			vars.IGT = 0;
			return true;
		}
	}
	
	if (version == "yh10s2") {
		if (current.roomID == 6) {
			return true;
		}
	}
	
	if (version == "yh10s3") {
		//if (current.runStart == 0 && old.runStart == 1) {
		//	vars.yh3SplitCounter = 0;
		//	return true;
		//}
		
		if (current.inHub == 1 && old.inHub == 0) {
			return true;
		}
	}
}

split {

	if (version == "yh10s") {
		//area splits
		if (current.roomID == 36 && old.roomID == 13 || current.roomID == 37 && old.roomID == 24 || current.roomID == 38 && old.roomID == 35) {
			return true;
		}
	
		//final split
		if (current.roomID == 50 && current.hasControl == 1 && old.hasControl == 0) {
			return true;
		}
	}
	
	if (version == "yh10s2") {
		//area splits
		if (old.roomID == 30 && current.roomID == 6 || old.roomID == 41 && current.roomID == 6 || old.roomID == 52 && current.roomID == 6 || 
		old.roomID == 63 && current.roomID == 6 || old.roomID == 74 && current.roomID == 6 || old.roomID == 85 && current.roomID == 6 ||
		old.roomID == 96 && current.roomID == 6 || old.roomID == 107 && current.roomID == 6 || old.roomID == 118 && current.roomID == 6 ||
		old.roomID == 129 && current.roomID == 6 || old.roomID == 140 && current.roomID == 7) {
			return true;
		}
	}
	
	if (version == "yh10s3") {
	
		//area splits
		if (current.inHub == 1 && old.inHub == 0 && vars.yh3SplitCounter != 1) {
			return true;
		}
		
		//final split
		if (current.credits == 1 && old.credits == 0) {
			return true;
		}
	}
}

isLoading {

	//if (version == "yh10s") {
	//	if (current.hasControl > 0) {
	//		return true;
	//	}
	//	
	//	else {
	//		return false;
	//	}
	//}
	
	//if (version == "yh10s2") {
	
	//}
	
	if (version == "yh10s3") {
		//CBA
	}
}

gameTime {

	if (version == "yh10s") {
		return TimeSpan.FromSeconds(vars.IGT);
	}

	if (version == "yh10s2") {
		return TimeSpan.FromSeconds(vars.IGTfinal);
	}
}
