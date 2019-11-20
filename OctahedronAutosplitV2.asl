state("octahedron") {
	int levelID: 0x1757DF0;
	int livesCount: 0x1A17658;
	double IGT: 0x17E5CA8;
	int finishCounter: 0x1A14A94;
}

startup {
	settings.Add("autosplit", true, "Enable autosplitter (doesn't work for final split, do that manually)");
}

update {
	vars.split = false;
	vars.start = false;	
	
	if (old.finishCounter != current.finishCounter) {
	vars.split = true;
	}
	
	if (current.levelID == 30)
	{
	vars.start = true;
	}
		
}

gameTime{
	return TimeSpan.FromSeconds(current.IGT / 10);
}

split 
{
	if (vars.split == true && settings["autosplit"] == true) {
		return true;
		}
}

start 
{
	return vars.start;
}
	
