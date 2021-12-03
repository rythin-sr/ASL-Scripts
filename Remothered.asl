state("Remothered-Win64-Shipping") {
	bool load_done: 0x296D920, 0xF0, 0x700, 0x318;
	bool loading:   0x296D920, 0xF0, 0x700, 0x338;
}

start {
	return current.load_done && !current.loading && old.loading;
}

isLoading {
	return current.loading;
}
