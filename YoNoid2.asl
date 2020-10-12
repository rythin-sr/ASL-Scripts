//Yo! Noid 2 Legacy Edition autosplitter by rythin
//todo: fix final split offset

state("noid") {
	//different number on different levels, flickers a bunch during level transitions
	int level:	0xFFC710;
}

startup {
	
	//set up settings and variables required for logic
	settings.Add("lc", true, "Level Completion");
	settings.Add("le", true, "Level Entry");
	
	settings.Add("5", true, "New York", "lc");
	
	vars.doneLevels = new List<string>();
	vars.validLevels = new List<int>();
	vars.validLevels.Add(5);
	vars.lastLevel = 0;
	vars.flickerPrevention = 0;
	vars.stopwatch = new Stopwatch();
	
	vars.l = new Dictionary<int, string> {
		{16, "Plizzanet"},
		{28, "Swing Factory"},
		{31, "Domino Dungeon"},
		{10, "???"}
	};
	
	foreach (var Tag in vars.l) {
		settings.Add(Tag.Key.ToString(), true, Tag.Value, "lc");
		settings.Add(Tag.Key.ToString() + "e", true, Tag.Value, "le");
		vars.validLevels.Add(Tag.Key); 
	};
	
	vars.timerStart = false;
	vars.timerStop = false;
	vars.currentTime = new TimeSpan (0, 0, 0);
}

//start timer offset = 1.081

update {
	vars.currentTime = timer.CurrentTime.GameTime;
}

start {
	if (current.level == 1 && old.level != 1) {
		vars.lastLevel = 5;
		vars.flickerPrevention = 0;
		vars.timerStart = true;
		vars.timerStop = false;
		vars.doneLevels.Clear();
		return true;
	}
}

split {
	
	//area entry splits
	if (vars.validLevels.Contains(current.level) && old.level != current.level) {
		vars.flickerPrevention = current.level;
		vars.stopwatch.Restart();
	}
	
	if (vars.stopwatch.ElapsedMilliseconds > 30) {
		if (current.level == vars.flickerPrevention && !vars.doneLevels.Contains(current.level.ToString() + "e")) {
			vars.doneLevels.Add(current.level.ToString() + "e");
			vars.lastLevel = current.level;
			return (settings[current.level.ToString() + "e"]);
		}
	}
	
	//area completion splits
	if (current.level == 19 && old.level != 19 && !vars.doneLevels.Contains(vars.lastLevel.ToString())) {
		vars.doneLevels.Add(vars.lastLevel.ToString());
		return (settings[vars.lastLevel.ToString()]);
	}
	
	//final split
	//might need to make sure you're on the last split but idk how to set that up right now
	if (current.level == 4 && vars.lastLevel == 10 && settings["10"]) {
		vars.timerStop = true;
		//print(timer.CurrentTime.RealTime.Value.TotalSeconds.ToString());
		return true;
	}
}

gameTime {
	if (vars.timerStart == true) {
		vars.timerStart = false;
		return TimeSpan.FromSeconds(1.081);
	}
	
	if (vars.timerStop == true) {
		vars.timerStop = false;
		return vars.currentTime.Subtract(new TimeSpan (0, 0, 0, 16, 502));
	}
}
