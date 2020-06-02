state("CloverIsland-Win64-Shipping") {

	byte counter:	0x26458A0;
}

startup {
	vars.h = 0;			//used for isLoading logic
	vars.L = 0;			//for some split logic dependant on loads
	
	refreshRate = 15;
}

update {
	//logic for determining when the game is loading
	//this could be in isLoading, but i figured it may be useful in the future for autosplitting or some such
	if (old.counter == current.counter) {	//when the value stops updating
		vars.h = current.counter;			//set h to that value	
		Thread.Sleep(10);					//wait 10ms
		if (vars.h == current.counter) {	//if the value is still the same
			vars.L = 1;
		}
		
		else if (current.counter == vars.h + 2) {	//sometimes the value can advance by 2 during loads
			vars.L = 1;
		}
		
		else {
			vars.L = 0;
		}
	}
		
	else {
		vars.L = 0;
	}
}

isLoading {
	return (vars.L == 1);
}
