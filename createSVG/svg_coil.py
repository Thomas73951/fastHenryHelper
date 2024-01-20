"""
Creates SVG from set of x,y points for a coil for the purposes of creating the coil on the pcb

<Tested on Linux>
svg_coil.py created by Thomas Sharratt Copyright (C) 2024
"""

import csv
import drawsvg as draw

# User Variables
TRACE_WIDTH = 0.4
FILENAME_X = 'coil_points_x.csv'
FILENAME_Y = 'coil_points_y.csv'
FILENAME_SVG = 'coil.svg'

def read_csv_onerow(filename):
    """
    returns first row of csv file as items in a list
    """
    with open(filename, 'r', encoding='UTF8', newline='') as data_file:
        reader = csv.reader(data_file)
        for row in reader:
            return row

# Import data for svg
x = read_csv_onerow(FILENAME_X)
y = read_csv_onerow(FILENAME_Y)

# y = [i * -1 for i in x] # y axis notation is reversed (positive down here, positive up in octave)
# TODO: fix this ^ (?) - can be rotated in KiCad so redundant

# Create SVG from data
# initialise SVG file
d = draw.Drawing(200, 100, origin='center') # (made big enough)

# setup path type
path = draw.Path(stroke='black', fill='none',stroke_width=TRACE_WIDTH)

d.append(path.M(x[0],y[0])) # move "cursor" to first point

# write data points
for i in range(len(x)):
    d.append(path.L(x[i],y[i]))

# save file
d.set_pixel_scale(1)  # Set number of pixels per geometry unit
d.save_svg(FILENAME_SVG)
