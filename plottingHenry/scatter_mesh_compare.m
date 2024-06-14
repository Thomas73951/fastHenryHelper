clear all
close all
clc

% MODIFIED VERSION OF plottingMultiHenry_mesh_compare.m
% Takes all of the sweeps and looks at the relationship
% between min required power and coupling factor

% MODIFIED VERSION OF plottingMultiHenry_mesh.m
% Compares to experimental read volume measurements from fyp-gpib-visa/keysight/detect_tag_multi.py
% Place results in the same folder as the mesh data, with name "z23_resultsFull.csv" - for z=23

% MODIFIED VERSION OF plottingMultiHenry_stdSweep.m
% Takes data from multiple coils and plots each sweep on a different plot
% (plottingMultiHenry_stdSweep.m takes one coil data and groups sweeps by axis (max 3 figs one for x, y and z sweeps))
% - expects all run with same "standard" sweeps (standard can be anything but consisent across files)
% STANDARD SWEEP VERSION. SWEEP1 = Z SWEEP, SWEEP2-5 = X SWEEPS AT DIFFERENT Z

% <Created for Octave on Arch Linux & Windows>
% Plotting for fastHenry results in csv file created by fasthenryhelper/automatedhenry/
% Requires a sweep over an offset direction.
%
% Uses function file: saveImages.m, fixAxes.m
%
% plottingHenry.m created by Thomas Sharratt Copyright (C) 2024


%% USER DEFINED >
% Read folder is top folder containing sweep folders.

READ_FOLDER = ['..', filesep 'results', filesep, 'mesh', filesep, 'CoilA', filesep];
SWEEP_TEXT = ['0.1';'4';'8';'13';'17';'23'];

% Gain in dB of the system. This is for experimental as power is recorded at the generator.
GAIN = round(26.7);

SAVE_IMG = true; % save figures in images folder
IMG_FOLDER = ['..', filesep 'results', filesep, 'mesh', filesep, '1',  filesep];
##PLOT_MARKER = '-'; % global plot marker for this script
##LINE_WIDTH = 1.5;
% < END OF user defined

rows(SWEEP_TEXT)
figure()
hold on
for i = 1:rows(SWEEP_TEXT)
  SWEEP_NAME = ["z", SWEEP_TEXT(i,:)];

  sweepName = strtrim(SWEEP_NAME);
  folderName = [READ_FOLDER]
##  sweepNameText = ["[", sweepName, "] "];
  sweepNameText = ["z = ", SWEEP_TEXT(i,:)];

  %% Read csv file
  csvFileName = [sweepName, '_inductances.csv'];
  data = csvread([folderName, csvFileName]);
  sweepX = data(:,2); % requires comma separated folder name: ".../Offset,x,y/"
  sweepY = data(:,3);
  sweepZ = data(:,4);
  L1 = data(:,6);
  L2 = data(:,7);
  M = data(:,8);

  % Import results data.
  resultsFileName = [sweepName, "_resultsFull.csv"];
  results = csvread([folderName, resultsFileName]);

  % Setup results data
  resultsX = results(:,1);
  resultsY = results(:,2);
  % not taking z as it's constant
  resultsVal = results(:,4);
  numResults = rows(results);


  % Convert to mesh
  Mmesh = [];

  xaxis = linspace(0, 40, 41);
  yaxis = xaxis;


  for j = 1:rows(data)
    xidx = find(xaxis == sweepX(j));
    yidx = find(yaxis == sweepY(j));

    Mmesh(yidx, xidx) = M(j);
  endfor


  % calculate coupling factor (k)
  L1Avg = mean(L1)
  L2Avg = mean(L2)
  kmesh = Mmesh / sqrt(L1Avg.*L2Avg);
  L1Text = [num2str(L1Avg * 1e6, "%.02f"), "μH"];

  % find corresponding k for each result
  scatterK = [];
  for k = 1:numResults % TODO: Fix plotting the DNF (100) values
    xidx2 = find(xaxis == resultsX(k));
    yidx2 = find(yaxis == resultsY(k));
    scatterK(k) = kmesh(xidx2,yidx2);
  endfor
  plot(abs(scatterK), resultsVal+GAIN, 'x', 'DisplayName', sweepNameText)

endfor

xlabel("Coupling Factor [k]")
ylabel("Min Required Power [dBm]")
ylim([0 30])
grid on
legend()
title("Coil A")


%% save figures?
if (SAVE_IMG)
  saveImages(IMG_FOLDER);
endif
