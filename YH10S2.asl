state("You Have 10 Seconds 2 Steam Release", "yh10s2") {
	  int roomID: 		0x59C310;
	  double y2IGT:		0x0059C34C, 0x80, 0x13C, 0x13C, 0x4, 0x20;	//built in IGT per area
	  int whiteFade:		0x00399F04, 0x0, 0x1E8, 0xC, 0xB4;		//0 when gameplay, 1 when fading to white between levels
	  int inMenu:		0x34D5D0;					//1065353216 when in menu, 1061997773 otherwise?
}

init {
    vars.IGTfinal = 0;			//final IGT displayed
    vars.areaIGT = 0;		  	//basically current.y2IGT but without 0
		vars.IGT = 0;				    //sum of IGT from the previous levels
	  vars.areaEndTransition = 0;
	  vars.timerPausedRoom = 0;
}

update {
  if (old.roomID != current.roomID) { 
			if (current.roomID == 30 || current.roomID == 41 || current.roomID == 52 ||
			current.roomID == 63 || current.roomID == 74 || current.roomID == 85 ||
			current.roomID == 96 || current.roomID == 107 || current.roomID == 118 ||
			current.roomID == 129 ||  current.roomID == 140) {
			vars.areaEndTransition = 1;
			}
		}
	
		else {
			vars.areaEndTransition = 0;
		}
	
		if (current.roomID == 30 || current.roomID == 41 || current.roomID == 52 ||
		current.roomID == 63 || current.roomID == 74 || current.roomID == 85 ||
		current.roomID == 96 || current.roomID == 107 || current.roomID == 118 ||
		current.roomID == 129 || current.roomID == 140 || current.roomID == 6 || current.roomID == 7) {
			vars.timerPausedRoom = 1;
		}

		else {
			vars.timerPausedRoom = 0;
		}
		//the ugly mess above was cleaned up a little bit thanks to KikooDX's help <3
		
		if (current.y2IGT != 0) {			//IGT resets to 0 every screen transition, this is just to avoid that on the splits
			vars.areaIGT = current.y2IGT;	
		}
	
		if (vars.areaEndTransition == 1) {		//since IGT resets every area, we need to sum it up to get the final run time
			vars.IGT = vars.IGT + vars.areaIGT;
		}
	
		if (vars.timerPausedRoom == 1) {		//when in X-11 or hub, display the sum of times of the previous areas 
			vars.IGTfinal = vars.IGT;
		}
	
		if (vars.timerPausedRoom == 0) {		//when in an area, display the above + current IGT of the area
			vars.IGTfinal = vars.IGT + vars.areaIGT;
		}
	
		if (current.roomID == 6) {			//reset current IGT when in the hub, otherwise it flickers when entering the next area
			vars.areaIGT = 0;
		}
  }
	
	start {
		if (current.inMenu == 1061997773 && old.inMenu == 1065353216) {		//this address is jank as fuck but hey it works lol
			return true;
			vars.IGTfinal = 0;
		}
	}
	
	isLoading {
		return truel
	}
	
	gameTime {
		return TimeSpan.FromSeconds(vars.IGTfinal);
	}
	
	
