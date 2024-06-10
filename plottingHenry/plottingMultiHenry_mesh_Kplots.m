clear all
close all
clc

% MODIFIED AGAIN, basically it now does 3D "read volumes" for a given K.

% MODIFIED VERSION OF plottingMultiHenry_stdSweep.m
% Takes data from multiple coils and plots each sweep on a different plot
% (plottingMultiHenry_stdSweep.m takes one coil data and groups sweeps by axis (max 3 figs one for x, y and z sweeps))
% - expects all run with same "standard" sweeps (standard can be anything but consisent across files)
% STANDARD SWEEP VERSION. SWEEP1 = Z SWEEP, SWEEP2-5 = X SWEEPS AT DIFFERENT Z

% <Created for Octave on Arch Linux & Windows>
% Plotting for fastHenry results in csv file created by fasthenryhelper/automatedhenry/
% Requires a sweep over an offset direction.
%
% Uses function file: saveImages.m
%
% plottingHenry.m created by Thomas Sharratt Copyright (C) 2024


%% USER DEFINED >
% Read folder is top folder containing sweep folders.

KMIN = 0.0053;

##READ_FOLDER = ['..', filesep 'results', filesep, 'mesh', filesep, 'CoilA', filesep];
READ_FOLDER = ['..', filesep 'results', filesep, 'mesh', filesep, 'CoilC', filesep];
##SWEEP_TEXT = ['0.1';'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'13';'15';'17';'19';'21';'23'];
SWEEP_TEXT = ['4';'8';'13';'23'];

SAVE_IMG = false; % save figures in images folder
IMG_FOLDER = ['..', filesep 'results', filesep, 'mesh', filesep, '2',  filesep];
##PLOT_MARKER = '-'; % global plot marker for this script
##LINE_WIDTH = 1.5;
% < END OF user defined


xaxis = linspace(0, 40, 41);
yaxis = xaxis;
z = ones(41) * -1; % set them all a bit below



for zPoint = 1:rows(SWEEP_TEXT)
  currZ = str2num(strtrim(SWEEP_TEXT(zPoint,:)));
  SWEEP_FOLDER = ["z", strtrim(SWEEP_TEXT(zPoint,:)), filesep];
  sweepName = strtrim(SWEEP_FOLDER)(1:end-1);
  folderName = [READ_FOLDER]
  ##sweepNameText = ["[", sweepName, "] "];


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



  for i = 1:rows(data)
    xidx = find(xaxis == sweepX(i));
    yidx = find(yaxis == sweepY(i));

    Mmesh(yidx, xidx) = M(i);
  endfor




##  Mmesh = horzcat(flip(Mmesh(:,2:end), 2), Mmesh);
##  Mmesh = vertcat(flip(Mmesh(2:end,:), 1), Mmesh);

  % calculate coupling factor (k)

  L1Avg = mean(L1)
  L2Avg = mean(L2)

  kmesh = abs(Mmesh / sqrt(L1Avg.*L2Avg));

  for i = 1:columns(xaxis)
    for j = 1:columns(yaxis)
      if (kmesh(i,j) >= KMIN)
        z(i,j) = currZ;
      endif
    endfor
  endfor

##  L1Text = [num2str(L1Avg * 1e6, "%.02f"), "μH"];


endfor

% now interpolate
megaz = interp2(z, 4);
megaxaxis = linspace(0, 40, 641);
megayaxis = megaxaxis;


##xaxis = horzcat(flip(-xaxis(2:end)), xaxis);
##yaxis = horzcat(flip(-yaxis(2:end)), yaxis);
##z = horzcat(flip(z(:,2:end), 2), z);
##z = vertcat(flip(z(2:end,:), 1), z);

megaxaxis = horzcat(flip(-megaxaxis(2:end)), megaxaxis);
megayaxis = horzcat(flip(-megayaxis(2:end)), megayaxis);
megaz = horzcat(flip(megaz(:,2:end), 2), megaz);
megaz = vertcat(flip(megaz(2:end,:), 1), megaz);


figure()
##surf(xaxis, yaxis, z, 'linestyle', 'none')
##surf(megaxaxis, megayaxis, megaz, 'linestyle', 'none')
##surface(megaxaxis, megayaxis, megaz, 'linestyle', 'none')
numLevels = max(max(z)) + 2; % with -1 for nada, +2 gives levels of 1 mm
contourf(megaxaxis, megayaxis, megaz, numLevels, 'linestyle', 'none')

grid off
##surface(xaxis,yaxis,abs(kmesh))
colormap("turbo")
##caxis([0 max(max(kmesh))])
##caxis([0.005 0.03])
colorbar
axis square
xlabel("x [mm]")
ylabel("y [mm]")
zlabel("z [mm]")
title(["points of k = ", num2str(KMIN), " or better"])


##xlim([-30 30])
##ylim([-30 30])
zlim([0 max(max(megaz))])

%% save figures?
if (SAVE_IMG)
  saveImages(IMG_FOLDER);
endif
