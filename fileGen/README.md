# fileGen

Creates `.inp` files to describe inductors for FastHenry to simulate.

Run `fastH_tmswrite.m` with octave (no packages needed) to create files.

Original script from ELEC70101 Sensors Coursework is `zFasthenrywrite.m`

### excess from when filegen was in university vault under Obsidian.

example files 
```
C:\Users\Public\Documents\FastFieldSolvers\FastHenry2\Automation\Office
```

TODO:

- [ ] mess around with the single turn coil
- [ ] make a reader coil with a few turns 
- [ ] take the output on the back of the pcb around the middle of one side
- [ ] find a more useful way of getting the data out of it - the .mat files are awful, and testing requires human input, kinda want to control it with octave or cmd 
- [ ] model a tag coil, or a few
- [ ] combine the two and measure mutual inductance with position using fasthenry