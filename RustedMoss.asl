state("Rusted_Moss") {
	int room: 0x8A4588;
}

start {
	return current.room == 19 && old.room == 1;
}

split {
	return current.room == 10 && old.room > 800;
}
