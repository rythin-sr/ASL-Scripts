//Destiny 2 Load Remover by rythin
//USING THIS SCRIPT MAY GET YOUR ACCOUNT BANNED I DONT REALLY KNOW BUNGIE SUCKS
//I AM NOT RESPONSIBLE FOR LOST ACCOUNTS, USE AT YOUR OWN RISK

state("destiny2")
{
	int gameState:	0x2F54660;
}

startup {

	var errorMessage = MessageBox.Show (
           	"Due to an update in the game, this script no longer works.\n"+
            	"Because making scripts like these requires the use of Cheat Engine,\n"+
            	"the original author of this script is now banned from Destiny 2,\n"
		"thus making updating it impossible. Sorry!",
          	"Destiny 2 Load Remover",
        	MessageBoxIcon.Error
       	);

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
	
	settings.Add("infoMain", false, "The 'settings' below don't affect anything, this is just a disclaimer");
	settings.Add("info1", false, "Since Bungie sucks, this script may cause account bans.", "infoMain");
	settings.Add("info2", false, "It has been tested and it seems like it's safe to use", "infoMain");
	settings.Add("info3", false, "but it still should be mentioned. Use at your own discretion.", "infoMain");
	settings.Add("info4", false, "I do not take responsibility for lost accounts.", "infoMain");
	settings.Add("stateDisp", false, "Display the current gameState under your splits");
}
update {
	if (settings["stateDisp"]) {
		vars.SetTextComponent("Value", (current.gameState).ToString());
	}
}

isLoading {
	return (current.gameState != 27);
}
