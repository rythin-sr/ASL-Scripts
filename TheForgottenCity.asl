/*
Update instructions:
1) Open up Ghidra
2) Analyze

Text:
	- Search for string "Slate.EnableDrawEvents", should be the DAT_{ADDRESS} two below the method that uses  it
	- Method is pretty simple to get a pattern on it.
	
Load Angle:
	- Will be in a method that uses "No world was found for object (%s) passed in toUEngine::GetWorldFromContextObject()." The first MOV from a DAT_{ADDRESS} below
	
	- Below pattern might also prove useful for location (filter out all variable things with Ghidra)
48 8b 4c 24 30 48 85 c9 74 05 e8 d3 e5 4e fe 80 7c 24 58 00 75 07 48 8b 3d 65 fd e2 01 48 8b 5c 24 60 48 8b c7 48 8b 7c 24 50 48 83 c4 40 5e

Player Coords: (DAT RIGHT BELOW FIRST FOUND ADDR)
48 8b 03 48 8d 15 62 34 fa 01 48 8b cb ff 90 78 0c 00 00 48 8b 8b 48 03 00 00 48 8d 15 4b 34 fa 01 44 0f b6 cf 0f 28 d6 48 8b 01 ff 90 70 02 00 00 8b 05 41 34 fa 01 c7 05 33 34 fa 01 00 00 00 00

*/

state("ModernStoryteller01-Win64-Shipping", "v1.1") {
	string100 text:   0x480BB60, 0xE8, 0x0;
	float load_angle: 0x483E610, 0x118, 0x3B8, 0x260, 0x7C;
	float x:          0x4831628, 0x0, 0x20, 0x5A8, 0x1D0;
	float y:          0x4831628, 0x0, 0x20, 0x5A8, 0x1D4;
	float z:          0x4831628, 0x0, 0x20, 0x5A8, 0x1D8;
}

state("ModernStoryteller01-Win64-Shipping", "v1.2.1") {
	string100 text:   0x48116e0, 0xE8, 0x0;
	float load_angle: 0x4844190, 0x118, 0x3B8, 0x260, 0x7C;
	float x:          0x48371a8, 0x0, 0x20, 0x5A8, 0x1D0;
	float y:          0x48371a8, 0x0, 0x20, 0x5A8, 0x1D4;
	float z:          0x48371a8, 0x0, 0x20, 0x5A8, 0x1D8;
}

init
{
    print("[The Forgotten City NoLoads] Module size: " + modules.First().ModuleMemorySize);
    if (modules.First().ModuleMemorySize == 80519168)
    {
        version = "v1.1";
    }
    else if (modules.First().ModuleMemorySize == 80551936)
    {
        version = "v1.2.1";
    }
}

start {
	return current.text != null && current.text.Contains("Well, it’s nice to meet you! And I’m sorry to pry,");
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
