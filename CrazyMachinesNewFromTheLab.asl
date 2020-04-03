//Crazy Machines 1.5: New From The Lab Autosplitter by rythin

//Contanct info in case issues arise:
//Discord: rythin#0135
//Twitter: rythin_sr
//Twitch:  rythin_sr


state("cmnftl") {
	string50 levelName:		0x00116064, 0x14, 0x0, 0x0, 0x14, 0x34;		
	int tbEnd:			0x001123FC, 0xD4, 0x1A4;			//level end textbox
	int tbOn:			0x113ABC;					//any textbox
}

start {
	return (current.levelName == "Cannons and a lamp" && old.tbOn == 0 && current.tbOn == 1);
}

split {
	return (current.tbEnd == 1 && old.tbEnd == 0);
}
