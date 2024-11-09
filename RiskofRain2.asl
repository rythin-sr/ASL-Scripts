state("Risk of Rain 2") {}

startup
{

    //UnityASL setup thanks to Ero
    vars.Log = (Action<object>)(output => print("[] " + output));
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;

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

   vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {

        var assembly = dll ? "RoR2" : "Assembly-CSharp";

        var ftbm = mono.GetClass(assembly, "FadeToBlackManager");
        var run = mono.GetClass(assembly, "Run");
        var goc = mono.GetClass(assembly, "GameOverController");

        vars.Helper["fade"] = ftbm.Make<float>("alpha");
        vars.Helper["stageCount"] = run.Make<int>("instance", "stageClearCount");
        try {
            vars.Helper["results"] = goc.Make<bool>("instance", "shouldDisplayGameEndReportPanels");
        } catch {
            // SotS update
            vars.Helper["results"] = goc.Make<bool>("instance", "_shouldDisplayGameEndReportPanels");
        }

        return true;
    });
}

update
{
    current.scene = vars.Helper.Scenes.Active.Name;
}

start {    
    if (current.scene.Contains("beach") || current.scene.Contains("golem") || current.scene.Contains("snowy") || current.scene.Contains("lakes")) {
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

    if (current.scene != old.scene && current.scene != "title" && current.scene != "lobby" && settings[old.scene]) 
        return true;

    if (current.results && !old.results && (current.scene == "voidraid" || current.scene == "limbo" || current.scene == "mysteryspace"))
        return true;
}

isLoading {
    if (current.fade > old.fade) return true;
    if (current.fade < old.fade && current.fade > 0 || current.fade == 0) return false;
}
