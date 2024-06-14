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
READ_FOLDER = ['..', filesep 'results', filesep];
##COIL1_FOLDER = ['C1_T5_ID40_S1_W0.4', filesep;
##                'C1_T7_ID25_S1.9_W0.4', filesep;
##                'C1_T9_ID10_S2.4_W0.4', filesep;
##                'C1_T10_ID5_S2.4_W0.4', filesep];
##LEGEND_EXT = ["Coil A (ID40, "; "Coil B (ID25 "; "Coil C (ID10, "; "Coil D (ID5, "];
##                'C1_T9_ID40_S0.6_W0.4', filesep;
##                'C1_T16_ID10_S1.3_W0.4', filesep];
##COIL1_FOLDER = ['C1_T20_ID20_S0.8_W0.2', filesep;
##                'C1_T40_ID19_S0.4_W0.2', filesep];
##LEGEND_EXT = ["L_{T20}";"L_{T40}"];
##COIL1_FOLDER = ['C1_T3_ID15_S8_W5', filesep;
##                'C1_T3_ID32_S4_W0.2', filesep;
##                'C1_T3_ID32_S4_W2', filesep;
##                'C1_T3_ID45_S1_W0.2', filesep];
##COIL1_FOLDER = ['C1_T10_ID5_S2.4_W0.4', filesep;
##                'C1_T10_ID10_S2.2_W1.4', filesep;
##                'C1_T10_ID21_S1.6_W0.8', filesep;
##                'C1_T10_ID32_S1_W0.2', filesep;
##                'C1_T10_ID40_S0.4_W0.2', filesep];
##COIL1_FOLDER = ['C1_T17_ID30_S0.6_W0.2', filesep;
##                'C1_T20_ID20_S0.8_W0.2', filesep];
##COIL1_FOLDER = ["C1_T10_ID40_S0.5_W0.4", filesep;
##                "C1_T10_ID25_S1.35_W0.4", filesep;
##                "C1_T10_ID10_S2.2_W0.4", filesep];
##LEGEND_EXT = ["T_{10} (ID40, "; "T_{10} (ID25, ";"T_{10} (ID10, "];
##COIL1_FOLDER = ["C1_T3_ID40_S2.2_W0.4", filesep;
##                "C1_T3_ID25_S5.6_W0.4", filesep;
##                "C1_T3_ID10_S9_W0.4", filesep];
##LEGEND_EXT = ["T_{3} (ID40, "; "T_{3} (ID25, ";"T_{3} (ID10, "];

COIL1_FOLDER = ["C1_T16_ID20_S1_W0.4", filesep;
                "C1_T8_ID20_S2_W0.4", filesep];

LEGEND_EXT = ["S_1, T_{16} (ID20, "; "S_2, T_{8} (ID20, "];


USE_LEGEND_EXT = true;

SHOW_C2 = false;
SIMPLE_XAXIS = true;

COIL2_FOLDER = ['C2_T20_ID0.2_S0.1_W0.03', filesep]
PLOT_L = false;
SAVE_IMG = true; % save figures in images folder
IMG_FOLDER = ['..', filesep 'results', filesep, 'report-images', filesep, '4',  filesep];
PLOT_MARKER = '-'; % global plot marker for this script
LINE_WIDTH = 1.5;
% < END OF user defined

function sweepType = determineSweepType(sweepX, sweepY, sweepZ)
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
endfunction



