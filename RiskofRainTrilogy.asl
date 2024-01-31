state("Risk of Rain 2") {}

state("ROR_GMS_controller") {
    int roomID:         0x2BED7A8;                                  //1st stages: 18, 23, 22, 21, 19, 20 | last stage: 41 | cutscenes: 1 & 9
    int runEnd:         0x2BEB5E0, 0x0, 0x548, 0xC, 0xB4;           //goes from 0 to 1 when you Press 'A' to leave the planet
    double gameTime:    0x2BEB5E0, 0x0, 0x28, 0xC, 0xBC, 0x8, 0x0, 0x720, 0x8, 0x1EC0;
}

state("Risk of Rain") {
    int roomID:         0x2BED7A8;                                  //1st stages: 18, 23, 22, 21, 19, 20 | last stage: 41 | cutscenes: 1 & 9
    int runEnd:         0x2BEB5E0, 0x0, 0x548, 0xC, 0xB4;           //goes from 0 to 1 when you Press 'A' to leave the planet
    double gameTime:    0x2BEB5E0, 0x0, 0x28, 0xC, 0xBC, 0x8, 0x0, 0x720, 0x8, 0x1EC0;
}

state("Risk of Rain Returns")
{
    int stageID:        0x21729D8;
    double gameTime:    0x1F5F450, 0x120, 0x10, 0x90, 0x0, 0x48, 0x10, 0xD0, 0x0, 0x48, 0x10, 0x2E0, 0x0;
}

startup {
    vars.Log = (Action<object>)(output => print("[] " + output));
    vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
    vars.Unity.LoadSceneManager = true; 

    settings.Add("ror1", true, "Risk of Rain");
    settings.Add("ror2", true, "Risk of Rain 2");
    settings.Add("rorr", true, "Risk of Rain Returns");

    settings.Add("ror1_splits", false, "Split on stage transitions", "ror1");

    settings.Add("rorr_splits", false, "Split on stage transitions", "rorr");  

    settings.Add("ror2_splits", false, "Split on stage transitions", "ror2");
    settings.Add("bazaar", false, "Split when leaving Bazaar Between Time", "ror2");
    settings.Add("arena", false, "Split when leaving Void Fields", "ror2");
    settings.Add("goldshores", false, "Split when leaving Gilded Coast", "ror2");
    settings.Add("artifactworld", false, "Split when leaving Bulwark's Ambry", "ror2");
    
    //variable to pause the timer when switching games
    vars.isSwitchingGames = false;
    
    //variable to keep track of if one game was finished before, for auto-reset purposes
    vars.canReset = true;
}

init
{
   var dll = File.Exists(modules.First().FileName + @"\..\Risk of Rain 2_Data\Managed\RoR2.dll"); 

   vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
    {

        var assembly = dll ? "RoR2" : "Assembly-CSharp";
        
        var ftbm = helper.GetClass(assembly, "FadeToBlackManager");
        var run = helper.GetClass(assembly, "Run");
        var goc = helper.GetClass(assembly, "GameOverController");

        vars.Unity.Make<float>(ftbm.Static, ftbm["alpha"]).Name = "fade";
        vars.Unity.Make<int>(run.Static, run["instance"], run["stageClearCount"]).Name = "stage";
        vars.Unity.Make<bool>(goc.Static, goc["instance"], goc["shouldDisplayGameEndReportPanels"]).Name = "panel";

        return true;
    });


    
    vars.Unity.Load(game, 500);
}

update {
    if (vars.Unity.Loaded) {
        vars.Unity.Update();
    

        current.fade = vars.Unity["fade"].Current;
        current.stageCount = vars.Unity["stage"].Current;
        current.scene = vars.Unity.Scenes.Active.Name;
        current.results = vars.Unity["panel"].Current;
    }

    if (vars.canReset == false) {   //if we're on the 2nd game, start condition unpauses the timer
        if (game.ProcessName == "Risk of Rain" || game.ProcessName == "ROR_GMS_controller") {
            if (old.roomID == 6 && current.roomID != 6 || old.roomID == 40 && current.roomID != 40 || old.roomID == 7 && current.roomID != 7) {
                if (current.roomID != 2) {
                    print("[Trilogy ASL] Restarting timer as " + game.ProcessName + " started a new run");
                    vars.isSwitchingGames = false;
                }
            }
        }
    
        if (game.ProcessName == "Risk of Rain 2") {
            if (current.scene.Contains("beach") || current.scene.Contains("golem") || current.scene.Contains("snowy")) {
                print("[Trilogy ASL] Restarting timer as " + game.ProcessName + " started a new run");
                vars.isSwitchingGames = false;
            }
        }

        if (game.ProcessName == "Risk of Rain Returns") {
            if (old.stageID == 4 && current.stageID != 4) {
                if (current.stageID != 4) {
                    print("[Trilogy ASL] Restarting timer as " + game.ProcessName + " started a new run");
                    vars.isSwitchingGames = false;
                }
            }   
        }
    }
}

