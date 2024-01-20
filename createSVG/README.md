# createSVG

Creates SVG files of coil points from set of x,y points from `fileGen`

- also requires trace width - set in coil_svg.py


## Operation

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
- With all lines selected, right click -> Create from Selection -> Create Tracks from Selection
- Hide F.cu layer, reselect coil, delete <- deletes lines in silkscreen layer.
- done :)
