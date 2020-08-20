//Crazy Machines Autosplitter by rythin

//Contanct info in case issues arise:
//Discord: rythin#0135
//Twitter: rythin_sr
//Twitch:  rythin_sr

//Basically i had to re-write everything because apparently pointers break after a long time for Reasons
//so from now on im only using static addresses, which severely limits what i can do with the script
//autostart is particularly annoying here, activating on ANY textbox appearance
//autosplit also fires when going back to the main menu, which is most likely preventable with some simple logic but I Do Not Want To Bother

state("CrazyMachines") {
	int 	tb:			0x11066C; 	//1 when there's a textbox on screen, 0 otherwise
	int		counter:	0x112430;	//seems to go up by 2 when level changes
}

startup {
	settings.Add("allsplit", true, "Split upon completion of every level");
	settings.SetToolTip("allsplit", "Disabling this option will still split at the end of the run, just not in the middle.");

	vars.splitCount = 0;		//for final split logic
	vars.noEarlySplit = false;	//same as above
	vars.splitTotal = 0;		//same as above
}

init {
	
}

start {
	if (current.tb == 1 && old.tb == 0) {
		if (timer.Run.CategoryName == "New Challenges") {
			vars.splitTotal = 103;
			print("CrazySplitter: Expecting 103 Levels");
		}
	
		else {
			vars.splitTotal = 102;
			print("CrazySplitter: Expecting 102 Levels");
		}
		
		vars.splitCount = 100;
		vars.noEarlySplit = false;
		return true;
	}
}

split {
	if (current.counter > old.counter) {
		vars.splitCount++;
		vars.noEarlySplit = true;
		if (settings["allsplit"]) {
			print("CrazySplitter: Transition split triggered, split count at: " + vars.splitCount.ToString());
			return true;
		}
	}
	
	
	if ((vars.splitCount == vars.splitTotal - 1) && current.tb == 1 && old.tb == 0) {
		if (vars.noEarlySplit == false) {
			print("CrazySplitter: Final split triggered");
			return true;
		}
		
		else if (vars.noEarlySplit == true) {
			print("CrazySplitter: Early split prevented!");
			vars.noEarlySplit = false;
		}
	}
}
