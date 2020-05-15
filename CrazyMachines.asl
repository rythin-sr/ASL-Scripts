//Crazy Machines Autosplitter by rythin

//Contanct info in case issues arise:
//Discord: rythin#0135
//Twitter: rythin_sr
//Twitch:  rythin_sr

state("CrazyMachines") {
	int	endTB:		0x00112C14, 0x1D8, 0x234; //1 when a level end textbox is up, 0 otherwise
	int 	isTB:		0x11066C; //1 when there's a textbox on screen, 0 otherwise
	string8 levName:	0x00112C14, 0x1EC, 0xA8, 0x54, 0x834; //level name, doesnt reset on quit to menu
}

startup {
	settings.Add("allsplit", true, "Split upon completion of every level");
	settings.SetToolTip("allsplit", "Disabling this option will still split at the end of the run, just not in the middle.");
}

start {
	//start on entering the first level
	//i could not for the life of me find an address for being in the main menu 
	//so instead i start when the first textbox appears in the first level
	//this can cause issues if the runner resets on the first level and then brings up a textbox in the main menu
	//but it's a very rare edge case and honestly i cant be bothered 
	//todo: get first level name for new challenges
	
	if (current.levName == "Cleaning" && current.isTB == 1 && old.isTB == 0) {
		return true;
	}
}

split {

	//split for every level
	if (settings["allsplit"] == true) {
		if (current.endTB == 1 && old.endTB == 0) {
			return true;
		}
	}
	
	//if the setting is disabled, only split for the final level
	//todo: get the name of the final level from new challenges
	
	else if (settings["allsplit"] == false) {
		if (current.levName == "The End" && current.endTB == 1 && old.endTB == 0) {
			return true;
		}
	}
}

reset {
	//reset when going into the first level from not the first level
	//todo: figure out some logic in case the runner resets on the first level
	
	if (current.levName == "Cleaning" && old.levName != "Cleaning") {
		return true;
	}
}
