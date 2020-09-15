state("ChildofLight") {
	int gameLoading: 0x9D88E8;
}

isLoading {
	return current.gameLoading != 0;
}

exit {
	timer.IsGameTimePaused = true;
}
