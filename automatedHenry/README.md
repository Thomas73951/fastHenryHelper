Automated running of simulations with FastHenry2 using Visual Basic Scripts (VBScript, `.vbs`). Using FastModel, simulations of single files can be run manually, but prints results to console and requires significant manual intervention.

The scripts here run simulations on all `.inp` files found within a directory or subdirectories. 

### Workflows

- *[SWEEP](../workflow-SWEEP.md)* - [automatedHenry_sweeps.vbs](automatedHenry_sweeps.vbs) - takes a folder containing five sweep folders and simulates them all, returning five `.csv` files.
- *[MESH](../workflow-MESH.md)* - [automatedHenry_multi.vbs](automatedHenry_multi.vbs) - takes a folder and recursively searches through the directory and subdirectory, writing results into a single `.csv` file. Ideal for *MESH*.

> [!NOTE]
> Multiple instances of a script can be run at once, where its edited, saved, then run multiple times.
> In task manager, the script will show during setup stages and replaced by FastHenry when running. 

### Example scripts 

FastFieldSolvers provide some examples for automation with VBScript, VBA (excel), and VisualBasic. This is typically found at:

```bash
C:\Users\Public\Documents\FastFieldSolvers\FastHenry2\Automation
```

### Additional Scripts

Test scripts for each part of the main VBScript scripts are provided in [testscripts](testscripts/).

## Setup and Usage

This can be run on Windows only. 

It requires an installation of FastHenry2 (via FastModel bundle, see [here](../README.md#prerequisites)).

To use these scripts, edit them in Notepad++ or similar, then double click to run. 



<!-- 
Visual Basic Script (VBScript) files for automation of:

- running fast henry on all files in a directory (& recursively through subfolders)
- writing output data to csv
  - folder
  - filename
  - Inductance of coil 1 (reader)
  - Inductance of coil 2 (tag)
  - Mutual inductance (M)


Test scripts:

- listFilesInFolder
- recursiveListFilesInFolder
- writeCSV
- regexTest
- fhdriv (automation example from FastHenry2 automation examples) -->


