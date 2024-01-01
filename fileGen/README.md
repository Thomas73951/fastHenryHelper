# fileGen

Creates `.inp` files to describe inductors for FastHenry to simulate.

Run `fastH_tmswrite.m` with octave (no packages needed) to create files. Then use `automatedHenry` to simulate.

Original script and files from ELEC70101 Sensors Coursework is in `initialScripts/`.

### excess from when filegen was in university vault under Obsidian.

Location of example files from fasthenry2 on Windows:

```
C:\Users\Public\Documents\FastFieldSolvers\FastHenry2\Automation\Office
```

TODO:

- [x] mess around with the single turn coil
- [x] make a reader coil with a few turns 
- [ ] take the output on the back of the pcb around the middle of one side
- [x] find a more useful way of getting the data out of it - the .mat files are awful, and testing requires human input, kinda want to control it with octave or cmd 
- [ ] model a tag coil, or a few - based on actual products
- [x] combine the two and measure mutual inductance using fasthenry
- [x] ... and with moving position of tag coil
