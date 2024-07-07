# Post Processing

Taken from files included with FastModel, however, are not useful. The combination of [automatedHenry](../automatedHenry/) and [plottingHenry](../plottingHenry/) make this redundant.

> [!WARNING] 
> **DEPRECATED, FUNCTIONALITY IMPLEMENTED INTO `automatedHenry` & `plottingHenry`.**

> Compiled on SteamOS 3 (Arch Linux)

## Readoutput

Takes Zc.mat (in form $R + j\omega L$) and prints in form $R + jL$

### To Compile:

```bash
gcc ReadOutput.c -o executables/readoutputcompiled
```

### To Run:

```bash
./executables/readoutputcompiled data/Zc.mat
```


## MakeLcircuit

Expects one frequency in input but will take last if multiple given.

### To Compile:

```bash
gcc MakeLcircuit.c -o executables/makelcircuitcompiled -lm
```

`-lm` [required to link the maths library at compile.](https://stackoverflow.com/questions/10409032/why-am-i-getting-undefined-reference-to-sqrt-error-even-though-i-include-math)

### To Run:

```bash
./executables/makelcircuitcompiled data/Zc.mat
```

### Output

- LZ: self terms
- KZ: mutual inductance
- RZ/HZ & Vam: mutual resistance
