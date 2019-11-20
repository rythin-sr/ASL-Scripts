state("FEAR2") {
	int gameLoading: 0x32E2E8;
	int gameLoading2: 0x2F4D70;
}

isLoading {
	return (current.gameLoading != 0 && current.gameLoading2 == 0);
}