clear all
close all
clc

% <Created for Octave on Arch Linux>
% Plotting for fastHenry results in csv file created by fasthenryhelper/automatedhenry/
% Requires a sweep over an offset direction.
%
% Uses function file: saveImages.m
%
% plottingHenry.m created by Thomas Sharratt Copyright (C) 2024


%% USER DEFINED >
READ_FOLDER = "results/offsetcoils-xy-0-10-11/";
FILE_NAME_INDUCTANCES = "inductances.csv";
SAVE_IMG = false; % save figures in images folder
PLT_LINE_STYLE = "-x";
% < END OF user defined

%% Read csv file
data = csvread([READ_FOLDER, FILE_NAME_INDUCTANCES]);
sweepX = data(:,2); % requires comma separated folder name: ".../Offset,x,y/"
sweepY = data(:,3);
L1 = data(:,5);
L2 = data(:,6);
M = data(:,7);

% calculate coupling factor (k)
k = M ./ sqrt(L1.*L2);

% determine sweep type
sweepType = [0, 0];
if (any(sweepX) != sweepX(1)) % any not the same as first => sweep in x
  sweepType(1,1) = 1;
endif

if (any(sweepY) != sweepY(1)) % any not the same as first => sweep in y
  sweepType(1,2) = 1;
endif

sweep2D = false;
if (sweepType == [1,1])
  % error("2D SWEEP, currently unsuported")
  sweep2D = true;
  % 2d sweep, unsupported rn.
elseif (sweepType == [1,0]) % x sweep
  sweepVar = sweepX;
  sweepAxis = "x";
elseif (sweepType == [0,1]) % y sweep
  sweepVar = sweepY;
  sweepAxis = "y";
else
  error("NO SWEEP FOUND. Cannot plot over single point")
endif


%% Plotting
% L1
figure(1)
grid
hold
if (sweep2D)
  plot3(sweepX, sweepY, L1, 'x')
  view(3)
else
  plot(sweepVar, L1, PLT_LINE_STYLE, 'DisplayName', 'L1')
  xlim([sweepVar(1), sweepVar(end)])
  legend('FontSize',11)
  xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
  ylabel("Inductance [H]")
  title(['L1 (reader) Swept Over ', sweepAxis, '-axis'])
endif


% L2
figure(2)
grid
hold
if (sweep2D)
  plot3(sweepX, sweepY, L2, 'x')
  view(3)
else
  plot(sweepVar, L2, PLT_LINE_STYLE, 'DisplayName', 'L2')
  xlim([sweepVar(1), sweepVar(end)])
  legend('FontSize',11)
  xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
  ylabel("Inductance [H]")
  title(['L2 (tag) Swept Over ', sweepAxis, '-axis'])
endif


% M
figure(3)
grid
hold
if (sweep2D)
  plot3(sweepX, sweepY, M, 'x')
  view(3)
else
  plot(sweepVar, M, PLT_LINE_STYLE, 'DisplayName', 'M')
  xlim([sweepVar(1), sweepVar(end)])
  legend('FontSize',11)
  xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
  ylabel("Inductance [H]")
  title(['Mutual Inductance Swept Over ', sweepAxis, '-axis'])
endif



% K
figure(4)
grid
hold
if (sweep2D)
  plot3(sweepX, sweepY, k, 'x')
  view(3)
else
  plot(sweepVar, k, PLT_LINE_STYLE, 'DisplayName', 'k')
  xlim([sweepVar(1), sweepVar(end)])
  legend('FontSize',11)
  xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
  ylabel("Coupling Factor []")
  title(['Coupling Factor (k) Swept Over ', sweepAxis, '-axis'])
endif

%% save figures?
if (SAVE_IMG)
  saveImages();
endif
