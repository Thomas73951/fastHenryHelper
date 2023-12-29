clear all
close all
clc

% <Created for Octave on Arch Linux>
% Creates a .inp file with two coils with specified:
% spacing, inner diameter, turn count, trace width, z position, and offset.
% .inp file is saved to WRITE_FOLDER with an name generated from parameters.
% figures are optionally saved to images/ with SAVE_IMG = true.
%
% .inp files are netlist style files read by FastHenry2 by FastFieldSolvers.
%
% fastH_tmswrite.m created by Thomas Sharratt Copyright (C) 2023
% from: fasthenry_write.m from Imperial College ELEC70101 Sensors Coursework


WRITE_FOLDER = 'testfiles/'; % file name is auto generated
SAVE_IMG = false;

% units in mm.
s = [0.4 0.1]; % spacing
id = [4.0 0.2]; % inner diameter
turns = [10 20]; % number of complete turns
traceWidth = [0.2 0.03]; % trace width
z = [0 10];
offset2 = [0 0]; % for coil2 (x,y)

N1Min = 1;

% test gap sizes
gap = s - traceWidth
if any(gap < 0)
  error("TRACES OVERLAP. Spacing too small or trace width too large, exiting...")
endif


%% fasthenry "frontmatter"
fileName = ['fh_C1_T', num2str(turns(1)), '_ID', num2str(id(1)), '_S', num2str(s(1)), ...
            '_C2_T', num2str(turns(2)), '_ID', num2str(id(2)), '_S', num2str(s(2)), ...
            '_O' num2str(offset2(1)), '.', num2str(offset2(2)), '.inp']
file = fopen([WRITE_FOLDER, fileName],'wt');

fprintf(file, horzcat('* Fasthenry file "', fileName, '" generated from fastH_tmswrite.m\n'));
fprintf(file, '.units mm\n');
fprintf(file, '.default sigma = 5.8e4 w = 0.5 h = 0.035\n'); % Z always specified.


%% COIL 1
% create a set of x,y values which will form the nodes
[x1,y1] = createCoilPoints(s(1), id(1), turns(1), [0 0]);
% plot x,y value set
figure(1)
grid
hold
plot(x1, y1, '-x', 'DisplayName', 'Coil')
xlim([(min(x1) - 1), (max(x1) + 1)])
ylim([(min(y1) - 1), (max(y1) + 1)])
legend('FontSize',11)
title(['Coil 1 (z = ', num2str(z(1)), ') [dimensions in mm]'])
% turn set of x,y values into fasthenry nodes
N1Max = size(x1,2);
file = nodePrint(file, N1Min, N1Max, x1, y1, z(1));
% connect nodes with E statments & add port connections
file = EPrint(file, N1Min, N1Max, traceWidth(1), 'coil1');


%% COIL 2
N2Min = N1Max + 1;
% create a set of x,y values which will form the nodes
[x2,y2] = createCoilPoints(s(2), id(2), turns(2), offset2);
% plot x,y value set
figure(2)
grid
hold
plot(x2, y2, '-x', 'DisplayName', 'Coil')
xlim([(min(x2) - 0.1), (max(x2) + 0.1)])
ylim([(min(y2) - 0.1), (max(y2) + 0.1)])
legend('FontSize',11)
title(['Coil 2 (z = ', num2str(z(2)), ', ', ...
      'Offset=(', num2str(offset2(1)), ',', num2str(offset2(2)), ')) [dimensions in mm]'])
% turn set of x,y values into fasthenry nodes
N2Max = N1Max + size(x2,2);
file = nodePrint(file, N2Min, N2Max, x2, y2, z(2));
% connect nodes with E statments & add port connections
file = EPrint(file, N2Min, N2Max, traceWidth(2), 'coil2');


% fasthenry "endmatter"
fprintf(file, '.freq fmin = 1e4 fmax  = 1e7 ndec = 1\n');
fprintf(file, '.end\n');
fclose(file);


% save all figures
if (SAVE_IMG)
  saveImages();
endif
