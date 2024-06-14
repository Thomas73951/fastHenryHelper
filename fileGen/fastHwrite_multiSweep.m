clear all
close all
clc

% <Created for Octave on Arch Linux & Windows>
% CREATES MULTIPLE SWEEPS - setup X sweeps in USER DEFINED for the X function calls of makeFiles()
% MODIFIED FROM fastHWrite.m by Thomas Sharratt for the application of creating a set of sweeps
% Use in conjunction with automatedMultiHenry.vbs
%
% fastHwrite.m front matter:
% Creates a set of swept .inp files with two coils with specified:
% spacing, inner diameter, turn count, trace width, z position, and offset.
% Offset as matrix of x rows of x,y value pairs.
% One to generate one file, multiple rows for multiple files generated.
% .inp file is saved to writeFolder with an name generated from parameters,
% and optionally each file is put into its own subfolder...
% (due to how fastHenry saves Zc.mat, overwritten otherwise)
% figures are optionally saved to images/ with SAVE_IMG = true.
%
% .inp files are netlist style files read by FastHenry2 by FastFieldSolvers.
% Reader coil denoted as Coil1, Tag coil denoted as Coil2
%
% Uses function files: createCoilPoints.m, EPrint.m, nodePrint.m, saveImages.m
%
% fastH_multiSweep.m created by Thomas Sharratt Copyright (C) 2024
% from: fastHwrite.m created by Thomas Sharratt Copyright (C) 2024
%       from: fasthenry_write.m from Imperial College ELEC70101 Sensors Coursework


%% USER DEFINED >
% n.b. file name is auto generated
TOP_FOLDER = ['..', filesep 'testfiles', filesep, 'offsetcoilsbiglittle', filesep];
##TOP_FOLDER = ['..', filesep 'testfiles', filesep, 'indiv-coils', filesep];
SHOW_FIGURES = false; % optionally supress figure opening, creates .inp files only
SAVE_IMG = false; % save figures in images folder
% v puts each file into a subfolder - can only be used with multiple offset values
USE_SUBFOLDERS = true;

% units in mm.
s = [1 0.1]; % spacing
id = [20 0.2]; % inner diameter
turns = [16 20]; % number of complete turns
traceWidth = [0.4 0.03]; % trace width
portSpacing = [1 0.1]; % x spacing of ports brought to bottom middle of coil
% v z offset of trace to bring ports to bottom middle of coil...
%   i.e. trace on other side of pcb therefore pcb board thickness.
boardThickness = [-1.6 0.1];
freqSweep = "fmin = 1e4 fmax  = 1e7 ndec = 1"; % set frequency setpoint(s) (all files)

% Coil1 is "normalised" at (0, 0, 0)
OFFSET_DP = 1; % set number of decimal points in offset values
% set of offsets for coil2 (x,y,z). Creates one file for each offset triplet given
% e.g. two pairs: [0 0 5; 1 0 5] - coil2 at y=0, z=5, moves from x=0 -> x=

offsetZ = linspace(1, 41, 101); % sweepA - z sweep
offsetX = zeros(size(offsetZ));
offsetY = zeros(size(offsetZ));
sweepA = transpose([offsetX; offsetY; offsetZ]);

offsetX = linspace(0, 40, 101); % sweepB - x sweep, z=5mm
offsetY = zeros(size(offsetX));
offsetZ = 5 * ones(size(offsetX));
sweepB = transpose([offsetX; offsetY; offsetZ]);

% sweepC - x sweep, z=10mm
offsetZ = 10 * ones(size(offsetX));
sweepC = transpose([offsetX; offsetY; offsetZ]);

% sweepD - x sweep, z=20mm
offsetZ = 20 * ones(size(offsetX));
sweepD = transpose([offsetX; offsetY; offsetZ]);

% sweepE - x sweep, z=40mm
offsetZ = 40 * ones(size(offsetX));
sweepE = transpose([offsetX; offsetY; offsetZ]);

% < END OF user defined


% Setup bits - folder structure
coil1Folder = ['C1_T', num2str(turns(1)), '_ID', num2str(id(1)), ...
               '_S', num2str(s(1)), '_W', num2str(traceWidth(1)), filesep]
coil2Folder = ['C2_T', num2str(turns(2)), '_ID', num2str(id(2)), ...
               '_S', num2str(s(2)), '_W', num2str(traceWidth(2)), filesep]
writeFolder = [TOP_FOLDER, coil1Folder, coil2Folder];


% test size of gap between adjacent traces in coil
gap = s - traceWidth
if any(gap < 0)
  error("TRACES OVERLAP. Spacing too small or trace width too large, exiting...")
endif


% creates .inp files like in fastHwrite.m but as a function call for multiple sweeps for each offset2 matrix.
function makeFiles(writeFolder, USE_SUBFOLDERS, SHOW_FIGURES, SAVE_IMG, s, id, turns, traceWidth, portSpacing, boardThickness, freqSweep, offset2, offsetDP)
  numOffsets = size(offset2, 1)
  N1Min = 1;
  % format for num2str, gives right padding
  maxNumDigits = floor(log10(max(max(offset2)))) + 1; % num of digits of max value
  offsetFormat = ["%0", num2str(maxNumDigits + 1 + offsetDP), ...
                  ".", num2str(offsetDP), "f"];

  % WRITE FOLDER exists?
  if (!exist(writeFolder))
    disp([writeFolder, " directory doesn't exist, creating..."])
    mkdir(writeFolder);
  endif

  %% Create .inp file(s)
  for iterINP = 1:numOffsets
    fileName = ['Coil1_0_0_0_Coil2_', num2str(offset2(iterINP,1), offsetFormat), ...
                '_', num2str(offset2(iterINP,2), offsetFormat), ...
                '_', num2str(offset2(iterINP,3), offsetFormat), '.inp'];
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

    %% fasthenry "frontmatter"
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
    saveImages(["images", filesep]);
  endif

endfunction




% function calls

% Sweep A
%makeFiles(writeFolder,                     USE_SUBFOLDERS, SHOW_FIGURES, SAVE_IMG, s, id, turns, traceWidth, portSpacing, boardThickness, freqSweep, offset2,offsetDP )
makeFiles([writeFolder, 'Sweep1', filesep], USE_SUBFOLDERS, SHOW_FIGURES, SAVE_IMG, s, id, turns, traceWidth, portSpacing, boardThickness, freqSweep, sweepA, OFFSET_DP)

% Sweep B
makeFiles([writeFolder, 'Sweep2', filesep], USE_SUBFOLDERS, SHOW_FIGURES, SAVE_IMG, s, id, turns, traceWidth, portSpacing, boardThickness, freqSweep, sweepB, OFFSET_DP)

% Sweep C
makeFiles([writeFolder, 'Sweep3', filesep], USE_SUBFOLDERS, SHOW_FIGURES, SAVE_IMG, s, id, turns, traceWidth, portSpacing, boardThickness, freqSweep, sweepC, OFFSET_DP)

% Sweep D
makeFiles([writeFolder, 'Sweep4', filesep], USE_SUBFOLDERS, SHOW_FIGURES, SAVE_IMG, s, id, turns, traceWidth, portSpacing, boardThickness, freqSweep, sweepD, OFFSET_DP)

% Sweep E
makeFiles([writeFolder, 'Sweep5', filesep], USE_SUBFOLDERS, SHOW_FIGURES, SAVE_IMG, s, id, turns, traceWidth, portSpacing, boardThickness, freqSweep, sweepE, OFFSET_DP)
