//original script by KunoDemetries
//cleaned up and some extra features by rythin
//modified pointers for expanded memory .exe file and fixed end split condition -Surviv0r
//fixed ending split for speedrun mod - Dev1ne

state("iw3sp", "V1.0") // Steam Version
{
  	int load :	0x10B1100;
	string20 map :	0x6C3140;
	int EndSplit :	0xCDE4C8;
}

state("iw3sp", "V1.5") // Modified .exe to support more physical memory
{
  	int load :	0x1C75F4, 0x0;
	string20 map :	0x4FA248;
	int EndSplit :	0xCDE4C8;
}

startup 
{
	settings.Add("CoD4", true, "Call of Duty 4");
    settings.Add("act0", true, "Prologue", "CoD4");
    settings.Add("act1", true, "Act 1", "CoD4");
    settings.Add("act2", true, "Act 2", "CoD4");
    settings.Add("act3", true, "Act 3", "CoD4");

	var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    var sB = new List<Tuple<string, string, string>> 
	{
		tB("act0","killhouse", "F.N.G."),
		tB("act0","cargoship", "Crew Expendable"), 
		tB("act0","coup", "The Coup"),
		tB("act1","blackout", "Blackout"),
		tB("act1","armada", "Charlie Dont Surf"),
		tB("act1","bog_a", "The Bog"),
		tB("act1","hunted", "Hunted"),	
		tB("act1","ac130", "Death From Above"),
		tB("act1","bog_b", "War Pig"),	
		tB("act1","airlift", "Shock and Awe"),
		tB("act1","aftermath", "Aftermath"),
		tB("act2","village_assault", "Safe House"),
		tB("act2","scoutsniper", "All Ghillied Up"), 
		tB("act2","sniperescape", "One Shot, One Kill"),
		tB("act2","village_defend", "Heat"),
		tB("act2","ambush", "The Sins of the Father"),
		tB("act3","icbm", "Ultimatum"),
		tB("act3","launchfacility_a", "All In"),
		tB("act3","launchfacility_b", "No Fighting in The War Room"),
		tB("act3","jeepride", "Game Over"),
    };
        foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) 
    {        
        var timingMessage = MessageBox.Show 
		(
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time? This will make verification easier",
            "LiveSplit | Call of Duty 4: Modern Warfare",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }

    vars.doneMaps = new List<string>();
    vars.startMaps = new List<string>{"killhouse", "blackout", "village_assault", "icbm"};
	vars.coupOffset = false;
	vars.currentTime = new TimeSpan(0, 0, 0);
	vars.lastGameplayMap = "";
	vars.firstGameplayMap = "";
}

init 
{
	if (modules.First().ModuleMemorySize == 0x1D03000)
        version = "V1.0";
    else if (modules.First().ModuleMemorySize == 0x1D00EC2)
        version = "V1.5";
}

start 
{
	if (vars.startMaps.Contains(current.map) && (vars.firstGameplayMap == "" || vars.firstGameplayMap == current.map) && current.load != 0 && old.load == 0) {
		vars.firstGameplayMap = current.map;
		return true;
	};
}

onStart
{
	vars.doneMaps.Clear();
	vars.coupOffset = false;
}

split 
{
	if (current.map != old.map && old.map != "ui")
		vars.lastGameplayMap = old.map; 

	if (current.map != old.map && current.map != "ui" && !vars.doneMaps.Contains(vars.lastGameplayMap)) {
		if (current.map == "coup") { 
			vars.currentTime = timer.CurrentTime.GameTime;	
			vars.coupOffset = true;	
		}	
		 					
			
		vars.doneMaps.Add(vars.lastGameplayMap);	
		return settings[vars.lastGameplayMap];			
		
			
	}	

	//Endsplit for vanilla
	if (current.map == "jeepride" && current.EndSplit != old.EndSplit && (old.EndSplit == 147865 && current.EndSplit != 147865 || current.EndSplit == 147865 && old.EndSplit != 147865)) 
	{
		return true;
	}
	//Endsplit solution for speedrun mod
	else if (old.map == "jeepride" && current.map == "ac130")
	{
		return true;
	}
}   
 
reset 
{
	return (current.map == vars.firstGameplayMap && old.map == "ui");
}

onReset
{
	vars.doneMaps.Clear();
}

gameTime 
{
	if (vars.coupOffset == true) {					
		vars.coupOffset = false;				
		return vars.currentTime.Add(new TimeSpan (0, 4, 44));
	}
}

isLoading 
{
		return (current.load == 0) || (current.map == "coup");
}

exit 
{
    timer.OnStart -= vars.onStart;
}
