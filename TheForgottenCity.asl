state("ModernStoryteller01-Win64-Shipping") {
	string100 text:   0x480BB60, 0xE8, 0x0;
	float load_angle: 0x483E610, 0x118, 0x3B8, 0x260, 0x7C;
	float x:          0x4831628, 0x0, 0x20, 0x5A8, 0x1D0;
	float y:          0x4831628, 0x0, 0x20, 0x5A8, 0x1D4;
	float z:          0x4831628, 0x0, 0x20, 0x5A8, 0x1D8;
}

start {
	return current.x < -29685.7 && current.y < -11915.5 && old.x == 0f;
}

split {
	return current.text != old.text && current.text.Contains("ENDING");
}

isLoading {
	if (current.load_angle != old.load_angle || current.load_angle == 0.0f) {
		return true;
	}
	
	if (current.x != old.x || current.y != old.y || current.z != old.z) {
		return false;
	}
}
