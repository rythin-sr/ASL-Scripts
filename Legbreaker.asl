//Autosplitter for Legbreaker by rythin

state("Legbreaker") {
	int roomID: 0x01A71CC8, 0xE8, 0x3D8, 0x148, 0x50, 0x18;
//											            LEVEL IDs
//
//	|  STAGE 1	|	 STAGE 2	|	 STAGE 3	|	 STAGE 4	|	 STAGE 5	|	 STAGE 6	|
//L1|	   170   	|	   119		|	   147		|	   174		|	   181		|	   169		|
//L2|	   175  	|	   170		|	   189		|	   132		|	   167		|	   162		|
//L3|	   172  	|	   134		|	   188		|	   128		|	   142		|	   144		|
//L4|	   181  	|	   137		|	   189		|	   190		|	   131		|	   198		|
//L5|	   148	  |	   154		|	   199		|	   164		|	   169		|	   115		|

//game tends to have an aneurysm on level transitions or room resets which makes the roomID jump up to like 200 or 300-something
//it happens seemingly randomly and isn't consistent at all
}

init {
	vars.realCurrent = 170;
	vars.realOld = 0;
}

startup {
	settings.Add("areasplit", true, "Split between 'areas' (where new obstacles are added)");
	settings.Add("levelsplit", false, "Split between levels (may very rarely split on death/reset)");
}	

update {
	//logic for determining the real room IDs
	//for the record i tried just doing roomID < 200 but it didnt seem to work so thats loads of fun
	
	if (old.roomID == 170 || old.roomID == 175 || old.roomID == 172 || old.roomID == 181
	 || old.roomID == 148 || old.roomID == 119 || old.roomID == 134 || old.roomID == 154
	 || old.roomID == 147 || old.roomID == 189 || old.roomID == 188 || old.roomID == 199
	 || old.roomID == 174 || old.roomID == 132 || old.roomID == 128 || old.roomID == 190
	 || old.roomID == 164 || old.roomID == 167 || old.roomID == 142 || old.roomID == 131
	 || old.roomID == 169 || old.roomID == 162 || old.roomID == 144 || old.roomID == 198
	 || old.roomID == 115 || old.roomID == 137 || old.roomID == 0   || old.roomID == 143) {
		vars.realOld = old.roomID;
	}
	
	if (current.roomID == 170 || current.roomID == 175 || current.roomID == 172 || current.roomID == 181
	 || current.roomID == 148 || current.roomID == 119 || current.roomID == 134 || current.roomID == 154
	 || current.roomID == 147 || current.roomID == 189 || current.roomID == 188 || current.roomID == 199
	 || current.roomID == 174 || current.roomID == 132 || current.roomID == 128 || current.roomID == 190
	 || current.roomID == 164 || current.roomID == 167 || current.roomID == 142 || current.roomID == 131
	 || current.roomID == 169 || current.roomID == 162 || current.roomID == 144 || current.roomID == 198
	 || current.roomID == 115 || current.roomID == 137 || current.roomID == 0   || current.roomID == 143) {
		vars.realCurrent = current.roomID;
	}
}

start {
	return (old.roomID == 5398 && current.roomID != old.roomID);
}

split {
	//area splits
	if (settings["areasplit"] == true) {															
		if (vars.realCurrent != vars.realOld && vars.realOld == 0 && vars.realCurrent != 170) {		//dialogue-based area changes
			return true;	
		}
		
		if (vars.realOld == 143 && vars.realCurrent == 169) {										//final area entrance
			return true;
		}
	}
	
	//level splits
	if (settings["levelsplit"] == true && vars.realCurrent != vars.realOld && vars.realOld != 0 && vars.realCurrent != 0) {
		return true;
	}
	
	//final split
	if (old.roomID == 143 && current.roomID == 0 || old.roomID == 115 && current.roomID == 0) {	
		return true;
	}
}
