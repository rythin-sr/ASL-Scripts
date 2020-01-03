// SAS: Secure Tomorrow Autosplitter/Load Remover made by rythin, contact in case you encounter any issues: 
// Discord: rythin#0135, Twitter: @rythin_sr, Twitch: rythin_sr

state("game") {
	int gameLoading: 0x1BC48C;
	int gameLoading2: 0x1C50CC;
	int cutsceneWatcher: 0x1BC668;
	int saveWatcher: 0x1C1A21;
	string10 levelEL: 0x1C616D;
	string9 levelL: 0x1C616D;
	string3 levelS: 0x1C616D;
}

start {
	return (current.levelL == "SAS_lvl_1" && current.gameLoading == 0);
	}
	
split {
	if (current.levelS != old.levelS && old.levelS == "") {
		return true;
	}
	
	if (current.levelEL == "SAS_lvl_13" && current.cutsceneWatcher == 0) {
		return true;
	}
}
	
isLoading {
		if (current.levelEL != "SAS_lvl_13" && current.gameLoading == 0 || current.saveWatcher != 0) {
			return true;
		}
		
		if (current.levelEL == "SAS_lvl_13" && current.gameLoading2 != 1) {
			return true;
		}
		
		else {
			return false;
		}
	}
	
exit {
	timer.IsGameTimePaused = true;
	}

