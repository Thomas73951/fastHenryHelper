Plotting operations on results produced by [automatedHenry](../automatedHenry/). The results are `.csv` files in different forms and different plotting scripts are provided for each purpose. 

- [plottingHenry.m](plottingHenry.m) - plotting of one sweep in *x*, *y*, or *z* axes, gives four plots: L1, L2, M, K.
- [plottingMultiHenry.m](plottingMultiHenry.m) SUPERSEDED by `plottingMultiHenry_stdSweep` as uses old file structure.
- [plottingMultiHenry_stdSweep.m](plottingMultiHenry_stdSweep.m) - plots a set of five standard sweeps (*[SWEEPS](../workflow-SWEEP.md)*), gives plots of M, K, optionally L1, L2 for each of the same axes direction on the same plot.
- [plottingMultiHenry_overlay.m](plottingMultiHenry_overlay.m) - same as `plottingMultiHenry_stdSweep` but plots each sweep on a separate graph. This also allows for several different *SWEEP* runs to be plotted together for comparison.
- [plottingMultiHenry_mesh.m](plottingMultiHenry_mesh.m) - plotting of one z set point for *[MESH](../workflow-MESH.md)* workflow. 
- [plottingMultiHenry_mesh_compare.m](plottingMultiHenry_mesh_compare.m) - overlays measured data for minimum required power (for RFID systems) with the coupling factor for several *z* set points.
- [scatter_mesh_compare.m](scatter_mesh_compare.m) - takes all measured points and compares to the coupling factor at that position.
- [plottingMultiHenry_mesh_Kplots.m](plottingMultiHenry_mesh_Kplots.m) - Uses several *z* set points and a minimum coupling factor to create a 3-D plot showing a volume for a coupling factor or better. 
