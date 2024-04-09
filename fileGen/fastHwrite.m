clear all
close all
clc

% <Created for Octave on Arch Linux & Windows>
% Creates a .inp file with two coils with specified:
% spacing, inner diameter, turn count, trace width, z position, and offset.
% Offset as matrix of x rows of x,y value pairs.
% One to generate one file, multiple rows for multiple files generated.
% .inp file is saved to writeFolder with an name generated from parameters,
% and optionally each file is put into its own subfolder...
% (due to how fastHenry saves Zc.mat, overwritten otherwise)
%
% figures are optionally saved to images/ with SAVE_IMG = true.
% Points for createSVG are optionally saved as csv files with SAVE_POINTS_CSV = true.
%
% .inp files are netlist style files read by FastHenry2 by FastFieldSolvers.
% Reader coil denoted as Coil1, Tag coil denoted as Coil2
%
% Uses function files: createCoilPoints.m, EPrint.m, nodePrint.m, saveImages.m
%
% fastHwrite.m created by Thomas Sharratt Copyright (C) 2024
% from: fasthenry_write.m from Imperial College ELEC70101 Sensors Coursework


%% USER DEFINED >
% n.b. file name is auto generated
##TOP_FOLDER = ['..', filesep, 'automatedHenry', filesep 'testfiles', filesep, 'offsetcoils', filesep];
TOP_FOLDER = ['..', filesep 'testfiles', filesep, 'mesh', filesep]
EXT_FOLDER = ['CoilA', filesep, 'z23', filesep];
SHOW_FIGURES = false; % optionally supress figure opening, creates .inp files only
SAVE_IMG = false; % save figures in images folder
SAVE_POINTS_CSV = false; % save two csv files (x & y) for use with createSVG (svg_coil.py)
% v puts each file into a subfolder - can only be used with multiple offset values
USE_SUBFOLDERS = true;

% units in mm.
s = [1.0 0.1]; % spacing
id = [40 0.2]; % inner diameter
turns = [5 20]; % number of complete turns
traceWidth = [0.4 0.03]; % trace width
portSpacing = [1 0.1]; % x spacing of ports brought to bottom middle of coil
% v z offset of trace to bring ports to bottom middle of coil...
%   i.e. trace on other side of pcb therefore pcb board thickness.
boardThickness = [-1.6 0.1];
freqSweep = "fmin = 1e4 fmax  = 1e7 ndec = 1"; % set frequency setpoint(s) (all files)

% Coil1 is "normalised" at (0, 0, 0)
OFFSET_DP = 1; % set number of decimal points in offset values
% set of offsets for coil2 (x,y,z). Creates one file for each offset triplet given
% e.g. two pairs: [0 0 5; 1 0 5] - coil2 at y=0, z=5, moves from x=0 -> x=1
##offset2 = [0 0 5];
##offset2 = [0 0; 1 0; 2 0];

##offsetY = linspace(0, 20, 101); % y sweep
##offsetX = zeros(size(offsetY));
##offsetZ = 5 * ones(size(offsetX));
##offset2 = transpose([offsetX; offsetY; offsetZ]);

##offsetZ = linspace(1, 21, 101); % Z sweep
##offsetX = zeros(size(offsetZ));
##offset2 = transpose([offsetX; offsetY; offsetZ]);
##offsetY = zeros(size(offsetZ));

% xy sweep
##zval = 4;
##offsetX = linspace(0, 40, 101); % x sweep
##offsetY = offsetX; #zeros(size(offsetX));
##offsetZ = zval * ones(size(offsetX));
##offset2 = transpose([offsetX; offsetY; offsetZ]);

% "mesh" sweep
a = linspace(0, 40, 41);
zval = 23;
##zval = 0.1;
offsetX = [];
offsetY = [];
offsetZ = [];
numpoints = columns(a)
% generates all for x > 0, y > 0 (one quadrant)
% NOT DOING: and also x => y,
% roughly 1/8 of state space. Possible because coil is square so abusing symmetry
for i = 1:numpoints % for x
  for j = 1:numpoints % for y
##    if (!(a(j)>a(i))) % "!(y > x)" takes 1/8 of space rather than one quadrant
    offsetX = [offsetX, a(i)];
    offsetY = [offsetY, a(j)];
    offsetZ = [offsetZ, zval];
##    endif
  endfor
endfor
offset2 = transpose([offsetX; offsetY; offsetZ]);


% < END OF user defined

% Setup bits
writeFolder = [TOP_FOLDER, EXT_FOLDER];
numOffsets = size(offset2, 1)
N1Min = 1;
% format for num2str, gives right padding
maxNumDigits = floor(log10(max(max(offset2)))) + 1; % num of digits of max value
offsetFormat = ["%0", num2str(maxNumDigits + 1 + OFFSET_DP), ...
                ".", num2str(OFFSET_DP), "f"];

% test size of gap between adjacent traces in coil
gap = s - traceWidth
if any(gap < 0)
  error("TRACES OVERLAP. Spacing too small or trace width too large, exiting...")
endif

% WRITE FOLDER exists?
if (!exist(writeFolder))
  disp("writeFolder directory doesn't exist, creating...")
  mkdir(writeFolder);