start {
    if (game.ProcessName == "Risk of Rain" || game.ProcessName == "ROR_GMS_controller") {
        if (old.roomID == 6 && current.roomID != 6 || old.roomID == 40 && current.roomID != 40 || old.roomID == 7 && current.roomID != 7) {
            if (current.roomID != 2) {
                vars.canReset = true;
                vars.isSwitchingGames = false;
                print("[Trilogy ASL] Starting new " + game.ProcessName + " run");
                return true;
            }
        }
    }
    
    if (game.ProcessName == "Risk of Rain 2" && vars.Unity.Loaded) {
        if (current.scene.Contains("beach") || current.scene.Contains("golem") || current.scene.Contains("snowy")) {
            vars.canReset = true;
            vars.isSwitchingGames = false;
            return current.fade < 1.0f && old.fade >= 1.0f;
        }
    }

    if (game.ProcessName == "Risk of Rain Returns") {
        if (old.stageID == 4 && current.stageID != 4) {
            if (current.stageID != 4) {
                vars.canReset = true;
                vars.isSwitchingGames = false;
                print("[Trilogy ASL] Starting new " + game.ProcessName + " run");
                return true;
            }
        }
    }
}

reset {
    if (vars.canReset == true) {
        if (game.ProcessName == "Risk of Rain" || game.ProcessName == "ROR_GMS_controller") {
            return (current.roomID == 2 || current.roomID == 40);
        }
        
        if (game.ProcessName == "Risk of Rain 2" && vars.Unity.Loaded) {
            return current.scene == "lobby";
        }
        
        if (game.ProcessName == "Risk of Rain Returns") {
            return (current.stageID == 2 || current.stageID == 3 || current.stageID == 4);
        }
    }
}

split {
    if (vars.isSwitchingGames == false) {
        if (game.ProcessName == "Risk of Rain" || game.ProcessName == "ROR_GMS_controller") {
            //ror1 area splits
            if (current.roomID != old.roomID &&                                                 
            current.roomID != 2 && old.roomID != 6 && old.roomID != 2 && old.roomID != 40 &&    
            old.roomID != 9 && old.roomID != 1 && old.roomID != 0 &&                            
            settings["ror1_splits"] == true) {                                                  
                vars.canReset = false;
                vars.isSwitchingGames = true;
                print("[Trilogy ASL] RoR stage split triggered (currently acting like final split for debugging)");
                return true;                                                                    
            }
    
            //ror1 final split
            if (current.roomID == 41 && current.runEnd == 1 && old.runEnd == 0) {
                vars.canReset = false;
                vars.isSwitchingGames = true;
                print("[Trilogy ASL] RoR Final Split triggered");
                return true;
            }
        }
    
        if (game.ProcessName == "Risk of Rain 2" && vars.Unity.Loaded) {
            if (current.scene == null) 
                current.scene = old.scene;

            //ror2 area splits
            if (settings["ror2_splits"]) {
                if (current.stageCount == old.stageCount + 1 && current.stageCount >= 1) {
                    print("[Trilogy ASL] RoR2 Stage Split triggered");
                    return true;
                }
            }

            //ending split
            if (current.scene != old.scene && current.scene == "outro") {
                vars.canReset = false;
                vars.isSwitchingGames = true;
                print("[Trilogy ASL] RoR2 Ending Split triggered");
                return !settings["ror2_splits"];
            }
            
            //special stage splits i.e. bazaar
            if (current.scene != old.scene && current.scene != "title" && current.scene != "lobby" && settings[old.scene])
                print("[Trilogy ASL] RoR2 special scene split triggered for " + old.scene);
                return true;

            //alternate ending splits i.e. celestial ending, voidling
            if (current.results && !old.results && (current.scene == "voidraid" || current.scene == "limbo" || current.scene == "mysteryspace"))
                vars.canReset = false;
                vars.isSwitchingGames = true;
                print("[Trilogy ASL] RoR2 Alternate Ending Split Triggered at " + current.scene);
                return true;
        }

        if (game.ProcessName == "Risk of Rain Returns") {
            //rorr area splits
            if (current.stageID != old.stageID &&                                                                   
                current.stageID != 2 && old.stageID != 3 && old.stageID != 2 && old.stageID != 4 &&                     
                old.stageID != 0 && old.stageID != 1 && old.stageID != 7 &&                                              
                settings["rorr_splits"] == true) {                                                                    
                print("[Trilogy ASL] RoRR Stage Split Triggered");
                return true;                                                                                  
            }
    
            //rorr final split
            if (current.stageID == 64 && old.stageID == 8) {
                vars.canReset = false;
                vars.isSwitchingGames = true;
                print("[Trilogy ASL] RoRR Final Split Triggered");
                return true;
            }
        }
    }
}
        
isLoading {
    if (game.ProcessName == "Risk of Rain 2" && !vars.isSwitchingGames && vars.Unity.Loaded) {
        if (current.fade > old.fade) return true;
        if (current.fade < old.fade && current.fade > 0 || current.fade == 0) return false;
    }

    return vars.isSwitchingGames;
}

exit
{
    vars.Unity.Reset();
}

shutdown
{
    vars.Unity.Reset();
}
