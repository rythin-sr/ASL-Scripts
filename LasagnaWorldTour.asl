//Garfield: Lasagna World Tour Autosplitter by rythin

state("Garfield", "International") {
	//string with some file path, includes the map name which is the important part
	string30 map:		0x1685E7;
	
	//different numbers in different menus, seems to be consistently 86 on the "new game" selection menu
	byte menuState:		0x1094EC;
	
	//final boss hp
	float boss:		0x00126A34, 0x308;
}

state ("Garfield", "Russian") {
	string30 map:		0x16BD0F;
	byte menuState:		0x10CC1C;
	float boss:		0x0012A154, 0x308;
}

startup {

	vars.d = new Dictionary<string, string> {
		{@"Single\Level_01\Level_01.ins", "Downtown"},
		{@"Single\Race_01\Race_01.ins", "Chase 1"},
		{@"Single\Level_04\Level_04.ins", "Egypt 1"},
		{@"Single\Level_05\Level_05.ins", "Egypt 2"},
		{@"Single\Race_02\Race_02.ins", "Chase 2"},
		{@"Single\Level_27\Level_27.ins", "Mexican City 1"},
		{@"Single\Level_08\Level_08.ins", "Mexican City 2"},
		{@"Single\Level_09\Level_09.ins", "Venice 1"},
		{@"Single\Level_10\Level_10.ins", "Venice 2"},
		{@"Single\Level_02\Level_02.ins", "Downtown Redux"},
	};
	
	foreach (var Tag in vars.d) {							
		settings.Add(Tag.Key, true, Tag.Value);				
    };
	
	vars.doneSplits = new List<string>();	
	refreshRate = 30;
}

init {

	if (modules.First().ModuleMemorySize == 2084864) {
		version = "Russian";
	}
	
	else if (modules.First().ModuleMemorySize == 2068480) {
		version = "International";
	}
	
	//print(modules.First().ModuleMemorySize.ToString()); 
}

start {
	if (current.map == @"Level_00\Level_00.ins" && current.menuState < old.menuState && old.menuState == 86) {
		vars.doneSplits.Clear();
		return true;
	}
}

split {
	//level splits
	if (current.map != old.map && current.map != @"Level_00\Level_00.ins" && settings[old.map] && !vars.doneSplits.Contains(old.map)) {
		vars.doneSplits.Add(old.map);
		return true;
	}
	
	//final split
	if (current.map == @"Single\Boss\Boss.ins" && current.boss == 0 && old.boss == 1) {
		return true;
	}
}

reset {
	if (current.map == @"Level_00\Level_00.ins" && old.map != current.map) {
		return true;
	}
}
