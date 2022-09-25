state("Risk of Rain 2") {}

startup
{

    //UnityASL setup thanks to Ero
    vars.Log = (Action<object>)(output => print("[] " + output));
    vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
    vars.Unity.LoadSceneManager = true; 

    settings.Add("fin", false, "Don't split on stage transitions");
    settings.SetToolTip("fin", "Will still split when entering the final cutscene, just not between stages.");
    settings.Add("bazaar", false, "Split when leaving Bazaar Between Time");
    settings.Add("arena", false, "Split when leaving Void Fields");
    settings.Add("goldshores", false, "Split when leaving Gilded Coast");
    settings.Add("artifactworld", false, "Split when leaving Bulwark's Ambry");
    
    //timing method reminder from Amnesia TDD autosplitter, all credits to those guys
    if (timer.CurrentTimingMethod == TimingMethod.RealTime) {        
            var timingMessage = MessageBox.Show (
                "This game uses time without loads as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (time INCLUDING loads).\n"+
                "Would you like the timing method to be set to Loadless for you?",
                "RoR2 Autosplitter | LiveSplit",
                MessageBoxButtons.YesNo,MessageBoxIcon.Question
            );
        
            if (timingMessage == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

init
{
   var dll = File.Exists(modules.First().FileName + @"\..\Risk of Rain 2_Data\Managed\RoR2.dll"); 

   vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
    {

        var assembly = dll ? "RoR2" : "Assembly-CSharp";
        
        var ftbm = helper.GetClass(assembly, "FadeToBlackManager");
        var run = helper.GetClass(assembly, "Run");

        vars.Unity.Make<float>(ftbm.Static, ftbm["alpha"]).Name = "fade";
        vars.Unity.Make<int>(run.Static, run["instance"], run["stageClearCount"]).Name = "stage";

        return true;
    });


    
    vars.Unity.Load(game);
}

update
{
    if (!vars.Unity.Loaded) return false;

    vars.Unity.Update();

    current.fade = vars.Unity["fade"].Current;
    current.stageCount = vars.Unity["stage"].Current;
    current.scene = vars.Unity.Scenes.Active.Name;

    //print("uwu " + current.scene + " " + current.fade + " ");
}

start {    
    if (current.scene.Contains("beach") || current.scene.Contains("golem") || current.scene.Contains("snowy")) {
        return current.fade < 1.0f && old.fade >= 1.0f;
    }
}

reset {
    return current.scene == "lobby";
}

split {
    if (current.scene == null) 
        current.scene = old.scene;

    if (!settings["fin"]) {
        if (current.stageCount == old.stageCount + 1 && current.stageCount >= 1) {
            return true;
        }
    } else {
        if (current.scene != old.scene && current.scene == "outro") {
            return true;
        }
    }

    if (current.scene != old.scene && current.scene != "title" && current.scene != "lobby" && settings[old.scene]) {
        return true;
    }
}

isLoading {
    if (current.fade > old.fade) return true;
    if (current.fade < old.fade && current.fade > 0 || current.fade == 0) return false;
}

exit
{
    vars.Unity.Reset();
}

shutdown
{
    vars.Unity.Reset();
}
