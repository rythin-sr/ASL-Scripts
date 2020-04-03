//Crazy Machines 3 Autosplitter + Load Remover by rythin
//timer will start whenever you leave a loading screen
//this is a really janky implementation but i have no other way of
//doing it really, game sucks

state("cm3") {
	int gameLoading:	0x005C8338, 0xD8, 0x548, 0x90, 0xB1C;
	int levelDone:		0x005CAF68, 0x78, 0xB1C;	
}

start {
	return (current.gameLoading == 0 && old.gameLoading == 1024);
}

split {
	return (current.levelDone == 1024 && old.levelDone == 0 && current.gameLoading == 0);
}

isLoading {
	return current.gameLoading == 1024;
}