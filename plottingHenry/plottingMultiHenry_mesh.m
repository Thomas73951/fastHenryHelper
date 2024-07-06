clear all
close all
clc

% MESH Plotting, single Z set point.

% <Created for Octave on Arch Linux & Windows>
% Plotting for fastHenry results in csv file created by fasthenryhelper/automatedhenry/
%
% Uses function file: saveImages.m
%
% plottingHenry.m created by Thomas Sharratt Copyright (C) 2024


%% USER DEFINED >
% Read folder is top folder containing sweep folders.

READ_FOLDER = ['..', filesep 'results', filesep, 'mesh', filesep, 'CoilA', filesep];
SWEEP_TEXT = '23';
SWEEP_FOLDER = ["z", SWEEP_TEXT, filesep];

SAVE_IMG = true; % save figures in images folder
IMG_FOLDER = ['..', filesep 'results', filesep, 'mesh', filesep, '2',  filesep];
##PLOT_MARKER = '-'; % global plot marker for this script
##LINE_WIDTH = 1.5;
% < END OF user defined


sweepName = strtrim(SWEEP_FOLDER)(1:end-1);
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

% Convert to mesh
Mmesh = [];

xaxis = linspace(0, 40, 41);
yaxis = xaxis;


for i = 1:rows(data)
  xidx = find(xaxis == sweepX(i));
  yidx = find(yaxis == sweepY(i));

  Mmesh(yidx, xidx) = M(i);
endfor



xaxis = horzcat(flip(-xaxis(2:end)), xaxis);
yaxis = horzcat(flip(-yaxis(2:end)), yaxis);

Mmesh = horzcat(flip(Mmesh(:,2:end), 2), Mmesh);
Mmesh = vertcat(flip(Mmesh(2:end,:), 1), Mmesh);

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
##caxis([0 max(max(kmesh))])
caxis([0 0.051])
colorbar
axis square
xlabel("x [mm]")
ylabel("y [mm]")
zlabel("Coupling Factor [k]")
title(["Coupling Factor [k] at z = ", SWEEP_TEXT]);



%% save figures?
if (SAVE_IMG)
  saveImages(IMG_FOLDER);
endif
