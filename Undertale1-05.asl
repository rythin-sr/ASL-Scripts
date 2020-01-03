// Undertale 1.05 Autosplitter made by rythin
// Contact: twitch.tv/rythin_sr | twitter.com/rythin_sr | Discord: rythin#0135
// ToDo: 
// -Add splits for areas and enemies specific to categories other than Neutral
// -Add a kill counter for Geno (done)
// -Make it work on 1.0/1.001
//
// Changelog:
// 1.0 - initial release 
// 1.1 - added kill counter (code yoinked from the Super Meat Boy autosplitter, thanks -7!)

state("UNDERTALE") {
	int roomID: 0x618EA0;
	int gameState: 0x3B54D4;
}
	
startup {
	vars.undyneSplit = 0; //variable to disable the split on the room transition after undyne after the first time
	
	settings.Add("bossSplits", false, "Boss/Miniboss Splits");
	settings.Add("areaSplits", false, "Area Splits");
	settings.Add("miscSplits", false, "Misc. Splits");
	//main settings groups
	
	settings.Add("Napstablook", false, "Napstablook", "bossSplits");
	settings.Add("Toriel", false, "Toriel", "bossSplits");
	settings.Add("Papyrus", false, "Papyrus", "bossSplits");
	settings.Add("PapyrusShed", false, "Split when going to Papyrus' shed", "Papyrus");
	settings.Add("Dummy", false, "Mad Dummy", "bossSplits");
	settings.Add("Undyne", false, "Undyne", "bossSplits");
	settings.Add("Muffet", false, "Muffet", "bossSplits");
	settings.Add("Mettaton", false, "Mettaton", "bossSplits");
	settings.Add("Asgore", false, "Asgore", "bossSplits");
	settings.Add("lDog", false, "Lesser Dog", "bossSplits");
	settings.Add("dDog", false, "Dogi", "bossSplits");
	settings.Add("bDog", false, "Greater Dog", "bossSplits");
	//settings for bosses and minibosses
	
	settings.Add("snowdin", false, "Enter Snowdin", "areaSplits");
	settings.Add("hotlands", false, "Enter Hotlands", "areaSplits");
	settings.Add("eLab", false, "Enter Alphys' Lab", "areaSplits");
	settings.Add("lLab", false, "Leave Alphys' Lab", "areaSplits");
	settings.Add("core", false, "Enter Core", "areaSplits");
	//settings for area based splits
	
	settings.Add("icePuzzle", false, "Ice Puzzle", "miscSplits");
	settings.Add("punchCard", false, "Punch Card Pickup", "miscSplits");
	settings.Add("onion", false, "Onion-San Dialogue", "miscSplits");
	settings.Add("2dshit", false, "2D Castle Background Room", "miscSplits");
	settings.Add("awake", false, "Waking up after Undyne chase", "miscSplits");
	settings.Add("mKid", false, "Last Monster Kid encounter", "miscSplits");
	settings.Add("pan", false, "Pan Pickup", "miscSplits");
	settings.Add("ewSkip", false, "East-West Puzzle Skip", "miscSplits");
	settings.Add("cmSkip", false, "Jetpack", "miscSplits");
	settings.Add("tButton", false, "Triple Button sequence w/ Alphys phonecall", "miscSplits");
	settings.Add("ventJump", false, "Vent Longjump after triple button", "miscSplits");
	settings.Add("rgSkip", false, "Royal Guards Skip", "miscSplits");
	settings.Add("bnSkip", false, "Breaking News Skip", "miscSplits");
	settings.Add("nsSkip", false, "North-West Puzzle Skip", "miscSplits");
	settings.Add("pSkip", false, "Play Skip", "miscSplits");
	settings.Add("cfSkip", false, "Core Fight Skip", "miscSplits");
	settings.Add("cPuzzle", false, "Core Puzzle", "miscSplits");
	settings.Add("kKey", false, "Key in the kitchen", "miscSplits");
	settings.Add("hKey", false, "Key in the hallway", "miscSplits");
	settings.Add("monstertale", false, "Monstertale Done", "miscSplits");
	settings.Add("SNAS", false, "Sans Judgement Skip", "miscSplits");
	//settings for other, misc stuff

	vars.SetTextComponent = (Action<string, string>)((id, text) =>
	{
		var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
		var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
		if (textSetting == null)
		{
			var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
			var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
			timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

			textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
			textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
		}

		if (textSetting != null)
			textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
	});
}

init {
// Code to execute on timer start
	vars.timer_OnStart = (EventHandler)((s, e) =>
	{
		// Set death count normalization on timer start
		if (settings["killDisp"])
		{
			vars.killCountOffset = old.killCount;
			vars.SetTextComponent("Kills", (current.killCount - vars.killCountOffset).ToString());
		}
	});
	timer.OnStart += vars.timer_OnStart;
	
	// Initialize kill count
	if (settings["killDisp"])
	{
		vars.SetTextComponent("Kills", current.killCount.ToString());
		vars.killCountOffset = 0; // Used to store death count on timer start, for normalization
	}
}
	
