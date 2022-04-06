state("ShadowOfMordor") {
    int sload: 0x17FCC90, 0x38, 0x18, 0x20, 0xCB;
    int bload: 0x17FB674;
    bool cs:   0x17FAC88, 0x40, 0x90; 
}

isLoading {
    return current.sload == 65536 || current.bload != 0 || current.cs; 
}
