state("ChildofLight")
{
    int gameLoading: 0x9D88E8;
}
 
update
{
    vars.timerStop = false;
   
    if (current.gameLoading != 0) {
        vars.timerStop = true;
    }
}
 
exit {
    timer.IsGameTimePaused = true;
}
 
isLoading {
    return vars.timerStop;
}