for iCoils = 1:size(COIL1_FOLDER, 1)
  coil1Name = strtrim(COIL1_FOLDER(iCoils,:));
  folderName = [READ_FOLDER, coil1Name, COIL2_FOLDER]
  coil1NameText = ["[", coil1Name(1:end-1), "] "];
  coil2NameText = [" [", COIL2_FOLDER(1:end-1), "]"];


  for i = 1:5
    figNumStart = 4*(i-1) + 1 % one for each of 5 sweeps
    %% Read csv file
    csvFileName = ['Sweep', num2str(i), '_inductances.csv'];
    data = csvread([folderName, csvFileName]);
    sweepX = data(:,2); % requires comma separated folder name: ".../Offset,x,y/"
    sweepY = data(:,3);
    sweepZ = data(:,4);
    L1 = data(:,6);
    L2 = data(:,7);
    M = data(:,8);


    % calculate coupling factor (k)
    k = abs(M ./ sqrt(L1.*L2));

    L1Avg = mean(L1);
    L1Text = [num2str(L1Avg * 1e6, "%.02f"), "μH"];

    sweepType = determineSweepType(sweepX, sweepY, sweepZ); % run sweep check fn

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
    if (PLOT_L)
      figure(figNumStart)
      grid on
      hold on
      plot(sweepVar, L1, PLOT_MARKER, 'DisplayName', ['L1 ', constCoords])
      legend()#'FontSize',11)
      % xlim([sweepVar(1), sweepVar(end)])
      xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
      ylabel("Inductance [H]")
      title(['L1 (reader) Swept Over ', sweepAxis, '-axis', coilNameText], 'Interpreter', 'none')
    else
      disp(["avg L1: ", num2str(L1Avg)])
    endif

    % L2
    if (PLOT_L)
      figure(figNumStart + 1)
      grid on
      hold on
      plot(sweepVar, L2, PLOT_MARKER, 'DisplayName', ['L2 ', constCoords])
      legend()#'FontSize',11)
      % xlim([sweepVar(1), sweepVar(end)])
      xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
      ylabel("Inductance [H]")
      title(['L2 (tag) Swept Over ', sweepAxis, '-axis', coilNameText], 'Interpreter', 'none')
    else
      disp(["avg L2: ", num2str(mean(L2))])
    endif

    % M
    figure(figNumStart + 2)
    grid on
    hold on
    if (USE_LEGEND_EXT)
##      plot(sweepVar, M/1e-9, PLOT_MARKER, 'DisplayName', ['M ', LEGEND_EXT(iCoils,:), ' (', L1Text, ')'], 'LineWidth', LINE_WIDTH)
      plot(sweepVar, M/1e-9, PLOT_MARKER, 'DisplayName', ['M ', LEGEND_EXT(iCoils,:), L1Text, ')'], 'LineWidth', LINE_WIDTH)
    else
      plot(sweepVar, M/1e-9, PLOT_MARKER, 'DisplayName', ['M ', coil1NameText, L1Text], 'LineWidth', LINE_WIDTH)
    endif
    legend()
##    legend('Interpreter', 'none') #'FontSize',11,
    % xlim([sweepVar(1), sweepVar(end)])
    if (SIMPLE_XAXIS)
      xlabel([, sweepAxis, " [mm]"])
    else
      xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
    endif
    ylabel("Inductance [nH]")
##    ylim([-20 40])
    if (SHOW_C2)
      title(['Mutual Inductance Swept Over ', sweepAxis, "-axis\n", constCoords, coil2NameText], 'Interpreter', 'none')
    else
      title(['Mutual Inductance Swept Over ', sweepAxis, "-axis\n", constCoords], 'Interpreter', 'none')
    endif

    if (sweepAxis == "z")
      disp(["Max M (z sweep): ", num2str(max(M))])
    endif


    % K
    figure(figNumStart + 3)
    grid on
    hold on
    if (USE_LEGEND_EXT)
##      plot(sweepVar, k, PLOT_MARKER, 'DisplayName', ['k ', LEGEND_EXT(iCoils,:), ' (', L1Text, ')'], 'LineWidth', LINE_WIDTH)
      plot(sweepVar, k, PLOT_MARKER, 'DisplayName', ['k ', LEGEND_EXT(iCoils,:), L1Text, ')'], 'LineWidth', LINE_WIDTH)
    else
      plot(sweepVar, k, PLOT_MARKER, 'DisplayName', ['k ', coil1NameText, L1Text], 'LineWidth', LINE_WIDTH)
    endif
    legend()
##    legend('Interpreter', 'none') #'FontSize',11,
    % xlim([sweepVar(1), sweepVar(end)])
    if (SIMPLE_XAXIS)
      xlabel([, sweepAxis, " [mm]"])
    else
      xlabel(["Sweep over ", sweepAxis, "-axis [mm]"])
    endif
    ylabel("Coupling Factor []")
##    ylim([0 0.0305])
    if (SHOW_C2)
      title(['Coupling Factor Swept Over ', sweepAxis, "-axis\n", constCoords, coil2NameText], 'Interpreter', 'none')
    else
      title(['Coupling Factor Swept Over ', sweepAxis, "-axis\n", constCoords], 'Interpreter', 'none')
    endif

    if (sweepAxis == "z")
      disp(["Max K (z sweep): ", num2str(max(k))])
    endif
  endfor

endfor




%% save figures?
if (SAVE_IMG)
  saveImages(IMG_FOLDER);
endif
