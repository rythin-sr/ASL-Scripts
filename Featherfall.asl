//Featherfall Game Time by rythin
//Autosplitter coming when i have motivation to work on it again
//Contact info:
//Discord: rythin#0135
//Twitter: @rythin_sr
//Twitch: rythin_sr

state("soksouls") {
	double IGT:		0x0043550C, 0x0, 0x60, 0x10, 0x4B4, 0x1A0;
	int dumbShit:	0x41C8A4; //changes when you go into the game?? idk
	int fpsCap:		0x3D0A50; //game runs at 60 except the end "cutscene", which is capped at 30
}

start {
	return (current.dumbShit != old.dumbShit);
}

isLoading {
	return true;
}

gameTime {
	return TimeSpan.FromSeconds(current.IGT + 0.5);
	// +0.5 because the game seems to round the IGT up in the display and 
	// i dont like the time in livesplit and the game not matching 
}
