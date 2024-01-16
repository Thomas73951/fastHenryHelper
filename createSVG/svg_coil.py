"""
Creates SVG from set of x,y points for a coil for the purposes of creating the coil on the pcb
"""

import csv
import drawsvg as draw

TRACE_WIDTH = 0.4

def read_csv(filename):
    """
    returns csv file as list (of lists)
    """
    values = []
    with open(filename, 'r', encoding='UTF8', newline='') as data_file:
        reader = csv.reader(data_file)
        for row in reader:
            values.append(row)
    return values

def read_csv_onerow(filename):
    """
    returns first row of csv file as list
    """
    with open(filename, 'r', encoding='UTF8', newline='') as data_file:
        reader = csv.reader(data_file)
        for row in reader:
            return row

# Setup data for svg
x = read_csv_onerow('coil_points_x.csv')
y = read_csv_onerow('coil_points_y.csv')

# y = [i * -1 for i in x] # y axis notation is reversed (positive down here, positive up in octave)
# TODO: fix this ^ (?)

# Create SVG from data
# initialise file
d = draw.Drawing(200, 100, origin='center') # (made big enough)

# setup path
path = draw.Path(stroke='black', fill='none',stroke_width=TRACE_WIDTH)

d.append(path.M(x[0],y[0])) # move "cursor" to first point

# write data points
for i in range(len(x)):
    d.append(path.L(x[i],y[i]))



d.set_pixel_scale(1)  # Set number of pixels per geometry unit
d.save_svg('coil.svg')
