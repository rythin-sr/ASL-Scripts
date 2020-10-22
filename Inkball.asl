state("inkball") {
	int score:	0xAEFC0, 0x280, 0x2F8, 0xDF0;
	int room:	0xAEF38;
	//int score 0xAFFD4, 0x8, 0x668, 0x1D0, 0x1D0, 0xAF8;
}

startup {
	refreshRate = 100;

	settings.Add("10k", true, "10000");
	settings.Add("100k", true, "100000");
}

start {
	return (current.score == 0 && old.room != current.room);
}

split {
	if (current.score >= 10000 && old.score < 10000) {
		return settings["10k"];
	}
	
	if (current.score >= 100000 && old.score < 100000) { 
		return settings["100k"];
	}
}

reset {
	return (current.score == 0 && old.room != current.room);
}