endif


%% Create .inp file(s)
for iterINP = 1:numOffsets
  %% fasthenry "frontmatter"
  fileName = ['fh_C1_T', num2str(turns(1)), '_ID', num2str(id(1)), '_S', num2str(s(1)), ...
              '_C2_T', num2str(turns(2)), '_ID', num2str(id(2)), '_S', num2str(s(2)), ...
              '_O' num2str(offset2(iterINP,1)), '_', num2str(offset2(iterINP,2)), '.inp']
  if (USE_SUBFOLDERS && numOffsets > 1) % only needed for multiple offsets
    % subfolder name: "Offset, x,y,z"
    subfolder = ['Offset,', num2str(offset2(iterINP,1), offsetFormat), ...
                 ',', num2str(offset2(iterINP,2), offsetFormat), ...
                 ',', num2str(offset2(iterINP,3), offsetFormat)];

    if (!exist([writeFolder, subfolder, filesep]))
      mkdir(writeFolder, subfolder); % create subfolder if doesnt exist
    endif
    file = fopen([writeFolder, subfolder, filesep, fileName],'wt');
  else
    file = fopen([writeFolder, fileName],'wt');
  endif

  fprintf(file, horzcat('* Fasthenry file "', fileName, ...
                        '" generated from fastH_tmswrite.m\n'));
  fprintf(file, '.units mm\n');
  fprintf(file, '.default sigma = 5.8e4 h = 0.035\n');


  %% COIL 1
  % create a set of x,y values which will form the nodes
  [x1,y1, z1] = createCoilPoints(s(1), id(1), turns(1), [0 0 0], boardThickness(1), portSpacing(1));
  % plot x,y value set
  if (SHOW_FIGURES)
    figure(iterINP*2-1)
    grid
    hold
    plot(x1, y1, '-x', 'DisplayName', 'Coil')
    xlim([(min(x1) - 1), (max(x1) + 1)])
    ylim([(min(y1) - 1), (max(y1) + 1)])
    legend('FontSize',11)
    title(['Coil 1, z = 0, W = ', num2str(traceWidth(1)), ...
           ' [dimensions in mm]'])
  endif
  % turn set of x,y values into fasthenry nodes
  N1Max = size(x1,2);
  file = nodePrint(file, N1Min, N1Max, x1, y1, z1);
  % connect nodes with E statments & add port connections
  file = EPrint(file, N1Min, N1Max, traceWidth(1), 'coil1');


  %% COIL 2
  N2Min = N1Max + 1;
  % create a set of x,y values which will form the nodes
  [x2,y2,z2] = createCoilPoints(s(2), id(2), turns(2), offset2(iterINP,:), boardThickness(2), portSpacing(2));
  % plot x,y value set
  if (SHOW_FIGURES)
    figure(iterINP*2)
    grid
    hold
    plot(x2, y2, '-x', 'DisplayName', 'Coil')
    xlim([(min(x2) - 0.1), (max(x2) + 0.1)])
    ylim([(min(y2) - 0.1), (max(y2) + 0.1)])
    legend('FontSize',11)
    title(['Coil 2, W = ', num2str(traceWidth(2)), ...
           ', Offset=(', num2str(offset2(iterINP,1)), ',', ...
           num2str(offset2(iterINP,2)), ',', num2str(offset2(iterINP,3)), ...
           ') [dimensions in mm]'])
  endif
  % turn set of x,y values into fasthenry nodes
  N2Max = N1Max + size(x2,2);
  file = nodePrint(file, N2Min, N2Max, x2, y2, z2);
  % connect nodes with E statments & add port connections
  file = EPrint(file, N2Min, N2Max, traceWidth(2), 'coil2');


  % fasthenry "endmatter"
  fprintf(file, ['.freq ', freqSweep, '\n']);
  fprintf(file, '.end\n');
  fclose(file);
endfor

% Display Coil1 size.
readerXSize = max(x1) - min(x1);
readerYSize = max(y1) - min(y1);
if (readerXSize == readerYSize)
  disp(["Reader coil measures ", num2str(readerXSize), " mm square"])
else
  disp(["Reader coil measures ", num2str(readerXSize), "x", num2str(readerYSize), " mm"])
endif

% save all figures
if (SAVE_IMG && SHOW_FIGURES)
  saveImages("images/");
endif

% saves x and y points into a CSV for use with createSVG
% crops underneath ones - first few that bring port from centre to bottom middle via back of board
if (SAVE_POINTS_CSV)
  svgFolder = ['..', filesep 'createSVG', filesep];
  csvwrite([svgFolder, "coil_points_x.csv"], x1(4:end));
  csvwrite([svgFolder, "coil_points_y.csv"], y1(4:end));
endif

xL = 0;
yL = 0;
for i = 2:size(x1,2)
  xL = xL + abs(x1(i) - x1(i-1));
  yL = yL + abs(y1(i) - y1(i-1));
endfor
coilLength = (xL + yL) / 1e3

rho = 1.7e-8;
CSA = 35e-6 * 0.4e-3;
R = (rho * coilLength) / CSA
