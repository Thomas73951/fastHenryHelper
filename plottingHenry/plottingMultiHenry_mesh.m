clear all
close all
clc

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


READ_FOLDER = ['..', filesep 'results', filesep, 'mesh', filesep, 'CoilA', filesep];
SWEEP_FOLDER = ['z23', filesep];


SAVE_IMG = false; % save figures in images folder
IMG_FOLDER = ['..', filesep 'results', filesep, 'mesh', filesep, '1',  filesep];
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

figure()
contourf(xaxis,yaxis,Mmesh*1e9)
xlabel("x [mm]")
ylabel("y [mm]")
zlabel("Mutual Inductance [nH]")



% calculate coupling factor (k)

L1Avg = mean(L1);
L2Avg = mean(L2);

kmesh = Mmesh / sqrt(L1Avg.*L2Avg);


L1Text = [num2str(L1Avg * 1e6, "%.02f"), "μH"];

figure()
mesh(xaxis,yaxis,kmesh)
##mesh(xaxis,yaxis,abs(kmesh))
xlabel("x [mm]")
ylabel("y [mm]")
zlabel("Coupling Factor [k]")


##
##
##
##
##%% Plotting
##
##% M
##figure()
##grid on
##hold on
##contourf(, M, PLOT_MARKER, 'DisplayName', ['M ', coil1NameText, L1Text], 'LineWidth', LINE_WIDTH)
##legend('FontSize',11, 'Interpreter', 'none')
##% xlim([sweepVar(1), sweepVar(end)])
##xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
##ylabel("Inductance [H]")
##title(['Mutual Inductance Swept Over ', sweepAxis, "-axis\n", constCoords, coil2NameText], 'Interpreter', 'none')
##
##
##% K
##figure()
##grid on
##hold on
##plot(sweepVar, k, PLOT_MARKER, 'DisplayName', ['k ', coil1NameText, L1Text], 'LineWidth', LINE_WIDTH)
##legend('FontSize',11, 'Interpreter', 'none')
##% xlim([sweepVar(1), sweepVar(end)])
##xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
##ylabel("Coupling Factor []")
##title(['Coupling Factor (k) Swept Over ', sweepAxis, "-axis\n", constCoords, coil2NameText], 'Interpreter', 'none')
##
##
##endfor
##
##
##
##
##
##%% save figures?
##if (SAVE_IMG)
##  saveImages(IMG_FOLDER);
##endif
