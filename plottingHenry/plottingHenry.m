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
sweepZ = data(:,4);
L1 = data(:,6);
L2 = data(:,7);
M = data(:,8);

% calculate coupling factor (k)
k = M ./ sqrt(L1.*L2);

% determine sweep type
sweepType = [0, 0, 0];
if (!all(sweepX(:) == sweepX(1))) % not all same value => sweep in x
  sweepType(1,1) = 1;
endif

if (!all(sweepY(:) == sweepY(1))) % not all same value => sweep in y
  sweepType(1,2) = 1;
endif

if (!all(sweepZ(:) == sweepZ(1))) % not all same value => sweep in y
  sweepType(1,3) = 1;
endif

if (sum(sweepType) > 1)
  error("2D & 3D SWEEP, currently unsuported")
  % 2d sweep, unsupported rn.
elseif (sweepType == [1,0,0]) % x sweep
  sweepVar = sweepX;
  sweepAxis = "x";
  constCoords = ['y = ', num2str(sweepY(1)), ', z = ', num2str(sweepZ(1))];
elseif (sweepType == [0,1,0]) % y sweep
  sweepVar = sweepY;
  sweepAxis = "y";
  constCoords = ['x = ', num2str(sweepX(1)), ', z = ', num2str(sweepZ(1))];
elseif (sweepType == [0,0,1]) % z sweep
  sweepVar = sweepZ;
  sweepAxis = "z";
  constCoords = ['x = ', num2str(sweepX(1)), ', y = ', num2str(sweepY(1))];
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
title(['L1 (reader) Swept Over ', sweepAxis, '-axis, ', constCoords])

% L2
figure(2)
grid
hold
plot(sweepVar, L2, PLOT_MARKER, 'DisplayName', 'L2')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
ylabel("Inductance [H]")
title(['L2 (tag) Swept Over ', sweepAxis, '-axis, ', constCoords])


% M
figure(3)
grid
hold
plot(sweepVar, M, PLOT_MARKER, 'DisplayName', 'M')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
ylabel("Inductance [H]")
title(['Mutual Inductance Swept Over ', sweepAxis, '-axis, ', constCoords])


% K
figure(4)
grid
hold
plot(sweepVar, k, PLOT_MARKER, 'DisplayName', 'k')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
ylabel("Coupling Factor []")
title(['Coupling Factor (k) Swept Over ', sweepAxis, '-axis, ', constCoords])

%% save figures?
if (SAVE_IMG)
  saveImages();
endif
