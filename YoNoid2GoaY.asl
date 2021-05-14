state("noid") {
	//PlayerMachine
	byte state:            "UnityPlayer.dll", 0x1446C88, 0x58, 0x98, 0x30, 0x18, 0x28, 0x10;
	float xPos:            "UnityPlayer.dll", 0x1446C88, 0x58, 0x98, 0x30, 0x1F0;
	float yPos:            "UnityPlayer.dll", 0x1446C88, 0x58, 0x98, 0x30, 0x1F4;
	float zPos:            "UnityPlayer.dll", 0x1446C88, 0x58, 0x98, 0x30, 0x1F8;
	bool dab:              "UnityPlayer.dll", 0x1446C88, 0x58, 0x98, 0x30, 0x338;
	
	//unity globals
	string20 loadedScene:  "UnityPlayer.dll", 0x1467538, 0x48, 0x40;
	string20 loadingScene: "UnityPlayer.dll", 0x1467538, 0x28, 0x0, 0x40;
	
	//BossController
	byte bosshp:           "UnityPlayer.dll", 0x1469C58, 0x8, 0x60, 0xAD8, 0x118, 0xAA;
	
	//TitleScreen
	float ConfirmTime:     "UnityPlayer.dll", 0x1469C58, 0x8, 0x8, 0x7D8, 0x158, 0xD0;
	
}

startup {
	settings.Add("IL", false, "Enable IL Mode");
	settings.Add("ILS", false, "Split according to IL timing in full-game runs");
	settings.Add("Level Completion", true);
		settings.Add("LevelIntro", true, "New York", "Level Completion");
		settings.Add("LeviLevle", true, "Swing Factory", "Level Completion");
		settings.Add("dungeon", true, "Domino Dugeon", "Level Completion");
		settings.Add("PZNTv5", true, "Plizzanet", "Level Completion");
		settings.Add("MikeLayer", true, "???", "Level Completion");
	
	settings.Add("Level Entry");
		settings.Add("eLeviLevle", false, "Swing Factory", "Level Entry");
		settings.Add("edungeon", false, "Domino Dungeon", "Level Entry");
		settings.Add("ePZNTv5", false, "Plizzanet", "Level Entry");
		settings.Add("eMikeLayer", false, "???", "Level Entry");
		
	settings.Add("Misc.");
		settings.Add("mikestart", false, "Split when starting the Mike fight", "Misc.");
		settings.Add("emoji_6", false, "Split when talking to an NPC", "Misc.");
	
	settings.Add("Dab", false, "Display dab counter");
		settings.Add("nodabreset", false, "Don't reset the counter between runs", "Dab");
	vars.doneSplits = new List<string>();
	
	var tB = (Func<float, float, float, float, float, float, Tuple<float, float, float, float, float, float>>) ((elmt1, elmt2, elmt3, elmt4, elmt5, elmt6) => { return Tuple.Create(elmt1, elmt2, elmt3, elmt4, elmt5, elmt6); });

	vars.splitzone = new List<Tuple<float, float, float, float, float, float>>{
		tB(-90, -77, 290, 320, 240, 250),   //intro        
		tB(715, 725, 135, 145, 110, 120),   //sf
		tB(-15, -3, 60, 70, 8, 20),         //dd
		tB(32, 42, -60, -40, -1345, -1330), //pznt
		tB(-1, 1, 0, 0, 0, 0)               //impossible condition because im too lazy to figure out a proper fix
	};
	
	Func<string, int> GetStageNum = (stage) => {
		switch (stage) {
			case "LevelIntro":
			return 0;
			case "LeviLevle":
			return 1;
			case "dungeon":
			return 2;
			case "PZNTv5":
			return 3;
			default:
			return 4;
		}
	};
	
	Func<float, float, float, Tuple<float, float, float, float, float, float>, bool> CheckPos = (x, y, z, split) => {
		if (x > split.Item1 && x < split.Item2 &&
		 y > split.Item3 && y < split.Item4 &&
		 z > split.Item5 && z < split.Item6) {
			return true;
		} else {
			return false;
		}
	};
	
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
	
	vars.GetStageNum = GetStageNum;
	vars.CheckPos = CheckPos;
	vars.dabs = 0;
}

init {
	//thanks to Ero for figuring out modded game offsets and this code
	var offsets =
		new FileInfo(modules.First().FileName + @"\..\noid_Data\Managed\Assembly-CSharp.dll").Length > 1000000
		? new int[] { 0x8, 0x10, 0x30, 0x150, 0x90, 0xA88, 0x10C }
		: new int[] { 0x8, 0x0, 0x30, 0x150, 0x90, 0xA88, 0x104 };

	vars.DialogueActive = new MemoryWatcher<bool>(new DeepPointer("UnityPlayer.dll", 0x14660A8, offsets));		
}

update
{
	vars.DialogueActive.Update(game);
	current.dialogue = vars.DialogueActive.Current;
	if (settings["Dab"]) vars.SetTextComponent("Dab count:", vars.dabs.ToString());
	if (current.dab && !old.dab) vars.dabs++;
}

start {
	if (current.loadedScene != "void" && current.state == old.state - 1 && settings["IL"]) {
		vars.doneSplits.Clear();
		return true;
	} 
	
	if (current.loadedScene == "title" && current.ConfirmTime > old.ConfirmTime) {
		vars.doneSplits.Clear();
		if (!settings["nodabreset"]) vars.dabs = 0;
		return true;
	}
}

split {
	if (String.IsNullOrEmpty(current.loadedScene))
		current.loadedScene = old.loadedScene;
	
	//splits on loads into a level
	if (!settings["ILS"]) {
		if (current.loadedScene != old.loadedScene) {
			if (current.loadedScene == "void" && !vars.doneSplits.Contains(old.loadedScene) && settings[old.loadedScene]) {
				vars.doneSplits.Add(old.loadedScene);
				return true;
			}
			
			if (current.loadedScene != "void" && !vars.doneSplits.Contains("e" + current.loadedScene) && settings["e" + current.loadedScene]) {
				vars.doneSplits.Add("e" + current.loadedScene);
				return true;
			}
		}
	} 
	
	//AllNPC splits
	if (current.loadedScene != "MikeLayer" && current.dialogue && !old.dialogue) {
		return settings["emoji_6"];
	}
	
	//IL timing splits
	if (settings["ILS"] || settings["IL"]) {
		if (current.state != old.state && current.state == 9) {
			return vars.CheckPos(current.xPos, current.yPos, current.zPos, vars.splitzone[vars.GetStageNum(current.loadedScene)]);
		}
		
		if (current.loadedScene != "LevelIntro" && current.loadedScene != "void" && !settings["IL"] && current.state == old.state - 1 && !vars.doneSplits.Contains("e" + current.loadedScene) && settings["e" + current.loadedScene]) {
			vars.doneSplits.Add("e" + current.loadedScene);
			return true;
		}
	}
	
	//mike level splits
	if (current.loadedScene == "MikeLayer" && !current.dialogue && old.dialogue) {
		if (current.bosshp > 0)
			return settings["mikestart"];
			
		if (current.bosshp == 0)
			return settings["MikeLayer"] || settings["IL"];
	}
}


reset {
	if (settings["IL"]) {
		return current.state == 8;
	} else {
		return current.loadedScene == "title" && old.loadedScene != "title";
	}
}

isLoading {
	return current.loadedScene != current.loadingScene;
}
