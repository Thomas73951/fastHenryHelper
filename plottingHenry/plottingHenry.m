clear all
close all
clc

% <Created for Octave on Arch Linux>
% TODO: DESCRIPTION
%
%
%
% plottingHenry.m created by Thomas Sharratt Copyright (C) 2023


%% USER DEFINED >
READ_FOLDER = "results/";
FILE_NAME_INDUCTANCES = "inductances.csv";
FILE_NAME_SWEEP = "sweepdetails.csv";
SAVE_IMG = false; % save figures in images folder
% < END OF user defined

%% Read csv file
data = csvread([READ_FOLDER, FILE_NAME_INDUCTANCES]);
L1 = data(:,2);
L2 = data(:,3);
M = data(:,4);

%% Manipulate file
sweepData = csvread([READ_FOLDER, FILE_NAME_SWEEP]);

sweepType = sweepData(1,:); % first row only
sweepX = sweepData(2:end,1);
sweepY = sweepData(2:end,2);

if (sweepType == [1,1])
  error("2D SWEEP, currently unsuported")
  % 2d sweep, unsupported rn.
elseif (sweepType == [1,0]) % x sweep
  sweepVar = sweepX;
  sweepAxis = "x";
elseif (sweepType == [0,1]) % y sweep
  sweepVar = sweepY;
  sweepAxis = "y";
endif

% calculate coupling factor (k)
k = M ./ sqrt(L1.*L2);

%% Plotting
% L1
figure(1)
grid
hold
plot(sweepVar, L1, '-x', 'DisplayName', 'L1')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
ylabel("Inductance [H]")
title(['L1 (reader) Swept Over ', sweepAxis, '-axis'])

% L2
figure(2)
grid
hold
plot(sweepVar, L2, '-x', 'DisplayName', 'L2')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
ylabel("Inductance [H]")
title(['L2 (tag) Swept Over ', sweepAxis, '-axis'])


% M
figure(3)
grid
hold
plot(sweepVar, M, '-x', 'DisplayName', 'M')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
ylabel("Inductance [H]")
title(['Mutual Inductance Swept Over ', sweepAxis, '-axis'])


% K
figure(4)
grid
hold
plot(sweepVar, k, '-x', 'DisplayName', 'k')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
ylabel("Coupling Factor []")
title(['Coupling Factor (k) Swept Over ', sweepAxis, '-axis'])

%% save figures?
if (SAVE_IMG)
  saveImages();
endif
