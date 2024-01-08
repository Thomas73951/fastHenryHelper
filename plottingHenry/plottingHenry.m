clear all
close all
clc

% <Created for Octave on Arch Linux & Windows>
% Plotting for fastHenry results in csv file created by fasthenryhelper/automatedhenry/
% Requires a sweep over an offset direction.
%
% Uses function file: saveImages.m
%
% plottingHenry.m created by Thomas Sharratt Copyright (C) 2024


%% USER DEFINED >
READ_FOLDER = ['results', filesep]; %, 'offset-y-0-20-101', filesep];
FILE_NAME_INDUCTANCES = "offset-x-0-20-101-z5_inductances.csv";
SAVE_IMG = false; % save figures in images folder
PLOT_MARKER = '-'; % global plot marker for this script
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

if (sweepType == [1,1])
  error("2D SWEEP, currently unsuported")
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
plot(sweepVar, L1, PLOT_MARKER, 'DisplayName', 'L1')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
ylabel("Inductance [H]")
title(['L1 (reader) Swept Over ', sweepAxis, '-axis'])

% L2
figure(2)
grid
hold
plot(sweepVar, L2, PLOT_MARKER, 'DisplayName', 'L2')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
ylabel("Inductance [H]")
title(['L2 (tag) Swept Over ', sweepAxis, '-axis'])


% M
figure(3)
grid
hold
plot(sweepVar, M, PLOT_MARKER, 'DisplayName', 'M')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
ylabel("Inductance [H]")
title(['Mutual Inductance Swept Over ', sweepAxis, '-axis'])


% K
figure(4)
grid
hold
plot(sweepVar, k, PLOT_MARKER, 'DisplayName', 'k')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
ylabel("Coupling Factor []")
title(['Coupling Factor (k) Swept Over ', sweepAxis, '-axis'])

%% save figures?
if (SAVE_IMG)
  saveImages();
endif
