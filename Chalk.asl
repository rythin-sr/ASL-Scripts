state("stdrt") {
	int gameState: 0x4C660; //0 = menu, 2 = transition, 4 = gameplay
}

start {
	return (current.gameState == 4 && old.gameState != 4);
	}
	
split {
	return (current.gameState != 4 && old.gameState == 4);
	}

isLoading {
	return current.gameState == 2;
	}

