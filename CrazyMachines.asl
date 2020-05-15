state("CrazyMachines") {
    int	endTB:			0x00112C14, 0x1D8, 0x234; //1 when a level end textbox is up, 0 otherwise
	int isTB:			0x11066C; //1 when there's a textbox on screen, 0 otherwise
	string8 levName:	0x00112C14, 0x1EC, 0xA8, 0x54, 0x834; //level name, doesnt reset on quit to menu
}

startup {
	settings.Add("allsplit", true, "Split upon completion of every level");
	settings.SetToolTip("allsplit", "Disabling this option will still split at the end of the run, just not in the middle.");
}

start {
	if (current.levName == "Cleaning" && current.isTB == 1 && old.isTB == 0) {
		return true;
	}
}

split {
	if (settings["allsplit"] == true) {
		if (current.endTB == 1 && old.endTB == 0) {
			return true;
		}
	}
	else if (settings["allsplit"] == false) {
		if (current.levName == "The End" && current.endTB == 1 && old.endTB == 0) {
			return true;
		}
	}
}

reset {
	if (current.levName == "Cleaning" && old.levName != "Cleaning") {
		return true;
	}
}