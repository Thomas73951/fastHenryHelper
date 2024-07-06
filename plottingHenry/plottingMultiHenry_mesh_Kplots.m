clear all
close all
clc

% MODIFIED AGAIN, basically it now does 3D "read volumes" for a given K.

% <Created for Octave on Arch Linux & Windows>
% Plotting for fastHenry results in csv file created by fasthenryhelper/automatedhenry/
%
% Uses function file: saveImages.m
%
% plottingHenry.m created by Thomas Sharratt Copyright (C) 2024


%% USER DEFINED >
% Read folder is top folder containing sweep folders.

KMIN = 0.0057;

READ_FOLDER = ['..', filesep 'results', filesep, 'mesh', filesep, 'CoilA', filesep];
SWEEP_TEXT = ['0.1';'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'12';'13';'14';'15';'16';'17';'19';'21';'23'];
##READ_FOLDER = ['..', filesep 'results', filesep, 'mesh', filesep, 'CoilC', filesep];
##SWEEP_TEXT = ['0.1';'1';'2';'3';'4';'5';'6';'8';'10';'13';'15';'17';'19';'21';'23';'25'];

SAVE_IMG = true; % save figures in images folder
IMG_FOLDER = ['..', filesep 'results', filesep, 'mesh', filesep, '5',  filesep];
##PLOT_MARKER = '-'; % global plot marker for this script
##LINE_WIDTH = 1.5;
% < END OF user defined

TITLE = ["Coil A: Points of k > ", num2str(KMIN)];
##TITLE = ["Coil C: Points of k > ", num2str(KMIN)];


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
surf(megaxaxis, megayaxis, megaz, 'linestyle', 'none')
##surface(megaxaxis, megayaxis, megaz, 'linestyle', 'none')
##numLevels = max(max(z)) + 2; % with -1 for nada, +2 gives levels of 1 mm
numLevels = 21 + 1;
##contourf(megaxaxis, megayaxis, megaz, numLevels, 'linestyle', 'none')
##contourf(megaxaxis, megayaxis, megaz, 23, 'linestyle', 'none')

grid off
grid on
view([0 0])

##surface(xaxis,yaxis,abs(kmesh))
colormap("turbo")
##caxis([0 max(max(kmesh))])
##caxis([0.005 0.03])
colorbar
axis square
xlabel("x [mm]")
ylabel("y [mm]")
zlabel("z [mm]")
title(TITLE)


##xlim([-30 30])
##ylim([-30 30])
##zlim([0 max(max(megaz))])
zlim([0 21])
caxis([-1 21])

%% save figures?
if (SAVE_IMG)
  saveImages(IMG_FOLDER);
endif
