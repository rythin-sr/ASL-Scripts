state("GothicMod") {
	long igt:	"ZSPEEDRUNTIMER.DLL", 0x17BD0;	//milliseconds of the timer from the in game timer mod used by the community
	float xPos:	0x46A5FC;	//player position
	float yPos:	0x46A604;
	float zPos:	0x46A60C;
	int area:	0x46A0B8;	//1 for overworld, 4 for orc temple
	int fmv_s:	0x4DDF90;	//goes from 0 to some high number in the starting fmv
	int end:	0x4DBCA8;	//1 in the final fmv, seems to flicker to 1 occasionally when piercing hearts
}

startup {
	
	var tB = (Func<float, float, int, float, float, int, int, Tuple<float, float, int, float, float, int, int>>) ((elmt1, elmt2, elmt3, elmt4, elmt5, elmt6, elmt7) => { return Tuple.Create(elmt1, elmt2, elmt3, elmt4, elmt5, elmt6, elmt7); });
	vars.endCheck = new Stopwatch();
	
	//this script works with 2 kinds of splits:
	//1. area transition based split that activates on changing areas defined by the game
	//2. zone based splits that happen upon entering a pre-defined area
	//you can configure your own splits by editing the List below,
	//you can find your desired coordinates by putting the addresses from above into Cheat Engine
	//the explanation of what field does what can be found below
	//splits must be listed in order
	//setting x_upper to 0 will make the split be an area-based split rather than a zone-based one
	
	vars.splitData = new List<Tuple<float, float, int, float, float, int, int>> {
        tB(3500, 3200, 0, 31800, 31700, -1, 1), //example split, activating when crossing the gate at the start of the game
        tB(0, 0, 0, 0, 0, 0, 4)    		//example split, activating when entering the temple
        
        //x_upper, x_lower, x_dir, y_upper, y_lower, y_dir, area
		
		//x_lower and y_lower indicate the lower coordinates of the split zone
		//x_upper and y_upper indicate the upper coordinates of the split zone
		//x_dir and y_dir indicate the direction you're coming at the split zone:
		//1 meaning you're moving in such a way that the coordinate is increasing
		//-1 meaning that you're moving in such a way that the coordinate is decreasing
		//0 disabling that direction entirely
		
		//area indicates the area in the game that the split should be occuring in
		//unless the split zone is set to 0, in which case it will split on entry to the given area
    
    		//make sure each entry in the list has a comma (,) at the end of it, EXCEPT for the final entry
		//the split list is in order, meaning that, for example, the second condition will only activate on the second split in your run
		//if you intend to have manual splits make sure to account for them here, for example by having a condition that will never be met
		//in place of your manual split
	};
}

start {
	return current.igt > 0 && old.igt == 0;
}

split {
	
	if (timer.CurrentSplitIndex <= vars.splitData.Count - 1) {
	
		var split = vars.splitData[timer.CurrentSplitIndex];
	
		if (split.Item1 == 0) {
			return current.area == split.Item7 && old.area != current.area;
		}
		else {
			if (current.area == split.Item7) {
				if (current.xPos >= split.Item2 && current.xPos < split.Item1 && current.yPos >= split.Item5 && current.yPos < split.Item4 && 
				(old.xPos < split.Item2 || old.xPos > split.Item1 || old.yPos < split.Item5 || old.yPos > split.Item4)) {
					if ((split.Item3 > 0 && old.xPos < split.Item2) ||
					(split.Item3 < 0 && old.xPos > split.Item1) ||
					(split.Item6 > 0 && old.yPos < split.Item5) ||
					(split.Item6 < 0 && old.yPos > split.Item4)) {
						//print("\nx: " + old.xPos.ToString() + " -> " + current.xPos.ToString() + " - " + split.Item3.ToString() +
						//"\ny: " + old.yPos.ToString() + " -> " + current.yPos.ToString() + " - " + split.Item6.ToString());
						return true;
					}
				}
			}
		}
	}
	
	//general final split condition for all categories
	if (timer.CurrentSplitIndex == timer.Run.Count - 1 && vars.splitData.Count < timer.Run.Count) {
		if (current.area == 4 && current.end == old.end + 1) {
			vars.endCheck.Restart();
		}
	}
	
	if (vars.endCheck.ElapsedMilliseconds >= 150 && current.end == 1) {
		vars.endCheck.Reset();
		return true;
	}
}

reset {
	return current.igt == 0 && old.igt > 0;
}

isLoading {
	return true;
}

gameTime {
	return TimeSpan.FromMilliseconds(current.igt);
}
