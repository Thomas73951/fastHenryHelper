clear all
close all
clc

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
SWEEP_TEXT = '23';
SWEEP_NAME = ["z", SWEEP_TEXT];

% Gain in dB of the system. This is for experimental as power is recorded at the generator.
GAIN = round(26.7);

SAVE_IMG = true; % save figures in images folder
IMG_FOLDER = ['..', filesep 'results', filesep, 'mesh', filesep, '1',  filesep];
##PLOT_MARKER = '-'; % global plot marker for this script
##LINE_WIDTH = 1.5;
% < END OF user defined


sweepName = strtrim(SWEEP_NAME);
folderName = [READ_FOLDER]
sweepNameText = ["[", sweepName, "] "];

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


for i = 1:rows(data)
  xidx = find(xaxis == sweepX(i));
  yidx = find(yaxis == sweepY(i));

  Mmesh(yidx, xidx) = M(i);
endfor


% Only using one quadrant for this.
xaxis = horzcat(flip(-xaxis(2:end)), xaxis);
yaxis = horzcat(flip(-yaxis(2:end)), yaxis);

Mmesh = horzcat(flip(Mmesh(:,2:end), 2), Mmesh);
Mmesh = vertcat(flip(Mmesh(2:end,:), 1), Mmesh);

% NOT PLOTTING M HERE
##figure()
##contourf(xaxis,yaxis, abs(Mmesh)*1e9, 100, 'linestyle', 'none')
##axis square
##colormap("turbo")
##colorbar
####view([0 90])
##xlabel("x [mm]")
##ylabel("y [mm]")
##zlabel("Mutual Inductance [nH]")
##title(["Mutual Inductance [nH] at z = ", SWEEP_TEXT]);
####caxis([0 25])


% calculate coupling factor (k)
L1Avg = mean(L1)
L2Avg = mean(L2)
kmesh = Mmesh / sqrt(L1Avg.*L2Avg);
L1Text = [num2str(L1Avg * 1e6, "%.02f"), "μH"];


figure()
contourf(xaxis,yaxis,abs(kmesh), 100, 'linestyle', 'none')
##surface(xaxis,yaxis,abs(kmesh))
colormap("turbo")
caxis([0 max(max(kmesh))])
xlim([-2 40])
ylim([-2 40])
caxis([0 0.051])
colorbar
axis square

hold on

offset = [0.8 1.5];
for i = 1:numResults
  if (resultsVal(i) != 100)
    h = plot3(resultsX(i), resultsY(i), 1, 'x', 'markeredgecolor', 'white');
    ##set(0, "defaultlinemarkersize", 10);
    set(h, 'LineWidth', 1.5)

    text(resultsX(i) + offset(1), resultsY(i) + offset(2), 1, num2str(resultsVal(i) + GAIN), ...
         'color', 'white', 'fontweight', 'bold') #'FontSize', 14,
  else
    h = plot3(resultsX(i), resultsY(i), 1, 'x', 'markeredgecolor', 'black');
    ##set(0, "defaultlinemarkersize", 10);
    set(h, 'LineWidth', 1.5)

    text(resultsX(i) + offset(1), resultsY(i) + offset(2), 1, "NA", ...
         'color', 'black', 'fontweight', 'bold') # 'FontSize', 14,
  endif
endfor


xlabel("x [mm]")
ylabel("y [mm]")
zlabel("Coupling Factor [k]")
title(["Abs(Coupling Factor) [k] at z = ", SWEEP_TEXT, ...
       "\nCompared to Min Power Required for Detection"]);
legend("Coupling Factor [k]", "Min Antenna Power for Detection [dBm]", ...
       'color', 'black', 'textcolor', 'white')#, 'fontsize', 11)
##fixAxes


%% save figures?
if (SAVE_IMG)
  saveImages(IMG_FOLDER);
endif
