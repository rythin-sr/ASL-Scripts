//Crazy Machines 3 Autosplitter + Load Remover by rythin
//timer will start whenever you leave a loading screen
//this is a really janky implementation
//load removal might break sometimes? not tested extensively

//Contanct info in case issues arise:
//Discord: rythin#0135
//Twitter: rythin_sr
//Twitch:  rythin_sr

state("cm3") {
	int gameLoading:	0x005C8338, 0xD8, 0x548, 0x90, 0xB1C;
	int levelDone:		0x005CAF68, 0x78, 0xB1C;	
	int inMenu:		0x0066E560, 0x50, 0xD8, 0x41C;
}

start {
	return (current.inMenu == 0 && old.inMenu == 1024);
}

split {
	return (current.levelDone == 1024 && old.levelDone == 0 && current.gameLoading == 0);
}

isLoading {
	return current.gameLoading == 1024;
}
