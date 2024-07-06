# fastHenryHelper

FastHenry is a 3-D inductance solver originally developed by [M.I.T. for Unix systems](https://www.rle.mit.edu/cpg/research_codes.htm), where the Microsoft Windows port [FastHenry2 from FastFieldSolvers](https://www.fastfieldsolvers.com/fasthenry2.htm) is used here.
It can be used to measure the inductance of a device, or the mutual inductance between two or more devices. These structures are outlined in  `.inp` files.
It does not measure parasitic series resistance or parasitic capacitance, but other software from FastFieldSolvers may be used.

---

This repository contains a full workflow for using FastHenry2 for the use case of designing reader coils for an inductively coupled RFID system. For other use cases read see [here](#not-making-coils-for-rfid). The code in this repository provides automation and the ability to run multiple `.inp` files  and contains the following stages:

- `.inp` file generation with [fileGen](fileGen/) (Octave)
- (Optionally) `.svg` file generation for PCB layout with [createSVG](createSVG/) (Python) <!-- using points from structures created in [fileGen](fileGen/) -->
- Automated simulation of FastHenry with [automatedHenry](automatedHenry/) (VBScript)
- Plotting of results with [plottingHenry](plottingHenry/) (Octave)

See READMEs within each folder (linked for each) for more information.

During this process, files generated are all placed in the top-level folder `testfiles/`, and result CSV files and images are all placed in the top-level folder `results/`.


### Different Workflow Streams

There are three main workflows here with the following codenames:
- Creating (and simulating) singular files - *SINGLE*
- Creating a set of sweeps - *SWEEPS* - details [here](workflow-SWEEP.md)
- Creating a mesh - *MESH* - details [here](workflow-MESH.md)

For more information on workflows, firstly read the README in [fileGen](fileGen/).

### Not Making Coils for RFID?

TODO: Then here's how this can be modified to be useful.


## Setup

> [!WARNING] 
> Operating System: 
> - FastHenry2 is Windows only.
> - Octave and Python scripts are generally compatible with both Windows and Linux

### Prerequisites

- ["FastFieldSolvers bundle binary distribution for Windows"](https://www.fastfieldsolvers.com/download.htm)
  - Download the bundle containing (at least) FastModel and FastHenry2. 
  - This can be used to view and run simulations of singular `.inp` files, however, using [automatedHenry](automatedHenry/) allows for automated running of file(s) with the program closed.
- GNU Octave
  - N.B. Running the `.m` scripts in MATLAB may be possible with some level of conversion required.
- Python (for [creating SVGs](createSVG/) only)
