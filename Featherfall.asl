//Featherfall Game Time by rythin
//Autosplitter coming when i have motivation to work on it again

//Contact info:
//Discord: rythin#0135
//Twitter: @rythin_sr
//Twitch: rythin_sr

state("soksouls") {
	double IGT:		0x0043550C, 0x0, 0x60, 0x10, 0x4B4, 0x1A0;
	int fpsCap:		0x3D0A50; 					//seems to be 30 in the menu and 60 in game?
}

start {
	return (current.fpsCap == 60 && old.fpsCap == 30);
}

isLoading {
	return true;
}

gameTime {
	return TimeSpan.FromSeconds(current.IGT + 0.5);
	// +0.5 because the game seems to round the IGT up in the display and 
	// i dont like the time in livesplit and the game not matching 
}
