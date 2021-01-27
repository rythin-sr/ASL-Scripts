//someone get me the german 1.0 retail so i can support that too

state("cm2", "Steam") {
	
	//different values depending on game state, most importantly:
	//8 in loads
	//16 in profile select
	//-116 in experiment complete screen
	//-88 in experiments
	//64 in the main menu from profile select, 28 otherwise
	sbyte state:	"cm2.dll", 0x1FFF74, 0x18;
	
	//current chapter you're in - 1 (so 0 for 1-7, 3 for 4-2 etc)
	int chapter:	"faktum.dll", 0x30ACA4, 0x10, 0x174;
	
	//current level you're in - 1 (so 1 for 1-2, 2 for 1-3 etc)
	int level:	"faktum.dll", 0x30ACA4, 0x10, 0x178;
}

startup {
	for (int i = 0; i < 11; i++) {
		settings.Add("ch" + i.ToString(), true, "Chapter " + (i + 1).ToString());
		for (int j = 0; j < 10; j++) {
			settings.Add(i.ToString() + "-" + j.ToString(), true, (i + 1).ToString() + "-" + (j + 1).ToString(), "ch" + i.ToString());
		}
	}
	
	vars.done = new List<string>();
}

start {
	if (current.level == 0 && current.chapter == 0 && current.state != 8 && old.state == 8) {
		vars.done.Clear();
		return true;
	}
}

split {
	if (current.state == -116 && current.state != old.state) {
		vars.done.Add(current.chapter.ToString() + "-" + current.level.ToString());
		return settings[current.chapter.ToString() + "-" + current.level.ToString()];
	}
}

reset {
	return current.state == 16;
}

isLoading {
	return current.state == 8;
}
