//Nuclear Throne Autosplitter by Gelly and rythin
//Honestly it was just Gelly i barely did anything here

state("nuclearthrone") {
	byte gameLoading:	0x74C6746;
}

//				SPLIT NUMBERS IN THE SAVEFILE THING WHO KNOWS FUCK YOU ERO
//Character		|	Run count		|	Win count
//1			|	68			|	79
//2			|	154			|	166
//3			|	240			|	252
//4			|	326			|	338
//5			|	411			|	424
//6			|	498			|	510
//7			|	586			|	598
//8			|	672			|	684
//9			|	758			|	770
//10			|	844			|	856
//11			|	930			|	942
//12			|	1016			|	1028
//13			|	1102			|	1114
//14			|	1188			|	1200
//15			|	1274			|	1286
//16			|	1360			|	1372
//17			|	1446			|	1458

init {
	vars.reader = new StreamReader(new FileStream((Environment.GetEnvironmentVariable("appdata"))+"\\..\\Local\\nuclearthrone\\nuclearthrone.sav", FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
	//in order to keep track of the history of the runs/wins
	//we need a current array and an old array keeping track
	vars.runValues = new double[17];
	vars.oldrunValues = new double[17];
	vars.winValues = new double[17];
	vars.oldwinValues = new double[17];
	vars.line = "";
	vars.runStrings = new String[1];
	vars.winStrings = new String[1];
	vars.runDelim = new String[] {"\"ctot_runs\" "};
	vars.winDelim = new String[] {"\"ctot_wins\" "};
}

update {
	if(vars.reader == null) return false;
	
	//read the line from the reader
	vars.line = vars.reader.ReadLine();
	//split it up based on wins/reads
	if(vars.line!=null){
	vars.runStrings = vars.line.Split(vars.runDelim,StringSplitOptions.None);
	vars.winStrings = vars.line.Split(vars.winDelim,StringSplitOptions.None);
	print(vars.runStrings.Length.ToString());
	
	//17 total win/runs to go through
	for(int i = 0; i < 17; i++){
		//first, maintain the history
		vars.oldrunValues[i] = vars.runValues[i];
		vars.oldwinValues[i] = vars.winValues[i];
		//then, get the new values from vars.reader
		vars.runValues[i] = Double.Parse(vars.runStrings[i+1].Split(',')[0]);
		vars.winValues[i] = Double.Parse(vars.winStrings[i+1].Split(',')[0]);
	}
	}
	//then, reset the save file reader
	vars.reader.DiscardBufferedData();
	vars.reader.BaseStream.Seek(0, System.IO.SeekOrigin.Begin);
}

exit {
    vars.reader = null;
}

start {
	return (current.gameLoading == 0 && old.gameLoading == 8);
}

reset {
	double d = 0.0;
	for(int i = 0; i < 17; i++){
		d += vars.runValues[i] - vars.oldrunValues[i];
	}
	return (d>0.0);
}

split {
	double d = 0.0;
	for(int i = 0; i < 17; i++){
		d += vars.winValues[i] - vars.oldwinValues[i];
	}
	return (current.gameLoading == 0 && old.gameLoading == 8) || 
		   (d>0.0);
}

isLoading {
	return current.gameLoading == 8;
}
