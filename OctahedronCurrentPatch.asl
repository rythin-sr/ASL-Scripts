// Octahedron Autosplitter + Game Time by rythin
// Contact info:
// Discord - rythin#0135
// Twitter - @rythin_sr
// Twitch - rythin_sr

state("octahedron") {
	int levelID: 		0x1757DF0;
	int livesCount: 	0x1A17658;
	double IGT: 		0x17E5CA8;
	int finishCounter: 	0x1A14A94;
}

start {
	return (current.levelID == 30);
}

split {
	return (old.finishCounter != current.finishCounter);
}

gameTime {
	return TimeSpan.FromSeconds(current.IGT / 10);
}
