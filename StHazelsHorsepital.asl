//St. Hazel's Horsepital Autosplitter + Load Remover by rythin

state("St. Hazel's Horsepital") {

}

init {


	string logPath = Environment.GetEnvironmentVariable("appdata")+"\\..\\LocalLow\\Hyph-n\\St. Hazel's Horsepital\\output_log.txt";
	try {
		FileStream fs = new FileStream(logPath, FileMode.Open, FileAccess.Write, FileShare.ReadWrite);
		fs.SetLength(0);
		fs.Close();
	} catch {
		print("Cant open horsepital log");
	}
	vars.line = "";
	vars.reader = new StreamReader(new FileStream(logPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
	
	vars.loading = false;
	string[] levels = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28"};
	vars.levList = new List<string>();
	vars.levList.AddRange(levels);
	vars.oldLev = "1";

}

update {
	if (vars.reader == null) return false;
	vars.line = vars.reader.ReadLine();
	
	if (vars.line != null) {
		//determine loading states
		if (vars.line.StartsWith("Unloading ")) {
			vars.loading = true;
		}

		if (vars.line.StartsWith("Total:")) {
			vars.loading = false;
		}
	}
}

start {
	if (vars.line != null) {
		if (vars.line == "1") {		//if on the first level
			vars.loading = false;	//there's been issues with the timer not running on the first level so this is a precaution to hopefully prevent that
			vars.oldLev = "1";		//set this back to 1 for splitting purposes
			return true;			//start
		}
	}	
}

split {
	if (vars.line != null) {
		if (vars.levList.Contains(vars.line)) {		//if the output log has a line that's the same as one of the levels
			if (vars.line != vars.oldLev) {			//and the level on that line is different from the previous level
				vars.oldLev = vars.line;			//set oldLev to the current level in preparation for the next split and to prevent splitting on retry
				return true;						//split
			}
		}
	}
}

reset {
	if (vars.line != null) {
		return vars.line == "0";		//reset in menu
	}	
}

isLoading {
	return vars.loading;
}

exit {
	vars.reader = null;
}