state("inkball") {
	int score:	0x0AEFC0, 0x280, 0x2F8, 0xDF0;
}

startup {
	settings.Add("10k", true, "10000");
	settings.Add("100k", true, "100000");
}

start {
	return (current.score == 0 && old.score > 0);
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
	return (current.score == 0 && old.score > 0);
}
	
	
