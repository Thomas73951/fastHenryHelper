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
FILE_NAME = "mutualinductances.csv";
SAVE_IMG = false; % save figures in images folder
% < END OF user defined

%% Read csv file
data = csvread([READ_FOLDER, FILE_NAME]);
L1 = data(:,2);
L2 = data(:,3);
M = data(:,4);

%% Manipulate file
sweepVar = linspace(0, 10, 11);
% calculate coupling factor (k)
k = M ./ sqrt(L1.*L2);

%% Plotting
% L1
figure(1)
grid
hold
plot(sweepVar, L1, 'DisplayName', 'L1')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel("Swept Offset Variable [mm]")
ylabel("Inductance [H]")
title('L1 (reader) Over Swept Offset Variable')

% L2
figure(2)
grid
hold
plot(sweepVar, L2, 'DisplayName', 'L2')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel("Swept Offset Variable [mm]")
ylabel("Inductance [H]")
title('L2 (tag) Over Swept Offset Variable')


% M
figure(3)
grid
hold
plot(sweepVar, M, 'DisplayName', 'M')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel("Swept Offset Variable [mm]")
ylabel("Inductance [H]")
title('Mutual Inductance Over Swept Offset Variable')


% K
figure(4)
grid
hold
plot(sweepVar, k, 'DisplayName', 'k')
legend('FontSize',11)
xlim([sweepVar(1), sweepVar(end)])
xlabel("Swept Offset Variable [mm]")
ylabel("Coupling Factor []")
title('Coupling Factor (k) Over Swept Offset Variable')

%% save figures?
if (SAVE_IMG)
  saveImages();
endif
