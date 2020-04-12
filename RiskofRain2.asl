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
	
	vars.teleSplit = false;
	vars.levelSplit = false;
	vars.finalSplit = false;
	
	vars.start = false;
	vars.reset = false;
}

update {
	if (vars.reader == null) return false;
	vars.line = vars.reader.ReadLine();
	
	//pretty sure there's a better way to do this and i might rewrite this script if i figure out what that better way is
	//for now this works and i understand it so i mean, we take those
	if (vars.line != null) {
		if (vars.line.StartsWith("Parent of RectTransform is being set")) {
			vars.finalSplit = true;
		}
	
		if (vars.line.StartsWith("Object PodGroundImpact") && !vars.line.StartsWith("Active scene changed from  to title")) {
			vars.start = true;
		}
	
		if (vars.line.StartsWith("Active scene changed") && !vars.line.StartsWith("Active scene changed from  to title")) {
			if (!vars.line.StartsWith("Active scene changed from  to bazaar")) {
				if (settings["levS"]) {
					vars.levelSplit = true;
				}
			}	
		}
	
		if (vars.line.StartsWith("Active scene changed from  to bazaar") && settings["bazaarS"]) {
			vars.levelSplit = true;
		}
	
		if (vars.line.StartsWith("<style=cEvent>You activated the <style=cDeath>Teleporter") && settings["teleS"]) {
			vars.teleSplit = true;
		}
	
		if (vars.line.StartsWith("Unloaded scene")) {
			vars.loading = true;
		}
	
		if (vars.line.StartsWith("Client ready")) {
			vars.loading = false;
		}
	
		if (vars.line.StartsWith("<style=cDeath>") || vars.line.StartsWith("Active scene changed from  to title")) {
			vars.reset = true;
		}
	}
}

split {
	if (vars.teleSplit) {
		vars.teleSplit = false;
		return true;
	}
	
	if (vars.levelSplit) {
		vars.levelSplit = false;
		return true;
	}
	
	if (vars.finalSplit) {
		vars.finalSplit = false;
		return true;
	}
}

start {
	if (vars.start) {
		vars.start = false;
		vars.finalSplit = false;
		vars.levelSplit = false;
		vars.teleSplit = false;
		return true;
	}
}

reset {
	if (vars.reset) {
		vars.reset = false;
		return true;
	}
}

isLoading {
	return vars.loading;
}

exit {
	vars.reader = null;
}