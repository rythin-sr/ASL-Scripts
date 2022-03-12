state("circuit-superstars") {}

startup
{
    vars.Log = (Action<object>)(output => print("[] " + output));
    vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
}

init
{
    vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
    {
        var rm = helper.GetClass("Assembly-CSharp", "RaceManager"); 
        var rs = helper.GetClass("Assembly-CSharp", "RaceStage");
        
        vars.Unity.Make<int>(rm.Static, rm["Instance"], rm["PhysicsTicksSinceRaceStart"]).Name = "frames";
        vars.Unity.Make<float>(rm.Static, rm["Instance"], rm["TimeInCurrentStage"]).Name = "time";
        vars.Unity.Make<byte>(rm.Static, rm["Instance"], rm["localStage"], rs["State"]).Name = "state";
        return true;
    });

    vars.Unity.Load(game);
    vars.igt = 0;
    vars.displayOnlyVar = false;
    vars.canSplit = true;
}

update
{
    if (!vars.Unity.Loaded) return false;

    vars.Unity.Update();

    current.state = vars.Unity["state"].Current; 
    current.frames = vars.Unity["frames"].Current;
    current.time = vars.Unity["time"].Current;

    /*print("frames: " + vars.Unity["frames"].Current +
        "\ntime: " + vars.Unity["time"].Current +
        //"\ntime3: " + vars.Unity["time3"].Current +
        "\nstate: " + vars.Unity["state"].Current);*/
}

start {
    if (current.frames > 0 && old.frames == 0 && current.state > 0) {
        return true;
    } 
}

onStart {
    vars.igt = 0;
    vars.canSplit = true;
}

split {
    if (current.time < old.time && old.time > 120f && vars.canSplit) {
        vars.igt += old.time;
        vars.displayOnlyVar = true;
        vars.canSplit = false;
        //print("otime: " + old.time + "\nctime: " + current.time + "\nftime: " + (current.frames * 0.02f));
        return true;
    }

    if (current.frames > 0 && old.frames == 0) {
        vars.displayOnlyVar = false;
        vars.canSplit = true;
    }
}

isLoading {
    return true;
}

gameTime {
    if (vars.displayOnlyVar) {
        return TimeSpan.FromSeconds(vars.igt);
    } else {
        return TimeSpan.FromSeconds(vars.igt + old.time);
    }
}

exit
{
    vars.Unity.Reset();
}

shutdown
{
    vars.Unity.Reset();
}
