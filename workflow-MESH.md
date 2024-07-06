This workflow is for simulating "mesh" sweeps of the second coil position.

- [fastHwrite.m](fileGen/fastHwrite.m) or [fastHwrite_multimesh.m](fileGen/fastHwrite_multimesh.m) - is used to create the files. This is for one or many *z* set points.
- [automatedHenry_multi.vbs](automatedHenry/automatedHenry_multi.vbs) - set the correct *z* set point and folder, then run. This outputs one results `.csv` file named with the *z* set point.
- []