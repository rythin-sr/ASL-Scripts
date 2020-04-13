//Risk of Rain 2 Autosplitter + Load Remover by rythin
//Huge shoutout to Ero for teaching me how to use Unity output logs for this
//Also the Untitled Goose Game community and their autosplitter which I heavily based this off of
//(while still managing to make it look like it was coded by a 3 year old)

state("Risk of Rain 2") {

}

startup {
	settings.Add("teleS", false, "Split when activating the Teleporter");
	settings.Add("levS", true, "Split when changing level");
	settings.Add("bazaarS", false, "Split upon entering the Bazaar", "levS");
}

init {
	//yea i have no idea what this does but UGG does this and it works here too so ill take it
	string logPath = Environment.GetEnvironmentVariable("appdata")+"\\..\\LocalLow\\Hopoo Games, LLC\\Risk of Rain 2\\output_log.txt";
	try {
		FileStream fs = new FileStream(logPath, FileMode.Open, FileAccess.Write, FileShare.ReadWrite);
		fs.SetLength(0);
		fs.Close();
	} catch {
		print("Cant open ror2 log");
	}
	vars.line = "";
	vars.reader = new StreamReader(new FileStream(logPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
	
	vars.loading = false;
	vars.curLev = "";
	vars.oldLev = "";
	vars.runStarted = false;
	vars.firstsList = new List<string>();
	string[] firsts = { "golemplains", "golemplains2", "blackbeach", "blackbeach2" };
}

update {
	if (vars.reader == null) return false;
	vars.line = vars.reader.ReadLine();
	
	
	if (vars.line != null) {
	
		if (vars.line.StartsWith("Unloaded scene")) {
			vars.loading = true;
		}
	
		if (vars.line.StartsWith("Client ready")) {
			vars.loading = false;
		}
		
		if (vars.line.StartsWith("Active scene changed")) {
			vars.curLev = vars.line.Split(' ')[6];
		}
		
		if (vars.runStarted == false && vars.curLev != "lobby" && vars.curLev != "title") {
			vars.runStarted = true;
			vars.oldLev = vars.curLev;
		}
		
		//if (vars.curLev != vars.oldLev) {
		//	print("OLD:"+vars.oldLev.ToString()+"CUR:"+vars.curLev.ToString());
		//}

	}
}

split {
	//level splits
	if (settings["levS"]) {
		if (vars.curLev != vars.oldLev && vars.curLev != "" && vars.oldLev != "") {			
			if (vars.curLev != "bazaar" && !settings["bazaarS"]) {
				vars.oldLev = vars.curLev;
				return true;
			}
			
			if (settings["bazaarS"]) {
				vars.oldLev = vars.curLev;
				return true;
			}
		}
	}
	
	//tele splits
	if (settings["teleS"]) {
		if (vars.line != null && vars.line.StartsWith("<style=cEvent>You activated the <style=cDeath>Teleporter")) {
			return true;
		}
	}
	
	//final split
	if (vars.line != null && vars.line.StartsWith("Parent of RectTransform is being set") && vars.curLev == "mysteryspace") {
		return true;
	}
}
		
start {
	if (vars.curLev == "golemplains" || vars.curLev == "golemplains2" || vars.curLev == "blackbeach" || vars.curLev == "blackbeach2") {
		vars.oldLev = vars.curLev;
		return true;
	}
}
		
reset {
	return (vars.curLev == "title" || vars.curLev == "lobby");
}
		
isLoading {
	return vars.loading;
}

exit {
	vars.reader = null;
}
