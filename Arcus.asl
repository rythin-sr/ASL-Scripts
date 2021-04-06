state("ArcherGame-Win64-Shipping") {
	bool load:     0x2BC6BF4;
	string80 text: 0x2E2F280, 0x48, 0x210, 0x0;
}

//You need to find the key to access the lift.
//...At the expense of a new beginning.

startup {
	vars.goldGet = 0;
}

start {
	timer.Run.Offset = TimeSpan.FromSeconds(0);
	
	if (!current.load && old.load && (current.text == "v1.06.4" || current.text == "Quit Game" || current.text.Contains("Deleting"))) {
		timer.Run.Offset = TimeSpan.FromSeconds(-16.71);
		return true;
	}
}

split {
	if (current.text != old.text && vars.goldGet == 0 && (current.text.Contains("Gold") || current.text.Contains("Skel Bits"))) {
		vars.goldGet = 1;
	}
	
	if (current.text != old.text && vars.goldGet == 2 && (current.text.Contains("Next") || current.text.ToLower().Contains("go back"))) {
		vars.goldGet = 0;
	}
	
	if (current.load && !old.load && vars.goldGet == 1) {
		vars.goldGet = 2;
		return true;
	}
	
	if (current.text != old.text) {
		if (current.text.Contains("You need to find the key") || 
		old.text.Contains("...At the expense of a")) {
			return true;
		}
	}
}

isLoading {
	return current.load;
}
