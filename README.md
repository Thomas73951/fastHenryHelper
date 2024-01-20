# fastHenryHelper

System Flow:

- `.inp` file generation with `fileGen` (octave)
  - `.svg` file generation for PCB layout with `createSVG` (python) using `fileGen` points
- automation of running FastHenry with `automatedHenry` (vbscript)
- plotting of results with `plottingHenry` (octave)
