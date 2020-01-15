//Mortyr IV: Operation Thunderstorm Load Remover + Autosplitter
//1.0 code written by rythin, addresses partially found by pitpo
//1.01 done entirely by Mr_Mary, poorly copy-pasted here
//Now with final split!

state("game", "1.0") {
	int gameLoading : "GameClient.dll", 0x210D82; //1 or 257 when loading, 256 when gameplay
	string9 mapName: 0x1C412D;
	byte freezeWatcher: 0x001DEF54, 0x2B0; //0 when gameplay happens, random value when game frozen, 160 when game is starting? idk its weird
	float finaleFade: 0x1C2EFC; // 1 at all times(?), 0 when final split happens
}

state("game", "Steam 1.01") {
	string9 mapName : 0x1C212D;
	int cutsceneWatch : 0x1B8648;
	bool isLoading : "GameClient.dll", 0x21142C;
	byte saveWatcher : "GameClient.dll", 0x21147D;
	bool inMenu : "GameClient.dll", 0x20F4F9;
	int cutCheck : 0x1CAA54;
	bool loadVerbose : "GameClient.dll", 0x2121D0;
	bool pathLoad : "GameClient.dll", 0x20A4E8;
	float finaleFade: 0x1C0EFC;
}

state("game", "Non-Steam 1.01")
{
	string9 levelName : 0x1C412D;
	byte saveLoadWatcher : "GameClient.dll", 0x20C004;
	bool inMenu : 0x1B980C;
	byte cutsceneWatcher : 0x1BA648;
    bool isFading: "GameClient.dll", 0x20FC04;
}

init {
	vars.lastMap = "h";
	vars.isCut = true; //something from Mr_Mary's script which seems to be needed? idk cba rewriting the steam script
	
	//code yoinked from Gelly, who yoinked it from someone else. cheers for that
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
	
	if(MD5Hash == "37CF43A357ACF65793702824538539DF"){
		version = "Non-Steam 1.01";
	}
	
	if(MD5Hash == "6B8599808068742CF4DB2CF25400E472"){
		version = "Steam 1.01";
    }
	
	if(MD5Hash == "96884A37F6B03FEFF0B38868FC908087"){
		version = "1.0";
    } 
}

update {
	if (current.mapName == "" && old.mapName != "") {
		vars.lastMap = old.mapName;
	}
	if (version == "Steam 1.01") {
		if (current.cutCheck == 12 || current.cutCheck == 21) {
			vars.isCut = true;
		}
		else {
			vars.isCut = false;
		}	
	}
}

start {
	if (version == "1.0") {
		if (current.mapName == "level_1_1" && current.gameLoading == 256) {
			vars.lastMap = "h";
			return true;
		}
	}
	
	if (version == "Non-Steam 1.01") {
			return current.levelName == "level_1_1" && current.saveLoadWatcher != 0 && old.saveLoadWatcher == 0;
	}
	
	if (version == "Steam 1.01") {
		if (current.mapName == "level_1_1" && current.cutsceneWatch == 0) {
			return true;
		}
	}
}

split {

	//level splits
	if (version == "1.0" || version == "Steam 1.01") {
		if (vars.lastMap != current.mapName && current.mapName != "" && vars.lastMap != "h") {
			vars.lastMap = current.mapName;
			return true;
		}
	}
	
	if (version == "Non-Steam 1.01") {
		return current.levelName == "" && old.levelName != current.levelName;
	}
	
	//final split
	if (current.mapName == "level_3_3" && old.finaleFade == 1 && current.finaleFade == 0) {
		return true;
	}
}

isLoading {
	if (version == "1.0") {
		return (current.gameLoading != 256 || current.freezeWatcher != 0);
	}
	
	if (version == "Non-Steam 1.01") {
		return !current.inMenu && current.saveLoadWatcher == 0 && current.cutsceneWatcher == 2 && !current.isFading;
	}
	
	if (version == "Steam 1.01") {
		// single case where the quickload condition is always met because game has stupid
		if (current.mapName == "level_2_1")
		{
			return ((!current.inMenu && (current.saveWatcher == 0)) && !vars.isCut) || current.isLoading || !current.pathLoad;
		}
		else return ((!current.inMenu && (!current.loadVerbose || current.saveWatcher == 0)) && !vars.isCut) || current.isLoading;
	}
}
