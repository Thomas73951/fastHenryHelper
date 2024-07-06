# createSVG

This creates SVG files of the coil points for the purpose of recreating the exact structure on a PCB. It creates the points from a set of x,y points from `fileGen`. 

---

To use this:
- the `SAVE_POINTS_CSV` option in one of the `fastHwrite.m` scripts in [fileGen](../fileGen/) must be enabled.
- Note the trace width used as this is set manually within [svg_coil.py](svg_coil.py)
- To import the file into KiCad, see [KiCad Import](#import-to-kicad)


## Setup and Usage

Requires Python 3 and the package: `drawsvg`.
Instructions provided for Linux, but setup on Windows is similar.

### Venv setup (linux)

```bash
cd createSVG/
python -m venv .venv
source .venv/bin/activate

pip install drawsvg
```

### Run 

```bash
python svg_coil.py
```

### Import to KiCad

- File > Import > Graphics
  - Choose file (svg)
  - Graphic layer: F.silk
  - Import scale: 3.7795492028587
  - Group Items: false
- Rotate (R) as needed and place where desired.
- With all lines selected, right click -> Create from Selection -> Create Tracks from Selection.
- Hide F.cu layer, reselect coil, delete (deletes lines in silkscreen layer).
- done :)
