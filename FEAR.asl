//FEAR Autosplitter + Load Remover made by rythin, with contributions from SuicideMachine, FireCulex, KunoDemetries and KZ_Frew

state("FEAR")
{
	int gameLoading:  0x173DB0;				//0, 4 or 5 when gameplay, 1 or 2 when loading
	int cp:           0x8519A, 0x25;
	string16 mapName: 0x16C045;
	int gamePaused:   0x16CCE8;				//1 when paused
}

init {
	vars.lastMap = "h";
	vars.splits = new List<string>();
}

update {
	if (current.mapName == "" && old.mapName != "") {
		vars.lastMap = old.mapName;
	}
}

start { 
	if(current.gameLoading == 0 || current.gameLoading == 4 || current.gameLoading == 5) {
		if(current.mapName == "Intro.World00p" && old.gameLoading != 0) {
			vars.lastMap = "h";
			vars.splits.Clear();
			vars.splits.Add(current.mapName);
			return true;
		}
	}
}

split {
	//level splits
	if (vars.lastMap != current.mapName && current.mapName != "" && vars.lastMap != "h" && !vars.splits.Contains(current.mapName) && timer.CurrentPhase == TimerPhase.Running) {
		vars.lastMap = current.mapName;
		vars.splits.Add(current.mapName);
		return true;
	}
}

reset {
	return (old.mapName == "" && current.mapName == "Intro.World00p");
}

isLoading {
	return current.loading > 0 && current.loading < 3 || current.cp != 256;
}
