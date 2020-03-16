state("bakoma") {
	int 		    gameLoading:		0x9C2DC;	//0 during gameplay
	string10 	  mapName:		  	0x9B428;	
}

split {
	return (current.mapName == "menu" && old.mapName != "menu");
}

start {
	return (current.mapName != "menu" && current.gameLoading == 0);
}

isLoading {
	return (current.gameLoading != 0);
}
