# fileGen

Creates `.inp` files describing one or more structures for FastHenry to simulate. After which, [automatedHenry](../automatedHenry/) is used to automate the simulations.

> [!NOTE] 
> The scripts in this folder are designed for use in Octave on Windows or Linux.

## Scripts

This folder contains some `fastHwrite.m` scripts and some helper scripts:

### `fastHwrite.m` scripts
- `fastHwrite.m` 
    - Base script, allows for the creation of two coils (for RFID this is a reader coil and a transponder coil). Where the second coil can be:
        - in one position (e.g. `offset2 = [0 0 5];`). (*one file*) *SINGLE*
        - A set of positions across the *x*, *y*, *z*, or *x=y* axes. (about 40 files)
        - A "mesh" sweep -- a grid of points covering the first quadrant of the *xy* plane at a set *z* height. (*about 41^2 = 1681 files*) *[MESH](../workflow-MESH.md)*
- `fastHwrite_multimesh.m` 
    - Modified script, takes the mesh sweep and repeats for several *z* heights. (*1681 * <number of *z* set-points> files*) *[MESH](../workflow-MESH.md)*
- `fastHwrite_multisweep.m` 
    - Modified script, this takes the "A set of positions across different axes" option and creates 5 of these sweeps. (*about 41 * 5 = 205 files*) *[SWEEPS](../workflow-SWEEP.md)*

Additionally, the basic original script for creating files, along with an example file is shown in [initialScripts](initialScripts/).

### Helper Files

These are functions files used in `fastHwrite.m` scripts and include:

- `createCoilPoints.m` - which handles the creation of *x, y, z* vectors forming the vertices of a coil.
- `nodePrint.m` - writes the vertices as points
- `EPrint.m` - writes the list of node connections.


## Usage and Notes

### `.inp` Files

> [!NOTE] 
> FastHenry1 manual which gives information on `.inp` file setup: https://www.fastfieldsolvers.com/Download/FastHenry_User_Guide.pdf

`.inp` files are netlist style files containing all the nodes and connections for each, along with simulation and wire setup information. The information these file contain includes:

- Units for all numerical entries in the file, usually mm, with syntax `.units mm`.
- Default file settings with syntax `.default sigma = 5.8e4 h = 0.035` for default conductivity and height (using mm as units from before).
- A list of nodes with syntax `N1 x = 1 y = 2 z = 3` for node 1 at coordinates (1,2,3).
- How the nodes are connected with syntax `E1 N1 N2  w = 0.4` for a trace of name `E1` connecting `N1` and `N2` with a width of 0.4 (mm) and default height.
- Which nodes form the ports of each device with syntax `.external N1 N10 coil1` for a two port device of name *coil1* and ports at nodes 1 & 10.
- Frequency simulation settings with example syntax: `.freq fmin=1e4 fmax=1e7 ndec=1` is for simulations starting at 1 KHz, ending at 10 MHz with one point per decade. Noting that frequency simulations are only relevant when skin depth is modelled. 
- To model skin depth, the options `nhinc` and `nwinc` can be set to greater than one, splitting up the cross section of the trace into different elements. More information in the manual.

#### Example files

Example `.inp` files included in the [FastModel install](../README.md#prerequisites) can be typically found at:

```bash
C:\Users\Public\Documents\FastFieldSolvers\FastHenry2
```
These can be viewed (and run) from FastModel.

### File/Folder Structures

FileGen employs a few strategies for creating and organising files. 

- The option USE_SUBFOLDERS determines whether each `.inp` file gets placed in its own folder. 
    - This is recommended if the `Zc.mat` file is of use as FastHenry will overwrite any existing `Zc.mat` files already in the directory.
    - This is also recommended when creating sets of files, such as in the *SWEEP* and *MESH* workflows because `fastHwrite.m` writes the position of the second coil into the folder name 

### Resistance Readout

This is performed in Octave, where it measures the trace length of the coil created. It uses this and the trace width, a trace height of 35μm (PCB trace), and a resistivity of 1.7e-8 Ω⋅m (copper), to give the estimated trace resistance. This is a good match to trace resistance measurements derived from KiCad.

<!-- ### Improvements

Bit inefficient when creating (40^2)*10 files and folders...
TODO: inefficiency when creating tons and tons of files -->