update {
	// Update kill count	
	if (
		settings["killDisp"]
		&& current.killCount > old.killCount
		&& (
			timer.CurrentPhase != TimerPhase.Ended // The run must not be finished
		)
		
	)
	{
		vars.SetTextComponent("Kills", (current.killCount - vars.killCountOffset).ToString());
	}
}

	
start {
	return (old.gameState == 3 && current.gameState == 4);
}

split { 

	if (settings["miscSplits"] == true) {
	
		if (current.roomID == 66 && old.roomID == 63 && settings["icePuzzle"] == true) {
			return true;
		}
		
		if (current.roomID == 95 && old.roomID == 96 && settings["punchCard"] == true) {
			return true;
		}
			
		if (current.roomID == 101 && old.roomID == 100 && settings["onion"] == true) {
			return true;
		}	
	
		if (current.roomID == 109 && old.roomID == 108 && settings["2dshit"] == true) {
			return true;
		}
	
		if (current.roomID == 133 && old.roomID == 132 && settings["mKid"] == true) {
			return true;
		}
		
		if (current.roomID == 145 && old.roomID == 146 && settings["pan"] == true) {
			return true;
		}
		
		if (current.roomID == 153 && old.roomID == 148 && settings["ewSkip"] == true) {
			return true;
		}
		
		if (current.roomID == 155 && old.roomID == 154 && settings["cmSkip"] == true) {
			return true;
		}
		
		if (current.roomID == 163 && old.roomID == 162 && settings["tButton"] == true) {
			return true;
		}
		
		if (current.roomID == 164 && old.roomID == 163 && settings["ventJump"] == true) {
			return true;
		}
		
		if (current.roomID == 166 && old.roomID == 165 && settings["rgSkip"] == true) {
			return true;
		}
		
		if (current.roomID == 167 && old.roomID == 166 && settings["bnSkip"] == true) {
			return true;
		}
		
		if (current.roomID == 176 && old.roomID == 171 && settings["nsSkip"] == true) {
			return true;
		}
		
		if (current.roomID == 181 && old.roomID == 179 && settings["pSkip"] == true) {
			return true;
		}
		
		if (current.roomID == 192 && old.roomID == 191 && settings["cfSkip"] == true) {
			return true;
		}
		
		if (current.roomID == 198 && old.roomID == 205 && settings["cPuzzle"] == true) {
			return true;
		}
		
		if (current.roomID == 221 && old.roomID == 225 && settings["kKey"] == true) {
			return true;
		}
		
		if (current.roomID == 220 && old.roomID == 222 && settings["hKey"] == true) {
			return true;
		}
		
		if (current.roomID == 231 && old.roomID == 230 && settings["monstertale"] == true) {
			return true;
		}
		
		if (current.roomID == 232 && old.roomID == 231 && settings["SNAS"] == true) {
			return true;
		}
		
		if (current.roomID == 113 && old.roomID == 112 && settings["awake"] == true) {
			return true;
		}
	
	} //all of the misc settings
	
	if (settings["bossSplits"] == true) {

		if (current.roomID == 21 && old.roomID == 19 && settings["Napstablook"] == true) {
			return true;
			}
		
		if (current.roomID == 42 && old.roomID == 41 && settings["Toriel"] == true) {
			return true;
		}
		
		if (current.roomID == 50 && old.roomID == 49  && settings["lDog"] == true) {
			return true;
		}
	
		if (current.roomID == 58 && old.roomID == 57 && settings["dDog"] == true) {
			return true;
		}
	
		if (current.roomID == 82 && old.roomID == 81 && settings["Papyrus"] == true) {
			return true;
		}
		
		if (current.roomID == 68 && old.roomID == 75 && settings["PapyrusShed"] == true) {
			return true;
		}
	
		if (current.roomID == 67 && old.roomID == 66 && settings["bDog"] == true) {
			return true;
		}
	
		if (current.roomID == 116 && old.roomID == 115 && settings["Dummy"] == true) {
			return true;
		}
	
		if (current.roomID == 138 && old.roomID == 137 && vars.undyneSplit == 0 && settings["Undyne"] == true) {
			vars.undyneSplit = 1;
			return true;
		}
	
		if (current.roomID == 178 && old.roomID == 177 && settings["Muffet"] == true) {
			return true;
		}
	
		if (current.roomID == 212 && old.roomID == 211 && settings["Mettaton"] == true) {
			return true;
		}
	
		if (current.roomID == 322 && old.roomID == 306 && settings["Asgore"] == true) {
			return true;
		}
	} //all of the boss splits
	
	if (settings["areaSplits"] == true) {
	
		if (current.roomID == 68 && old.roomID == 67  && settings["snowdin"] == true) {
			return true;
		}
		
		if (current.roomID == 137 && old.roomID == 136 && settings["hotlands"] == true) {
			return true;
		}
		
		if (current.roomID == 141 && old.roomID == 139 && settings["eLab"] == true) {
			return true;
		}
		
		if (current.roomID == 143 && old.roomID == 141 && settings["lLab"] == true) {
			return true;
		}
		
		if (current.roomID == 189 && old.roomID == 188 && settings["core"] == true) {
			return true;
		}
	} //all of the area splits

	if (current.roomID == 238 && current.gameState == 41 && old.gameState == 40) { //game end split
		return true;
	}
}
