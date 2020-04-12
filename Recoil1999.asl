//Recoil (1999) Autosplitter + Game Time by rythin

state("Rec3dfx") {
	float 	levelTime:		0xE8C1C;	//doesnt seem to reset between levels on this version?
	int 	mission:		0xF3DE4;
	int		gameLoading:	0xDF370;
}

start {
	return (current.mission == 1 && current.gameLoading == 0 && old.gameLoading == 1);	
}

split {
	return (current.mission > old.mission);
}

isLoading {
	return true;
}

gameTime {
	return TimeSpan.FromSeconds(current.levelTime);
}